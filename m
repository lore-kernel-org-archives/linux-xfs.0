Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 415727F81
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 05:14:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2E7ED8F8066
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 03:14:55 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id MJ9cgdeoBsf9G65q (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 03:14:53 -0700 (PDT)
Received: from [88.128.80.19] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZAxzg-0002V4-Fx
	for xfs@oss.sgi.com; Fri, 03 Jul 2015 10:14:52 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/13] xfsprogs: remove install-qa target
Date: Fri,  3 Jul 2015 12:12:13 +0200
Message-Id: <1435918341-10128-6-git-send-email-hch@lst.de>
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

Now that we don't install all the libxfs internals but just the disk format
defintions we can install those as part of the normal install-dev target.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Makefile           |  6 ------
 include/Makefile   | 11 +++--------
 include/buildrules |  2 +-
 libdisk/Makefile   |  2 --
 libhandle/Makefile |  2 --
 libxcmd/Makefile   |  2 +-
 libxfs/Makefile    | 10 ++--------
 libxlog/Makefile   |  2 +-
 8 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/Makefile b/Makefile
index 6d6803b..111bf76 100644
--- a/Makefile
+++ b/Makefile
@@ -108,8 +108,6 @@ install: $(addsuffix -install,$(SUBDIRS))
 
 install-dev: $(addsuffix -install-dev,$(SUBDIRS))
 
-install-qa: install $(addsuffix -install-qa,$(SUBDIRS))
-
 %-install:
 	@echo "Installing $@"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $* install
@@ -118,10 +116,6 @@ install-qa: install $(addsuffix -install-qa,$(SUBDIRS))
 	@echo "Installing $@"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-dev
 
-%-install-qa:
-	@echo "Installing $@"
-	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-qa
-
 distclean: clean
 	$(Q)rm -f $(LDIRT)
 
diff --git a/include/Makefile b/include/Makefile
index 0135860..bd8b0ca 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -18,8 +18,6 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
-QAHFILES = xfs_arch.h
-
 LIBHFILES = libxfs.h \
 	libxlog.h \
 	atomic.h \
@@ -47,7 +45,8 @@ HFILES = handle.h \
 	$(PKG_PLATFORM).h \
 	platform_defs.h \
 	xfs.h \
-	xqm.h
+	xqm.h \
+	xfs_arch.h
 
 PHFILES = darwin.h freebsd.h irix.h linux.h gnukfreebsd.h
 DKHFILES = volume.h fstyp.h dvh.h
@@ -66,7 +65,7 @@ disk:
 include $(BUILDRULES)
 
 # set up include/xfs header directory
-install-headers: $(addsuffix -hdrs, $(HFILES) $(QAHFILES) $(PHFILES) $(DKHFILES) $(LIBHFILES))
+install-headers: $(addsuffix -hdrs, $(HFILES) $(PHFILES) $(DKHFILES) $(LIBHFILES))
 
 %-hdrs: xfs
 	$(Q)$(LN_S) -f $(PWD)/include/$* xfs/$*
@@ -79,7 +78,3 @@ install: default
 
 install-dev: install
 	$(INSTALL) -m 644 $(HFILES) $(PKG_INC_DIR)
-
-install-qa: install-dev
-	$(INSTALL) -m 644 $(QAHFILES) $(PKG_INC_DIR)
-
diff --git a/include/buildrules b/include/buildrules
index 0e13f9d..72491db 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -94,7 +94,7 @@ $(_FORCE):
 # rebuild on every make invocation isn't a problem we need to care about. Just
 # do it silently so it doesn't make the build unnecessarily noisy.
 
-.PHONY : depend ltdepend install-qa
+.PHONY : depend ltdepend
 
 MAKEDEP := $(MAKEDEPEND) $(CFLAGS)
 
diff --git a/libdisk/Makefile b/libdisk/Makefile
index b058a9f..3b84a3a 100644
--- a/libdisk/Makefile
+++ b/libdisk/Makefile
@@ -32,6 +32,4 @@ install: default
 
 install-dev: default
 
-install-qa: install-dev
-
 -include .ltdep
diff --git a/libhandle/Makefile b/libhandle/Makefile
index 865ca22..cc4ad1d 100644
--- a/libhandle/Makefile
+++ b/libhandle/Makefile
@@ -25,6 +25,4 @@ install: default
 install-dev: default
 	$(INSTALL_LTLIB_DEV)
 
-install-qa: install-dev
-
 -include .ltdep
diff --git a/libxcmd/Makefile b/libxcmd/Makefile
index ce082a5..7701ed9 100644
--- a/libxcmd/Makefile
+++ b/libxcmd/Makefile
@@ -34,6 +34,6 @@ default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
-install install-dev install-qa: default
+install install-dev: default
 
 -include .ltdep
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 3d3b448..ebbe40e 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -12,10 +12,7 @@ LT_AGE = 0
 
 # headers to install in include/xfs
 PKGHFILES = xfs_fs.h \
-	xfs_types.h
-
-# headers installed in QA targets
-QAHFILES = \
+	xfs_types.h \
 	xfs_da_format.h \
 	xfs_format.h \
 	xfs_log_format.h
@@ -138,7 +135,7 @@ include $(BUILDRULES)
 install: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 
-install-headers: $(addsuffix -hdrs, $(PKGHFILES) $(LIBHFILES) $(QAHFILES))
+install-headers: $(addsuffix -hdrs, $(PKGHFILES) $(LIBHFILES))
 
 %-hdrs:
 	$(Q)$(LN_S) -f $(PWD)/libxfs/$* $(TOPDIR)/include/xfs/$*
@@ -146,9 +143,6 @@ install-headers: $(addsuffix -hdrs, $(PKGHFILES) $(LIBHFILES) $(QAHFILES))
 install-dev: install
 	$(INSTALL) -m 644 $(PKGHFILES) $(PKG_INC_DIR)
 
-install-qa: install-dev
-	$(INSTALL) -m 644 $(QAHFILES) $(PKG_INC_DIR)
-
 # We need to install the headers before building the dependencies.  If we
 # include the .ltdep file, the makefile decides that it needs to build the
 # dependencies to remake the makefile before running the header install target,
diff --git a/libxlog/Makefile b/libxlog/Makefile
index 4673663..3417eed 100644
--- a/libxlog/Makefile
+++ b/libxlog/Makefile
@@ -19,6 +19,6 @@ default: ltdepend $(LTLIBRARY)
 
 include $(BUILDRULES)
 
-install install-dev install-qa: default
+install install-dev: default
 
 -include .ltdep
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
