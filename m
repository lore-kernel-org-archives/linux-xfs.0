Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F165F17E00E
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479607; cv=none; b=mi95gGepapVNxcCbiFDyY3P+ShTvEQT+ZH4d/CkYVaaylywjZV4T3RcmqFfiSajPdTINtNtG84xBsiQ4Q9/o7jbe5ucx4OaF1FqN4Zm0+QP/UHKFA3Hd+T9Aoz/zQMWGoQu4MO92rqB2a9KinVOaUQXYBrECLX95K+uy4Fg+chc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479607; c=relaxed/simple;
	bh=mX0ZmjIkN4wXiz9FOHYvuCekEqK/zLaegkzWaxEbLs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyuBYiuMjDG3UpFPclhRjsaKRNAqubnfKDTLzZdpF6o6Z6zr7GSBB5/qKFwoii1XxSvoeLqFFLe0HhXhP/LNP6OrUzl2xadBhjN/bm9KI2ax+VD/nlsMazU/JPN1NN5XahnS3bwKSiowYm+7xuVcNShyYMcl56ivqVDEQMv6m50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gfsX0HLk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gfsX0HLk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EfzzENznNjiArzXXpC/lPrIcwVfvkYN0yXyHZK/T2KY=;
	b=gfsX0HLkykLyLqQfukTionFT4wLzbzVCC/BbmsON7NFunZs0xe8ICfaSwWMXvFofE1DPyn
	NdYtsYKVMEf3ostT4QZzuHy90TX/NqtNZDXlyS2cYpgIj0L+TiLBbX7vSfMWyD0r9YcPbt
	/yT8l3t8blAKzyBHOvTZPzkBk/tsRVE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-7M8Xzn2uM02wmF3qEhE0_Q-1; Sun, 29 Dec 2024 08:40:03 -0500
X-MC-Unique: 7M8Xzn2uM02wmF3qEhE0_Q-1
X-Mimecast-MFC-AGG-ID: 7M8Xzn2uM02wmF3qEhE0_Q
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aa63b02c69cso116626666b.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479602; x=1736084402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EfzzENznNjiArzXXpC/lPrIcwVfvkYN0yXyHZK/T2KY=;
        b=EjYKFYEa9XzTJK8o+fVaYms7VY2I2xOD3qcnB+Su2uOhxpZxgETwzPge7CeoWvRbsg
         ZJXAJFHsNiZ193PZZK0Yt5QczKa0O09ucWo2g4ncCmk4JbZVbwAK+0I2movbRFjtZTbL
         o1M96ECX5rIfJLeyK27wTPRP/pAfec5YU7lszEf8K5wkpuO5jjYi2h+c1cRqtLZDLKYN
         fvKCwNJcZPtwfW9ZZuQ11dAPyFIYbhEcky/ndoBY/45EMD74J1sVlQsslxYuM4OMvfsf
         LcU+Mf2UDiJNXJvQfm9o9kZ26o0axk3OkilNBe5To4sdGnyX34nNbB1MNUjT5+L6yKsr
         caBw==
X-Gm-Message-State: AOJu0YypDgug6OyoVyAeOCDSoJqjbi8hiPlMX27GocRERo4jiJA0A95z
	up1PQYDwyrRvFw4umVddcmzHfQBQR8Ycs8OetK7vmeE/7hkmeFkfKYL+PshI7huMwinQfx8coi0
	AkBXUwoS31/Pi5KPco/m0zfPmdhTsFymtzIvNQcuRO6Mcq97zr3cYnPElTjcS7bn70A8iEr10AS
	wht7nVcNK57eSUFshVNJ/Td9WbirjOsEjwjwJGg56Q
X-Gm-Gg: ASbGncvMri1g458R8G4L2J7EBUgfyZI0D6YvqgcJuhF6x4iXD+rZE5Tl+wkJSKVwAR+
	KPmAWYKvqY+8UzAAF6H5QkpGU+7JhE1Izg0wj6asbM8UjAK0DUtskUSKZ171BA/QXJJnXtlHgA/
	A+utHA69+tdSNYS6Jf7sD2qWsM5n+b85tjr1ojyTYGJwe9vII9yECozcCf20TOAgxURo81hco4v
	lKxaXYdBWURIImaT0fXAbpuNbTMGQdZ4MQkGkWRtktWlrpvtSQVo3QqqnY4YYib5Lzz87soajI5
	caD0ax3pd3wIh38=
X-Received: by 2002:a17:907:2d22:b0:aa6:acbe:1a81 with SMTP id a640c23a62f3a-aac0822b57cmr3499862166b.21.1735479601731;
        Sun, 29 Dec 2024 05:40:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IESiVurSjCHap/EpvbDpF/hykMB7e+RDuTG0nXUM2jmmvlh2shxU4YyohiAym6IDLMInwArOg==
X-Received: by 2002:a17:907:2d22:b0:aa6:acbe:1a81 with SMTP id a640c23a62f3a-aac0822b57cmr3499859766b.21.1735479601387;
        Sun, 29 Dec 2024 05:40:01 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:00 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 11/24] xfs: add attribute type for fs-verity
Date: Sun, 29 Dec 2024 14:39:14 +0100
Message-ID: <20241229133927.1194609-12-aalbersh@kernel.org>
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

The Merkle tree blocks and descriptor are stored in the extended
attributes of the inode. Add new attribute type for fs-verity
metadata. Add XFS_ATTR_INTERNAL_MASK to skip parent pointer and
fs-verity attributes as those are only for internal use. While we're
at it add a few comments in relevant places that internally visible
attributes are not suppose to be handled via interface defined in
xfs_xattr.c.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h  | 11 ++++++++---
 fs/xfs/libxfs/xfs_log_format.h |  1 +
 fs/xfs/xfs_trace.h             |  3 ++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index ee9635c04197..060cedb4c12d 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -717,20 +717,24 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
 #define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_RMCRC_SEL_BIT	4	/* which CRC field is primary */
+#define	XFS_ATTR_VERITY_BIT	5	/* verity merkle tree and descriptor */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_RMCRC_SEL	(1u << XFS_ATTR_RMCRC_SEL_BIT)
+#define XFS_ATTR_VERITY		(1u << XFS_ATTR_VERITY_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
 
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
-					 XFS_ATTR_PARENT)
+					 XFS_ATTR_PARENT | \
+					 XFS_ATTR_VERITY)
 
 /* Private attr namespaces not exposed to userspace */
-#define XFS_ATTR_PRIVATE_NSP_MASK	(XFS_ATTR_PARENT)
+#define XFS_ATTR_PRIVATE_NSP_MASK	(XFS_ATTR_PARENT | \
+					 XFS_ATTR_VERITY)
 
 #define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
 				 XFS_ATTR_LOCAL | \
@@ -740,7 +744,8 @@ struct xfs_attr3_leafblock {
 	{ XFS_ATTR_LOCAL,	"local" }, \
 	{ XFS_ATTR_ROOT,	"root" }, \
 	{ XFS_ATTR_SECURE,	"secure" }, \
-	{ XFS_ATTR_PARENT,	"parent" }
+	{ XFS_ATTR_PARENT,	"parent" }, \
+	{ XFS_ATTR_VERITY,	"verity" }
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 9f1b02a599d2..1d07e12a9a30 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1045,6 +1045,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
 					 XFS_ATTR_PARENT | \
+					 XFS_ATTR_VERITY | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5c3b8929179d..de937b3770d3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -103,7 +103,8 @@ struct xfs_rtgroup;
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
 	{ XFS_ATTR_SECURE,	"SECURE" }, \
 	{ XFS_ATTR_INCOMPLETE,	"INCOMPLETE" }, \
-	{ XFS_ATTR_PARENT,	"PARENT" }
+	{ XFS_ATTR_PARENT,	"PARENT" }, \
+	{ XFS_ATTR_VERITY,	"VERITY" }
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
-- 
2.47.0

