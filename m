Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67310C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B2AF2074B
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:28:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j2QN2vTc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgFBE2F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:28:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34876 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgFBE2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:28:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524H8bK106584;
        Tue, 2 Jun 2020 04:26:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xQo/NubJ8pV+EOcJ+3qkQrjvP54eNJjBR6SO+r65MAo=;
 b=j2QN2vTc0gtCma7h9Chbjj6G1FHYZN2eIaj8rFO+r08UQxWUczPftgAHRh2YllRywGfN
 xK5hERdBEjCLfNIYa3z+I2CnSwgKG4IXEz75Lta+ibM9FZ1qTZl9V98hxnWvxVyrLjRj
 HQr8hIdfle6Ali1WATukAfV6Lsd4qJt+T42DzX17cihI+CwnJ6UCwlSX2dJpSHlOChHh
 3hoNcAEFUsA/bu9GYdX327K0J/Tjq08kan3fYk7/HbaSoatCd9fJL630MOZLa8C9eQR7
 8uHVE1SkjcgeExW80X2Wk+K1Pz0JsGp1VE2VnG+lRMk8PEIsPm6P044IewfG1/mPBBKe GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31bfem1t8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:26:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HuYh126657;
        Tue, 2 Jun 2020 04:26:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31c25mngn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:26:01 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524Q0Oi019788;
        Tue, 2 Jun 2020 04:26:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:26:00 -0700
Subject: [PATCH 09/17] xfs_repair: complain about bad interior btree pointers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:25:58 -0700
Message-ID: <159107195896.313760.2369698179955785000.stgit@magnolia>
In-Reply-To: <159107190111.313760.8056083399475334567.stgit@magnolia>
References: <159107190111.313760.8056083399475334567.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Actually complain about garbage btree node pointers, don't just silently
ignore them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

