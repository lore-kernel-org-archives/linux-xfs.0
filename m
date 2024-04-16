Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3093D7A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230622; cv=none; b=RhQa+JuFkLDViWFqIKFCmdzpaUjiFXsQtylu0k1vnmJldtfUTX0hL3Djl1UNuNZGcVF67w4WmTk4p1L4t7tO2OxVHjETu/NZWgU8zySmbCA8EVlId3gDv/9rrAzheoPQi74dn9sWhrmR5OF6FlFo5oYE+FdwF4cw6KWvlzvw0gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230622; c=relaxed/simple;
	bh=7PjA/hn0EaVGPSaTSf/8TfHXVZx7fzdiVVWzudEjhXA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HtT8AYJwzB4DW3BWQja9M6Yc27yxkOmMA0vu3jSorUhx5VcrAbzSj6dbs0iRg2zFwBC4RkphRVaGB0cb9xn+XOFeAVCeey1Ejn57vnS5or8YSkaCN/lB2hEsH9Y2fsrh9vKUonCA05pYmlrB6DsPviaAxUyhsherwLCJYPB+da4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKubZSSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKubZSSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B57C113CC;
	Tue, 16 Apr 2024 01:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230622;
	bh=7PjA/hn0EaVGPSaTSf/8TfHXVZx7fzdiVVWzudEjhXA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mKubZSSjSt4K3epL50Lo7PNTuDlYHldqcl6Bb9OCzF1jAbGvptoErg3flSWjzT3UU
	 eMkJmjvwFy8wYWeSWgdFCdr/tkOhRvZg/LDXhFzzHxb7kfHtgBwjLy5/nJIxo31SWj
	 9AJ4CNZcmLw2dJSvtlZ528U7rfkJDpUop+AHw2rVe4IadEvbbkF+QEnf/tcVOcIpJ/
	 nZbBVTwmxC388w/WkVh78DkNMucUlSrHOk1CalqhwuXkyM8hZ5ZNkmKVoQgdv2AggY
	 SBUD5YEOyiU/Z9COq7oQk+hLlFVzWlIrJH93t8m0rm/+ujBVHbHFoUmUqKbOqBZvZC
	 SNf0mUen9CaAQ==
Date: Mon, 15 Apr 2024 18:23:41 -0700
Subject: [PATCH 05/14] xfs: fix missing check for invalid attr flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323027154.251201.16843560287969999816.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
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
index aac3fe0396140..ecd0616f5776a 100644
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
index 5b855d7c98211..5ca79af47e81e 100644
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

