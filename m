Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BF1C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE72B20706
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N8R8iQo/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388961AbgFYBSU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:18:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33640 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388942AbgFYBSR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 21:18:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P18v1G138953;
        Thu, 25 Jun 2020 01:18:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=glXHqMEBMxNEib2fPSNiAm0R/tedc1/NIrv1/3DTySA=;
 b=N8R8iQo/+ylUQzV2NZQBPhby+PfFwrFZPBwh+K7uA5M3CafWwjW4zoCGNmpJPRFUGvi2
 ImmH44zVcRfX0eERiChEfk9BnrDC6HCxJiSPJ2ESF4MurPsjRskiGbodERb8BAdg5A4D
 uwBYtcPlFhFesA0oQhu7xcXnQlVmE7j+WdMuZRhHhrI2pEmwnyopAEwFwdH5eHQVJnje
 idezlRAqKCjjDJjpkek8W/gG5OuZ3294Z0idRriJszoioBDzjqOns1nmFXAj1FvDORc5
 ToE6JEs4mH7XGyjYl1sTIjIxr3vd12BuYz3CdC+xzjcAsYuhnABjUzUvHPpJh7wdAj6k yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31uustwvqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 01:18:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P17u5t180656;
        Thu, 25 Jun 2020 01:18:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31uur0fx8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 01:18:14 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05P1IDkY009797;
        Thu, 25 Jun 2020 01:18:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 01:18:13 +0000
Subject: [PATCH 5/9] xfs: only reserve quota blocks if we're mapping into a
 hole
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Date:   Wed, 24 Jun 2020 18:18:12 -0700
Message-ID: <159304789231.874036.3844840616429094322.stgit@magnolia>
In-Reply-To: <159304785928.874036.4735877085735285950.stgit@magnolia>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=1 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When logging quota block count updates during a reflink operation, we
only log the /delta/ of the block count changes to the dquot.  Since we
now know ahead of time the extent type of both dmap and smap (and that
they have the same length), we know that we only need to reserve quota
blocks for dmap's blockcount if we're mapping it into a hole.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 9cc1c340d0ec..72de7179399d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1051,7 +1051,9 @@ xfs_reflink_remap_extent(
 	 *
 	 * If we are mapping a written extent into the file, we need to have
 	 * enough quota block count reservation to handle the blocks in that
-	 * extent.
+	 * extent.  We log only the delta to the quota block counts, so if the
+	 * extent we're unmapping also has blocks allocated to it, we don't
+	 * need a quota reservation for the extent itself.
 	 *
 	 * Note that if we're replacing a delalloc reservation with a written
 	 * extent, we have to take the full quota reservation because removing
@@ -1063,7 +1065,7 @@ xfs_reflink_remap_extent(
 	qres = qdelta = 0;
 	if (smap_mapped || dmap_written)
 		qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	if (dmap_written)
+	if (!smap_mapped && dmap_written)
 		qres += dmap->br_blockcount;
 	if (qres > 0) {
 		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,

