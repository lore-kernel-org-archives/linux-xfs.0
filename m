Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA23620
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371267; cv=none; b=urmVltysL+BS8uskD921oLESBXS4X4Uxu8uegsTuubzJrh5lD/Idigd0um8QfFhzdg4X1ouT20Nmb/CKQCejonz2dITC3ZvO0MqahiXwamWQfEz8d1/M1xmpQMAnf4CueCaD2r8+DNXhfyaYcgYSQfEvEbu3keV0356kkH8+xAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371267; c=relaxed/simple;
	bh=s0E+oOFibR+7/dofV4XSkWiEyLRmZZPRwLlbARikCYQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QUjw0tQmlrdLEhGARPavMv2G3mJgYXLUsjUKpSsqFmuck2GY0IY6Gm2KS7KKuNQyUXWJgika71vWQMt4eyuhdLFvULE5nziTTUPZUwO4jf9qw2RbMmK67WOFbW12OIDwmmQ9Zb0jSuZGwVbOXPRy68tefM8Kg1Ep09IwM92/QOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aILUMCrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aILUMCrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4C4C32782;
	Fri, 23 Aug 2024 00:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371267;
	bh=s0E+oOFibR+7/dofV4XSkWiEyLRmZZPRwLlbARikCYQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aILUMCrV6j6roVSkxtDJdtfIYD3EpSPTLRmtMV14RGwyZWv53cBmVy1v6uXQSa0bj
	 H/MRb6qV0yHiqf21wA7Qwy7lK5WnGm8pduWnbPLk+XZVfX6C/RixcpupcfOgN/5opX
	 PjatXU5PIsnXVImRK7MtkWM4+CDKbAPgO7+Dv3h8fTAc8ACYOsASF7Owh15Zp9KCZr
	 nbUnTNQJXwWrRIZjQtOwp3PjhKUJw6BrG4a//xLWoAdcPO/AK7XvfhM0rsolRwICYS
	 mupU5zOKEZCF/PuWgNt1Li0nqvinb+ZXrbby/vzd8hSZeBGlOF0rhDbnmzl8MZRaSw
	 OkN0H1XVOilxg==
Date: Thu, 22 Aug 2024 17:01:07 -0700
Subject: [PATCH 9/9] xfs: reset rootdir extent size hint after growfsrt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437083905.56860.4443371257049623802.stgit@frogsfrogsfrogs>
In-Reply-To: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
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

If growfsrt is run on a filesystem that doesn't have a rt volume, it's
possible to change the rt extent size.  If the root directory was
previously set up with an inherited extent size hint and rtinherit, it's
possible that the hint is no longer a multiple of the rt extent size.
Although the verifiers don't complain about this, xfs_repair will, so if
we detect this situation, log the root directory to clean it up.  This
is still racy, but it's better than nothing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 776d6c401f62f..ebeab8e4dab10 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -784,6 +784,39 @@ xfs_alloc_rsum_cache(
 		xfs_warn(mp, "could not allocate realtime summary cache");
 }
 
+/*
+ * If we changed the rt extent size (meaning there was no rt volume previously)
+ * and the root directory had EXTSZINHERIT and RTINHERIT set, it's possible
+ * that the extent size hint on the root directory is no longer congruent with
+ * the new rt extent size.  Log the rootdir inode to fix this.
+ */
+static int
+xfs_growfs_rt_fixup_extsize(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inode	*ip = mp->m_rootip;
+	struct xfs_trans	*tp;
+	int			error = 0;
+
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	if (!(ip->i_diflags & XFS_DIFLAG_RTINHERIT) ||
+	    !(ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT))
+		goto out_iolock;
+
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange, 0, 0, false,
+			&tp);
+	if (error)
+		goto out_iolock;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+out_iolock:
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return error;
+}
+
 /*
  * Visible (exported) functions.
  */
@@ -812,6 +845,7 @@ xfs_growfs_rt(
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
 	xfs_sb_t	*sbp;		/* old superblock */
 	uint8_t		*rsum_cache;	/* old summary cache */
+	xfs_agblock_t	old_rextsize = mp->m_sb.sb_rextsize;
 
 	sbp = &mp->m_sb;
 
@@ -1046,6 +1080,12 @@ xfs_growfs_rt(
 	if (error)
 		goto out_free;
 
+	if (old_rextsize != in->extsize) {
+		error = xfs_growfs_rt_fixup_extsize(mp);
+		if (error)
+			goto out_free;
+	}
+
 	/* Update secondary superblocks now the physical grow has completed */
 	error = xfs_update_secondary_sbs(mp);
 

