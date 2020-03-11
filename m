Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D80C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AABC1215A4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YK5hNKRY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgCKArb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:47:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33642 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgCKArb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 20:47:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0fbke112398
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GQ+Z9pROGAPAJV51bYED/cV8Y5HaDH8Ojk9Qqpvv/3k=;
 b=YK5hNKRYom+iFe6R+7T/MIv9ojoa3nvSJ5IotgSK42cYVOmZc9P+NTEHRtdICzoWEDE5
 W4yWBNUXnxxG4rz8ozyCXQ63BJb6JnqVvVe3EhYrNQBUcUeBtmBefA4OYuYFNNW7PeSV
 MtxkoCmnyq+bF9nEScTAKgNUbiRI4KrSHANSjNmGM+tSvvnCtCIONHtn5YGrXKIfLZa6
 X09miF4pt3QHB5hcI6HU29QPb0vO8D+OKxKLmGMaVMqxWewvruSL3hVm6S3553+pxJtB
 x/Ro853OtxGd1FwXC+xjabOdU02+BxO+OrZG3AkbKoBqjW6+cHSceXfZf5MB5n3sBwH/ fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ym31ugq53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0bwqe013823
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2yp8rnnb7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:29 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02B0lSuU014425
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 17:47:28 -0700
Subject: [PATCH 2/7] xfs: xfs_buf_corruption_error should take __this_address
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Mar 2020 17:47:25 -0700
Message-ID: <158388764539.939165.6782481626684056069.stgit@magnolia>
In-Reply-To: <158388763282.939165.6485358230553665775.stgit@magnolia>
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a xfs_failaddr_t parameter to this function so that callers can
potentially pass in (and therefore report) the exact point in the code
where we decided that a metadata buffer was corrupt.  This enables us to
wire it up to checking functions that have to run outside of verifiers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c   |    2 +-
 fs/xfs/xfs_error.c |    5 +++--
 fs/xfs/xfs_error.h |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9d26e37f78f5..28304dc751d8 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1593,7 +1593,7 @@ __xfs_buf_mark_corrupt(
 	ASSERT(bp->b_log_item == NULL ||
 	       !(bp->b_log_item->bli_flags & XFS_BLI_DIRTY));
 
-	xfs_buf_corruption_error(bp);
+	xfs_buf_corruption_error(bp, fa);
 	xfs_buf_stale(bp);
 }
 
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 57068d4ffba2..a21e9cc6516a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -350,13 +350,14 @@ xfs_corruption_error(
  */
 void
 xfs_buf_corruption_error(
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa)
 {
 	struct xfs_mount	*mp = bp->b_mount;
 
 	xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR,
 		  "Metadata corruption detected at %pS, %s block 0x%llx",
-		  __return_address, bp->b_ops->name, bp->b_bn);
+		  fa, bp->b_ops->name, bp->b_bn);
 
 	xfs_alert(mp, "Unmount and run xfs_repair");
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 31a5d321ba9a..1717b7508356 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -15,7 +15,7 @@ extern void xfs_corruption_error(const char *tag, int level,
 			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
-void xfs_buf_corruption_error(struct xfs_buf *bp);
+void xfs_buf_corruption_error(struct xfs_buf *bp, xfs_failaddr_t fa);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
 			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);

