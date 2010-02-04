Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14IDk9M081747 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 12:13:47 -0600
Date: Thu, 4 Feb 2010 12:15:29 -0600
From: bpm@sgi.com
Subject: Re: [RFC PATCH 0/4] wsync export option
Message-ID: <20100204181529.GK5702@sgi.com>
References: <20100203233755.17677.96582.stgit@case>
	<20100204153006.GC22014@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100204153006.GC22014@infradead.org>
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
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Feb 04, 2010 at 10:30:06AM -0500, Christoph Hellwig wrote:
> On Wed, Feb 03, 2010 at 05:44:24PM -0600, Ben Myers wrote:
> > The following series is adds a 'wsync' export option to nfsd.  It is intended
> > to be used on XFS with the wsync mount option.  When you already have a
> > synchronous log there is no need to sync metadata separately.
>
> You don't need the xfs wsync option, as the existing write_inode calls
> or your new fsync calls are doing the same as the wsync mount option,
> just from a higher layer.

Ok, I see that now.  write_inode_now is basically a superset of what we
need.  The important thing is to force the log (which
xfs_file_operations.xfs_file_fsync does do) but not to call
xfs_super_operations.write_inode (via write_inode_now) which eventually
gets into xfs_iflush and takes forever.  We can take forever later-- when
the log is full.  ;)

> The wsync option causes the log to be synchronously forced up to the
> log sequence number of the commit for the metadata operation, that is
> make all the operations affected by it synchronous.  That's exactly
> what we'll do using fsync (actually right now we force the whole log,
> but I have a patch to optimize it to only force nuntil the last commit
> lsn), and approqimately the same as we do using write_inode, just a
> lot less efficiently.

Rather than having X number of synchronous log transactions written
separately as with wsync you have X number of log transactions written
out together in one go by vfs_fsync (if datasync==0).  That should be
faster than wsync.
 
> > Curious to hear if this is a reasonable thing to do.  Suggestions
> > welcome.
> 
> I think it's reasonable.  What might be even better it to have an
> export operation call out into the filesystem so that we can force
> wsync and not let nfsd deal with it at all.  There is a fair chance
> that the filesystem can do the sync more efficiently.

Trond also suggested an export_operation and I think it's a good idea.
I'll explore that and repost.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
