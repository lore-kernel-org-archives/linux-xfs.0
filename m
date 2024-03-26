Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63FE12838F
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425491; cv=none; b=cMYjHqJAYFEFYIX5y8BFCyo1Kh2fYmAgkmQ1ewuGS8MTDgQcFK1RLt/urRwPvOXiMO2azeIoUzkyzv/Y1pVF8Lk9IrJu316GpHyonATTyq7jsAMVs3jympxSQP4yUNNlEI6GaW46fVDd7cMG3RGl52gJvXiy18YkIfcL5Ax7a+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425491; c=relaxed/simple;
	bh=zou1A9NV7RwEqQlnZek6n9QFWNshxUr8pw9xIe13FRs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ceb73f9qGcA8ufK8ItRXAGA4MwGQ+kgEwHmwq5b8w23nLpcOUv8gCDBCNdjFzSyVIC9iHgKKthMIm0Bfh9BILu4st+dSO6hHlirOhw571YRcjUtIm06HPMm+eEmY308H7tAN911/8Ef4yZ+sK7wDtBO6hdNc5g8OYzLH3k1rx9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u0KQGqiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0KQGqiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53813C433F1;
	Tue, 26 Mar 2024 03:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425491;
	bh=zou1A9NV7RwEqQlnZek6n9QFWNshxUr8pw9xIe13FRs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u0KQGqiWEQVkhJ9r2tCnAT3ygiktjx5+8Z8hC9BmU/reaFDrS8k2M31IJB0tQtWYg
	 OgxYT7Cgc3wuaQN5q02VWqExbzW8nVYEpzeY6sBRD5FX2oO9a5oT6JDRju06ZQ0kj6
	 ASguGpGiuYjg0aQ4yA0jJRtHalVVAFknTad4DoQmiOlpIOYqkBOikMMOixB1fp917E
	 RHA+IUlzG4gZAUvArbQfev0k7vmiAQwq0KKmDDNwR9SN4Cx/23gOtBT6sjKzGZpE/y
	 eAMfn6m3cJBYv7NtzF6I+zX+NdPERvCKqLWuegE/BLEMwa4g8tNxgncFzfGGHVQWDi
	 VP/k1VqAt8akg==
Date: Mon, 25 Mar 2024 20:58:10 -0700
Subject: [PATCH 4/4] xfs: add a xattr_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142133348.2217863.7124619996249333792.stgit@frogsfrogsfrogs>
In-Reply-To: <171142133286.2217863.14915428649465069188.stgit@frogsfrogsfrogs>
References: <171142133286.2217863.14915428649465069188.stgit@frogsfrogsfrogs>
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
---
 libxfs/defer_item.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 36811c7fece1..fdb922f08c39 100644
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
 

