Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8ECIIKd092206 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 07:18:18 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YrWqVB2DxtwYn9Re for
	<xfs@oss.sgi.com>; Fri, 14 Sep 2012 05:19:25 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8ECJPAn024849
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 08:19:25 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8ECJOuU030669
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 08:19:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 2/8] xfs: support a tag-based inode_ag_iterator
Date: Fri, 14 Sep 2012 08:19:49 -0400
Message-Id: <1347625195-6369-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1347625195-6369-1-git-send-email-bfoster@redhat.com>
References: <1347625195-6369-1-git-send-email-bfoster@redhat.com>
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
---
 fs/xfs/xfs_qm_syscalls.c |    5 ++-
 fs/xfs/xfs_sync.c        |   61 +++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_sync.h        |    7 ++++-
 3 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 858a3b1..848bd8e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -845,7 +845,8 @@ STATIC int
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
-	int			flags)
+	int			flags,
+	void			*args)
 {
 	/* skip quota inodes */
 	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
@@ -881,5 +882,5 @@ xfs_qm_dqrele_all_inodes(
 	uint		 flags)
 {
 	ASSERT(mp->m_quotainfo);
-	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags);
+	xfs_inode_ag_iterator(mp, xfs_dqrele_inode, flags, NULL);
 }
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 00c6224..0da93c9 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -101,8 +101,11 @@ xfs_inode_ag_walk(
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
@@ -121,9 +124,17 @@ restart:
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
@@ -164,7 +175,7 @@ restart:
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			error = execute(batch[i], pag, flags);
+			error = execute(batch[i], pag, flags, args);
 			IRELE(batch[i]);
 			if (error == EAGAIN) {
 				skipped++;
@@ -193,8 +204,10 @@ int
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
@@ -204,7 +217,36 @@ xfs_inode_ag_iterator(
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
@@ -219,7 +261,8 @@ STATIC int
 xfs_sync_inode_data(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
-	int			flags)
+	int			flags,
+	void			*args)
 {
 	struct inode		*inode = VFS_I(ip);
 	struct address_space *mapping = inode->i_mapping;
@@ -252,7 +295,7 @@ xfs_sync_data(
 
 	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
 
-	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags);
+	error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags, NULL);
 	if (error)
 		return XFS_ERROR(error);
 
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 4486491..463ea0a 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -48,7 +48,10 @@ void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 
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
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
