Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48848 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfDAHBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 03:01:23 -0400
Date: Mon, 1 Apr 2019 00:01:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] e2fsprogs: create tools for formatting and fscking bootfs
Message-ID: <20190401070118.GB1177@magnolia>
References: <20190401070001.GJ1173@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401070001.GJ1173@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Create tools and documentation for our new simple bootloader filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/Makefile.in  |    4 ++--
 misc/Makefile.in    |    8 ++++----
 misc/ext4.5.in      |    5 +++++
 misc/mke2fs.conf.in |    3 +++
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 9799274fa..69bd244d7 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -196,7 +196,7 @@ install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs
 		$(ES) "	INSTALL $(root_sbindir)/$$i"; \
 		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(root_sbindir)/$$i; \
 	done
-	$(Q) for i in ext2 ext3 ext4; do \
+	$(Q) for i in ext2 ext3 ext4 bootfs; do \
 		$(ES) "	LINK $(root_sbindir)/fsck.$$i"; \
 		(cd $(DESTDIR)$(root_sbindir); \
 			$(LN) $(LINK_INSTALL_FLAGS) e2fsck fsck.$$i); \
@@ -215,7 +215,7 @@ install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs
 		$(ES) "	INSTALL_DATA $(man5dir)/$$i"; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(man5dir)/$$i; \
 	done
-	$(Q) for i in ext2 ext3 ext4; do \
+	$(Q) for i in ext2 ext3 ext4 bootfs; do \
 		$(ES) "	LINK $(man8dir)/fsck.$$i.8"; \
 		(cd $(DESTDIR)$(man8dir); \
 			$(LN) $(LINK_INSTALL_FLAGS) e2fsck.8 fsck.$$i.8); \
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 22c984893..c961f26fd 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -545,7 +545,7 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 		$(ES) "	INSTALL $(sbindir)/$$i"; \
 		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(sbindir)/$$i; \
 	done
-	$(Q) for i in ext2 ext3 ext4; do \
+	$(Q) for i in ext2 ext3 ext4 bootfs; do \
 		$(ES) "	LINK $(root_sbindir)/mkfs.$$i"; \
 		(cd $(DESTDIR)$(root_sbindir); \
 			$(LN) $(LINK_INSTALL_FLAGS) mke2fs mkfs.$$i); \
@@ -576,7 +576,7 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 	done
 	$(Q) $(RM) -f $(DESTDIR)$(man8dir)/mkfs.ext2.8.gz \
 		$(DESTDIR)$(man8dir)/mkfs.ext3.8.gz
-	$(Q) for i in ext2 ext3 ext4; do \
+	$(Q) for i in ext2 ext3 ext4 bootfs; do \
 		$(ES) "	LINK mkfs.$$i.8"; \
 		(cd $(DESTDIR)$(man8dir); \
 			$(LN) $(LINK_INSTALL_FLAGS) mke2fs.8 mkfs.$$i.8); \
@@ -595,7 +595,7 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 		$(ES) "	INSTALL_DATA $(man5dir)/$$i"; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(man5dir)/$$i; \
 	done
-	$(Q) for i in ext2 ext3; do \
+	$(Q) for i in ext2 ext3 bootfs; do \
 		$(ES) "	LINK $$i.5"; \
 		(cd $(DESTDIR)$(man5dir); \
 			$(LN) $(LINK_INSTALL_FLAGS) ext4.5 $$i.5); \
@@ -674,7 +674,7 @@ uninstall:
 	for i in $(FMANPAGES); do \
 		$(RM) -f $(DESTDIR)$(man5dir)/$$i; \
 	done
-	$(Q) for i in ext2 ext3; do \
+	$(Q) for i in ext2 ext3 bootfs; do \
 		$(ES) "	LINK $$i.5"; \
 		$(RM) -f $(DESTDIR)$(man5dir)/$$i.5; \
 	done
diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index ee5e17097..7eff9c1d1 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -9,6 +9,8 @@ ext2 \- the second extended file system
 ext3 \- the third extended file system
 .br
 ext4 \- the fourth extended file system
+.br
+bootfs \- the simple bootloader file system
 .SH DESCRIPTION
 The second, third, and fourth extended file systems, or ext2, ext3, and
 ext4 as they are commonly known, are Linux file systems that have
@@ -19,6 +21,9 @@ previously intended for use with the ext2 and ext3 file systems can be
 mounted using the ext4 file system driver, and indeed in many modern
 Linux distributions, the ext4 file system driver has been configured
 to handle mount requests for ext2 and ext3 file systems.
+bootfs is a simple bootloader filesystem that trades thirty years' worth of
+filesystem design and speed improvements for safety in the face of poorly
+written userspace software and bootloaders; it is basically ext3 with extents.
 .SH FILE SYSTEM FEATURES
 A file system formatted for ext2, ext3, or ext4 can have some
 collection of the following file system feature flags enabled.  Some of
diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 00afd9128..b60f86f6d 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -10,6 +10,9 @@
 	ext3 = {
 		features = has_journal
 	}
+	bootfs = {
+		features = has_journal,extent
+	}
 	ext4 = {
 		features = has_journal,extent,huge_file,flex_bg,metadata_csum,64bit,dir_nlink,extra_isize
 		inode_size = 256
