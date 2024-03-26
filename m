Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33531C6A8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422232; cv=none; b=DrPGOPXokNZJD0h2uqULXcNL88IGx7FQAV+/s45Ub7qzW6YWzDhcO0hMU9xhNlriGSfWXaA+63qLqT7CsbnQqk9duJumsfkZQQjp+6hzeY+O87phhfN0CteVWWqYq1h0hJ4HrlOuyyBoaYD4NeVryjNBH2YyvBNQTJPchKCDKek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422232; c=relaxed/simple;
	bh=Mh8SENwNRjGtbTi8aJPKCttmTsGFVOZBOyur8nADVRQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RLlgh/ITIGdUc6Sz3WcmfEzHilc4q4s4YQmNfSmrAGpAws0Cg/jQ2M3p3WSe1yce5OIRp/ZSvUxA+t5A1vL/3Lwy68a38fxcsoegh/ye2k2COAA9EP4qyEmarwVZZcR7MSPD1jUKMZMfUpbcKtsEA+AXkFEoGEbfGLTC0jnLKsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HA9AJPVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HA9AJPVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A349C43390;
	Tue, 26 Mar 2024 03:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422232;
	bh=Mh8SENwNRjGtbTi8aJPKCttmTsGFVOZBOyur8nADVRQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HA9AJPVoNE/9fWcftLg8CCu8UQW0zU3ncqPC3V3Ilgi6rso2tYMiKLx7dy8adSjZZ
	 7sqd20BA7H+tH/MgJNyhrbhZhy92+5Z2qZbp+zzr0qWqdpteWvWsJzV4uhsq3b4oat
	 0owH98HLfadx2NOr+qkPmHXOl1Uz7SZfWId/9mtVRtvHr8ip+Z5UFCHKE76T1sOlzf
	 UHNEfEglElnbKS0tD3R+HEliK2oTO1MsfWRFGSI/WIlPvJZQq7znB+Pp7yi7MR6baU
	 uC8uCbAL53+kVp+sHjDPTlPeyvilrRePLc0zenqKNYyW3SliG2fCl3PGJ2JsbKIsJA
	 NHydu3CIdV3/g==
Date: Mon, 25 Mar 2024 20:03:52 -0700
Subject: [PATCH 04/67] xfs: move ->iop_recover to xfs_defer_op_type
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127021.2212320.6827474228634791533.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: db7ccc0bac2add5a41b66578e376b49328fc99d0

Finish off the series by moving the intent item recovery function
pointer to the xfs_defer_op_type struct, since this is really a deferred
work function now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 include/xfs_trace.h |    2 ++
 libxfs/xfs_defer.c  |   17 +++++++++++++++++
 libxfs/xfs_defer.h  |    4 ++++
 3 files changed, 23 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 7fd446ad42bf..c79a4bd74dcb 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -336,4 +336,6 @@
 
 #define trace_xfs_fs_mark_healthy(a,b)		((void) 0)
 
+#define trace_xlog_intent_recovery_failed(...)	((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 4ef9867cca0e..54865b73b47f 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -708,6 +708,23 @@ xfs_defer_cancel_recovery(
 	xfs_defer_pending_cancel_work(mp, dfp);
 }
 
+/* Replay the deferred work item created from a recovered log intent item. */
+int
+xfs_defer_finish_recovery(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*capture_list)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	int				error;
+
+	error = ops->recover_work(dfp, capture_list);
+	if (error)
+		trace_xlog_intent_recovery_failed(mp, error,
+				ops->recover_work);
+	return error;
+}
+
 /*
  * Move deferred ops from one transaction to another and reset the source to
  * initial state. This is primarily used to carry state forward across
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index c1a648e99174..ef86a7f9b059 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -57,6 +57,8 @@ struct xfs_defer_op_type {
 	void (*finish_cleanup)(struct xfs_trans *tp,
 			struct xfs_btree_cur *state, int error);
 	void (*cancel_item)(struct list_head *item);
+	int (*recover_work)(struct xfs_defer_pending *dfp,
+			    struct list_head *capture_list);
 	unsigned int		max_items;
 };
 
@@ -130,6 +132,8 @@ void xfs_defer_start_recovery(struct xfs_log_item *lip,
 		enum xfs_defer_ops_type dfp_type, struct list_head *r_dfops);
 void xfs_defer_cancel_recovery(struct xfs_mount *mp,
 		struct xfs_defer_pending *dfp);
+int xfs_defer_finish_recovery(struct xfs_mount *mp,
+		struct xfs_defer_pending *dfp, struct list_head *capture_list);
 
 static inline void
 xfs_defer_add_item(

