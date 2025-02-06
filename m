Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BC723C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881200; cv=none; b=bfbtJoCMactQC3qoyetLp/GywVbiFEwVRYU3UtajB4d/h2U4kauhz8UoWR0/PTpMMpNYfWkfo2XP2JwIrhkOl9qTBRpLOt9pJZrJ+9bAMEnvFlsZJu5LyswgxutlOhium4VCI2VYLPLvkqc1CY/kWK64OoDrmDiclDhLfyXv4aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881200; c=relaxed/simple;
	bh=81jMm/6LH7cbXeO9MllrHoOYrcWze0fVPNguk2AOp78=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTdvBijg0qAIfKmhocfU8jeDyW4VNwuy+GuvdldACKdR0Bzi5mGUIng5yjgOhOaqguv8AVst6UMSWLF8Q5DfcMopAV/nMBK01kE34ZAXpJf44N0hNQukuj3sAdogDKoJiS+7VTiXPEWuV8vEC4pPSoxlZZrKXYNU3q6sFJaH9v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YYfArVN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYfArVN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDD1C4CEDD;
	Thu,  6 Feb 2025 22:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881197;
	bh=81jMm/6LH7cbXeO9MllrHoOYrcWze0fVPNguk2AOp78=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YYfArVN6cSmDrQnN5LQ1DIsYSXdhjKJ3k98zLRfv+4Pghg36qmkmAOdNmjhcc4Rdx
	 3RqHVDtKut+KOXSdT5vBhWnRC5aKZd8JfoP0boUSXO3tWGDVUrE7I7z1ySWql7OjYp
	 gie7AsJFX4FbgITlThE3o6fRedVsXDDJKDke92uddcwyOTL3Eapnlmeh6J8N6jhAyr
	 lxLIM56NiRlPMDP9jqOe6gZYAP0yO9+hdvwl4e24ZxaQpUmc2xA7suPAHNQJVohJed
	 wkOw0H4PF5Sxn+NmPmoKc3s2LP06S/QXNJMRx/028RTO3f2PZnKogrvKeKkKENcI5W
	 iHjwiLsgohgsQ==
Date: Thu, 06 Feb 2025 14:33:17 -0800
Subject: [PATCH 10/17] xfs_scrub: don't double-scan inodes during phase 3
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086213.2738568.8939791256440476361.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The bulkstat ioctl only allows us to specify the starting inode number
and the length of the bulkstat array.  It is possible that a bulkstat
request for {startino = 30, icount = 10} will return stat data for inode
50.  For most bulkstat users this is ok because they're marching
linearly across all inodes in the filesystem.

Unfortunately for scrub phase 3 this is undesirable because we only want
the inodes that belong to a specific inobt record because we need to
know about inodes that are marked as allocated but are too corrupt to
appear in the bulkstat output.  Another worker will process the inobt
record(s) that corresponds to the extra inodes, which means we can
double-scan some inodes.

Therefore, bulkstat_for_inumbers should trim out inodes that don't
correspond to the inumbers record that it is given.

Cc: <linux-xfs@vger.kernel.org> # v5.3.0
Fixes: e3724c8b82a320 ("xfs_scrub: refactor xfs_iterate_inodes_range_check")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 4d8b137a698004..a7ea24615e9255 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -50,15 +50,17 @@
  */
 static void
 bulkstat_for_inumbers(
-	struct scrub_ctx	*ctx,
-	struct descr		*dsc,
-	const struct xfs_inumbers *inumbers,
-	struct xfs_bulkstat_req	*breq)
+	struct scrub_ctx		*ctx,
+	struct descr			*dsc,
+	const struct xfs_inumbers	*inumbers,
+	struct xfs_bulkstat_req		*breq)
 {
-	struct xfs_bulkstat	*bstat = breq->bulkstat;
-	struct xfs_bulkstat	*bs;
-	int			i;
-	int			error;
+	struct xfs_bulkstat		*bstat = breq->bulkstat;
+	struct xfs_bulkstat		*bs;
+	const uint64_t			limit_ino =
+		inumbers->xi_startino + LIBFROG_BULKSTAT_CHUNKSIZE;
+	int				i;
+	int				error;
 
 	assert(inumbers->xi_allocmask != 0);
 
@@ -73,6 +75,16 @@ bulkstat_for_inumbers(
 			 strerror_r(error, errbuf, DESCR_BUFSZ));
 	}
 
+	/*
+	 * Bulkstat might return inodes beyond xi_startino + CHUNKSIZE.  Reduce
+	 * ocount to ignore inodes not described by the inumbers record.
+	 */
+	for (i = breq->hdr.ocount - 1; i >= 0; i--) {
+		if (breq->bulkstat[i].bs_ino < limit_ino)
+			break;
+		breq->hdr.ocount--;
+	}
+
 	/*
 	 * Check each of the stats we got back to make sure we got the inodes
 	 * we asked for.

