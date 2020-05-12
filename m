Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4030CA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 18:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C33AB20784
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 18:33:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dWG23Nye"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgELSdx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 14:33:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48980 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgELSdx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 14:33:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CIX4bB072728;
        Tue, 12 May 2020 18:33:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QFFy64gmGKqe+5p6u0FNSS2URwBbrwr8/EOlSLIJbfk=;
 b=dWG23NyeaUZRCp1bxZeJ1TzytcCnXOTWtZjji7i0m+viIof+579jdLrCYAetSsaFPQ4/
 B3adaeWAWDId7ztBLhX9oDku1V3XDuiNwHTvJcz4WEmFWc4Wikei6SVp7vNbfM9YcAQr
 2lnRs/tmm/1uEjtX3Ps9SHIuvxlvqR8CuJI5mQQr1tV56bUfchHMSrd8MrPBdTSM92w2
 BNpmEKyT71SeufAMuL0hFHd0APofLBlewpFtcbBcVnppkHUI+0w6z5+90y769pLMCIh7
 8LNlaRPqOkxqtoWH1utRP9k9x8uVNJhjim8TxZ6eg3q+E0jihTfA2fY9rvNIuN8MOfd+ EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3100xwg2m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 18:33:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CIWVr6154247;
        Tue, 12 May 2020 18:33:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3100yn9dxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 18:33:50 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04CIXn3t018525;
        Tue, 12 May 2020 18:33:49 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 11:33:48 -0700
Subject: [PATCH 2/2] xfs_repair: skip mount time quotacheck if our quotacheck
 was ok
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 12 May 2020 11:33:48 -0700
Message-ID: <158930842796.1920396.10122151582917073763.stgit@magnolia>
In-Reply-To: <158930841417.1920396.3792994124679376951.stgit@magnolia>
References: <158930841417.1920396.3792994124679376951.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005120140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we verified that the incore quota counts match the ondisk quota
contents, we can leave the CHKD flags set so that the next mount doesn't
have to repeat the quotacheck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/quotacheck.c |   10 ++++++++++
 repair/quotacheck.h |    1 +
 repair/xfs_repair.c |    4 +++-
 3 files changed, 14 insertions(+), 1 deletion(-)


diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index c176492f..d46dbafd 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -16,6 +16,16 @@
  */
 static uint16_t chkd_flags;
 
+/*
+ * Return CHKD flags for the quota types that we checked.  If we encountered
+ * any errors at all, return zero.
+ */
+uint16_t
+quotacheck_results(void)
+{
+	return chkd_flags;
+}
+
 /* Global incore dquot tree */
 struct qc_dquots {
 	pthread_mutex_t		lock;
diff --git a/repair/quotacheck.h b/repair/quotacheck.h
index 27865e32..02ae61b6 100644
--- a/repair/quotacheck.h
+++ b/repair/quotacheck.h
@@ -8,6 +8,7 @@
 
 void quotacheck_adjust(struct xfs_mount *mp, xfs_ino_t ino);
 void quotacheck_verify(struct xfs_mount *mp, unsigned int type);
+uint16_t quotacheck_results(void);
 int quotacheck_setup(struct xfs_mount *mp);
 void quotacheck_teardown(void);
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 8fbd3649..cc999e07 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -25,6 +25,7 @@
 #include "libfrog/fsgeom.h"
 #include "libfrog/platform.h"
 #include "bload.h"
+#include "quotacheck.h"
 
 /*
  * option tables for getsubopt calls
@@ -1100,7 +1101,8 @@ _("Warning:  project quota information would be cleared.\n"
 
 	dsb = sbp->b_addr;
 
-	if (be16_to_cpu(dsb->sb_qflags) & XFS_ALL_QUOTA_CHKD) {
+	if ((be16_to_cpu(dsb->sb_qflags) & XFS_ALL_QUOTA_CHKD) !=
+			quotacheck_results()) {
 		do_warn(_("Note - quota info will be regenerated on next "
 			"quota mount.\n"));
 		dsb->sb_qflags &= cpu_to_be16(~XFS_ALL_QUOTA_CHKD);

