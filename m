Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168C7143737
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924915; cv=none; b=NKRq9T3EDTgiHGTT6nyzr/81fLcOqyaAD8ShjxbLdIW5a/Nrste1P+CqnkuWN0kBRPmsQndA/fG+6c3pUa751oD/gBNEHSJKXHFfGRo+pRqMXExzlQdA3l37I4pVAH1MQooDEdrkM7TqId7X5OTJ0GQ1hWPVBUFJfZHgt3AWbH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924915; c=relaxed/simple;
	bh=NH4s8TtOVlH+7APGst/OeWkLAYIo6c6PDjzNNhvDoAI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OmGZuQMnBUjQOivyMXAgkBZ0EPC/0bYjYa14BjMSVZrSop+RRWBCWXuy6oJ/NQGOdOsgvnhZ+FEKQarPmoz/JrpmjNr6hhVOR1HDN3UfB0dmo2EcFj3zNOI2Bdhx/O14MaSUJHd2UqcbnmS9FBOQdCmjWM3ld88xo5ZNbpVY3Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lm57DtvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lm57DtvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B0BC2BD10;
	Thu, 20 Jun 2024 23:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924914;
	bh=NH4s8TtOVlH+7APGst/OeWkLAYIo6c6PDjzNNhvDoAI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lm57DtvWgDZjka69GSltD5jiiFKizWCNEmBriKsEUdDp2FYjr97MWJNkhIgkm7TRx
	 0pO/yqNyWa4j/E+TfLzrOwWg5pn1yQXY+lMgec8byBtFtmrhZurL7Or279nXc1U48K
	 Af0m42h2WKhZZZ0bB7vuW85E3dcEVukqFV/eTU/mBM2cFnTNNF+407vMZPIYEfKQj/
	 fv4NitUie7DveVYZBLV2cXGo8CQyuOYSDtmD9lg+C1FLacLU//cKiNI2VaszzsTDjX
	 Xc0bHLx0xOzuHakk0CnlhUM1l+U9xqr8o+GyKVX/3C02W4yJf8BWu+Rnzg5syz7/h8
	 j2FDWp6dRJvJQ==
Date: Thu, 20 Jun 2024 16:08:34 -0700
Subject: [PATCH 6/9] xfs: reuse xfs_rmap_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419335.3184396.12111999574233433655.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Reuse xfs_rmap_update_cancel_item to put the AG/RTG and free the item in
a few places that currently open code the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rmap_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 1cc1ec597a0bd..68e4ce0dbd727 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -358,6 +358,17 @@ xfs_rmap_update_put_group(
 	xfs_perag_intent_put(ri->ri_pag);
 }
 
+/* Cancel a deferred rmap update. */
+STATIC void
+xfs_rmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_rmap_intent		*ri = ri_entry(item);
+
+	xfs_rmap_update_put_group(ri);
+	kmem_cache_free(xfs_rmap_intent_cache, ri);
+}
+
 /* Process a deferred rmap update. */
 STATIC int
 xfs_rmap_update_finish_item(
@@ -371,8 +382,7 @@ xfs_rmap_update_finish_item(
 
 	error = xfs_rmap_finish_one(tp, ri, state);
 
-	xfs_rmap_update_put_group(ri);
-	kmem_cache_free(xfs_rmap_intent_cache, ri);
+	xfs_rmap_update_cancel_item(item);
 	return error;
 }
 
@@ -384,17 +394,6 @@ xfs_rmap_update_abort_intent(
 	xfs_rui_release(RUI_ITEM(intent));
 }
 
-/* Cancel a deferred rmap update. */
-STATIC void
-xfs_rmap_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_rmap_intent		*ri = ri_entry(item);
-
-	xfs_rmap_update_put_group(ri);
-	kmem_cache_free(xfs_rmap_intent_cache, ri);
-}
-
 /* Is this recovered RUI ok? */
 static inline bool
 xfs_rui_validate_map(

