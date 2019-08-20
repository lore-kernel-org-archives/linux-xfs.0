Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E24AC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3D312332B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aieiT1Te"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbfHTUcK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:32:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46602 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730728AbfHTUcJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:32:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKSwWq151487;
        Tue, 20 Aug 2019 20:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=M0cHfUb71N8ECjgb3Km3UFRTxw3bWthiqzd/BgJUMtU=;
 b=aieiT1TeDjPwlAx023KouzoycDpJ79PtMyp04w/JDKgFLFzPwljy7Zfjmk0LCwrX/2wf
 76Jbe6MswoT7UWCmRwyc88PQgi1NEpmSmFrdNLp5fPadTbWrCyEcBhMDgCjpUe1Umid7
 Xv4xHW0JcPueb27b7hJS8rEg5/ssQ1v9loxlAB7mPyGQ9Ned9INE4xqg0P0yeZX5NQtG
 VLZ+HW792MVDqIJfCF+lScK+0r6PsjwpKqW4M3puRvDVlG/K4OjV4fUd8dHvr75Azg4m
 kXTAsyaHCCScpO5eXCNz/IAihrFfVPxLop8TsHAH5QoGd1Zze+JofY7/rAgakrh1GWRR nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ue90th611-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:32:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTM1T191285;
        Tue, 20 Aug 2019 20:32:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ugj7p4swt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:32:07 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7KKW5GH021765;
        Tue, 20 Aug 2019 20:32:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:32:05 -0700
Subject: [PATCH 08/12] xfs_db: remove db/convert.h
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:32:00 -0700
Message-ID: <156633312041.1215978.17289300639793819044.stgit@magnolia>
In-Reply-To: <156633307176.1215978.17394956977918540525.stgit@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

db/convert.h conflicts with include/convert.h and since the former only
has one declaration in it anyway, just get rid of it.  We'll need this
in the next patch to avoid an ugly include mess.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/Makefile  |    4 ++--
 db/command.c |    1 -
 db/command.h |    1 +
 db/convert.c |    1 -
 db/convert.h |    7 -------
 5 files changed, 3 insertions(+), 11 deletions(-)
 delete mode 100644 db/convert.h


diff --git a/db/Makefile b/db/Makefile
index 8fecfc1c..0941b32e 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -8,13 +8,13 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_db
 
 HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
-	btblock.h bmroot.h check.h command.h convert.h crc.h debug.h \
+	btblock.h bmroot.h check.h command.h crc.h debug.h \
 	dir2.h dir2sf.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h
-CFILES = $(HFILES:.h=.c) btdump.c info.c
+CFILES = $(HFILES:.h=.c) btdump.c convert.c info.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
diff --git a/db/command.c b/db/command.c
index c7c52342..89a78f03 100644
--- a/db/command.c
+++ b/db/command.c
@@ -11,7 +11,6 @@
 #include "bmap.h"
 #include "check.h"
 #include "command.h"
-#include "convert.h"
 #include "debug.h"
 #include "type.h"
 #include "echo.h"
diff --git a/db/command.h b/db/command.h
index eacfd465..2f9a7e16 100644
--- a/db/command.h
+++ b/db/command.h
@@ -28,5 +28,6 @@ extern int		command(int argc, char **argv);
 extern const cmdinfo_t	*find_command(const char *cmd);
 extern void		init_commands(void);
 
+extern void		convert_init(void);
 extern void		btdump_init(void);
 extern void		info_init(void);
diff --git a/db/convert.c b/db/convert.c
index 01a08823..e1466057 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -6,7 +6,6 @@
 
 #include "libxfs.h"
 #include "command.h"
-#include "convert.h"
 #include "output.h"
 #include "init.h"
 
diff --git a/db/convert.h b/db/convert.h
deleted file mode 100644
index 3660cabe..00000000
--- a/db/convert.h
+++ /dev/null
@@ -1,7 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-
-extern void	convert_init(void);

