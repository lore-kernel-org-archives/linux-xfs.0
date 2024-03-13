Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41A5AD21
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294815; cv=none; b=sbOGoESg6OGWqItypViw9/XEth+WUpCjhMnH45L65+YYIOYkFrdifEswAjwaNAuFT7Hm+ERvWWwKCnu0w+zfRiDp/I/HYyup3J0Rj8pFAE6KScsyXV9pVG4+TLSt1Rbns359iX7qiKGaVXBBHAo6/2uGIJvYpCuoJfhwJ+jEB40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294815; c=relaxed/simple;
	bh=+86Rvgu/X+hG9PPDEOae0++zrzu5y2CeauEv1NFde7A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d8kn+ahnqgCFxnHj4838iIWntNlVyiNAe3g5i/eBqNFgcmvt76dCPPUzUKEKLbTGs8s3+wITooIPwq6/EF86tcLy8UchtUxYzsPnUaxpyyeyIl3le2LhR1axc8/OlKFeI/tsLLs63jX/iJxNvc5ZiJ5F4w7h5aTlgghKoIU3208=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qz3ylK8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qz3ylK8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE2AC433F1;
	Wed, 13 Mar 2024 01:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294814;
	bh=+86Rvgu/X+hG9PPDEOae0++zrzu5y2CeauEv1NFde7A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qz3ylK8aDO2v/vk9f4m4T8abmZW3CirWxtc+OAzKsMEygc8TslVr/QI4n2yx/i00n
	 gVhngUDRirVNpiSlTF+p69gLtbHFAqo+E4C0IAwc5Sv/udfYSqpYnq6ray3oR1BQk+
	 nb/rLP6GnbLsqSmseONJB5KTk08rapwix+3hGbFnYzeGqtyGNiOd8ZwW1GwDNzXpGv
	 VUTobbyU9j9cXBIig4B7vDGenNdhq9Ai7kuYHkfwlfj4Wwkapdyn5JnLhpa8cP8Hwu
	 FkSJUi9ptBuw24yWLj6bEfMX0FzlR3C7mIXCb2czbzb95Tx99D3/X4kHqOprGiinvW
	 i6u0GCygaq1Cw==
Date: Tue, 12 Mar 2024 18:53:33 -0700
Subject: [PATCH 02/67] xfs: recreate work items when recovering intent items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431222.2061787.13965134299124279099.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: e70fb328d5277297ea2d9169a3a046de6412d777

Recreate work items for each xfs_defer_pending object when we are
recovering intent items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_defer.c |    3 +--
 libxfs/xfs_defer.h |    9 +++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index bd6f14a2c0d2..4900a7d62e5e 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -671,9 +671,8 @@ xfs_defer_add(
 		list_add_tail(&dfp->dfp_list, &tp->t_dfops);
 	}
 
-	list_add_tail(li, &dfp->dfp_work);
+	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
-	dfp->dfp_count++;
 }
 
 /*
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 5dce938ba3d5..bef5823f61fb 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -130,6 +130,15 @@ void xfs_defer_start_recovery(struct xfs_log_item *lip,
 void xfs_defer_cancel_recovery(struct xfs_mount *mp,
 		struct xfs_defer_pending *dfp);
 
+static inline void
+xfs_defer_add_item(
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*work)
+{
+	list_add_tail(work, &dfp->dfp_work);
+	dfp->dfp_count++;
+}
+
 int __init xfs_defer_init_item_caches(void);
 void xfs_defer_destroy_item_caches(void);
 

