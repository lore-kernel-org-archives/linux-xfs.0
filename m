Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3C09D7F5F
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:40:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD6D8AC006
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 07:40:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BPTr34i2gX6NchdH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 07:40:23 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2 02/11] xfsprogs: Use glibtoolize on osx
Date: Mon,  3 Aug 2015 16:39:40 +0200
Message-Id: <1438612789-17486-3-git-send-email-jtulak@redhat.com>
In-Reply-To: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
References: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

(Already reviewed by Chris, but resubmiting
as the patchset itself was partially reworked.)

OS X doesn't have libtoolize binary by default, and the available$
ports are named "glibtoolize". Autodetect this issue.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
