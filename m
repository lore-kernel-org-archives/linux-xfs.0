Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24396BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WVUR0RHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11D6C433C8;
	Sun, 31 Dec 2023 21:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057180;
	bh=cukyhDV7Ox8xuAhTdVOZyIzPsdT2av/nVjnDJ4nWqDI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WVUR0RHKLqCXW7s/sMbcWj0XAKSvaGQBDkut7qo6F40XLKNAIPN7A/283qVkuZTbT
	 65XUIsh7oiIv3s5qtWvMlbgHooaznLyimWLXnysyEDSSiIOkqCaSXFxWZADgVABE9b
	 vlDX2Vo4qI7yR+HUd+JvvUqAhsenLRT2p/CebunSKnX7hU0WL4AfDaWBEp3AjULTlf
	 W1aE8vpkFRRsWKLEEKlDnb61ej2zRB5StoEAIq+w2sKSRfOXNaECaDOTanvcTIf45c
	 r1TOXsS8Nwe4dgF8cdp85rVmKFZutYyTzEe05S+waTli38KrCiEL7aXjDQALSYrEa8
	 qIiBvCpK/Trdw==
Date: Sun, 31 Dec 2023 13:13:00 -0800
Subject: [PATCH 26/32] xfs: teach nlink scrubber to deal with metadata
 directory roots
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845284.1760491.12309799325056692631.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Enhance the inode link count online fsck code alter their behavior when
they detect metadata directory tree roots, just like they do for the
regular root directory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/nlinks.c        |   12 +++++++-----
 fs/xfs/scrub/nlinks_repair.c |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 4e62e287e1590..46785e0712377 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -275,7 +275,7 @@ xchk_nlinks_collect_dirent(
 	 * determine the backref count.
 	 */
 	if (dotdot) {
-		if (dp == sc->mp->m_rootip)
+		if (dp == sc->mp->m_rootip || dp == sc->mp->m_metadirip)
 			error = xchk_nlinks_update_incore(xnc, ino, 1, 0, 0);
 		else if (!xfs_has_parent(sc->mp))
 			error = xchk_nlinks_update_incore(xnc, ino, 0, 1, 0);
@@ -516,9 +516,11 @@ xchk_nlinks_collect(
 	int			error;
 
 	/* Count the rt and quota files that are rooted in the superblock. */
-	error = xchk_nlinks_collect_metafiles(xnc);
-	if (error)
-		return error;
+	if (!xfs_has_metadir(sc->mp)) {
+		error = xchk_nlinks_collect_metafiles(xnc);
+		if (error)
+			return error;
+	}
 
 	/*
 	 * Set up for a potentially lengthy filesystem scan by reducing our
@@ -716,7 +718,7 @@ xchk_nlinks_compare_inode(
 		}
 	}
 
-	if (ip == sc->mp->m_rootip) {
+	if (ip == sc->mp->m_rootip || ip == sc->mp->m_metadirip) {
 		/*
 		 * For the root of a directory tree, both the '.' and '..'
 		 * entries should point to the root directory.  The dotdot
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index fb299b23d5f1d..b2f1cec7d5778 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -64,7 +64,7 @@ xrep_nlinks_is_orphaned(
 
 	if (obs->parents != 0)
 		return false;
-	if (ip == mp->m_rootip || ip == sc->orphanage)
+	if (ip == mp->m_rootip || ip == sc->orphanage || ip == mp->m_metadirip)
 		return false;
 	return actual_nlink != 0;
 }

