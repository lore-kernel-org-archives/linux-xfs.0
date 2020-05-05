Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA836C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C854F206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cbp7b2Vs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEEBK0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:10:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBK0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:10:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04514pFi143799
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LCEQjIROfRLRgYgU6SYCHWd2VHCDApNb2O45+sBPv0A=;
 b=Cbp7b2VscjQLRuHna0oh2hHudyA9oGaNYr9yGvh2VsV4hb9NIMiOwefPhczGC2gldT44
 OuKsBD2dkScvETnpKn/HK5DRMtz/Wy/hVAURaSlWU53/km3JKhiB1y2JbclAfeW7BNKQ
 cBGpHLl0057n5boS8zu/L34DS99RQQR6e54Md1RQAQY6xPMV/JNW5iFJo3aBabEwNqxs
 d41s0omXBrtYV3ROkFt8CQXr69THwIy7XLRNul5athbqRo48jsKOWKeZ1+GdBlPo9+Hi
 zXC4DzCgrwY1+lRNWA0magrlliWKID6oKQM7Knsg1e22EyJcoxmOdOD/Ee7oTicQbjfL dA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30s09r2320-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:10:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516ein149291
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30sjjxak5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:10:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0451AN3L014523
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:10:23 -0700
Subject: [PATCH 2/3] xfs: clean up the metadata validation in
 xfs_swap_extent_rmap
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:10:22 -0700
Message-ID: <158864102271.182577.2059355876586003107.stgit@magnolia>
In-Reply-To: <158864100980.182577.10199078041909350877.stgit@magnolia>
References: <158864100980.182577.10199078041909350877.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Bail out if there's something not right with either file's fork
mappings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index cc23a3e23e2d..2774939e176d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1342,8 +1342,16 @@ xfs_swap_extent_rmap(
 				&nimaps, 0);
 		if (error)
 			goto out;
-		ASSERT(nimaps == 1);
-		ASSERT(tirec.br_startblock != DELAYSTARTBLOCK);
+		if (nimaps != 1 || tirec.br_startblock == DELAYSTARTBLOCK) {
+			/*
+			 * We should never get no mapping or a delalloc extent
+			 * since the donor file should have been flushed by the
+			 * caller.
+			 */
+			ASSERT(0);
+			error = -EINVAL;
+			goto out;
+		}
 
 		trace_xfs_swap_extent_rmap_remap(tip, &tirec);
 		ilen = tirec.br_blockcount;
@@ -1360,8 +1368,17 @@ xfs_swap_extent_rmap(
 					&nimaps, 0);
 			if (error)
 				goto out;
-			ASSERT(nimaps == 1);
-			ASSERT(tirec.br_startoff == irec.br_startoff);
+			if (nimaps != 1 ||
+			    tirec.br_startoff != irec.br_startoff) {
+				/*
+				 * We should never get no mapping or a mapping
+				 * for another offset, but bail out if that
+				 * ever does.
+				 */
+				ASSERT(0);
+				error = -EFSCORRUPTED;
+				goto out;
+			}
 			trace_xfs_swap_extent_rmap_remap_piece(ip, &irec);
 
 			/* Trim the extent. */
@@ -1400,11 +1417,9 @@ xfs_swap_extent_rmap(
 		offset_fsb += ilen;
 	}
 
-	tip->i_d.di_flags2 = tip_flags2;
-	return 0;
-
 out:
-	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
+	if (error)
+		trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
 	tip->i_d.di_flags2 = tip_flags2;
 	return error;
 }

