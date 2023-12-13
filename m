Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B308183A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="syRJaQYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CD2C433C7;
	Wed, 13 Dec 2023 22:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508011;
	bh=r/mHLV84wFJgCliVoQK9qd+aG4p0A/O8nja3jOfXXzk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=syRJaQYcPNGhCM/rnsrwJ2jiwTDAe3Fb9uadIFF9vU0O6sEl594n8TBAgmCnhm7au
	 Z9mpaFUrbZZnLCcJmAu3fO8fpLfP3Hp5mENfs2Ro1mIS+6GtpETLnLLrKaGy7Y7MPH
	 wLdOy3Ro/jzhVkQh6veIaEcEsRSu0GytbALMyyt85XwMqouDk4kvwnScX1o/mL5f8d
	 44e2mxlO1Q1Pf4nsGysJ+AJLscTnhzGQ+MMOcUpWQrYz+cfql6KShk13vlhiXiIyp5
	 hz4G8iSQXbvgLlwK9vjwlb79EUUpa+OpJNnZ44IhjwN9NR6EXP2HHZRe+wBPLs4Z/7
	 J6EDb4oDPMaLw==
Date: Wed, 13 Dec 2023 14:53:31 -0800
Subject: [PATCH 1/9] xfs: disable online repair quota helpers when quota not
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783483.1399182.8627947875581297917.stgit@frogsfrogsfrogs>
In-Reply-To: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
References: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
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

Don't compile the quota helper functions if quota isn't being built into
the XFS module.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.c |    2 ++
 fs/xfs/scrub/repair.h |    9 +++++++++
 2 files changed, 11 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index a604f0cea8c1..b4e7c4ad779f 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -673,6 +673,7 @@ xrep_find_ag_btree_roots(
 	return error;
 }
 
+#ifdef CONFIG_XFS_QUOTA
 /* Force a quotacheck the next time we mount. */
 void
 xrep_force_quotacheck(
@@ -734,6 +735,7 @@ xrep_ino_dqattach(
 
 	return error;
 }
+#endif /* CONFIG_XFS_QUOTA */
 
 /*
  * Initialize all the btree cursors for an AG repair except for the btree that
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index cc7ea3942729..93814acc678a 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -57,8 +57,15 @@ struct xrep_find_ag_btree {
 
 int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
+
+#ifdef CONFIG_XFS_QUOTA
 void xrep_force_quotacheck(struct xfs_scrub *sc, xfs_dqtype_t type);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
+#else
+# define xrep_force_quotacheck(sc, type)	((void)0)
+# define xrep_ino_dqattach(sc)			(0)
+#endif /* CONFIG_XFS_QUOTA */
+
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
 
 /* Repair setup functions */
@@ -87,6 +94,8 @@ int xrep_reinit_pagi(struct xfs_scrub *sc);
 
 #else
 
+#define xrep_ino_dqattach(sc)	(0)
+
 static inline int
 xrep_attempt(
 	struct xfs_scrub	*sc,

