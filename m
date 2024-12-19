Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E321990BA
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637298; cv=none; b=r6dufvt4I1lBoFJ0HaSkIEqH7IJ8M7EI6WJsKuYP/jkl0n3hfZDqaDO/89FF01p2OoOPoKWcw6nIaAvXqYPzbWycH5FOYlJbNNNnSPtmRGgHCx3kEe16iq6hpP8lk1JfrKbGOGlavoQZ+6pNwGSvPYyfj+gxiqo+vVA2LBHePTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637298; c=relaxed/simple;
	bh=t2V91u8ZRt6DztCKRdl1jxpanDsYCJlKI+HBKQ8GxWA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qrYuRclT/FnycQzP7pQpDWlQ1DmnS2eeym6PW7F/mffA/EzVvOrA9LtAQcTGUanAnxCsEZwieYvSYjxBGWnK2c/LFNB/ZV8VcCB5khaMOmfWoMc4pYh6o7HCUjpYEiDH3anOc5TCihX1yn/LIOS/6plzGCpT8B5Ek4YWk14RuQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TgKhdh55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TgKhdh55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7459DC4CECE;
	Thu, 19 Dec 2024 19:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637298;
	bh=t2V91u8ZRt6DztCKRdl1jxpanDsYCJlKI+HBKQ8GxWA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TgKhdh55fgCMH9Cz7nYJABjvOl8U2JuHe/L9N/uWH1idAM+0hUkIv+PdKyd74NXSM
	 sFB+vZDUF181oSDmf+jQ+BbDs7tDivhXetUjOr3Y8pcNuToC+hHrQsQWCKiRYjB/p2
	 B+1zpiWJ0S6zwxEhIEUlg3FSAJnuwViyjBwK+MeoPGxzuQk9dmWoJouNAgTtTafx8s
	 qa1AWvDgT6J2mvCOBFhoXMiWkwSsYpWUAccOK9dFk3Dz9cdE0L/n0GLCy3k6AtizVD
	 Ba6nSsSszt9lHGiD2h+Bq1lN0usCwG9s5kf1RqHQpoV0A4DbTYmLknUHOhIhID4pFk
	 xTQ1wI+I6i5Vw==
Date: Thu, 19 Dec 2024 11:41:37 -0800
Subject: [PATCH 33/43] xfs: detect and repair misaligned rtinherit directory
 cowextsize hints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581543.1572761.15691236377043085261.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we encounter a directory that has been configured to pass on a CoW
extent size hint to a new realtime file and the hint isn't an integer
multiple of the rt extent size, we should flag the hint for
administrative review and/or turn it off because that is a
misconfiguration.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode.c        |   26 +++++++++++++++++---------
 fs/xfs/scrub/inode_repair.c |   15 +++++++++++++++
 2 files changed, 32 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index c7bbc3f78e90b1..db6edd5a5fe5d8 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -260,12 +260,7 @@ xchk_inode_extsize(
 		xchk_ino_set_warning(sc, ino);
 }
 
-/*
- * Validate di_cowextsize hint.
- *
- * The rules are documented at xfs_ioctl_setattr_check_cowextsize().
- * These functions must be kept in sync with each other.
- */
+/* Validate di_cowextsize hint. */
 STATIC void
 xchk_inode_cowextsize(
 	struct xfs_scrub	*sc,
@@ -276,12 +271,25 @@ xchk_inode_cowextsize(
 	uint64_t		flags2)
 {
 	xfs_failaddr_t		fa;
+	uint32_t		value = be32_to_cpu(dip->di_cowextsize);
 
-	fa = xfs_inode_validate_cowextsize(sc->mp,
-			be32_to_cpu(dip->di_cowextsize), mode, flags,
-			flags2);
+	fa = xfs_inode_validate_cowextsize(sc->mp, value, mode, flags, flags2);
 	if (fa)
 		xchk_ino_set_corrupt(sc, ino);
+
+	/*
+	 * XFS allows a sysadmin to change the rt extent size when adding a rt
+	 * section to a filesystem after formatting.  If there are any
+	 * directories with cowextsize and rtinherit set, the hint could become
+	 * misaligned with the new rextsize.  The verifier doesn't check this,
+	 * because we allow rtinherit directories even without an rt device.
+	 * Flag this as an administrative warning since we will clean this up
+	 * eventually.
+	 */
+	if ((flags & XFS_DIFLAG_RTINHERIT) &&
+	    (flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    value % sc->mp->m_sb.sb_rextsize > 0)
+		xchk_ino_set_warning(sc, ino);
 }
 
 /* Make sure the di_flags make sense for the inode. */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 938a18721f3697..701baee144a66e 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1903,6 +1903,20 @@ xrep_inode_pptr(
 			sizeof(struct xfs_attr_sf_hdr), true);
 }
 
+/* Fix COW extent size hint problems. */
+STATIC void
+xrep_inode_cowextsize(
+	struct xfs_scrub	*sc)
+{
+	/* Fix misaligned CoW extent size hints on a directory. */
+	if ((sc->ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (sc->ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    sc->ip->i_extsize % sc->mp->m_sb.sb_rextsize > 0) {
+		sc->ip->i_cowextsize = 0;
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+	}
+}
+
 /* Fix any irregularities in an inode that the verifiers don't catch. */
 STATIC int
 xrep_inode_problems(
@@ -1926,6 +1940,7 @@ xrep_inode_problems(
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
 		xrep_inode_dir_size(sc);
 	xrep_inode_extsize(sc);
+	xrep_inode_cowextsize(sc);
 
 	trace_xrep_inode_fixed(sc);
 	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);

