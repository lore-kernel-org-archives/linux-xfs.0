Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4767C4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ECA020870
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:04:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="B+o5Ouj6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgJGOE4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:04:56 -0400
Received: from sonic305-20.consmr.mail.gq1.yahoo.com ([98.137.64.83]:45683
        "EHLO sonic305-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728469AbgJGOEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 10:04:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1602079495; bh=/bc3QL8qK6G9BCq69i20sSRTNqhb1LMZZCXRzQMgUnU=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=B+o5Ouj6ZgXQgOfDlr5Y66iMnqFZApvTW7kfZgrZcp5f3qZYkQ2OyOllP6RTB8XnvKRA4nAZf9VOuVl3kf2fOKBlG381RfgaWItvYceOVXpu9z+0Tnu758wZ1smBCUw1iIA4zu7no2Gt3nfTizKyv0rNCqswBG44UZkZG15Ezs9dkWDqzj9Wyx5lgNYLYuMaRwgTIsbs/hvko+uh6Hq5rjGesUeGy3/lb6/ShA3FuIMUbHQgusQdMBcFHug8woyZsTuoFhaYLsfGDXFZPgcVsNriMW43XFkqyI6fTErAjygzNmy83akwbAyrrkLk+QJwF535SbUWYuS6pkNbZPXVkw==
X-YMail-OSG: iT8FFrgVM1k_g3pD6BfMQV_chaAbF117qF9TzLeG8Drm844D3kKRToJ9wg2N8dG
 8IdAwBr9Sm3daoMQsOb5ylAeOXmKBTBhhA.5GqnJ.4k2gEF7QB6EFNLr8cMFGT7UQAolByDi1Ha5
 HzLH09hodff3GUYXiILf.HVW_E.xRMQdCBP4XNAELxpxPMATEsncJNXJ_ZqTLKM5qAF4JV3iTIbf
 aisJwiZdbVhm6.gk8vpqe_G1dhlX69WhASwUqOiximU_.S583vGL0U3O22zXYcTClkpWalj2k.qb
 KKjosq0Tk_in8A_fmxL.ak5YbcTWTJ5HdgB.G130xPW0tJ8Nf.FrLYs3dlwOLnQ17r2s.2o5sWt_
 gXsea2f0Q5kf9yDOzzi7eCcC1jJZkl6ylxon.HrCfkNLCMCXcF.fRmE2sKZJ09l9Ub8rFSTxO7io
 c2AoQMdNKM5LRNhNpvT4BrfPIDKMoSsbUDt2hlSlFjkumR4khmq6IYcoZuERaEAVoC69frBEgabn
 F1A1hqHDr1mWp3QZpk_EzSmN89IvcN3An.HyGs7JZDQ2BeiuqLAgIVFPdAXYE6XdIpb8b2_yCjqH
 q3GRe317MpfqTyOc567ypj0o7RqotxSJz5i0hhBccCMspEYiEtEfcsU5LxnuOP7bzGrek2k2dYey
 M8WFa6XoNxObl8ZJNBaDoDtCH56QFHmHvLm.f1fbOhxUvTYLsMXozFTPv_LePUTf08I8xXWMMxR5
 UA5I9Nu1tGzFS_zMbUWgdfR9l8dWkUitkvCFhnXO3kOZZspInWvfDUmR6hAI1o5rD.XSYH6H9p1E
 VBpX4MqE9cqonRwx6JR9MZGpRlMcHoNsW8Wu8qGWkRGyCVB7Sf31rX8TfCq4BGRZRdeMpv8ncBrf
 Pep0hWqfaSi1.Up636tnW3L9nWLksafHjP38vG9D0q.tYeQFwAQZIDV.N1FuCjBY4T.GxKmO2j4P
 j3DK2KPstfgsWDszS5m6BoBr8T1nWZ7SKSYt.aw3Ss2VYFItH0_rjU6thnlpSWaw0.I_anuQMRRM
 1y7FLspZBXHj8nI2LHlXD9toncEcRtTa6A0EVxNGAfw8lIfX26h33kilS2AWS8lTHvp1UqX.imW_
 pgatjGDkm7qSeJm_lmswGtvmaqYo3brKypyWW0ThbDi0Bn_FZTSldBvgkUxOc4xt2cS_ptbyjAfu
 mlsyYkpz.sxvBc7xC1bnrI61fNoo1aIIziCGtHO.rpND7jdPe.puZ3rPOLOOB.a8dVV7lSbIXJcH
 IfgrapTE8VeS3IS9R0Q2e6JXWxTKgrHLDzot17qtXjJkUURVszHjSAEx9M5.nAPZgvbpZqA6Qysu
 iYVzucrP0o0J016n9ifX7_eRSGXd4Wb9luSNIcI7d7ZAWTyeCmhQjMwbGYuO_ESeh64g72_r.DJQ
 wbxsl4R4AnI7XzsEiWWlfZRfTaC_7aQl6rZE08EdB8NI6.yiojIKi2LHYKAnNbmGaps8U6hoE9hA
 QSAA8M9du5VewL6VvvNZMYFKoN8LZNhwW.HtibsRJl7zvK.0-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.gq1.yahoo.com with HTTP; Wed, 7 Oct 2020 14:04:55 +0000
Received: by smtp404.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a1aacd19ca90341b10418ab97793d328;
          Wed, 07 Oct 2020 14:04:53 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 3/3] xfsprogs: make use of xfs_validate_stripe_factors()
Date:   Wed,  7 Oct 2020 22:04:02 +0800
Message-Id: <20201007140402.14295-4-hsiangkao@aol.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20201007140402.14295-1-hsiangkao@aol.com>
References: <20201007140402.14295-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Check stripe numbers in calc_stripe_factors() by
using xfs_validate_stripe_factors().

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 mkfs/xfs_mkfs.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e6cd280e388..b7f8f98147eb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2289,12 +2289,6 @@ _("both data su and data sw options must be specified\n"));
 			usage();
 		}
 
-		if (dsu % cfg->sectorsize) {
-			fprintf(stderr,
-_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
-			usage();
-		}
-
 		dsunit  = (int)BTOBBT(dsu);
 		big_dswidth = (long long int)dsunit * dsw;
 		if (big_dswidth > INT_MAX) {
@@ -2306,13 +2300,9 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
 		dswidth = big_dswidth;
 	}
 
-	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
-	    (dsunit && (dswidth % dsunit != 0))) {
-		fprintf(stderr,
-_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
-			dswidth, dsunit);
+	if (!xfs_validate_stripe_factors(NULL, BBTOB(dsunit), BBTOB(dswidth),
+					 cfg->sectorsize))
 		usage();
-	}
 
 	/* If sunit & swidth were manually specified as 0, same as noalign */
 	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
@@ -2328,11 +2318,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
 
 	/* if no stripe config set, use the device default */
 	if (!dsunit) {
-		/* Ignore nonsense from device.  XXX add more validation */
-		if (ft->dsunit && ft->dswidth == 0) {
+		/* Ignore nonsense from device report. */
+		if (!xfs_validate_stripe_factors(NULL, ft->dsunit,
+						 ft->dswidth, 0)) {
 			fprintf(stderr,
-_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
-				progname, BBTOB(ft->dsunit));
+_("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
+				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
 			ft->dsunit = 0;
 			ft->dswidth = 0;
 		} else {
-- 
2.24.0

