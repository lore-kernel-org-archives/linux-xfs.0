Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0043033F1
	for <linux-xfs@vger.kernel.org>; Fri, 27 Feb 2026 03:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772161353; cv=none; b=mFoYDCKMA2eF3Z5YmZ72hbJo/p4q49uV5X/QxbtpzEfJ39zOaNewe5BbRH2gOvSw1xYne+4V+7U51MbiCrytsD6rkBKxLbN1RvygVIZ3hLrPFVYLHlFIU+ygP9KL6mBHKIddeIjw2nbTcxNJWpD7OtVkKQsQEmy9kNkfdPrqFzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772161353; c=relaxed/simple;
	bh=ZyeWyiJTJ0OA+5E3jkRmqSEBgh0ORjxHLGVsBbZQWHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bncXbUZMxLzOGfaCTUCquuaJQAnUUDamvvxURQw+aTmU7Tsjflcud31HX1irk7ImbDFOT5T92LZ0Kmhuj4zYWVo8pmXyW6U2546FR3aA8t04nd6WGdsJEOw4zLFt2E+4pplmBew6T68Z5XMvU45RmSNpKh8GA213NB9KWJT4r2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a7A1mCGN; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a7A1mCGN"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ad9a9be502so10632395ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 26 Feb 2026 19:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772161351; x=1772766151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qD/WqA/1b12OidapDExAK5d+k5pGTkMmVLPJE+ZQNhI=;
        b=a7A1mCGN78rXQY51lrHwJoGyTKiY26iS6Uk1zgFIC4URtl3suRk4BQM4+lIO7dAQqo
         lPpZIcFE02ssg2J+W2r2V3EqzrgSNppj5l0g7gkUywkcAvfI8NEObQ/XJegx55Yi4ya3
         ZC/W86swCGtmHJRZ59NPG1XpL6Ue8fggJv9VkqHcxI2nutvM5ZExjVFwP2qCJcXoUaEc
         t6eDVL15yLyEthAZf4EXkT87kbwBYv/KJi9EnJbo9eoHdNTcNzMWM+b9zu8KNGGdr4sz
         pkCSUKTxramXFdWcsjW34IdDabPqycrK68fazsjhxlTeYdHH9vsP56j/62hIgiYKAykW
         hMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772161351; x=1772766151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qD/WqA/1b12OidapDExAK5d+k5pGTkMmVLPJE+ZQNhI=;
        b=pPA9jekWpwQPauTdK0ET3rm5njv3Gf3hunNG6+H7xlRAyxP5Jj6QM646RkOpaKtlXA
         gneUsJWdTYguyuPBkeGxEDo5n28XILHZd4aBMijr3BjoJT3xdlHgIjgL7ov8JeYVtOBM
         OyzD3EMHLdiLIEixfEciZFooM1RAkyP3T887JuMslnFT527rmdLvXbi+BpnlBQQ1KmPS
         shKoZ3bVy2ZajBc2IHssSKnyY8jjfM6c5dsiomlm+QBiXv7pnuGCLhARE3rlGmv9rHUn
         xhu21JIxoLQoEJl6qItVMj6LizW7hODyBPKjziuqD2PQOnUSkoeB6EApKThXv3Bkwm/+
         PAgQ==
X-Gm-Message-State: AOJu0YwYodKa9EjpU/o/tDtLZHrZ/uM/BElJp0MIOP91dnCH1DDXJ4u+
	am/X5U8VHs11V0P9uFhaKpU045cLqPYhzNtLDsYeH6SYDszAD+tSqbhuxLjnfg==
X-Gm-Gg: ATEYQzwcgar2lo4mNGL37NpQITgDXQ6sY9Zi5EixKWWTsDhOiVoYCQ1eBV+WlbqICQV
	B/XPbQLA0jlkW1dMzrXAsCCA6PJifiY/gUcdh1Go5qmp9+FAITAQF1kDQhiYJ+Xlw5bp82GwWaJ
	2rka1y1d2WucOG8cYkfwIOWIXV0UZrQ3Offyz6aY1aSTs7G67/hAyJEq0miftc15pyMKRNJZ/6Q
	Kcv+5LdVepcKsWUYfA9+GIRfOMHkCjfxLS7euxeRFoF5bxN7CR56NOSCPCacM0fZECtlqBDk04I
	g+uipfAbj8WPmX8MRkLztcfN3rOq8BaY4KWm1oigL553ChaqliATpQUxDLuo2r/RhunkMY2F1ZO
	znB8M/WvLzs9L5UZwvW+fU9kS5Z4IZ54K7Ad0nhKzY7XWXXyG+EQTJ5rW8dn/QcgyBuBvNoBvmi
	ImpCc0GyiPekZtb/Fg9iwXvw5lbon7Y5djjmLPjTKYaYaXIyfpydYPDFVWPgYNUO1hRfoaKCioU
	kZO2IMQFfw06u7Gq4uu5bsipmhN6ikc
X-Received: by 2002:a17:902:f541:b0:2ab:344e:1413 with SMTP id d9443c01a7336-2ae2e46c080mr11063255ad.34.1772161351472;
        Thu, 26 Feb 2026 19:02:31 -0800 (PST)
Received: from zenbook (122-150-206-46.dyn.ip.vocus.au. [122.150.206.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b48f4sm39865245ad.13.2026.02.26.19.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 19:02:31 -0800 (PST)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH] xfs: add write pointer to xfs_rtgroup_geometry
Date: Fri, 27 Feb 2026 13:01:06 +1000
Message-ID: <20260227030105.822728-2-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

There is currently no XFS ioctl that allows userspace to retrieve the
write pointer for a specific realtime group block for zoned XFS. On zoned
block devices, userspace can obtain this information via zone reports from
the underlying device. However, for zoned XFS operating on regular block
devices, no equivalent mechanism exists.

Access to the realtime group write pointer is useful to userspace
development and analysis tools such as Zonar [1]. So extend the existing
struct xfs_rtgroup_geometry to add a new rg_writepointer field. This field
is valid if XFS_RTGROUP_GEOM_WRITEPOINTER flag is set. The rg_writepointer
field specifies the location of the current writepointer as a sector offset
into the respective rtgroup.

[1] https://lwn.net/Articles/1059364/
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
 fs/xfs/libxfs/xfs_fs.h |  6 +++++-
 fs/xfs/xfs_ioctl.c     | 20 ++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d165de607d17..ca63ae67f16c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -995,7 +995,9 @@ struct xfs_rtgroup_geometry {
 	__u32 rg_sick;		/* o: sick things in ag */
 	__u32 rg_checked;	/* o: checked metadata in ag */
 	__u32 rg_flags;		/* i/o: flags for this ag */
-	__u32 rg_reserved[27];	/* o: zero */
+	__u32 rg_reserved0;	/* o: preserve alignment */
+	__u64 rg_writepointer;  /* o: write pointer sector for zoned */
+	__u32 rg_reserved[24];	/* o: zero */
 };
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
@@ -1003,6 +1005,8 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
 
+#define XFS_RTGROUP_GEOM_WRITEPOINTER  (1U << 0)  /* write pointer */
+
 /* Health monitor event domains */
 
 /* affects the whole fs */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index facffdc8dca8..86bd8fc0c41d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,12 +37,15 @@
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtrmap_btree.h"
 #include "xfs_file.h"
 #include "xfs_exchrange.h"
 #include "xfs_handle.h"
 #include "xfs_rtgroup.h"
 #include "xfs_healthmon.h"
 #include "xfs_verify_media.h"
+#include "xfs_zone_priv.h"
+#include "xfs_zone_alloc.h"
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
@@ -413,6 +416,7 @@ xfs_ioc_rtgroup_geometry(
 {
 	struct xfs_rtgroup	*rtg;
 	struct xfs_rtgroup_geometry rgeo;
+	xfs_rgblock_t		highest_rgbno, write_pointer;
 	int			error;
 
 	if (copy_from_user(&rgeo, arg, sizeof(rgeo)))
@@ -433,6 +437,22 @@ xfs_ioc_rtgroup_geometry(
 	if (error)
 		return error;
 
+	if (xfs_has_zoned(mp)) {
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+		if (rtg->rtg_open_zone) {
+			write_pointer = rtg->rtg_open_zone->oz_allocated;
+		} else {
+			highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
+			if (highest_rgbno == NULLRGBLOCK)
+				write_pointer = 0;
+			else
+				write_pointer = highest_rgbno + 1;
+		}
+		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+		rgeo.rg_writepointer = XFS_FSB_TO_BB(mp, write_pointer);
+		rgeo.rg_flags |= XFS_RTGROUP_GEOM_WRITEPOINTER;
+	}
+
 	if (copy_to_user(arg, &rgeo, sizeof(rgeo)))
 		return -EFAULT;
 	return 0;
-- 
2.53.0

