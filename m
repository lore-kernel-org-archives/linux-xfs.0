Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6A1C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:38:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF84C22CED
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:38:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GxvQV2fT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfIDEis (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:38:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54358 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDEis (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:38:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844c2Ix028006;
        Wed, 4 Sep 2019 04:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=mwFPWkXQR69JJHJqfi5e1TTravkNncs8shgdGadv2oA=;
 b=GxvQV2fTJtvlsmSL6Sd9blKRmqmkDr0jUgoZK9mxcjoI4tZbilVEXjgKQZLkKcXnVPeu
 WdvqcaDt+cijCkmr72TGPOTiH6DPZmv8SDK6JvmeGuai6u2fTVPjXGoZ3TkkGGoqXYZJ
 1012OGLWogOO6cw4X3IJBPoPvNfnNukGf2Ce4YWkDx5mvxxL+XlYgBa6vPVPNL0pmmpJ
 mhjdqRQl6SDCZ76hm+sOiKctkKi4qlTJ9dg96RH9xea77dmIwFuYJs9NzPMBk9xBcAoc
 JSnjNFUzQdBSoRI8H4/hD1exZZCSpTxn6e+wHjyIosUHn0in23v1Qr1oROv7IyuLe0Qw SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ut6ds0042-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:38:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844cZm8176160;
        Wed, 4 Sep 2019 04:38:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2usu52bke5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:38:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x844c7GC016603;
        Wed, 4 Sep 2019 04:38:07 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:38:06 -0700
Subject: [PATCH 09/10] xfs_repair: reduce the amount of "clearing reflink
 flag" messages
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Tue, 03 Sep 2019 21:38:05 -0700
Message-ID: <156757188583.1838441.18008361702211038370.stgit@magnolia>
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
 engine=8.0.1-1906280000 definitions=main-1909040048
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

Clearing the reflink flag on files that don't share blocks is an
optimization, not a repair, so it's not critical to log a message every
single time we clear a flag.  Only log one message that we're clearing
these flags unless verbose mode is enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 repair/rmap.c |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index 5dd6557a..b907383e 100644
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
+		do_warn(_("clearing reflink flag on inode %"PRIu64"\n"), ino);
+		return;
+	}
+
+	if (warned)
+		return;
+
+	pthread_mutex_lock(&lock);
+	if (!warned) {
+		do_warn(_("clearing reflink flag on inodes when possible\n"));
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
 

