Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B6BC3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F390D2469C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vbm3MM/B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgB1XiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:38:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42476 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1XiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:38:08 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXabP028494;
        Fri, 28 Feb 2020 23:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=V/xB/g2GdLXhIg65lpBNMiBAn+FqrDDw/IO3DW0RgLU=;
 b=vbm3MM/BY9M6JKidMMAG/TE5jJGrDGRMF7RKWdpwBvpuvuFa2J/6pPQ3+8FOeByz6k1m
 iw82wc2pIg6HVZaeNUgOF/yzcAVynfbShq7CZiZKmpFfqXBLMkSXm9WbpGXYp1d1rvGL
 FPQkapZwY0Xyrt+0nL7GIn1xqdf1I07Wz/7h+lBYN3RmGvbwF0U1yvloPkgMe/OTAdDH
 85HhmylgxU8APWmHbagM7NtCr2xjlN7epjroqcdb9rniOVZZtMuREeZ7LOUnZ19KhsO8
 ZetQqWDITvxD7jpD6RjWC9O6ojPX82zanT2hBOEo9vJcz1Jxma4kX8m7RwZ8Tm12Esvb aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ydct3nt4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWqrX156478;
        Fri, 28 Feb 2020 23:38:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ydcsgbc32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SNc40f025318;
        Fri, 28 Feb 2020 23:38:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:37:49 -0800
Subject: [PATCH 14/26] libxfs: convert libxfs_log_clear to use uncached
 buffers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Feb 2020 15:37:48 -0800
Message-ID: <158293306846.1549542.6988917301256455028.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=511 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=577 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the log clearing function to use uncached buffers like
everything else, instead of using the raw buffer get/put functions.
This will eventually enable us to hide them more effectively.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index f76ac228..cc7db73b 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1420,15 +1420,13 @@ libxfs_log_clear(
 	/* write out the first log record */
 	ptr = dptr;
 	if (btp) {
-		bp = libxfs_getbufr(btp, start, len);
+		bp = libxfs_getbufr_uncached(btp, start, len);
 		ptr = bp->b_addr;
 	}
 	libxfs_log_header(ptr, fs_uuid, version, sunit, fmt, lsn, tail_lsn,
 			  next, bp);
-	if (bp) {
-		bp->b_flags |= LIBXFS_B_DIRTY;
-		libxfs_putbufr(bp);
-	}
+	if (bp)
+		libxfs_writebuf(bp, 0);
 
 	/*
 	 * There's nothing else to do if this is a log reset. The kernel detects
@@ -1468,7 +1466,7 @@ libxfs_log_clear(
 
 		ptr = dptr;
 		if (btp) {
-			bp = libxfs_getbufr(btp, blk, len);
+			bp = libxfs_getbufr_uncached(btp, blk, len);
 			ptr = bp->b_addr;
 		}
 		/*
@@ -1477,10 +1475,8 @@ libxfs_log_clear(
 		 */
 		libxfs_log_header(ptr, fs_uuid, version, BBTOB(len), fmt, lsn,
 				  tail_lsn, next, bp);
-		if (bp) {
-			bp->b_flags |= LIBXFS_B_DIRTY;
-			libxfs_putbufr(bp);
-		}
+		if (bp)
+			libxfs_writebuf(bp, 0);
 
 		blk += len;
 		if (dptr)

