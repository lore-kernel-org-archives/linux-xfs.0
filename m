Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95EEAdb053208 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 09:14:10 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id M6jrSJcBbxWU80i0 for
	<xfs@oss.sgi.com>; Fri, 05 Oct 2012 07:15:37 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q95EFaod025347
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:36 -0400
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q95EFapE027042
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 10:15:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 02/10] xfs: support a tag-based inode_ag_iterator
Date: Fri,  5 Oct 2012 10:17:08 -0400
Message-Id: <1349446636-8611-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Genericize xfs_inode_ag_walk() to support an optional radix tree tag
and args argument for the execute function. Create a new wrapper
called xfs_inode_ag_iterator_tag() that performs a tag based walk
of perag's and inodes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c      |   56 ++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_icache.h      |    7 ++++-
 fs/xfs/xfs_qm_syscalls.c |    5 ++-
 3 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f9afc5f..878eb24 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -516,8 +516,11 @@ xfs_inode_ag_walk(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
 	int			(*execute)(struct xfs_inode *ip,
-					   struct xfs_perag *pag, int flags),
-	int			flags)
+					   struct xfs_perag *pag, int flags,
+					   void *args),
+	int			flags,
+	void			*args,
+	int			tag)
 {
 	uint32_t		first_index;
 	int			last_error = 0;
@@ -536,9 +539,17 @@ restart:
 		int		i;
 
 		rcu_read_lock();
-		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+
+		if (tag == -1) 
+			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
 					(void **)batch, first_index,
 					XFS_LOOKUP_BATCH);
+		else
+			nr_found = radix_tree_gang_lookup_tag(
+					&pag->pag_ici_root,
+					(void **) batch, first_index,
+					XFS_LOOKUP_BATCH, tag);
+
 		if (!nr_found) {
 			rcu_read_unlock();
 			break;
@@ -579,7 +590,7 @@ restart:
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			error = execute(batch[i], pag, flags);
+			error = execute(batch[i], pag, flags, args);
 			IRELE(batch[i]);
 			if (error == EAGAIN) {
 				skipped++;
@@ -608,8 +619,10 @@ int
 xfs_inode_ag_iterator(
 	struct xfs_mount	*mp,
 	int			(*execute)(struct xfs_inode *ip,
-					   struct xfs_perag *pag, int flags),
-	int			flags)
+					   struct xfs_perag *pag, int flags,
+					   void *args),
+	int			flags,
+	void			*args)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
@@ -619,7 +632,36 @@ xfs_inode_ag_iterator(
 	ag = 0;
 	while ((pag = xfs_perag_get(mp, ag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, flags);
+		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, -1);
+		xfs_perag_put(pag);
+		if (error) {
+			last_error = error;
+			if (error == EFSCORRUPTED)
+				break;
+		}
+	}
+	return XFS_ERROR(last_error);
+}
+
+int
+xfs_inode_ag_iterator_tag(
+	struct xfs_mount	*mp,
+	int			(*execute)(struct xfs_inode *ip,
+					   struct xfs_perag *pag, int flags,
+					   void *args),
+	int			flags,
+	void			*args,
+	int			tag)
+{
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			last_error = 0;
+	xfs_agnumber_t		ag;
+
+	ag = 0;
+	while ((pag = xfs_perag_get_tag(mp, ag, tag))) {
+		ag = pag->pag_agno + 1;
+		error = xfs_inode_ag_walk(mp, pag, execute, flags, args, tag);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index db36130..bb80237 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -40,7 +40,10 @@ void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 
 int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
-	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
-	int flags);
+	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags, void *args),
+	int flags, void *args);
+int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
+	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags, void *args),
+	int flags, void *args, int tag);
 
 #endif
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 7a9071f..5f53e75 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -846,7 +846,8 @@ STATIC int
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
-	int			flags)
+	int			flags,
+	void			*args)
 {
 	/* skip quota inodes */
 	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
@@ -882,5 +883,5 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags);
+	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, NULL);
 }
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
