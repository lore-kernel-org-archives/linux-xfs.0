Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4761923A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442460; cv=none; b=n1UOFtGlSHQEwxv16ApTHN6y4aj5HFDHFuJy4OKXGun+TlGbYc2KZNHfvKj/KjYGfeQQmSdnsTAxXYlu6gSszX3z3ylcQkLY0fpsFCJILu/QCYz2OqlQNI1hmdpYL6LABkFu1Krk30Vc3u9F1SuHtC503n/Jk+cj7cI4gw6s/L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442460; c=relaxed/simple;
	bh=lICuU5NDkEHveGIHyG7z/74zkVMb9x2oUwOkusF57fI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eb86yJcwLzqVInH5PeGyDlzrIdz+UlbBXsJkYMDKjieftlaKaBPsc0p0E0mU12NOdnbxjEl9YqANGyfo6ERzcmIk+qR6fgiHhbpod72C1Kc2pftD8uwt6xaL2wD7V53YMqVVb9zcV0bt6lRGlb1P7Wo6Lu/WAEYAiP1y8XRlPAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=narjbx1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="narjbx1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C448C2BD10;
	Mon,  3 Jun 2024 19:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442460;
	bh=lICuU5NDkEHveGIHyG7z/74zkVMb9x2oUwOkusF57fI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=narjbx1lmYTHBjtGR3j7GUexKyP7SnkF9JK0HwDNPinneytdK3ND9h7dEXEVCoqi+
	 F0z1w2Ps1DNymdNQKI0Jl5Yntaej+cws61XeKQNMEoHHIpToUTFDcSmS0a00H4bo0g
	 4rVvzkSDO6vKYfJ8a4tkAJDCmendzeppNdtE2OaC/JclbCQyeN78ko5QfW9mhy5ys9
	 QzuaNAcdqwy5m2qx2P4l7Bf68bA4XqFYRijgIWKwspczv50+Eg0pSFLYPhYrD+4tmK
	 /BhVbCaWGreVafTma2pP23c8cm+vr26WE8OdxoyDZfZkzuK9JTaXJsVooyCeS3TgmP
	 jpLZtFm3dFSJQ==
Date: Mon, 03 Jun 2024 12:20:59 -0700
Subject: [PATCH 111/111] xfs: allow sunit mount option to repair bad primary
 sb stripe values
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171744041033.1443973.1363547765024486503.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 15922f5dbf51dad334cde888ce6835d377678dc9

If a filesystem has a busted stripe alignment configuration on disk
(e.g. because broken RAID firmware told mkfs that swidth was smaller
than sunit), then the filesystem will refuse to mount due to the
stripe validation failing. This failure is triggering during distro
upgrades from old kernels lacking this check to newer kernels with
this check, and currently the only way to fix it is with offline
xfs_db surgery.

This runtime validity checking occurs when we read the superblock
for the first time and causes the mount to fail immediately. This
prevents the rewrite of stripe unit/width via
mount options that occurs later in the mount process. Hence there is
no way to recover this situation without resorting to offline xfs_db
rewrite of the values.

However, we parse the mount options long before we read the
superblock, and we know if the mount has been asked to re-write the
stripe alignment configuration when we are reading the superblock
and verifying it for the first time. Hence we can conditionally
ignore stripe verification failures if the mount options specified
will correct the issue.

We validate that the new stripe unit/width are valid before we
overwrite the superblock values, so we can ignore the invalid config
at verification and fail the mount later if the new values are not
valid. This, at least, gives users the chance of correcting the
issue after a kernel upgrade without having to resort to xfs-db
hacks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_sb.c |   40 +++++++++++++++++++++++++++++++---------
 libxfs/xfs_sb.h |    5 +++--
 mkfs/xfs_mkfs.c |    6 +++---
 3 files changed, 37 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 00b0a937d..895d646bb 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -528,7 +528,8 @@ xfs_validate_sb_common(
 	}
 
 	if (!xfs_validate_stripe_geometry(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
-			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
+			XFS_FSB_TO_B(mp, sbp->sb_width), 0,
+			xfs_buf_daddr(bp) == XFS_SB_DADDR, false))
 		return -EFSCORRUPTED;
 
 	/*
@@ -1321,8 +1322,10 @@ xfs_sb_get_secondary(
 }
 
 /*
- * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
- * so users won't be confused by values in error messages.
+ * sunit, swidth, sectorsize(optional with 0) should be all in bytes, so users
+ * won't be confused by values in error messages.  This function returns false
+ * if the stripe geometry is invalid and the caller is unable to repair the
+ * stripe configuration later in the mount process.
  */
 bool
 xfs_validate_stripe_geometry(
@@ -1330,20 +1333,21 @@ xfs_validate_stripe_geometry(
 	__s64			sunit,
 	__s64			swidth,
 	int			sectorsize,
+	bool			may_repair,
 	bool			silent)
 {
 	if (swidth > INT_MAX) {
 		if (!silent)
 			xfs_notice(mp,
 "stripe width (%lld) is too large", swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit > swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sectorsize && (int)sunit % sectorsize) {
@@ -1351,21 +1355,21 @@ xfs_validate_stripe_geometry(
 			xfs_notice(mp,
 "stripe unit (%lld) must be a multiple of the sector size (%d)",
 				   sunit, sectorsize);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit && !swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "invalid stripe unit (%lld) and stripe width of 0", sunit);
-		return false;
+		goto check_override;
 	}
 
 	if (!sunit && swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "invalid stripe width (%lld) and stripe unit of 0", swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit && (int)swidth % (int)sunit) {
@@ -1373,9 +1377,27 @@ xfs_validate_stripe_geometry(
 			xfs_notice(mp,
 "stripe width (%lld) must be a multiple of the stripe unit (%lld)",
 				   swidth, sunit);
-		return false;
+		goto check_override;
 	}
 	return true;
+
+check_override:
+	if (!may_repair)
+		return false;
+	/*
+	 * During mount, mp->m_dalign will not be set unless the sunit mount
+	 * option was set. If it was set, ignore the bad stripe alignment values
+	 * and allow the validation and overwrite later in the mount process to
+	 * attempt to overwrite the bad stripe alignment values with the values
+	 * supplied by mount options.
+	 */
+	if (!mp->m_dalign)
+		return false;
+	if (!silent)
+		xfs_notice(mp,
+"Will try to correct with specified mount options sunit (%d) and swidth (%d)",
+			BBTOB(mp->m_dalign), BBTOB(mp->m_swidth));
+	return true;
 }
 
 /*
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 2e8e8d63d..37b1ed1bc 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -35,8 +35,9 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
 
-extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
-		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
+bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
+		__s64 sunit, __s64 swidth, int sectorsize, bool may_repair,
+		bool silent);
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d6fa48ede..4f2d529aa 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2765,13 +2765,13 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
 		}
 
 		if (!libxfs_validate_stripe_geometry(NULL, dsu, big_dswidth,
-						     cfg->sectorsize, false))
+					cfg->sectorsize, false, false))
 			usage();
 
 		dsunit = BTOBBT(dsu);
 		dswidth = BTOBBT(big_dswidth);
 	} else if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit),
-			BBTOB(dswidth), cfg->sectorsize, false)) {
+			BBTOB(dswidth), cfg->sectorsize, false, false)) {
 		usage();
 	}
 
@@ -2791,7 +2791,7 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
 	if (!dsunit) {
 		/* Ignore nonsense from device report. */
 		if (!libxfs_validate_stripe_geometry(NULL, BBTOB(ft->data.sunit),
-				BBTOB(ft->data.swidth), 0, true)) {
+				BBTOB(ft->data.swidth), 0, false, true)) {
 			fprintf(stderr,
 _("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
 				progname,

