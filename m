Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166198F5C;
	Mon,  1 Apr 2024 16:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990140; cv=none; b=iedvqCkl7P7jjhBJRbZ1YE2lgRBo7gA+4/5WG5B6Z39ujf56zzfnWb8kSfFYlDW2oK4tUcgjumaxroQQmxBKeGzfUNhV7DLUhhvwU9FMRkmyqi49A96Y+f86i3hBt9AVkCvyVJnPXc8u8Cm/7oTHwjLeX7wxQAZx/u7WqeelheY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990140; c=relaxed/simple;
	bh=FLySU1PwYVt+Bmdvv5oNXfaryWGpks56SfBQhANIO8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVVYlL+3nbepMgcRtPat17DAY8oGOELW+pQ92KBUe+yCDgXEtgK21wKsxvQPs1+w3U0PCp8Q637gm1AwlYm2125ywIRN6LKg0Nl3r3IOjfBOoK6J1DPXZSNxAmC/QWq8D7I91SeRbD4p+8O5+6I/LgT7oGjz30YF9TN5nluWiX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0v7ou/qb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0v7ou/qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2893DC433F1;
	Mon,  1 Apr 2024 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990139;
	bh=FLySU1PwYVt+Bmdvv5oNXfaryWGpks56SfBQhANIO8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0v7ou/qbtWIL40JlmxWW3hYDw3m+Rs967J8NOpBp1Ivu3Ac1owliMlTklc8e8hGvm
	 j0qkjghLW/NuesNzXFo7sdNJNktlKcCOn9DVVMnDgGC1uZoctPU+izW0mJcS9/BWFR
	 obll3ozFowAxHx6BxFrOy5bCDLR1wUosu8+HlKiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 259/396] xfs: transfer recovered intent item ownership in ->iop_recover
Date: Mon,  1 Apr 2024 17:45:08 +0200
Message-ID: <20240401152555.630052286@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit deb4cd8ba87f17b12c72b3827820d9c703e9fd95 upstream.

Now that we pass the xfs_defer_pending object into the intent item
recovery functions, we know exactly when ownership of the sole refcount
passes from the recovery context to the intent done item.  At that
point, we need to null out dfp_intent so that the recovery mechanism
won't release it.  This should fix the UAF problem reported by Long Li.

Note that we still want to recreate the full deferred work state.  That
will be addressed in the next patches.

Fixes: 2e76f188fd90 ("xfs: cancel intents immediately if process_intents fails")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |    2 ++
 fs/xfs/xfs_attr_item.c          |    1 +
 fs/xfs/xfs_bmap_item.c          |    2 ++
 fs/xfs/xfs_extfree_item.c       |    2 ++
 fs/xfs/xfs_log_recover.c        |   19 ++++++++++++-------
 fs/xfs/xfs_refcount_item.c      |    1 +
 fs/xfs/xfs_rmap_item.c          |    2 ++
 7 files changed, 22 insertions(+), 7 deletions(-)

--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -155,5 +155,7 @@ xlog_recover_resv(const struct xfs_trans
 
 void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
 		xfs_lsn_t lsn, unsigned int dfp_type);
+void xlog_recover_transfer_intent(struct xfs_trans *tp,
+		struct xfs_defer_pending *dfp);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -632,6 +632,7 @@ xfs_attri_item_recover(
 
 	args->trans = tp;
 	done_item = xfs_trans_get_attrd(tp, attrip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -524,6 +524,8 @@ xfs_bui_item_recover(
 		goto err_rele;
 
 	budp = xfs_trans_get_bud(tp, buip);
+	xlog_recover_transfer_intent(tp, dfp);
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -689,7 +689,9 @@ xfs_efi_item_recover(
 	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
 	if (error)
 		return error;
+
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		struct xfs_extent_free_item	fake = {
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2590,13 +2590,6 @@ xlog_recover_process_intents(
 			break;
 		}
 
-		/*
-		 * XXX: @lip could have been freed, so detach the log item from
-		 * the pending item before freeing the pending item.  This does
-		 * not fix the existing UAF bug that occurs if ->iop_recover
-		 * fails after creating the intent done item.
-		 */
-		dfp->dfp_intent = NULL;
 		xfs_defer_cancel_recovery(log->l_mp, dfp);
 	}
 	if (error)
@@ -2631,6 +2624,18 @@ xlog_recover_cancel_intents(
 }
 
 /*
+ * Transfer ownership of the recovered log intent item to the recovery
+ * transaction.
+ */
+void
+xlog_recover_transfer_intent(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	dfp->dfp_intent = NULL;
+}
+
+/*
  * This routine performs a transaction to null out a bad inode pointer
  * in an agi unlinked inode hash bucket.
  */
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -523,6 +523,7 @@ xfs_cui_item_recover(
 		return error;
 
 	cudp = xfs_trans_get_cud(tp, cuip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
 		struct xfs_refcount_intent	fake = { };
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -537,7 +537,9 @@ xfs_rui_item_recover(
 			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
+
 	rudp = xfs_trans_get_rud(tp, ruip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
 		struct xfs_rmap_intent	fake = { };


