Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0D079CC
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302347; cv=none; b=gYtgbZlP4bW12XRfnDsE4ie+jyO92/jWhmg/QlYwQPXvipPFMqCcVu2w9R8kNqTxKB5Kuwmoh+MpYzgHBg32ZmoL7Da4UtF32oRGHHSdNR4lDdPPNuRgQOVSj1Sb3K4UP/GPfJL4/TqYULfx9fDzw08QwBtwtd5XMuhLv/6NepM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302347; c=relaxed/simple;
	bh=TxPv39wFaK+TCYbAuy4Ig89xyj6Yz4cyNj+a1qdyiBU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rPl/Ej2/Gs0BtbVpG18C0oHlKx4IgJbhqwfrdWTmUY1pUR4bV1/KKeaFeIUXE6I5G7ZXC/d+wkNUW19bzV1l7KeW4yxDuopOTGKvcwqz1qQwkktEQ2+8CviLxLQKP7OCjE5CFHQ5+hrC9eHRgu2q86W+qkqkKzTPfXTNwnAHj8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+wa9Qlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+wa9Qlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDF7C32786;
	Tue, 30 Jul 2024 01:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302347;
	bh=TxPv39wFaK+TCYbAuy4Ig89xyj6Yz4cyNj+a1qdyiBU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m+wa9QlxX3EnL2sVJCeoTyKTda83zibXgsJNjCW8vTIwnDKryU4KF6jMUEelswZOZ
	 ojhlIHQYnxeVrRBP5VkVy5g57l619uKCZO8qgiUlKRb5OdvxWjwsj3psw5TNslap/T
	 6ZwTMCcXeJeu4fBXM3DrAzSrfmZkwm1DsnZVg/1egIAt33el1nvFR32lUTJgL0OyP3
	 OfD6ghVcXYmITYSkXoWzgtB3PrEPUdtIZXe3KSlGFta2iF2up6P+BAfPLu6LT7LBhQ
	 2W1A3O4H0vZirwFQ7l/ZVSGTZZJi/vE0hr9B0IZFd0P/aoWIrGuuv94mrzL38aLtA1
	 DFh8I0QQk3HWA==
Date: Mon, 29 Jul 2024 18:19:06 -0700
Subject: [PATCH 01/24] libxfs: create attr log item opcodes and formats for
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850533.1350924.9301095357934631650.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
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

Update xfs_attr_defer_add to use the pptr-specific opcodes if it's
reading or writing parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |   52 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 9955e189d..8cdf57eac 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -676,21 +676,61 @@ xfs_attr_defer_add(
 	enum xfs_attr_defer_op	op)
 {
 	struct xfs_attr_intent	*new;
+	unsigned int		log_op = 0;
+	bool			is_pptr = args->attr_filter & XFS_ATTR_PARENT;
 
-	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	if (is_pptr) {
+		ASSERT(xfs_has_parent(args->dp->i_mount));
+		ASSERT((args->attr_filter & ~XFS_ATTR_PARENT) != 0);
+		ASSERT(args->op_flags & XFS_DA_OP_LOGGED);
+		ASSERT(args->valuelen == sizeof(struct xfs_parent_rec));
+	}
+
+	new = kmem_cache_zalloc(xfs_attr_intent_cache,
+			GFP_NOFS | __GFP_NOFAIL);
 	new->xattri_da_args = args;
 
+	/* Compute log operation from the higher level op and namespace. */
 	switch (op) {
 	case XFS_ATTR_DEFER_SET:
-		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_SET;
-		new->xattri_dela_state = xfs_attr_init_add_state(args);
+		if (is_pptr)
+			log_op = XFS_ATTRI_OP_FLAGS_PPTR_SET;
+		else
+			log_op = XFS_ATTRI_OP_FLAGS_SET;
 		break;
 	case XFS_ATTR_DEFER_REPLACE:
-		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_REPLACE;
-		new->xattri_dela_state = xfs_attr_init_replace_state(args);
+		if (is_pptr)
+			log_op = XFS_ATTRI_OP_FLAGS_PPTR_REPLACE;
+		else
+			log_op = XFS_ATTRI_OP_FLAGS_REPLACE;
 		break;
 	case XFS_ATTR_DEFER_REMOVE:
-		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_REMOVE;
+		if (is_pptr)
+			log_op = XFS_ATTRI_OP_FLAGS_PPTR_REMOVE;
+		else
+			log_op = XFS_ATTRI_OP_FLAGS_REMOVE;
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+	new->xattri_op_flags = log_op;
+
+	/* Set up initial attr operation state. */
+	switch (log_op) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_SET:
+		new->xattri_dela_state = xfs_attr_init_add_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		ASSERT(args->new_valuelen == args->valuelen);
+		new->xattri_dela_state = xfs_attr_init_replace_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		new->xattri_dela_state = xfs_attr_init_replace_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		new->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	}

