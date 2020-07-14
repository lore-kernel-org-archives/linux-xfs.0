Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AACEC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61CD5206F4
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:48:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c6LYQXAL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgGNVsT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:48:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38478 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGNVsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 17:48:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELm92Y073272;
        Tue, 14 Jul 2020 21:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EOwoY6kVWZOC1K8QZJM/aJnlRm5+D/BQKpLlkKc8BK4=;
 b=c6LYQXALKOlOMwx2TaXeLa3v/NOMXLzrU2clLsgyEt7GUXsPHmfz53s6fhKVmcGpmp+7
 JlYJUB4YzOsjxjZHykd8v6tgt+1jlcn4nog0mi/mppGwSs8VPIqa/74PhhQtsCk0zJBr
 ax1pV2RE683E0RX0P17wNBLMcRY32cx9xXXBIAlpwCyESBk8MNcwdZHq6CrHI47v+zmQ
 YxDfOTk7/SK8vM5a4REKw7FsRUlq/kvycHCploKZKzPmQaknZW/gshV16L+ANoBfbrxc
 XmtKL20NK5f4VfChLyDXyf+CH5ksIT6hcY6SHdhf0XHvJleJHQXxavk8rno/z+V9rii0 iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274ur830u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 21:48:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELhaEp051417;
        Tue, 14 Jul 2020 21:46:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 327qb5bcje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 21:46:15 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06ELkEYr023113;
        Tue, 14 Jul 2020 21:46:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 14:46:14 -0700
Subject: [PATCH 1/4] xfs_repair: alphabetize HFILES and CFILES
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 14:46:13 -0700
Message-ID: <159476317341.3156699.9021466334498861961.stgit@magnolia>
In-Reply-To: <159476316511.3156699.17998319555266568403.stgit@magnolia>
References: <159476316511.3156699.17998319555266568403.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140149
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
 repair/Makefile |   67 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 9 deletions(-)


diff --git a/repair/Makefile b/repair/Makefile
index f6a6e3f9..e9f93202 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -9,16 +9,65 @@ LSRCFILES = README
 
 LTCOMMAND = xfs_repair
 
-HFILES = agheader.h agbtree.h attr_repair.h avl.h bulkload.h bmap.h btree.h \
-	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
-	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h
+HFILES = \
+	agheader.h \
+	agbtree.h \
+	attr_repair.h \
+	avl.h \
+	bulkload.h \
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
 
-CFILES = agheader.c agbtree.c attr_repair.c avl.c bulkload.c bmap.c btree.c \
-	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
-	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
-	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
-	progress.c prefetch.c rmap.c rt.c sb.c scan.c slab.c threads.c \
-	versions.c xfs_repair.c
+CFILES = \
+	agheader.c \
+	agbtree.c \
+	attr_repair.c \
+	avl.c \
+	bulkload.c \
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

