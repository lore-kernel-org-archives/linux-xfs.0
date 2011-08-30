Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U76khW119551 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 02:06:46 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14B01124DE3
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 00:06:45 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4epZnfkptGEU816R for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2011 00:06:45 -0700 (PDT)
Date: Tue, 30 Aug 2011 17:06:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS metadata flushing design - current and future
Message-ID: <20110830070641.GR3162@dastard>
References: <20110827080321.GA16661@infradead.org>
	<20110829010149.GE3162@dastard>
	<20110829123318.GA12928@infradead.org>
	<20110830012820.GI3162@dastard>
	<20110830050959.GA8667@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110830050959.GA8667@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Aug 30, 2011 at 01:09:59AM -0400, Christoph Hellwig wrote:
> On Tue, Aug 30, 2011 at 11:28:21AM +1000, Dave Chinner wrote:
> > > One really stupid thing we do in that area is that the xfs_iflush from
> > > xfs_inode_item_push puts the buffer at the end of the delwri list and
> > > expects it to be aged, just so that the first xfs_inode_item_pushbuf
> > > can promote it to the front of the list.  Now that we mostly write
> > > metadata from AIL pushing
> > 
> > Actually, when we have lots of data to be written, we still call
> > xfs_iflush() a lot from .write_inode. That's where the delayed write
> > buffer aging has significant benefit.
> 
> One thing we could try is to log the inode there even for non-blocking
> write_inode calls to unifty the code path.  But I suspect simply waiting
> for 3.3 and making future progress based on the removal of ->write_inode
> is going to to save us a lot of work and deal with different behaviour.

*nod*

> > [ IOWs, the xfs_inode_item_push() simply locks the inode and returns
> 
>               xfs_inode_item_trylock?

yeah, sorry, got it mixed up.

> > PUSHBUF if it needs flushing, then xfs_inode_item_pushbuf() calls
> > xfs_iflush() and gets the dirty buffer back, which it then adds the
> > buffer to a local dispatch list rather than submitting IO directly. ]
> 
> Why not keep using _push for this?

Because if we are returning a buffer, then it makes sense to use
pushbuf and change the prototype for that operation and leave
IOP_PUSH completely unchanged...

> > FWIW, what this discussion is indicating to me is that we should
> > timestamp entries in the AIL so we can push it to a time threshold
> > as well as a LSN threshold.
> > 
> > That is, whenever we insert a new entry into the AIL, we not only
> > update the LSN and position, we also update the insert time of the
> > buffer. We can then update the time based threshold every few
> > seconds and have the AIL wq walker walk until the time threshold is
> > reached pushing items to disk. This would also make the xfssyncd
> > "push the entire AIL" change to "push anything older than 30s" which
> > is much more desirable from a sustained workload POV.
> 
> Sounds reasonable.  Except that we need to do the timestamp on the log
> item and not the buffer given that we might often not even have a
> buffer at AIL insertation time.

yeah, that's what i intended that to mean, sorry if it wasn't clear.

> > If we then modify the way all buffers are treated such that
> > the AIL is the "delayed write list" (i.e. we take a reference count
> > to the buffer when it is first logged and not in the AIL) and the
> > pushbuf operations simply add the buffer to the local dispatch list,
> > we can get rid of the delwri buffer list altogether. That also gets
> > rid of the xfsbufd, too, as the AIL handles the aging, reference
> > counting and writeback of the buffers entirely....
> 
> That would be nice.  We'll need some ways to deal with the delwri
> buffers from quotacheck and log recovery if we do this, but we could
> just revert to the good old async buffers if we want to keep things
> simple.  Alternatively we could keep local buffer submission lists
> in quotacheck and pass2 of log recovery, similar to what you suggested
> for the AIL worked.
> 
> We could also check if we can get away with not needing lists managed
> by us at all and rely on the on-stack plugging, which I'm about to move
> up from the request layer to the bio layer and thus making generally
> useful.

The advantage of using our own list is that we can still then sort
them (might be thousands of buffers we queue in a single pass)
before submitting them for IO.  The on-stack plugging doesn't allow
this at all, IIUC, as itis really just a FIFO list above the IO
scheduler queues....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
