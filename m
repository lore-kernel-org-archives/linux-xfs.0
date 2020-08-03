Return-Path: <SRS0=ns7q=BN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA95C433DF
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 12:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B6482064B
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 12:53:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IIU3x/bi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgHCMvh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Aug 2020 08:51:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40615 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729183AbgHCMv0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Aug 2020 08:51:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596459064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=SqrnrVBugImuhT0yhnlPO6MXgZZ+L8bUW9h5EMB3LAg=;
        b=IIU3x/biQgot2uEokDcucSqnkbXlBLpoClA0CxcY0upQtI3l9QhwcWRvg8nQOn0pJNszcX
        tzeIXYK9JQgnPevOnwN+dHBOli5iivMoOiqcf+pBZOzWaMIiWSQat/yBYrpFrXWajyxPs2
        Y66k8QUrvmKy1YmHgoe0xpssIBT2XeU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-uiyP5OTNNwi6IeYSmKKXLg-1; Mon, 03 Aug 2020 08:51:02 -0400
X-MC-Unique: uiyP5OTNNwi6IeYSmKKXLg-1
Received: by mail-pl1-f198.google.com with SMTP id k21so19730130pls.2
        for <linux-xfs@vger.kernel.org>; Mon, 03 Aug 2020 05:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SqrnrVBugImuhT0yhnlPO6MXgZZ+L8bUW9h5EMB3LAg=;
        b=dxAdobVnziN+fcfiUlh2nbcIO8Pq84UpRuqt5su/kCInMAtUz3Mdm4P56+EGLcUaEK
         s/ZNJs3AmPJiFXZVPhAtsQZi22/OzbeBdyDrndBT/rvd5VUN6BeLn6QsWRPl4YCIMONS
         NtuKq1UwhoOMWsTj57xDDZaMUbWIvXftpEj6GaJsx/vriDHBjRPIuXebzXZncpjYrv5c
         F1ixFsuiDcrCotPJVLrxShnLRv0ZAcVAp6cEuj115dL0iqLVlOCVWarAY345J7TJKiCo
         rX86l+gsq5TkbxdgqkqJFBMgDuUiPxnzwfh9vBq/xv5iSRepFk5DH79RA2zPCDCJvBn4
         Awuw==
X-Gm-Message-State: AOAM532zrpfKpWVDr66/Z/uU4DGm3em9l0zdl8NjIPMz93QehMObu2/L
        +A9PyHhqVK7udX+cYwv/4cAybNZqaGt9Zvaz+cpnL2wKfhb+Nif0ngV3IsQs3cSYaN0MIqdpby/
        876g1iMPHB+MHq407L+Wy
X-Received: by 2002:a63:af0c:: with SMTP id w12mr14136595pge.312.1596459061034;
        Mon, 03 Aug 2020 05:51:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoB8EFdWzitnsSzrJFlsEj2O8cESb/WlOpepYBBWAhGrYUpxdDcQc4Q7idjCAByct/67Sv4A==
X-Received: by 2002:a63:af0c:: with SMTP id w12mr14136578pge.312.1596459060740;
        Mon, 03 Aug 2020 05:51:00 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f2sm19250360pfb.184.2020.08.03.05.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 05:51:00 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH] mkfs.xfs: introduce sunit/swidth validation helper
Date:   Mon,  3 Aug 2020 20:50:18 +0800
Message-Id: <20200803125018.16718-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <a673fbd3-5038-2dc8-8135-a58c24042734@redhat.com>
References: <a673fbd3-5038-2dc8-8135-a58c24042734@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently stripe unit/width checking logic is all over xfsprogs.
So, refactor the same code snippet into a single validation helper
xfs_validate_stripe_factors(), including:
 - integer overflows of either value
 - sunit and swidth alignment wrt sector size
 - if either sunit or swidth are zero, both should be zero
 - swidth must be a multiple of sunit

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---

This patch follows Darrick's original suggestion [1], yet I'm
not sure if I'm doing the right thing or if something is still
missing (e.g the meaning of six(ish) places)... So post it
right now...

TBH, especially all these naming and the helper location (whether
in topology.c)...plus, click a dislike on calc_stripe_factors()
itself...

(Hopefully hear some advice about this... Thanks!)

[1] https://lore.kernel.org/r/20200515204802.GO6714@magnolia

 libfrog/topology.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/topology.h | 15 ++++++++++++++
 mkfs/xfs_mkfs.c    | 48 ++++++++++++++++++++++----------------------
 3 files changed, 89 insertions(+), 24 deletions(-)

diff --git a/libfrog/topology.c b/libfrog/topology.c
index b1b470c9..cf56fb03 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -174,6 +174,41 @@ out:
 	return ret;
 }
 
+enum xfs_stripe_retcode
+xfs_validate_stripe_factors(
+	int	sectorsize,
+	int 	*sup,
+	int	*swp)
+{
+	int sunit = *sup, swidth = *swp;
+
+	if (sectorsize) {
+		long long	big_swidth;
+
+		if (sunit % sectorsize)
+			return XFS_STRIPE_RET_SUNIT_MISALIGN;
+
+		sunit = (int)BTOBBT(sunit);
+		big_swidth = (long long)sunit * swidth;
+
+		if (big_swidth > INT_MAX)
+			return XFS_STRIPE_RET_SWIDTH_OVERFLOW;
+		swidth = big_swidth;
+	}
+	if ((sunit && !swidth) || (!sunit && swidth))
+		return XFS_STRIPE_RET_PARTIAL_VALID;
+
+	if (sunit > swidth)
+		return XFS_STRIPE_RET_SUNIT_TOO_LARGE;
+
+	if (sunit && (swidth % sunit))
+		return XFS_STRIPE_RET_SWIDTH_MISALIGN;
+
+	*sup = sunit;
+	*swp = swidth;
+	return XFS_STRIPE_RET_OK;
+}
+
 static void blkid_get_topology(
 	const char	*device,
 	int		*sunit,
@@ -229,6 +264,21 @@ static void blkid_get_topology(
 	 */
 	*sunit = *sunit >> 9;
 	*swidth = *swidth >> 9;
+	switch (xfs_validate_stripe_factors(0, sunit, swidth)) {
+	case XFS_STRIPE_RET_OK:
+		break;
+	case XFS_STRIPE_RET_PARTIAL_VALID:
+		fprintf(stderr,
+_("%s: Volume reports stripe unit of %d bytes and stripe width of %d bytes, ignoring.\n"),
+				progname, BBTOB(*sunit), BBTOB(*swidth));
+	default:
+		/*
+		 * if firmware is broken, just give up and set both to zero,
+		 * we can't trust information from this device.
+		 */
+		*sunit = 0;
+		*swidth = 0;
+	}
 
 	if (blkid_topology_get_alignment_offset(tp) != 0) {
 		fprintf(stderr,
diff --git a/libfrog/topology.h b/libfrog/topology.h
index 6fde868a..e8be26b2 100644
--- a/libfrog/topology.h
+++ b/libfrog/topology.h
@@ -36,4 +36,19 @@ extern int
 check_overwrite(
 	const char	*device);
 
+enum xfs_stripe_retcode {
+	XFS_STRIPE_RET_OK = 0,
+	XFS_STRIPE_RET_SUNIT_MISALIGN,
+	XFS_STRIPE_RET_SWIDTH_OVERFLOW,
+	XFS_STRIPE_RET_PARTIAL_VALID,
+	XFS_STRIPE_RET_SUNIT_TOO_LARGE,
+	XFS_STRIPE_RET_SWIDTH_MISALIGN,
+};
+
+enum xfs_stripe_retcode
+xfs_validate_stripe_factors(
+	int	sectorsize,
+	int 	*sup,
+	int	*swp);
+
 #endif	/* __LIBFROG_TOPOLOGY_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e6cd280..a3d6032c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2255,7 +2255,6 @@ calc_stripe_factors(
 	struct cli_params	*cli,
 	struct fs_topology	*ft)
 {
-	long long int	big_dswidth;
 	int		dsunit = 0;
 	int		dswidth = 0;
 	int		lsunit = 0;
@@ -2263,6 +2262,7 @@ calc_stripe_factors(
 	int		dsw = 0;
 	int		lsu = 0;
 	bool		use_dev = false;
+	int		error;
 
 	if (cli_opt_set(&dopts, D_SUNIT))
 		dsunit = cli->dsunit;
@@ -2289,31 +2289,40 @@ _("both data su and data sw options must be specified\n"));
 			usage();
 		}
 
-		if (dsu % cfg->sectorsize) {
+		dsunit = dsu;
+		dswidth = dsw;
+		error = xfs_validate_stripe_factors(cfg->sectorsize, &dsunit, &dswidth);
+		switch(error) {
+		case XFS_STRIPE_RET_SUNIT_MISALIGN:
 			fprintf(stderr,
 _("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
 			usage();
-		}
-
-		dsunit  = (int)BTOBBT(dsu);
-		big_dswidth = (long long int)dsunit * dsw;
-		if (big_dswidth > INT_MAX) {
+			break;
+		case XFS_STRIPE_RET_SWIDTH_OVERFLOW:
 			fprintf(stderr,
-_("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
-				big_dswidth, dsunit);
+_("data stripe width (dsw %d) is too large of a multiple of the data stripe unit (%d)\n"),
+				dsw, dsunit);
 			usage();
+			break;
 		}
-		dswidth = big_dswidth;
+	} else {
+		error = xfs_validate_stripe_factors(0, &dsunit, &dswidth);
 	}
 
-	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
-	    (dsunit && (dswidth % dsunit != 0))) {
+	if (error == XFS_STRIPE_RET_PARTIAL_VALID ||
+	    error == XFS_STRIPE_RET_SWIDTH_MISALIGN) {
 		fprintf(stderr,
 _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
 			dswidth, dsunit);
 		usage();
 	}
 
+	if (error) {
+		fprintf(stderr,
+_("invalid data stripe unit (%d), width (%d)\n"), dsunit, dswidth);
+		usage();
+	}
+
 	/* If sunit & swidth were manually specified as 0, same as noalign */
 	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
 	    !dsunit && !dswidth)
@@ -2328,18 +2337,9 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
 
 	/* if no stripe config set, use the device default */
 	if (!dsunit) {
-		/* Ignore nonsense from device.  XXX add more validation */
-		if (ft->dsunit && ft->dswidth == 0) {
-			fprintf(stderr,
-_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
-				progname, BBTOB(ft->dsunit));
-			ft->dsunit = 0;
-			ft->dswidth = 0;
-		} else {
-			dsunit = ft->dsunit;
-			dswidth = ft->dswidth;
-			use_dev = true;
-		}
+		dsunit = ft->dsunit;
+		dswidth = ft->dswidth;
+		use_dev = true;
 	} else {
 		/* check and warn if user-specified alignment is sub-optimal */
 		if (ft->dsunit && ft->dsunit != dsunit) {
-- 
2.18.1

