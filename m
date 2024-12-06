Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756AC1F3D3D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528989; cv=none; b=ti8z0tabkF+v1W5f2AhdyvgRAAUfz9ItMMNkZQe8sqqcJTsh1aijLbTVh/u1fZoEBS0qVzqzR7R+5g9iD7p3Jic8HJu8raop00XTeGmFhnenwHOb1hYh0wwZm5w0p8i86wqBwVASlQq44CgW0DfIvmhuECvvha8lqMMAZf9aeIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528989; c=relaxed/simple;
	bh=T9KdIyuU/UDlpNtrjnBoaKFWCnhtZUwmc9jl+qkKgy8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xx6gJ68ZjD/firzFOecIN2D9QG9iPOLrHBQeYoeIGboLutVKIEXfChBC4yuX6GzxsedJczMt9QUUUWZYG+Gu6CIvAXB+t7FRwD+0n9k8aDnd3bTl5dN1sA7UvRAhlRAJMoOSHkja2Sqr1+DVv92nWHWMNE7pAf7qAqkHWB1W8/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enGyWsLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enGyWsLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFE0C4CED1;
	Fri,  6 Dec 2024 23:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528989;
	bh=T9KdIyuU/UDlpNtrjnBoaKFWCnhtZUwmc9jl+qkKgy8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=enGyWsLB9ICdJCKWBBV+Ibwt/zoxhzGjX7oHgWPBU3naxN6FCPgKGWpwjuTJIYIQB
	 l0k36KIiV3m2Yd0TR7e5IhApqqwGYBnuSWdkXHtiW3fsBqDeqd/LOR7wWuIOly7W7k
	 WJwpiH3KUX44BEycqEKzmt2UtKzA37/oQ0DLie431Lqp89uRBEAi1fyVnKwHUQ/D1e
	 3an5AeWhnF7+nuSehJ1PWO7dOkqE3u0o7NoP7Xtpk4Nj0dA4H2jBKAh23LzFz91S76
	 +K+ikjaSWVecuXlqIbj1WoIThu3Vns1rsRjBxLurpyghczCWbcrDF3xyQEnrxeWSbB
	 g6kEeZBKqp+Gg==
Date: Fri, 06 Dec 2024 15:49:48 -0800
Subject: [PATCH 39/41] xfs_repair: fix maximum file offset comparison
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748828.122992.13639585878604982942.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c   |    2 +-
 repair/globals.c  |    1 -
 repair/globals.h  |    1 -
 repair/prefetch.c |    2 +-
 repair/versions.c |    7 +------
 5 files changed, 3 insertions(+), 10 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 9fea0cedd71cfe..2185214ac41bdf 100644
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
index 0772ecef9d73eb..5ecf19ae9cb111 100644
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

