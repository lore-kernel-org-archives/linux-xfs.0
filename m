Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p953tkPd083599 for <xfs@oss.sgi.com>; Tue, 4 Oct 2011 22:55:46 -0500
Subject: Re: [PATCH] xfs: fix buffer flushing during unmount
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110928163437.GA1530@infradead.org>
References: <20110914140826.GA25729@infradead.org>
	<1316453600.2941.37.camel@doink> <20110928163437.GA1530@infradead.org>
Date: Tue, 4 Oct 2011 22:55:42 -0500
Message-ID: <1317786942.2270.8.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-09-28 at 12:34 -0400, Christoph Hellwig wrote:
> On Mon, Sep 19, 2011 at 12:33:20PM -0500, Alex Elder wrote:
> > On Wed, 2011-09-14 at 10:08 -0400, Christoph Hellwig wrote:
> > > The code to flush buffers in the umount code is a bit iffy: we first flush
> > > all delwri buffers out, but then might be able to queue up a new one when
> > > logging the sb counts.  On a normal shutdown that one would get flushed
> > > out when doing the synchronous superblock write in xfs_unmountfs_writesb,
> > > but we skip that one if the filesystem has been shut down.
> > > 
> > > Fix this by moving the delwri list flushing until just before unmounting
> > > the log, and while we're at it also remove the superflous delwri list
> > > and buffer lru flusing for the rt and log device that can never have
> > > cached or delwri buffers.
> > 
> > What prevents blocks on a realtime device from being cached?
> 
> Note that cached here means using buffers that end up in the rbtree
> and/or on the lru.  We simply never do that for the rt and log device,
> as that would mean complicating the code for no reason - the only
> time we ever use buffer on the rt device is for the size check during
> mount and the _uncached variant where we free the buffer after the
> refcount hits zero is just fine for that, and xfs_zero_remaining_bytes,
> which actually operates on a regular file and thus must not use the
> rbtree or the lru (and should eventually stop using buffer routines at
> all).  All actual metadata which the buffer cache is used for resides
> on the main device. Log buffers stay alive from mount to unmount so
> we're fine with that interface as well.

And now that you've said that I see that there are in fact
no calls to xfs_buf_get() that specify anything other than
the data device.

> > 
> > I haven't looked exhaustively, but it looks like the summary
> > and bitmap data are operated on without caching, but the
> > realtime data itself is treated no different from "normal"
> > data blocks.
> 
> The buffer cache is never used for actual file data.

OK, I get it.  Your original patch looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
