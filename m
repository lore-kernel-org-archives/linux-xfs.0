Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD2E18A6D7
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995693; cv=none; b=d2GBoPK3diFpBH+7JL05byyi/pAzomrnVoGg/dHeLE9MWxYZqc0PLs8xjZutGdGesqWDuaAflSDsr1Q+DNAnNTqGg1BWJ/qO1jABW9vO2cnZTj3cGABAIsYvI8kz6PqkUAGVAzYpMGX6T7+gzamvSxiyv9rM1hPg7J4mPmgGcUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995693; c=relaxed/simple;
	bh=t2V91u8ZRt6DztCKRdl1jxpanDsYCJlKI+HBKQ8GxWA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=exDWq+7MEqhqr7X6fdGGJpT4MKuBOq4pchdU+Ha8L1T2bY/yhqCt88T3KadPJLY9MjiHFDg8Ay4ibDQVgIxUI4QO51RL0xuRtNWZPPF2wasnbGyOMAFBzKhy33LWCKk+Izv3b2xuZUs8wj34hOQe/w5tnofkEkG6esfyYXAA9Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWk5NIRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWk5NIRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C922C4CED3;
	Mon, 23 Dec 2024 23:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995693;
	bh=t2V91u8ZRt6DztCKRdl1jxpanDsYCJlKI+HBKQ8GxWA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TWk5NIRFTv+2u2RdKDI6jxjLY4eajEbJLH+JnQ4dHr2K5ZgKRXXosegiPzhNY16Tb
	 +D2pmiez7vdqVt52b5moe/Yt9+/xhydjc01TMTnwKCkSgp9QVR5PJMu6cMpa6MlGvq
	 bw9ihT16J+gUgk7rcaqDE6n3EC2mTGQgrWq21iotVC/BXySdZxx4i6MXbMG2Uq+cm0
	 CSkXl3heEZhVLOqSlC4U79ph7OoBVwo7N+n9V3HM9KG693Esb6PaYcFHn9N/AsEgdB
	 tvioKJ1BXPVkPCvD3eE1txfAf+iz3QiB7uVk+au/dAEk3mfFHJwGOdOSq5tm3uPqI5
	 4MbyKwg3XUPXg==
Date: Mon, 23 Dec 2024 15:14:53 -0800
Subject: [PATCH 33/43] xfs: detect and repair misaligned rtinherit directory
 cowextsize hints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420504.2381378.9592738513389234942.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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

