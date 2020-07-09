Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C6DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 16:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 277CD2078B
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 16:11:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aThu8rcm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgGIQLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 12:11:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54474 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgGIQLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 12:11:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069G7nbX194047;
        Thu, 9 Jul 2020 16:11:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=F0/dOWGhROC93o0sLJFekztwJuQg5kmHuL8lY3u+X2Q=;
 b=aThu8rcm4z+pod+yk58nVxrhuiAkCxbrhe6E4JQRnORUNvz3jdbf8SKsFZQQze6prmyo
 gX/x36PJ6P0X4AmMJ5KTOsMDIwSeLqbV+ig+DNeQsx0c8/yMvvb6xGYQ7PFWmL1Gr/s+
 Zh/N+uvfwRsWx4cq5TKW0FsXJP2LlVJd9ROGcfqQipvNqzRe8t0l3XO847ERE8qesBab
 kg8z6gq0fJZneMHawVkuWDl6xcT5jafRcx9lZDOLC6BqDK0uTPsxarLJgCmxsCXq/iye
 UKEt961bCYnXviK+dQyFUD17Si/PVV1wnaCya27Q6OHGA/w8UBKNfh24BFvhF6/Np0Kj lA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 325y0ajsf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 09 Jul 2020 16:11:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069G9HAA032063;
        Thu, 9 Jul 2020 16:11:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 325k3h9xbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jul 2020 16:11:26 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 069GBPLW013166;
        Thu, 9 Jul 2020 16:11:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jul 2020 09:11:25 -0700
Date:   Thu, 9 Jul 2020 09:11:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Bill O'Donnell" <billodo@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_quota: display warning limits when printing quota type
 information
Message-ID: <20200709161124.GP7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=1 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007090116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=1 mlxlogscore=999 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007090116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We should dump the default warning limits when we're printing quota
information.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 quota/state.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/quota/state.c b/quota/state.c
index 8f9718f1..a90b0d9e 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -130,6 +130,16 @@ state_timelimit(
 		time_to_string(timelimit, VERBOSE_FLAG | ABSOLUTE_FLAG));
 }
 
+static void
+state_warnlimit(
+	FILE		*fp,
+	uint		form,
+	uint16_t	warnlimit)
+{
+	fprintf(fp, _("%s max warnings: %u\n"),
+		form_to_string(form), warnlimit);
+}
+
 /*
  * fs_quota_stat holds a subset of fs_quota_statv; this copies
  * the smaller into the larger, leaving any not-present fields
@@ -218,7 +228,11 @@ state_quotafile_mount(
 				sv.qs_flags & XFS_QUOTA_PDQ_ENFD);
 
 	state_timelimit(fp, XFS_BLOCK_QUOTA, sv.qs_btimelimit);
+	state_warnlimit(fp, XFS_BLOCK_QUOTA, sv.qs_bwarnlimit);
+
 	state_timelimit(fp, XFS_INODE_QUOTA, sv.qs_itimelimit);
+	state_warnlimit(fp, XFS_INODE_QUOTA, sv.qs_iwarnlimit);
+
 	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv.qs_rtbtimelimit);
 }
 
