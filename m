Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B6EC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4492D21D1B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:01:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="crGpoKlq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgIQHBU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:01:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47590 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgIQHBL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:01:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H6wrfr042903;
        Thu, 17 Sep 2020 07:01:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=WO5AHQDIpbrjQyg7EIVCKPGkBGlMLKYJAv95yohBB50=;
 b=crGpoKlqOnTYEzmZXtGCqsYwVqdl+VFiPeZAyuvhEJp024qJOOsedE1nYxVdE+o5W7+t
 wx4s94oD8SiJ1Qz3Dc7z5QrGYYtLbeSPPdq91E5yvaDUyju+evYcp0fbTN9J5x9U93+8
 bcz68mmKDL5Wp1s2NYGwAfZip4Qru7NMfTm6b+vxrCdyNdjO0a78TMYL1L+2GS7QGSdp
 WnryYJBAgLoUJHQXk352K3uAUdd691fEYI3rsQramcT4cAr7374O+KPVYF0KdaIZQ51u
 YCjmwkQb1nPD6Eiq8imGk7TaUdJ99BVqs5A8Q5OpqwG9hWOdzkEz72RQuRlcHiyK4lkl lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9mf7cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 07:01:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H70nGB096474;
        Thu, 17 Sep 2020 07:01:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33h8936vtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 07:01:05 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08H7143r007274;
        Thu, 17 Sep 2020 07:01:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 07:01:04 +0000
Date:   Thu, 17 Sep 2020 00:01:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: [PATCH v2 2/2] xfs: attach inode to dquot in xfs_bui_item_recover
Message-ID: <20200917070103.GU7955@magnolia>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <160031333615.3624373.7775190767495604737.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031333615.3624373.7775190767495604737.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170051
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In the bmap intent item recovery code, we must be careful to attach the
inode to its dquots (if quotas are enabled) so that a change in the
shape of the bmap btree doesn't cause the quota counters to be
incorrect.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: use dqattach_locked
---
 fs/xfs/xfs_bmap_item.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 815a0563288f..2b1cf3ed8172 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -24,6 +24,7 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_quota.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -498,6 +499,10 @@ xfs_bui_item_recover(
 	if (error)
 		goto err_inode;
 
+	error = xfs_qm_dqattach_locked(ip, false);
+	if (error)
+		goto err_inode;
+
 	if (VFS_I(ip)->i_nlink == 0)
 		xfs_iflags_set(ip, XFS_IRECOVERY);
 
