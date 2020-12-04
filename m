Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0195EC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE6B5224B8
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgLDBOh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:14:37 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59028 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgLDBOh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:14:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B419me6187996;
        Fri, 4 Dec 2020 01:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ulWXev5TBEd1S3H5yWykDQzR/xZAKtBBuPazZ74mL0k=;
 b=AD1mtLfblLbJQv1DuQ/Sz1pw+WZeSKyH6J+OBr0gE2ucEk4Gn7gDRFRp8YOVbakw2Oyt
 X/Q+Ohcl7lIP2TSNGh8jV1jKX8bTmhZ6JY3kiBKjHpecyAAQt8YWDvXZt39/IFwqZKIj
 udZqFBw/Cu4Z2bEykEqXLl9Kbu1h/SP4LAQqmWxJySMo232nWlDO71GgLN34gsl12mnT
 wfdHjCdXlP6hDKUpOQ1RV1pNrkRbLuL3q2gU9Bt8mUyZYboQPED0rdGw6k3QoPuucIte
 SbU3ey1aNrvmfm5rSIb2C3m3AtEYsn9aGgzQqcrj6fChjU4sfnVSctMQPayQwO6rD9p6 Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2b939h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 01:13:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41AXP0093339;
        Fri, 4 Dec 2020 01:13:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35404rn887-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 01:13:54 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B41DrRG016996;
        Fri, 4 Dec 2020 01:13:53 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 17:13:53 -0800
Date:   Thu, 3 Dec 2020 17:13:53 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/3] xfs_repair: clear the needsrepair flag
Message-ID: <20201204011353.GD629293@magnolia>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160679383892.447856.12907477074923729733.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Clear the needsrepair flag, since it's used to prevent mounting of an
inconsistent filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/agheader.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/repair/agheader.c b/repair/agheader.c
index f28d8a7bb0de..53f541d4a53a 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -452,6 +452,17 @@ secondary_sb_whack(
 			rval |= XR_AG_SB_SEC;
 	}
 
+	if (xfs_sb_version_needsrepair(sb)) {
+		if (!no_modify)
+			sb->sb_features_incompat &=
+					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		if (!do_bzero) {
+			rval |= XR_AG_SB;
+			do_warn(_("needsrepair flag set in sb %d\n"), i);
+		} else
+			rval |= XR_AG_SB_SEC;
+	}
+
 	return(rval);
 }
 
