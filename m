Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B134A20
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883487; cv=none; b=H3cO4/5IVJXiymy8xXvNLPD/fCGFaWbbnzx9ASu00kCuRJHbM3uo3FINr5l7JchA9TDVUOtkXEyspzuC/yLJzRZE7hsKHNrcIha7YALlaU09NR8pec5AWksGPF8TlmRUwY5EVEzdVg2dcdMRgdEPSe1+7sJ6M3a4VYMdfQQlL6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883487; c=relaxed/simple;
	bh=IWaQ6s1bsyMx1LdyHb0OGt0a9OPrkdexjktNRpnkDfk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fzgXUbCJVXi8NyuPnrn/jJ5Br56ySlA5nnygQrVhstTpl7BKlnMOSKPTn41Cyc2S0nNvM2zUGuDuTy3MAt36ARTZlkhpdStuv9n4rHTowmwE5U3O4JtzZWMBgMNZFyyTQyFT5dcm3ZeYXpyxhlPZOjyCCtYSJl7P2JN12cnGQU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WeTNqKgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WeTNqKgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C76C116B1;
	Tue,  2 Jul 2024 01:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883486;
	bh=IWaQ6s1bsyMx1LdyHb0OGt0a9OPrkdexjktNRpnkDfk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WeTNqKgVWl9KFneo+TEKnPNWsqAF8EcArl2O0/gbwAU1sJbtUYq4oriJhjjIGmapP
	 YJunAf23muIWXzwZfvclex2dRvDd7MWmpAkJ4pGXJx6Xogw7QEXxMngq4E61OR89L9
	 +cGW4+8pOKfTV6hZQvT1qOF4Uc4LYjqaiy/KHYfIcakDw3SzBNzbkByIMIOctY2FYd
	 28ASWj9Br7YF54YFPuv6iNiNFc9sMoQZ7Rdch0+GgBediSwTzJ91bHJRUUgJ/+VWcV
	 4mYsjYyCxBZZgrnf2J2AIfglU+/ld9EQDMuPQgGeZwzRioj3HQMn2qKMN5jw023GzN
	 z5NDXBfcAmFXQ==
Date: Mon, 01 Jul 2024 18:24:46 -0700
Subject: [PATCH 1/1] xfs_repair: allow symlinks with short remote targets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988123600.2012930.8636977551669222212.stgit@frogsfrogsfrogs>
In-Reply-To: <171988123583.2012930.12584359346392356391.stgit@frogsfrogsfrogs>
References: <171988123583.2012930.12584359346392356391.stgit@frogsfrogsfrogs>
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

Symbolic links can have extended attributes.  If the attr fork consumes
enough space in the inode record, a shortform symlink can become a
remote symlink.  However, if we delete those extended attributes, the
target is not moved back into the inode core.

IOWs, we can end up with a symlink inode that looks like this:

core.magic = 0x494e
core.mode = 0120777
core.version = 3
core.format = 2 (extents)
core.nlinkv2 = 1
core.nextents = 1
core.size = 297
core.nblocks = 1
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
u3.bmx[0] = [startoff,startblock,blockcount,extentflag]
0:[0,12,1,0]

This is a symbolic link with a 297-byte target stored in a disk block,
which is to say this is a symlink with a remote target.  The forkoff is
0, which is to say that there's 512 - 176 == 336 bytes in the inode core
to store the data fork.

Prior to kernel commit 1eb70f54c445f, the kernel was ok with this
arrangement, but the change to symlink validation in that patch now
produces corruption errors on filesystems written by older kernels that
are not otherwise inconsistent.  Those changes were inspired by reports
of illegal memory accesses, which I think were a result of making data
fork access decisions based on symlink di_size and not on di_format.

Unfortunately, for a very long time xfs_repair has flagged these inodes
as being corrupt, even though the kernel has historically been willing
to read and write symlinks with these properties.  Resolve the conflict
by adjusting the xfs_repair corruption tests to allow extents format.
This change matches the kernel patch "xfs: allow symlinks with short
remote targets".

While we're at it, fix a lurking bad symlink fork access.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 168cbf484906..e36de9bf1a1b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1036,7 +1036,8 @@ process_symlink_extlist(
 	int			max_blocks;
 
 	if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp)) {
-		if (dino->di_format == XFS_DINODE_FMT_LOCAL)
+		if (dino->di_format == XFS_DINODE_FMT_LOCAL ||
+		    dino->di_format == XFS_DINODE_FMT_EXTENTS)
 			return 0;
 		do_warn(
 _("mismatch between format (%d) and size (%" PRId64 ") in symlink ino %" PRIu64 "\n"),
@@ -1368,7 +1369,7 @@ process_symlink(
 	 * get symlink contents into data area
 	 */
 	symlink = &data[0];
-	if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp))  {
+	if (dino->di_format == XFS_DINODE_FMT_LOCAL) {
 		/*
 		 * local symlink, just copy the symlink out of the
 		 * inode into the data area

