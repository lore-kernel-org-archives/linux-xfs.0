Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Sep 2006 06:20:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k81DKDDW024104
	for <xfs@oss.sgi.com>; Fri, 1 Sep 2006 06:20:27 -0700
Date: Fri, 1 Sep 2006 23:19:13 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: vmsplice can't work well
Message-ID: <20060901131913.GG5737019@melbourne.sgi.com>
References: <44F4440F.1090300@gmail.com> <20060829140542.GN12257@kernel.dk> <44F5CC08.8010205@mnsu.edu> <20060830174815.GF7331@kernel.dk> <44F5D3C6.1010108@mnsu.edu> <20060831092440.GC5528@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060831092440.GC5528@kernel.dk>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: "Jeffrey E. Hundstad" <jeffrey.hundstad@mnsu.edu>, xfs@oss.sgi.com, nathans@sgi.com

On Thu, Aug 31, 2006 at 11:24:41AM +0200, Jens Axboe wrote:
> XFS list,
> 
> On Wed, Aug 30 2006, Jeffrey E. Hundstad wrote:
> > Jens Axboe wrote:
> > >On Wed, Aug 30 2006, Jeffrey E. Hundstad wrote:
> > >  
> > >>I tried your splie-git...tar.gz file and tried the splice-cp.  It 
> > >>produced files that are the right length... but the files only contain 
> > >>nulls.  Here's the straces:
> > >>    
> > >
> > >Works for me as well. Could be an fs issue, how large was the README and
> > >what filesystem did you use?
> > >
> > >  
> > The file was 1130 bytes (it was the README in that directory.)  The 
> > filesystem is XFS.
> > 
> 
> I can reproduce this quite easily, doing:
> 
> nelson:~ # splice-cp sda.blktrace.0 foo
> 
> nelson:~ # md5sum sda.blktrace.0 foo
> 4754070ae77091468c830ea23b125d68  sda.blktrace.0
> efdc7b9d00692fdfe91a691277209267  foo

Busted write side - splice-in works fine, splice-out is an alias
for /dev/zero. The reason it's full of NULLs:

death:/mnt# xfs_bmap -vv foo
foo: no extents
death:/mnt#

It's a hole.  Nothing has been flushed out to disk.

Interesting - the inode is leaving pipe_to_file() dirty, the page is
dirty, the buffer head is dirty, delay, mapped and uptodate. The
page is the only page in the radix tree and the radix tree is marked
dirty.

But it never gets flushed out. Even when I use dd to seek past the
first disk block and write further into the file, I still end up
with a hole in the range where the original splice write should
be which means it was no longer in the page cache.

Copying a large file I can see dirty memory increase to tens of
megabytes.  Nothing is going to disk, writeback is not going above
zero.  Interestingly, when the write completes, the size of the page
cache drops by almost exactly the size of the file being written -
almost like a truncate_inode_pages() is occuring on file close.

Oh, look - we _are_ tossing away all the pages on close.

xfs_splice_write() hasn't updated the xfs inode size when extending the
file. The linux inode  has the correct value, but xfs thinks that it's
only got a speculative allocation EOF (i.e. 0) so we invalidate it
before it gets to disk.

The patch below just copies some code out of xfs_write() where it updates
the xfs inode size and drops it in xfs_splice_write(). It's almost certainly not
the right fix, but the bucket under the pipe will now catch most of the
bits....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/linux-2.6/xfs_lrw.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_lrw.c	2006-08-31 16:17:47.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c	2006-09-01 22:48:56.463190730 +1000
@@ -390,6 +390,8 @@ xfs_splice_write(
 	xfs_inode_t		*ip = XFS_BHVTOI(bdp);
 	xfs_mount_t		*mp = ip->i_mount;
 	ssize_t			ret;
+	struct inode		*inode = outfilp->f_mapping->host;
+	xfs_fsize_t		isize;
 
 	XFS_STATS_INC(xs_write_calls);
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
@@ -416,6 +418,20 @@ xfs_splice_write(
 	if (ret > 0)
 		XFS_STATS_ADD(xs_write_bytes, ret);
 
+	isize = i_size_read(inode);
+	if (unlikely(ret < 0 && ret != -EFAULT && *ppos > isize))
+		*ppos = isize;
+
+	if (*ppos > ip->i_d.di_size) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		if (*ppos > ip->i_d.di_size) {
+			ip->i_d.di_size = *ppos;
+			i_size_write(inode, *ppos);
+			ip->i_update_core = 1;
+			ip->i_update_size = 1;
+		}
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	return ret;
 }
