Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7E91C6A8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422201; cv=none; b=uOsQ3fm5gHQaAyQVA+jrRpuZTYl4UWhVRRwh+jWlCppfxXs2nJPR1ymKzZfQi4//PRlYpZmiof6lKIIovGCoTfsRS1B2Qo3lhf5/MLUwdZ8xILKD5KDaezNZ+Z9erCuOUHz/dW55ySIFWVYz/tyOtu50Ji/6/hugo1uE8UabYHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422201; c=relaxed/simple;
	bh=dguFfVRAnMY5CPI91KBiC7fyOpV5yAkG+ZqvTQB6EY0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p3UtDS+/WwJTQRsf9LlUuQZMjOnZvPdloed+7AGsjDSRZh/KCUYqkuJTz6ifxvUZyZWU7HOv44RGNPcuv1DIVqc69yIx6nmPP+l43oSHIC29xAkPaM/jG/lv2SF2kHinA1Mc21e7Uw8R7KnwFiYmc9UEB8r+2ePZIhKS+AK9RME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCRyirZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCRyirZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC31C433C7;
	Tue, 26 Mar 2024 03:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422201;
	bh=dguFfVRAnMY5CPI91KBiC7fyOpV5yAkG+ZqvTQB6EY0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QCRyirZcKqOLPz/+bNP/N3UQoWT0kVgoOXVpq6M0ID+RlUKF7Rr9MbGwTaPnTlmTW
	 8+kVIKsOWKoR4wxP0L25Gjbv83jFLrVMvZSGHIO3jGjggTjHnoLcf8MUL/qb2rM1ka
	 h6k0W+y+Y3Bv57RiIFA4gOFV5uA2wQQZIpMdnQDpi9pdYUIhp9xOIVQrGRrf/3bSXR
	 9OEfMJXloOEPh9uuZWJzqxv4g7CXXhqgaxYIGjeEWGBd7lncWpKDrHUeOM6h6K5vvk
	 A8MSt5ln0nr/e9JYFYpDkHSNvUZjlNKt+aHEiHBSJdm2l+AMTS18ePcdZILBMvU7DS
	 M0vGynBu/t5hA==
Date: Mon, 25 Mar 2024 20:03:20 -0700
Subject: [PATCH 02/67] xfs: recreate work items when recovering intent items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126992.2212320.10290367464323094842.stgit@frogsfrogsfrogs>
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

Source kernel commit: e70fb328d5277297ea2d9169a3a046de6412d777

Recreate work items for each xfs_defer_pending object when we are
recovering intent items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
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
 

