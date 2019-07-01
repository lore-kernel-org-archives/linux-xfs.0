Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37748 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729374AbfGARCR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 13:02:17 -0400
Subject: [PATCH 01/11] iomap: start moving code to fs/iomap/
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Jul 2019 10:02:05 -0700
Message-ID: <156200052577.1790352.9825618388583583693.stgit@magnolia>
In-Reply-To: <156200051933.1790352.5147420943973755350.stgit@magnolia>
References: <156200051933.1790352.5147420943973755350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create the build infrastructure we need to start migrating iomap code to
fs/iomap/ from fs/iomap.c.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MAINTAINERS       |    1 +
 fs/Makefile       |    1 +
 fs/iomap/Makefile |    7 +++++++
 3 files changed, 9 insertions(+)
 create mode 100644 fs/iomap/Makefile


diff --git a/MAINTAINERS b/MAINTAINERS
index 57f496cff999..8ce7d57e4d30 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8222,6 +8222,7 @@ L:	linux-fsdevel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 S:	Supported
 F:	fs/iomap.c
+F:	fs/iomap/
 F:	include/linux/iomap.h
 
 IOMMU DRIVERS
diff --git a/fs/Makefile b/fs/Makefile
index c9aea23aba56..8e61bdf9f330 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_SYSCTL)		+= drop_caches.o
 
 obj-$(CONFIG_FHANDLE)		+= fhandle.o
 obj-$(CONFIG_FS_IOMAP)		+= iomap.o
+obj-y				+= iomap/
 
 obj-y				+= quota/
 
diff --git a/fs/iomap/Makefile b/fs/iomap/Makefile
new file mode 100644
index 000000000000..b778a05acac3
--- /dev/null
+++ b/fs/iomap/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-or-newer
+#
+# Copyright (c) 2019 Oracle.
+# All Rights Reserved.
+#
+
+ccflags-y += -I $(srctree)/$(src)/..
