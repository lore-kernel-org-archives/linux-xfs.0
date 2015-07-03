Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BE07B7FC6
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 05:14:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6AB82AC00B
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 03:14:49 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id RsRgbHvybaQUVmmm (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 03:14:47 -0700 (PDT)
Received: from [88.128.80.19] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZAxzb-0002UE-1r
	for xfs@oss.sgi.com; Fri, 03 Jul 2015 10:14:47 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/13] xfsprogs: only install *format.h headers in install-qa
Date: Fri,  3 Jul 2015 12:12:12 +0200
Message-Id: <1435918341-10128-5-git-send-email-hch@lst.de>
In-Reply-To: <1435918341-10128-1-git-send-email-hch@lst.de>
References: <1435918341-10128-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Now that we've properly split up the headers we don't need to install all
the libxfs-internal headers for xfstests.  Just install the three headers
defining the on-disk format and xfs_arch.h which is required to compile
them instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/Makefile | 12 ++++++++----
 libxfs/Makefile  | 29 +++++++++++++++++------------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/include/Makefile b/include/Makefile
index f033245..0135860 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -18,7 +18,9 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
-QAHFILES = libxfs.h \
+QAHFILES = xfs_arch.h
+
+LIBHFILES = libxfs.h \
 	libxlog.h \
 	atomic.h \
 	bitops.h \
@@ -28,14 +30,17 @@ QAHFILES = libxfs.h \
 	list.h \
 	parent.h \
 	radix-tree.h \
-	xfs_arch.h \
 	xfs_btree_trace.h \
 	xfs_inode.h \
 	xfs_log_recover.h \
 	xfs_metadump.h \
 	xfs_mount.h \
 	xfs_trace.h \
-	xfs_trans.h
+	xfs_trans.h \
+	command.h \
+	input.h \
+	path.h \
+	project.h
 
 HFILES = handle.h \
 	jdm.h \
@@ -46,7 +51,6 @@ HFILES = handle.h \
 
 PHFILES = darwin.h freebsd.h irix.h linux.h gnukfreebsd.h
 DKHFILES = volume.h fstyp.h dvh.h
-LIBHFILES = command.h input.h path.h project.h
 LSRCFILES = $(shell echo $(PHFILES) | sed -e "s/$(PKG_PLATFORM).h//g")
 LSRCFILES += platform_defs.h.in builddefs.in buildmacros buildrules install-sh
 LSRCFILES += $(DKHFILES) $(LIBHFILES)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index c85f1ed..3d3b448 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -14,15 +14,14 @@ LT_AGE = 0
 PKGHFILES = xfs_fs.h \
 	xfs_types.h
 
-# headers with build dependencies
-HFILES = init.h \
-	crc32defs.h \
-	crc32table.h \
-	libxfs_priv.h \
-	xfs_dir2_priv.h \
-
 # headers installed in QA targets
-QAHFILES = xfs_alloc.h \
+QAHFILES = \
+	xfs_da_format.h \
+	xfs_format.h \
+	xfs_log_format.h
+
+LIBHFILES = \
+	xfs_alloc.h \
 	xfs_alloc_btree.h \
 	xfs_attr_leaf.h \
 	xfs_attr_sf.h \
@@ -33,14 +32,11 @@ QAHFILES = xfs_alloc.h \
 	xfs_attr_remote.h \
 	xfs_cksum.h \
 	xfs_da_btree.h \
-	xfs_da_format.h \
 	xfs_dir2.h \
-	xfs_format.h \
 	xfs_ialloc.h \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
-	xfs_log_format.h \
 	xfs_quota_defs.h \
 	xfs_sb.h \
 	xfs_shared.h \
@@ -49,6 +45,14 @@ QAHFILES = xfs_alloc.h \
 	libxfs_io.h \
 	libxfs_api_defs.h
 
+
+# headers with build dependencies
+HFILES = init.h \
+	crc32defs.h \
+	crc32table.h \
+	libxfs_priv.h \
+	xfs_dir2_priv.h
+
 CFILES = cache.c \
 	crc32.c \
 	init.c \
@@ -89,6 +93,7 @@ CFILES = cache.c \
 CFILES += $(PKG_PLATFORM).c
 PCFILES = darwin.c freebsd.c irix.c linux.c
 LSRCFILES = $(shell echo $(PCFILES) | sed -e "s/$(PKG_PLATFORM).c//g")
+LSRCFILES += $(LIBHFILES)
 LSRCFILES += gen_crc32table.c
 
 #
@@ -133,7 +138,7 @@ include $(BUILDRULES)
 install: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 
-install-headers: $(addsuffix -hdrs, $(PKGHFILES) $(QAHFILES))
+install-headers: $(addsuffix -hdrs, $(PKGHFILES) $(LIBHFILES) $(QAHFILES))
 
 %-hdrs:
 	$(Q)$(LN_S) -f $(PWD)/libxfs/$* $(TOPDIR)/include/xfs/$*
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
