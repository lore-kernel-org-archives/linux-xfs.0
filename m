Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F23C2BA1E
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95FC820719
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:52:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e1u6N4Zr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgDFSwl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 14:52:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54408 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgDFSwk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 14:52:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036Ii3uq008246;
        Mon, 6 Apr 2020 18:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7lQZjAqnk3eE9LcbxDp1S5dNxnHPYAO/2Q38A22nDAA=;
 b=e1u6N4ZrTwodKWRnIYA71l8PZjGsGLzF1A8P6eOzHZhTOBMxD/QAXSq8+/k6cMrfH72S
 i36n222wsR8z+wW9WWHtanHGFdVoQ+stBYAhFJ4qo41z+vcMRaDD03XKVl8oc4pZ0YbM
 WIhX9jjGbesdmBktPJV9TzE35+ksr8zyNRX5r+qsZKHviLAIWgtR8Zl5JKBhh3uKBQ39
 b1gcVPYB3kRm1thYdb5MwZEdZje2sPDaAeYIqbpuD64mBdEikaHu89eyffpX+Bg7tTS9
 ihrrk5ZbDJSlNiaujkNS6XcA7Y1C9/4ahSBzoBIuAgWng1bStJpZJmSq/ZS4Z2QijUOx bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 306hnr0qyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:52:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036IgQT5048387;
        Mon, 6 Apr 2020 18:52:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30839quhfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:52:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036IqbKe028863;
        Mon, 6 Apr 2020 18:52:37 GMT
Received: from localhost (/10.159.131.9)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 11:52:37 -0700
Subject: [PATCH 2/5] libxfs: check return value of device flush when closing
 device
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 06 Apr 2020 11:52:36 -0700
Message-ID: <158619915636.469742.17283369979015724938.stgit@magnolia>
In-Reply-To: <158619914362.469742.7048317858423621957.stgit@magnolia>
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Although the libxfs_umount function flushes all devices when unmounting
the incore filesystem, the libxfs io code will flush the device again
when the application close them.  Check and report any errors that might
happen, though this is unlikely.

Coverity-id: 1460464
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/init.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 3e6436c1..cb8967bc 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -166,13 +166,18 @@ libxfs_device_close(dev_t dev)
 
 	for (d = 0; d < MAX_DEVS; d++)
 		if (dev_map[d].dev == dev) {
-			int	fd;
+			int	fd, ret;
 
 			fd = dev_map[d].fd;
 			dev_map[d].dev = dev_map[d].fd = 0;
 
-			fsync(fd);
-			platform_flush_device(fd, dev);
+			ret = platform_flush_device(fd, dev);
+			if (ret) {
+				ret = -errno;
+				fprintf(stderr,
+	_("%s: flush of device %lld failed, err=%d"),
+						progname, (long long)dev, ret);
+			}
 			close(fd);
 
 			return;

