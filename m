Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGCBNP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 21:13:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62NOd4I140945
        for <linux-xfs@vger.kernel.org>; Tue, 2 Jul 2019 23:27:57 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2te5tbpc7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jul 2019 23:27:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62NNKIQ170178
        for <linux-xfs@vger.kernel.org>; Tue, 2 Jul 2019 23:27:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2tebqgsu3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jul 2019 23:27:56 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x62NRtrF000374
        for <linux-xfs@vger.kernel.org>; Tue, 2 Jul 2019 23:27:55 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v2 1/1] xfsprogs: Fix uninitialized cfg->lsunit
Date: Tue,  2 Jul 2019 16:27:46 -0700
Message-Id: <20190702232746.22516-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

While investigating another mkfs bug, noticed that cfg->lsunit is sometimes
left uninitialized when it should not.  This is because calc_stripe_factors
in some cases needs cfg->loginternal to be set first.  This is done in
validate_logdev. So move calc_stripe_factors below validate_logdev while
parsing configs.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 mkfs/xfs_mkfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 468b8fd..6e32403 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3861,15 +3861,15 @@ main(
 		.isdirect = LIBXFS_DIRECT,
 		.isreadonly = LIBXFS_EXCLUSIVELY,
 	};
-	struct xfs_mount	mbuf = {};
+	struct xfs_mount	mbuf = {0};
 	struct xfs_mount	*mp = &mbuf;
 	struct xfs_sb		*sbp = &mp->m_sb;
-	struct fs_topology	ft = {};
+	struct fs_topology	ft = {0};
 	struct cli_params	cli = {
 		.xi = &xi,
 		.loginternal = 1,
 	};
-	struct mkfs_params	cfg = {};
+	struct mkfs_params	cfg = {0};
 
 	/* build time defaults */
 	struct mkfs_default_params	dft = {
@@ -4008,7 +4008,6 @@ main(
 	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
 
 	validate_rtextsize(&cfg, &cli, &ft);
-	calc_stripe_factors(&cfg, &cli, &ft);
 
 	/*
 	 * Open and validate the device configurations
@@ -4018,6 +4017,7 @@ main(
 	validate_datadev(&cfg, &cli);
 	validate_logdev(&cfg, &cli, &logfile);
 	validate_rtdev(&cfg, &cli, &rtfile);
+	calc_stripe_factors(&cfg, &cli, &ft);
 
 	/*
 	 * At this point when know exactly what size all the devices are,
-- 
2.7.4
