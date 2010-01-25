Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0PF37Er060708 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 09:03:08 -0600
Date: Mon, 25 Jan 2010 10:04:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: nfs performance delta between filesystems
Message-ID: <20100125150410.GA25699@infradead.org>
References: <20100122185419.63ae6430@harpe.intellique.com>
	<20100122183848.GB28561@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100122183848.GB28561@sgi.com>
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
To: bpm@sgi.com
Cc: xfs@oss.sgi.com

On Fri, Jan 22, 2010 at 12:38:48PM -0600, bpm@sgi.com wrote:
> Hey Emmanuel,
> 
> I did some research on this in April last year on an old, old kernel.
> One of the codepaths I flagged:
> 
> nfsd_create
>   write_inode_now
>     __sync_single_inode
>       write_inode
>         xfs_fs_write_inode
> 	  xfs_inode_flush
> 	    xfs_iflush
> 
> There were small gains to be had by reordering the sync of the parent and
> child syncs where the two inodes were in the same cluster.  The larger
> problem seemed to be that we're not treating the log as stable storage.
> By calling write_inode_now we've written the changes to the log first
> and then gone and also written them out to the inode.  
> 
> nfsd_create, nfsd_link, and nfsd_setattr all do this (or do in the old
> kernel I'm looking at).  I have a patchset that changes
> this to an fsync so we force the log and call it good.  I'll be happy to
> dust it off if someone hasn't already addressed this situation.

Dave and I had had some discussion about this when going through his
inode writeback changes.  Changing to ->fsync might indeed be the
easiest option, but on the other hand I'm really trying to get rid of
the special case of ->fsync without a file argument in the VFS as it
complicates stackable filesystem layers and also creates a rather
annoying and under/un documented assumtion that filesystem that need
the file pointer can't be NFS exported.  One option if we want to
keep these semantics is to add a new export operation just for
synchronizations things in NFS.

But given that the current use case in NFS is to pair one write_inode
call with one actual VFS operation it might be better to just
automatically turn on the wsync mount option in XFS, we'd need a hook
from NFSD into the filesystem to implement this, but I've been looking
into adding this anyway to allow for checking other paramters like the
file handle size against filesystem limitations.  Any chance you
could run your tests against a wsync filesystem?

But all this affects metadata performance, and only for sync exports,
while the OP does a simple dd which is streaming data I/O and uses the
(extremly unsafe) async export operation that disables the write_inode
calls.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
