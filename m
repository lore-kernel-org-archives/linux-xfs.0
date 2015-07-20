Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 312347F55
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 07:57:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 204228F8033
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 05:57:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sYP94wjyHmegaAO0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 05:57:11 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2 3/4] xfsprogs: Use glibtoolize on osx
Date: Mon, 20 Jul 2015 14:56:57 +0200
Message-Id: <1437397018-12864-4-git-send-email-jtulak@redhat.com>
In-Reply-To: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
References: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

OS X doesn't have libtoolize binary by default, and the available$
ports are named "glibtoolize". Autodetect this issue.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 Makefile | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 3da4d5d..4abaaac 100644
--- a/Makefile
+++ b/Makefile
@@ -52,6 +52,14 @@ ifneq ("$(XGETTEXT)","")
 TOOL_SUBDIRS += po
 endif
 
+# If we are on OS X, use glibtoolize from MacPorts, as OS X doesn't have
+# libtoolize binary itself.
+LIBTOOLIZE_TEST=$(shell libtoolize --version >/dev/null 2>&1 && echo found)
+LIBTOOLIZE_BIN=libtoolize
+ifneq ("$(LIBTOOLIZE_TEST)","found")
+LIBTOOLIZE_BIN=glibtoolize
+endif
+
 # include is listed last so it is processed last in clean rules.
 SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) include
 
@@ -85,13 +93,14 @@ else
 clean:	# if configure hasn't run, nothing to clean
 endif
 
+
 # Recent versions of libtool require the -i option for copying auxiliary
 # files (config.sub, config.guess, install-sh, ltmain.sh), while older
 # versions will copy those files anyway, and don't understand -i.
-LIBTOOLIZE_INSTALL = `libtoolize -n -i >/dev/null 2>/dev/null && echo -i`
+LIBTOOLIZE_INSTALL = `$(LIBTOOLIZE_BIN) -n -i >/dev/null 2>/dev/null && echo -i`
 
 configure:
-	libtoolize -c $(LIBTOOLIZE_INSTALL) -f
+	$(LIBTOOLIZE_BIN) -c $(LIBTOOLIZE_INSTALL) -f
 	cp include/install-sh .
 	aclocal -I m4
 	autoconf
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
