Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9806C62D
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWSB63vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6493AC433C7;
	Thu,  7 Dec 2023 02:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916918;
	bh=hCOFdhOGIZTGooCDL77ip+ZlQ0g2EtbIOKB/89pLsCc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EWSB63vq/QFn0gdSyC1S4BNl2xvIRAOWVsVuXVAZhHrXq6SOO2B2ZILkg7eiJG/gs
	 Z+wb+ikUKDC0gjKwra+jHet9CAbU0rKMSjrOWlKLrzZXraFgME18eOCzjUZ8g7MfbA
	 7vzT9wkhaB3GdhfWG/u9g2ie3xaAggRdREpkiUIo5sNzKoHYmEqppC2Xyo+bYnb9De
	 H808BZpN2UqhMRmzLe5KheSnCSqmJXfd0vGKEniC7a48GMsCibmH1A6aMO6HZlMC93
	 Vm5pSpRquFxBBNWr99jeZcZCcj7Gcn8tCyq9EIWsWBkGnsDfJV0Tt5pdWrzW1M3BEt
	 7NbGRVC+iVjnw==
Date: Wed, 06 Dec 2023 18:41:57 -0800
Subject: [PATCH 1/9] xfs: disable online repair quota helpers when quota not
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170191666124.1182270.11742959430393900754.stgit@frogsfrogsfrogs>
In-Reply-To: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
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
index a604f0cea8c1e..b4e7c4ad779f9 100644
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
index cc7ea39427296..93814acc678a8 100644
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

