Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 802E07CAF
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 15:51:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4944D304032
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 13:51:08 -0700 (PDT)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id xcoPmO1DtRDKHFUL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Apr 2016 13:51:06 -0700 (PDT)
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 4BFF7340B3A
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 20:51:05 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH xfsdump] po: respect LINGUAS build setting
Date: Fri,  8 Apr 2016 16:51:03 -0400
Message-Id: <1460148663-23227-1-git-send-email-vapier@gentoo.org>
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

It is common gettext practice to limit the translations a particular
package will include by setting the LINGUAS environment variable.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 po/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/po/Makefile b/po/Makefile
index 6d40324..48a19c1 100644
--- a/po/Makefile
+++ b/po/Makefile
@@ -6,7 +6,10 @@ TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
 POTHEAD = $(PKG_NAME).pot
-LINGUAS = de pl
+# If the user has requested a specific set of translations, only build those.
+SUPPORTED_LINGUAS = $(patsubst %.po,%,$(wildcard *.po))
+LINGUAS ?= $(SUPPORTED_LINGUAS)
+LINGUAS := $(filter $(SUPPORTED_LINGUAS),$(LINGUAS))
 LSRCFILES = $(LINGUAS:%=%.po)
 LDIRT = $(POTHEAD)
 
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
