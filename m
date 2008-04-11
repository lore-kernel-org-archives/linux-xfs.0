Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 19:31:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3B2VG40028934
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 19:31:20 -0700
Date: Fri, 11 Apr 2008 12:31:45 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: odd code in xfs_remove
Message-ID: <20080411023145.GK103491721@sgi.com>
References: <20080410185445.GA7521@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410185445.GA7521@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2008 at 08:54:45PM +0200, Christoph Hellwig wrote:
> unlike xfs_rmdir or xfs_rename xfs_remove always passes 0 instead of the
> reserved blocks to xfs_dir_removename which means the latter always
> operated in the ENOSPC mode.  This seems rather strange to me, so a
> second pair of eyes, especially on a tree with history back to day 0
> would be nice.

Originially, back in the days of dir1 (1994) when xfs_dir_removename()
was expanded to take a block count, only xfs_rename() passed a value
in (MAX_EXT_NEEDED). Both xfs_rmdir and xfs_remove passed zero.

Then some time later (pv 519072):

irix/kern/fs/xfs/xfs_vnodeops.c - 1.356
        - Add more vnode tracing points.  Remove some cruft from merge errors.
          Speed up xfs_remove by getting a real space reservation unless the fs
          is full, then reverting to a zero space reservation (bug 519072). 

The speed up was for dir v1, which doesn't exist on linux. Then in pv 653987:

irix/kern/fs/xfs/xfs_vnodeops.c - 1.395
        - In xfs_link, call xfs_dir_canenter before xfs_dir_createname if we
          have no space reservation.
          In xfs_rmdir, get a 0 space reservation if we can't get the real space
          reservation (as is done for xfs_remove).
          In xfs_symlink, properly account for resblks throughout so we don't 
          make it go negative to a xfs_bmapi call.

The key point here is that in rev 1.395, the variable resblks got passed
into xfs_dir_removename(), whilst in 1.356, it didn't. This was work
that preceeded dir v2, so was probably fixing bugs found as a result.

The remove name case with resblks = 0 avoids block allocation during
modification of the alloc btree to insert newly freed blocks at
ENOSPC; instead it just leaves the empty leaf block in place in the
directory.

Looks like no harm is done by this and it's a rarely hit corner
case, but it would appear that we should be passing in resblks in
remove if only to avoid a potential transaction reservation
overrun....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
