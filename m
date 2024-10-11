Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17918BE5
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609921; cv=none; b=m2+UEtdROKgXgt56+7xm6X1G/pptZRc+2YZU2hlnLaQZjTO1VJGTpODceHbgQttBgh2r4gIREFjLjxnkwFnAArlEcW55KFoWeJyLDUbdgcrqd4PewLYfYsXA2gaQEHBGVPcze632h49Akrk7pQlGGk31km10woLDdd/WYhuu++k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609921; c=relaxed/simple;
	bh=yO/aw3NraNskWiKXC6QwwNxKJRZr+2xpmrimtMSYOaw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cfrNfyp5YYPnGVZKYXY7+t2dupkDAE3xtqBTFi7MIJ3EtpxN01pno4OvRbevKvTqz88qwjQ89gPdcRbDCA9RWl/uAFgs8MOfse0wzHuyeCxDojmNNzJ5Sd+fFBc4vBjcZ+4UenmOUwlquqJ/818oWs70Lh/0cSg25wC21+igVKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNmWof0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNmWof0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3132C4CEC5;
	Fri, 11 Oct 2024 01:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609921;
	bh=yO/aw3NraNskWiKXC6QwwNxKJRZr+2xpmrimtMSYOaw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HNmWof0nxcTtO1iagI1Ev2zTL4+KzquiDiUYzWT2Ns09J9vyxtDGgaUotlrNTMMVj
	 +BnjNQvpcYxa7C439lmee1Zxcmvp/SRYeQZ/v8Gv9quAzb320niLppUlx1gs0JMZYe
	 hjJM4oC2DVUCPlCvDAumpilRiYF+faAJt3vhOjiR3CljmHezgD2TYXfT5ACep/UQKF
	 1MZL1pjqj9dyxGKIn0fPFUtrDqV/YAHFJ4Cil5FR6tRgU7UpjvR0aOAPzQnprnaFXL
	 qB4JDma/w22PJ0KlK49RafFaJvAdP/hKo7GJFR+1Q/ARYUfVvlBDA+lPe66gidYwLc
	 eDSKv2NBPSwUQ==
Date: Thu, 10 Oct 2024 18:25:21 -0700
Subject: [PATCH 03/43] libxfs: implement some sanity checking for enormous
 rgcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655412.4184637.10120294388632916359.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

Similar to what we do for suspiciously large sb_agcount values, if
someone tries to get libxfs to load a filesystem with a very large
realtime group count, let's do some basic checks of the rt device to
see if it's really that large.  If the read fails, only load the first
rtgroup and warn the user.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

