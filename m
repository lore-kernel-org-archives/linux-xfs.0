Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 182008030
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:59:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 09A888F8071
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:23 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 0JPeWP7JOUE4xvvj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:59:22 -0800 (PST)
Subject: [PATCH 27/76] xfs: add rmap btree insert and delete helpers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:59:19 -0800
Message-ID: <20151219085918.12713.20164.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Add a couple of helper functions to encapsulate rmap btree insert and
delete operations.  Add tracepoints to the update function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c       |   62 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h |    2 +
 2 files changed, 64 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 8b244c4..6733873 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -88,6 +88,10 @@ xfs_rmap_update(
 {
 	union xfs_btree_rec	rec;
 
+	trace_xfs_rmapbt_update(cur->bc_mp, cur->bc_private.a.agno,
+			irec->rm_startblock, irec->rm_blockcount,
+			irec->rm_owner, irec->rm_offset);
+
 	rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
 	rec.rmap.rm_blockcount = cpu_to_be32(irec->rm_blockcount);
 	rec.rmap.rm_owner = cpu_to_be64(irec->rm_owner);
@@ -95,6 +99,64 @@ xfs_rmap_update(
 	return xfs_btree_update(cur, &rec);
 }
 
+int
+xfs_rmapbt_insert(
+	struct xfs_btree_cur	*rcur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	uint64_t		offset)
+{
+	int			i;
+	int			error;
+
+	trace_xfs_rmapbt_insert(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+			len, owner, offset);
+
+	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 0, done);
+
+	rcur->bc_rec.r.rm_startblock = agbno;
+	rcur->bc_rec.r.rm_blockcount = len;
+	rcur->bc_rec.r.rm_owner = owner;
+	rcur->bc_rec.r.rm_offset = offset;
+	error = xfs_btree_insert(rcur, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+done:
+	return error;
+}
+
+STATIC int
+xfs_rmapbt_delete(
+	struct xfs_btree_cur	*rcur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	uint64_t		offset)
+{
+	int			i;
+	int			error;
+
+	trace_xfs_rmapbt_delete(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+			len, owner, offset);
+
+	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+
+	error = xfs_btree_delete(rcur, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+done:
+	return error;
+}
+
 /*
  * Get the data from the pointed-to record.
  */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 0dfc151..d7c9722 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -55,6 +55,8 @@ int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t	bno,
 		xfs_extlen_t len, uint64_t owner, uint64_t offset, int *stat);
 int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t	bno,
 		xfs_extlen_t len, uint64_t owner, uint64_t offset, int *stat);
+int xfs_rmapbt_insert(struct xfs_btree_cur *rcur, xfs_agblock_t	agbno,
+		xfs_extlen_t len, uint64_t owner, uint64_t offset);
 int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
 		int *stat);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
