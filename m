Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E9FA23
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303176; cv=none; b=qL3mfjVqmz2esCBCmzC0ArfqNyIjuPCDPQzdUQorOWaFzZmh7RqsFHlcblWOLq89ZDctdxrr39E/l3ROGhILwL50mqENaWML78T3n+Lcgf/bb6AqPKDwfcAWRM+IhyPFFMUc1LwafSYYUXAOgkpp9N0b7GYxx2jrq13G2ZQtCo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303176; c=relaxed/simple;
	bh=zBdsC7Y+qCmLELZ+tymfYnV4Q4MhH5YHwgLUkwXzH/k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BJ4qsXlvc0dskNJoFCrFjschDYKn6qpqG+X1pU7yyv5QbbIaL8kWNkOgUhS+GqE6AEq3kPrz65Uo35KHn3/O/NJgZBFcabfGnl7I5Z0MpH5SJsy/fxhJX4/8xzZtVkrCX8jEkwqbr5nwgQXDEhl+3YZZRLVzCq5XxuNmnkO8858=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tu3eurJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tu3eurJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B1AC32786;
	Tue, 30 Jul 2024 01:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722303176;
	bh=zBdsC7Y+qCmLELZ+tymfYnV4Q4MhH5YHwgLUkwXzH/k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tu3eurJmJlgBJGP3prPv/WUHJdpKWpX7USuETebbT5L91A6bSyKsvmFFPgyFHhheq
	 F/2mrm0p9Rt4gutpvN5zmolEnEebJAk8CZKgnUWuKUSfkiI2+lBku6EB+gkCYaprN4
	 nbcW+myoBzH+x921rVk62cUJ2+SYdTY7T60PWM7qcLKzC43sByQfsDeLRY9rqIYeUw
	 Q3s8iAs3K7jw7sM7ksrx4PoYRp5Wg9A9sIx3SYGOdPFBQqizDkZ7hn8rLeememMMn6
	 TDlCKXLnYgWu7iopNl60Sm3Tg7xI9O1bykPK8WKkBSMPyzfkAJGuF+MIRC+2BZqhha
	 EuDA14AnJlS2A==
Date: Mon, 29 Jul 2024 18:32:56 -0700
Subject: [PATCH 1/1] xfs_repair: allow symlinks with short remote targets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229852814.1353623.14141518085672776332.stgit@frogsfrogsfrogs>
In-Reply-To: <172229852800.1353623.6368136045506828951.stgit@frogsfrogsfrogs>
References: <172229852800.1353623.6368136045506828951.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 168cbf484..e36de9bf1 100644
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

