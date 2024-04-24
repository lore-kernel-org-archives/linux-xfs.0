Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A900BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928215; cv=none; b=AdBaBy9BzdJSJqoOmofSEQHgFxQwXe6aYpHnlE8aXyys89XjjIyLuwrYwiE6gSvl8/eM7MbDH8GOE7J1sBhRoHAumbiAbYigjfPb3bcFA3IkHDbd8bVGBlU1zS9DbTub1TD876ZLrAr30lOToh5RFAnoIRWp01PxdY/IrP7GcE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928215; c=relaxed/simple;
	bh=P7chQrSVH0LzzkX2fhH0RmSCmEBQT3DBFCsSrckCNCg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KpF9lDToekZurZhZNzc3ZxwdYq5xXCMZRVdOtuSSImJFxn6Oi7B8SrCHyp38ZZPwgwFZZysHDELhSggFMn+jeoLsKaw/zVHbw2ZTC3/a66Ry1o6o3qroxuWL1w/M8Ju86VByjoNRY5mb5hL1ye7r7hSP/TJo3Lj0QY9m4DbFxpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UolWrwJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UolWrwJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AC6C116B1;
	Wed, 24 Apr 2024 03:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928214;
	bh=P7chQrSVH0LzzkX2fhH0RmSCmEBQT3DBFCsSrckCNCg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UolWrwJqGtc6wFiw7XXvDGUXC8ZT8RRm5AUYGRvEeJx8rCi7S3ABi8YJXpAtTKqx6
	 n4fd+vsdPZmFIYgVz3FQD1HUJBULQvjhIA3WxqCQfiN6eBfVqs47MWJ49mQ2SuBf01
	 0qFWnX0Vrf1CnPhAZkskFHn1fwuLsnQw7WeKjq5Hofu2qFf4lVUB+EMKhUrqFX2FO1
	 1eRtu8fdJhIXpe7SGIIcdC0X3lHAa5RpHMd5eeqK7uXwCyEHxvNrGvxrWxMPhxG3Jq
	 ZrSxAtSp17UBgYX1VkiP8CsVkM5mEspe8H2MK4IOOJvRePwQR3f+VjE+ont1HlrQ8j
	 PYX8cJE/A/6eg==
Date: Tue, 23 Apr 2024 20:10:14 -0700
Subject: [PATCH 05/14] xfs: fix missing check for invalid attr flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782657.1904599.12358922838678709826.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
References: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
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

The xattr scrubber doesn't check for undefined flags in shortform attr
entries.  Therefore, define a mask XFS_ATTR_ONDISK_MASK that has all
possible XFS_ATTR_* flags in it, and use that to check for unknown bits
in xchk_xattr_actor.

Refactor the check in the dabtree scanner function to use the new mask
as well.  The redundant checks need to be in place because the dabtree
check examines the hash mappings and therefore needs to decode the attr
leaf entries to compute the namehash.  This happens before the walk of
the xattr entries themselves.

Fixes: ae0506eba78fd ("xfs: check used space of shortform xattr structures")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.h |    5 +++++
 fs/xfs/scrub/attr.c           |   13 +++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index aac3fe039614..ecd0616f5776 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -719,8 +719,13 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
+
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
 
+#define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
+				 XFS_ATTR_LOCAL | \
+				 XFS_ATTR_INCOMPLETE)
+
 #define XFS_ATTR_NAMESPACE_STR \
 	{ XFS_ATTR_LOCAL,	"local" }, \
 	{ XFS_ATTR_ROOT,	"root" }, \
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 5b855d7c9821..5ca79af47e81 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -192,6 +192,11 @@ xchk_xattr_actor(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
+	if (attr_flags & ~XFS_ATTR_ONDISK_MASK) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+		return -ECANCELED;
+	}
+
 	if (attr_flags & XFS_ATTR_INCOMPLETE) {
 		/* Incomplete attr key, just mark the inode for preening. */
 		xchk_ino_set_preen(sc, ip->i_ino);
@@ -481,7 +486,6 @@ xchk_xattr_rec(
 	xfs_dahash_t			hash;
 	int				nameidx;
 	int				hdrsize;
-	unsigned int			badflags;
 	int				error;
 
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
@@ -511,10 +515,11 @@ xchk_xattr_rec(
 
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
-	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
-			XFS_ATTR_INCOMPLETE);
-	if ((ent->flags & badflags) != 0)
+	if (ent->flags & ~XFS_ATTR_ONDISK_MASK) {
 		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = (struct xfs_attr_leaf_name_local *)
 				(((char *)bp->b_addr) + nameidx);

