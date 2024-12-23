Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34818161328
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989797; cv=none; b=aGFHCxvrwfyGiIfpvSlSRuWnGJQ+SGHaoCzRaBgu1peu1pnmm8j8eGaTK7KWLgU0izdgu5aMyG9m3pVSIO8odIoFl40rGFlTgrZWxoOa1DVxiAgPX4tztgmnWd3pVDWiYXFAMJswzwza1jiZyhwZTD4fZWID8nNTodrp1fDrOPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989797; c=relaxed/simple;
	bh=Lor96sr8a7W4fml9/CVYkyXthMkAIJuyZ/GFA/TNVe8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LaKxiW/tDQ0kqwdRjN/8Zd9YXzqihmxInDojk1fZ63voMQDZFruo9DGJj9dl/kGEhqNlcRgLDoYjoFYoM9kOOY3Fn8PE2m3LbBC7hGgBa2GZuFvuTGLYJJMJMtij5Zj/5JT8yeWIrh4u7AJbIkRns+oyEz8wD3LKuxiB2PyzMVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M72rL+UA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M72rL+UA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C59C4CED3;
	Mon, 23 Dec 2024 21:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989796;
	bh=Lor96sr8a7W4fml9/CVYkyXthMkAIJuyZ/GFA/TNVe8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M72rL+UAbhTmETqxkCZpnmMUeEBLsvPctPMWSPGOckyJquwfSPSl3M+qbdmqohNRW
	 XuiaXbCSBDQ1KPVQVFxoPfPL6eB9U93/DcZE8WlpuG1Imm+OZFXWublUQqAKVgqwZZ
	 9atR3x9bhs/TzGrwZUQ0V6UaiRjRJiYjBbv6RYtO2ohmBuD7J8cVKl+miNF7pG3u4P
	 nK8DlvRwf9XcOIzWSft5ZKGBQwARxwMDjk7smOs13ijF48ooZzw5TxOUK3xtjr6J6L
	 U4BlDnfYN5f3rW1UaV+2dUbNW8FRbUVwuQTQj+OFHd66Uxb2QfuOY0CTzdxqu/c+bA
	 rwGM9ObIQ7vLA==
Date: Mon, 23 Dec 2024 13:36:36 -0800
Subject: [PATCH 1/3] xfs_repair: fix maximum file offset comparison
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498939497.2292884.2235886667157405986.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939477.2292884.7220593538958401281.stgit@frogsfrogsfrogs>
References: <173498939477.2292884.7220593538958401281.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c   |    2 +-
 repair/globals.c  |    1 -
 repair/globals.h  |    1 -
 repair/prefetch.c |    2 +-
 repair/versions.c |    7 +------
 5 files changed, 3 insertions(+), 10 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index ac81c487a20b8a..2c9d9acfa10be5 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -491,7 +491,7 @@ _("inode %" PRIu64 " - bad extent overflows - start %" PRIu64 ", "
 		}
 		/* Ensure this extent does not extend beyond the max offset */
 		if (irec.br_startoff + irec.br_blockcount - 1 >
-							fs_max_file_offset) {
+							XFS_MAX_FILEOFF) {
 			do_warn(
 _("inode %" PRIu64 " - extent exceeds max offset - start %" PRIu64 ", "
   "count %" PRIu64 ", physical block %" PRIu64 "\n"),
diff --git a/repair/globals.c b/repair/globals.c
index c0c45df51d562a..7388090a7d39f3 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -83,7 +83,6 @@ int		inodes_per_block;
 unsigned int	glob_agcount;
 int		chunks_pblock;	/* # of 64-ino chunks per allocation */
 int		max_symlink_blocks;
-int64_t		fs_max_file_offset;
 
 /* realtime info */
 
diff --git a/repair/globals.h b/repair/globals.h
index 1eadfdbf9ae4f2..fa53502f98bbcd 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -124,7 +124,6 @@ extern int		inodes_per_block;
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

