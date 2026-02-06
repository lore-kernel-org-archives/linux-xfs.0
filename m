Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD87136351
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 03:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770347242; cv=none; b=cdO5CULJDsKy7ZOawUew+3Iekr0vEcMolWh5z3PKounhFHqbsD/91BzXhck1wKrMGomb7kmNIV9EprqVqoKPZsiTrO99QwkHLjkqnMqZQf/GamxbuMululCImlxvRyuCOpgoepsoVr9+ROU71KyGUISG6jU3V+HGbE8Lk6eh40U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770347242; c=relaxed/simple;
	bh=J/2AjULVPo7JxyW4cLKt3dWi5eq6Mmj+ADikJpFxrxs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aXYrRQmRbj5cyHm6bM2FpUI59Jd0wsnAH0PE3eP6UvUP2pvvGu/NYyKJjKhdeIFfI85euZNvtpmgAf1RNYRvY1rlq1bkNCVO5a/1ZKlP0FJn/L5vbAR1ufWznr5gnigIAgUQXV4orQelcFEXJ2YXxweDikiaG5Y1h2qqCCA0tNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B5yCB48O; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B5yCB48O"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a0d52768ccso10311485ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 19:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770347241; x=1770952041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NeCdDvONNGPVeboC3q1Jqb3Mi6sRaFCJ/jUEyGj5MuI=;
        b=B5yCB48OwyM6VD6nxkQTBHoZHBusC1RSn23Tp8f78UL8Izn3jHXLvl1BnBYw8XScUG
         +ja0GE7Mx8KR+5VNd1eRC1itcIbqFABtM8TXstN10QGOGkKJQSXzjmabKRPRO+I0q3BR
         SBE29ouXduIjClfBSWhCJ/pxw89VEyUynV9kl2geVmH/ApLwZgBuBIjus80As/qbQg1f
         Yu838lQz/wlwgkaVyfh2zGLC2fNdwpjnCzGIwZMXXhSRLwWzhYH9y7gGsCGCcrNh+3jy
         xgauueROn2Upg8kjgP/SAuJOovKO+Ds47AtOqZuO9p1x3Y/R1vaMS0m8kUx/aaBg2eRa
         cLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770347241; x=1770952041;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NeCdDvONNGPVeboC3q1Jqb3Mi6sRaFCJ/jUEyGj5MuI=;
        b=bfG8L21Q9wh90OVLnCMFEOZdrACy7weZH/h/T4kYGQk6bCWZbQit6+IRKKnFfwC5a3
         N+cfKQUtbFvCyvVwl4YeyUhWKYoEzWlGlNYFB5kgLo3seX4zPbVTdutprWyIIldS9+5A
         lUj83Pz7BVzKqahqqfnFwXojdqllejTIUT6ShDCkVzT4g0W4Lj6x9LLbOFvlOdf2QSCo
         ZQaZKKxVWoc1A8spUARlHYVSyLTrLw9lJyKqIRL4JUlEp/0phbhfgrMUXk/zFn2RDNOI
         +vCw8AssnWy+DTzm/JSj2ay6j9OPvJNwn2Ed/HLyihuQz1eThzljOGZqGhWP51nQq7O3
         fSoQ==
X-Gm-Message-State: AOJu0YyNQEHxBh0ZeawnZHWrpIQHtjkPuf5qd6+jwPNRB5BLpVjZLIXP
	dmppZ9iCz1T6WM2pOhSLwdobgFKEIH6EgVG0OdN4YMrgRJRFJ0/h69pU0oUc8qqQ
X-Gm-Gg: AZuq6aK1tqJyls8OtTFwY37Y286PjlTvY4boTK8slk5xqwLZybgf0xzeF2S46hsfJv/
	MSIJvI4uETzR8weupXn4ob+aA82Wt44mEBYCitiDDq/GpJTt/wTE8I7CW2hyGQLCU/ivOtNt1kL
	Ao/B0SuE8tj/QVHiVvZnquHhwCEye5H04QSMwTrh4qoiRsPgQu76IJf81IjHgajrPBgtNi3xscS
	LYm6TvlNM05UWRa2prr2H9vBYQwIiCUTnnrTH2ykD6ejbKFRka/vxDHDsuj75GZcDB8JIF7HF1t
	vRjLh4EvBHraPuUZw0jP1EcjwhjFjK9IpoaEvNDfZysCabp7wfezsedgUaUOeUca40FoPzWh37F
	gXQdqiAGO/DZpv/eXfWX7nbBS6t8HsrIIRtP53NPVPFiTq/jqL3QdStgbw7NSSKC21xiadZ2KDf
	AZ1vP33f405dVhET0V54nZHmT3NyrHRvRvm+Jhz77D7VHXLdR4nMQB+vDLp+9E
X-Received: by 2002:a17:903:2412:b0:2a7:90f2:2dea with SMTP id d9443c01a7336-2a9516f8bd7mr13167365ad.28.1770347241077;
        Thu, 05 Feb 2026 19:07:21 -0800 (PST)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9522121besm8194905ad.85.2026.02.05.19.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 19:07:20 -0800 (PST)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Date: Fri,  6 Feb 2026 13:05:58 +1000
Message-ID: <20260206030557.1201204-2-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

This patch adds static size checks for the structures in
libxfs/xfs_fs.h. The structures with architecture dependent size for
fields are ommited from this patch (such as xfs_bstat which depends on
__kernel_long_t).

Also remove some existing duplicate entries of XFS_CHECK_STRUCT_SIZE().

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
 fs/xfs/libxfs/xfs_ondisk.h | 46 ++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 2e9715cc1641..874c25cf9a4e 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -26,6 +26,9 @@
 static inline void __init
 xfs_check_ondisk_structs(void)
 {
+	/* direct I/O */
+	XFS_CHECK_STRUCT_SIZE(struct dioattr,			12);
+
 	/* file structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
@@ -59,6 +62,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_bmdr_key_t,			8);
+	XFS_CHECK_STRUCT_SIZE(struct getbmap,			32);
+	XFS_CHECK_STRUCT_SIZE(struct getbmapx,			48);
 
 	/* dir/attr trees */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
@@ -77,6 +82,12 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_hdr,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_map,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_local,	4);
+	XFS_CHECK_STRUCT_SIZE(xfs_attrlist_cursor_t,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrlist_ent,		4);
+
+	/* allocation groups */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_ag_geometry,		128);
 
 	/* realtime structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtsb,			56);
@@ -87,6 +98,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_root,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_rtrefcount_ptr_t,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrefcount_root,	4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtgroup_geometry,	128);
 
 	/*
 	 * m68k has problems with struct xfs_attr_leaf_name_remote, but we pad
@@ -117,20 +129,11 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_entry,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_hdr,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,		4);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,		16);
 	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, freetag,	0);
 	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, length,	2);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_free,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_entry,	8);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_leaf_tail,	4);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_entry,		3);
 	XFS_CHECK_OFFSET(struct xfs_dir2_sf_entry, namelen,	0);
 	XFS_CHECK_OFFSET(struct xfs_dir2_sf_entry, offset,	1);
 	XFS_CHECK_OFFSET(struct xfs_dir2_sf_entry, name,	3);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_sf_hdr,		10);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_rec,		12);
 
 	/* ondisk dir/attr structures from xfs/122 */
@@ -196,6 +199,9 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		40);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_by_handle,	64);
 
+	/* error injection */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_error_injection,	8);
+
 	/*
 	 * The v5 superblock format extended several v4 header structures with
 	 * additional data. While new fields are only accessible on v5
@@ -221,6 +227,28 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_flock64,		48);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v1,		112);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom_v4,		112);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fsop_geom,		256);
+	XFS_CHECK_STRUCT_SIZE(xfs_fsop_counts_t,		32);
+	XFS_CHECK_STRUCT_SIZE(xfs_fsop_resblks_t,		16);
+	XFS_CHECK_STRUCT_SIZE(xfs_growfs_data_t,		16);
+	XFS_CHECK_STRUCT_SIZE(xfs_growfs_log_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_growfs_rt_t,			16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inogrp,		24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulk_ireq,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_fs_eofblocks,		128);
+	XFS_CHECK_STRUCT_SIZE(xfs_fsid_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_fid_t,			16);
+	XFS_CHECK_STRUCT_SIZE(xfs_handle_t,			24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_exchange_range,	40);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_commit_range,		88);
+
+	/* scrub */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_metadata,	64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_scrub_vec_head,	40);
 
 	/*
 	 * Make sure the incore inode timestamp range corresponds to hand
-- 
2.52.0

