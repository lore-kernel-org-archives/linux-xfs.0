Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11567129A71
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424410; cv=none; b=hZsvPXJUpgx/K7aFeRPk1zEbmeXCp06mUP1wyiWcjLeCB7+N3QsYgpm6ZeW08m/D0Hrg8VmS4FDFKh7RnLd0Sr1XiF090990hLPf/+oqv2vu+9xwwiNXLY/uCoSgCaiavCU/yO0mrvPyVwsalJEqfJhIV+mfTVRTro587sltvMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424410; c=relaxed/simple;
	bh=kb9aT+b5nMku8HhD6MtGzqJtCYjZcSrNXTrW5ExEqQE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LZb6mV7X+A+UEt4wLLv4X53aA7x//lG3RFE0fgtcMz2hk7Mx16bV35her8gD0Ta8h3vTd/tWRGX6hu/2fOjJjC77Fr+y3CV8wWZbAGExbOV2E5VmD057zjx1ryptt29oQd/LWfheATqEQcNI+/ivnQ8BaZ2TeZDwXqor1E8DiMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUEPtiqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUEPtiqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B55C433C7;
	Tue, 26 Mar 2024 03:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424409;
	bh=kb9aT+b5nMku8HhD6MtGzqJtCYjZcSrNXTrW5ExEqQE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pUEPtiqcrRTHzv3TvKE/Ht4YsIk2GTdZLsnwSSuY3t2x8STPffeqze10W7rnkHeLv
	 rBXP1w0BA7Fyz/M0bhF5+uvwkC/CUxChtAjun6vI1mfyvh+RqmLxowEwB+FRnXBwAz
	 f/GtFNhgrqxCSu8vOVUu4LLRXBTJM38cgxDT5Dj6g8R/AkeoTc/OZaPqt/PmGNIqDK
	 IvnAqx4VBNAsUXnbLlZngbrQZGMNpIQAgASsOJ22vINRfnLss79PCxWV+1/mbKZ1Hx
	 17ITKaPYq+mHMJxQqd9kqvLXOTeUuL659N6YgJGw1D4jhmQ3pCPE0fVNy5vzPyx5Cu
	 xScWFA2WoOTFw==
Date: Mon, 25 Mar 2024 20:40:09 -0700
Subject: [PATCH 045/110] xfs: factor out a btree block owner check
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132032.2215168.13612131279855387749.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 186f20c003199824eb3eb3b78e4eb7c2535a8ffc

Hoist the btree block owner check into a separate helper so that we
don't have an ugly multiline if statement.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index dab571222c96..5f132e3367aa 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1774,6 +1774,33 @@ xfs_btree_decrement(
 	return error;
 }
 
+/*
+ * Check the btree block owner now that we have the context to know who the
+ * real owner is.
+ */
+static inline xfs_failaddr_t
+xfs_btree_check_block_owner(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block)
+{
+	__u64			owner;
+
+	if (!xfs_has_crc(cur->bc_mp) ||
+	    (cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER))
+		return NULL;
+
+	owner = xfs_btree_owner(cur);
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+		if (be64_to_cpu(block->bb_u.l.bb_owner) != owner)
+			return __this_address;
+	} else {
+		if (be32_to_cpu(block->bb_u.s.bb_owner) != owner)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 int
 xfs_btree_lookup_get_block(
 	struct xfs_btree_cur		*cur,	/* btree cursor */
@@ -1812,11 +1839,7 @@ xfs_btree_lookup_get_block(
 		return error;
 
 	/* Check the inode owner since the verifiers don't. */
-	if (xfs_has_crc(cur->bc_mp) &&
-	    !(cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER) &&
-	    (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) &&
-	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
-			cur->bc_ino.ip->i_ino)
+	if (xfs_btree_check_block_owner(cur, *blkp) != NULL)
 		goto out_bad;
 
 	/* Did we get the level we were looking for? */

