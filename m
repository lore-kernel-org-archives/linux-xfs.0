Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB5EC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cM0xe4+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30112C433C7;
	Sun, 31 Dec 2023 23:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066814;
	bh=hSlHm6qmfeskOgDW1gHQxRQfaYl7uhSd2SjvCrW+u8Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cM0xe4+u61mJTuUXfeT5M8K7rzhk2qVe+C2QMzOL4tVGPYBxzX1FsruQ0VSdwrgSu
	 GpCNRukrUOBsNKLjC7fpHXnYmfB9SA6topyLehLmsboLjAFpgSUm6ZH7OeOHNPxlCt
	 p9M9t+Tm5NdOuqIWwmj4AkZTG7QxCJR3On6415ak2eT0UYh/6fg5UlKZRct/2wRnCr
	 XoFr4QU0uxOfHrm57rFxjuJYAH1QketkciEXUzwfZcz1OPFXA4p2r997337ipQ6Nwv
	 SEei3E1TPbOB7f5ATkogsffheMm8aHcEhnGNObWCqrFql24Yp6vHT1IK276pNTQ6Zc
	 wf6osR9EcINPw==
Date: Sun, 31 Dec 2023 15:53:33 -0800
Subject: [PATCH 23/52] libxfs: implement some sanity checking for enormous
 rgcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012475.1811243.1094484901228200396.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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
 libxfs/init.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)


diff --git a/libxfs/init.c b/libxfs/init.c
index f1ba28a3ca3..0332a4eeb21 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -725,6 +725,50 @@ xfs_set_low_space_thresholds(
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
+	xfs_rtblock_t		rtbno;
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
+	rtbno = xfs_rgbno_to_rtb(mp, sbp->sb_rgcount - 1, 0);
+
+	error = libxfs_buf_read(mp->m_rtdev, xfs_rtb_to_daddr(mp, rtbno), 1, 0,
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
@@ -878,6 +922,9 @@ libxfs_mount(
 			libxfs_buf_relse(bp);
 	}
 
+	if (sbp->sb_rgcount > 1000000 && !check_many_rtgroups(mp, sbp))
+		goto out_da;
+
 	error = libxfs_initialize_perag(mp, sbp->sb_agcount, sbp->sb_dblocks,
 			&mp->m_maxagi);
 	if (error) {

