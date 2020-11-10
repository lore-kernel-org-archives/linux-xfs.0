Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BC0C388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A3A207D3
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jTSKG9F7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgKJSD1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:03:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57310 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKJSD1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:03:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHxG3Y018668;
        Tue, 10 Nov 2020 18:03:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sFzbgxO4uAdIzX90wlQXEWYw5GpnsTHh+AXiZZftmAc=;
 b=jTSKG9F7fH+JZPUKCXkgaJgydOBoxWY5PXuNiWmp3Tx1uW5ZYAFfsxhc6Np+QYX2WgXt
 qPybjB8/ybKlCy5l9vBZJ8SvJGAbzDm+nUuuTx7EJ0EGfzB6neNZyMum2WUes5QkSwfs
 ByR6wP29+NXL/VD2XoELq35rbu2QSrq0U2cceMNQTQ/rKbEeD988p3FJlV4j7iE2gzyq
 iZ1vgNW1L4SNodz2FGBT4j5zNIXAAoC+y5LE+2oBoOyRm6yKKKeNGhcC8rwi8DdfxVFl
 ahJlO2qjiT/tHf3Pm2G7LQ/C8xSF5CHyZ5NPJQIkqHir7RT8KduUY/qPfqaZrwr31j5S bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72ek8kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 18:03:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAI0qPq081448;
        Tue, 10 Nov 2020 18:03:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34p5g0p25n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 18:03:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AAI3Oec004711;
        Tue, 10 Nov 2020 18:03:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 10:03:23 -0800
Subject: [PATCH 3/9] mkfs: don't pass on extent size inherit flags when extent
 size is zero
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Nov 2020 10:03:22 -0800
Message-ID: <160503140288.1201232.14448155271122385848.stgit@magnolia>
In-Reply-To: <160503138275.1201232.927488386999483691.stgit@magnolia>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=913 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=923 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the caller passes in an extent size hint of zero, clear the inherit
flags because a hint value of zero is treated as not a hint.

Otherwise, you get stupid stuff like:
$ mkfs.xfs -d cowextsize=0 /tmp/a.img -f
illegal CoW extent size hint 0, must be less than 9600.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 908d520df909..9989cf57c295 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1438,11 +1438,17 @@ data_opts_parser(
 		break;
 	case D_EXTSZINHERIT:
 		cli->fsx.fsx_extsize = getnum(value, opts, subopt);
-		cli->fsx.fsx_xflags |= FS_XFLAG_EXTSZINHERIT;
+		if (cli->fsx.fsx_extsize)
+			cli->fsx.fsx_xflags |= FS_XFLAG_EXTSZINHERIT;
+		else
+			cli->fsx.fsx_xflags &= ~FS_XFLAG_EXTSZINHERIT;
 		break;
 	case D_COWEXTSIZE:
 		cli->fsx.fsx_cowextsize = getnum(value, opts, subopt);
-		cli->fsx.fsx_xflags |= FS_XFLAG_COWEXTSIZE;
+		if (cli->fsx.fsx_cowextsize)
+			cli->fsx.fsx_xflags |= FS_XFLAG_COWEXTSIZE;
+		else
+			cli->fsx.fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
 		break;
 	case D_DAXINHERIT:
 		if (getnum(value, opts, subopt))

