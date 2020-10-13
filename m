Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EC6C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 04:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AE3420872
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 04:11:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HZcTpjFL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731457AbgJMELP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 00:11:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbgJMELP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 00:11:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602562274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=EaKJWf5pcJX3nN3qaoG7QXi3sKn+f9gmIzO5v2zmmVw=;
        b=HZcTpjFLKdOOQ5As6w75AfoDE8I4I+wtOstjtiOJBs31a4HHgveNomfjJQ19zQhda/C+yx
        uqEBvtHjA3v4n4nxgZQ+SEMjRw34AhyCCDVoT7OrJR2C6IyIrJQ/IKVYRIES0WbtwH+5Y0
        dVYOghGXzYObaGTwXhsS/wgU73bsH1Q=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-Z4OibqeIO_2E2gDLP42cVg-1; Tue, 13 Oct 2020 00:11:11 -0400
X-MC-Unique: Z4OibqeIO_2E2gDLP42cVg-1
Received: by mail-pf1-f199.google.com with SMTP id a19so14173841pff.12
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 21:11:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EaKJWf5pcJX3nN3qaoG7QXi3sKn+f9gmIzO5v2zmmVw=;
        b=W7ZsOJoO972p9zZ/IBwQgj36/EbX9PPl9jRPrMPPGEcuZN0mzKKy9tCb19m3GkTG7t
         eE2TgUYMtFna8/WlSU8cSdP9Zvpof8lpoUicwfKV3L92By1B3A22uOkjeIpDcrZYZpxf
         Rxq7kjRf7PD6XH84AYbuDsDYRmAZuO/J6MquSuJqZ+SAsDA5JegjxrEZvwGVhCKiJSaq
         2oEevEDxM8PQip//C5uMOHcO7nvAz6HUUIoD5OpLz6GeJi6T9CoYpg1z3S0nDkpUSltD
         hbi0xhzcu8G41ajHiEAQUlH9VWmuASq4i0nj+ETtW5eILVebJW7RMceCICQiG4xyVagf
         dlKw==
X-Gm-Message-State: AOAM531BgPZxuCWxptdstZ1ngdLNl2gHvbxhLdPQDCbwv3JiP++m4w8H
        5MkyTA0KFCFmroFzOL+BejKQEhmPQyDWIcnXAMhQIUt+IHtnswwqO4Ie0/U6oZgtuYlE5Pxl+RH
        8eXBvFfVd3BPpaPt16I6r
X-Received: by 2002:a17:90a:d901:: with SMTP id c1mr21591637pjv.81.1602562269876;
        Mon, 12 Oct 2020 21:11:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx32KZxrUyjH4JjqcDhZtNNR/oo0XEWgnVtVOcA7AXGewLzZhhy22X/VGuxvHjO/N69S/lU6A==
X-Received: by 2002:a17:90a:d901:: with SMTP id c1mr21591616pjv.81.1602562269677;
        Mon, 12 Oct 2020 21:11:09 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e21sm20387615pgi.91.2020.10.12.21.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 21:11:09 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 3/3] mkfs: make use of xfs_validate_stripe_geometry()
Date:   Tue, 13 Oct 2020 12:06:27 +0800
Message-Id: <20201013040627.13932-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201013040627.13932-1-hsiangkao@redhat.com>
References: <20201013040627.13932-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Check stripe numbers in calc_stripe_factors() by using
xfs_validate_stripe_geometry().

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 libxfs/libxfs_api_defs.h |  1 +
 mkfs/xfs_mkfs.c          | 23 +++++++----------------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e7e42e93..306d0deb 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -188,6 +188,7 @@
 #define xfs_trans_roll_inode		libxfs_trans_roll_inode
 #define xfs_trans_roll			libxfs_trans_roll
 
+#define xfs_validate_stripe_geometry	libxfs_validate_stripe_geometry
 #define xfs_verify_agbno		libxfs_verify_agbno
 #define xfs_verify_agino		libxfs_verify_agino
 #define xfs_verify_cksum		libxfs_verify_cksum
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8fe149d7..aec40c1f 100644
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
+	if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit), BBTOB(dswidth),
+					     cfg->sectorsize, false))
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
+		if (!libxfs_validate_stripe_geometry(NULL, BBTOB(ft->dsunit),
+				BBTOB(ft->dswidth), 0, true)) {
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

