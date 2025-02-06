Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D14D2417C0
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882905; cv=none; b=RCUozITvH0TnD5L0FxwEhFKUAjUgHq4+2sjwYE61Mr44kKuQgZ+eiYlZLHyfEH/p2I7JLc7VDbyqljxsoJg+pnp8JyQGUQWQdIN7QzagviNpX0HNl2N8gmic5+1Ec2NA+uQXr/UpPfv5qQO64NxywO4yHji9f0F2RDITNaOnPNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882905; c=relaxed/simple;
	bh=8Othlc5lyJEG45HMs44TN1mOoNSy2Z4RXAVK6Ys9cdM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dhmeufdsKwizd45GvE3hoNy1SDiBCkVGwSJAQyKeoGrEU2znE1DzjNjpHPREnY0NRbogBwV3iIoePCtBlAhxvtpPCHIubxOqg+0DwlT1WZZjp7IC3n1+eLnEOH9f2UD6Luc/6+oqlcfI4P8tmEt9xetx8KL7G07zRoaNF55jmGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJq8M1DC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJq8M1DC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1259C4CEDD;
	Thu,  6 Feb 2025 23:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882903;
	bh=8Othlc5lyJEG45HMs44TN1mOoNSy2Z4RXAVK6Ys9cdM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QJq8M1DCyifX2Hitl2aWUSg6VUchfL64XP1Jd3dVzxIXbN3LvT2FWnkUZGOieozZa
	 Qp7MgEbhQvMGQfpdMP16ZgTUST6KuZWgK7xssph5tkN39UkeP3c3RpHhgdvmjTe2W0
	 Aj/hb+wPQA2Izu/RUyooElo0D0ZrVV/5f+bgEFN9NJfkslhUvQOcow62KQJuW4ZRtD
	 SCM2J5FtDtGVct+XLePhfMzsCREyzoBleSkKkT+vORxoAiEj7LX3e/H0k1OaavXvlC
	 0cM/KUd2X3IgYDbRzv0oyNqppbTWv3o8CJBNEfiWduYScEQXUSJci4d2e+QfjX9OSx
	 0DJI1CdH7rI9Q==
Date: Thu, 06 Feb 2025 15:01:43 -0800
Subject: [PATCH 19/22] xfs_repair: validate CoW extent size hint on rtinherit
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089222.2741962.6290838942184793559.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c |   64 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 21 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 5a1c8e8cb3ec11..8696a838087f1b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2961,6 +2961,47 @@ should_have_metadir_iflag(
 	return false;
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
@@ -3544,27 +3585,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 
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

