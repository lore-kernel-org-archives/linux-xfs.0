Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9550613FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992047; cv=none; b=OhrSYcOHrL4NJyql4qhUgIkqYQ+zXoYSGqS/pYEkDrMWvEaNUmdZo1hl6+8T7smDLDBcEW6UOoHLGKELZ8BM4mK9C5UniK0+KVzzcvDW4pmJ76f3GccLnZaWCQYWNJRTlOdGzqujaeb++JKOoricQxSaM2F3OfwsRDHOBxzFp+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992047; c=relaxed/simple;
	bh=qredLaqZSVHKZIewrncChktl+Uq73WmkT/C4nzIJ12w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D/4I9aK8VHpvfrR2Uq/m4tsDl2zN37OR39sdLCp19NPwt9/E6jF+eTgw6WUrVk9s94ZNG7DUuJa/zl/2L5ApG5lQCf5N2Op8tfP9OSDhBU/qESUC410a4ht62Zb4qJRDNr0mZ9SqCXZrrEliRuiPItH0VxdlOJTw2laFrwGsWR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KhhYaUJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KhhYaUJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235E4C4CED3;
	Mon, 23 Dec 2024 22:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992047;
	bh=qredLaqZSVHKZIewrncChktl+Uq73WmkT/C4nzIJ12w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KhhYaUJf8d1G/vNgxAFguxngZya1jdOw8oF5GidKhuYMtcqeRh+ijoqbSsvlRMJ8X
	 Iezz6K8rjOj/1WjJbhHatiuE+PmtQANgh8cOS9dkUpddKe+uTJw0pAcANp4dxtB99z
	 S6CbpQB9kylBt5dwSkiKFd36YJ1fMSyYvVbwBSYe79wguAULmYVurvf84cxOsGMLuw
	 ry2Bxi3e3RScB9gCJkFwNSJrydiyWGlOxcNlS8ge6ZG4ABsXcZJDuGRXXKbNyeLIdH
	 Rc8tVH/EQGpeEjJENcUeEt3zJXd1YSLxQf2R0tIQCRnbgumS8MBtiuHhy+A/GAN+1Y
	 l3BQFVHejWmBg==
Date: Mon, 23 Dec 2024 14:14:06 -0800
Subject: [PATCH 09/51] libxfs: implement some sanity checking for enormous
 rgcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943941.2297565.9493389794666208223.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

