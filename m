Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71424C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 16:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39D8120671
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 16:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0MSIeK0E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgENQ4d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 12:56:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56466 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgENQ4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 12:56:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGrFKq173799;
        Thu, 14 May 2020 16:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xYwd7EglabM1940rbdX4g3eqd2AUnNhIoY2H99UIsYs=;
 b=0MSIeK0E+/TAQLC2+hRxJsGJyaFJ4VhMVWsuOrKCfkk+ejGx6b6pFFbVPvvgUurqxwIn
 VOQbIHyeMLrFRLDv7UlwQzo1WLNBJjlLa8fS04w2XV4JJJYOuU+zCIljgqecUIt56ANJ
 Jfh8sUk6Yu+w+4syRjLzjIX73/1RIebOGnCVlLHlYwVMdcBa+r/vSYFqB29tBCuoBykx
 GgNsSFsqv+pXMLmN0xbYBDFNrB4w1J+ZCyF8J1MCAhGkbcYoq5XtTnM8Gvu2XLTtZrES
 CnpJyCi5xwoVm+y3SCjX2hfVMrfuXKF3XREVX3GJUNvQ/S1BCC/LGAUJO11eG02axKQp Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3100xwurq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 16:56:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGs5sR154633;
        Thu, 14 May 2020 16:56:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3100yh5dey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 16:56:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EGuT34005477;
        Thu, 14 May 2020 16:56:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 09:56:29 -0700
Subject: [PATCH 1/4] xfs_repair: alphabetize HFILES and CFILES
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 May 2020 09:56:28 -0700
Message-ID: <158947538814.2482564.831276969317955641.stgit@magnolia>
In-Reply-To: <158947538149.2482564.3112804204578429865.stgit@magnolia>
References: <158947538149.2482564.3112804204578429865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the definitions of HFILES and CFILES to lists that can be sorted
easily (in vim, anyway), then fix the alphabetization of the makefile
targets.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/Makefile |   67 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 10 deletions(-)


diff --git a/repair/Makefile b/repair/Makefile
index 8cc1ee68..78a521c5 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -9,16 +9,63 @@ LSRCFILES = README
 
 LTCOMMAND = xfs_repair
 
-HFILES = agheader.h attr_repair.h avl.h bload.h bmap.h btree.h \
-	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
-	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h
-
-CFILES = agheader.c attr_repair.c avl.c bload.c bmap.c btree.c \
-	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
-	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
-	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
-	progress.c prefetch.c rmap.c rt.c sb.c scan.c slab.c threads.c \
-	versions.c xfs_repair.c
+HFILES = \
+	agheader.h \
+	attr_repair.h \
+	avl.h \
+	bload.h \
+	bmap.h \
+	btree.h \
+	da_util.h \
+	dinode.h \
+	dir2.h \
+	err_protos.h \
+	globals.h \
+	incore.h \
+	prefetch.h \
+	progress.h \
+	protos.h \
+	rmap.h \
+	rt.h \
+	scan.h \
+	slab.h \
+	threads.h \
+	versions.h
+
+CFILES = \
+	agheader.c \
+	attr_repair.c \
+	avl.c \
+	bload.c \
+	bmap.c \
+	btree.c \
+	da_util.c \
+	dino_chunks.c \
+	dinode.c \
+	dir2.c \
+	globals.c \
+	incore_bmc.c \
+	incore.c \
+	incore_ext.c \
+	incore_ino.c \
+	init.c \
+	phase1.c \
+	phase2.c \
+	phase3.c \
+	phase4.c \
+	phase5.c \
+	phase6.c \
+	phase7.c \
+	prefetch.c \
+	progress.c \
+	rmap.c \
+	rt.c \
+	sb.c \
+	scan.c \
+	slab.c \
+	threads.c \
+	versions.c \
+	xfs_repair.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
 	$(LIBPTHREAD) $(LIBBLKID)

