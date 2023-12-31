Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D720BC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMqJBxdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB75C433C7;
	Sun, 31 Dec 2023 23:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066767;
	bh=AcE+RvC2+n4vqEbsjhnzgEZ7T2lW+MpTUz5a3slxnGo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rMqJBxdI7mRlqglonFL1NofVwpPnDvwF2EUav+j1SzG/0FjIxzEB51kLVYguNP7+X
	 unu3VOQnoTAblcZ19KlrcszHqXe44BpoaG+/BzIc+9ut1C4vTn8OV4vZKmWnrWMXZT
	 fIYAz7dEll/dIn4A6IeN1Pk1ni7kLhnqKXNs4yHhcRAUoBFFi77AjPik9VWBGOdKsd
	 limkVYc5MHreil43rniAleuQerBYWLkLXhQcbp0uBtzAnytUR8pnbecL0Rb+5QDE0/
	 +EUiGYKoxqPc2jbocShhTMz2gl2CgDK9Bp7YkQPfPIxKSsRtOplWCRcw3rplyfR+GC
	 OOw8o/1j/SlGA==
Date: Sun, 31 Dec 2023 15:52:46 -0800
Subject: [PATCH 20/52] xfs: repair secondary realtime group superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012435.1811243.8121937227947033236.stgit@frogsfrogsfrogs>
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

Repair secondary realtime group superblocks.  They're not critical for
anything, but some consistency would be a good idea.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtgroup.c |    2 +-
 libxfs/xfs_rtgroup.h |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index c503a39b0fc..4ef6b9e9094 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -418,7 +418,7 @@ xfs_rtgroup_log_super(
 }
 
 /* Initialize a secondary realtime superblock. */
-static int
+int
 xfs_rtgroup_init_secondary_super(
 	struct xfs_mount	*mp,
 	xfs_rgnumber_t		rgno,
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index e6d60425faa..0a63f14b5aa 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -221,6 +221,8 @@ void xfs_rtgroup_update_super(struct xfs_buf *rtsb_bp,
 		const struct xfs_buf *sb_bp);
 void xfs_rtgroup_log_super(struct xfs_trans *tp, const struct xfs_buf *sb_bp);
 int xfs_rtgroup_update_secondary_sbs(struct xfs_mount *mp);
+int xfs_rtgroup_init_secondary_super(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		struct xfs_buf **bpp);
 
 /* Lock the rt bitmap inode in exclusive mode */
 #define XFS_RTGLOCK_BITMAP		(1U << 0)
@@ -241,6 +243,7 @@ int xfs_rtgroup_get_geometry(struct xfs_rtgroup *rtg,
 # define xfs_rtgroup_update_super(bp, sb_bp)	((void)0)
 # define xfs_rtgroup_log_super(tp, sb_bp)	((void)0)
 # define xfs_rtgroup_update_secondary_sbs(mp)	(0)
+# define xfs_rtgroup_init_secondary_super(mp, rgno, bpp)	(-EOPNOTSUPP)
 # define xfs_rtgroup_lock(tp, rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)

