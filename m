Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAA7BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0XvZpRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF7DC433C7;
	Sun, 31 Dec 2023 20:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054974;
	bh=FxJ1I10REOdyl51tTkwuLVKMcd7d4WilvrDcrazj0tQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F0XvZpRQOD7kcj4QTAhPJKYEPrf0t054MA+p4G1Nuuf/qW2WB8MI8MRs56UgMJuSJ
	 9k8Jmwqx68OtwDHzl4atkr0tghdTpXP6fzoUUapdCFgqrM0buzVFKiW13+FgeDISf2
	 DPr485U4fFqPvy82dyx4h+FV2D8jMjt4qI+LpmIGg6he3vW3wim7uJEOGxD4cFbtl4
	 h/1iLKRS8qqChiadd+3hgobr3+1e+mtm2dGsEz18ZYLZlHINexthQOclr+jxCx+pw3
	 zybbAtHaZiE6nimyyWurLD8PFZuXKvR/CNFuXU/CF/19wL0FOE/rsOuDNxZuqFSsau
	 N1yUUb8Llm1tw==
Date: Sun, 31 Dec 2023 12:36:14 -0800
Subject: [PATCH 5/6] xfs: flag empty xattr leaf blocks for optimization
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404835296.1753315.1515475809477956883.stgit@frogsfrogsfrogs>
In-Reply-To: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
References: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
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

Empty xattr leaf blocks at offset zero are a waste of space but
otherwise harmless.  If we encounter one, flag it as an opportunity for
optimization.

If we encounter empty attr leaf blocks anywhere else in the attr fork,
that's corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c    |   11 +++++++++++
 fs/xfs/scrub/dabtree.h |    2 ++
 2 files changed, 13 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 7dccbc849b19b..07e8ca840745c 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -420,6 +420,17 @@ xchk_xattr_block(
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
 
+	/*
+	 * Empty xattr leaf blocks mapped at block 0 are probably a byproduct
+	 * of a race between setxattr and a log shutdown.  Anywhere else in the
+	 * attr fork is a corruption.
+	 */
+	if (leafhdr.count == 0) {
+		if (blk->blkno == 0)
+			xchk_da_set_preen(ds, level);
+		else
+			xchk_da_set_corrupt(ds, level);
+	}
 	if (leafhdr.usedbytes > mp->m_attr_geo->blksize)
 		xchk_da_set_corrupt(ds, level);
 	if (leafhdr.firstused > mp->m_attr_geo->blksize)
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index d654c125feb4d..de291e3b77dd8 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -37,6 +37,8 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
 void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
+void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
+
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
 		xchk_da_btree_rec_fn scrub_fn, void *private);

