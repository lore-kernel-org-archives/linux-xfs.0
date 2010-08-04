Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o74EGxOa036181 for <xfs@oss.sgi.com>; Wed, 4 Aug 2010 09:16:59 -0500
Received: from CF--AMER002E--3.americas.sgi.com
	(cf--amer002e--3.americas.sgi.com [137.38.100.6])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3EFD1AC002
	for <xfs@oss.sgi.com>; Wed,  4 Aug 2010 07:17:17 -0700 (PDT)
Subject: [PATCH v3] xfs: ensure f_ffree returned by statfs() is non-negative
From: Stuart Brodsky <sbrodsky@sgi.com>
Date: Wed, 04 Aug 2010 09:15:59 -0500
Message-ID: <1280931359.12084.2519.camel@superior.americas.sgi.com>
Mime-Version: 1.0
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
To: xfs@oss.sgi.com

Because of delayed updates to sb_icount field in the super block, it
is possible to allocate over maxicount number of inodes.  This
causes the arithmetic to calculate a negative number of free inodes
in user commands like df or stat -f.

Since maxicount is a somewhat arbitrary number, a slight over
allocation is not critical but user commands should be displayed as
0 or greater and never go negative.  To do this the value in the
stats buffer f_ffree is capped to never go negative.

Signed-off-by: Stu Brodsky <sbrodsky@sgi.com>

--- a/fs/xfs/linux-2.6/xfs_super.c.orig 2010-07-20
06:06:19.269572013-0500
+++ b/fs/xfs/linux-2.6/xfs_super.c 2010-07-20 08:09:17.773570840 -0500
@@ -1226,6 +1226,7 @@
        struct xfs_inode        *ip = XFS_I(dentry->d_inode);
        __uint64_t              fakeinos, id;
        xfs_extlen_t            lsize;
+       __int64_t               ffree;
  
        statp->f_type = XFS_SB_MAGIC;
        statp->f_namelen = MAXNAMELEN - 1;
@@ -1249,7 +1250,9 @@
        statp->f_files = min_t(typeof(statp->f_files),
                                        statp->f_files,
                                        mp->m_maxicount);
-       statp->f_ffree = statp->f_files - (sbp->sb_icount -
sbp->sb_ifree);
+       ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
+       statp->f_ffree = (__u64) (ffree < 0 ? 0 : ffree);
+
        spin_unlock(&mp->m_sb_lock);

        if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
-- 
Stuart Brodsky
2750 Blue Water Road
Eagan, MN. 55121
651-683-7910
<sbrodsky@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
