Return-Path: <SRS0=zhh1=BQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_FUZZY_SECTOR,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0EAC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 13:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2FB22311A
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 13:27:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kt9RcbYB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgHFNYZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Aug 2020 09:24:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38827 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728190AbgHFNIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Aug 2020 09:08:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596719027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Go68WusXGQ6nfgm0rdlych/R0ayEr9obBFWuYKD/VME=;
        b=Kt9RcbYBGMI4abWk4tm4Omc5tUPIeEuSBLuhPulSxTOkhknGtfW3na0n1ZYT2xRHUZrDE1
        4KIzsbOKTUDJinOEWi7M7Yrp6liHLASQFH9yhg276ke2uinbY5lLoS9OYOGTBcpq/j+yMn
        ManI1x/iD3uuc48ZUhGd1L/Gpn2+efg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-HzHuf7lZPhikIpa2cl6ByQ-1; Thu, 06 Aug 2020 09:03:46 -0400
X-MC-Unique: HzHuf7lZPhikIpa2cl6ByQ-1
Received: by mail-pf1-f200.google.com with SMTP id k12so13968970pfu.19
        for <linux-xfs@vger.kernel.org>; Thu, 06 Aug 2020 06:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Go68WusXGQ6nfgm0rdlych/R0ayEr9obBFWuYKD/VME=;
        b=a75CWTQx7BFEUlKCEv1BuXpulGwc9P0NhKbNk3f+ou5KXgp+XfYABfyAhZq7srI7sE
         tHvU8ndUTOAJ7b4rsFz2nYpe5M0ab77tjyIZBjD0Fdp9UhLmBTUQdF0upyU1kkUhvV7d
         h2v/126nS993JYqjEhShwA9WEpSXNSrRQy6gZ2hV0ExRSkR5mlm6+2X2jTEBpXNb136Y
         nnC/SxRpOe83Qa4DbkzlZic9Ncgh+GkBQ7qvJfzABMqRMQJ35dBva3WHXfPuhfDZZ+Ul
         ZzVwr0XJK8G7tCbXOl7B6P1CYwlIZG1xHiUtkhJM0X10KA7eV0waoVH1uBKFNfsWK7D2
         d9zQ==
X-Gm-Message-State: AOAM532+nlmDRhH+WM0tiZdd2kajoTza9ay+HADbABBblOu+KpHwmyUa
        Sz+vUspGXBGCPUikMO5bcoKGzK2TAQks0bx/aPeLPOmeWISEMA8vHLeRM9+LNoxOrFgM+8DHyxZ
        VKUpRH8CJuQqjmN0h0OpY
X-Received: by 2002:a17:902:aa93:: with SMTP id d19mr7429231plr.272.1596719024793;
        Thu, 06 Aug 2020 06:03:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyotFNOB7umfdrgsDFOiGR2PsWDEtF9tMuM8H0wOqR6zUHimF6ruYx65aWFBkNmnpinTZIT6g==
X-Received: by 2002:a17:902:aa93:: with SMTP id d19mr7429200plr.272.1596719024435;
        Thu, 06 Aug 2020 06:03:44 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g7sm7316972pjj.2.2020.08.06.06.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 06:03:43 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3] mkfs.xfs: introduce sunit/swidth validation helper
Date:   Thu,  6 Aug 2020 21:03:01 +0800
Message-Id: <20200806130301.27937-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200804160015.17330-1-hsiangkao@redhat.com>
References: <20200804160015.17330-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently stripe unit/swidth checking logic is all over xfsprogs.
So, refactor the same code snippet into a single validation helper
xfs_validate_stripe_factors(), including:
 - integer overflows of either value
 - sunit and swidth alignment wrt sector size
 - if either sunit or swidth are zero, both should be zero
 - swidth must be a multiple of sunit

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---

changes since v2:
 - try to cover xfs_validate_sb_common() case as well suggested by Eric,
   so move to libxfs as an attempt for review;

 - use an static inline helper in xfs_sb.h so compilers can do their
   best to eliminate unneeded branches / rearrange code according to
   each individual caller;

 - get back to use "int error" expression since it's compatible with
   "enum xfs_stripeval" and it can be laterly reused for future uses
   in these callers instead of introducing another error code variables;

just for review/comments for now, if it looks almost fine, I'd like to
go further to stage up related functions to kernel.

 libfrog/topology.c | 15 +++++++++++
 libxfs/xfs_sb.c    | 32 ++++++++++++++++--------
 libxfs/xfs_sb.h    | 54 ++++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c    | 62 ++++++++++++++++++++++++----------------------
 po/pl.po           |  4 +--
 5 files changed, 124 insertions(+), 43 deletions(-)

diff --git a/libfrog/topology.c b/libfrog/topology.c
index b1b470c9..554afbfc 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -187,6 +187,7 @@ static void blkid_get_topology(
 	blkid_probe pr;
 	unsigned long val;
 	struct stat statbuf;
+	int error;
 
 	/* can't get topology info from a file */
 	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
@@ -230,6 +231,20 @@ static void blkid_get_topology(
 	*sunit = *sunit >> 9;
 	*swidth = *swidth >> 9;
 
+	error = xfs_validate_stripe_factors(0, sunit, swidth);
+	if (error) {
+		fprintf(stderr,
+_("%s: Volume reports invalid sunit (%d bytes) and swidth (%d bytes) %s, ignoring.\n"),
+			progname, BBTOB(*sunit), BBTOB(*swidth),
+			xfs_stripeval_str[error]);
+		/*
+		 * if firmware is broken, just give up and set both to zero,
+		 * we can't trust information from this device.
+		 */
+		*sunit = 0;
+		*swidth = 0;
+	}
+
 	if (blkid_topology_get_alignment_offset(tp) != 0) {
 		fprintf(stderr,
 			_("warning: device is not properly aligned %s\n"),
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index d37d60b3..0c0f5f90 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -210,6 +210,15 @@ xfs_validate_sb_write(
 	return 0;
 }
 
+const char *xfs_stripeval_str[] = {
+	"OK",
+	"SUNIT_MISALIGN",
+	"SWIDTH_OVERFLOW",
+	"PARTIAL_VALID",
+	"SUNIT_TOO_LARGE",
+	"SWIDTH_MISALIGN",
+};
+
 /* Check the validity of the SB. */
 STATIC int
 xfs_validate_sb_common(
@@ -220,6 +229,8 @@ xfs_validate_sb_common(
 	struct xfs_dsb		*dsb = bp->b_addr;
 	uint32_t		agcount = 0;
 	uint32_t		rem;
+	int			sunit, swidth;
+	int			error;
 
 	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
 		xfs_warn(mp, "bad magic number");
@@ -357,21 +368,20 @@ xfs_validate_sb_common(
 		}
 	}
 
-	if (sbp->sb_unit) {
-		if (!xfs_sb_version_hasdalign(sbp) ||
-		    sbp->sb_unit > sbp->sb_width ||
-		    (sbp->sb_width % sbp->sb_unit) != 0) {
-			xfs_notice(mp, "SB stripe unit sanity check failed");
-			return -EFSCORRUPTED;
-		}
-	} else if (xfs_sb_version_hasdalign(sbp)) {
+	sunit = sbp->sb_unit;
+	swidth = sbp->sb_width;
+
+	if (!sunit ^ !xfs_sb_version_hasdalign(sbp)) {
 		xfs_notice(mp, "SB stripe alignment sanity check failed");
 		return -EFSCORRUPTED;
-	} else if (sbp->sb_width) {
-		xfs_notice(mp, "SB stripe width sanity check failed");
-		return -EFSCORRUPTED;
 	}
 
+	error = xfs_validate_stripe_factors(0, &sunit, &swidth);
+	if (error) {
+		xfs_notice(mp, "SB stripe sanity check failed %s",
+				xfs_stripeval_str[error]);
+		return -EFSCORRUPTED;
+	}
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 92465a9a..c4524bbc 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -41,5 +41,59 @@ extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
 extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
+enum xfs_stripeval {
+	XFS_STRIPEVAL_OK = 0,
+	XFS_STRIPEVAL_SUNIT_MISALIGN,
+	XFS_STRIPEVAL_SWIDTH_OVERFLOW,
+	XFS_STRIPEVAL_PARTIAL_VALID,
+	XFS_STRIPEVAL_SUNIT_TOO_LARGE,
+	XFS_STRIPEVAL_SWIDTH_MISALIGN,
+};
+
+extern const char *xfs_stripeval_str[];
+
+/*
+ * This accepts either
+ *  - (sectersize != 0) dsu (in bytes) / dsw (which is multiplier of dsu)
+ * or
+ *  - (sectersize == 0) sunit / swidth (in 512B sectors)
+ * and return sunit/swidth in sectors.
+ */
+static inline enum xfs_stripeval
+xfs_validate_stripe_factors(
+	int	sectorsize,
+	int	*sunitp,
+	int	*swidthp)
+{
+	int	sunit = *sunitp;
+	int	swidth = *swidthp;
+
+	if (sectorsize) {
+		long long	big_swidth;
+
+		if (sunit % sectorsize)
+			return XFS_STRIPEVAL_SUNIT_MISALIGN;
+
+		sunit = (int)BTOBBT(sunit);
+		big_swidth = (long long)sunit * swidth;
+
+		if (big_swidth > INT_MAX)
+			return XFS_STRIPEVAL_SWIDTH_OVERFLOW;
+		swidth = big_swidth;
+	}
+
+	if ((sunit && !swidth) || (!sunit && swidth))
+		return XFS_STRIPEVAL_PARTIAL_VALID;
+
+	if (sunit > swidth)
+		return XFS_STRIPEVAL_SUNIT_TOO_LARGE;
+
+	if (sunit && (swidth % sunit))
+		return XFS_STRIPEVAL_SWIDTH_MISALIGN;
+
+	*sunitp = sunit;
+	*swidthp = swidth;
+	return XFS_STRIPEVAL_OK;
+}
 
 #endif	/* __XFS_SB_H__ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e6cd280..8fdf17d7 100644
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
@@ -2289,29 +2289,40 @@ _("both data su and data sw options must be specified\n"));
 			usage();
 		}
 
-		if (dsu % cfg->sectorsize) {
-			fprintf(stderr,
-_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
-			usage();
-		}
-
-		dsunit  = (int)BTOBBT(dsu);
-		big_dswidth = (long long int)dsunit * dsw;
-		if (big_dswidth > INT_MAX) {
-			fprintf(stderr,
-_("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
-				big_dswidth, dsunit);
-			usage();
-		}
-		dswidth = big_dswidth;
+		dsunit = dsu;
+		dswidth = dsw;
+		error = xfs_validate_stripe_factors(cfg->sectorsize,
+				&dsunit, &dswidth);
+	} else {
+		error = xfs_validate_stripe_factors(0, &dsunit, &dswidth);
 	}
 
-	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
-	    (dsunit && (dswidth % dsunit != 0))) {
+	switch (error) {
+	case XFS_STRIPEVAL_OK:
+		break;
+	case XFS_STRIPEVAL_SUNIT_MISALIGN:
+		fprintf(stderr,
+_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
+		usage();
+		break;
+	case XFS_STRIPEVAL_SWIDTH_OVERFLOW:
+		fprintf(stderr,
+_("data stripe width (%d) is too large of a multiple of the data stripe unit (%d)\n"),
+			dsw, dsunit);
+		usage();
+		break;
+	case XFS_STRIPEVAL_PARTIAL_VALID:
+	case XFS_STRIPEVAL_SWIDTH_MISALIGN:
 		fprintf(stderr,
 _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
 			dswidth, dsunit);
 		usage();
+		break;
+	default:
+		fprintf(stderr,
+_("invalid data stripe unit (%d), width (%d) %s\n"),
+			dsunit, dswidth, xfs_stripeval_str[error]);
+		usage();
 	}
 
 	/* If sunit & swidth were manually specified as 0, same as noalign */
@@ -2328,18 +2339,9 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
 
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
diff --git a/po/pl.po b/po/pl.po
index 87109f6b..02d2258f 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -9085,10 +9085,10 @@ msgstr "su danych musi być wielokrotnością rozmiaru sektora (%d)\n"
 #: .././mkfs/xfs_mkfs.c:2267
 #, c-format
 msgid ""
-"data stripe width (%lld) is too large of a multiple of the data stripe unit "
+"data stripe width (%d) is too large of a multiple of the data stripe unit "
 "(%d)\n"
 msgstr ""
-"szerokość pasa danych (%lld) jest zbyt dużą wielokrotnością jednostki pasa "
+"szerokość pasa danych (%d) jest zbyt dużą wielokrotnością jednostki pasa "
 "danych (%d)\n"
 
 #: .././mkfs/xfs_mkfs.c:2276
-- 
2.18.1

