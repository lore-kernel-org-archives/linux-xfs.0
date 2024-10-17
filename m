Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DDA2194B7
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192267; cv=none; b=eJlJ5fAS8s8Hn/oZwnRCyTWYeiOwNiSGkWh9ws+J1e7S+t2RaIUtFEghwSxxHec/1Rmzek3eIt4FmPoIPblJiQINWfaxJ4YYdaG4LXRrcyZu+Ihes9t5lTaYK8mcPj+DKTO1nGUCHDeFcYfRJBvhaJ4kwUkx2HL3xoyZz7eKmD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192267; c=relaxed/simple;
	bh=vIIDjwyLOZ75SAZIx0/aNIuCXHCl6sG4okw4vzsAfFI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igSsY4v3p1NhkIJLfjp7eyMWAUpbx+uRUnMDyTjDIxRKbOeuVKHPc4cyxFq+2ZeMFYhUIcHIFWZ6uG1qupRGIemrNY7JUSasSYA6MtBp3PGeCPdfdinBGT5NKZqJVZHEmRzpU0dLt2b5IaBOyqx/1+exCmfB9dSSmlHMNID3ga4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Emy7VccC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Emy7VccC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47F9C4CEC3;
	Thu, 17 Oct 2024 19:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192266;
	bh=vIIDjwyLOZ75SAZIx0/aNIuCXHCl6sG4okw4vzsAfFI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Emy7VccCaEaetR29azQf25wCI5peiMwUxVGuRKbp87VUva6diM222FPSvVF8zPAZ/
	 5tn6EMyCLyRDteEP5bIOY9rtpzp5z+uwjtQnRdtroNLBotn/u4v7FVW5upVbZP2DRw
	 g43dWHHVSeHJfxHO5C31nqqD2e7cJbWudOR082l06u686PN0MLjXXT2kKr1fcVFh/U
	 t7DavCa7JNx2PC7UFbnYgSEWx/wGlnxVXy27LaEIb0qZ9mCBrdKsqCayHemF5aBKFC
	 xsOO84rMi6zH+q5bVKc3xA4PULOqDY8iQ7NuLXsBueqbuVu+8Ikw3kHKidgz5VMPR/
	 eB5LyGyvCLwOg==
Date: Thu, 17 Oct 2024 12:11:06 -0700
Subject: [PATCH 3/6] xfs: report realtime block quota limits on realtime
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919073129.3456016.18028274540878573379.stgit@frogsfrogsfrogs>
In-Reply-To: <172919073062.3456016.13160926749424883839.stgit@frogsfrogsfrogs>
References: <172919073062.3456016.13160926749424883839.stgit@frogsfrogsfrogs>
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
index 7a9cfdb66c0313..8bbe6511fec7c2 100644
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
 

