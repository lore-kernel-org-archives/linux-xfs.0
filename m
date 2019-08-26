Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19783C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC63621881
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qly/ohL5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbfHZVaz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:30:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50448 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbfHZVaz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:30:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLFSOD162375;
        Mon, 26 Aug 2019 21:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=lyuSMxcaA4HvNDpSU6V/V2Hwd+1dSiaG5oKRiPlGTeY=;
 b=Qly/ohL57pbZNQ1szx2aT1biCS/4yRbUadrJh0YOTV9ZfMVWKRF9AQgNvcQAz5MzBzUv
 e/yxjDB6lButqZlx/MlJWa3poLH3rjp7pWdi4c8qx+LOcUJ6MYvDIjWhvnca5i9OIWC0
 wvROdzN/8xCLrS11Z+yorPA8U9x26GbP97bA83VDm8Q69VDk8tQ8Icl9K9VhP2his9YB
 NkIDeSPQLexmJjpFB5vm5YT3hSxx4Q3HQTMFS7zFlM9WzMzb4buiNd4t3btG84N4eh20
 4MTpmXhKDx6eG8kVYXiL6llitJFtFR5zNg34QSCz3sz8G600urtTmVuGYimysi1Upuu9 zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2umq5t8290-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLItfV185080;
        Mon, 26 Aug 2019 21:30:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2umj2xvy43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:52 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLUpNq029695;
        Mon, 26 Aug 2019 21:30:51 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:30:50 -0700
Subject: [PATCH 09/11] xfs_scrub: return bytes verified from a SCSI VERIFY
 command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:30:50 -0700
Message-ID: <156685504999.2841898.3845253676802836561.stgit@magnolia>
In-Reply-To: <156685499099.2841898.18430382226915450537.stgit@magnolia>
References: <156685499099.2841898.18430382226915450537.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since disk_scsi_verify and pread are interchangeably called from
disk_read_verify(), we must return the number of bytes verified (or -1)
just like what pread returns.  This doesn't matter now due to bugs in
scrub, but we're about to fix those bugs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/disk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/scrub/disk.c b/scrub/disk.c
index b728d1c7..e34a8217 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -144,7 +144,7 @@ disk_scsi_verify(
 	iohdr.timeout = 30000; /* 30s */
 
 	error = ioctl(disk->d_fd, SG_IO, &iohdr);
-	if (error)
+	if (error < 0)
 		return error;
 
 	dbg_printf("VERIFY(16) fd %d lba %"PRIu64" len %"PRIu64" info %x "
@@ -163,7 +163,7 @@ disk_scsi_verify(
 		return -1;
 	}
 
-	return error;
+	return blockcount << BBSHIFT;
 }
 #else
 # define disk_scsi_verify(...)		(ENOTTY)

