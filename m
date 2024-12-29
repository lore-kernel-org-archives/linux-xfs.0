Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E623415820C
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479606; cv=none; b=KX5dz6T5QJ/SrUpHtEbphPV0X+kNplOE23vo0Pg4O6EcjYD3/JsHOhYLKGhFk1MAGy4/CsxKZ8VaSSnPOxqVv2PQttLwo0/n4rPX3q3Y1kSdcHuN1IMKwrQ+a7ntyzxhtcM6bsfzoJ7iIo+aZ/fGKd9fefynHTroXTN+gdHLwzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479606; c=relaxed/simple;
	bh=SX7S02qPBMQobYOitruwdNBmCawcJJlvEKSGyl7lh5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etiuCu+fAPBjUaFWMpRC86wDrHbaOqDmB81ndcf/VVkpLCsqKHpY9OVwamYYahswL9q6OgmPqeMhOALdLb4oCKThXRLBEoVLrIb9/7JK2+j+yj1Qc7h9tahqCjb/CZyX5G9n/+0xSbUHxvm+62qIvQ3u4XvVGZiUIzYJwHK5XVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DBe+Dqs0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DBe+Dqs0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f8MOnnCVLq3zKR7sisANDSKCrP8PowsY4sVfHwdkRZk=;
	b=DBe+Dqs0OuyDzgwOz7m1SPrE3Hr6Tg/PGDjg6zC84vVrH96gzDocPY3mJ2cG7WDfq8XOwz
	QRWg5JSKD4s6TWC26c85KLv9IJiWgiUG7LRojl/dI0i6oacB5NvRFExYmhYc+Za/9nK3lT
	WcF8A12IDX0oO/MPCbXL/0IxKtidFmc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-AyubXBbZNt-VN4wzFY5TXw-1; Sun, 29 Dec 2024 08:40:02 -0500
X-MC-Unique: AyubXBbZNt-VN4wzFY5TXw-1
X-Mimecast-MFC-AGG-ID: AyubXBbZNt-VN4wzFY5TXw
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa6869e15ebso131640366b.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479601; x=1736084401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f8MOnnCVLq3zKR7sisANDSKCrP8PowsY4sVfHwdkRZk=;
        b=cc32H80Q1BQ8Uu/fCvbwHl5oOHA9BvomG9fagkPYmOjZuta041CRsanxaR22MeF3pF
         7M57PoxTiugf8p7xAsDXd9bhGdfJat/R0gygrg6mZd3bkFgZhmhlOT3Mne3us05n1Zfd
         /yoet/VvpFDUYoQ8/w9rAwDrQpFabkVjadsfaVTe0GloxZVbUU9EIt165BblfErFnLMI
         Hk2lA3M37V9MOo5/pTvXV6Z982+SjYQqH3yD7lsqTEq4raRIiJpYlxUQZnXiGGQ8VZCm
         oxpw6fdOy0/iHmNXFjfzIIiPnp2SjmpAoqJxxTvmen4CP2VRZXUQAmURUEXRbuhQ8KLy
         TFCQ==
X-Gm-Message-State: AOJu0YxSRgr4FPTFl7zw7gAKAIQLaoK4Or34yATXlJ+ktKjZWLiRd2Uk
	A9KOwLp+ysfgUVTO55hxLmAb95greLdr8FjT/pQiZHPklAb1PpSGAY5l6AMRQDCsG//3CmpsWju
	yyrb7iCLRn6Qb25owYp7h4uCfG02wxJvBLXFACe3GFeLhcNIFHME8tLHVRH/FWS8IAvgDoTmZ06
	xxinG3vf66JC5dVHRs+4UItg4y5LxEIRWi1Kp1+URI
X-Gm-Gg: ASbGnctMeBJJWW0PnhQyVvJOkgaV0VjnrBHHnldNNVjO9ov9t5Zu8mHuncPrYG4QFFv
	OnXZL0xKDZEt2tZqrs3LFKzPUrMUZMytheGOM0PQG/v8zpzLE/PmuPZkW8xb+1N/z7xv3d/E+ac
	7QIGyGghtj1P5R1lK2x3jCi9kqoHJzTmSujoCw0spVJ3YtuFFPfBaD7K0Fc1TLeP9xZWJlq6RQP
	eTjRIHxyor6TdUBE3OiOJRoasqUkGiigt8PKYpN1ZnkIJbnnbxAjSx5mc41PN4M9nbqET/tlx5D
	XaugfBUT5ZKVuZk=
X-Received: by 2002:a17:906:478b:b0:aa6:950c:ae1a with SMTP id a640c23a62f3a-aac349cbbb7mr2849132566b.30.1735479601073;
        Sun, 29 Dec 2024 05:40:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGW/CzGG+m2uGEjhDWG5TWb/R9IaPMNPDTOXzmJG68jutOXSUa/mBqfarwNWEMgq/CbYXTEJA==
X-Received: by 2002:a17:906:478b:b0:aa6:950c:ae1a with SMTP id a640c23a62f3a-aac349cbbb7mr2849128666b.30.1735479600560;
        Sun, 29 Dec 2024 05:40:00 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:58 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de
Subject: [PATCH 10/24] xfs: don't let xfs_bmap_first_unused overflow a xfs_dablk_t
Date: Sun, 29 Dec 2024 14:39:13 +0100
Message-ID: <20241229133927.1194609-11-aalbersh@kernel.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

The directory/xattr code uses xfs_bmap_first_unused to find a contiguous
chunk of file range that can hold a particular value.  Unfortunately,
file offsets are 64-bit quantities, whereas the dir/attr block number
type (xfs_dablk_t) is a 32-bit quantity.  If an integer truncation
occurs here, we will corrupt the file.

Therefore, check for a file offset that would truncate and return EFBIG
in that case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 3 +++
 fs/xfs/libxfs/xfs_da_btree.c    | 3 +++
 fs/xfs/libxfs/xfs_da_format.h   | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index e90a62c61f28..2bd225b1772c 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -529,6 +529,9 @@ xfs_attr_rmt_find_hole(
 	if (error)
 		return error;
 
+	if (lfileoff > XFS_MAX_DABLK)
+		return -EFBIG;
+
 	args->rmtblkno = (xfs_dablk_t)lfileoff;
 	args->rmtblkcnt = blkcnt;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 17d9e6154f19..6c6c7bab87fb 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2308,6 +2308,9 @@ xfs_da_grow_inode_int(
 	if (error)
 		return error;
 
+	if (*bno > XFS_MAX_DABLK)
+		return -EFBIG;
+
 	/*
 	 * Try mapping it in one filesystem block.
 	 */
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 48bebcd1e226..ee9635c04197 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -748,6 +748,9 @@ struct xfs_attr3_leafblock {
  */
 #define	XFS_ATTR_LEAF_NAME_ALIGN	((uint)sizeof(xfs_dablk_t))
 
+/* Maximum file block offset of a directory or an xattr. */
+#define	XFS_MAX_DABLK			((xfs_dablk_t)-1U)
+
 static inline int
 xfs_attr3_leaf_hdr_size(struct xfs_attr_leafblock *leafp)
 {
-- 
2.47.0

