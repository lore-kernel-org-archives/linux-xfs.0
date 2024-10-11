Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9932933E7
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607311; cv=none; b=S5Bgqbm+d+NAhW9Mt9OSdkXeRGyb1xaHs8j32aR5UvLLRBpj76PhC6d8ePQ3cjApXqwHEnDDvmReMJqI/RHeSVYvDLJyCmIfKQUAGjCm6a3sZmoj2vuMUcjh3dGWNxXg2bDM5cRBKaz2rqrmF85O8tPsKcM/noe/SrFg7Vve3tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607311; c=relaxed/simple;
	bh=T9/iRHmJy5EtnWmBSTOKBWAOntXNFL9l/ji2RRspyUY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D2m7gGJT01f4YfrkRegNcmUM4dtghRdn5riqg3rgGSOxwhBp6EyXyOMhQS1IW+icftRw96GH4KuuQJp9HRSernhS54HIxEETPY5ON5RC5CW7SPncd/1NkgEJzfBAI6jbvhsLEWwIgeBQ0JRlIN/F77BRnod1s+UcZkoYR/lgPjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=InxbyHMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="InxbyHMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC8AC4CEC5;
	Fri, 11 Oct 2024 00:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607311;
	bh=T9/iRHmJy5EtnWmBSTOKBWAOntXNFL9l/ji2RRspyUY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=InxbyHMu/Ffx071PsJoUX8vXRPgzo6cAOy9v44lOs+ZSsrDIgPbL9BveituqdjEjF
	 Jis+k3odCMxFkr16umuYF3XXfZeOCl7RXWRsSXw7NKsU3NfhO3OTTcBE18/C3+NU4d
	 N8alZ5O5MtZlNyVJjo2+cc7KE65tkjFxg/PDNI57dCbz7vSCgi0M0WrfV6tBvVzJaV
	 rv9qJvqLHiq7HEnOfRrNS9a4HX7c8wexGod4HPoikS4LXOR1zrW2PWz8f4Ecy4XFH+
	 A/soyXW9yLCjEIuKsjS6+p1UDhDU+SUtLFqfSFU+1b4hH+Nj9yLNW+OTaZYPP+skyD
	 QsToz0FBnAOiQ==
Date: Thu, 10 Oct 2024 17:41:51 -0700
Subject: [PATCH 16/25] xfs: constify pag arguments to trace points
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640687.4175438.9730579945808326347.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
index bd01b7a13228c6..b85e75712a3ebe 100644
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
-	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino, xfs_extlen_t free),
+	TP_PROTO(const struct xfs_perag *pag, xfs_ino_t ino, xfs_extlen_t free),
 	TP_ARGS(pag, ino, free),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -1763,8 +1763,9 @@ DEFINE_AGF_EVENT(xfs_agf);
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
@@ -4657,7 +4658,7 @@ TRACE_EVENT(xfs_force_shutdown,
 
 #ifdef CONFIG_XFS_DRAIN_INTENTS
 DECLARE_EVENT_CLASS(xfs_perag_intents_class,
-	TP_PROTO(struct xfs_perag *pag, void *caller_ip),
+	TP_PROTO(const struct xfs_perag *pag, void *caller_ip),
 	TP_ARGS(pag, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -4680,7 +4681,7 @@ DECLARE_EVENT_CLASS(xfs_perag_intents_class,
 
 #define DEFINE_PERAG_INTENTS_EVENT(name)	\
 DEFINE_EVENT(xfs_perag_intents_class, name,					\
-	TP_PROTO(struct xfs_perag *pag, void *caller_ip), \
+	TP_PROTO(const struct xfs_perag *pag, void *caller_ip), \
 	TP_ARGS(pag, caller_ip))
 DEFINE_PERAG_INTENTS_EVENT(xfs_perag_intent_hold);
 DEFINE_PERAG_INTENTS_EVENT(xfs_perag_intent_rele);

