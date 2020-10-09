Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A68C433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 05:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF39D21D46
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 05:25:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P4DwrEON"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731213AbgJIFZX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 01:25:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731210AbgJIFZX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 01:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602221121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Ax4NP2o3MiPQJzqLzjtAo8mf5CCCLgdZdynuD9wNouQ=;
        b=P4DwrEONIoFBqV3ALbkFhcmM+cMfNhSBbbSWbXIexEiSzSh8SSI899epPupzxkJP6P8g/X
        lyrbIRBJUMjIWVhMsPFTefQmf5EbdqkEBdPkL3mjNYGPW2jc2u3aMTMdAT2r6ui9wSerht
        Q1dYjeXPR6eNyLT7t6Li4DcKa3HCs1c=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-3ygZGsKcMiCd3Zc5qrR3Cg-1; Fri, 09 Oct 2020 01:25:18 -0400
X-MC-Unique: 3ygZGsKcMiCd3Zc5qrR3Cg-1
Received: by mail-pg1-f197.google.com with SMTP id e28so5725285pgm.15
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 22:25:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ax4NP2o3MiPQJzqLzjtAo8mf5CCCLgdZdynuD9wNouQ=;
        b=EE4/c0yppz+O+nwJ1yepzGLxhmInFSKfs0PiWZWi+QCd1YltvdLaV2A+zWztO3WNvG
         Nb4D1KXyeSMWh6YoAc+zgjTcpG7LnxytZfNsOcSTfS8Hpa0G6TTPQmFJdMWDJkSJVFCc
         ue6r607L1DXOvr7+u7JtEOZvtE2Br+9/L2lZzxI3uoLGx2CgShDKcogmw4I4SO7iT9WK
         mjuPmUUjTEyJssCs13gEPkKYyrGKWV8M30lAzQ8uqVRFKYo+JgUnatYhbbUfUa3Ww4iR
         XHVXzmyaWibG3xAlaO7vyUIEu/9OyblqnqIqOenYamHVnxm1ZG9wW4J61x1kzg/1JE1S
         3K9g==
X-Gm-Message-State: AOAM531YQdGf3eaAYW575GyTJ8p57NLSY28bxQJCYWR3BmUP1Nxc42EP
        OGF78KTF/wmJAt9dA/koz1/MrMw48zoUNyK0ctl1DNlS1w8scxGdw5Bbx28+vwOC0pLR61bnW0r
        ntBY+NRolJoUvFR/RVJGY
X-Received: by 2002:a17:902:8c8b:b029:d2:6356:8b43 with SMTP id t11-20020a1709028c8bb02900d263568b43mr10819424plo.34.1602221117527;
        Thu, 08 Oct 2020 22:25:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8T0pm2ez2SHuMzuV0SB/rkJCzPK59voufeeSIQs/LkqkjsgBB5ZQaDdAa5dD+iYFuPtInwg==
X-Received: by 2002:a17:902:8c8b:b029:d2:6356:8b43 with SMTP id t11-20020a1709028c8bb02900d263568b43mr10819405plo.34.1602221117305;
        Thu, 08 Oct 2020 22:25:17 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p12sm9254042pgm.29.2020.10.08.22.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 22:25:17 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 3/3] mkfs: make use of xfs_validate_stripe_factors()
Date:   Fri,  9 Oct 2020 13:24:21 +0800
Message-Id: <20201009052421.3328-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201009052421.3328-1-hsiangkao@redhat.com>
References: <20201009052421.3328-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Check stripe numbers in calc_stripe_factors() by using
xfs_validate_stripe_factors().

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 libxfs/libxfs_api_defs.h |  1 +
 mkfs/xfs_mkfs.c          | 23 +++++++----------------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e7e42e93..c1b009c1 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -188,6 +188,7 @@
 #define xfs_trans_roll_inode		libxfs_trans_roll_inode
 #define xfs_trans_roll			libxfs_trans_roll
 
+#define xfs_validate_stripe_factors	libxfs_validate_stripe_factors
 #define xfs_verify_agbno		libxfs_verify_agbno
 #define xfs_verify_agino		libxfs_verify_agino
 #define xfs_verify_cksum		libxfs_verify_cksum
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8fe149d7..5ce063ae 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2305,12 +2305,6 @@ _("both data su and data sw options must be specified\n"));
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
@@ -2322,13 +2316,9 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
 		dswidth = big_dswidth;
 	}
 
-	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
-	    (dsunit && (dswidth % dsunit != 0))) {
-		fprintf(stderr,
-_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
-			dswidth, dsunit);
+	if (!libxfs_validate_stripe_factors(NULL, BBTOB(dsunit), BBTOB(dswidth),
+					    cfg->sectorsize))
 		usage();
-	}
 
 	/* If sunit & swidth were manually specified as 0, same as noalign */
 	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
@@ -2344,11 +2334,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
 
 	/* if no stripe config set, use the device default */
 	if (!dsunit) {
-		/* Ignore nonsense from device.  XXX add more validation */
-		if (ft->dsunit && ft->dswidth == 0) {
+		/* Ignore nonsense from device report. */
+		if (!libxfs_validate_stripe_factors(NULL, BBTOB(ft->dsunit),
+						    BBTOB(ft->dswidth), 0)) {
 			fprintf(stderr,
-_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
-				progname, BBTOB(ft->dsunit));
+_("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
+				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
 			ft->dsunit = 0;
 			ft->dswidth = 0;
 		} else {
-- 
2.18.1

