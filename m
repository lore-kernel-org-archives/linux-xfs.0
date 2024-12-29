Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E127172767
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479609; cv=none; b=p5T1YA0ixB3bG/Y1iKdlKxnZx8QlnHNH2E1aw3yFSL8oYc2rcY/ZevtU1rzTRULsT5+sk97NYPZM65tE27sw57uJKm4t9gpT7FeoO5th2xUMFmyGXo08sAfWsLjlKbHBgtzi5QNdq5WDvaROwBPBbM3u4dqR/SBoUtboIKf8S/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479609; c=relaxed/simple;
	bh=ar1k2/FktHgAAFIVZAcUmwjkf5d52p2g0CTD+fKLkMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pp+q0jK2nOXu69qNCyUVDA/BoUFwmq0jd7TEr/NzALY7VVRLYnh/N5FLxZ8LTIaZvcwHrtYt4nObMRIeJ2gqq6jyqMNaYM1lzdFjJfDXBcOVhkC62sKCDJSwTUHVgT0nOo3IsFztazlujVl+YTswBbBfPS5ydcJtjWjhN4I2Y4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a91KL4e8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a91KL4e8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J5cP+QZWQKVsyjYSN5k7dzWdWw44VtuDeCRQbuPFX0g=;
	b=a91KL4e8eygEcz6FYA+8DtwaumShaiTMTNZc3ODhOcX50AdYl/fBGmfyz4D1Qy7wbgsnA0
	4jkpZixxbJe6uBmWeVnI5i9ZiCOmxdLvLgVityCAwJovhNyTptYCoxNNM8TXRlICq7EB64
	VopJthjqWesO0wH+24TlNT69Hlu2iN8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-nSuT23LzOhqdCZ6Po9ykvQ-1; Sun, 29 Dec 2024 08:40:06 -0500
X-MC-Unique: nSuT23LzOhqdCZ6Po9ykvQ-1
X-Mimecast-MFC-AGG-ID: nSuT23LzOhqdCZ6Po9ykvQ
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa66f6ce6bfso624232266b.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479605; x=1736084405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J5cP+QZWQKVsyjYSN5k7dzWdWw44VtuDeCRQbuPFX0g=;
        b=S1VEssHMIXVbVAUDIndUGyB/1NesqRjHmAnxwF4R+cjcctMqjolgc9rshYHxe1kYg2
         ZZnKPp5XeL8eRblxlRUxqiAMzT/z+jUQnU33/tfzo35CViX4+ydLfnnh8owi5sH+/XH1
         OjX30BEkm5D658gqAaSyYCfrPnmX/70xmh37LwVhg0y7LgvogK1QCRseN/Y/rC9FyI4X
         SH4qE4jEpp9Cde4tpWAAcSuh1sOP3JZhUhHD1kcpaG6Mr8jlZg1eA1e/QhWKKk0fQf95
         rewSMo0s/2iu0w1AcxuZP2J6ZjS+hOGhPF02pKRwTojp4tc3wZb6mXEg6WSTBV0tMhSY
         Lt/g==
X-Gm-Message-State: AOJu0YzUYJrnhSwHhhLqLQWyD2Yl+v2AFb6nPdvq3AobS7TggoV5b11p
	xvasxHHV2FrsDwSR9ENrdn3T3T375ShVIYNlAsoFsTOr1bT1QZ5WcuU6zuS8AEpPow2TMHZSgZe
	ULjAnJFX2F+7h/FOfDO8mNqrA492LWqLOYzcMusY1DPu471sg1eDKqjAwVxfaia8SPF+l9WZdbJ
	AENKFtRdsClb0IVchBIIkQvbUGjzOigdGKGty4ND8S
X-Gm-Gg: ASbGncsSZV9WBlyrg921T2NFRrOnJbhRiL08N1KeWg6+9oIDdzYc5CHrjL582cnOs8s
	Xo3AIAFcPJ61DS5Sk+GqXf/qDehK1tA1UDLuwzfWpnSxD0DHYhP/BZf6NQmXH6jCf0CFP9zUimF
	Edou8xIZWaCOfqBEBPzPoWbnrJDZ1YVsKHTYGtw3ZtrRntJkXZfX5CsGXvXmCO2TN8PN2N5q+7f
	/ACuj7t3g45bJd825bnir2yaWH7HYxgtCu3ezghwpnFQqSModuQajqqS2tFVRU9+CoNjYUTZX4M
	C//bvGK+iqPUl8s=
X-Received: by 2002:a17:906:7314:b0:aa6:8cbc:8d15 with SMTP id a640c23a62f3a-aac2ad9e06emr2706267466b.14.1735479604631;
        Sun, 29 Dec 2024 05:40:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHP2U/7oLFtoQ08rBDq9ryh04pkSlc4zo/DAqh+/5wuZ7zAW9M922x7J9FSH1dC9Ep4uTZaOg==
X-Received: by 2002:a17:906:7314:b0:aa6:8cbc:8d15 with SMTP id a640c23a62f3a-aac2ad9e06emr2706264366b.14.1735479604195;
        Sun, 29 Dec 2024 05:40:04 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:02 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 13/24] xfs: add inode on-disk VERITY flag
Date: Sun, 29 Dec 2024 14:39:16 +0100
Message-ID: <20241229133927.1194609-14-aalbersh@kernel.org>
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

Add flag to mark inodes which have fs-verity enabled on them (i.e.
descriptor exist and tree is built).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h     | 7 ++++++-
 fs/xfs/libxfs/xfs_inode_buf.c  | 8 ++++++++
 fs/xfs/libxfs/xfs_inode_util.c | 2 ++
 fs/xfs/xfs_iops.c              | 2 ++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index aefeda01f60f..df84c275837d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1215,16 +1215,21 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  */
 #define XFS_DIFLAG2_METADATA_BIT	5
 
+/* Inode sealed by fsverity */
+#define XFS_DIFLAG2_VERITY_BIT		6
+
 #define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
 #define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
 #define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)
+#define XFS_DIFLAG2_VERITY	(1ULL << XFS_DIFLAG2_VERITY_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA | \
+	 XFS_DIFLAG2_VERITY)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 424861fbf1bd..9ba57a1efa50 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -726,6 +726,14 @@ xfs_dinode_verify(
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
 		return __this_address;
 
+	/* only regular files can have fsverity */
+	if (flags2 & XFS_DIFLAG2_VERITY) {
+		if (!xfs_has_verity(mp))
+			return __this_address;
+		if ((mode & S_IFMT) != S_IFREG)
+			return __this_address;
+	}
+
 	/* COW extent size hint validation */
 	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
 			mode, flags, flags2);
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index deb0b7c00a1f..d2bbb4ca1ecd 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -126,6 +126,8 @@ xfs_ip2xflags(
 			flags |= FS_XFLAG_DAX;
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			flags |= FS_XFLAG_COWEXTSIZE;
+		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+			flags |= FS_XFLAG_VERITY;
 	}
 
 	if (xfs_inode_has_attr_fork(ip))
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 207e0dadffc3..47203b8923aa 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1286,6 +1286,8 @@ xfs_diflags_to_iflags(
 		flags |= S_NOATIME;
 	if (init && xfs_inode_should_enable_dax(ip))
 		flags |= S_DAX;
+	if (xflags & FS_XFLAG_VERITY)
+		flags |= S_VERITY;
 
 	/*
 	 * S_DAX can only be set during inode initialization and is never set by
-- 
2.47.0

