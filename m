Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3547E3FE4
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299731; cv=none; b=Dl3SsZJR2U+SdgyLuwmYIptlmIcu0KajG8rZ69V74tOV15/KgD0o6TGFEOYk9p59W6/arU9J8LpTJM9oVA6q7mdigPxiMLuQwprj8Ip1kz6gm+70o2vcdl3wZZ8yFPH3cXn1cRaUzgpbTypVEqP6s9msUOh7RuUyHEG8gsrF4iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299731; c=relaxed/simple;
	bh=ZpLK4fpzz73Rjb0WhopjlBg+CKpU4hdTuGXklsjF8zw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bNMSFckTR0L5MbA2tMoMHqdMKiDZNL2cO4pzwal1cbHWpSNnwFtFSDZTEMA4QCKeTcs5naE/A3RniP5OZvxWF5ZxvwgfpDThaKJqklY9Pzkjc+gbMpETTX180LrquRdm6FTUOMDe1taOS3LNjlDWKLOgH4BGSQ8F4l3Ohqj3LpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aQ2ZW3WX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQ2ZW3WX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122B9C32786;
	Tue, 30 Jul 2024 00:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299731;
	bh=ZpLK4fpzz73Rjb0WhopjlBg+CKpU4hdTuGXklsjF8zw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aQ2ZW3WX3BsupNBcckEYBmSYrrzeLQ4RnELSHY+QzmexFm3Oue4u3ARGrR5a+CwQa
	 JQjwGJ+2hx64hdrXP++ukGbttSEPcrSq7EabZcnGzmB6pGwo/Lyb5e3btQ+pxITyX3
	 +SXxDspzWyjNDQX4+N3eF45AQfhBPW4zOBDi5bXeTRN/7HtIGWV6k2HbMxQl3s7HdN
	 KQcovZnihdGrmw1h5vzWfxiAe6BeSZR8rqXnAnr+HWzrAbb6w0zSsr2E5GIkZWWyGi
	 LsfUwdqp4DiAe124ol1VHaUs2tAaWqv1O0qUnxo0tivP47tMu1YfrZcIa6oendNbAM
	 ImHCBKLgEDYqg==
Date: Mon, 29 Jul 2024 17:35:30 -0700
Subject: [PATCH 045/115] xfs: rearrange xfs_da_args a bit to use less space
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843076.1338752.13895998587215955301.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: cda60317ac57add7a0a2865aa29afbc6caad3e9a

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
 libxfs/xfs_da_btree.h |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 706b529a8..17cef594b 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
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

