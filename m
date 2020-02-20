Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF0FC7619D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0550221D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kk+0yYOe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgBTBmg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44138 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTBmg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1d4RN164632;
        Thu, 20 Feb 2020 01:42:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=o/OsrdBU1dw06qQ3gRT7D+qVqYYUS4o7LTutOljcqfo=;
 b=Kk+0yYOeNwlf9S3hDM/+JmV5I1sB2dbh0PDvSup0owF+C48ltmpG2YfKO+ey9REuDyKB
 6I/j13ZyFeMmZPPHJiH6eMhD/1S73fJsGyGliw78c1LCMsAjqZsRYEy0uYcK3+N53/QG
 WmSCRLrjDv43XGxbJ6nh1of/7oUO1/mtFmsSwX+RM4s394TPp3HNjIbiIZLpLshSDv/x
 chFINQhp4tHCYinwcs+9fNCX9hSK39RcIp96Tnthl/xu5eJPWrsN8z19AEXRoBf0TTTv
 k3c9yj44i3gMvAGBH6QNjEElTWtSoRNCU7PEj8bECTcw8NxEydId0/JxQYfO+KHQ4/zT TQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2y8udd6tc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1bc1Q050387;
        Thu, 20 Feb 2020 01:42:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2y8ud2g2dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:33 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1gX3q002606;
        Thu, 20 Feb 2020 01:42:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:42:32 -0800
Subject: [PATCH 8/8] libfrog: always fsync when flushing a device
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:42:31 -0800
Message-ID: <158216295197.601264.12572804096602430873.stgit@magnolia>
In-Reply-To: <158216290180.601264.5491208016048898068.stgit@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=947 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=998 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Always call fsync() when we're flushing a device, even if it is a block
device.  It's probably redundant to call fsync /and/ BLKFLSBUF, but the
latter has odd behavior so we want to make sure the standard flush
methods have a chance to run first.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/linux.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)


diff --git a/libfrog/linux.c b/libfrog/linux.c
index 60bc1dc4..40a839d1 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -155,14 +155,18 @@ platform_flush_device(
 	if (major(device) == RAMDISK_MAJOR)
 		return 0;
 
+	ret = fsync(fd);
+	if (ret)
+		return ret;
+
 	ret = fstat(fd, &st);
 	if (ret)
 		return ret;
 
-	if (S_ISREG(st.st_mode))
-		return fsync(fd);
+	if (S_ISBLK(st.st_mode))
+		return ioctl(fd, BLKFLSBUF, 0);
 
-	return ioctl(fd, BLKFLSBUF, 0);
+	return 0;
 }
 
 void

