Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42D1523D
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882657; cv=none; b=pMDAS1Qj7YyVG5WC/n6IsM2UB4k41Rdr4xcNHarGq3+YOXyeuw1xdWN+Yk1Rj/EjOwBqejvQz/3GS3VUywjgEtBquckqRubM+mMt2lXNLvlxnH/ZMckLnZIzbYqMPRz7/mP0XuamcvMtNymArqSsb2Pp36A8aOeNMoNW9CF1t/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882657; c=relaxed/simple;
	bh=0yLw1UmLgVAEsVrXEQ6ewWeAhNGYevMaBioQrKVR8sQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EIDK//YG/wqVAE6ioKXBRJjkDDhBnn3lRCvjpPu6KSdQaigCZbXUI2FBe8I57cVdQCBcKhAwvw12pTK8l7j3rQlqMQjNMVO3CJY7Ow9LnLNBqJVZ/Ya4U17JsHGdyuSLFupm/V++WUn/m/1hiaO9IvefYvdcoGtYJP3vwymYmBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YgTgvDXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YgTgvDXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87567C116B1;
	Tue,  2 Jul 2024 01:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882657;
	bh=0yLw1UmLgVAEsVrXEQ6ewWeAhNGYevMaBioQrKVR8sQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YgTgvDXg7/Codbk9mSSp34VuNi5Th07rbAAH0OxtaS0Kgph1ut+MrnmjKJNZQOJN3
	 WU+sJDphhbR6bgzhqG9Re4PjKQmzCSR0zElWyqVFgaC0kGFid5ev3ETyMXg0YE9f8S
	 bFUU47VVf7yKD/1XFLtq0MtHIgOySL7JFHhqYFFpnVLZwLdNXdnAvcS1mZaAACqMeE
	 4mH5aJ5PUE0nDltUwm0fgby7GAbhRs2KMlS5qrYm8LvxHqMLyRDT0IYXyKB374kRIF
	 24m7cKnNkXC/h50upTgAMGTGHG16Dbqa3O2NkbAca1n3EuT9v/nzLn4OBfraF+KQ4W
	 GMS0WKYmEzgKw==
Date: Mon, 01 Jul 2024 18:10:57 -0700
Subject: [PATCH 01/24] libxfs: create attr log item opcodes and formats for
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121078.2009260.1928679002077059727.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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
---
 libxfs/defer_item.c |   52 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 9955e189dfe1..8cdf57eac900 100644
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

