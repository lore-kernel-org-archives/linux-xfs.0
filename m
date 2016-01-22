Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7409B7F4E
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 22:07:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 63ADA8F8033
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 20:07:29 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5ni2yE5dLzzcDmzj for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 20:07:27 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 7/7] xfs: wire up Q_XGETNEXTQUOTA / get_nextdqblk
Date: Thu, 21 Jan 2016 22:07:24 -0600
Message-Id: <1453435644-32261-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1453435644-32261-1-git-send-email-sandeen@redhat.com>
References: <1453435644-32261-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: jack@suse.cz

Add code to allow the Q_XGETNEXTQUOTA quotactl to quickly find
all active quotas by examining the quota inode, and skipping
over unallocated or uninitialized regions.

Userspace can then use this interface rather than i.e. a
getpwent() loop when asked to report all active quotas.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |    3 +-
 fs/xfs/xfs_dquot.c             |   96 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_qm.h                |    2 +-
 fs/xfs/xfs_qm_syscalls.c       |    6 ++-
 fs/xfs/xfs_quotaops.c          |   22 +++++++++-
 5 files changed, 124 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index f51078f..8eed512 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -37,7 +37,7 @@ typedef __uint16_t	xfs_qwarncnt_t;
 #define XFS_DQ_PROJ		0x0002		/* project quota */
 #define XFS_DQ_GROUP		0x0004		/* a group quota */
 #define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
-#define XFS_DQ_FREEING		0x0010		/* dquot is beeing torn down */
+#define XFS_DQ_FREEING		0x0010		/* dquot is being torn down */
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
@@ -116,6 +116,7 @@ typedef __uint16_t	xfs_qwarncnt_t;
 #define XFS_QMOPT_DQREPAIR	0x0001000 /* repair dquot if damaged */
 #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
 #define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
+#define XFS_QMOPT_DQNEXT	0x0008000 /* return next dquot >= this ID */
 
 /*
  * flags to xfs_trans_mod_dquot to indicate which field needs to be
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5dbde0d..3b93e94 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -686,6 +686,56 @@ error0:
 }
 
 /*
+ * Advance to the next id in the current chunk, or if at the
+ * end of the chunk, skip ahead to first id in next allocated chunk
+ * using the SEEK_DATA interface.
+ */
+int
+xfs_dq_get_next_id(
+	xfs_mount_t		*mp,
+	uint			type,
+	xfs_dqid_t		*id,
+	loff_t			eof)
+{
+	struct xfs_inode	*quotip;
+	xfs_fsblock_t		start;
+	loff_t			offset;
+	uint			lock;
+	xfs_dqid_t		next_id;
+	int			error = 0;
+
+	/* Simple advance */
+	next_id = *id + 1;
+
+	/* If new ID is within the current chunk, advancing it sufficed */
+	if (next_id % mp->m_quotainfo->qi_dqperchunk) {
+		*id = next_id;
+		return 0;
+	}
+
+	/* Nope, next_id is now past the current chunk, so find the next one */
+	start = (xfs_fsblock_t)next_id / mp->m_quotainfo->qi_dqperchunk;
+
+	quotip = xfs_quota_inode(mp, type);
+	lock = xfs_ilock_data_map_shared(quotip);
+
+	offset = __xfs_seek_hole_data(VFS_I(quotip), XFS_FSB_TO_B(mp, start),
+				      eof, SEEK_DATA);
+	if (offset < 0)
+		error = offset;
+
+	xfs_iunlock(quotip, lock);
+
+	/* -ENXIO is essentially "no more data" */
+	if (error)
+		return (error == -ENXIO ? -ESRCH : error);
+
+	/* Convert next data offset back to a quota id */
+	*id = XFS_B_TO_FSB(mp, offset) * mp->m_quotainfo->qi_dqperchunk;
+	return 0;
+}
+
+/*
  * Given the file system, inode OR id, and type (UDQUOT/GDQUOT), return a
  * a locked dquot, doing an allocation (if requested) as needed.
  * When both an inode and an id are given, the inode's id takes precedence.
@@ -705,6 +755,7 @@ xfs_qm_dqget(
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 	struct radix_tree_root *tree = xfs_dquot_tree(qi, type);
 	struct xfs_dquot	*dqp;
+	loff_t			eof = 0;
 	int			error;
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
@@ -732,6 +783,21 @@ xfs_qm_dqget(
 	}
 #endif
 
+	/* Get the end of the quota file if we need it */
+	if (flags & XFS_QMOPT_DQNEXT) {
+		struct xfs_inode	*quotip;
+		xfs_fileoff_t		last;
+		uint			lock_mode;
+
+		quotip = xfs_quota_inode(mp, type);
+		lock_mode = xfs_ilock_data_map_shared(quotip);
+		error = xfs_bmap_last_offset(quotip, &last, XFS_DATA_FORK);
+		xfs_iunlock(quotip, lock_mode);
+		if (error)
+			return error;
+		eof = XFS_FSB_TO_B(mp, last);
+	}
+
 restart:
 	mutex_lock(&qi->qi_tree_lock);
 	dqp = radix_tree_lookup(tree, id);
@@ -745,6 +811,18 @@ restart:
 			goto restart;
 		}
 
+		/* uninit / unused quota found in radix tree, keep looking  */
+		if (flags & XFS_QMOPT_DQNEXT) {
+			if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
+				xfs_dqunlock(dqp);
+				mutex_unlock(&qi->qi_tree_lock);
+				error = xfs_dq_get_next_id(mp, type, &id, eof);
+				if (error)
+					return error;
+				goto restart;
+			}
+		}
+
 		dqp->q_nrefs++;
 		mutex_unlock(&qi->qi_tree_lock);
 
@@ -771,6 +849,13 @@ restart:
 	if (ip)
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 
+	/* If we are asked to find next active id, keep looking */
+	if (error == -ENOENT && (flags & XFS_QMOPT_DQNEXT)) {
+		error = xfs_dq_get_next_id(mp, type, &id, eof);
+		if (!error)
+			goto restart;
+	}
+
 	if (error)
 		return error;
 
@@ -821,6 +906,17 @@ restart:
 	qi->qi_dquots++;
 	mutex_unlock(&qi->qi_tree_lock);
 
+	/* If we are asked to find next active id, keep looking */
+	if (flags & XFS_QMOPT_DQNEXT) {
+		if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
+			xfs_qm_dqput(dqp);
+			error = xfs_dq_get_next_id(mp, type, &id, eof);
+			if (error)
+				return error;
+			goto restart;
+		}
+	}
+
  dqret:
 	ASSERT((ip == NULL) || xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	trace_xfs_dqget_miss(dqp);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 8901a01..193a9c2 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -165,7 +165,7 @@ extern void		xfs_qm_dqrele_all_inodes(struct xfs_mount *, uint);
 /* quota ops */
 extern int		xfs_qm_scall_trunc_qfiles(struct xfs_mount *, uint);
 extern int		xfs_qm_scall_getquota(struct xfs_mount *, xfs_dqid_t,
-					uint, struct qc_dqblk *);
+					uint, struct qc_dqblk *, uint);
 extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
 					struct qc_dqblk *);
 extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 3640c6e..961420c 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -637,7 +637,8 @@ xfs_qm_scall_getquota(
 	struct xfs_mount	*mp,
 	xfs_dqid_t		id,
 	uint			type,
-	struct qc_dqblk		*dst)
+	struct qc_dqblk		*dst,
+	uint			dqget_flags)
 {
 	struct xfs_dquot	*dqp;
 	int			error;
@@ -647,7 +648,7 @@ xfs_qm_scall_getquota(
 	 * we aren't passing the XFS_QMOPT_DOALLOC flag. If it doesn't
 	 * exist, we'll get ENOENT back.
 	 */
-	error = xfs_qm_dqget(mp, NULL, id, type, 0, &dqp);
+	error = xfs_qm_dqget(mp, NULL, id, type, dqget_flags, &dqp);
 	if (error)
 		return error;
 
@@ -661,6 +662,7 @@ xfs_qm_scall_getquota(
 	}
 
 	memset(dst, 0, sizeof(*dst));
+	dst->d_id = be32_to_cpu(dqp->q_core.d_id);
 	dst->d_spc_hardlimit =
 		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_blk_hardlimit));
 	dst->d_spc_softlimit =
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 7795e0d..d576443 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -238,7 +238,26 @@ xfs_fs_get_dqblk(
 		return -ESRCH;
 
 	return xfs_qm_scall_getquota(mp, from_kqid(&init_user_ns, qid),
-				      xfs_quota_type(qid.type), qdq);
+				      xfs_quota_type(qid.type), qdq, 0);
+}
+
+/* Return quota info for active quota >= this qid */
+STATIC int
+xfs_fs_get_nextdqblk(
+	struct super_block	*sb,
+	struct kqid		qid,
+	struct qc_dqblk		*qdq)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+	if (!XFS_IS_QUOTA_ON(mp))
+		return -ESRCH;
+
+	return xfs_qm_scall_getquota(mp, from_kqid(&init_user_ns, qid),
+				     xfs_quota_type(qid.type), qdq,
+				     XFS_QMOPT_DQNEXT);
 }
 
 STATIC int
@@ -267,5 +286,6 @@ const struct quotactl_ops xfs_quotactl_operations = {
 	.quota_disable		= xfs_quota_disable,
 	.rm_xquota		= xfs_fs_rm_xquota,
 	.get_dqblk		= xfs_fs_get_dqblk,
+	.get_nextdqblk		= xfs_fs_get_nextdqblk,
 	.set_dqblk		= xfs_fs_set_dqblk,
 };
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
