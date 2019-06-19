Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47544 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFSS3H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jun 2019 14:29:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JIT2Vg034328
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2019 18:29:05 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t7809d331-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2019 18:29:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JISU4R048492
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2019 18:29:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t77yp0khc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2019 18:29:04 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5JIT4ph011785
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2019 18:29:04 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 1/1] xfsprogs: Fix uninitialized cfg->lsunit
Date: Wed, 19 Jun 2019 11:28:57 -0700
Message-Id: <20190619182857.9959-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

While investigating another mkfs bug, noticed that cfg->lsunit is sometimes
left uninitialized when it should not.  This is because calc_stripe_factors
in some cases needs cfg->loginternal to be set first.  This is done in
validate_logdev. So move calc_stripe_factors below validate_logdev while
parsing configs.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ddb25ec..f4a5e4b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3995,7 +3995,6 @@ main(
 	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
 
 	validate_rtextsize(&cfg, &cli, &ft);
-	calc_stripe_factors(&cfg, &cli, &ft);
 
 	/*
 	 * Open and validate the device configurations
@@ -4005,6 +4004,7 @@ main(
 	validate_datadev(&cfg, &cli);
 	validate_logdev(&cfg, &cli, &logfile);
 	validate_rtdev(&cfg, &cli, &rtfile);
+	calc_stripe_factors(&cfg, &cli, &ft);
 
 	/*
 	 * At this point when know exactly what size all the devices are,
-- 
2.7.4
