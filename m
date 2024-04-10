Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A530B37C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710223; cv=none; b=B7IKIzOQ022IuVlJ2YauS0LSC7bS9ZO+7NhaVIxJ9CiHSp+lLnpRtkBCVe3uTHfjLp7zSPIlSi/E0655SHFvCF37MR0v6c7jGoPN7Hsmzr9LoHhvG6EdcN7OPctfZ3gS8NgnNDmYQ4hpWvtzgSQir0j3gs6sicx0gfItYmEKV9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710223; c=relaxed/simple;
	bh=owgu+1GP8mn/VU3kItW09DSrnVEXJqMZp+reHppTJg0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HVLQovzlaBee5JugQsj3Dzb4IjX7lLy1C+mq9cdwj3ujXI6uP3DKyzk41KXFHfeAkICc8AkmwhpINk83lIzHlID78zIru9OMMUFq11AxScU7RjmKqQxK55Z7DwR0nTK4PF3wD2wIRXx7e19Ke3C8EeF9+QHjPdxu9YibL6/lELQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LeUZKRrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LeUZKRrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A06C433F1;
	Wed, 10 Apr 2024 00:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710223;
	bh=owgu+1GP8mn/VU3kItW09DSrnVEXJqMZp+reHppTJg0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LeUZKRrTt6E3Q5TMVhcACp5xKVG7pBJOIz5UMccjSWr3qlaHvvzvV4BpAVgrVIqQU
	 d7IlugLuSFYwhLl/H6NdtH/eS6GHfmf1TzEulBpFMNCV4+ZrpS1HEcUvsHKmBHFnol
	 K0K5TyKF2Qqsx6/0clmunddnmPEwMZI2j8tOPj/X3xONGgxAyWDkaIADV7RqNxunLV
	 +Vj1zaxvkQtqddS06RHYmT8UBhH9/hc+OSUtMMt7khhe2zEZ2Ok0Kfak9k12o1u/bD
	 uXq/i418WGH291lbk+81jpV/CSKvN0+9ts+m+Tb2Ok+wnA6UtUcFMy3enR4mlBm2KQ
	 FwkxRNVpTiJeg==
Date: Tue, 09 Apr 2024 17:50:23 -0700
Subject: [PATCH 4/4] xfs: rearrange xfs_da_args a bit to use less space
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270968452.3631393.6758018766662309716.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
References: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
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

The XATTR_* flags only have two values, which means that xattr_flags
could be shrunk to a u8.

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
---
 fs/xfs/libxfs/xfs_da_btree.h |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index e585d0fa9caea..47485f5edae86 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -54,17 +54,21 @@ enum xfs_dacmp {
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
-	unsigned int	xattr_flags;	/* XATTR_{CREATE,REPLACE} */
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
+	uint8_t		xattr_flags;	/* XATTR_{CREATE,REPLACE} */
+	short		namelen;	/* length of string (maybe no NULL) */
+	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
 	int		whichfork;	/* data or attribute fork */
 	xfs_dablk_t	blkno;		/* blkno of attr leaf of interest */
@@ -77,9 +81,7 @@ typedef struct xfs_da_args {
 	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
 	int		rmtblkcnt2;	/* remote attr value block count */
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
-	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
-	xfs_ino_t	owner;		/* inode that owns the dir/attr data */
 } xfs_da_args_t;
 
 /*

