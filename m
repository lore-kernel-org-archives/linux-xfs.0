Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A938C1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 06:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F878206F8
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 06:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ytoTeo/0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgCYGHX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 02:07:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46992 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgCYGHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 02:07:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P5xBwr069223;
        Wed, 25 Mar 2020 06:07:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=K+hYCkBTkkBHdU3V9dl/p7s6G5+Y/tPalh3a95CQ4gM=;
 b=ytoTeo/0UGhxXw2jlTdbuCWFo6V8TSAMPgxzmYskJR2w0pOPOl+beUxCOy1u7JZ+JBik
 BYFhOk3jKzycvxGw7AXH7FvEEhIIBnFzuUN63xTTfd7jgHetQTkv28GxZ4omtf5O/y1I
 KQKEo0zP0myPFfwtxmk1X1GnLXO2dss6IrTxWv/T+YOMRMpsOa8z2k2PxKrULQQ3WjA5
 rn54lYF93S2qFA/rDV4KS3OXz4MA04+wgKqNC+c5Fqj6a1WP2/ASoHaaDPwWJF8w84TA
 wZ7tcFdeonrZAsSQP/AtSXUmMU4RtBv06O7MxKiLakhsw9V0XOyuAFe2JU/8bvrWlxJ9 Fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ywabr7y90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 06:07:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P5wRRJ108514;
        Wed, 25 Mar 2020 06:07:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2yxw4qubrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 06:07:21 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02P67Khc023574;
        Wed, 25 Mar 2020 06:07:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 23:07:20 -0700
Date:   Tue, 24 Mar 2020 23:07:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2 2/4] xfs: validate the realtime geometry in
 xfs_validate_sb_common
Message-ID: <20200325060719.GX29339@magnolia>
References: <158510667039.922633.6138311243444001882.stgit@magnolia>
 <158510668306.922633.16796248628127177511.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158510668306.922633.16796248628127177511.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Validate the geometry of the realtime geometry when we mount the
filesystem, so that we don't abruptly shut down the filesystem later on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: remove the excess whitespace and unlikely() bits
---
 fs/xfs/libxfs/xfs_sb.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 2f60fc3c99a0..9a0cd25ec22a 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -328,6 +328,36 @@ xfs_validate_sb_common(
 		return -EFSCORRUPTED;
 	}
 
+	/* Validate the realtime geometry; stolen from xfs_repair */
+	if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
+	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE) {
+		xfs_notice(mp,
+			"realtime extent sanity check failed");
+		return -EFSCORRUPTED;
+	}
+
+	if (sbp->sb_rblocks == 0) {
+		if (sbp->sb_rextents != 0 || sbp->sb_rbmblocks != 0 ||
+		    sbp->sb_rextslog != 0 || sbp->sb_frextents != 0) {
+			xfs_notice(mp,
+				"realtime zeroed geometry sanity check failed");
+			return -EFSCORRUPTED;
+		}
+	} else {
+		xfs_rtblock_t	rexts;
+		uint32_t	temp;
+
+		rexts = div_u64_rem(sbp->sb_rblocks, sbp->sb_rextsize, &temp);
+		if (rexts != sbp->sb_rextents ||
+		    sbp->sb_rextslog != xfs_highbit32(sbp->sb_rextents) ||
+		    sbp->sb_rbmblocks != howmany(sbp->sb_rextents,
+						 NBBY * sbp->sb_blocksize)) {
+			xfs_notice(mp,
+				"realtime geometry sanity check failed");
+			return -EFSCORRUPTED;
+		}
+	}
+
 	if (sbp->sb_unit) {
 		if (!xfs_sb_version_hasdalign(sbp) ||
 		    sbp->sb_unit > sbp->sb_width ||
