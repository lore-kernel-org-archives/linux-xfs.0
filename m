Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D193DB84
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icjld6ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2072C433C8;
	Fri, 24 Nov 2023 23:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869881;
	bh=LwhCM0jBGSq7GhOGwGa4s3e1apuJT8v7hm3P+f2XyDg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=icjld6nem8otfvrrIiXJHZ4X31iQCSAZn2XtoDAK1hvl8zbcegj3LMlO3IzSmKylH
	 oY63pl7M5ApbdLHffazfhemZza7LtECmvLgJ5xGXaK59HBPbJ3DlyfFPUpVt57aeTH
	 7Bz5R032ihOaX77EiWIYjhx8ssr7T7YgXSi+uSaUUn1vlhRWSYs5SBqA6D8WA8vruB
	 7MVnLATKDfEY4Dq4oMHRg9OduD+ngLiiANsrnlVJnJVMUCcVDcOlsBZizbjTIiwidk
	 Lq+0xku7iL0nESocMeaesczRP1JjCCQ6HmDFuvg+nRngfsUJqcVXizTARNuoCtGt86
	 teFcEOpEVy86A==
Date: Fri, 24 Nov 2023 15:51:20 -0800
Subject: [PATCH 1/7] xfs: disable online repair quota helpers when quota not
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086927457.2771142.15924813255165832144.stgit@frogsfrogsfrogs>
In-Reply-To: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/repair.c |    2 ++
 fs/xfs/scrub/repair.h |    9 +++++++++
 2 files changed, 11 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index ad1df212ec4c1..18f8d54948f26 100644
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
 
 /* Initialize all the btree cursors for an AG repair. */
 void
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

