Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91012C9D
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347926; cv=none; b=AMU7BV9f4MAE55AW3CrcdWKomViUF9T99Wf2PvQUZh43nrswcO9L9JHEEjO19dzuMWRAZ229jiz9CTOAD8uIlStFPys7UmUV2/ygb7+GLsDq7BSECXHKhPBtj7ST32wdCkDthxxBDDVKxAeNVZdTA7m/rKM/KYPJJMbyh06CcW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347926; c=relaxed/simple;
	bh=ovkxT+7VOOU2QWTiVge5/V6cL2T7VmGgjzQaIfFSJJ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oc3XuUhPAhvFwBOsXlweptnZje9uYD2YAiUmmhRKWTyDc31ajRDghwZLq2OQuh5s2fnzSYHmO18Mz0J0oM0iPScImm2lRHX3UOFfjtDF/ZPFHdpJgnpLCewZoKvDu84Ns9k+jiA65D8fEflwQfxwggFZ8azOuZK66jA+2rijUJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIy5L60A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIy5L60A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E086C2BD11;
	Wed, 22 May 2024 03:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347926;
	bh=ovkxT+7VOOU2QWTiVge5/V6cL2T7VmGgjzQaIfFSJJ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AIy5L60AB+NqumwLbucHPdpswsYRijmAdD+W4KV1NQqHn0RDddROGk0Blwq0CECNw
	 GFlGajiw9oGKX/D+2e8QpkOcIVh+4giv1q01SIbWNiRmBqG2teJCNYa0TMwJXqlMpD
	 qcz2ZtsxOyRJgX2IT3mPr/PPQn2h02xFg+ArqJ7Ltel/D0nmwi+BaRkfFC7YWbZl8l
	 6BDiv6t64zBSgaMjuRo9Muu+Szds8++FKEb4t1KMYZ/U9dAhcEstVN6jnMclIG8z5S
	 gij8tOkLqvkhLEWi/pEzJhQ4KHjnNYlYwSdQGBcUR5H9gACX8xMUA7mGGaMJ9j6xYQ
	 ymFoItuKlLKQw==
Date: Tue, 21 May 2024 20:18:46 -0700
Subject: [PATCH 4/4] libxfs: add a xattr_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533755.2482547.4139068182291216339.stgit@frogsfrogsfrogs>
In-Reply-To: <171634533692.2482547.7100831050962784521.stgit@frogsfrogsfrogs>
References: <171634533692.2482547.7100831050962784521.stgit@frogsfrogsfrogs>
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
 

