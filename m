Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E20FC7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9B9124670
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ikk51vP2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgBTBmS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbgBTBmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1e2bH041174;
        Thu, 20 Feb 2020 01:42:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WxxOWAVWNmEjck9K0065/0ZNdA2/8vQeBxe8Agj4kbo=;
 b=Ikk51vP21Nd+4SeIff9k7VP0j8+Ljjmz4bJV1c4lCiHQmjDX977ccb+XetshkiX5/U3I
 argeZku/8sH5mChta9TlfS2CtEBDHpcidps/YseCR/tIehIl59o/3umGY3la+l6ijIAy
 aGKqH1tHUJrOzgaMdg8txkzEbTeSiF8XfDUtwGJqIcZ9Mi8QJZa2YHVOaXQcnm+3gPeE
 pnIdRT9itx+nXqXUYIVOm4HcG8GHl1Zc07PWmveoiSUL4yVQYKnPSTudci+eJQkk0wKx
 mxpKdhfthLnpYZ5pExXwdpDcmJjprDEoTkW5F/e6QT3iTUyf70aY7s0IiDgo7/9LjVHu bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y8ud16s93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1foXp188363;
        Thu, 20 Feb 2020 01:42:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2y8ud96utd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:15 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1gE6J001644;
        Thu, 20 Feb 2020 01:42:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:42:14 -0800
Subject: [PATCH 5/8] xfs_db: check that metadata updates have been committed
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:42:13 -0800
Message-ID: <158216293385.601264.3202158027072387776.stgit@magnolia>
In-Reply-To: <158216290180.601264.5491208016048898068.stgit@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new function that will ensure that everything we scribbled on has
landed on stable media, and report the results.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/init.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/db/init.c b/db/init.c
index 0ac37368..e92de232 100644
--- a/db/init.c
+++ b/db/init.c
@@ -184,6 +184,7 @@ main(
 	char	*input;
 	char	**v;
 	int	start_iocur_sp;
+	int	d, l, r;
 
 	init(argc, argv);
 	start_iocur_sp = iocur_sp;
@@ -216,6 +217,19 @@ main(
 	 */
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
+
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
+
+
 	libxfs_umount(mp);
 	if (x.ddev)
 		libxfs_device_close(x.ddev);

