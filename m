Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8558D262A3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388969; cv=none; b=HfSOlYsdjJKWzxDkAaA+Pxk+3sxLt6c/fMVoODC7q2OZqyAZTdr8grR5H0w+f5S51m5jpbs8znN+Rp87FBfg54psA3IG41BhZOCRWzcSxk0aJyG3Of8j9MCDIciFqce2Ctm4cmxKGGRtV73vL5qOWQ8wkLzScVOCOMJTSX2Pj1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388969; c=relaxed/simple;
	bh=PgE26RsE38Usgv5VpcFNFFnYnq9RWoWqMv5rdwpStfQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b//Km51m1CpaaQwJI399GIA3189EwlcfAxn4rouB/wzZU8YTR3AfR6Y5A/rP6wSWgrZgIu3SEHUPzyfFqYsZXh9Pxq0koe1sMDd/hbuqvGg5hMVmfOlU+ELqtYmoptIaGj+gc4O+3P/6+z9HqxlMTMxTCVSyCEcPyWhXlmBu8b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KCtbesOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KCtbesOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6216EC072AA;
	Wed, 17 Apr 2024 21:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388969;
	bh=PgE26RsE38Usgv5VpcFNFFnYnq9RWoWqMv5rdwpStfQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KCtbesOiGZqqMI2g2tI56zkRjoRVHoIk+rEStCWK0VfpTg9+PUJUR64lBiIRMOMak
	 vDumQ17AeO/5/7YTLy/q7PjdZoYsckmAWY0eYXV4vB2VxNg6vBkTs4Ce+oRaaOrjWN
	 WRb5tvMEdRIITtAlQPrrsl/ZOhgUZzWwiU0QzuRJnXbbiA4kujuGcYgpAnSUlEh25/
	 LRcFzZQUoLfMR2QQd1Qcfcj4GyOLcgV/8xXhXVO5RxUJ9khjKn6unSpHVTdQCK4miG
	 Bu8kg5aa5P7goSpCZLM+CeZeV+VE9NcurwpKlp4N1CDDGzhVezrQ48P6nc4dQcOI0a
	 3AaLKK9bIZQrg==
Date: Wed, 17 Apr 2024 14:22:48 -0700
Subject: [PATCH 04/67] xfs: move ->iop_recover to xfs_defer_op_type
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842400.1853449.3306949489902406349.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
index 7fd446ad4..c79a4bd74 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -336,4 +336,6 @@
 
 #define trace_xfs_fs_mark_healthy(a,b)		((void) 0)
 
+#define trace_xlog_intent_recovery_failed(...)	((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 4ef9867cc..54865b73b 100644
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
index c1a648e99..ef86a7f9b 100644
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

