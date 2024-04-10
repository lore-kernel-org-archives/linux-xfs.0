Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5709621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710301; cv=none; b=Nv3m3J/iZ97fC0vYwRoN2odeTpLxvglZOF1OUVaZg4t0pwXnzsEHiXd7FZZY6AQJx04VKCXHkpHHmeMR6IAqy9n9rSnwc+zMnkvBnjf6MBCdn6e02Y/3xRHE2vX+J0JmJwATQQD0MuT+6cPv9RzncwJpi/hX5pQy0pthetKfNx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710301; c=relaxed/simple;
	bh=NgezUS+bKR6kKwSMmU+QHZ8P6x5Cf2bfNlDXsrij4ek=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ryYsAlI0JEXQ/PDlY5anHhNJi6raXspG0fNO9l9pFZpqa+/l/HPo5Uu0NKY7Urwd/KRCabX8WSUsgKTCouT/L5QQeeWAMLZvE5kglsS92BbVjb7YXzHZyG8gvOE8xH1qcQbAsVI50cWqrT0qseO9Yei9WM+rtsC6GzvZ14cXvoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgYhRL8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgYhRL8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC20C433F1;
	Wed, 10 Apr 2024 00:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710301;
	bh=NgezUS+bKR6kKwSMmU+QHZ8P6x5Cf2bfNlDXsrij4ek=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QgYhRL8QF+xX4wb55bUbQ8Wn3WhHf3OF2l5Qj+mEmOK6wEV+/6/MvfdilErxzCoHQ
	 J6xlvthA3VMtuX30qJWEjCFWZHFunNDhrtMc5NHkMuwINnzkfwOBu55x5gztbpY4D3
	 SGdzV/BMnH89m8tCyvh3Vj5SLXzrvu9kxam2fcBa9dtHp4BTC76NKjdADZrjAkPyOY
	 FBkqF8rSfm4tHBaB9m1Tz5wv4xD35VG5gFUF/n/oQYOBpApGfGEoZ3gyLEJLiEG67W
	 SZVK8r8dyEPIVB33CglXHVjRnxvGieTKBHfCTvBK22uEFOoRvXpg+wsALMnh5Eix4Y
	 t+GDd0jwC6PeQ==
Date: Tue, 09 Apr 2024 17:51:41 -0700
Subject: [PATCH 05/12] xfs: fix missing check for invalid attr flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968933.3631545.17328111564626328171.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
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

