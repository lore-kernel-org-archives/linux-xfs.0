Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B671EC006
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844608; cv=none; b=j2kEaPFBjlAalA8uPj8CcTnR2j1YVSzpSIFAAJENPQIg3rLhrHRo9M08LHLnxqaLPUbhHCTB3KE1pn82P2kVdelwPAYBkvVgSoGOXArJotJ8vybrc73SyqHPNt2e7g5snQVxuuR/MzdpLRPyJwwVaG9pLhfwvl/3HQh+MORZA7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844608; c=relaxed/simple;
	bh=cN8ghLqSN7SiaAi4x6vE6lzCv++S3FKPMXBAeD68r4s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N1LiTlOfYTnR0ovYgGh6bR/fW/BHXqpUYEtnvFclI1z2zHf0vSDW8BOvWSuRqXVM+zUPvG3gtEUqbOxLpFmd+2K4ra5yltLVoK3GnKNnopDhCROEzYYXjqidbvtP9B07qOD0Kmzqs5RxN4xXHUynWYGWr5EznrpK5cWj+X1+EOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pyxW9ETL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pyxW9ETL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E4CC4CECF;
	Tue,  5 Nov 2024 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844608;
	bh=cN8ghLqSN7SiaAi4x6vE6lzCv++S3FKPMXBAeD68r4s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pyxW9ETL+7ptr/sQ1CFOszh4/TVEgfq3Ydx39mbRnUG3vcIfUWR+hfv5PVgbDJ2Vg
	 x6R+glutgfaP65buUtl3cFIE0jvXuaHq+Q/BcfymzOcq6hK5zYDRn87r1Ty8f4X4g0
	 9bwHNWgBbp7dgvTNKQlk/UC9R794Kns+VTJBp0kkO9JbbcF+Y/WSf46x+bREuVXbq3
	 TCCjLxFJteGozu0kPLgub1rc6woGUGwUHyrbWhhifvZaUBEbAPAKgjMHBhycFUm3DL
	 0SXJ6IQnP0mfLEI/hAuDhFeNt/6GNf6FL6njDM/3+46nP/wJqhA7BIezWrGUvHDUFw
	 4/TU+4dCmOkGQ==
Date: Tue, 05 Nov 2024 14:10:07 -0800
Subject: [PATCH 14/23] xfs: constify pag arguments to trace points
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394691.1868694.8836128994689916072.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Trace points never modify their arguments.  Mark all the pag objects
passed to trace points.  The exception is the xfs_ag_resv_class, which
uses the xfs_perag_resv helper that can't be marked const due to
other users modifying the returned structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |   34 +++++++++++++++++++---------------
 fs/xfs/xfs_trace.h   |   19 ++++++++++---------
 2 files changed, 29 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5eff6186724d4a..ae8b850fdd85ae 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -922,7 +922,8 @@ DEFINE_XCHK_FSFREEZE_EVENT(xchk_fsfreeze);
 DEFINE_XCHK_FSFREEZE_EVENT(xchk_fsthaw);
 
 TRACE_EVENT(xchk_refcount_incorrect,
-	TP_PROTO(struct xfs_perag *pag, const struct xfs_refcount_irec *irec,
+	TP_PROTO(const struct xfs_perag *pag,
+		 const struct xfs_refcount_irec *irec,
 		 xfs_nlink_t seen),
 	TP_ARGS(pag, irec, seen),
 	TP_STRUCT__entry(
@@ -1918,7 +1919,8 @@ TRACE_EVENT(xchk_dirtree_live_update,
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
 DECLARE_EVENT_CLASS(xrep_extent_class,
-	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+		 xfs_extlen_t len),
 	TP_ARGS(pag, agbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1940,7 +1942,8 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
 );
 #define DEFINE_REPAIR_EXTENT_EVENT(name) \
 DEFINE_EVENT(xrep_extent_class, name, \
-	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len), \
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno, \
+		 xfs_extlen_t len), \
 	TP_ARGS(pag, agbno, len))
 DEFINE_REPAIR_EXTENT_EVENT(xreap_dispose_unmap_extent);
 DEFINE_REPAIR_EXTENT_EVENT(xreap_dispose_free_extent);
@@ -1949,8 +1952,8 @@ DEFINE_REPAIR_EXTENT_EVENT(xreap_bmapi_binval);
 DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
 
 DECLARE_EVENT_CLASS(xrep_reap_find_class,
-	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len,
-		bool crosslinked),
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+		 xfs_extlen_t len, bool crosslinked),
 	TP_ARGS(pag, agbno, len, crosslinked),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1975,8 +1978,8 @@ DECLARE_EVENT_CLASS(xrep_reap_find_class,
 );
 #define DEFINE_REPAIR_REAP_FIND_EVENT(name) \
 DEFINE_EVENT(xrep_reap_find_class, name, \
-	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len, \
-		 bool crosslinked), \
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno, \
+		 xfs_extlen_t len, bool crosslinked), \
 	TP_ARGS(pag, agbno, len, crosslinked))
 DEFINE_REPAIR_REAP_FIND_EVENT(xreap_agextent_select);
 DEFINE_REPAIR_REAP_FIND_EVENT(xreap_bmapi_select);
@@ -2077,7 +2080,8 @@ TRACE_EVENT(xrep_ibt_found,
 )
 
 TRACE_EVENT(xrep_refc_found,
-	TP_PROTO(struct xfs_perag *pag, const struct xfs_refcount_irec *rec),
+	TP_PROTO(const struct xfs_perag *pag,
+		 const struct xfs_refcount_irec *rec),
 	TP_ARGS(pag, rec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -2595,7 +2599,7 @@ TRACE_EVENT(xrep_cow_replace_mapping,
 );
 
 TRACE_EVENT(xrep_cow_free_staging,
-	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno,
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
 		 xfs_extlen_t blockcount),
 	TP_ARGS(pag, agbno, blockcount),
 	TP_STRUCT__entry(
@@ -3312,7 +3316,7 @@ DEFINE_XREP_SYMLINK_EVENT(xrep_symlink_rebuild);
 DEFINE_XREP_SYMLINK_EVENT(xrep_symlink_reset_fork);
 
 TRACE_EVENT(xrep_iunlink_visit,
-	TP_PROTO(struct xfs_perag *pag, unsigned int bucket,
+	TP_PROTO(const struct xfs_perag *pag, unsigned int bucket,
 		 xfs_agino_t bucket_agino, struct xfs_inode *ip),
 	TP_ARGS(pag, bucket, bucket_agino, ip),
 	TP_STRUCT__entry(
@@ -3402,7 +3406,7 @@ TRACE_EVENT(xrep_iunlink_reload_ondisk,
 );
 
 TRACE_EVENT(xrep_iunlink_walk_ondisk_bucket,
-	TP_PROTO(struct xfs_perag *pag, unsigned int bucket,
+	TP_PROTO(const struct xfs_perag *pag, unsigned int bucket,
 		 xfs_agino_t prev_agino, xfs_agino_t next_agino),
 	TP_ARGS(pag, bucket, prev_agino, next_agino),
 	TP_STRUCT__entry(
@@ -3428,7 +3432,7 @@ TRACE_EVENT(xrep_iunlink_walk_ondisk_bucket,
 );
 
 DECLARE_EVENT_CLASS(xrep_iunlink_resolve_class,
-	TP_PROTO(struct xfs_perag *pag, unsigned int bucket,
+	TP_PROTO(const struct xfs_perag *pag, unsigned int bucket,
 		 xfs_agino_t prev_agino, xfs_agino_t next_agino),
 	TP_ARGS(pag, bucket, prev_agino, next_agino),
 	TP_STRUCT__entry(
@@ -3454,7 +3458,7 @@ DECLARE_EVENT_CLASS(xrep_iunlink_resolve_class,
 );
 #define DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(name) \
 DEFINE_EVENT(xrep_iunlink_resolve_class, name, \
-	TP_PROTO(struct xfs_perag *pag, unsigned int bucket, \
+	TP_PROTO(const struct xfs_perag *pag, unsigned int bucket, \
 		 xfs_agino_t prev_agino, xfs_agino_t next_agino), \
 	TP_ARGS(pag, bucket, prev_agino, next_agino))
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_uncached);
@@ -3515,7 +3519,7 @@ TRACE_EVENT(xrep_iunlink_relink_prev,
 );
 
 TRACE_EVENT(xrep_iunlink_add_to_bucket,
-	TP_PROTO(struct xfs_perag *pag, unsigned int bucket,
+	TP_PROTO(const struct xfs_perag *pag, unsigned int bucket,
 		 xfs_agino_t agino, xfs_agino_t curr_head),
 	TP_ARGS(pag, bucket, agino, curr_head),
 	TP_STRUCT__entry(
@@ -3541,7 +3545,7 @@ TRACE_EVENT(xrep_iunlink_add_to_bucket,
 );
 
 TRACE_EVENT(xrep_iunlink_commit_bucket,
-	TP_PROTO(struct xfs_perag *pag, unsigned int bucket,
+	TP_PROTO(const struct xfs_perag *pag, unsigned int bucket,
 		 xfs_agino_t old_agino, xfs_agino_t agino),
 	TP_ARGS(pag, bucket, old_agino, agino),
 	TP_STRUCT__entry(
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 35b07af3b71d51..c5128b151dbfce 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -181,7 +181,7 @@ TRACE_EVENT(xlog_intent_recovery_failed,
 );
 
 DECLARE_EVENT_CLASS(xfs_perag_class,
-	TP_PROTO(struct xfs_perag *pag, unsigned long caller_ip),
+	TP_PROTO(const struct xfs_perag *pag, unsigned long caller_ip),
 	TP_ARGS(pag, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -207,7 +207,7 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
 
 #define DEFINE_PERAG_REF_EVENT(name)	\
 DEFINE_EVENT(xfs_perag_class, name,	\
-	TP_PROTO(struct xfs_perag *pag, unsigned long caller_ip), \
+	TP_PROTO(const struct xfs_perag *pag, unsigned long caller_ip), \
 	TP_ARGS(pag, caller_ip))
 DEFINE_PERAG_REF_EVENT(xfs_perag_get);
 DEFINE_PERAG_REF_EVENT(xfs_perag_hold);
@@ -662,7 +662,7 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_binval);
 
 DECLARE_EVENT_CLASS(xfs_filestream_class,
-	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino),
+	TP_PROTO(const struct xfs_perag *pag, xfs_ino_t ino),
 	TP_ARGS(pag, ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -684,14 +684,14 @@ DECLARE_EVENT_CLASS(xfs_filestream_class,
 )
 #define DEFINE_FILESTREAM_EVENT(name) \
 DEFINE_EVENT(xfs_filestream_class, name, \
-	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino), \
+	TP_PROTO(const struct xfs_perag *pag, xfs_ino_t ino), \
 	TP_ARGS(pag, ino))
 DEFINE_FILESTREAM_EVENT(xfs_filestream_free);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
 DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
 
 TRACE_EVENT(xfs_filestream_pick,
-	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino),
+	TP_PROTO(const struct xfs_perag *pag, xfs_ino_t ino),
 	TP_ARGS(pag, ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1758,8 +1758,9 @@ DEFINE_AGF_EVENT(xfs_agf);
 DEFINE_AGF_EVENT(xfs_agfl_reset);
 
 TRACE_EVENT(xfs_free_extent,
-	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len,
-		 enum xfs_ag_resv_type resv, int haveleft, int haveright),
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+		 xfs_extlen_t len, enum xfs_ag_resv_type resv, int haveleft,
+		 int haveright),
 	TP_ARGS(pag, agbno, len, resv, haveleft, haveright),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -4652,7 +4653,7 @@ TRACE_EVENT(xfs_force_shutdown,
 
 #ifdef CONFIG_XFS_DRAIN_INTENTS
 DECLARE_EVENT_CLASS(xfs_perag_intents_class,
-	TP_PROTO(struct xfs_perag *pag, void *caller_ip),
+	TP_PROTO(const struct xfs_perag *pag, void *caller_ip),
 	TP_ARGS(pag, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -4675,7 +4676,7 @@ DECLARE_EVENT_CLASS(xfs_perag_intents_class,
 
 #define DEFINE_PERAG_INTENTS_EVENT(name)	\
 DEFINE_EVENT(xfs_perag_intents_class, name,					\
-	TP_PROTO(struct xfs_perag *pag, void *caller_ip), \
+	TP_PROTO(const struct xfs_perag *pag, void *caller_ip), \
 	TP_ARGS(pag, caller_ip))
 DEFINE_PERAG_INTENTS_EVENT(xfs_perag_intent_hold);
 DEFINE_PERAG_INTENTS_EVENT(xfs_perag_intent_rele);

