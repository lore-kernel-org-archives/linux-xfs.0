Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02BB2C4727E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 14:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF8762076B
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 14:58:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TWVFS1X2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgI3O6q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 10:58:46 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44450 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728329AbgI3O6q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 10:58:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UErpc5052593;
        Wed, 30 Sep 2020 14:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=LVpXOeGodyUxpUMR1gjVhWajW0zJJncvGTDcApmxONU=;
 b=TWVFS1X2B4Q7o195PgtsV2YGyENNuNJ2A8hmfVtMR2fBVoh4JUru8+R+yp/qnOG8Iwey
 +9H8FarTx7kHEllSxjkSGLGVM5R/FbLGXM93oAPno1P4X9Ka7OCA9+f+2WFdHj3cZr7f
 RawQa7LIgdihhy8E7KrOEpnJp6D6tgpUjMbM1oT+7R19SvG4YKHcpXjow48FdG0l6iHa
 qC69j4lVwycZcK5BKwzL19jefOh5/EHqNEPfD/SlYMvhhB/Ls7mrb4XyV8TmgJgADh8A
 1Yuu70EjNFPVwssE0TchLkUDq+ePntl6dA7hcTmmCKvZ+CLrZ3SNjtQr912cbS8MCOU9 Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33su5b131f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 14:58:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UEsmJ0155420;
        Wed, 30 Sep 2020 14:58:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33tfdu2mf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 14:58:42 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08UEwfPG012906;
        Wed, 30 Sep 2020 14:58:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 07:58:41 -0700
Date:   Wed, 30 Sep 2020 07:58:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] libxfs: disallow filesystems with reverse mapping and
 reflink and realtime
Message-ID: <20200930145840.GL49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Neither the kernel nor the code in xfsprogs support filesystems that
have (either reverse mapping btrees or reflink) enabled and a realtime
volume configured.  The kernel rejects such combinations and mkfs
refuses to format such a config, but xfsprogs doesn't check and can do
Bad Things, so port those checks before someone shreds their filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/init.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/libxfs/init.c b/libxfs/init.c
index cb8967bc77d4..1a966084ffea 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -724,6 +724,20 @@ libxfs_mount(
 		exit(1);
 	}
 
+	if (xfs_sb_version_hasreflink(sbp) && sbp->sb_rblocks) {
+		fprintf(stderr,
+	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
+				progname);
+		exit(1);
+	}
+
+	if (xfs_sb_version_hasrmapbt(sbp) && sbp->sb_rblocks) {
+		fprintf(stderr,
+	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
+				progname);
+		exit(1);
+	}
+
 	xfs_da_mount(mp);
 
 	if (xfs_sb_version_hasattr2(&mp->m_sb))
