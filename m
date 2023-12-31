Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE10CBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tcwVW9rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6386CC433C9;
	Sun, 31 Dec 2023 21:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057149;
	bh=0p1yaiu7YRV/bMApcOn1O6wj4taUI287AI9xAFl16Ho=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tcwVW9rgAetwNUxMD8bX/F9q6rCIkKRtsXbhhu6wj6jxZrH4hHsfN4vlhALIgghIi
	 bXYUrLl4TQBhSyG5vHdcH6PYwvApmeJ+FklBSaITFin0cY7GXy/NnC4mKQcT13sz5g
	 Y8olMu7qixru0WvjLpLCWHNYfz5/j6bGHD1NPRXPASrTwl7o2gOECcEqpCP3b87Gg1
	 5FDn45YyZeIZLfaRlnbiS6uxKKta5bhySaUfKIW0R2+ieAuP2iy7zIq5MwlyhPjerr
	 JBz5deWb+CLmFVW3VrozBsZLalMna/Z3uLF8OZ5IWxN5Kh9TR5Kp5M1m2K+kdr7N/3
	 Qvcye5TN3Em5g==
Date: Sun, 31 Dec 2023 13:12:28 -0800
Subject: [PATCH 24/32] xfs: scrub shouldn't tag metadata files with attr forks
 if metadir and parent pointers are on
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845252.1760491.7094434837498529448.stgit@frogsfrogsfrogs>
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

If metadata directory trees and parent pointers are both enabled, it's
ok for metadata files to have extended attribute forks.  Don't flag
these in online checking, and don't remove it during online repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |    8 ++++++--
 fs/xfs/scrub/repair.c |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index fbc28bd98e957..5a6681c6647c3 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1248,8 +1248,12 @@ xchk_metadata_inode_forks(
 		return 0;
 	}
 
-	/* They also should never have extended attributes. */
-	if (xfs_inode_hasattr(sc->ip)) {
+	/*
+	 * Metadata files can only have extended attributes if parent pointers
+	 * and the metadata directory tree are enabled.
+	 */
+	if (xfs_inode_hasattr(sc->ip) &&
+	    !(xfs_has_parent(sc->mp) && xfs_has_metadir(sc->mp))) {
 		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		return 0;
 	}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index b15eee680510c..12cbc14b24810 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1100,8 +1100,12 @@ xrep_metadata_inode_forks(
 			return error;
 	}
 
-	/* Clear the attr forks since metadata shouldn't have that. */
-	if (xfs_inode_hasattr(sc->ip)) {
+	/*
+	 * Clear the attr forks since metadata shouldn't have one unless
+	 * parent pointers and the metadata directory tree are enabled.
+	 */
+	if (xfs_inode_hasattr(sc->ip) &&
+	    !(xfs_has_parent(sc->mp) && xfs_has_metadir(sc->mp))) {
 		if (!dirty) {
 			dirty = true;
 			xfs_trans_ijoin(sc->tp, sc->ip, 0);

