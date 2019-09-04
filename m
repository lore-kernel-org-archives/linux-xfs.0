Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A65C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E88A22CED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PcBQIDCc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfIDEhZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:37:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58484 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfIDEhZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:37:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844aQVp040106;
        Wed, 4 Sep 2019 04:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vDXz6QILu96WOKc1YAKbpi7icpvhs+bNhFT/X8CX1zU=;
 b=PcBQIDCcdQM6G235mNDmf5SWumhV7ejZVWVx2npJ6v/gNktdzGIa5k/JP07M3RavLR2I
 fywu6cmZV4ev+NTRj821+BmrVSrqXo4hQ7S6JnDALLlyfb9rcIuLBIhXD9ZU3t/2734L
 6Vrlu2IC+xHEFl62yV2vIWno42DHP4FhD4PXTd7VsHCTUDiW8n4Ht94Mvtl+Y37YCJjK
 cgzAANGEO8osbs2rWzjWUPQY05GbqbAKwxaRq9Rd6bCopmQEgSLD/ZRxp5c2uBhsSxnQ
 jpNQl7nauJHhlZIazCZffbOxwvAkLYteEtJGRonnfqNsQcBRjvcTdoL4XZuHsTHnl3QZ GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ut6d1r041-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XkF0163016;
        Wed, 4 Sep 2019 04:36:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2usu52bhng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:36:55 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844as15030929;
        Wed, 4 Sep 2019 04:36:54 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:36:54 -0700
Subject: [PATCH 11/12] libfrog: move workqueue.h to libfrog/
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 Sep 2019 21:36:53 -0700
Message-ID: <156757181354.1838135.14750040578517707289.stgit@magnolia>
In-Reply-To: <156757174409.1838135.8885359673458816401.stgit@magnolia>
References: <156757174409.1838135.8885359673458816401.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move this header to libfrog since the code is there already.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/Makefile   |    1 -
 include/input.h    |    2 +-
 include/project.h  |   39 ---------------------------------------
 libfrog/Makefile   |    1 +
 libfrog/paths.c    |    2 +-
 libfrog/projects.c |    2 +-
 libfrog/projects.h |   39 +++++++++++++++++++++++++++++++++++++++
 quota/quota.h      |    2 +-
 8 files changed, 44 insertions(+), 44 deletions(-)
 delete mode 100644 include/project.h
 create mode 100644 libfrog/projects.h


diff --git a/include/Makefile b/include/Makefile
index fc90bc48..a80867e4 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -28,7 +28,6 @@ LIBHFILES = libxfs.h \
 	xfs_trans.h \
 	command.h \
 	input.h \
-	project.h \
 	platform_defs.h
 
 HFILES = handle.h \
diff --git a/include/input.h b/include/input.h
index 57fdd343..3c3fa116 100644
--- a/include/input.h
+++ b/include/input.h
@@ -9,7 +9,7 @@
 #include <pwd.h>
 #include <grp.h>
 #include <sys/types.h>
-#include "project.h"
+#include "libfrog/projects.h"
 #include "libfrog/convert.h"
 #include <stdbool.h>
 
diff --git a/include/project.h b/include/project.h
deleted file mode 100644
index 3577dadb..00000000
--- a/include/project.h
+++ /dev/null
@@ -1,39 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __PROJECT_H__
-#define __PROJECT_H__
-
-#include "platform_defs.h"
-#include "xfs.h"
-
-extern int setprojid(const char *__name, int __fd, prid_t __id);
-extern int getprojid(const char *__name, int __fd, prid_t *__id);
-
-typedef struct fs_project {
-	prid_t		pr_prid;	/* project identifier */
-	char		*pr_name;	/* project name */
-} fs_project_t;
-
-extern void setprent(void);
-extern void endprent(void);
-extern fs_project_t *getprent(void);
-extern fs_project_t *getprnam(char *__name);
-extern fs_project_t *getprprid(prid_t __id);
-
-typedef struct fs_project_path {
-	prid_t		pp_prid;	/* project identifier */
-	char		*pp_pathname;	/* pathname to root of project tree */
-} fs_project_path_t;
-
-extern void setprpathent(void);
-extern void endprpathent(void);
-extern fs_project_path_t *getprpathent(void);
-
-extern void setprfiles(void);
-extern char *projid_file;
-extern char *projects_file;
-
-#endif	/* __PROJECT_H__ */
diff --git a/libfrog/Makefile b/libfrog/Makefile
index f8f7de68..25b5a03c 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -38,6 +38,7 @@ crc32defs.h \
 crc32table.h \
 fsgeom.h \
 paths.h \
+projects.h \
 ptvar.h \
 radix-tree.h \
 topology.h \
diff --git a/libfrog/paths.c b/libfrog/paths.c
index f0f4548e..32737223 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -14,7 +14,7 @@
 #include <sys/stat.h>
 #include "paths.h"
 #include "input.h"
-#include "project.h"
+#include "projects.h"
 #include <limits.h>
 
 extern char *progname;
diff --git a/libfrog/projects.c b/libfrog/projects.c
index 91bc78f2..dbde9702 100644
--- a/libfrog/projects.c
+++ b/libfrog/projects.c
@@ -7,7 +7,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include "project.h"
+#include "projects.h"
 
 #define PROJID		"/etc/projid"
 #define PROJECT_PATHS	"/etc/projects"
diff --git a/libfrog/projects.h b/libfrog/projects.h
new file mode 100644
index 00000000..77919474
--- /dev/null
+++ b/libfrog/projects.h
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_PROJECTS_H__
+#define __LIBFROG_PROJECTS_H__
+
+#include "platform_defs.h"
+#include "xfs.h"
+
+extern int setprojid(const char *__name, int __fd, prid_t __id);
+extern int getprojid(const char *__name, int __fd, prid_t *__id);
+
+typedef struct fs_project {
+	prid_t		pr_prid;	/* project identifier */
+	char		*pr_name;	/* project name */
+} fs_project_t;
+
+extern void setprent(void);
+extern void endprent(void);
+extern fs_project_t *getprent(void);
+extern fs_project_t *getprnam(char *__name);
+extern fs_project_t *getprprid(prid_t __id);
+
+typedef struct fs_project_path {
+	prid_t		pp_prid;	/* project identifier */
+	char		*pp_pathname;	/* pathname to root of project tree */
+} fs_project_path_t;
+
+extern void setprpathent(void);
+extern void endprpathent(void);
+extern fs_project_path_t *getprpathent(void);
+
+extern void setprfiles(void);
+extern char *projid_file;
+extern char *projects_file;
+
+#endif	/* __LIBFROG_PROJECTS_H__ */
diff --git a/quota/quota.h b/quota/quota.h
index 5db0a741..025d8877 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -6,7 +6,7 @@
 
 #include "xqm.h"
 #include "libfrog/paths.h"
-#include "project.h"
+#include "libfrog/projects.h"
 #include <stdbool.h>
 
 /*

