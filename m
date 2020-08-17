Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B587C433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 628FF204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:00:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OziqLLc/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgHQXAs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:00:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41884 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgHQXAq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:00:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMuu86136112;
        Mon, 17 Aug 2020 23:00:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZTwQTMn+bmKz2sa/ePtYNIFWWIfKQfsymsvGiSdvHSU=;
 b=OziqLLc/pXBcHnUudKjvG6AeA0uqB2NnzrW1aIXm1dPsO3yyVl/qlDgT2Chx2e5gAIZK
 4R9L3MMo0+cICtHNQPXBoBtJAEH8US+C++wpMD/ihBQnmd5igffMV5oWcK4zH/gecftN
 vm1we+GV4qChRuvXoaJyMsHEu9MuApu9y5BeRsGAr4/6EVZRtoqoiK1YWqC3dfFawTL2
 /JgEEiIoKalK5pcjQy3sxGxNSkSSEVvnhcc3WnF6Kh5JUjeDV4x+eep/UVV5al+Xxz0e
 8l9wP0vhrh6c0qQeB2xa76vk8aC7apg6fLXc2688CA70dkoIl2Gb5PYv4VdNUjvJ5BCm wQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32x8bn1g4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:00:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwthT113630;
        Mon, 17 Aug 2020 23:00:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32xsmwgjkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 23:00:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HN0hd9018568;
        Mon, 17 Aug 2020 23:00:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 16:00:42 -0700
Subject: [PATCH 17/18] xfs_repair: support bigtime
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 16:00:41 -0700
Message-ID: <159770524187.3958786.13522554876108493954.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the bigtime iflag in relation to the fs feature set.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index ad2f672d8703..3507cd06075d 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2173,7 +2173,8 @@ check_nsec(
 	union xfs_timestamp	*t,
 	int			*dirty)
 {
-	if ((dip->di_flags2 & be64_to_cpu(XFS_DIFLAG2_BIGTIME)) ||
+	if ((dip->di_version >= 3 &&
+	     (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME))) ||
 	    be32_to_cpu(t->t_nsec) < NSEC_PER_SEC)
 		return;
 
@@ -2601,6 +2602,16 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 			flags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
 		}
 
+		if ((flags2 & XFS_DIFLAG2_BIGTIME) &&
+		    !xfs_sb_version_hasbigtime(&mp->m_sb)) {
+			if (!uncertain) {
+				do_warn(
+	_("inode %" PRIu64 " is marked bigtime but file system does not support large timestamps\n"),
+					lino);
+			}
+			flags2 &= ~XFS_DIFLAG2_BIGTIME;
+		}
+
 		if (!verify_mode && flags2 != be64_to_cpu(dino->di_flags2)) {
 			if (!no_modify) {
 				do_warn(_("fixing bad flags2.\n"));

