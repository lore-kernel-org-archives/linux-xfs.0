Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BE6C43461
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D712080A
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 17:56:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fTLrzgG5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730657AbgIGRz6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:55:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59202 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729667AbgIGRzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 13:55:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HnsAE043254;
        Mon, 7 Sep 2020 17:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fWLCR5dL8KmPYRP62pSqh2i/0C3R36vel+aZYfJ5d1E=;
 b=fTLrzgG5gZGqLMW2AXAIrVKUn+WiUlLXVt/gugIMtEt8JnAhcwZq1W3M8fu0Cw5yGh/r
 xvdM40e49lNtMpIUmYAd8Sg4bVM3Q5jcKknHmEkE6mKJ8QwD8HJ4m3wC+m5GQeArnhx9
 /FyI4Ouz4hugjJb8fBBKibjpD7k1oMqOYlejisF1YEm05l7vb3EAsf3Q3o+bW7BZjXMn
 KbF17yAf5PMnQUakXuQ1wIuWwInXvtRukfCGA2DszETVCO0vKMnss/9Swn76R+7u0ecj
 WTC4FfWZPCBlRyZFEJxe5/dUCjratoOttWJz5yfTKFoJgYtMD/MUau5qQalr4cbNNOSa mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33c3amqgwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Sep 2020 17:55:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HoCiK066251;
        Mon, 7 Sep 2020 17:53:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33cmkuus4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Sep 2020 17:53:40 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 087Hrdkq022040;
        Mon, 7 Sep 2020 17:53:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 10:52:23 -0700
Subject: [PATCH 4/7] xfs_repair: complain about unwritten extents when they're
 not appropriate
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 10:52:22 -0700
Message-ID: <159950114274.567790.13140838452739405641.stgit@magnolia>
In-Reply-To: <159950111751.567790.16914248540507629904.stgit@magnolia>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't allow unwritten extents in the attr fork, and we don't allow
them in the data fork except for regular files.  Check that this is the
case.

Found by manually fuzzing the extentflag field of an attr fork to one.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index d552db2d5f1a..1fe68bd41117 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -347,6 +347,28 @@ _("bmap rec out of order, inode %" PRIu64" entry %d "
 		cp = irec.br_blockcount;
 		sp = irec.br_startblock;
 
+		if (irec.br_state != XFS_EXT_NORM) {
+			/* No unwritten extents in the attr fork */
+			if (whichfork == XFS_ATTR_FORK) {
+				do_warn(
+_("unwritten extent (off = %" PRIu64 ", fsbno = %" PRIu64 ") in ino %" PRIu64 " attr fork\n"),
+					irec.br_startoff,
+					irec.br_startblock,
+					ino);
+				goto done;
+			}
+
+			/* No unwritten extents in non-regular files */
+			if (type != XR_INO_DATA && type != XR_INO_RTDATA) {
+				do_warn(
+_("unwritten extent (off = %" PRIu64 ", fsbno = %" PRIu64 ") in non-regular file ino %" PRIu64 "\n"),
+					irec.br_startoff,
+					irec.br_startblock,
+					ino);
+				goto done;
+			}
+		}
+
 		/*
 		 * check numeric validity of the extent
 		 */

