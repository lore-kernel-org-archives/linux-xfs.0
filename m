Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UL0nZ9072281 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 16:00:49 -0500
Message-Id: <20121030210236.326173337@sgi.com>
Date: Tue, 30 Oct 2012 16:01:54 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [patch 2/2] [PATCH 6/6] dmapi: Update .gitignore
References: <20121030210152.751573876@sgi.com>
Content-Disposition: inline; filename=update-.gitignore.patch
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Engelhardt <jengelh@inai.de>, Rich Johnston <rjohnston@sgi.com>

Root entries to where they only can occur.

Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Ben Myers <bpm@sgi.com>

---

 .gitignore |   82 ++++++++++++++++++++++++++++++------------------------------
 1 files changed, 41 insertions(+), 41 deletions(-)

Index: dmapi/.gitignore
===================================================================
--- dmapi.orig/.gitignore
+++ dmapi/.gitignore
@@ -2,38 +2,45 @@
 *.o
 
 # build system
-.census
-Logs/
-include/builddefs
-install-sh
+/.census
+/Logs/
+/include/builddefs
+/install-sh
 
 # magic diretory symlinks
-include/xfs
+/include/xfs
 
 # Makepgs
-build/src-manifest
-build/dmapi-*.tar.gz
-doc/CHANGES.gz
+/build/src-manifest
+/build/dmapi-*.tar.gz
+/doc/CHANGES.gz
 dmapi-*
 
 # autoconf generated files
-aclocal.m4
-autom4te.cache/
-config.guess
-config.log
-config.status
-config.sub
-configure
+/aclocal.m4
+/autom4te.cache/
+/config.guess
+/config.log
+/config.status
+/config.sub
+/configure
 
 # libtool
-libtool
-ltmain.sh
+/libtool
+/ltmain.sh
 *.lo
 *.la
 .libs
 
 # quilt stuff
-.pc/
-patches/
+/.pc/
+/patches/
 
 # binaries
+
+# m4
+/m4/libtool.m4
+/m4/ltoptions.m4
+/m4/ltsugar.m4
+/m4/ltversion.m4
+/m4/lt~obsolete.m4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
