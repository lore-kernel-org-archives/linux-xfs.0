Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC35EC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 16:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A239F2074A
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 16:56:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hvnr/7eu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgENQ4j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 12:56:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56552 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgENQ4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 12:56:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGr9qD173735;
        Thu, 14 May 2020 16:56:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZFu59slLGSMPHS7WuNFCjxYikFIRBTvNEldet01Z7+w=;
 b=hvnr/7euY627UqnW1DGYs0jZ8UmHi4R3boVFRuCr4djeTyhc75FP4IQEswzJqIyevsqT
 KVNaV/lxQFPoJJSNiV3bw0teMkTSgIU/H/nc/n5BEUsyh1A/k+W4VPDdz3SjDPSUhFMW
 mFvvDed8LBgDcflM+DZ/XpNfVSyMKFLKe9RuNH/Rzog0f0HaAayz/ca7Ofj62FIv5f6H
 WA9y9OgsWLoLpa/Rh/4fG0PXQbxkxbcTG6T5UTvwKvivF6fFkFFlsA19L/qp6S3OGXSY
 1r6UKEbgLqSw603/V0B3hjHhBqO0cenvQtP1SN70s0b+h2sS5dgmUAUdnaHbcQhrjkVj KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3100xwurq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 16:56:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGs7jl154974;
        Thu, 14 May 2020 16:56:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3100yh5dpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 16:56:36 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EGuZd1005583;
        Thu, 14 May 2020 16:56:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 09:56:35 -0700
Subject: [PATCH 2/4] xfs_repair: fix clearing of quota CHKD flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 May 2020 09:56:34 -0700
Message-ID: <158947539434.2482564.14967976160614785881.stgit@magnolia>
In-Reply-To: <158947538149.2482564.3112804204578429865.stgit@magnolia>
References: <158947538149.2482564.3112804204578429865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

XFS_ALL_QUOTA_CHKD, being a OR of [UGP]QUOTA_CHKD, is a bitset of the
possible *incore* quota checked flags.  This means that it cannot be
used in a comparison with the *ondisk* quota checked flags because V4
filesystems set OQUOTA_CHKD, not the [GU]QUOTA_CHKD flags (which are V5
flags).

If you have a V4 filesystem with user quotas disabled but either group
or project quotas enabled, xfs_repair will /not/ claim that the quota
info will be regenerated on the next mount like it does in any other
situation.  This is because the ondisk qflags field has OQUOTA_CHKD set
but repair fails to notice.

Worse, if you have a V4 filesystem with user and group quotas enabled
and mild corruption, repair will claim that the quota info will be
regenerated.  If you then mount the fs with only group quotas enabled,
quotacheck will not run to correct the data because repair failed to
clear OQUOTA_CHKD properly.

These are fairly benign and unlikely scenarios, but when we add
quotacheck capabilities to xfs_repair, it will complain about the
incorrect quota counts, which causes regressions in xfs/278.

Fixes: 342aef1ec0ec ("xfsprogs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/xfs_repair.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 8fbd3649..9ab3cafa 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1100,10 +1100,13 @@ _("Warning:  project quota information would be cleared.\n"
 
 	dsb = sbp->b_addr;
 
-	if (be16_to_cpu(dsb->sb_qflags) & XFS_ALL_QUOTA_CHKD) {
+	if (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) {
 		do_warn(_("Note - quota info will be regenerated on next "
 			"quota mount.\n"));
-		dsb->sb_qflags &= cpu_to_be16(~XFS_ALL_QUOTA_CHKD);
+		dsb->sb_qflags &= cpu_to_be16(~(XFS_UQUOTA_CHKD |
+						XFS_GQUOTA_CHKD |
+						XFS_PQUOTA_CHKD |
+						XFS_OQUOTA_CHKD));
 	}
 
 	if (copied_sunit) {

