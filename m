Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ACE817F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 18:16:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 918B3304039
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 16:15:57 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CCCqsCsXYsuKL5tK for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 16:15:56 -0800 (PST)
Message-ID: <530BE0BA.6070202@sandeen.net>
Date: Mon, 24 Feb 2014 18:15:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V3] xfs: be honest about used inodes in statfs
References: <53067DC0.9040800@redhat.com>
In-Reply-To: <53067DC0.9040800@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Because we have lazy counters, it's possible that we over-allocate
inodes past the maxicount (imaxpct) limit.  

A previous commit,

 2fe3366 xfs: ensure f_ffree returned by statfs() is non-negative

stopped statfs from underflowing f_ffree in this case, but that
only happened when we mis-reported f_files, capped at maxicount.

Change statfs to report the actual number of inodes allocated,
even if it is greater than maxicount.  It's reality.
Deal with it.  

Also rework code & rename vars for clarity after input from
dchinner & bfoster.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: code cleanup thanks to Brian
V3: more cleanup thanks to Dave

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f317488..2f80923 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1081,9 +1081,8 @@ xfs_fs_statfs(
 	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
 	xfs_sb_t		*sbp = &mp->m_sb;
 	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
-	__uint64_t		fakeinos, id;
+	__uint64_t		potential, id;
 	xfs_extlen_t		lsize;
-	__int64_t		ffree;
 
 	statp->f_type = XFS_SB_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
@@ -1100,17 +1099,17 @@ xfs_fs_statfs(
 	statp->f_blocks = sbp->sb_dblocks - lsize;
 	statp->f_bfree = statp->f_bavail =
 				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
-	fakeinos = statp->f_bfree << sbp->sb_inopblog;
-	statp->f_files =
-	    MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
-	if (mp->m_maxicount)
-		statp->f_files = min_t(typeof(statp->f_files),
-					statp->f_files,
-					mp->m_maxicount);
-
-	/* make sure statp->f_ffree does not underflow */
-	ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
-	statp->f_ffree = max_t(__int64_t, ffree, 0);
+
+	/* Potential new inodes in free blocks, limited by maxicount */
+	potential = statp->f_bfree << sbp->sb_inopblog;
+	if (mp->m_maxicount > sbp->sb_icount)
+		potential = min(mp->m_maxicount - sbp->sb_icount, potential);
+	else
+		potential = 0;
+
+	/* Total possible files is current inodes + potential new inodes */
+	statp->f_files = min_t(u64, sbp->sb_icount + potential, XFS_MAXINUMBER);
+	statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
 
 	spin_unlock(&mp->m_sb_lock);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
