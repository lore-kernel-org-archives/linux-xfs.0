Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84434158858
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479608; cv=none; b=UAhhMiJW6KKIvE8vIrQ7eVV91Xd7CEe7BrznuJ+3Zbmnp+8c5ZZJ+9kcC9n+Y6h0moCuXl08ngdFIDpxBYVD0ZC5MHYmfcF+P0VjUuKH8DW6BA9Z6LmievnhQ32+yrkTyvB3piEwCaH0t/xBovppobGB2IPiB/ZUR8li7jFWrR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479608; c=relaxed/simple;
	bh=bRFtmwciGLkLnE3amW3DkrNNqSW4Wq2yLBfn5SeHFns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spSUh9aPcIduXKZzwHRDh92p0ostF1uHO8DVZihmL5HEh5tL9+fLZQkBNQDwAXdfGglFz6mOxMDzva9b3O7gN579R8Zt8MA5+Tlkale/DSy1qI5UK/xQX2Zff4u1xTVvVeDWp4H0bPMLdBj0++C+TICEpQ/2KcMPuVJmRgHmkug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dy8gSPLf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dy8gSPLf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/tOj4fSNP9GoPdgEKvzjKClHLkqzd6cbpBDc09lPS3A=;
	b=dy8gSPLfm2R1mF3Bz57SQ83VcEQEjpi2DzzLLF1jrBNHlgVfht5dEHtAE7qcpCfYdQh4XJ
	qbDwE8IYYg9aPIbFFImLjVU7OZG4joK4bjV55J335OHzHbO5H/5e9AMkWBGiQYqYr4GSKb
	vcKy+/8YKdh8R5mRHXWrTJv7IcSx6uw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-2U1DPFyPPI60M7KYG_Ldcg-1; Sun, 29 Dec 2024 08:40:04 -0500
X-MC-Unique: 2U1DPFyPPI60M7KYG_Ldcg-1
X-Mimecast-MFC-AGG-ID: 2U1DPFyPPI60M7KYG_Ldcg
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa6a7bea04cso243781766b.3
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479602; x=1736084402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/tOj4fSNP9GoPdgEKvzjKClHLkqzd6cbpBDc09lPS3A=;
        b=EXvmzX+XtiWRanCopMa/IHnQ0nlesR+B5+4m5IZsANDTGy5uXgN9pJjBFRx3Me8uh/
         kceAV8Wpnh+CAC3SGBHn5l2mvhVi4nuyC8Q8owvvCPIxtSN2pc3BqmpU0FXpGdp+Oh3a
         xHGGx9O48fRnroRj0LYssjGVqysHtJwIPYgr7RRLDVjsYwHlIvhJNxAUC6dISz5fUnrY
         YF3RU+vAR6CpDnjwSJH6NfgFpmQFr1q4DeZ7L2TxNE4V2Sm2RpqTj7kp1HCDUrvQqC5i
         DQbsYeKIT3dquViHSINmzscwzeoQn09S+O1X2lJHxXxZnv7fw1EK4ZdtCk8cWkLmD/Hw
         CZRw==
X-Gm-Message-State: AOJu0YwkYNZMzKlR3QsMQ6bO7HwBGPsI1z8m8xQB9DndtmE5nbxzPu8K
	ccv7hRwyFgcAfQqygH4/8/CjtFoqLUoBpdZbYXKkBT20mhvWXkqh1lXbfd6btnNb0wA5l5VXSbO
	D2XueoKbL0Bnj4HC/yHmsgUSYNd8HelnXxnAL74vdFRp/CAuxjLM74kKGmhiear6xPCc0vm2OpO
	kMA9mtJV91vsudgSHbp9tH44bjRIhS4SzApIP8d7ym
X-Gm-Gg: ASbGncuA9zaVf32oP7C3NU3YEN8PVBZCPcyu8B79uec3DXv4kpOIoX6Tm4E8LdBFyKZ
	nnWsycKD6i2LS9jOKqx1ywkoCKww0Bi5WrM33EqXWGy709D5NGeiCkExJfcUCTPGqFR6LUQCZBg
	633HDOpfGziKBuX5oHUNDnbYvaGoxb1e9ouEifc/4Vxe4S9GJVddpXRnkvbtQWRtK1gEMo8tU97
	+cBX0aR18HL2UjxAYdEQZLhZGJBgij9PKomldpnzFV/fEXSb0cjQnp3kOMKohXtneRigH7ZyoSi
	779qaSEHHE8o5mg=
X-Received: by 2002:a17:907:7f16:b0:aaf:f1a:d2ad with SMTP id a640c23a62f3a-aaf0f1ade0amr1304236866b.50.1735479602476;
        Sun, 29 Dec 2024 05:40:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG3Mlda80/RXUxGcSdIzyLpvbDO3719L/Gv9NTXhSWTa0dJDJQZESB9xr0XFQR3seuHjVuK3g==
X-Received: by 2002:a17:907:7f16:b0:aaf:f1a:d2ad with SMTP id a640c23a62f3a-aaf0f1ade0amr1304234366b.50.1735479602056;
        Sun, 29 Dec 2024 05:40:02 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:01 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 12/24] xfs: add fs-verity ro-compat flag
Date: Sun, 29 Dec 2024 14:39:15 +0100
Message-ID: <20241229133927.1194609-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@redhat.com>

To mark inodes with fs-verity enabled the new XFS_DIFLAG2_VERITY flag
will be added in further patch. This requires ro-compat flag to let
older kernels know that fs with fs-verity can not be modified.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 2 ++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 334ca8243b19..aefeda01f60f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -372,6 +372,7 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
+#define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 20395ba66b94..9945ad33a460 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -165,6 +165,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_REFLINK;
 	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
 		features |= XFS_FEAT_INOBTCNT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_VERITY)
+		features |= XFS_FEAT_VERITY;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
 		features |= XFS_FEAT_FTYPE;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1fa4a57421c3..dab6bc3ae0cf 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -331,6 +331,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
 #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
 #define XFS_FEAT_DXATTR		(1ULL << 29)	/* directly mapped xattrs */
+#define XFS_FEAT_VERITY		(1ULL << 30)	/* fs-verity */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -388,6 +389,7 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
 __XFS_HAS_FEAT(dxattr, DXATTR)
+__XFS_HAS_FEAT(verity, VERITY)
 
 static inline bool xfs_has_rtgroups(struct xfs_mount *mp)
 {
-- 
2.47.0

