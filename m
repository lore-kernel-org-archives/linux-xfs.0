Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7AB21C17C
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192201; cv=none; b=j1y663sH4pA+hmBTWsLe6ysmJGJnHvavVqN2E2NDQjaE/EJOApP3vG8YbwCqlu2iAyAVUrS9xCHsYghWHzmNsH7smQiJcim6yqZX9J+e+OC8gA6cdW01r2h6eM7kydcN1WnnNUy+6aLTgbxlXF3bMgRZNMe3APblJqqXSramKRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192201; c=relaxed/simple;
	bh=Ghg8E08pjCYzdcD2fnG9nduoTiOPZud0RlUBIwmjog4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hZJPRxXMQAwCpbdXqBkuqYMFG08ScBXakcJk6U4p3wwvHqRaSyGIkXtnY0/jUHxPE+oa5d4KhSMAokSGYPBJUIWHt/RSrbPqsMjCK+KT2/eeztFEQG6Z+7vdXol95GSbTdcRJBTXPl3UsSlo6PnPxHvyXvptFthiywMHTv9Luyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avsRNROj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avsRNROj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09C5C4CEC3;
	Thu, 17 Oct 2024 19:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192201;
	bh=Ghg8E08pjCYzdcD2fnG9nduoTiOPZud0RlUBIwmjog4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=avsRNROj0+o4qSFZbrP5KQevJ3S4Rs7rRji77RvOUkesI8TP1WygQlCGT5ONRvljx
	 sagIQHun8Xtf04tsoLMqqJmYhtUocu1y9/y1guwbeKUevIAcv6dFQ4TkGFchs+U4ZF
	 PHTAJ8uXSquN6S4p95K7W2RZl/EqYoI4lBLH75OaXh31CtvfB8DH5EKcEgwYf240wR
	 HqQfn5Zciq30n6zquNHxFosFRC10tVKbxLv43/XPiqfjFhL5j9Qqiuu7RNuYw44Fvj
	 xXyl3hIzQEUVMy6oRSWgOPHJPp42C3o58+z1RCk3Lud7OJNZW2m1DGJnh7q5CFwDn8
	 49fB/4gbrgekQ==
Date: Thu, 17 Oct 2024 12:10:01 -0700
Subject: [PATCH 1/4] xfs: refactor xfs_qm_destroy_quotainos
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072646.3454331.3256955076038945929.stgit@frogsfrogsfrogs>
In-Reply-To: <172919072618.3454331.12971255439040173668.stgit@frogsfrogsfrogs>
References: <172919072618.3454331.12971255439040173668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Reuse this function instead of open-coding the logic.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c |   53 ++++++++++++++++++++---------------------------------
 1 file changed, 20 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 28b1420bac1dd2..b37e80fe7e86a6 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -40,7 +40,6 @@
 STATIC int	xfs_qm_init_quotainos(struct xfs_mount *mp);
 STATIC int	xfs_qm_init_quotainfo(struct xfs_mount *mp);
 
-STATIC void	xfs_qm_destroy_quotainos(struct xfs_quotainfo *qi);
 STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
 /*
  * We use the batch lookup interface to iterate over the dquots as it
@@ -226,6 +225,24 @@ xfs_qm_unmount_rt(
 	xfs_rtgroup_rele(rtg);
 }
 
+STATIC void
+xfs_qm_destroy_quotainos(
+	struct xfs_quotainfo	*qi)
+{
+	if (qi->qi_uquotaip) {
+		xfs_irele(qi->qi_uquotaip);
+		qi->qi_uquotaip = NULL; /* paranoia */
+	}
+	if (qi->qi_gquotaip) {
+		xfs_irele(qi->qi_gquotaip);
+		qi->qi_gquotaip = NULL;
+	}
+	if (qi->qi_pquotaip) {
+		xfs_irele(qi->qi_pquotaip);
+		qi->qi_pquotaip = NULL;
+	}
+}
+
 /*
  * Called from the vfsops layer.
  */
@@ -250,20 +267,8 @@ xfs_qm_unmount_quotas(
 	/*
 	 * Release the quota inodes.
 	 */
-	if (mp->m_quotainfo) {
-		if (mp->m_quotainfo->qi_uquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_uquotaip);
-			mp->m_quotainfo->qi_uquotaip = NULL;
-		}
-		if (mp->m_quotainfo->qi_gquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_gquotaip);
-			mp->m_quotainfo->qi_gquotaip = NULL;
-		}
-		if (mp->m_quotainfo->qi_pquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_pquotaip);
-			mp->m_quotainfo->qi_pquotaip = NULL;
-		}
-	}
+	if (mp->m_quotainfo)
+		xfs_qm_destroy_quotainos(mp->m_quotainfo);
 }
 
 STATIC int
@@ -1712,24 +1717,6 @@ xfs_qm_init_quotainos(
 	return error;
 }
 
-STATIC void
-xfs_qm_destroy_quotainos(
-	struct xfs_quotainfo	*qi)
-{
-	if (qi->qi_uquotaip) {
-		xfs_irele(qi->qi_uquotaip);
-		qi->qi_uquotaip = NULL; /* paranoia */
-	}
-	if (qi->qi_gquotaip) {
-		xfs_irele(qi->qi_gquotaip);
-		qi->qi_gquotaip = NULL;
-	}
-	if (qi->qi_pquotaip) {
-		xfs_irele(qi->qi_pquotaip);
-		qi->qi_pquotaip = NULL;
-	}
-}
-
 STATIC void
 xfs_qm_dqfree_one(
 	struct xfs_dquot	*dqp)

