Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81DB3911C9
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789046950; cv=none; b=RjZm6k70uMw5czyc5rcGs6RMnoJ/diOMK77BujiknwVOMUgZhV/cZx3dqM6EgjGATLZCiLZQb3FWxONSutfVCQ3z/6KZTmEFbgW1FRWxRCEjvbAVxzH3WTjln8mvoPVj8p8a2mUQErUaxiHK9oT+3zaKyg5CQbo65Bg0U/MBfSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789046950; c=relaxed/simple;
	bh=ANziYaDg2BVt9WmY7YCnu8NDeVFbzThCwUgv4cprxl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMAgTds5uO6DL5q5g7u9wPQOdvmnQICAiSBO+KPP3Pir1xlx67xTFI3AqdPqb66kQZXtZiLSO0ANbw7h51JyozXWhxUN/b8VYhxpjgwGNM+svZxcwFk6sI437+2Njn+aMPWtgLwqtnQ0sVQhUM/aVBnJ8x2VBnijgTUtSeQIE2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t/CTNIYS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t/CTNIYS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sGCyUY1D+FW+y3JbfcVPcnoT/+tYLXrB9SB3NToR0zI=; b=t/CTNIYSzDY3EHMDzhLpmB1X6e
	w6Cx7CCWNWQUYNkV6LX/LDxljROKpwXhMUM5ECDXf2bRN5ydAkOVHklSKgjY049y4AwCaQw9pDCSE
	0haP7sOlEl57hSnpv7pyHei7hyxr2XiBu0ZHsIjnosa5uBX7kpOd8gPY40zE16ECPngIVZ4bZxne3
	6TnOJqKyB5JPe8xgw061ZfbCftgfBXRHH9Lbres5tRBXYi3vbwLnzwHuHfnkkP1GrJZdBW98xJ9y+
	UbxaV7pEF8kDggH+1wp8TLT/rMONa0otsRGtFWju/HaOnCZeAVeRt4W8ZySnwAXX9/Oy6wDXOG3cK
	stC4xsiQ==;
Received: from [2001:4bb8:2c4:6e16:7921:e451:555c:a765] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4epv-0000000ESu3-3RQi;
	Thu, 10 Sep 2026 13:29:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] libxfs: find a better location for stub headers
Date: Thu, 10 Sep 2026 15:28:34 +0200
Message-ID: <20260910132840.1541283-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910132840.1541283-1-hch@lst.de>
References: <20260910132840.1541283-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

include/ currently has a few headers that files from fs/xfs/ in the kernel
with the same name.  We'll add a lot more of them, so move them to a
place not easily confused with public headers and clearly in the libxfs
realm by adding a libxfs/stubs/ directory.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/Makefile                      | 4 ----
 include/builddefs.in                  | 3 ++-
 libxfs/Makefile                       | 6 +++++-
 {include => libxfs/stubs}/xfs_inode.h | 0
 {include => libxfs/stubs}/xfs_mount.h | 0
 {include => libxfs/stubs}/xfs_trace.h | 0
 {include => libxfs/stubs}/xfs_trans.h | 0
 7 files changed, 7 insertions(+), 6 deletions(-)
 rename {include => libxfs/stubs}/xfs_inode.h (100%)
 rename {include => libxfs/stubs}/xfs_mount.h (100%)
 rename {include => libxfs/stubs}/xfs_trace.h (100%)
 rename {include => libxfs/stubs}/xfs_trans.h (100%)

diff --git a/include/Makefile b/include/Makefile
index a4f0c365db12..90614554b7bb 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -17,11 +17,7 @@ LIBHFILES = libxfs.h \
 	list.h \
 	parent.h \
 	spinlock.h \
-	xfs_inode.h \
 	xfs_metadump.h \
-	xfs_mount.h \
-	xfs_trace.h \
-	xfs_trans.h \
 	command.h \
 	input.h \
 	platform_defs.h
diff --git a/include/builddefs.in b/include/builddefs.in
index 3b52d1afd703..c8e0e0ae69e8 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -179,7 +179,8 @@ endif
 
 GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
-	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs \
+	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include \
+	  -I$(TOPDIR)/libxfs/stubs -I$(TOPDIR)/libxfs \
 	  -I$(TOPDIR)
 
 ifeq ($(ENABLE_GETTEXT),yes)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index bd6b8f54d2ae..24ff07e961aa 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -73,7 +73,11 @@ HFILES = \
 	xfs_trans_resv.h \
 	xfs_trans_space.h \
 	xfs_dir2_priv.h \
-	xfs_zones.h
+	xfs_zones.h \
+	stubs/xfs_inode.h \
+	stubs/xfs_mount.h \
+	stubs/xfs_trace.h \
+	stubs/xfs_trans.h
 
 CFILES = buf_mem.c \
 	cache.c \
diff --git a/include/xfs_inode.h b/libxfs/stubs/xfs_inode.h
similarity index 100%
rename from include/xfs_inode.h
rename to libxfs/stubs/xfs_inode.h
diff --git a/include/xfs_mount.h b/libxfs/stubs/xfs_mount.h
similarity index 100%
rename from include/xfs_mount.h
rename to libxfs/stubs/xfs_mount.h
diff --git a/include/xfs_trace.h b/libxfs/stubs/xfs_trace.h
similarity index 100%
rename from include/xfs_trace.h
rename to libxfs/stubs/xfs_trace.h
diff --git a/include/xfs_trans.h b/libxfs/stubs/xfs_trans.h
similarity index 100%
rename from include/xfs_trans.h
rename to libxfs/stubs/xfs_trans.h
-- 
2.53.0

