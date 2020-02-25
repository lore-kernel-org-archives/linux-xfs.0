Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12524C35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D499820838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:13:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aaEfygF3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgBYANr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:13:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50290 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728544AbgBYANr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:13:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07brA050093;
        Tue, 25 Feb 2020 00:13:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=McyzXoNGP7D04VpAqACJuCsiuRwvfexo/En1DAhwXJM=;
 b=aaEfygF3+LSYtZ/OjHiGiTwkMcWB6AUzKa/49+oRf5eRlBchwPJeQo/fQ0sB0Yc+tPY8
 xENDiplbJIYTCuvM2/xYzoByMnnhWltY3POD2Mraldf3p+rmqZ5sEm7HQASNEzK6JRnf
 0YWntOerwTl2+l4N/7ZX2r2nns7TTCD4JTfklXYje+UTbwRKDZ00QXVj3e/GpkLyCd7h
 NMsPLGsWRiFWhL2RzqZn5LddrJtosrH4rchvZiaXbDMJxrM/HiHzsjs1sRaCslMhb6cE
 gOdJwfVjWtL59tn8xw5/oVWAPRymbiksK5gsrBHspGcijMJZiGtqEKiwWsB/GUrxhAuI EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q3k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P06Wgg098039;
        Tue, 25 Feb 2020 00:13:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ybduvg0tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0DiW0032079;
        Tue, 25 Feb 2020 00:13:44 GMT
Received: from localhost (/67.169.218.210) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Mon, 24 Feb 2020 16:12:59 -0800
USER-AGENT: StGit/0.17.1-dirty
MIME-Version: 1.0
Message-ID: <158258957631.451378.6297312804413916157.stgit@magnolia>
Date:   Mon, 24 Feb 2020 16:12:56 -0800 (PST)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/25] libxfs: convert libxfs_log_clear to use uncached
 buffers
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=506 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=567 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
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
index d607a565..739f4aed 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1413,15 +1413,13 @@ libxfs_log_clear(
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
@@ -1461,7 +1459,7 @@ libxfs_log_clear(
 
 		ptr = dptr;
 		if (btp) {
-			bp = libxfs_getbufr(btp, blk, len);
+			bp = libxfs_getbufr_uncached(btp, blk, len);
 			ptr = bp->b_addr;
 		}
 		/*
@@ -1470,10 +1468,8 @@ libxfs_log_clear(
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

