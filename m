Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD671CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846435; cv=none; b=q8YSIktpFrAnGOwx+aanGoInO0j6NkEdjDwiYH+QiWYyZvc02m78Xsqcb1e1jhFWl+6k/fn1eyUKvmLJ5H5t0K57BbtVmux+9roF4rWQrOiUyDGSk+7y9dWdMbolcFZ62hdz7CDWZLjKNprmukwYKEHgaR/Jq1OXoy4ia83h5a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846435; c=relaxed/simple;
	bh=u83W6b5fNBnzY4+5wRw+TLr+aMixEG/1D//C68gscs0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N6owaM9Oc0sFV+jfZx2bg/1ELPH4iqUgXN8cOT/dy4lpYHDX/Wq58lQJQdC7O5cOpMri6ZfZmuHIhskyrjH1wuQsuxnpfGtF4JWthOlLhx0DFWd2apBJ7pVQVoeJxUd0/Ocn0hoVHPYvBVvmSFn/S45g6eXbnzfiDJes89DMpFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPQB/hsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WPQB/hsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0ADC4CECF;
	Tue,  5 Nov 2024 22:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846434;
	bh=u83W6b5fNBnzY4+5wRw+TLr+aMixEG/1D//C68gscs0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WPQB/hswDh00kIx44rZ0bTsaTPqP1evLMNjTbPHWm0qaJmE5JnO5csGbp0Wprw6FO
	 ayEC00Jw3E6mQijcGRrWqYhL6ff4PERLwgF2zfxyrbTXLwtlMHmpsXPksfp0OVmysV
	 weqJjQo+JjzGgqUVYWAOQTZksJiooBLHMh0EWGiBwZiY1wUa+rmMIQOuXCLH7LkHGk
	 Aa8du+WnBRIz1oarsZsS75CFlV4dnoHloe/RU9r4fHuCEdU8PVwCbRS/t+mB+xAQMP
	 yXB5tQ0Jz4EkXPGZrp43Tq325lY3R9S+LA/hjtxdwtTTMOe+ogWn8ukEIFSkfSGjOY
	 uWwlggLuIYYtw==
Date: Tue, 05 Nov 2024 14:40:34 -0800
Subject: [PATCH 3/6] xfs: report realtime block quota limits on realtime
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084399613.1873230.10368889388480660250.stgit@frogsfrogsfrogs>
In-Reply-To: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
References: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On the data device, calling statvfs on a projinherit directory results
in the block and avail counts being curtailed to the project quota block
limits, if any are set.  Do the same for realtime files or directories,
only use the project quota rt block limits.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm_bhv.c |   18 ++++++++++++------
 fs/xfs/xfs_super.c  |   11 +++++------
 2 files changed, 17 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 79a96558f739e3..847ba29630e9d8 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -19,18 +19,24 @@
 STATIC void
 xfs_fill_statvfs_from_dquot(
 	struct kstatfs		*statp,
+	struct xfs_inode	*ip,
 	struct xfs_dquot	*dqp)
 {
+	struct xfs_dquot_res	*blkres = &dqp->q_blk;
 	uint64_t		limit;
 
-	limit = dqp->q_blk.softlimit ?
-		dqp->q_blk.softlimit :
-		dqp->q_blk.hardlimit;
+	if (XFS_IS_REALTIME_MOUNT(ip->i_mount) &&
+	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME)))
+		blkres = &dqp->q_rtb;
+
+	limit = blkres->softlimit ?
+		blkres->softlimit :
+		blkres->hardlimit;
 	if (limit && statp->f_blocks > limit) {
 		statp->f_blocks = limit;
 		statp->f_bfree = statp->f_bavail =
-			(statp->f_blocks > dqp->q_blk.reserved) ?
-			 (statp->f_blocks - dqp->q_blk.reserved) : 0;
+			(statp->f_blocks > blkres->reserved) ?
+			 (statp->f_blocks - blkres->reserved) : 0;
 	}
 
 	limit = dqp->q_ino.softlimit ?
@@ -61,7 +67,7 @@ xfs_qm_statvfs(
 	struct xfs_dquot	*dqp;
 
 	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
-		xfs_fill_statvfs_from_dquot(statp, dqp);
+		xfs_fill_statvfs_from_dquot(statp, ip, dqp);
 		xfs_qm_dqput(dqp);
 	}
 }
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 20fde2442768c4..f8d59081950a72 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -877,12 +877,6 @@ xfs_fs_statfs(
 	ffree = statp->f_files - (icount - ifree);
 	statp->f_ffree = max_t(int64_t, ffree, 0);
 
-
-	if ((ip->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
-	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
-			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
-		xfs_qm_statvfs(ip, statp);
-
 	if (XFS_IS_REALTIME_MOUNT(mp) &&
 	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
 		s64	freertx;
@@ -893,6 +887,11 @@ xfs_fs_statfs(
 			xfs_rtbxlen_to_blen(mp, freertx);
 	}
 
+	if ((ip->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
+	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
+			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
+		xfs_qm_statvfs(ip, statp);
+
 	return 0;
 }
 

