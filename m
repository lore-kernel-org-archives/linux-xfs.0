Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299A1BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/qXGv8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9494BC433C8;
	Sun, 31 Dec 2023 21:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058182;
	bh=WCY2tyB8nIIeyzjaQOa7awtpP1AqvXBVjYOoI/2Tegg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g/qXGv8jxv87r7n0alIbNlsz2rZTPBWRtpQiAyYLUbQLnaPxKDgPxFvoyjenfJ/Ut
	 3hBkkA4kFRffP09heAWta4dUoyxKw3CYxuLrnCsSBSpB/2lVLy6D1DWILuGHeZwDDS
	 bbVG9APEnWQeyP4EtaYKgooUB2W+tXulq/kCPNNnK1WXQDhP5OxpU8LJAA4o97pnW6
	 LkB3gXbqsiM7+efbwXbl/ekdeptQIDDfy/Xxz5PFfNZ80GJSiw0kgF6KUdoqKpovAr
	 uHvI2u5MmCx41Oiu+QJk1LLeAgc6xCRzsFk6jslc3uSSTUQyCEbfUD6T/iB+KoLF3B
	 s+W+md4qPruYQ==
Date: Sun, 31 Dec 2023 13:29:42 -0800
Subject: [PATCH 02/10] xfs: give rmap btree cursor error tracepoints their own
 class
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404849266.1764703.7451907172468345144.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
References: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new tracepoint class for btree-related errors, then convert all
the rmap tracepoints to use it.  Also fix the one tracepoint that was
abusing the old class by making it a separate tracepoint.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   33 +++++---------
 fs/xfs/xfs_trace.h       |  106 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 99 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 539200e4b2516..813c2f77c9b3d 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -111,8 +111,7 @@ xfs_rmap_update(
 			xfs_rmap_irec_offset_pack(irec));
 	error = xfs_btree_update(cur, &rec);
 	if (error)
-		trace_xfs_rmap_update_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_update_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -155,8 +154,7 @@ xfs_rmap_insert(
 	}
 done:
 	if (error)
-		trace_xfs_rmap_insert_error(rcur->bc_mp,
-				rcur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_insert_error(rcur, error, _RET_IP_);
 	return error;
 }
 
@@ -194,8 +192,7 @@ xfs_rmap_delete(
 	}
 done:
 	if (error)
-		trace_xfs_rmap_delete_error(rcur->bc_mp,
-				rcur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_delete_error(rcur, error, _RET_IP_);
 	return error;
 }
 
@@ -816,8 +813,7 @@ xfs_rmap_unmap(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_unmap_error(mp, cur->bc_ag.pag->pag_agno,
-				error, _RET_IP_);
+		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1139,8 +1135,7 @@ xfs_rmap_map(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(mp, cur->bc_ag.pag->pag_agno,
-				error, _RET_IP_);
+		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1335,8 +1330,7 @@ xfs_rmap_convert(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
-			_RET_IP_);
+	trace_xfs_rmap_convert_state(cur, state, _RET_IP_);
 
 	/* reset the cursor back to PREV */
 	error = xfs_rmap_lookup_le(cur, bno, owner, offset, oldext, NULL, &i);
@@ -1689,8 +1683,7 @@ xfs_rmap_convert(
 			unwritten, oinfo);
 done:
 	if (error)
-		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1813,8 +1806,7 @@ xfs_rmap_convert_shared(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
-			_RET_IP_);
+	trace_xfs_rmap_convert_state(cur, state, _RET_IP_);
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
 	 */
@@ -2116,8 +2108,7 @@ xfs_rmap_convert_shared(
 			unwritten, oinfo);
 done:
 	if (error)
-		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -2316,8 +2307,7 @@ xfs_rmap_unmap_shared(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_unmap_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -2477,8 +2467,7 @@ xfs_rmap_map_shared(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index aafc0735e20ac..a7c752023f662 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2878,46 +2878,87 @@ DEFINE_EVENT(xfs_rmap_class, name, \
 		 const struct xfs_owner_info *oinfo), \
 	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo))
 
-/* simple AG-based error/%ip tracepoint class */
-DECLARE_EVENT_CLASS(xfs_ag_error_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error,
+/* btree cursor error/%ip tracepoint class */
+DECLARE_EVENT_CLASS(xfs_btree_error_class,
+	TP_PROTO(struct xfs_btree_cur *cur, int error,
 		 unsigned long caller_ip),
-	TP_ARGS(mp, agno, error, caller_ip),
+	TP_ARGS(cur, error, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
 		__field(int, error)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		if (cur->bc_flags & XFS_BTREE_IN_XFILE) {
+			__entry->agno = 0;
+			__entry->ino = 0;
+		} else if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+			__entry->agno = 0;
+			__entry->ino = cur->bc_ino.ip->i_ino;
+		} else {
+			__entry->agno = cur->bc_ag.pag->pag_agno;
+			__entry->ino = 0;
+		}
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno 0x%x error %d caller %pS",
+	TP_printk("dev %d:%d agno 0x%x ino 0x%llx error %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __entry->ino,
 		  __entry->error,
 		  (char *)__entry->caller_ip)
 );
 
-#define DEFINE_AG_ERROR_EVENT(name) \
-DEFINE_EVENT(xfs_ag_error_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error, \
+#define DEFINE_BTREE_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_btree_error_class, name, \
+	TP_PROTO(struct xfs_btree_cur *cur, int error, \
 		 unsigned long caller_ip), \
-	TP_ARGS(mp, agno, error, caller_ip))
+	TP_ARGS(cur, error, caller_ip))
 
 DEFINE_RMAP_EVENT(xfs_rmap_unmap);
 DEFINE_RMAP_EVENT(xfs_rmap_unmap_done);
-DEFINE_AG_ERROR_EVENT(xfs_rmap_unmap_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_rmap_unmap_error);
 DEFINE_RMAP_EVENT(xfs_rmap_map);
 DEFINE_RMAP_EVENT(xfs_rmap_map_done);
-DEFINE_AG_ERROR_EVENT(xfs_rmap_map_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_rmap_map_error);
 DEFINE_RMAP_EVENT(xfs_rmap_convert);
 DEFINE_RMAP_EVENT(xfs_rmap_convert_done);
-DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_error);
-DEFINE_AG_ERROR_EVENT(xfs_rmap_convert_state);
+DEFINE_BTREE_ERROR_EVENT(xfs_rmap_convert_error);
+
+TRACE_EVENT(xfs_rmap_convert_state,
+	TP_PROTO(struct xfs_btree_cur *cur, int state,
+		 unsigned long caller_ip),
+	TP_ARGS(cur, state, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(int, state)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+			__entry->agno = 0;
+			__entry->ino = cur->bc_ino.ip->i_ino;
+		} else {
+			__entry->agno = cur->bc_ag.pag->pag_agno;
+			__entry->ino = 0;
+		}
+		__entry->state = state;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d agno 0x%x ino 0x%llx state %d caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->ino,
+		  __entry->state,
+		  (char *)__entry->caller_ip)
+);
 
 DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -3018,9 +3059,9 @@ DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_deferred);
 DEFINE_RMAPBT_EVENT(xfs_rmap_update);
 DEFINE_RMAPBT_EVENT(xfs_rmap_insert);
 DEFINE_RMAPBT_EVENT(xfs_rmap_delete);
-DEFINE_AG_ERROR_EVENT(xfs_rmap_insert_error);
-DEFINE_AG_ERROR_EVENT(xfs_rmap_delete_error);
-DEFINE_AG_ERROR_EVENT(xfs_rmap_update_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_rmap_insert_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_rmap_delete_error);
+DEFINE_BTREE_ERROR_EVENT(xfs_rmap_update_error);
 
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_candidate);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_query);
@@ -3146,6 +3187,35 @@ DEFINE_AG_RESV_EVENT(xfs_ag_resv_free_extent);
 DEFINE_AG_RESV_EVENT(xfs_ag_resv_critical);
 DEFINE_AG_RESV_EVENT(xfs_ag_resv_needed);
 
+/* simple AG-based error/%ip tracepoint class */
+DECLARE_EVENT_CLASS(xfs_ag_error_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, agno, error, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, error)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->error = error;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d agno 0x%x error %d caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->error,
+		  (char *)__entry->caller_ip)
+);
+
+#define DEFINE_AG_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_ag_error_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error, \
+		 unsigned long caller_ip), \
+	TP_ARGS(mp, agno, error, caller_ip))
 DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 
 /* refcount tracepoint classes */

