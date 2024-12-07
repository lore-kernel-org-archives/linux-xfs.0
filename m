Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98451139B
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530020; cv=none; b=EVwen4cu6ru0pPAduzl+q+hEB1z/AFB8+6JgOYWJMpWduA6wQf7w2d3SxsD9thTqE6Wb/k2MVvJFZHcdbBNSxGjkmSVGHX8ok7Vq4p0e1SiCCt4P+bNr8243bwt38ZztuGavuXIcqUMS54TajYII+6WVop3y2PPeaG3Jl+6B3lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530020; c=relaxed/simple;
	bh=loh2sxhYhkqS8DfjBDKgW5WMuAWIWpkCKAh271kW428=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=icmD6veOknuB2ngB7B0/EIW5u2lpO/CrdzCR+yT2+cBq/35LZiZpdMapfcRMPUTM0HPDUc8rGXcEdlfnHfzfO/KNiygC4RL1tw+fYqPYonidfYQktrx2pv7tKeQJiUAtHAUC7a/au6ONpOnMIESTBuvY6W2Veu+Y4fVoextSWDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+EQ9gTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+EQ9gTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A36C4CED1;
	Sat,  7 Dec 2024 00:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530020;
	bh=loh2sxhYhkqS8DfjBDKgW5WMuAWIWpkCKAh271kW428=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f+EQ9gTb69poEark0PgTgB+59vZAjMPBPjERXMc0unIWjE36pWyp14zjpZO+fnYsg
	 E0xxnDhQLxxhbp70ZimVh4Oxr/XJoXrshstThmb6Xn0HR4pK2c5wCOTyLzKlQstSQL
	 PIcwCbzQNQQg0CjcIQw3pqiNUbU2aEEhgO9xUoePvjRF0SmJ9IPK37Rfe96Hue18Vm
	 BBYWGNU26FuTQjt/VuViolSvwEjLWkXuHuK8WUPN6+SNorOJpJpH3YfGVFpy5fafPb
	 nG3Jti/ea3YRDcqtC2YYzO7DDNrBlf62cRD9avkhKBpsC9K2Uhf6R9E+lT1TcOYrW5
	 +NAt8oqI4Y5AQ==
Date: Fri, 06 Dec 2024 16:07:00 -0800
Subject: [PATCH 08/50] libxfs: implement some sanity checking for enormous
 rgcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752068.126362.5584212124575478710.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Similar to what we do for suspiciously large sb_agcount values, if
someone tries to get libxfs to load a filesystem with a very large
realtime group count, let's do some basic checks of the rt device to
see if it's really that large.  If the read fails, only load the first
rtgroup and warn the user.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/init.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)


diff --git a/libxfs/init.c b/libxfs/init.c
index 6642cd50c00b5f..16291466ac86d3 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -654,6 +654,49 @@ xfs_set_low_space_thresholds(
 		mp->m_low_space[i] = dblocks * (i + 1);
 }
 
+/*
+ * libxfs_initialize_rtgroup will allocate a rtgroup structure for each
+ * rtgroup.  If rgcount is corrupted and insanely high, this will OOM the box.
+ * Try to read what would be the last rtgroup superblock.  If that fails, read
+ * the first one and let the user know to check the geometry.
+ */
+static inline bool
+check_many_rtgroups(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	struct xfs_buf		*bp;
+	xfs_daddr_t		d;
+	int			error;
+
+	if (!mp->m_rtdev->bt_bdev) {
+		fprintf(stderr, _("%s: no rt device, ignoring rgcount %u\n"),
+				progname, sbp->sb_rgcount);
+		if (!xfs_is_debugger(mp))
+			return false;
+
+		sbp->sb_rgcount = 0;
+		return true;
+	}
+
+	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	error = libxfs_buf_read(mp->m_rtdev, d - XFS_FSB_TO_BB(mp, 1), 1, 0,
+			&bp, NULL);
+	if (!error) {
+		libxfs_buf_relse(bp);
+		return true;
+	}
+
+	fprintf(stderr, _("%s: read of rtgroup %u failed\n"), progname,
+			sbp->sb_rgcount - 1);
+	if (!xfs_is_debugger(mp))
+		return false;
+
+	fprintf(stderr, _("%s: limiting reads to rtgroup 0\n"), progname);
+	sbp->sb_rgcount = 1;
+	return true;
+}
+
 /*
  * Mount structure initialization, provides a filled-in xfs_mount_t
  * such that the numerous XFS_* macros can be used.  If dev is zero,
@@ -810,6 +853,9 @@ libxfs_mount(
 			libxfs_buf_relse(bp);
 	}
 
+	if (sbp->sb_rgcount > 1000000 && !check_many_rtgroups(mp, sbp))
+		goto out_da;
+
 	error = libxfs_initialize_perag(mp, 0, sbp->sb_agcount,
 			sbp->sb_dblocks, &mp->m_maxagi);
 	if (error) {

