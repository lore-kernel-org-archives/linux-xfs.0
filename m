Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73D818E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846169; cv=none; b=MYdKSpx9tnRRozZqu+vhIGvneM4ZTBWk8o8w8ZJkmasfK/QIXw1K+Qbz0XhlI5/6DvLp2AMuiLxZQ/XEy/lfPkZjbZ+mhBG84WWAJrDMwtJTQqMyu0+l0KOrha0WZt7AAFwJ0zj/LhZqn9W5gJKeZUZtXV+h9NzxBk45CZV6O7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846169; c=relaxed/simple;
	bh=lRfe52tyMyBnmokqal2CmqJt6IEB3cyIqrb5SMrW8CU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M5qtRkWNkp6ApnQ2A83cAUEtjsWqytCOKe4mJWfR+1JAnq8wmhfLeHX+LfpFsDUPpqGETrzGwj60/Tf7dbHqDpT09QsudemwedXpvepFG2ucd1jNhVY3KugdM7tLrawlr8Be1AcU/HuF9OSSMYoOPBw+mBFiheuSWDMWyat7f/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hf8YbthR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hf8YbthR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866CCC4CECF;
	Tue,  5 Nov 2024 22:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846169;
	bh=lRfe52tyMyBnmokqal2CmqJt6IEB3cyIqrb5SMrW8CU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Hf8YbthRoQKQGHzZe5pSC4XgDNtesgdfp1PGAUaszmfurMWaCMoAkK3XPy1KT9pvU
	 e5OPJUWD0hQDCszpC7lFmEReVNTgg2Gbh8UM6b5xKnkzTmUHUxk8XikFURYh5NMEmi
	 C74ZX3gX/XDcts1+nnG7qxgtVSzeupf4R2y1YhoQHbGxBHGaKgPdryyaRyiUKFZK4f
	 VKt3gVMAyHZnsZO3TYqRLIr7IJPS79MaDNnolp+iVw/yOp1iJR9lcUoj7O3/tMZ5iN
	 ndH2RbpryDXiFKEXgMWDgmFEIr31FUkMGP0wSlsOd0EefWUco4BYV2OnRC+muKEEDL
	 uBbHA3YQUQmkw==
Date: Tue, 05 Nov 2024 14:36:09 -0800
Subject: [PATCH 24/34] xfs: repair realtime group superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398595.1871887.12005909406385038484.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Repair the realtime superblock if it has become out of date with the
primary superblock.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.h  |    3 +++
 fs/xfs/scrub/rgsuper.c |   16 ++++++++++++++++
 fs/xfs/scrub/scrub.c   |    2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 4052185743910d..b649da1a93eb8c 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -146,9 +146,11 @@ int xrep_metapath(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
 int xrep_rtsummary(struct xfs_scrub *sc);
+int xrep_rgsuperblock(struct xfs_scrub *sc);
 #else
 # define xrep_rtbitmap			xrep_notsupported
 # define xrep_rtsummary			xrep_notsupported
+# define xrep_rgsuperblock		xrep_notsupported
 #endif /* CONFIG_XFS_RT */
 
 #ifdef CONFIG_XFS_QUOTA
@@ -253,6 +255,7 @@ static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_symlink			xrep_notsupported
 #define xrep_dirtree			xrep_notsupported
 #define xrep_metapath			xrep_notsupported
+#define xrep_rgsuperblock		xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index 00dfe043dfea7f..463b3573bb761b 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -10,8 +10,12 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_rtgroup.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/repair.h"
 
 /* Set us up with a transaction and an empty context. */
 int
@@ -66,3 +70,15 @@ xchk_rgsuperblock(
 	xchk_rgsuperblock_xref(sc);
 	return 0;
 }
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+int
+xrep_rgsuperblock(
+	struct xfs_scrub	*sc)
+{
+	ASSERT(rtg_rgno(sc->sr.rtg) == 0);
+
+	xfs_log_sb(sc->tp);
+	return 0;
+}
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index ceb22c722d8f52..950f5a58dcd967 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -456,7 +456,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rgsuperblock,
 		.scrub	= xchk_rgsuperblock,
 		.has	= xfs_has_rtsb,
-		.repair = xrep_notsupported,
+		.repair = xrep_rgsuperblock,
 	},
 };
 

