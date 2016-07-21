Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 748897D4F
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 00:00:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 475728F8035
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:00:17 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id pXegGA60J4S5atDg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:00:15 -0700 (PDT)
Subject: [PATCH 37/47] xfs: add rmap btree insert and delete helpers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 22:00:09 -0700
Message-ID: <146907720943.25461.13482265927474464252.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

Add a couple of helper functions to encapsulate rmap btree insert and
delete operations.  Add tracepoints to the update function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   47 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_rmap.h |    3 +++
 2 files changed, 49 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 7439272..e8ce97f 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -92,13 +92,58 @@ xfs_rmap_update(
 	struct xfs_rmap_irec	*irec)
 {
 	union xfs_btree_rec	rec;
+	int			error;
+
+	trace_xfs_rmap_update(cur->bc_mp, cur->bc_private.a.agno,
+			irec->rm_startblock, irec->rm_blockcount,
+			irec->rm_owner, irec->rm_offset, irec->rm_flags);
 
 	rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
 	rec.rmap.rm_blockcount = cpu_to_be32(irec->rm_blockcount);
 	rec.rmap.rm_owner = cpu_to_be64(irec->rm_owner);
 	rec.rmap.rm_offset = cpu_to_be64(
 			xfs_rmap_irec_offset_pack(irec));
-	return xfs_btree_update(cur, &rec);
+	error = xfs_btree_update(cur, &rec);
+	if (error)
+		trace_xfs_rmap_update_error(cur->bc_mp,
+				cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+int
+xfs_rmap_insert(
+	struct xfs_btree_cur	*rcur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags)
+{
+	int			i;
+	int			error;
+
+	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+			len, owner, offset, flags);
+
+	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 0, done);
+
+	rcur->bc_rec.r.rm_startblock = agbno;
+	rcur->bc_rec.r.rm_blockcount = len;
+	rcur->bc_rec.r.rm_owner = owner;
+	rcur->bc_rec.r.rm_offset = offset;
+	rcur->bc_rec.r.rm_flags = flags;
+	error = xfs_btree_insert(rcur, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+done:
+	if (error)
+		trace_xfs_rmap_insert_error(rcur->bc_mp,
+				rcur->bc_private.a.agno, error, _RET_IP_);
+	return error;
 }
 
 static int
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 34c811a..92ac067 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -148,6 +148,9 @@ int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, uint64_t owner, uint64_t offset,
 		unsigned int flags, int *stat);
+int xfs_rmap_insert(struct xfs_btree_cur *rcur, xfs_agblock_t agbno,
+		xfs_extlen_t len, uint64_t owner, uint64_t offset,
+		unsigned int flags);
 int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
 		int *stat);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
