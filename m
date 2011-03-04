Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24MWI0c194471 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 16:32:18 -0600
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A54928F8078
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 14:35:07 -0800 (PST)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.4/8.14.2) with ESMTP id p24MZ7KS023400
	for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 16:35:07 -0600
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.4/8.14.4/Submit) id p24MZ75i023399
	for xfs@oss.sgi.com; Fri, 4 Mar 2011 16:35:07 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103042235.p24MZ75i023399@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 16:35:07 -0600
Subject: [PATCH] xfstests: fix parallel make
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Having both "include/builddefs" and "include/config.h" as
dependencies for the default target results in a parallel
invocation of "make" spawning two concurrent attempts to
do the configure step--and that doesn't work.

Creating one of those two will result in the other getting
created, so there's no need to list both as dependencies.

There are several other mysterious dependencies that serve
no purpose, so get rid of them.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -38,7 +38,7 @@ endif
 
 SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
-default: include/builddefs include/config.h new remake check $(TESTS)
+default: include/builddefs $(TESTS)
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) $@
 else

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
