Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48988 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbeGaEfi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 00:35:38 -0400
Subject: [PATCH 2/1] mkfs: factor stripe geom validator & use for cli + device
References: <6f62dbc6-f516-e8b5-1f08-6be227a61219@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b250d549-68aa-74da-0767-bc5c1d49a9f9@sandeen.net>
Date: Mon, 30 Jul 2018 21:57:36 -0500
MIME-Version: 1.0
In-Reply-To: <6f62dbc6-f516-e8b5-1f08-6be227a61219@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Mahoney <jeffm@suse.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

Factor the dsunit-vs-dwidth-vs-blocksize checks into a helper.

If they fail on user-specified values, exit with usage().

If they fail on values from the device, warn about it and set
them to zero so they'll be ignored.

This also ensures that we won't complain if user-specified values
don't match bogus device-provided geometry.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

NB: this does undo Jeff's "try to make the best of it" approach
which set swidth=sunit, but I feel like we get burned whenever
we try to second-guess broken hardware anyway.  Thoughts?

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8f0bd89..4f05354 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2196,6 +2196,37 @@ validate_rtextsize(
 	ASSERT(cfg->rtextblocks);
 }
 
+static bool
+validate_stripe_factors(
+	int			blocksize,
+	int			dsunit,
+	int			dswidth,
+	bool			devicevals)
+{
+	/* Can't have one without the other, and dswidth must be multiple */
+	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
+	    (dsunit && (dswidth % dsunit != 0))) {
+		if (devicevals)
+			fprintf(stderr, _("Validating device geometry:\n"));
+		fprintf(stderr,
+_("Data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
+			BBTOB(dswidth), BBTOB(dsunit));
+		return false;
+	}
+
+	/* Check that the stripe config is a multiple of block size */
+	if ((BBTOB(dsunit) % blocksize) ||
+	    (BBTOB(dswidth) % blocksize)) {
+		if (devicevals)
+			fprintf(stderr, _("Validating device geometry:\n"));
+		fprintf(stderr,
+_("Stripe unit(%d) or stripe width(%d) is not a multiple of the block size(%d)\n"),
+			BBTOB(dsunit), BBTOB(dswidth), blocksize);
+		return false;
+	}
+	return true;
+}
+
 /*
  * Validate the configured stripe geometry, or is none is specified, pull
  * the configuration from the underlying device.
@@ -2215,7 +2246,6 @@ calc_stripe_factors(
 	int		dsu = 0;
 	int		dsw = 0;
 	int		lsu = 0;
-	bool		use_dev = false;
 
 	if (cli_opt_set(&dopts, D_SUNIT))
 		dsunit = cli->dsunit;
@@ -2259,13 +2289,9 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
 		dswidth = big_dswidth;
 	}
 
-	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
-	    (dsunit && (dswidth % dsunit != 0))) {
-		fprintf(stderr,
-_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
-			dswidth, dsunit);
+	/* Validate the user-supplied stripe geometry */
+	if (!validate_stripe_factors(cfg->blocksize, dsunit, dswidth, false))
 		usage();
-	}
 
 	/* If sunit & swidth were manually specified as 0, same as noalign */
 	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
@@ -2279,22 +2305,16 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
 		goto check_lsunit;
 	}
 
-	/* if no stripe config set, use the device default */
-	if (!dsunit) {
-		/* Watch out for nonsense from device */
-		if (ft->dsunit && ft->dswidth == 0) {
-			fprintf(stderr,
-_("%s: Volume reports stripe unit of %d bytes but stripe width of 0.\n"),
-				progname, ft->dsunit << 9);
-			fprintf(stderr,
-_("Using stripe width of %d bytes, which may not be optimal.\n"),
-				ft->dsunit << 9);
-			ft->dswidth = ft->dsunit;
-		}
-		dsunit = ft->dsunit;
-		dswidth = ft->dswidth;
-		use_dev = true;
-	} else {
+	/* Validate the device-reported stripe geometry */
+	if (!validate_stripe_factors(cfg->blocksize, ft->dsunit, ft->dswidth, true)) {
+		fprintf(stderr,
+_("Device-reported stripe geometry failed checks, ignoring\n"));
+		ft->dsunit = 0;
+		ft->dswidth = 0;
+	}
+
+	/* If user specified geometry, check against device values */
+	if (dsunit) {
 		/* check and warn if user-specified alignment is sub-optimal */
 		if (ft->dsunit && ft->dsunit != dsunit) {
 			fprintf(stderr,
@@ -2306,28 +2326,10 @@ _("%s: Specified data stripe unit %d is not the same as the volume stripe unit %
 _("%s: Specified data stripe width %d is not the same as the volume stripe width %d\n"),
 				progname, dswidth, ft->dswidth);
 		}
-	}
-
-	/*
-	 * now we have our stripe config, check it's a multiple of block
-	 * size.
-	 */
-	if ((BBTOB(dsunit) % cfg->blocksize) ||
-	    (BBTOB(dswidth) % cfg->blocksize)) {
-		/*
-		 * If we are using device defaults, just clear them and we're
-		 * good to go. Otherwise bail out with an error.
-		 */
-		if (!use_dev) {
-			fprintf(stderr,
-_("%s: Stripe unit(%d) or stripe width(%d) is not a multiple of the block size(%d)\n"),
-				progname, BBTOB(dsunit), BBTOB(dswidth),
-				cfg->blocksize);
-			exit(1);
-		}
-		dsunit = 0;
-		dswidth = 0;
-		cfg->sb_feat.nodalign = true;
+	} else {
+		/* Use the device-reported geometry */
+		dsunit = ft->dsunit;
+		dswidth = ft->dswidth;
 	}
 
 	/* convert from 512 byte blocks to fs blocksize */


