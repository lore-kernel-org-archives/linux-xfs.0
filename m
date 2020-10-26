Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE85DC2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFBF520809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:33:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dh619RIk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406466AbgJZXdD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:33:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53792 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406465AbgJZXdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:33:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOXm8164641;
        Mon, 26 Oct 2020 23:32:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gQD5phMuq0azj/jiPF1+wtOnafFV/h7gNFyHHXxFeaE=;
 b=Dh619RIkq2UKNm02qsSJ9W19su26GdJnleCGSmEI0UIjYFyEjsoXM3i/NfeGCmgh+Ln0
 vi1scK1+JnofU/hdGaSPcyzxFiwOcyytK1KXllGqKSB0hVuI6UZ5r9p5nTCbd4cjMst4
 R33wUGd/DK1y/H6lrqzeNG/Rwp9XwuhAR0akE1rOPJxQWcRpan1kRW+6T2QYF4jyZ/kB
 t/+zktW+s6JImEbgLOhnyubuMocfiLuUkvE5doQUNXxeRp+D++4IYGeylH4t8tLmL0sG
 7Sl4u08nM6d6pynn2m5es4hdgHxHKCT8dn/e6TP9o7bf0wB9d1+ztXNypjmGazlvLCUb zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34dgm3vum6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:32:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPGZq120985;
        Mon, 26 Oct 2020 23:32:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34cx6va4te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:32:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNWvPv028294;
        Mon, 26 Oct 2020 23:32:57 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:32:57 -0700
Subject: [PATCH 2/3] xfs: move the buffer retry logic to xfs_buf.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:32:56 -0700
Message-ID: <160375517648.880210.5292913443729268324.stgit@magnolia>
In-Reply-To: <160375516392.880210.12781119775998925242.stgit@magnolia>
References: <160375516392.880210.12781119775998925242.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 664ffb8a429a800c51964b94c15c6a92c8d8334c

Move the buffer retry state machine logic to xfs_buf.c and call it once
from xfs_ioend instead of duplicating it three times for the three kinds
of buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_trans_inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 82716ea27f92..a392fd293d25 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -174,9 +174,9 @@ xfs_trans_log_inode(
 
 	/*
 	 * Always OR in the bits from the ili_last_fields field.  This is to
-	 * coordinate with the xfs_iflush() and xfs_iflush_done() routines in
-	 * the eventual clearing of the ili_fields bits.  See the big comment in
-	 * xfs_iflush() for an explanation of this coordination mechanism.
+	 * coordinate with the xfs_iflush() and xfs_buf_inode_iodone() routines
+	 * in the eventual clearing of the ili_fields bits.  See the big comment
+	 * in xfs_iflush() for an explanation of this coordination mechanism.
 	 */
 	iip->ili_fields |= (flags | iip->ili_last_fields | iversion_flags);
 	spin_unlock(&iip->ili_lock);

