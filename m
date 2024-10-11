Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7E38BE5
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609797; cv=none; b=idP7t5x+haeM3Q6Sn5NyohAHOaZuGV4/iIaWgvzFYhDmQOJfgXnNasmn+n33pumPoiQtHeJ4F/Xvx3HH46Gz1sJrr3AJsRl7YpNuiy5UeF3eEgDXtGO8zI18EnrUzwy98Pf7OjHyTOL+GHRadcufOe0E9DQEJTZVBfY34qeQmTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609797; c=relaxed/simple;
	bh=cv4KMYchLjMcfDngP7ArbWclVzXF7dK03L5Cwu3TvH0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nGbGaPX9G2L0oiTfwj9rEqpGzke3hz+JGs10zUGakzaJUKeF5JHB2rKfuXUL8+qnqRusYFpN27tzW+XHrJsutyPRw575wUBqdqk4ExuC2Ge/4e+R5s0JZaumt6+ui+UAzY22wQxCSkaYBCUS+HFXvxH8M7zCHzohON+QNqwEPUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ptSNrQhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ptSNrQhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAF3C4CEC5;
	Fri, 11 Oct 2024 01:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609796;
	bh=cv4KMYchLjMcfDngP7ArbWclVzXF7dK03L5Cwu3TvH0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ptSNrQhHrQVylpGDydRKmiQV2ccsEZUPU6dwcMPufPHnATbvj1E2HWL7tMjkih91I
	 LiseIOLozSDDm1L4iIr5vPQvaO1k4p5IBY2d/eqeDn4dsuLV/2tNBUVb/T9oAS/uON
	 gPy7xpgnaDWVAdizJVebjLDVMhubm+SD4FK60fmnrqnkHLUMkj1nvmutgnNRAyUGmn
	 TZbaBBPngwHf3MmyijXAO/EsL+HGF+IadZ2py9tToVh0gaA0qBvcSelwmpCsLdB1Gx
	 B8Shu4FBVmn+554aXYJW5rHYJnVGguqOCEwL4tlxqdP+pkrpDgkgt2WLnVzjBEIl4M
	 pTueIGld6DQIQ==
Date: Thu, 10 Oct 2024 18:23:16 -0700
Subject: [PATCH 35/38] xfs_repair: fix maximum file offset comparison
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654514.4183231.8423397755918144781.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

When running generic/525 with rtinherit=1 and rextsize=28k, generic/525
trips over the following block mapping:

data offset 2251799813685247 startblock 7 (0/7) count 1 flag 0
data offset 2251799813685248 startblock 8 (0/8) count 6 flag 1

with this error:

inode 155 - extent exceeds max offset - start 2251799813685248, count 6,
physical block 8

This is due to an incorrect check in xfs_repair, which tries to validate
that a block mapping cannot exceed what it thinks is the maximum file
offset.  Unfortunately, the check is wrong, because only br_startoff is
subject to the 2^52-1 limit -- not br_startoff + br_blockcount.

Nowadays libxfs provides a symbol XFS_MAX_FILEOFF for the maximum
allowable file block offset that can be mapped into a file.  Use this
instead of the open-coded logic in versions.c and correct all the other
checks.  Note that this problem only surfaced when rtgroups were enabled
because hch changed xfs_repair to use the same tree-based block state
data structure that we use for AGs when rtgroups are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c   |    2 +-
 repair/globals.c  |    1 -
 repair/globals.h  |    1 -
 repair/prefetch.c |    2 +-
 repair/versions.c |    7 +------
 5 files changed, 3 insertions(+), 10 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index fb234e259afd83..1d2d4ffa6d0e53 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -501,7 +501,7 @@ _("inode %" PRIu64 " - bad extent overflows - start %" PRIu64 ", "
 		}
 		/* Ensure this extent does not extend beyond the max offset */
 		if (irec.br_startoff + irec.br_blockcount - 1 >
-							fs_max_file_offset) {
+							XFS_MAX_FILEOFF) {
 			do_warn(
 _("inode %" PRIu64 " - extent exceeds max offset - start %" PRIu64 ", "
   "count %" PRIu64 ", physical block %" PRIu64 "\n"),
diff --git a/repair/globals.c b/repair/globals.c
index 07f7526a73a0b1..b63931be9fdb70 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -86,7 +86,6 @@ int		inodes_per_block;
 unsigned int	glob_agcount;
 int		chunks_pblock;	/* # of 64-ino chunks per allocation */
 int		max_symlink_blocks;
-int64_t		fs_max_file_offset;
 
 /* realtime info */
 
diff --git a/repair/globals.h b/repair/globals.h
index 7db710a266b3c7..1dc85ce7f8114c 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -127,7 +127,6 @@ extern int		inodes_per_block;
 extern unsigned int	glob_agcount;
 extern int		chunks_pblock;	/* # of 64-ino chunks per allocation */
 extern int		max_symlink_blocks;
-extern int64_t		fs_max_file_offset;
 
 /* realtime info */
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 998797e3696bac..27ef15708aa0ea 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -185,7 +185,7 @@ pf_read_bmbt_reclist(
 
 		if (((i > 0) && (op + cp > irec.br_startoff)) ||
 				(irec.br_blockcount == 0) ||
-				(irec.br_startoff >= fs_max_file_offset))
+				(irec.br_startoff + irec.br_blockcount - 1 >= XFS_MAX_FILEOFF))
 			goto out_free;
 
 		if (!libxfs_verify_fsbno(mp, irec.br_startblock) ||
diff --git a/repair/versions.c b/repair/versions.c
index b24965b263a183..7dc91b4597eece 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -180,10 +180,5 @@ _("WARNING: you have a V1 inode filesystem. It would be converted to a\n"
 		fs_ino_alignment = mp->m_sb.sb_inoalignmt;
 	}
 
-	/*
-	 * calculate maximum file offset for this geometry
-	 */
-	fs_max_file_offset = 0x7fffffffffffffffLL >> mp->m_sb.sb_blocklog;
-
-	return(0);
+	return 0;
 }

