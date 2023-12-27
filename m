Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734141376
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c41RnNTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AF6C433C7;
	Mon,  1 Jan 2024 00:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069364;
	bh=mFd+f2n7Oeyg8X/eS5u01YeVGAAcoKqmebIq50is6AE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c41RnNToetcw+4VfO7+xs//GAGEyKShKk5EbUJfnANzAiS23p8TUEaofMhVcn4qM/
	 pZQCnTw2oUBTvdkIX+dFwtuG87UMA3Z+OGnuiq5Dixi8zsu14pIpp+OHjgikBTXM26
	 xjDMyTcKphWc5TfpgRHh4lPRYWps6wtD2b3b4nMuTo8ZBrEvElVLq689t+DgfxCMxb
	 LhILHIm224EdVSKGQ1IAcoMruc8nPu2m3L1Pf4Af8xVYOw5dwBtoPoFcdvbcDMKBs2
	 ++LbUlcbVwpC/s6sKQheHvNsMgOknJVwVTt3EbivOceigBdLmomBbNxFwAYh877E0c
	 Xm32orh/MaSGQ==
Date: Sun, 31 Dec 2023 16:36:03 +9900
Subject: [PATCH 38/42] xfs_repair: validate CoW extent size hint on rtinherit
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017634.1817107.4786026043233889277.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

XFS allows a sysadmin to change the rt extent size when adding a rt
section to a filesystem after formatting.  If there are any directories
with both a cowextsize hint and rtinherit set, the hint could become
misaligned with the new rextsize.  Offer to fix the problem if we're in
modify mode and the verifier didn't trip.  If we're in dry run mode,
we let the kernel fix it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   64 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 21 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 2b254b29c4a..df88a162829 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2808,6 +2808,47 @@ _("Bad extent size hint %u on inode %" PRIu64 ", "),
 	}
 }
 
+static void
+validate_cowextsize(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dino,
+	xfs_ino_t		lino,
+	int			*dirty)
+{
+	uint16_t		flags = be16_to_cpu(dino->di_flags);
+	uint64_t		flags2 = be64_to_cpu(dino->di_flags2);
+	unsigned int		value = be32_to_cpu(dino->di_cowextsize);
+	bool			misaligned = false;
+	bool			bad;
+
+	/*
+	 * XFS allows a sysadmin to change the rt extent size when adding a
+	 * rt section to a filesystem after formatting.  If there are any
+	 * directories with both a cowextsize hint and rtinherit set, the
+	 * hint could become misaligned with the new rextsize.
+	 */
+	if ((flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    (flags & XFS_DIFLAG_RTINHERIT) &&
+	    value % mp->m_sb.sb_rextsize > 0)
+		misaligned = true;
+
+	/* Complain if the verifier fails. */
+	bad = libxfs_inode_validate_cowextsize(mp, value,
+			be16_to_cpu(dino->di_mode), flags, flags2) != NULL;
+	if (bad || misaligned) {
+		do_warn(
+_("Bad CoW extent size hint %u on inode %" PRIu64 ", "),
+				be32_to_cpu(dino->di_cowextsize), lino);
+		if (!no_modify) {
+			do_warn(_("resetting to zero\n"));
+			dino->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
+			dino->di_cowextsize = 0;
+			*dirty = 1;
+		} else
+			do_warn(_("would reset to zero\n"));
+	}
+}
+
 /*
  * returns 0 if the inode is ok, 1 if the inode is corrupt
  * check_dups can be set to 1 *only* when called by the
@@ -3385,27 +3426,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 
 	validate_extsize(mp, dino, lino, dirty);
 
-	/*
-	 * Only (regular files and directories) with COWEXTSIZE flags
-	 * set can have extsize set.
-	 */
-	if (dino->di_version >= 3 &&
-	    libxfs_inode_validate_cowextsize(mp,
-			be32_to_cpu(dino->di_cowextsize),
-			be16_to_cpu(dino->di_mode),
-			be16_to_cpu(dino->di_flags),
-			be64_to_cpu(dino->di_flags2)) != NULL) {
-		do_warn(
-_("Bad CoW extent size %u on inode %" PRIu64 ", "),
-				be32_to_cpu(dino->di_cowextsize), lino);
-		if (!no_modify)  {
-			do_warn(_("resetting to zero\n"));
-			dino->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
-			dino->di_cowextsize = 0;
-			*dirty = 1;
-		} else
-			do_warn(_("would reset to zero\n"));
-	}
+	if (dino->di_version >= 3)
+		validate_cowextsize(mp, dino, lino, dirty);
 
 	/* nsec fields cannot be larger than 1 billion */
 	check_nsec("atime", lino, dino, &dino->di_atime, dirty);

