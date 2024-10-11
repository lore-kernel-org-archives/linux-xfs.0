Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE07BE40
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609172; cv=none; b=YHxS/CqnCQhWBnnUkkVR3MCzykL7qQ799sPwcJA3J5kVuS610c7wESt8Y8vXBOVzzFKjGMtoGsxYg9bIakA7LNBsGVd6ZDLgjZ6XzdHP96LGo1tvRF/do3CvyZjPsKUOeApNVv+0hikL66hdqhInHWF2GZ53/VOD8C011btjYL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609172; c=relaxed/simple;
	bh=iGcpR34W1elEfdwQO0/RPx9zM+dJc5yj+HqJRmjwVLg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aCBumf+5iB2vz0243ER1l5S311fSH/Rb7NWARmNrUAWCbHkuHOV4xLSOvIrYOJeGEasrGt/Cg+XOp5kTC0ek3NlVBf7tZAWDmfyzY88ki7tGAli172cV/XTiDQno5WURhCCa/l4FHKtLNzft5vbAFGolGfY+5dosDpB313dZp1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6YD+SPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6YD+SPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF47FC4CEC5;
	Fri, 11 Oct 2024 01:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609172;
	bh=iGcpR34W1elEfdwQO0/RPx9zM+dJc5yj+HqJRmjwVLg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e6YD+SPsfG7e9wx22BEBh+dHLNCjirSP+l6zomjRVBwnCo9CUnhtdtApmfqtJEp9n
	 VJxqSGv1CuJVrVLL3MgAWbzhN2qc6W7wDi8eLtPMtxok+FKPRTOMwlGdy2EVo+8tef
	 4ONjKUQZT94RMsh+EoQU9sAemVSygG5cjWx4Cv6Jau3u0O1yc9EZQoP4yhZChuxHvq
	 kzWLhJnd08quhQpTyO0oX4sv5fIEUfJB8p4ZwdzhtLFQYbA+s804kMgp3iPP7skhQH
	 PfXj0P6YAEn+Ym4Q2BjYZ6MK9c9uz0tc+XxzlhtZukvVELE/19HnrfzU/gdbSQa2e4
	 M9JwR9+z6AjTA==
Date: Thu, 10 Oct 2024 18:12:52 -0700
Subject: [PATCH 3/6] xfs: report realtime block quota limits on realtime
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860645728.4180109.10342852954128462806.stgit@frogsfrogsfrogs>
In-Reply-To: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
index 90d79d22793e79..adc8109a6a953d 100644
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
 

