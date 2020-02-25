Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24F35C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAF7521927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dhStDw3+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgBYALY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:11:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46876 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYALY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:11:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07aaG050082;
        Tue, 25 Feb 2020 00:11:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kBSTEFDyvjzYVodbr71WmQOzg5o8qEAiChACPDmfS54=;
 b=dhStDw3+FxEH5UbHbOVePdChOrTTxWl3yu4J/YR6Q2BzXFwNMyAXhB8jP2FWo6grbHWO
 qQvEDojz7zabuZ6HYpdzr1KZePqNt209fmSQQwNb/OHDseXekActDW1wwbCKJ4Rk6LAF
 nAzmpdQyozkaa3ZSlvaaN3Rjaeo70gDs1Z+/XrJmJBx52s1td2ZosBSj1R5QZhZM0cuQ
 0boDwdNUIjC8QkESabDNf8J0ptFdgNyXGQz7J3u+qcJOCxfTT2d3YtE5xZkraqu+3GoG
 9nm9s7TJ/Y9HOmN4qcrPkyn7+1pAvvV/x4ReNxsaBgcAAHS0iK4ZNfTLj84Xv7LcsL34 Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q375-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P088WV158191;
        Tue, 25 Feb 2020 00:11:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yby5e9dp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:11:22 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0BL8G030253;
        Tue, 25 Feb 2020 00:11:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:11:21 -0800
Subject: [PATCH 1/2] libxfs: zero the struct xfs_mount when unmounting the
 filesystem
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:11:20 -0800
Message-ID: <158258948007.451256.11063346596276638956.stgit@magnolia>
In-Reply-To: <158258947401.451256.14269201133311837600.stgit@magnolia>
References: <158258947401.451256.14269201133311837600.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=2 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=2 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since libxfs doesn't allocate the struct xfs_mount *, we can't just free
it during unmount.  Zero its contents to prevent any use-after-free.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/init.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/init.c b/libxfs/init.c
index d4804ead..197690df 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -904,6 +904,7 @@ libxfs_umount(
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
 		kmem_free(mp->m_logdev_targp);
 	kmem_free(mp->m_ddev_targp);
+	memset(mp, 0, sizeof(struct xfs_mount));
 
 	return error;
 }

