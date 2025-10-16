Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCF81DF982;
	Thu, 16 Oct 2025 16:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760631921; cv=none; b=daER27UTGR8ukUguWEccaaVfUQ16J+HnFDrIFiUPcM+LHLWJ/hrm1uM5Zp+36Ql1/Vp08f2xd+g/HKF/3d5lCZILcpuDj+MVQTPNsuMF5iiFCvFGE/1EZu6wOblhc4g4cjoj+NZBB0nhIULsmBY1+amctxLqjcG1dmMiFFC0Rvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760631921; c=relaxed/simple;
	bh=Ur8b/tBAj1XMiE3ZQhEMBO4X4i1WG2QSesZ1qm4qfIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taJYb2HOpEfOzuF6HM4NdQfZ662Xay+Vk5SemKLcl2pjFOHzEIje2+SD5tAmT01eS0suVVY2pJG2MDmneRdNrL/SDDJuQtrOjqYSA0VdXf2LOGgPI2lI3Jjoug5oMe8k8qogP6jljktHQNcuZEFPLdhT1MyjWjr97RMpYhbi0kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNMUAcW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNMUAcW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EC2C4CEF1;
	Thu, 16 Oct 2025 16:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760631921;
	bh=Ur8b/tBAj1XMiE3ZQhEMBO4X4i1WG2QSesZ1qm4qfIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MNMUAcW19ecxw3OiDXsL6iBuz17YQJ3jHC1TflaDqkXNrfQwUl3AGUTqlP1ceRiB0
	 +4tUjwaIiiUEjQ/livemBkzoAgAhlghkZn5UvcEIEGkbKh5zU6d30oFM2n9ggbYkPv
	 y9qnfotoxUeZ1hyB2ecky4aS+HjZ2tXT/csQTJ4YiU2x9vcAk/rg5QhLfxKOxYWEnP
	 nGLE+AKCsTMxvKw6q0d2RGBdYgFZQyOhkSoHsY+Q11NkZZ/S3Zm4j8KGNZv8L180YH
	 3M4qDWKmPpj35eSfHd3wg4i72qNvZ1Xm29cqfM7FRPfZ2eNL9arvwtmVxI1XQcUDby
	 K5k2CUmsIp0Qg==
Date: Thu, 16 Oct 2025 09:25:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Pavel Reichl <preichl@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: [PATCH 4/3] xfs: fix locking in xchk_nlinks_collect_dir
Message-ID: <20251016162520.GB3356773@frogsfrogsfrogs>
References: <20251015050133.GV6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015050133.GV6188@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

On a filesystem with parent pointers, xchk_nlinks_collect_dir walks both
the directory entries (data fork) and the parent pointers (attr fork) to
determine the correct link count.  Unfortunately I forgot to update the
lock mode logic to handle the case of a directory whose attr fork is in
btree format and has not yet been loaded *and* whose data fork doesn't
need loading.

This leads to a bunch of assertions from xfs/286 in xfs_iread_extents
because we only took ILOCK_SHARED, not ILOCK_EXCL.  You'd need the rare
happenstance of a directory with a large number of non-pptr extended
attributes set and enough memory pressure to cause the directory to be
evicted and partially reloaded from disk.

I /think/ this only started in 6.18-rc1 because I've started seeing OOM
errors with the maple tree slab using 70% of memory, and this didn't
happen in 6.17.  Yay dynamic systems!

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 77ede5f44b0d86 ("xfs: walk directory parent pointers to determine backref count")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/nlinks.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 26721fab5cab42..dcd57c3f65dfdc 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -376,6 +376,24 @@ xchk_nlinks_collect_pptr(
 	return error;
 }
 
+static uint
+xchk_nlinks_ilock_dir(
+	struct xfs_inode	*ip)
+{
+	uint			lock_mode = XFS_ILOCK_SHARED;
+
+	if (xfs_need_iread_extents(&ip->i_df))
+		lock_mode = XFS_ILOCK_EXCL;
+
+	if (xfs_has_parent(ip->i_mount) && xfs_inode_has_attr_fork(ip) &&
+	    xfs_need_iread_extents(&ip->i_af))
+		lock_mode = XFS_ILOCK_EXCL;
+
+	lock_mode |= XFS_IOLOCK_SHARED;
+	xfs_ilock(ip, lock_mode);
+	return lock_mode;
+}
+
 /* Walk a directory to bump the observed link counts of the children. */
 STATIC int
 xchk_nlinks_collect_dir(
@@ -394,8 +412,7 @@ xchk_nlinks_collect_dir(
 		return 0;
 
 	/* Prevent anyone from changing this directory while we walk it. */
-	xfs_ilock(dp, XFS_IOLOCK_SHARED);
-	lock_mode = xfs_ilock_data_map_shared(dp);
+	lock_mode = xchk_nlinks_ilock_dir(dp);
 
 	/*
 	 * The dotdot entry of an unlinked directory still points to the last
@@ -452,7 +469,6 @@ xchk_nlinks_collect_dir(
 	xchk_iscan_abort(&xnc->collect_iscan);
 out_unlock:
 	xfs_iunlock(dp, lock_mode);
-	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 	return error;
 }
 
