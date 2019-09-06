Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B59C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC69E206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:38:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ba9liCPv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392153AbfIFDin (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:38:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44766 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392146AbfIFDin (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:38:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XpYf074291;
        Fri, 6 Sep 2019 03:38:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=zAjXva+PC8/QMXuOkpSNqIOC7Z7vSbnIAH9MIXKr3ME=;
 b=Ba9liCPvx7FrXUigZBFbGVcoqVU3+WtYwVIlOLToC6N24JPGu6gOmQZiWdtGVpR+xfNq
 cgTEZl3d7z9wdWY/jWRaO02h2MXL9GVUIcx9cUSOp4KuSzEbqvrkGllk416oi1z/pkSA
 6KPODdIQYByxNsdDjH2ic0bdxgnUL/goY3NxGKfhCTlnEfcki/nVO0m9n7uE24a9dFDa
 DbSm2wFYZbQYAaindvkprkdVZ2RxmtU4OD9aTFdGqpR56USunl/5MFFTsEZFaZ8jNzae
 ZBizBKirOh5IwtbPmcjYQp48jzH+gGfFnNdVM56Veemp6NWX79i3GHY5TukrCkrpMgiH Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uuf51g3c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:38:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cPlD077880;
        Fri, 6 Sep 2019 03:38:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2utvr4jy03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:38:40 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863cdFi019844;
        Fri, 6 Sep 2019 03:38:39 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:38:39 -0700
Subject: [PATCH 09/11] xfs_scrub: return bytes verified from a SCSI VERIFY
 command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:38:39 -0700
Message-ID: <156774111898.2645135.3530205346306381964.stgit@magnolia>
In-Reply-To: <156774106064.2645135.2756383874064764589.stgit@magnolia>
References: <156774106064.2645135.2756383874064764589.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
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

