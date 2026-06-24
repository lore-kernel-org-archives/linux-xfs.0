Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7EA23BD06
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324981; cv=none; b=LSWuoZ82WpVjOuJPlO7WrL8f2ohkOz/t2a+d/kvHWgA1xBxVzWzX5n9gAYJsJF6LzpI/C5Hfq11HxpsthZ/wNEDv/0uNHx08ZeHGeudWqCXOhjUMR6B58JchWuawye991M0P9fNW3B3a80MttNWmxjY0OTBEF5thLIIjmMie5BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324981; c=relaxed/simple;
	bh=ZCv/sPkRGDHj5A+FPw/efqyYjkw999cB0KKMFdQO60E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GAVvG3AzN1fPlpWNCNVExeOXZ728XMmYlqdNYxbCqf1XefudZyhe+jDu99kEoqk/9d0BSutfwNEUhycw66b+4hT07bUsJQAamr4rE4t9a4DPVGziET78wZEPMWP7Wa9iqwXIsa+8ibIjdJ/E6lfYKIVf/1otHdmryemtvPZzSns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R52dJrZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R52dJrZu"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 451611F000E9;
	Wed, 24 Jun 2026 18:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324980;
	bh=fLSqRG7AJ+MtXIfyvsSsOYFRhN3+vtfP97nwJf6QDAs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=R52dJrZu6Svif9wxuPNAUTwa+hOzDuN9uu2p5p+xVrEGTkyGuY7EdKdvpzpuqSTZx
	 P1+ZLfeOaSRzWZNjG6ej96yvmuu4xIHU5ZEka0Ix3bWcpTpSfDzes2t1hWoY2W71js
	 9icyjR0NzEkcsuPjYR7YtEppctXY3F5jnAlFA7aM//wkqrayvpk9257yyFMQ6cZNDm
	 EuqpcPhFPlEagOjUldF3mhbV+TKvVX8/0Z7xdmgNAZUsY9Vl1CmSojto2LneR3QFrZ
	 EbYK479S0EUxAHgJ7OZaYFgCLlUsRXX4B5OBexPjK7wiu13w/qvD+DltC+rzw030Om
	 85T+x4/rp9A3A==
Date: Wed, 24 Jun 2026 11:16:19 -0700
Subject: [PATCH 07/11] xfs_scrub: report external log space usage in phase 7
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484568.915780.126389403172696544.stgit@frogsfrogsfrogs>
In-Reply-To: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Let's report the external log space attached to a mounted filesystem so
that the user knows we found it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase7.c |   73 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 25 deletions(-)


diff --git a/scrub/phase7.c b/scrub/phase7.c
index e16ca28aa28371..3b765931a304a9 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -26,6 +26,7 @@
 struct summary_counts {
 	unsigned long long	dbytes;		/* data dev bytes */
 	unsigned long long	rbytes;		/* rt dev bytes */
+	unsigned long long	lbytes;		/* log dev bytes */
 	unsigned long long	next_phys;	/* next phys bytes we see? */
 	unsigned long long	agbytes;	/* freespace bytes */
 
@@ -68,21 +69,18 @@ count_block_summary(
 	void			*arg)
 {
 	struct summary_counts	*counts;
-	bool			is_rt = false;
+	enum xfs_device		dev;
 	unsigned long long	len;
 	int			ret;
 
-	if (ctx->mnt.fsgeom.rtstart) {
-		if (fsmap->fmr_device == XFS_DEV_LOG)
-			return 0;
-		if (fsmap->fmr_device == XFS_DEV_RT)
-			is_rt = true;
-	} else {
-		if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
-			return 0;
-		if (fsmap->fmr_device == ctx->fsinfo.fs_rtdev)
-			is_rt = true;
-	}
+	if (ctx->mnt.fsgeom.rtstart)
+		dev = fsmap->fmr_device;
+	else if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
+		dev = XFS_DEV_LOG;
+	else if (fsmap->fmr_device == ctx->fsinfo.fs_rtdev)
+		dev = XFS_DEV_RT;
+	else
+		dev = XFS_DEV_DATA;
 
 	counts = ptvar_get((struct ptvar *)arg, &ret);
 	if (ret) {
@@ -95,10 +93,16 @@ count_block_summary(
 		uint64_t	blocks;
 
 		blocks = cvt_b_to_off_fsbt(&ctx->mnt, fsmap->fmr_length);
-		if (is_rt)
+		switch (dev) {
+		case XFS_DEV_RT:
 			hist_add(&counts->rtdev_hist, blocks);
-		else
+			break;
+		case XFS_DEV_DATA:
 			hist_add(&counts->datadev_hist, blocks);
+			break;
+		case XFS_DEV_LOG:
+			break;
+		}
 		return 0;
 	}
 
@@ -109,10 +113,16 @@ count_block_summary(
 	    fsmap->fmr_owner == XFS_FMR_OWN_AG)
 		counts->agbytes += fsmap->fmr_length;
 
-	if (is_rt) {
+	switch (dev) {
+	case XFS_DEV_LOG:
+		/* Count external log */
+		counts->lbytes += len;
+		break;
+	case XFS_DEV_RT:
 		/* Count realtime extents. */
 		counts->rbytes += len;
-	} else {
+		break;
+	case XFS_DEV_DATA:
 		/* Count datadev extents. */
 		if (counts->next_phys >= fsmap->fmr_physical + len)
 			return 0;
@@ -120,6 +130,7 @@ count_block_summary(
 			len = counts->next_phys - fsmap->fmr_physical;
 		counts->dbytes += len;
 		counts->next_phys = fsmap->fmr_physical + fsmap->fmr_length;
+		break;
 	}
 
 	return 0;
@@ -137,6 +148,7 @@ add_summaries(
 
 	total->dbytes += item->dbytes;
 	total->rbytes += item->rbytes;
+	total->lbytes += item->lbytes;
 	total->agbytes += item->agbytes;
 
 	hist_import(&total->datadev_hist, &item->datadev_hist);
@@ -162,8 +174,10 @@ phase7_func(
 	unsigned long long	used_data;
 	unsigned long long	used_rt;
 	unsigned long long	used_files;
+	unsigned long long	used_log;
 	unsigned long long	stat_data;
 	unsigned long long	stat_rt;
+	unsigned long long	stat_log;
 	uint64_t		counted_inodes = 0;
 	unsigned long long	absdiff;
 	unsigned long long	d_blocks;
@@ -241,8 +255,13 @@ phase7_func(
 	/* Report on what we found. */
 	used_data = cvt_off_fsb_to_b(&ctx->mnt, d_blocks - d_bfree);
 	used_rt = cvt_off_fsb_to_b(&ctx->mnt, r_blocks - r_bfree);
+	if (ctx->mnt.fsgeom.logstart == 0)
+		used_log = cvt_off_fsb_to_b(&ctx->mnt, l_blocks);
+	else
+		used_log = 0;
 	stat_data = totalcount.dbytes;
 	stat_rt = totalcount.rbytes;
+	stat_log = totalcount.lbytes;
 
 	/*
 	 * Complain if the counts are off by more than 10% unless
@@ -252,28 +271,32 @@ phase7_func(
 	complain = verbose;
 	complain |= !within_range(ctx, stat_data, used_data, absdiff, 1, 10,
 			_("data blocks"));
+	complain |= !within_range(ctx, stat_log, used_log, absdiff, 1, 10,
+			_("external log blocks"));
 	complain |= !within_range(ctx, stat_rt, used_rt, absdiff, 1, 10,
 			_("realtime blocks"));
 	complain |= !within_range(ctx, counted_inodes, used_files, 100, 1, 10,
 			_("inodes"));
 
 	if (complain) {
-		double		d, r, i;
-		char		*du, *ru, *iu;
+		double		d, r, i, l;
+		char		*du, *ru, *iu, *lu;
 
-		if (used_rt || stat_rt) {
+		if (used_rt || stat_rt || used_log) {
 			d = auto_space_units(used_data, &du);
 			r = auto_space_units(used_rt, &ru);
+			l = auto_space_units(used_log, &lu);
 			i = auto_units(used_files, &iu, &ip);
 			fprintf(stdout,
-_("%.1f%s data used;  %.1f%s realtime data used;  %.*f%s inodes used.\n"),
-					d, du, r, ru, ip, i, iu);
+_("%.1f%s data used;  %.1f%s realtime data used;  %.1f%s external log used;  %.*f%s inodes used.\n"),
+					d, du, r, ru, l, lu, ip, i, iu);
 			d = auto_space_units(stat_data, &du);
 			r = auto_space_units(stat_rt, &ru);
+			l = auto_space_units(stat_log, &lu);
 			i = auto_units(counted_inodes, &iu, &ip);
 			fprintf(stdout,
-_("%.1f%s data found; %.1f%s realtime data found; %.*f%s inodes found.\n"),
-					d, du, r, ru, ip, i, iu);
+_("%.1f%s data found; %.1f%s realtime data found; %.1f%s external log found; %.*f%s inodes found.\n"),
+					d, du, r, ru, l, lu, ip, i, iu);
 		} else {
 			d = auto_space_units(used_data, &du);
 			i = auto_units(used_files, &iu, &ip);
@@ -314,13 +337,13 @@ _("%.*f%s inodes counted; %.*f%s inodes checked.\n"),
 	 */
 	if (ctx->bytes_checked &&
 	    (verbose ||
-	     !within_range(ctx, used_data + used_rt,
+	     !within_range(ctx, used_data + used_rt + used_log,
 			ctx->bytes_checked, absdiff, 1, 10,
 			_("verified blocks")))) {
 		double		b1, b2;
 		char		*b1u, *b2u;
 
-		b1 = auto_space_units(used_data + used_rt, &b1u);
+		b1 = auto_space_units(used_data + used_rt + used_log, &b1u);
 		b2 = auto_space_units(ctx->bytes_checked, &b2u);
 		fprintf(stdout,
 _("%.1f%s data counted; %.1f%s data verified.\n"),

