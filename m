Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D8E31D75E
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291811; cv=none; b=poEeLHePGKYl2JWd5ob0eq3Cv0dehBUV0MPmYNxbMg89BS98tuWcCmCZUmvIIlnVBZwkEms0kmPINnEzqy9WET2T7SVhoh/AREYMqQDYpoNfXrxpN83FKxNrm94ffmMzKruSWXuYWO2Ywg5qnFM95xTU3Yb5rxg81bX7AD5Q2Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291811; c=relaxed/simple;
	bh=NWj/trDcJrOxWcoSQSbf/Esc+iQTleNHRqwwAUb2lo4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IsVRL0y9hS/5ZOptJ/jD03zVhZ9Ps7daaXQtEDDwKAKBoHSwp+mVA3GDbD/avpGOaBKQt75nU8Vmxj/zxaMlGmDNnMKM2mRY0ajCpYxgH5EVY3FMwWMBQo7YO6ypWJP2bj8vdYcQ3X+TapNUPr51woRe608so5XccKdQ/336XgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dhbEejX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dhbEejX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9CFC4CEF7;
	Mon, 23 Mar 2026 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291810;
	bh=NWj/trDcJrOxWcoSQSbf/Esc+iQTleNHRqwwAUb2lo4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dhbEejX3qCbq+KV08X3VHQQ3eBWFFeq/vYbMAh5wtYnCYKmA7XXdUVIzNmdC6p5Ov
	 YWUm8NZ3zl6xA4ulcSVIXaLVlhzZjifhmM0FEPr8V2zsL9Xbka1d+SX3naRUnCLAt7
	 8vKV5sy5dBYGxSYi2bIOcRT52gzsVOfpujyPvmt22NbAW05+dACCu4nBoXpm+OS+xn
	 3j1w19TyKsCISCezwX3Xq3yAvbufmnfmQCrQeX0xVjfDS/DyGulEhbg5HAaeHhwqDk
	 56gFFUxbpQxk65R48o/h1jSpUY3TEQzfm54Mmk7vuU5ROSq7Zw83YsZoPoXRLWaI/f
	 tBwNDWV8Ws47g==
Date: Mon, 23 Mar 2026 11:50:10 -0700
Subject: [PATCH 34/40] xfs: fix code alignment issues in xfs_ondisk.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, wilfred.mallawa@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <177429121365.2266274.15980468196738514244.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Source kernel commit: fd81d3fd01a5ee4bd26a7dc440e7a2209277d14b

Fixup some code alignment issues in xfs_ondisk.c

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ondisk.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 2e9715cc1641df..70605019383c32 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -73,7 +73,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free_hdr,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf_hdr,		64);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,	8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_hdr,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_map,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_local,	4);
@@ -116,7 +116,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_intnode,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_entry,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,	4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,		16);
 	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, freetag,	0);
 	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, length,	2);

