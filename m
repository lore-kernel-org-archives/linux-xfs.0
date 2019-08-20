Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9113AC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6707C2332A
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:32:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nTDjNckD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbfHTUcg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:32:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730515AbfHTUcg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:32:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKSxph151519;
        Tue, 20 Aug 2019 20:32:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MLs7H2u33k8VmQo9Y5sKrHWtGbqSBXkQPe/govj4MiM=;
 b=nTDjNckDBv9tYLji02wFHvYIDNHOtbb+EoS/eDRXHhbbVgiHNVZNGTR0cPeBsVU/57jN
 URIEPY3XROekePxgxSL0mC43s5hzN39oi5Ne/RbEKrenYB4C1+IsjOeg20ks/z1vmLJo
 cmytokB9mfNaap+seVIM4Tt7OgPzSkzBDEy+O1bihTWHvggIiQ/Rqaq6IcsWLrLXdcXb
 Pa/6SIGEBuaHaIZufKsgt6HCVNPrr/rErNyHujrfodU7F9vIaWWRTlkeGWJsFS38lht6
 Y8bwxgpSSFpvlymddoGunGMTkb3bEGpwuP1MpnErhVNKMw1ZzTQ4FMZxDTIf2yr2a0yJ qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ue90th64e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:32:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKTLtc191234;
        Tue, 20 Aug 2019 20:32:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ugj7p4t8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:32:32 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7KKWVgZ028840;
        Tue, 20 Aug 2019 20:32:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:32:31 -0700
Subject: [PATCH 12/12] xfs_repair: reduce the amount of "clearing reflink
 flag" messages
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:32:29 -0700
Message-ID: <156633314915.1215978.1191691824699956900.stgit@magnolia>
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

Clearing the reflink flag on files that don't share blocks is an
optimization, not a repair, so it's not critical to log a message every
single time we clear a flag.  Only log one message that we're clearing
these flags unless verbose mode is enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/rmap.c |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index 47828a06..24251e9f 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1170,6 +1170,36 @@ record_inode_reflink_flag(
 		(unsigned long long)lino, (unsigned long long)irec->ino_was_rl);
 }
 
+/*
+ * Inform the user that we're clearing the reflink flag on an inode that
+ * doesn't actually share any blocks.  This is an optimization (the kernel
+ * skips refcount checks for non-reflink files) and not a corruption repair,
+ * so we don't need to log every time we clear a flag unless verbose mode is
+ * enabled.
+ */
+static void
+warn_clearing_reflink(
+	xfs_ino_t		ino)
+{
+	static bool		warned = false;
+	static pthread_mutex_t	lock = PTHREAD_MUTEX_INITIALIZER;
+
+	if (verbose) {
+		do_warn( _("clearing reflink flag on inode %"PRIu64"\n"), ino);
+		return;
+	}
+
+	if (warned)
+		return;
+
+	pthread_mutex_lock(&lock);
+	if (!warned) {
+		do_warn( _("clearing reflink flag on inodes when possible\n"));
+		warned = true;
+	}
+	pthread_mutex_unlock(&lock);
+}
+
 /*
  * Fix an inode's reflink flag.
  */
@@ -1188,9 +1218,7 @@ fix_inode_reflink_flag(
 _("setting reflink flag on inode %"PRIu64"\n"),
 			XFS_AGINO_TO_INO(mp, agno, agino));
 	else if (!no_modify) /* && !set */
-		do_warn(
-_("clearing reflink flag on inode %"PRIu64"\n"),
-			XFS_AGINO_TO_INO(mp, agno, agino));
+		warn_clearing_reflink(XFS_AGINO_TO_INO(mp, agno, agino));
 	if (no_modify)
 		return 0;
 

