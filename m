Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF2B84FAA
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928136; cv=none; b=dqBSE3R+m8HjDcWt/Aoy5WQEHgJCknz67t+opa70bDKvgaWhp0uQYlkAxaUhSeX/cSC8BXyvGIqgCCTysyiaDtnHRue4j93P8fAKjlrvEdOVIHwxQDKE14usn/S425xxcac7KYTkX6ItqQixLL5Ct10EcaZXheIt9892pTBuUgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928136; c=relaxed/simple;
	bh=1WGsAevhZmJTw0T/LCzsLNBSev5vhk3Ck90UY+Wj28w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i5JgkmRffq5nI+eBzmkALgHreUoJEGBZJOUrds8/63LHsnpnmSjg1UZ0+mnnWh7zKVsXOy6n0OyEzuzaDJd/daRuSqypFIThHFvrqM7dMuLSA0kPu20I87Y6ZX49TtZ6joCk8ZrTefIt45BDKhRjthnGufyiDNF4Vmqm1fTFn/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nas3b5Cb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nas3b5Cb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C34DC116B1;
	Wed, 24 Apr 2024 03:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928136;
	bh=1WGsAevhZmJTw0T/LCzsLNBSev5vhk3Ck90UY+Wj28w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nas3b5Cbm1g6IoT63N8T/WHn/sTxY2SeoWnnVy8PUuAkB5GLAzKD06gIIgvozvZOP
	 +QA6wZgMzPzn6nqvBYd/ObeL9vuS2DKj85OQJhhruWgEgV5uBXGjzaAkMeekDwGHKm
	 4UsXW/XUoprww89XPrXpcE67/iWHVBSaWN/BxqohU6iXZURB1gmjjcuBon3ggCXIPr
	 D0tbl65zfpMFIplEnezPoZth2pYQ3g8QPHApUyUQHX3zObishFOriSz9Lncx+HQVlL
	 UXpdbuLILVX6KhSrQJjGf6pTxF1rK5KR4spt/qPWUnMygobJuQwU5OwZMR6mtRJxbL
	 l3wS+oZGc95Dg==
Date: Tue, 23 Apr 2024 20:08:55 -0700
Subject: [PATCH 5/5] xfs: rearrange xfs_da_args a bit to use less space
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782196.1904378.13804043586808314286.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782098.1904378.6539247354693938689.stgit@frogsfrogsfrogs>
References: <171392782098.1904378.6539247354693938689.stgit@frogsfrogsfrogs>
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

A few notes about struct xfs_da_args:

The XFS_ATTR_* flags only go up as far as XFS_ATTR_INCOMPLETE, which
means that attr_filter could be a u8 field.

I've reduced the number of XFS_DA_OP_* flags down to the point where
op_flags would also fit into a u8.

filetype has 7 bytes of slack after it, which is wasteful.

namelen will never be greater than MAXNAMELEN, which is 256.  This field
could be reduced to a short.

Rearrange the fields in xfs_da_args to waste less space.  This reduces
the structure size from 136 bytes to 128.  Later when we add extra
fields to support parent pointer replacement, this will only bloat the
structure to 144 bytes, instead of 168.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.h |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 706b529a81fe..17cef594b5bb 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -54,16 +54,20 @@ enum xfs_dacmp {
  */
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
-	const uint8_t		*name;		/* string (maybe not NULL terminated) */
-	int		namelen;	/* length of string (maybe no NULL) */
-	uint8_t		filetype;	/* filetype of inode for directories */
+	const uint8_t	*name;		/* string (maybe not NULL terminated) */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
-	int		valuelen;	/* length of value */
-	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
-	xfs_dahash_t	hashval;	/* hash value of name */
-	xfs_ino_t	inumber;	/* input/output inode number */
 	struct xfs_inode *dp;		/* directory inode to manipulate */
 	struct xfs_trans *trans;	/* current trans (changes over time) */
+
+	xfs_ino_t	inumber;	/* input/output inode number */
+	xfs_ino_t	owner;		/* inode that owns the dir/attr data */
+
+	int		valuelen;	/* length of value */
+	uint8_t		filetype;	/* filetype of inode for directories */
+	uint8_t		op_flags;	/* operation flags */
+	uint8_t		attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
+	short		namelen;	/* length of string (maybe no NULL) */
+	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
 	int		whichfork;	/* data or attribute fork */
 	xfs_dablk_t	blkno;		/* blkno of attr leaf of interest */
@@ -76,9 +80,7 @@ typedef struct xfs_da_args {
 	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
 	int		rmtblkcnt2;	/* remote attr value block count */
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
-	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
-	xfs_ino_t	owner;		/* inode that owns the dir/attr data */
 } xfs_da_args_t;
 
 /*

