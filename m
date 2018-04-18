Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48912 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753144AbeDRCjm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:39:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2aFZ8167649
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:42 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2hdrxn8jhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:42 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2dfGd011357
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:41 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3I2df1x026280
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:39:41 GMT
Subject: [PATCH 02/11] xfs: create the XFS_QMOPT_QUOTIP_LOCKED flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:39:39 -0700
Message-ID: <152401917977.11465.9543981144688523511.stgit@magnolia>
In-Reply-To: <152401916729.11465.4212188839231900136.stgit@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new QMOPT flag to signal that we've already locked the quota
inode.  This will be used by the quota scrub code refactoring to avoid
dropping the quota ip lock during scrub.  The flag is incompatible with
the DQALLOC flag because dquot allocation creates a transaction, and we
shouldn't be doing that with the ILOCK held.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |    2 ++
 fs/xfs/xfs_dquot.c             |   32 ++++++++++++++++++++------------
 2 files changed, 22 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index bb1b13a..cfc9938 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -107,6 +107,8 @@ typedef uint16_t	xfs_qwarncnt_t;
  * to a single function. None of these XFS_QMOPT_* flags are meant to have
  * persistent values (ie. their values can and will change between versions)
  */
+/* Quota ip already locked.  Cannot be used with DQALLOC. */
+#define XFS_QMOPT_QUOTIP_LOCKED	0x0000001
 #define XFS_QMOPT_DQALLOC	0x0000002 /* alloc dquot ondisk if needed */
 #define XFS_QMOPT_UQUOTA	0x0000004 /* user dquot requested */
 #define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a7daef9..ed2e37c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -417,18 +417,20 @@ xfs_qm_dqtobp(
 	struct xfs_mount	*mp = dqp->q_mount;
 	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
 	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
-	uint			lock_mode;
+	uint			lock_mode = 0;
 
 	quotip = xfs_quota_inode(dqp->q_mount, dqp->dq_flags);
 	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
 
-	lock_mode = xfs_ilock_data_map_shared(quotip);
+	if (!(flags & XFS_QMOPT_QUOTIP_LOCKED))
+		lock_mode = xfs_ilock_data_map_shared(quotip);
 	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
 		/*
 		 * Return if this type of quotas is turned off while we
 		 * didn't have the quota inode lock.
 		 */
-		xfs_iunlock(quotip, lock_mode);
+		if (lock_mode)
+			xfs_iunlock(quotip, lock_mode);
 		return -ESRCH;
 	}
 
@@ -438,7 +440,8 @@ xfs_qm_dqtobp(
 	error = xfs_bmapi_read(quotip, dqp->q_fileoffset,
 			       XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
 
-	xfs_iunlock(quotip, lock_mode);
+	if (lock_mode)
+		xfs_iunlock(quotip, lock_mode);
 	if (error)
 		return error;
 
@@ -458,7 +461,7 @@ xfs_qm_dqtobp(
 		 */
 		if (!(flags & XFS_QMOPT_DQALLOC))
 			return -ENOENT;
-
+		ASSERT(!(flags & XFS_QMOPT_QUOTIP_LOCKED));
 		ASSERT(tp);
 		error = xfs_qm_dqalloc(tpp, mp, dqp, quotip,
 					dqp->q_fileoffset, &bp);
@@ -553,6 +556,7 @@ xfs_qm_dqread(
 	trace_xfs_dqread(dqp);
 
 	if (flags & XFS_QMOPT_DQALLOC) {
+		ASSERT(!(flags & XFS_QMOPT_QUOTIP_LOCKED));
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
 				XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
 		if (error)
@@ -634,11 +638,12 @@ static int
 xfs_dq_get_next_id(
 	struct xfs_mount	*mp,
 	uint			type,
-	xfs_dqid_t		*id)
+	xfs_dqid_t		*id,
+	uint			flags)
 {
 	struct xfs_inode	*quotip = xfs_quota_inode(mp, type);
 	xfs_dqid_t		next_id = *id + 1; /* simple advance */
-	uint			lock_flags;
+	uint			lock_flags = 0;
 	struct xfs_bmbt_irec	got;
 	struct xfs_iext_cursor	cur;
 	xfs_fsblock_t		start;
@@ -657,7 +662,8 @@ xfs_dq_get_next_id(
 	/* Nope, next_id is now past the current chunk, so find the next one */
 	start = (xfs_fsblock_t)next_id / mp->m_quotainfo->qi_dqperchunk;
 
-	lock_flags = xfs_ilock_data_map_shared(quotip);
+	if (!(flags & XFS_QMOPT_QUOTIP_LOCKED))
+		lock_flags = xfs_ilock_data_map_shared(quotip);
 	if (!(quotip->i_df.if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(NULL, quotip, XFS_DATA_FORK);
 		if (error)
@@ -673,7 +679,8 @@ xfs_dq_get_next_id(
 		error = -ENOENT;
 	}
 
-	xfs_iunlock(quotip, lock_flags);
+	if (lock_flags)
+		xfs_iunlock(quotip, lock_flags);
 
 	return error;
 }
@@ -733,7 +740,8 @@ xfs_qm_dqget(
 			if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
 				xfs_dqunlock(dqp);
 				mutex_unlock(&qi->qi_tree_lock);
-				error = xfs_dq_get_next_id(mp, type, &id);
+				error = xfs_dq_get_next_id(mp, type, &id,
+						flags);
 				if (error)
 					return error;
 				goto restart;
@@ -768,7 +776,7 @@ xfs_qm_dqget(
 
 	/* If we are asked to find next active id, keep looking */
 	if (error == -ENOENT && (flags & XFS_QMOPT_DQNEXT)) {
-		error = xfs_dq_get_next_id(mp, type, &id);
+		error = xfs_dq_get_next_id(mp, type, &id, flags);
 		if (!error)
 			goto restart;
 	}
@@ -827,7 +835,7 @@ xfs_qm_dqget(
 	if (flags & XFS_QMOPT_DQNEXT) {
 		if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
 			xfs_qm_dqput(dqp);
-			error = xfs_dq_get_next_id(mp, type, &id);
+			error = xfs_dq_get_next_id(mp, type, &id, flags);
 			if (error)
 				return error;
 			goto restart;

