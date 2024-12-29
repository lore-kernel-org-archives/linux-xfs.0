Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF607157E99
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479618; cv=none; b=ALMTK2cxqPOk+u2h8XeTk7p+NpafiimKO7JRucZkmRpbSrR/9yC1Tcj4MMT5JWRbK1aDhOfk+65SfPkyhQblp2AmpD+2McaBCRiKR49zLHu/+twQvBqVVDq/hCmFq8La1p2xnszvx+GQvce1nw9zulavxoAfkw0S6WLLwkkAFP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479618; c=relaxed/simple;
	bh=JTZQIiMQfpYsMOHaD2DGukmLLnfy3FjBxR12tCIVKII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUBgQGpbo+jB4f+qF0oYZea6ogTmwOA56EnjlOFmJqvBwA2S6FukvUXJzv9jRl/b0qXLFAo2q35ObJk/RlddKhfZaOnYqFGXyUN1aTVeC/oHaqz7u3MuWq2ylu1OI9W904P5jX3foFy0PxBFg4SZkSjC8kfFm1JaK/3XX/FQl0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K0Pq393S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0Pq393S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xcUJ7JOultRHJq27A+Cdj/bYFCb0r9yIRc71c1wyytY=;
	b=K0Pq393SBIsS9UmM0FPoZFws8XGUrUGEcqcw4+4hk42wmQh+ETUA6jjnqxEtvPa2mkX13T
	4p7harujf0J+I3/1IFFnZErwqlfVysB7hBvctxDGroxlNRHtUoWgrnKABe8vN7zKUfpkR3
	PRV55PgQmvbC3cDMvLRgnK0j/XXfU2c=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-moZWfMfdNHaP_XIfUdDJnw-1; Sun, 29 Dec 2024 08:40:13 -0500
X-MC-Unique: moZWfMfdNHaP_XIfUdDJnw-1
X-Mimecast-MFC-AGG-ID: moZWfMfdNHaP_XIfUdDJnw
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aab9f30ac00so682895566b.3
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:40:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479612; x=1736084412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xcUJ7JOultRHJq27A+Cdj/bYFCb0r9yIRc71c1wyytY=;
        b=VYpAWP98cVhdG4D4o+Pc5XM9vjSJFzH45xaHnnR+pXlGV3H+vyYIaeDPKnIYik0apK
         fnZXIacNjBdx2cTCYjeNlsn4udMuAVAhhh2QhZdFXjXWXHpagrS/S0xIU0/T2jSIX0zv
         QYRpz/plCtzP8H3uWb5hHBR05ziRAhbPuqsTtDJg9dZlgWL3piamuzUBtqtoWthfFvLQ
         cQtPyrB1K8usYEj8D7pcEbwNqpOVfL9baRwLW2PZtWsvIErSZdW8XSkDNNpetHdAcYeQ
         4rABq0FLsJYVjtF8d97EBU8hxj7Bc4P5A7Zu883Dbz7wC/Tvw+QJRBxNKxriVzCVU2xW
         qUGQ==
X-Gm-Message-State: AOJu0YxAwQuw8QAmC2dW/7XKtLbBatczLzVZ2FQYq7uBbvKyTHV4EW1L
	syA02zl7HfAtT3WrhfCx4ojIi8CKAA8FlV803etKjuaRAfEliHY6fb8Ukim5TAEyJ50NpNIwcLp
	xn/mos7VDPl29OGFinpHl0YyrJ9PCRhHqkfcVnDmYlvuobYqc+CVFS/snlBXw+iBnTmt5JoKLbS
	AEyROIVb1y4fs7etcsIKAK2Kef1c5betU/TiZj2z73
X-Gm-Gg: ASbGncv/sPVS7ld9UT6Mz3Jl7c0AYyMr5z4jQZVNPWoXqc64C740dq5331B/SQ1ABf3
	EtAgDS0Tm7Ry4ucPwLaDc0fuSsNtHVLkGp0KRE0HWzgjQRmuZQE8IcdUNnQEJpuuHYek1jbtfMH
	S6PGCBfQo4dd937Kv/NaNWcnksiI5C5gHYjRTbOXtd9PPed3pO3vv4thYUVB5di3ay5BHSAnr0u
	gEiRDqAJikZgpLrb89vIGGxESKWU3VUqQk0n0GWe49zo991FXJvAlnHn2HbG/lXi7UYxcpIi2hO
	8uoQsRnM7qGUTZM=
X-Received: by 2002:a17:907:9490:b0:aac:4ed:b4ec with SMTP id a640c23a62f3a-aac2ad8ab93mr3025608466b.14.1735479611984;
        Sun, 29 Dec 2024 05:40:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5BxcYvceuzuNGMRGNdo5UK8nz0R4s+sNTE2lYU1InBjdBblkU6E2oOr4FQXwiE5nEZR0skg==
X-Received: by 2002:a17:907:9490:b0:aac:4ed:b4ec with SMTP id a640c23a62f3a-aac2ad8ab93mr3025605466b.14.1735479611623;
        Sun, 29 Dec 2024 05:40:11 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:40:10 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 21/24] xfs: advertise fs-verity being available on filesystem
Date: Sun, 29 Dec 2024 14:39:24 +0100
Message-ID: <20241229133927.1194609-22-aalbersh@kernel.org>
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

Advertise that this filesystem supports fsverity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 41ce4d3d650e..5cfd4043cb9b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -247,6 +247,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
+#define XFS_FSOP_GEOM_FLAGS_VERITY	(1 << 27) /* fs-verity */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 9945ad33a460..b8fd1759ebe8 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1500,6 +1500,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
 	if (xfs_has_metadir(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
-- 
2.47.0

