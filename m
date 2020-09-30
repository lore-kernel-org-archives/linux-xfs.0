Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37532C4727C
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 16:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C707320759
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 16:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D1y8pqEc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgI3QBS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 12:01:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34926 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3QBS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 12:01:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UFx7BW184291;
        Wed, 30 Sep 2020 16:01:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=amY++imsqORpF+pDHQJV9m3CdVEtGL9hxVHdZACc8yU=;
 b=D1y8pqEcvcKjzzha9a70AGxHGyMqVNcKDyjT743HheAvCZrJqeVkIwqe8QKVruU2JDH+
 YiDgdVqDHWCtn+aJY63y07PUogGLxHwcXzNv0MbQMy96wdZzDU/vnahFma33JmXOFERr
 ZCssi60Ejhj+9H4i9s5AefzBd1z//dWZrAuI4fO+Radhryyv44lN1yXEY3ozBuDFlrkG
 Rzf35bc+dpDXK0BuH+BhjnHAjT7I/TUD9Fga0MIxoUZabMgp2c2sRqsPIydEm20DHkAF
 5AcShHHi3x7+R/HrZIxeODCL6Om8V86dsaXk2p49vjTFa9FeSOjb1WTUGyY7f8M/eKMK cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33sx9n9a2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 16:01:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UG0wmC154061;
        Wed, 30 Sep 2020 16:01:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33uv2fjru3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 16:01:13 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08UG1DXB000363;
        Wed, 30 Sep 2020 16:01:13 GMT
Received: from localhost (/10.159.225.72)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 09:01:13 -0700
Date:   Wed, 30 Sep 2020 09:01:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] libxfs: disallow filesystems with reverse mapping and
 reflink and realtime
Message-ID: <20200930160112.GN49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Neither the kernel nor the code in xfsprogs support filesystems that
have (either reverse mapping btrees or reflink) enabled and a realtime
volume configured.  The kernel rejects such combinations and mkfs
refuses to format such a config, but xfsprogs doesn't check and can do
Bad Things, so port those checks before someone shreds their filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: move code to rtmount_init where it belongs
---
 libxfs/init.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libxfs/init.c b/libxfs/init.c
index cb8967bc77d4..330c645190d9 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -428,6 +428,21 @@ rtmount_init(
 	sbp = &mp->m_sb;
 	if (sbp->sb_rblocks == 0)
 		return 0;
+
+	if (xfs_sb_version_hasreflink(sbp)) {
+		fprintf(stderr,
+	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
+				progname);
+		return -1;
+	}
+
+	if (xfs_sb_version_hasrmapbt(sbp)) {
+		fprintf(stderr,
+	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
+				progname);
+		return -1;
+	}
+
 	if (mp->m_rtdev_targp->dev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
 		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
 			progname);
