Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F4AC35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF54520838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EBx0vnbY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBYALT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:11:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58694 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYALT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:11:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08Voa129970;
        Tue, 25 Feb 2020 00:11:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6dp5tqHOQpe0c4LcHpdwY03LdP/Cej8MH8TFeuveIVg=;
 b=EBx0vnbY315pPx09hIYX5KZ6vx5o3alvEPWCRp+RIskCXPeXmKJttOxeQRcPMOt1XfEZ
 tWKffQksg5yiATRjzNatdWZKTMGH3Pmpwi0VQB/YPsoAFL8w4UGwsR4Fy6BHyGhuMvcG
 tT/S6eAluydrHIZ0jzcJvO24JwQFYCeEjdXDXG3+ya9mU9jEbmpChXFNhW3zY6+ZYZhA
 f7zfBtUuE+Z6AjIPg5g6d/BxnSufbqtt7p+p5FZA61vRbuD0DGOY4LtK73PwWfJpfpa4
 l1t1MnQI0mdegLQDn1hjav5kn7nB1UALC4GpCV/t/rH5JLVimCtXTc5Z+iw/NJjzutl2 wA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yavxrjrnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08DGl014948;
        Tue, 25 Feb 2020 00:11:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ybdshxvyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:14 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0BDgU011259;
        Tue, 25 Feb 2020 00:11:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:11:13 -0800
Subject: [PATCH 7/7] libfrog: always fsync when flushing a device
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Date:   Mon, 24 Feb 2020 16:11:11 -0800
Message-ID: <158258947176.451075.17374209516005783362.stgit@magnolia>
In-Reply-To: <158258942838.451075.5401001111357771398.stgit@magnolia>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
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

