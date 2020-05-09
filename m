Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29863C47257
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AB6B20735
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I2ui8v9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgEIQcn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:32:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38922 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbgEIQcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:32:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GODwC064954;
        Sat, 9 May 2020 16:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=v5VFNryt1NupKWD/nU4TADy/N80IJVBueKidb1F+n9M=;
 b=I2ui8v9WbphELprwfPx9Zh/9T4krxPJVZsQoY3/2TWStxU6fgRzx0Y1U6r41gKczE+Cd
 bLRzam4XiuOhtLKhywPEUS2/eP6ImSIgT2xc2nVoI8JhGgV0R+BGzBYXlzaGN+sfMzUi
 IFN1tOZd9SEkC3G9q3SDFPhI0NZRzFus/0ePlWyrS9zfrWazs6z5RUP69XM/WEBtXv7D
 JD0GOyIE/kND8DYGlQFHgSLj4cvWWN1lZW/LMoBh2S0sH9E32wLovToNRaxFUPRes+G+
 7OY0HpeRKs4RKaniUtQIztjuxqNG1FxhetTyD4R2WhLkpYgMVeiCGE61OumjWQ7qsFyT oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30wx8n86rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GWVPA117431;
        Sat, 9 May 2020 16:32:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30wwwpnjsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:32 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049GUmHD025272;
        Sat, 9 May 2020 16:30:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:30:48 -0700
Subject: [PATCH 08/16] xfs_repair: complain about bad interior btree pointers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:30:48 -0700
Message-ID: <158904184818.982941.1861210055263598397.stgit@magnolia>
In-Reply-To: <158904179213.982941.9666913277909349291.stgit@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Actually complain about garbage btree node pointers, don't just silently
ignore them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/scan.c            |   55 +++++++++++++++++++++++++++++++++-------------
 2 files changed, 41 insertions(+), 15 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 4462036b..7b264ff2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -180,6 +180,7 @@
 #define xfs_trans_roll_inode		libxfs_trans_roll_inode
 #define xfs_trans_roll			libxfs_trans_roll
 
+#define xfs_verify_agbno		libxfs_verify_agbno
 #define xfs_verify_cksum		libxfs_verify_cksum
 #define xfs_verify_dir_ino		libxfs_verify_dir_ino
 #define xfs_verify_ino			libxfs_verify_ino
diff --git a/repair/scan.c b/repair/scan.c
index fff54ecf..719ad035 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -779,6 +779,14 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 	for (i = 0; i < numrecs; i++)  {
 		xfs_agblock_t		agbno = be32_to_cpu(pp[i]);
 
+		if (!libxfs_verify_agbno(mp, agno, agbno)) {
+			do_warn(
+	_("bad btree pointer (%u) in %sbt block %u/%u\n"),
+				agbno, name, agno, bno);
+			suspect++;
+			return;
+		}
+
 		/*
 		 * XXX - put sibling detection right here.
 		 * we know our sibling chain is good.  So as we go,
@@ -788,10 +796,8 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		 * pointer mismatch, try and extract as much data
 		 * as possible.
 		 */
-		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
-			scan_sbtree(agbno, level, agno, suspect, scan_allocbt,
-				    0, magic, priv, ops);
-		}
+		scan_sbtree(agbno, level, agno, suspect, scan_allocbt, 0,
+				magic, priv, ops);
 	}
 }
 
@@ -1234,10 +1240,16 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			continue;
 		}
 
-		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
-			scan_sbtree(agbno, level, agno, suspect, scan_rmapbt, 0,
-				    magic, priv, ops);
+		if (!libxfs_verify_agbno(mp, agno, agbno)) {
+			do_warn(
+	_("bad btree pointer (%u) in %sbt block %u/%u\n"),
+				agbno, name, agno, bno);
+			suspect++;
+			return;
 		}
+
+		scan_sbtree(agbno, level, agno, suspect, scan_rmapbt, 0, magic,
+				priv, ops);
 	}
 
 out:
@@ -1454,10 +1466,16 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 	for (i = 0; i < numrecs; i++)  {
 		xfs_agblock_t		agbno = be32_to_cpu(pp[i]);
 
-		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
-			scan_sbtree(agbno, level, agno, suspect, scan_refcbt, 0,
-				    magic, priv, ops);
+		if (!libxfs_verify_agbno(mp, agno, agbno)) {
+			do_warn(
+	_("bad btree pointer (%u) in %sbt block %u/%u\n"),
+				agbno, name, agno, bno);
+			suspect++;
+			return;
 		}
+
+		scan_sbtree(agbno, level, agno, suspect, scan_refcbt, 0, magic,
+				priv, ops);
 	}
 out:
 	if (suspect)
@@ -2125,11 +2143,18 @@ _("%sbt btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 	}
 
 	for (i = 0; i < numrecs; i++)  {
-		if (be32_to_cpu(pp[i]) != 0 && verify_agbno(mp, agno,
-							be32_to_cpu(pp[i])))
-			scan_sbtree(be32_to_cpu(pp[i]), level, agno,
-					suspect, scan_inobt, 0, magic, priv,
-					ops);
+		xfs_agblock_t	agbno = be32_to_cpu(pp[i]);
+
+		if (!libxfs_verify_agbno(mp, agno, agbno)) {
+			do_warn(
+	_("bad btree pointer (%u) in %sbt block %u/%u\n"),
+				agbno, name, agno, bno);
+			suspect++;
+			return;
+		}
+
+		scan_sbtree(be32_to_cpu(pp[i]), level, agno, suspect,
+				scan_inobt, 0, magic, priv, ops);
 	}
 }
 

