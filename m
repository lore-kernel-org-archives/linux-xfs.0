Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF9BC433E4
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25FC320759
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgEUCfu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 22:35:50 -0400
Received: from sandeen.net ([63.231.237.45]:41444 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgEUCft (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 22:35:49 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id BFD66323C1A; Wed, 20 May 2020 21:35:19 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] xfs: always return -ENOSPC on project quota reservation failure
Date:   Wed, 20 May 2020 21:35:13 -0500
Message-Id: <1590028518-6043-3-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
References: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS project quota treats project hierarchies as "mini filesysems" and
so rather than -EDQUOT, the intent is to return -ENOSPC when a quota
reservation fails, but this behavior is not consistent.

The only place we make a decision between -EDQUOT and -ENOSPC
returns based on quota type is in xfs_trans_dqresv().

This behavior is currently controlled by whether or not the
XFS_QMOPT_ENOSPC flag gets passed into the quota reservation.  However,
its use is not consistent; paths such as xfs_create() and xfs_symlink()
don't set the flag, so a reservation failure will return -EDQUOT for
project quota reservation failures rather than -ENOSPC for these sorts
of operations, even for project quota:

# mkdir mnt/project
# xfs_quota -x -c "project -s -p mnt/project 42" mnt
# xfs_quota -x -c 'limit -p isoft=2 ihard=3 42' mnt
# touch mnt/project/file{1,2,3}
touch: cannot touch ‘mnt/project/file3’: Disk quota exceeded

We can make this consistent by not requiring the flag to be set at the
top of the callchain; instead we can simply test whether we are
reserving a project quota with XFS_QM_ISPDQ in xfs_trans_dqresv and if
so, return -ENOSPC for that failure.  This removes the need for the
XFS_QMOPT_ENOSPC altogether and simplifies the code a fair bit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |  1 -
 fs/xfs/xfs_qm.c                |  9 +++------
 fs/xfs/xfs_trans_dquot.c       | 16 +++++-----------
 3 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index b2113b1..56d9dd7 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -100,7 +100,6 @@
 #define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
 #define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
 #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
-#define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
 
 /*
  * flags to xfs_trans_mod_dquot to indicate which field needs to be
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index fc93f88..27a9076 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1808,7 +1808,7 @@ struct xfs_dquot *
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	uint64_t		delblks;
-	unsigned int		blkflags, prjflags = 0;
+	unsigned int		blkflags;
 	struct xfs_dquot	*udq_unres = NULL;
 	struct xfs_dquot	*gdq_unres = NULL;
 	struct xfs_dquot	*pdq_unres = NULL;
@@ -1849,7 +1849,6 @@ struct xfs_dquot *
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
 	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
-		prjflags = XFS_QMOPT_ENOSPC;
 		pdq_delblks = pdqp;
 		if (delblks) {
 			ASSERT(ip->i_pdquot);
@@ -1859,8 +1858,7 @@ struct xfs_dquot *
 
 	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
 				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1,
-				flags | blkflags | prjflags);
+				ip->i_d.di_nblocks, 1, flags | blkflags);
 	if (error)
 		return error;
 
@@ -1878,8 +1876,7 @@ struct xfs_dquot *
 		ASSERT(udq_unres || gdq_unres || pdq_unres);
 		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
 			    udq_delblks, gdq_delblks, pdq_delblks,
-			    (xfs_qcnt_t)delblks, 0,
-			    flags | blkflags | prjflags);
+			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
 		if (error)
 			return error;
 		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 2c3557a..2c07897 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -711,7 +711,7 @@
 
 error_return:
 	xfs_dqunlock(dqp);
-	if (flags & XFS_QMOPT_ENOSPC)
+	if (XFS_QM_ISPDQ(dqp))
 		return -ENOSPC;
 	return -EDQUOT;
 }
@@ -751,15 +751,13 @@
 	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
 
 	if (udqp) {
-		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos,
-					(flags & ~XFS_QMOPT_ENOSPC));
+		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos, flags);
 		if (error)
 			return error;
 	}
 
 	if (gdqp) {
-		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos,
-					(flags & ~XFS_QMOPT_ENOSPC));
+		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
 		if (error)
 			goto unwind_usr;
 	}
@@ -804,16 +802,12 @@
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
-	if (XFS_IS_PQUOTA_ON(mp))
-		flags |= XFS_QMOPT_ENOSPC;
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
-				XFS_TRANS_DQ_RES_RTBLKS ||
-	       (flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
-				XFS_TRANS_DQ_RES_BLKS);
+	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_RTBLKS ||
+	       (flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_BLKS);
 
 	/*
 	 * Reserve nblks against these dquots, with trans as the mediator.
-- 
1.8.3.1

