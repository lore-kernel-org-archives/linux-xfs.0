Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 16:54:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5INsXdo027702
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 16:54:36 -0700
Date: Tue, 19 Jun 2007 09:54:28 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: fix test 004 to account for reserved space
Message-ID: <20070618235428.GD86004887@sgi.com>
References: <20070604063328.GT85884050@sgi.com> <20070616195508.GB6929@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070616195508.GB6929@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>, asg-qa <asg-qa@melbourne.sgi.com>

On Sat, Jun 16, 2007 at 08:55:08PM +0100, Christoph Hellwig wrote:
> On Mon, Jun 04, 2007 at 04:33:28PM +1000, David Chinner wrote:
> > With the changes to use some space by default in only in memory
> > as a reserved pool, df and statfs will now output a fre block
> > count that is slightly different to  what is held in the superblock.
> > 
> > Update the qa test to account for this change.
> 
> I think we should rather subtract the amount of internally reserved blocks
> from the return value in xfs_statvfs.

Which return value?

With this patch:


---
 fs/xfs/xfs_vfsops.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-06-08 21:46:29.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-06-12 13:08:49.933837815 +1000
@@ -876,6 +876,7 @@ xfs_statvfs(
 	statp->f_blocks = sbp->sb_dblocks - lsize;
 	statp->f_bfree = statp->f_bavail =
 				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+	statp->f_bfree += mp->m_resblks_avail;
 	fakeinos = statp->f_bfree << sbp->sb_inopblog;
 #if XFS_BIG_INUMS
 	fakeinos += mp->m_inoadd;


An strace of df --block-size=4k gives:

statfs("/mnt/test", {f_type=0x58465342, f_bsize=4096, f_blocks=1048616, f_bfree=874158, f_bavail=873134, f_files=4204672, f_ffree=4191008, f_fsid={2072, 0}, f_namelen=255, f_frsize=4096}) = 0
write(1, "/dev/sdb8              1048616  "..., 66/dev/sdb8              1048616    174458    873134  17% /mnt/test
) = 66
statfs("/mnt/scratch", {f_type=0x58465342, f_bsize=4096, f_blocks=1248496, f_bfree=1248392, f_bavail=1247368, f_files=5004224, f_ffree=5004220, f_fsid={2073, 0}, f_namelen=255, f_frsize=4096}) = 0
write(1, "/dev/sdb9              1248496  "..., 69/dev/sdb9              1248496       104   1247368   1% /mnt/scratch

Is this what you were thinking of?

Note that this still requires the fix to the qa test because
the value in the on disk superblock matches f_bfree, not f_bavail
and df appears to output f_bavail....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
