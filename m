Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D254C43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 01:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 415772082D
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 01:16:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jnaIiG2W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgC0BQZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 21:16:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52210 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbgC0BQZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 21:16:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R1ATCj097776;
        Fri, 27 Mar 2020 01:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=+Qc6hgt1SxNtt1W4te33ZOg095qzVvwBt3uIexuIKxA=;
 b=jnaIiG2WmLuigasHObHgrQ+NyDFy51q/7efLX3q/L9GH8dfO+zkOUeGzG8Xm5WApyRc4
 ev8pJYuKwop4wrFO3yBPXsqCGaLr3lszHp770nSsn3VDA8AEVZ7IS9gPVk3u5rotcqwI
 9k/c8VkcDuUm3IbZEhvd8xpNLDdzYyuJHZx70cCXSyuNA+ga4mzNBGZFdXlbIQpX+9aM
 vm75JIrW5dnDTK6e37efAtwRh56pVJkOtcOdgtR2rNEg/MdxJlvmhR+3e6kHU7VCTUmP
 EMCqCZFfrpGhHyGHjkZ3OeJWO0jV7M73UDqppDLLQq2ASJZJZqCSbddAOmrYcepF2toT hQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 300urk3j6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 01:16:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R1861Y157081;
        Fri, 27 Mar 2020 01:14:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3006r9ejpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 01:14:20 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02R1EI59017649;
        Fri, 27 Mar 2020 01:14:18 GMT
Received: from localhost (/10.159.247.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 18:14:18 -0700
Date:   Thu, 26 Mar 2020 18:14:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: don't write a corrupt unmount record to force summary
 counter recalc
Message-ID: <20200327011417.GF29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit f467cad95f5e3, I added the ability to force a recalculation of
the filesystem summary counters if they seemed incorrect.  This was done
(not entirely correctly) by tweaking the log code to write an unmount
record without the UMOUNT_TRANS flag set.  At next mount, the log
recovery code will fail to find the unmount record and go into recovery,
which triggers the recalculation.

What actually gets written to the log is what ought to be an unmount
record, but without any flags set to indicate what kind of record it
actually is.  This worked to trigger the recalculation, but we shouldn't
write bogus log records when we could simply write nothing.

Fixes: f467cad95f5e3 ("xfs: force summary counter recalc at next mount")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 46108ca20d85..00fda2e8e738 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -835,19 +835,6 @@ xlog_unmount_write(
 	if (error)
 		goto out_err;
 
-	/*
-	 * If we think the summary counters are bad, clear the unmount header
-	 * flag in the unmount record so that the summary counters will be
-	 * recalculated during log recovery at next mount.  Refer to
-	 * xlog_check_unmount_rec for more details.
-	 */
-	if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS), mp,
-			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
-		xfs_alert(mp, "%s: will fix summary counters at next mount",
-				__func__);
-		flags &= ~XLOG_UNMOUNT_TRANS;
-	}
-
 	error = xlog_write_unmount_record(log, tic, &lsn, flags);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
@@ -913,6 +900,20 @@ xfs_log_unmount_write(
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
+
+	/*
+	 * If we think the summary counters are bad, avoid writing the unmount
+	 * record to force log recovery at next mount, after which the summary
+	 * counters will be recalculated.  Refer to xlog_check_unmount_rec for
+	 * more details.
+	 */
+	if (XFS_TEST_ERROR(xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS), mp,
+			XFS_ERRTAG_FORCE_SUMMARY_RECALC)) {
+		xfs_alert(mp, "%s: will fix summary counters at next mount",
+				__func__);
+		return;
+	}
+
 	xfs_log_unmount_verify_iclog(log);
 	xlog_unmount_write(log);
 }
