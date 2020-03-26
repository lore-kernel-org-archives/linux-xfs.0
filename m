Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9EEC43331
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 15:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22AF520737
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 15:48:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B+2qV7/V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgCZPsw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 11:48:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47342 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbgCZPsw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 11:48:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02QFhkQc090234;
        Thu, 26 Mar 2020 15:48:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=eH/RmXSS9BJZDPxwx+pX2p56159pcGfdPwzEPHt2NP0=;
 b=B+2qV7/VUJ8IIg2Mphkm+CXQ/CSVJ0YrFfFuiS0FJr7Lm60p1ybG48dKsKfns/EmzBhu
 PjufNd4QtFCwKaVmpmIj97jok9/Ry+Auc00BBZLFpZ6p3QxxYm2xrosASvwQuztEkYyj
 fzfJAI5XvPu9NlJrXj/S9WMSAmyEKdfHHOtRt5TUVwevpvp/WsryVtCdE0gLmxlOEG7T
 1QdTQwyxli++rOnlQ2mXsKWJHaOObyzT4e0NtQfSL/NPMUsfjZ8bONNVySInW2h+uuDT
 n3B9JtgelfsODZhSu8s507CjJBlWRzZlKikoUkDUWF5H4oda5onGB0uRsQntz89Dxb7C vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ywabrgn11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 15:48:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02QFlsOv176406;
        Thu, 26 Mar 2020 15:48:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3006r8nx7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 15:48:49 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02QFmmva026134;
        Thu, 26 Mar 2020 15:48:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 08:48:48 -0700
Date:   Thu, 26 Mar 2020 08:48:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH v3] xfs: validate the realtime geometry in
 xfs_validate_sb_common
Message-ID: <20200326154847.GM29351@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003260122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

The v2 patch didn't build on i386 due to 64-bit division, so I'm
committing the following v3 with the division fixed, and sending to the
list for completeness.

--D

---
From: Darrick J. Wong <darrick.wong@oracle.com>

Validate the geometry of the realtime geometry when we mount the
filesystem, so that we don't abruptly shut down the filesystem later on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
v3: use 64-bit safe division and howmany helper functions
v2: remove the excess whitespace and unlikely() bits
---
 fs/xfs/libxfs/xfs_sb.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 00266de58954..c526c5e5ab76 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -328,6 +328,38 @@ xfs_validate_sb_common(
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
+				"realtime zeroed geometry check failed");
+			return -EFSCORRUPTED;
+		}
+	} else {
+		uint64_t	rexts;
+		uint64_t	rbmblocks;
+
+		rexts = div_u64(sbp->sb_rblocks, sbp->sb_rextsize);
+		rbmblocks = howmany_64(sbp->sb_rextents,
+				       NBBY * sbp->sb_blocksize);
+
+		if (sbp->sb_rextents != rexts ||
+		    sbp->sb_rextslog != xfs_highbit32(sbp->sb_rextents) ||
+		    sbp->sb_rbmblocks != rbmblocks) {
+			xfs_notice(mp,
+				"realtime geometry sanity check failed");
+			return -EFSCORRUPTED;
+		}
+	}
+
 	if (sbp->sb_unit) {
 		if (!xfs_sb_version_hasdalign(sbp) ||
 		    sbp->sb_unit > sbp->sb_width ||
