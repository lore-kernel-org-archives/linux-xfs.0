Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA2EC43334
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 03:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiGEDU1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jul 2022 23:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiGEDU0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jul 2022 23:20:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920AE11814
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jul 2022 20:20:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264M46pT001181
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jul 2022 03:20:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=ZIFj59pRZxmUaCL2pQhxLHSyZI9vX39fGoZpX23UoMA=;
 b=uF/pj8eFx6ecztbOqVKjar26NIdtulNsg/uDmxGYinSDceOPy11JKE2mZ/OZW6+3cn7r
 ngwcE1H8B8AMxIkoACxstmcTsbnu86ZXxhcm6BGR5dEljiAKB4/vCx9cZUGMI+K8R09z
 PFqoM/ktpyZNtjN5fTqGYPsp7ZJvFPX1tAY0Hw8MXQqszYzqIHABBhexYQMpy7W3mFWg
 XIIogRphP0kmpYn+scwTwquMkagFflW98E6uKSWv/b7ZJNllwoCbs0vvostNEkqyo3aj
 OTvXIanIE+QtyC2pAAblf2V7AVfigFTmKs7SzYVxerBcGw7sBxgkX74XnArZKK6vboo7 Rg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h2ct2ckm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jul 2022 03:20:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2653Asn8016594
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jul 2022 03:20:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h32mhw3jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jul 2022 03:20:22 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2653KMDa038855
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jul 2022 03:20:22 GMT
Received: from srikcs-7420.in.oracle.com (dhcp-10-191-253-19.vpn.oracle.com [10.191.253.19])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h32mhw3h1-1;
        Tue, 05 Jul 2022 03:20:21 +0000
From:   Srikanth C S <srikanth.c.s@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: [PATCH] mkfs: custom agcount that renders AG size < XFS_AG_MIN_BYTES gives "Assertion failed. Aborted"
Date:   Tue,  5 Jul 2022 08:49:58 +0530
Message-Id: <20220705031958.407-1-srikanth.c.s@oracle.com>
X-Mailer: git-send-email 2.34.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: MfJuxlJFJFWnp4q5H-6d0pWwdICG4LlN
X-Proofpoint-ORIG-GUID: MfJuxlJFJFWnp4q5H-6d0pWwdICG4LlN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For a 2GB FS we have
$ mkfs.xfs -f -d agcount=129 test.img
mkfs.xfs: xfs_mkfs.c:3021: align_ag_geometry: Assertion `!cli_opt_set(&dopts, D_AGCOUNT)' failed.
Aborted

With this change we have
$ mkfs.xfs -f -d agcount=129 test.img
Invalid value 129 for -d agcount option. Value is too large.

Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
---
 mkfs/xfs_mkfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 057b3b09..32dcbfff 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2897,6 +2897,13 @@ _("agsize (%s) not a multiple of fs blk size (%d)\n"),
 		cfg->agcount = cli->agcount;
 		cfg->agsize = cfg->dblocks / cfg->agcount +
 				(cfg->dblocks % cfg->agcount != 0);
+		if (cfg->agsize < XFS_AG_MIN_BYTES >> cfg->blocklog)
+		{
+			fprintf(stderr,
+_("Invalid value %lld for -d agcount option. Value is too large.\n"),
+				(long long)cli->agcount);
+			usage();	
+		}
 	} else {
 		calc_default_ag_geometry(cfg->blocklog, cfg->dblocks,
 					 cfg->dsunit, &cfg->agsize,
-- 
2.25.1
