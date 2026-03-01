Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14911BD9D0
	for <linux-xfs@vger.kernel.org>; Sun,  1 Mar 2026 00:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772325680; cv=none; b=fiNb8+NNZFhZLxXodnA6eIsET/uV6LsbV2x/AaXl8gEQq0kTbwvSPQc34VV8QrV3iyPoVoFcRaWzwmNgHgJuf0U85MbxnZwD0V9zI318gBYqMb9FkYlen2hbQ1rib3QkA6HokhfkWG3c9v8f1MS1je7noUtyQOZ22svPjQAGUKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772325680; c=relaxed/simple;
	bh=Vv7Erq2ZiEMpKTxq/A99SyVYZ9w1AJ9522b6JIzBTYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y1YhMhg8+0cMmsQ97w2QlGrpZ/hDnjHBF3gUASCrkYQ4ilE5g8OWVshGxWsILY1qGzmWHS0kRhoskq86Vl5aLb/zYgjkzqZ7FMUHEKWq6XkBnVVKtpFzZEpV6EUgem+H81kocPHikXOz+03OXcTSlxTMEaBpDlrFcUWUjn9TK6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jx9yJKaw; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jx9yJKaw"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c7103601c8cso1392037a12.2
        for <linux-xfs@vger.kernel.org>; Sat, 28 Feb 2026 16:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772325677; x=1772930477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hhGTDgaaohLTr2ABCzAU6hrkLau/xiHtalhCAkjhyT8=;
        b=jx9yJKawPrxcAxUo1c2o2bCxcuR0F98+BgztEWWhnhKB1FmpfddrOYkMoHgB7+bFfz
         KAcba+bxeiqZ48XgCGlA9z20FBZ+46zcGvQ0zvpf5QjK2LF40e4OBdf452srBt8tgevS
         1X1rVQfDpm450b3FVzxCz/Q5PvJAlKBPTV7YYuTqcKB+ywZJTxVh87KwhxLCXyolE719
         cQm+zhS+LosogD9SMcXyiihJik6wp032qhf8HeiKdEYoTUGYkoBH8bVz0m5fo5lnqVTm
         MLTkLBX6u3ZfZgaybaoVxmq7s7zL1FJkU5hLDoClEjMxG+0Z7Ln7VpycIEu72E0fZdYQ
         EAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772325677; x=1772930477;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhGTDgaaohLTr2ABCzAU6hrkLau/xiHtalhCAkjhyT8=;
        b=iw3yJeVRNIJISf/t0vn7+wQq7H8OJpAj44rOQHdruREMRjeOip1JfCF4e8CnWzUWic
         zRRkwBdaLtngImSwtxnxsARtY+5jaTFdl0EJxQGBnz3DxfhJz55Zm5yYHpPm+w7kxgjx
         j9L3wR0YGIATJC4V1CusXnItFqAPUHihJqXKvO5Sz+q3RxIjfO5ZdyTK7D/8iVZkjcBW
         Uz8g32s+GlbXDyVt8W70D/XW2nD22jR4JvyVAY8ToTvLF6WXrqHRNh+W+uFwKLX5CvHP
         7EZ/2XeMTKmNLFcTvn4jNQgcXlsOS6bPNx93LfV62Fn8pu4STHT9KVXBxXCu505SjH6M
         q/7Q==
X-Gm-Message-State: AOJu0Yw1dg/2JnnWqAUPLF+34WgmOLgVwJI/3oYr615aV2zDtSas0OYl
	/c1X+7qvExyyn8NMOcGATZEMvC1f7GenYc4T/p492nXP6Y8ku8DBlVrwCF+Z7g==
X-Gm-Gg: ATEYQzy/GZ2AOCGw+DFWh/fbI3KELqnlgfN8P6GhBfmorQpb5wHk6J39KE+xZ+fDQ1g
	s/g072ovBw6K3PDI3MWwv7MRB2zqlKCU2sMkbM7Wq/HthDnriecFwmN2g+78jrSHfCQ3UKpImqh
	DCR29fxdM+id743Vn+nUD+mBzTConwXB0NvtPiyUByjbRAauPOejpOQBYz9BilzCGRE5HS+Td/c
	JV0S7rH98K1/XDp7udeT1BwNIHu50/lZt7bY0B0LzXYuDoN4amUHs7fTttV/QQP8nH+3SfFd3Yq
	JhFnz8tvFKSBjXG3+1VHea2oiiB7kCeBZ+qYfVvpu4uQX8CIh41Z6VLM+iS+SywSiIpQZkBp5PD
	yFJsYAXMnA7aQI/0x/yG359cGgNAYELw0rzme4Pw0OZUQ+j7XCwStOA/t5jWtihd3mW6YizGcaM
	Zt+qj8qTILf1xYFFufo4QIoe1SZM35XFOdKB9QWQRPwDOEw6NPdzp72FQxwkfshWgjgcA/WKdCW
	oZwBFb4AFtQqiVS60iHuQ==
X-Received: by 2002:a17:90b:4fc6:b0:354:c3a4:397 with SMTP id 98e67ed59e1d1-35965d02b63mr5957635a91.32.1772325677052;
        Sat, 28 Feb 2026 16:41:17 -0800 (PST)
Received: from zenbook (122-150-206-24.dyn.ip.vocus.au. [122.150.206.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35982814773sm1402491a91.0.2026.02.28.16.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 16:41:16 -0800 (PST)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: [PATCH v2] xfs: add write pointer to xfs_rtgroup_geometry
Date: Sun,  1 Mar 2026 10:34:35 +1000
Message-ID: <20260301003432.605428-4-wilfred.opensource@gmail.com>
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
field specifies the location of the current writepointer as a block offset
into the respective rtgroup.

[1] https://lwn.net/Articles/1059364/
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
---
V1 -> V2:
	- Use a __u32 to instead of __u64 to store the write pointer
	- This, also drop the previously added padding.
	- Directly retun the writepointer block instead of converting
	  with XFS_FSB_TO_BB(), for consistentcy in struct
	  xfs_rtgroup_geometry (i.e rg_length is in fs blocks).
---
 fs/xfs/libxfs/xfs_fs.h |  5 ++++-
 fs/xfs/xfs_ioctl.c     | 19 +++++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d165de607d17..185f09f327c0 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -995,7 +995,8 @@ struct xfs_rtgroup_geometry {
 	__u32 rg_sick;		/* o: sick things in ag */
 	__u32 rg_checked;	/* o: checked metadata in ag */
 	__u32 rg_flags;		/* i/o: flags for this ag */
-	__u32 rg_reserved[27];	/* o: zero */
+	__u32 rg_writepointer;  /* o: write pointer block offset for zoned */
+	__u32 rg_reserved[26];	/* o: zero */
 };
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
@@ -1003,6 +1004,8 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
 
+#define XFS_RTGROUP_GEOM_WRITEPOINTER  (1U << 0)  /* write pointer */
+
 /* Health monitor event domains */
 
 /* affects the whole fs */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index facffdc8dca8..46e234863644 100644
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
+	xfs_rgblock_t		highest_rgbno;
 	int			error;
 
 	if (copy_from_user(&rgeo, arg, sizeof(rgeo)))
@@ -433,6 +437,21 @@ xfs_ioc_rtgroup_geometry(
 	if (error)
 		return error;
 
+	if (xfs_has_zoned(mp)) {
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+		if (rtg->rtg_open_zone) {
+			rgeo.rg_writepointer = rtg->rtg_open_zone->oz_allocated;
+		} else {
+			highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
+			if (highest_rgbno == NULLRGBLOCK)
+				rgeo.rg_writepointer = 0;
+			else
+				rgeo.rg_writepointer = highest_rgbno + 1;
+		}
+		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+		rgeo.rg_flags |= XFS_RTGROUP_GEOM_WRITEPOINTER;
+	}
+
 	if (copy_to_user(arg, &rgeo, sizeof(rgeo)))
 		return -EFAULT;
 	return 0;
-- 
2.53.0

