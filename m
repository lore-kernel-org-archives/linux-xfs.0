Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7449CC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F3BB206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P2ecgChm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392149AbfIFDib (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:38:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37342 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392146AbfIFDia (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:38:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863Xr0P104870;
        Fri, 6 Sep 2019 03:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=FYXXrPLwaTe2otpJz1HVJs62nr+I8tCAp7lee9WC9BY=;
 b=P2ecgChmMpxjAIz8ZWmzpI/JbOo+pr7XDPItwniSz4JfV3s54wJkYq5J/ZameIxDjn0r
 5bSddnpmYf+UB+pwkpOUZqpeQLPVUR95hCzo2a/1qNqdVhaxb7HVLAIQuR26hk7BRJuG
 rDhbx4H+I5trmcI8PcFBj5tuaJL3HRPx8bp7mqgE+Q94nj1xtDgmjaHRTnMVegZOV/1c
 B+cT3fNlqpiRONlA382tKaN+Fb81xvWhyFVjeCYq/lVAcPPhSyOpyDEIvskg/F4Jgy+b
 R25Raj6mT0KqzwDKzoyptYjT0bnAqSGqEsyV70E+dB6945BdAaTlsVCjrEVwYDCUaxIe 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uuf5f836b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:38:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cPZh077903;
        Fri, 6 Sep 2019 03:38:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2utvr4jxrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:38:28 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863cRTH020475;
        Fri, 6 Sep 2019 03:38:27 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:38:27 -0700
Subject: [PATCH 07/11] xfs_scrub: record disk LBA size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:38:26 -0700
Message-ID: <156774110666.2645135.15931272284847388930.stgit@magnolia>
In-Reply-To: <156774106064.2645135.2756383874064764589.stgit@magnolia>
References: <156774106064.2645135.2756383874064764589.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remember the size (in bytes) of a logical block on the disk.  We'll use
this in subsequent patches to improve the ability of media scans to
report on which files are corrupt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/disk.c |    7 +++----
 scrub/disk.h |    3 ++-
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/scrub/disk.c b/scrub/disk.c
index dcdd5ba8..d2101cc6 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -193,7 +193,6 @@ disk_open(
 #endif
 	struct disk		*disk;
 	bool			suspicious_disk = false;
-	int			lba_sz;
 	int			error;
 
 	disk = calloc(1, sizeof(struct disk));
@@ -205,10 +204,10 @@ disk_open(
 		goto out_free;
 
 	/* Try to get LBA size. */
-	error = ioctl(disk->d_fd, BLKSSZGET, &lba_sz);
+	error = ioctl(disk->d_fd, BLKSSZGET, &disk->d_lbasize);
 	if (error)
-		lba_sz = 512;
-	disk->d_lbalog = log2_roundup(lba_sz);
+		disk->d_lbasize = 512;
+	disk->d_lbalog = log2_roundup(disk->d_lbasize);
 
 	/* Obtain disk's stat info. */
 	error = fstat(disk->d_fd, &disk->d_sb);
diff --git a/scrub/disk.h b/scrub/disk.h
index 74a26d98..36bfb826 100644
--- a/scrub/disk.h
+++ b/scrub/disk.h
@@ -10,7 +10,8 @@
 struct disk {
 	struct stat	d_sb;
 	int		d_fd;
-	int		d_lbalog;
+	unsigned int	d_lbalog;
+	unsigned int	d_lbasize;	/* bytes */
 	unsigned int	d_flags;
 	unsigned int	d_blksize;	/* bytes */
 	uint64_t	d_size;		/* bytes */

