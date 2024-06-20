Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B687C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924836; cv=none; b=i/5d6PcrpnolytdWcMLvNe3JmLfdhBpax5tr7qNeabsAyRRpnIdXrGgYxKlRdT3/RI2l9tFSjCUCO7eQvoWQjMbnpNtNeFw4pzTB4+FdZrfANmieCqK3zbJTNgwYpFN/JEg6KC/NIzM7acWAtnyMQ+ju5brYNACfNZwIAfZFxHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924836; c=relaxed/simple;
	bh=7zKln5jeLNM/PRHw+EmwB21dmBk0y/zoK0ZJa8Cf/ZU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c3rMi6wISkWkEsmU7dcPn2elsltf/nGKsjx+Dyn+qmJQhKfHpPL0AzN7UCm1S+U+y4UgoEL+y4k4+dCZFx62izghAwaF8fUj1i8HNfh/N1ekieFifwgau+AsOdGqa59WRsfiKW1GDo8msd4nC7BwGQhpjKy/yQVwPGsAgu3AJa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MkLFLyOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MkLFLyOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41968C2BD10;
	Thu, 20 Jun 2024 23:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924836;
	bh=7zKln5jeLNM/PRHw+EmwB21dmBk0y/zoK0ZJa8Cf/ZU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MkLFLyOfSe/Yr8A4I/NSyRCyngO7G0zhBmerS8eH/7wQnwRpafup1cqal0yfdqpyX
	 wcf3c2doOII4SHw/8BubRa8MZV8k0z7Z8/yyCwYYv4ZJ+/feRq70QyWhoUlPtqs444
	 8Fqp+d8NKotdcTdGWJHarTOZryCPGKusAX7Wxl7+0yjk7XXr9FHAY4dtFqADV1QSAD
	 fNr7z162/eN3UoMemKas9d/Q6X8HgzjdJmwYTzF6YwEouQCUhpdQNYQL7Va+OO/Wx6
	 WLrBHl5ZQmx1l5BpIMO2rR8DfqtzJh+lqnr5FdE//KkN7fhSMMjIH7aSqWdNScFz6k
	 VJJ1wo6QYpKdw==
Date: Thu, 20 Jun 2024 16:07:15 -0700
Subject: [PATCH 1/9] xfs: give rmap btree cursor error tracepoints their own
 class
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419249.3184396.641039011881838280.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rmap.c |   33 ++++---------
 fs/xfs/xfs_trace.h       |  117 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 110 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index ef16f6f9cef67..bf047cdb95a4e 100644
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
 
@@ -1148,8 +1144,7 @@ xfs_rmap_map(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(mp, cur->bc_ag.pag->pag_agno,
-				error, _RET_IP_);
+		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1344,8 +1339,7 @@ xfs_rmap_convert(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
-			_RET_IP_);
+	trace_xfs_rmap_convert_state(cur, state, _RET_IP_);
 
 	/* reset the cursor back to PREV */
 	error = xfs_rmap_lookup_le(cur, bno, owner, offset, oldext, NULL, &i);
@@ -1698,8 +1692,7 @@ xfs_rmap_convert(
 			unwritten, oinfo);
 done:
 	if (error)
-		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -1822,8 +1815,7 @@ xfs_rmap_convert_shared(
 	     RIGHT.rm_blockcount > XFS_RMAP_LEN_MAX)
 		state &= ~RMAP_RIGHT_CONTIG;
 
-	trace_xfs_rmap_convert_state(mp, cur->bc_ag.pag->pag_agno, state,
-			_RET_IP_);
+	trace_xfs_rmap_convert_state(cur, state, _RET_IP_);
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
 	 */
@@ -2125,8 +2117,7 @@ xfs_rmap_convert_shared(
 			unwritten, oinfo);
 done:
 	if (error)
-		trace_xfs_rmap_convert_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_convert_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -2325,8 +2316,7 @@ xfs_rmap_unmap_shared(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_unmap_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_unmap_error(cur, error, _RET_IP_);
 	return error;
 }
 
@@ -2486,8 +2476,7 @@ xfs_rmap_map_shared(
 			unwritten, oinfo);
 out_error:
 	if (error)
-		trace_xfs_rmap_map_error(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, error, _RET_IP_);
+		trace_xfs_rmap_map_error(cur, error, _RET_IP_);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 438e88a9fd1d3..7527db2c04426 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2797,46 +2797,98 @@ DEFINE_EVENT(xfs_rmap_class, name, \
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
+		switch (cur->bc_ops->type) {
+		case XFS_BTREE_TYPE_INODE:
+			__entry->agno = 0;
+			__entry->ino = cur->bc_ino.ip->i_ino;
+			break;
+		case XFS_BTREE_TYPE_AG:
+			__entry->agno = cur->bc_ag.pag->pag_agno;
+			__entry->ino = 0;
+			break;
+		case XFS_BTREE_TYPE_MEM:
+			__entry->agno = 0;
+			__entry->ino = 0;
+			break;
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
+		switch (cur->bc_ops->type) {
+		case XFS_BTREE_TYPE_INODE:
+			__entry->agno = 0;
+			__entry->ino = cur->bc_ino.ip->i_ino;
+			break;
+		case XFS_BTREE_TYPE_AG:
+			__entry->agno = cur->bc_ag.pag->pag_agno;
+			__entry->ino = 0;
+			break;
+		case XFS_BTREE_TYPE_MEM:
+			__entry->agno = 0;
+			__entry->ino = 0;
+			break;
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
@@ -2937,9 +2989,9 @@ DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_deferred);
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
@@ -3065,6 +3117,35 @@ DEFINE_AG_RESV_EVENT(xfs_ag_resv_free_extent);
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

