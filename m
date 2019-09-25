Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A124AC432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7309620872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GV5qyw9/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfIYVf5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:35:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60216 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbfIYVf4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:35:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYRWZ054822;
        Wed, 25 Sep 2019 21:35:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=zAjXva+PC8/QMXuOkpSNqIOC7Z7vSbnIAH9MIXKr3ME=;
 b=GV5qyw9/cRTZBuJciXMPvj/0gUFEmtGBfAPMcdcXebcN7CXJzRD1/x4DYEzK2Iw8MDxf
 r9oaN16RmMPuDt/CEswAvX1YVPRqA7rYrEicbI4tnOaaUUHcmEeM+9Iv7piYvmnaqkfN
 Rp8bOrFFqwWDQem8X8PtsMmo6MPExCCZu1smHCFlmriZbLwo9AeroTywt6s7fdCvbgUo
 GA2fgERUkuIUc2OK+jcyGvM8I1XO3jMTU9pijlizqSthW8KUqWa4MoDJBJJ0uWmiR7ZL
 0jZVkO9+sfx7DXPj+syuKmoCxhwZL4AFj2BvenlHTZtEi2hutOqTGBeFLBmU6rdmmliQ xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgr7f1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYVF2097943;
        Wed, 25 Sep 2019 21:35:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v82qaku54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:53 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLZrB7015175;
        Wed, 25 Sep 2019 21:35:53 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:35:53 -0700
Subject: [PATCH 09/11] xfs_scrub: return bytes verified from a SCSI VERIFY
 command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:35:51 -0700
Message-ID: <156944735184.298887.10018131559275191626.stgit@magnolia>
In-Reply-To: <156944728875.298887.8311229116097714980.stgit@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
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
index d2101cc6..bf9c795a 100644
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

