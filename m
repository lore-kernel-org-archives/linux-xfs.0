Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44382 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933354AbdKAVQq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 17:16:46 -0400
Date: Wed, 1 Nov 2017 14:16:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] xfs: account for per-AG reservation in statfs f_blocks
Message-ID: <20171101211642.GK4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Since the blocks reserved by the per-AG reservation mechanism are never
available to userspace, there's no point in reporting them via statfs.
Reduce the number of blocks reported by statfs so our space accounting
works the way it did in the old days -- f_blocks is the theoretical
upper bound on the amount of space that user programs could allocate,
and f_blocks is the current maximum.

This eliminates the regression where you format a 100T XFS and df
reports 2T are already "used".  Now it reports that you have a 98T
filesystem.

(Dave's thinp rfc might very well fix this whole problem; this is
purely a bandaid to shut down the complaints.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c |    3 +++
 fs/xfs/xfs_mount.h          |    1 +
 fs/xfs/xfs_super.c          |    2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 2291f42..1c23b9f 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -150,6 +150,7 @@ __xfs_ag_resv_free(
 	struct xfs_perag		*pag,
 	enum xfs_ag_resv_type		type)
 {
+	struct xfs_mount		*mp = pag->pag_mount;
 	struct xfs_ag_resv		*resv;
 	xfs_extlen_t			oldresv;
 	int				error;
@@ -167,6 +168,7 @@ __xfs_ag_resv_free(
 		oldresv = resv->ar_orig_reserved;
 	else
 		oldresv = resv->ar_reserved;
+	mp->m_ag_resv -= oldresv;
 	error = xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
 	resv->ar_reserved = 0;
 	resv->ar_asked = 0;
@@ -217,6 +219,7 @@ __xfs_ag_resv_init(
 				pag->pag_agno);
 		return error;
 	}
+	mp->m_ag_resv += reserved;
 
 	/*
 	 * Reduce the maximum per-AG allocation length by however much we're
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e0792d0..04ceefa 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -152,6 +152,7 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks;	/* total reserved blocks */
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
+	uint64_t		m_ag_resv;	/* per-ag reserved blocks */
 	int			m_dalign;	/* stripe unit */
 	int			m_swidth;	/* stripe width */
 	int			m_sinoalign;	/* stripe unit inode alignment */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f663022..5bfbf05 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1126,7 +1126,7 @@ xfs_fs_statfs(
 	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
 	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
-	statp->f_blocks = sbp->sb_dblocks - lsize;
+	statp->f_blocks = sbp->sb_dblocks - lsize - mp->m_ag_resv;
 	spin_unlock(&mp->m_sb_lock);
 
 	statp->f_bfree = fdblocks - mp->m_alloc_set_aside;
