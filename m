Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98971FC8
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831771; cv=none; b=luksDoqooZmszwDI7AW1cQRXFftzgdfpl0nKhDDchkGLA3mwLPn+//v3G1nY0Re2jedWXZ3GPFL66IvDG+goqP0k6HT7K6uzhnf0qA+Ljhh8Qb8tO7ofLRjIiUHFpCTzdVDZuCUWqKM9Pc1Llox73WuyxYZzTH+flOFVuBGoLPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831771; c=relaxed/simple;
	bh=cuJj9ZzNw1LnzR9AKcS+wxCUGO85ZxKhQDOKYHweMhM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eu2KjmOrlDcH3yyXRI/LFY3UrfzrLMhRl0FZsdEHgX+jJaZOHJn6iIxDwZN01dKjUQCKkdNI1pfDwCqgrE5Ie5rfWPx48Mx+QSGcdf6y4LkHrMcPT573ymdTgWcDY8PeGmbzAeIKNS3hu94Bx/o4yZ8cgT93Mft6U5GTHRQ68qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=STXnozw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="STXnozw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829C8C4CECF;
	Wed,  2 Oct 2024 01:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831770;
	bh=cuJj9ZzNw1LnzR9AKcS+wxCUGO85ZxKhQDOKYHweMhM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=STXnozw5Io9aoiHfAWzBom7g4skTsP7BWokfn/QlMeWB7ZHRgvogWOUglAGr65Kkh
	 +OgpsMaBd40d8O+7CMdfZH1lxvCCh+lLfMP3qlhTRTwOkQ+jDV4CZBLD4AsCdmLKpX
	 cn78CPUW4sJgisWuZqAKMzLAmmwsEEMjOVN9viBd7wWhf0hV859lGYP6WHTs+v7J8J
	 4JLLdVIM2s+miWHGahzzfN1WUiON7EUF+uyadwSZ+GQ8A7bWx4ZpqJ9Sta7tptXaGh
	 EgqEt2hrh3VsnEa9VlO2Ay9yAhdek1+Lb4o1RZXz2ZJ4f66Wqv5VdGDL4Qh/q0yVIQ
	 eZsjOUH/IAepg==
Date: Tue, 01 Oct 2024 18:16:10 -0700
Subject: [PATCH 32/64] xfs: don't use the incore struct xfs_sb for offsets
 into struct xfs_dsb
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102264.4036371.14673026554207192697.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: ac3a0275165b4f80d9b7b516d6a8f8b308644fff

Currently, the XFS_SB_CRC_OFF macro uses the incore superblock struct
(xfs_sb) to compute the address of sb_crc within the ondisk superblock
struct (xfs_dsb).  This is a landmine if we ever change the layout of
the incore superblock (as we're about to do), so redefine the macro
to use xfs_dsb to compute the layout of xfs_dsb.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h |    9 ++++-----
 libxfs/xfs_ondisk.h |    1 +
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 61f51becf..e1bfee0c3 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -90,8 +90,7 @@ struct xfs_ifork;
 #define XFSLABEL_MAX			12
 
 /*
- * Superblock - in core version.  Must match the ondisk version below.
- * Must be padded to 64 bit alignment.
+ * Superblock - in core version.  Must be padded to 64 bit alignment.
  */
 typedef struct xfs_sb {
 	uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
@@ -178,10 +177,8 @@ typedef struct xfs_sb {
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
-#define XFS_SB_CRC_OFF		offsetof(struct xfs_sb, sb_crc)
-
 /*
- * Superblock - on disk version.  Must match the in core version above.
+ * Superblock - on disk version.
  * Must be padded to 64 bit alignment.
  */
 struct xfs_dsb {
@@ -265,6 +262,8 @@ struct xfs_dsb {
 	/* must be padded to 64 bit alignment */
 };
 
+#define XFS_SB_CRC_OFF		offsetof(struct xfs_dsb, sb_crc)
+
 /*
  * Misc. Flags - warning - these will be cleared by xfs_repair unless
  * a feature bit is set when the flag is used.
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index e8cdd77d0..23c133fd3 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -85,6 +85,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
 	 */
 
+	XFS_CHECK_OFFSET(struct xfs_dsb, sb_crc,		224);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);

