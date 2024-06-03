Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D6723A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442523; cv=none; b=oM/5vWyR8xi4jCnXdds1uhsBl299Enc1ioazGxIgy/3YlstNERxIImLzRMAPI2y0MCSBRguSTGxe3XnZz7u96dzSPzspIVPL/s3nSFqgOnHwMfzsXf9T0piSWarHXm3XeVo6NbdIjMW+P7+qJSwzejXElblgPZ8HuwtEe4wlSdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442523; c=relaxed/simple;
	bh=ovkxT+7VOOU2QWTiVge5/V6cL2T7VmGgjzQaIfFSJJ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RAM3cO3dmEOwoxbP0+LP/K721htbx5Oj9I/UqWtgdSLbbjUNTjyVrWAXyIMtEtdUnqHLNM/Me5CA+zZlj+XXWqAOARQGO1Bi/GNv7sHuPCvVk+F0MxrcTEm9+sPBAQ1f+CUtJqeJ6ZbWrl/JgL9SgrOPWVYI7RlnwJmhdOy29qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZtoG83w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZtoG83w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E54C2BD10;
	Mon,  3 Jun 2024 19:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442523;
	bh=ovkxT+7VOOU2QWTiVge5/V6cL2T7VmGgjzQaIfFSJJ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YZtoG83waqFYyTe+5AOYmOBZ3/jZHNVXIbm7NWmU8Tt6JBpa5zUNpI/OWJ0hUEasK
	 9+PbFipe+IcwnBZx5aq2sRCxEN0vQo2Tr/7Qc7FitXPsh0vC8PeMuU13rf5QxjeWgw
	 3uVryCFWnMrrdBKX03fzN+0BVyAvonPd5hTYcG7PdXj2459urCnPD18sQwHiSacwHK
	 F+acKBnffpFmDzutvEXOFynxWL8VeGJNJabYNhXvsPfe4C8F7NQlD2lmTdU1wmkB1g
	 2zCjLItNeaeBDdh6ot3zbRakB/kE9o/4DknbAiqebZfr2+rpBwrQC0YrEWJ8RJEaEZ
	 EhTSS1Y0RW0vA==
Date: Mon, 03 Jun 2024 12:22:02 -0700
Subject: [PATCH 4/4] libxfs: add a xattr_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744041412.1447589.9112088958225342343.stgit@frogsfrogsfrogs>
In-Reply-To: <171744041355.1447589.2661742462217465267.stgit@frogsfrogsfrogs>
References: <171744041355.1447589.2661742462217465267.stgit@frogsfrogsfrogs>
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

Add a helper to translate from the item list head to the attr_intent
item structure and use it so shorten assignments and avoid the need for
extra local variables.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 36811c7fe..fdb922f08 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -570,6 +570,13 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.cancel_item	= xfs_bmap_update_cancel_item,
 };
 
+/* Logged extended attributes */
+
+static inline struct xfs_attr_intent *attri_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_attr_intent, xattri_list);
+}
+
 /* Get an ATTRI. */
 static struct xfs_log_item *
 xfs_attr_create_intent(
@@ -618,11 +625,10 @@ xfs_attr_finish_item(
 	struct list_head	*item,
 	struct xfs_btree_cur	**state)
 {
-	struct xfs_attr_intent	*attr;
-	int			error;
+	struct xfs_attr_intent	*attr = attri_entry(item);
 	struct xfs_da_args	*args;
+	int			error;
 
-	attr = container_of(item, struct xfs_attr_intent, xattri_list);
 	args = attr->xattri_da_args;
 
 	/*
@@ -651,9 +657,8 @@ static void
 xfs_attr_cancel_item(
 	struct list_head	*item)
 {
-	struct xfs_attr_intent	*attr;
+	struct xfs_attr_intent	*attr = attri_entry(item);
 
-	attr = container_of(item, struct xfs_attr_intent, xattri_list);
 	xfs_attr_free_item(attr);
 }
 

