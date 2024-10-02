Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593B423C9
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832363; cv=none; b=rmuoROIO4wkjtT/W7133YTvRvUlVX64tYUUzbh0Adx+HlUDhwGJJtIYMx/3lH6hKcQo4t1imGhuBnbCf/AthJikbMbVqXDu4rfvgOEDvtRec4OKo05WQc7EShJC5jEhchh1RwX3n729jW7xNQM5MBakmw2V6eC1EvwmTiYu4qoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832363; c=relaxed/simple;
	bh=/bp81eubvwMBcqI77DR7gz0drQpA6kizO6EB0s8vSLY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HDzYynQLdWtRw6w8n6XysxLHbIEIK04EIBqnv1nI9MnECle68FFAY2u2LoksQYWKSFrZHobSBDCx+80qUdZBYVWlj84cj+3Dc/1Ocm8mVJojmGNDdj/UyWuPMQ/k20e5UJUZwFKU2ev2ij7K6HdiEoxiW/NBbWwl6ZvSsJpB/0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pGb18LJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pGb18LJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300BFC4CEC6;
	Wed,  2 Oct 2024 01:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832363;
	bh=/bp81eubvwMBcqI77DR7gz0drQpA6kizO6EB0s8vSLY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pGb18LJFEonodMUnhRqJE2ueQ0v5goqGDlEmA3kkgbktNlOZv3zCTv6KIGkfoJlrA
	 H2Bnng62En3mTXk5O+jG1g3d+KUim1le7wWFp2LvrsMQVREsonym+OvRXrT6fB/0e6
	 9NovSxlA8QnQ/rDXPnnXQ2Xq+heaabZT7fnF9rDlCs7MNTTPwM6aKLTj0BviUSpNwX
	 pBnDFvhMiYOXJa+gS48SKzFyJXjH3BTPZPEEkr2jbG6OPx5R/nzKPmNl4vk+XdwCfI
	 6J+Mcktl8aG9dDJp+k7UzrMxaoCj2MzJz8hhSdMFkgwaQPfOer6lkbI/Miwb605MXc
	 W48XyeCpwzn5w==
Date: Tue, 01 Oct 2024 18:26:02 -0700
Subject: [PATCH 2/4] xfs_repair: don't crash in get_inode_parent
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103408.4038674.5358388719134964046.stgit@frogsfrogsfrogs>
In-Reply-To: <172783103374.4038674.1366196250873191221.stgit@frogsfrogsfrogs>
References: <172783103374.4038674.1366196250873191221.stgit@frogsfrogsfrogs>
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

The xfs_repair fuzz test suite encountered a crash in xfs_repair.  In
the fuzzed filesystem, inode 8388736 is a single-block directory where
the one dir data block has been trashed.  This inode maps to agno 1
agino 128, and all other inodes in that inode chunk are regular files.
Output is as follows:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
Metadata corruption detected at 0x565335fbd534, xfs_dir3_block block 0x4ebc78/0x1000
corrupt directory block 0 for inode 8388736
no . entry for directory 8388736
no .. entry for directory 8388736
problem with directory contents in inode 8388736
would have cleared inode 8388736
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
entry "S_IFDIR.FMT_BLOCK" at block 0 offset 1728 in directory inode 128 references free inode 8388736
        would clear inode number in entry at offset 1728...
        - agno = 1
entry "." at block 0 offset 64 in directory inode 8388736 references free inode 8388736
imap claims in-use inode 8388736 is free, would correct imap
        - agno = 2
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
./common/xfs: line 387: 84940 Segmentation fault      (core dumped) $XFS_REPAIR_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV

From the coredump, we crashed in get_inode_parent here because ptbl is a
NULL pointer:

	if (ptbl->pmask & (1ULL << offset))  {

Directory inode 8388736 doesn't have a dotdot entry and phase 3 decides
to clear that inode, so it never calls set_inode_parent for 8388736.
Because the rest of the inodes in the chunk are regular files, phase 3
never calls set_inode_parent on the corresponding irec.  As a result,
neither irec->ino_un.plist nor irec->ino_un.ex_data->parents are ever
set to a parents array.

When phase 6 calls get_inode_parent to check the S_IFDIR.FMT_BLOCK
dirent from the root directory to inode 8388736, it sets ptbl to
irec->ino_un.ex_data->parents (which is still NULL) and walks off the
NULL pointer.

Because get_inode_parent already has the behavior that it can return
zero for "unknown parent", the correction is simple: check ptbl before
dereferencing it.  git blame says this code has been in xfsprogs since
the beginning of git, so I won't bother with a fixes tag.

Found by fuzzing bhdr.hdr.bno = zeroes in xfs/386.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/incore_ino.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 6618e534a..158e9b498 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -714,7 +714,7 @@ get_inode_parent(ino_tree_node_t *irec, int offset)
 	else
 		ptbl = irec->ino_un.plist;
 
-	if (ptbl->pmask & (1ULL << offset))  {
+	if (ptbl && (ptbl->pmask & (1ULL << offset)))  {
 		bitmask = 1ULL;
 		target = 0;
 

