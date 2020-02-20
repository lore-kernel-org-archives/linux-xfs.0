Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D60C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC4BF21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DAYAmRjd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBTBmY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbgBTBmY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1dqCU165655;
        Thu, 20 Feb 2020 01:42:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=y2YV+x4SWUWv3OYlU7mp1ee358cLAq6dUPUVIY7U0qI=;
 b=DAYAmRjdhF77njkHcMPmYBZa7ne7odb1jRn6JluuKU7n4JHaPZTd/7+oEPWlOJ0ozcJw
 yUdGSH4ErP5YlIKtw62bI22A/CNcrmt4itSvHi8nMqq1+Cut+fTyikvYa991MMbuxm7S
 z5USMc4gtaWQIVdW70XoZNPyzlm3ExYEOfswMsvMeKoC9UGcpnwXKebzeteTv2X0QFRi
 gQ+vVF8IM9fdfaK7ZTzo644cy1Sv+ccLD1U4PPlJ7p5N/TL10PBt8LxjNurYT/Z8Kz90
 bHjCAgZdkUM9acwHKTVk1XwpUd3YnGfj4qAN3dvCE6f9kBfGhEXWUruj7ON3FP8rrXJ0 Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2y8udd6tbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1g3ee146295;
        Thu, 20 Feb 2020 01:42:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2y8ud4pwmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:21 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1gKTJ027353;
        Thu, 20 Feb 2020 01:42:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:42:20 -0800
Subject: [PATCH 6/8] mkfs: check that metadata updates have been committed
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:42:19 -0800
Message-ID: <158216293986.601264.13332308350623716848.stgit@magnolia>
In-Reply-To: <158216290180.601264.5491208016048898068.stgit@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new function that will ensure that everything we formatted has
landed on stable media, and report the results.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1f5d2105..6b182264 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3644,6 +3644,7 @@ main(
 	char			*protofile = NULL;
 	char			*protostring = NULL;
 	int			worst_freelist = 0;
+	int			d, l, r;
 
 	struct libxfs_xinit	xi = {
 		.isdirect = LIBXFS_DIRECT,
@@ -3940,6 +3941,20 @@ main(
 	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
+	/* Make sure our new fs made it to stable storage. */
+	libxfs_flush_devices(mp, &d, &l, &r);
+	if (d)
+		fprintf(stderr, _("%s: cannot flush data device (%d).\n"),
+				progname, d);
+	if (l)
+		fprintf(stderr, _("%s: cannot flush log device (%d).\n"),
+				progname, l);
+	if (r)
+		fprintf(stderr, _("%s: cannot flush realtime device (%d).\n"),
+				progname, r);
+	if (d || l || r)
+		return 1;
+
 	libxfs_umount(mp);
 	if (xi.rtdev)
 		libxfs_device_close(xi.rtdev);

