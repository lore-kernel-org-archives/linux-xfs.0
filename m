Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73498C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50710207DD
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W2s2vxaK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388962AbgFYBSZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:18:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33700 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388942AbgFYBSY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 21:18:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P18v1H138953;
        Thu, 25 Jun 2020 01:18:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3jN1/3V65KkKRMJRafUFyULZzBRevGl/ZJwrb2lm2DI=;
 b=W2s2vxaKESGCCNX3P7y4qZK4001LIiDb3GWi+cHxSO2w2924DE4A2ctsZEkZoswGEKrN
 zGtwHjXNgfh/At78m9GyqckgVXIQFekIL+QPsJjs6wzsxcusgeoHmd2x8W24xkJ4/2O5
 /FgSbHgm3vJ08EvkEZTLs0OkJYSwejbrQYfSVcWRr8mjr3IBcXWJJWGZifpiAb9LVaPp
 hM0U4rgvqmNY0jcxouCdWou7pIedYw5Kl9nTiVaxuBUBOju8KX8Vx5uU50cEbS2/2NUz
 syQLylZ69hIz1sML3RKaXsoej/yUMHzW+NWgLtMg2h5z+R2GdXYZ6LSeyTuE4Fg+gKgj 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31uustwvqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 01:18:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P18Blb157981;
        Thu, 25 Jun 2020 01:18:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31uur7tm8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 01:18:20 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05P1IJ7Z009904;
        Thu, 25 Jun 2020 01:18:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 01:18:19 +0000
Subject: [PATCH 6/9] xfs: reflink can skip remap existing mappings
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Date:   Wed, 24 Jun 2020 18:18:18 -0700
Message-ID: <159304789856.874036.15102270304208951038.stgit@magnolia>
In-Reply-To: <159304785928.874036.4735877085735285950.stgit@magnolia>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 bulkscore=0
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

If the source and destination map are identical, we can skip the remap
step to save some time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 72de7179399d..f1156f121b7d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1031,6 +1031,23 @@ xfs_reflink_remap_extent(
 
 	trace_xfs_reflink_remap_extent_dest(ip, &smap);
 
+	/*
+	 * Two extents mapped to the same physical block must not have
+	 * different states; that's filesystem corruption.  Move on to the next
+	 * extent if they're both holes or both the same physical extent.
+	 */
+	if (dmap->br_startblock == smap.br_startblock) {
+		ASSERT(dmap->br_startblock == smap.br_startblock);
+		if (dmap->br_state != smap.br_state)
+			error = -EFSCORRUPTED;
+		goto out_cancel;
+	}
+
+	/* If both extents are unwritten, leave them alone. */
+	if (dmap->br_state == XFS_EXT_UNWRITTEN &&
+	    smap.br_state == XFS_EXT_UNWRITTEN)
+		goto out_cancel;
+
 	/* No reflinking if the AG of the dest mapping is low on space. */
 	if (dmap_written) {
 		error = xfs_reflink_ag_has_free_space(mp,

