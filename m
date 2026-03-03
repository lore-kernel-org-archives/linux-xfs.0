Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936F05474F
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497294; cv=none; b=FYvWUIb3Hjt13XuYi4hHUDWGbHYUDC2x3f1i5qltP3wUiOmmBrpONHQW8x9g+8vVV9r8PfCyNlJPjYWOXPv7hPCR1ueMLp/yKm37Mxf/VCwAGK1+kdWwYC7HHNR4dXb0udP4Ggi3hq7BWk7sdpYhiXlQA8JFTNW4YQuwtSIeCKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497294; c=relaxed/simple;
	bh=oXqvibuSAihRzyWnUqhR0rN9FzGrRPIgXiI9I7tsUcg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qh9MtO2y7padUni0Pbwc+XASoChqruGQUrtldF2sVHG8kmUuY3ewQ+ygh93DONRQZAmMdeqPbV4vj2Zy2zenMuZogcOLqz/+gR6q1f6gmNuLxpYCdkshviXy30QcCGFWNh7MVCujyzNpVCOPPv7HN6GjbbJ6IZzpNoAUe6+bO2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIonhClm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIonhClm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF4BC19423;
	Tue,  3 Mar 2026 00:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497294;
	bh=oXqvibuSAihRzyWnUqhR0rN9FzGrRPIgXiI9I7tsUcg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AIonhClmJMLsnIYnYEdhbu+YTvxNvJgtOl2X/jipqhksQ2CrXrTgWTvUCNhRM58VF
	 oyHxQTwJ9Efqwa+UDp6IqycILoBMX5eqY1zUF5owWvcSMgYShEp5prhBuANbUd06II
	 hisG4foq1PbJ99Rre8VIZS7dBjYaAfCMyg5nJAiOv2Mo0kIe1an14UGqv4iGLSFzo4
	 j7je/FXY/orIRmZlA5aOZwgRRnCn8SrL+hUKbhp03Fsc7E64P8iOR6oLj0RbJUCfI5
	 JFqvP2qeCpeNERTG3f4Th5ZHfki2sjxpXGSFvvk+FWRvQp0FYJZlWnHbwpGirFI5mM
	 nS7zcjrFfBbDw==
Date: Mon, 02 Mar 2026 16:21:33 -0800
Subject: [PATCH 36/36] xfs: add static size checks for ioctl UABI
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, wilfred.mallawa@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <177249638439.457970.15320050232395811419.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Source kernel commit: 650b774cf94495465d6a38c31bb1a6ce697b6b37

The ioctl structures in libxfs/xfs_fs.h are missing static size checks.
It is useful to have static size checks for these structures as adding
new fields to them could cause issues (e.g. extra padding that may be
inserted by the compiler). So add these checks to xfs/xfs_ondisk.h.

Due to different padding/alignment requirements across different
architectures, to avoid build failures, some structures are ommited from
the size checks. For example, structures with "compat_" definitions in
xfs/xfs_ioctl32.h are ommited.

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ondisk.h |   39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 7bccfa7b695c95..23cde1248f019f 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -208,11 +208,6 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
 	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
 
-	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
-
 	/*
 	 * Make sure the incore inode timestamp range corresponds to hand
 	 * converted values based on the ondisk format specification.
@@ -292,6 +287,40 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_SB_OFFSET(sb_pad,			281);
 	XFS_CHECK_SB_OFFSET(sb_rtstart,			288);
 	XFS_CHECK_SB_OFFSET(sb_rtreserved,		296);
+
+	/*
+	 * ioctl UABI
+	 *
+	 * Due to different padding/alignment requirements across
+	 * different architectures, some structures are ommited from
+	 * the size checks. In addition, structures with architecture
+	 * dependent size fields are also ommited (e.g. __kernel_long_t).
+	 */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
+	XFS_CHECK_STRUCT_SIZE(struct dioattr,			12);
+	XFS_CHECK_STRUCT_SIZE(struct getbmap,			32);
+	XFS_CHECK_STRUCT_SIZE(struct getbmapx,			48);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_cursor,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_ent,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,		128);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtgroup_geometry,	128);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,	8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,		256);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v4,		112);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_counts,		32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_resblks,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_growfs_log,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulk_ireq,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fs_eofblocks,		128);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsid,			8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_metadata,	64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec_head,	40);
 }
 
 #endif /* __XFS_ONDISK_H */

