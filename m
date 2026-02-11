Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0813344044
	for <linux-xfs@vger.kernel.org>; Wed, 11 Feb 2026 03:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770780582; cv=none; b=J1I5MjAoTOT1IOogKr42w8udSfHsFlXkNzO8zmBhhBu09XI6+lvUiwNvQM7DL8ozM5lkjY+3gXKhFNHREE/VEUwDIGbJFDshx077Kvqpk1u4+JnbCHqo+AtMJt9IzZbw0pVD8XGhFbxPlikTCzexkvF5FEknqAm8e1ZfPzfL+90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770780582; c=relaxed/simple;
	bh=LEWKl1EusnsoCVOCGkkD3zuIV7Myuv/JJySiflQnLR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pye/cGNqlWKMEpoF6LUJkgm38ENHWRAp7CnE3l63ctv/Ci06O5LsnDFLx6CJ4Ozq3mNDgzxDU0JHcQYEXXTR90rRrZtYoKXylf3As1L34If3tB1B5SgFVFBKMvFpSBoqIwn2Htrklis0fxnCDKYDp9O45u/jKpa9cQdILFpLFG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LpK2WvFt; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LpK2WvFt"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8249aca0affso179556b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 19:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770780581; x=1771385381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xCVntle00304lt8vmoDLORT430txZdDpjlJMTS+t+zI=;
        b=LpK2WvFtb0gIc3CpMvOtclYeasXQmPTbQtxdsg8YxByB5jn8iPuq3TAumgxRtMdXx6
         etlaiwu4tkrSYjwAgqTcKIBO5KuwuPvc8ZMTJ8rAzv8AhX8WDGOzXZR7wCi1Fgqrx7X5
         FkEapjvYiyFixKV4/zdszIo5vm2C5KICaF78QwIV3NRx6YPZb4KvOxOhQPRggxKpiGJ+
         ueNgeG+YY/ovDeYt6DvWtHNhsPSbX/hin0lG8j7RdYiqMM85bbozv2LLjFurshXLv/cz
         c28PFGxVeGk/H79JV6ZDaF/t6nlF3D/XgxI31vODOIOH4lOYlYtcKcmoCiiSk8FTw4Oy
         GcmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770780581; x=1771385381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xCVntle00304lt8vmoDLORT430txZdDpjlJMTS+t+zI=;
        b=P1NqGSzu22NsRXTdMj/Ke5mfFBAc9wMSpbeMsh4R3vSJ4zGCGLVGXrOp4zd9mrU1/e
         ondN0FnI8S8Spr9h8ypLGoVvvOEKorChjwC97W0QAKEvcfkqbFBE6xr4dJsr2NTP5XgV
         1HHGG8ty89c+76fM0QKIkS98GMj158hZM4gYQQzrruJnY4f95lrJmvEtvZxHLpkc6dPo
         YwVuBVPPFpEysRG3FycpSFQzqKoR5oAiYpV6aHG29KMm2HGueEFzwt5aag8xs5IVzIgw
         ogEdRE4/FuTGalebj8lEQVtxdltjO20ntwZ0wjsF13S7ntCjvyFfP1ZgCQYtvh/e8X5B
         A6Zg==
X-Gm-Message-State: AOJu0Ywm3QDXhFzgD5UKyaf//8VhcGaNu9xjwxXsA90zHnTjibTLj+6+
	ywtOGZga2j4+BtkVTzPodJuWaSuDkWWECtjpv9Ux/zChxoZc/fcAE5/DpmgewxMo
X-Gm-Gg: AZuq6aK16ItgJXJEEM4EILNgBgWK+F/M6faVgwHAX2euIQJquo9lR41QZnO+2TWwGh/
	IDEUdAQwu71LT66izO8w2SxNPfRR3Ybk6aFAn45rO7nXe43qFbMpwU5ye45PvKMWMnTwADOJU08
	noZu1M+tB+QPqjRPUmekyf7JacIy/00jRTSazHnhhq52CoiYzGhSTJZdkLtDDy40T0RJKLrgffR
	EdSyYHXPsxBbdYNv4p/WgzH90+n9LQNpPnLKFYOuZwEc1uOBzkL3aGGSjM/Rr61d/y6ppd5Zn5K
	AJS1ebfcCKyfSnNByO4Hr0yM4X4nXzFq8I2dcNTuS6kTx2ZCfxSy4tbvmUkhXeuM6vT/Gi7nVW/
	9SgayL+SXeYG25TtH/agk/MGl6t30J22joalxFJyM0Vwgf7CqSqDoPc4jYLl/tqhqqey9xUfPx8
	S+IZ5dhxRk8FlrHeUdgHzP3fc5fzyLXWYMhYiIkLmKr8ItohssmX/3lIW/EdTo
X-Received: by 2002:a05:6a00:802:b0:81f:9bdc:9ef1 with SMTP id d2e1a72fcca58-8249b1454ddmr1325281b3a.69.1770780581046;
        Tue, 10 Feb 2026 19:29:41 -0800 (PST)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e8473fasm439521b3a.55.2026.02.10.19.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 19:29:40 -0800 (PST)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH v3 2/2] xfs: add static size checks for ioctl UABI
Date: Wed, 11 Feb 2026 13:29:04 +1000
Message-ID: <20260211032902.3649525-4-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260211032902.3649525-2-wilfred.opensource@gmail.com>
References: <20260211032902.3649525-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

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
---
V2 -> V3:
	- Drop excess whitespace
---
 fs/xfs/libxfs/xfs_ondisk.h | 39 +++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 601a8367ced6..1914ffe59202 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
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
-- 
2.53.0

