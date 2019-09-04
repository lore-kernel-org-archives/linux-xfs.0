Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646A7C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35F3722DBF
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cYovUOQH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfIDEhv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:37:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59094 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfIDEhv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:37:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844am5a040715;
        Wed, 4 Sep 2019 04:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=coUo8uX6myA1hiLCtCsVIwjVSy8cp0L9pS2vjytEPJM=;
 b=cYovUOQHKYyfXWFHafrTEYx1gzbci2n2pSnxa7gzaCtjjUvJ/ZRR3Mpy2w0O/nwedAXe
 9l7YLhMXtwtIPJw/LNqnL9DTpZNpBoxtGQv+P1GR2wjgr6LZpmj63ll82lqDOZh5wQr0
 uUbAoCcdHfJe8JxM+hbGIbNwyRt+dW7fDZFoUkVlu0lFeydK9AtmwhVD4bPaymdFVe70
 Z5HzNchoNFlxv4+pC5dqxpeq3mDL1gtF9EzfLRN/1uWPUurvZaW1zme3H2ck68q2O6c3
 i6dc1L7gYbrS/at0nuoNtOvES9BdBB+1IvwB5SqaoxjVQ1WGFo9OecdbPyUWbaP37Uip RQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ut6d1r0ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XFQT027462;
        Wed, 4 Sep 2019 04:37:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ut1hmtvud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:39 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844bcXG016383;
        Wed, 4 Sep 2019 04:37:38 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:37:38 -0700
Subject: [PATCH 05/10] xfs_db: remove db/convert.h
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Tue, 03 Sep 2019 21:37:34 -0700
Message-ID: <156757185424.1838441.6515170778646159040.stgit@magnolia>
In-Reply-To: <156757182283.1838441.193482978701233436.stgit@magnolia>
References: <156757182283.1838441.193482978701233436.stgit@magnolia>
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

db/convert.h conflicts with include/convert.h and since the former only
has one declaration in it anyway, just get rid of it.  We'll need this
in the next patch to avoid an ugly include mess.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

