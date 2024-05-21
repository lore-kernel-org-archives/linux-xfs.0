Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C057F
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 01:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716253488; cv=none; b=AJvIRugBh1w4eoCy9UeVYCjN7l2gJvEoijWe20wbVlWgamz+FK9zZ9IgOtAtMKWtQl2CxT5OwaPYmgIDAVDddk5bPhL9hbhNWy4VJpMXFszmKButeu/Nkk5+Y9aa++C5u33gZhj5nmpNsuiCitpnh+cUo1DALX85I1HYuiY/5xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716253488; c=relaxed/simple;
	bh=ecoH7rU0bqAfjtH31fs/74xzMCIxLDoUG7HTpsLPix8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=r11d4e/AA5IDTXthITtCG+VhtvN22mc1nmKOfvTNCUdHa9Pl7yC2KhkvBUOnHTdnyUoIHCLEFBh8KCyvDTgb2Tab1Ujo3olFChr1y/Y6yNTRgFzQfBBXy+ggSjxHhmffUdvYzXWF4vvSHm5+uISm3o0YszTIWg7cFYxRXXoYP0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tQxhB25M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tQxhB25M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A04AC2BD10;
	Tue, 21 May 2024 01:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716253488;
	bh=ecoH7rU0bqAfjtH31fs/74xzMCIxLDoUG7HTpsLPix8=;
	h=Date:From:To:Cc:Subject:From;
	b=tQxhB25MxyzIx1tHURFNpYouR1sG8eFfpntBpRyYx3vSHHqcx/RHXbS4pJr/0rQs1
	 8qPjOh6cq26JTpnJlAR11M2bE/oZjN2Y4Bho4kUrJBBSjI6MgNV/THKqJpLkbjs2Up
	 vbZrGj6kgsyr9Mk8I4OvpDXc+xG9+GoEZg/LURYAy66JAAs5xKguf54VRr97x7dTJF
	 nyFJjhUvUT1jjrmf0NZnPGV6C7ggGcKBoszX/jGnhe9VkDiUv08c1HxLG5O2RTW/Nk
	 EHOAjMkbE5Cg+RwrGYxcjAvZQbSPexYV1dit9aAXiwCco1nDbMTBPfn3PLUXQGck1S
	 rOZ616NjGxf5g==
Date: Mon, 20 May 2024 18:04:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: allow symlinks with short remote targets
Message-ID: <20240521010447.GM25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

An internal user complained about log recovery failing on a symlink
("Bad dinode after recovery") with the following (excerpted) format:

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

Eventually, testing of generic/388 failed with the same inode corruption
message during inode recovery.  In writing a debugging patch to call
xfs_dinode_verify on dirty inode log items when we're committing
transactions, I observed that xfs/298 can reproduce the problem quite
quickly.

xfs/298 creates a symbolic link, adds some extended attributes, then
deletes them all.  The test failure occurs when the final removexattr
also deletes the attr fork because that does not convert the remote
symlink back into a shortform symlink.  That is how we trip this test.
The only reason why xfs/298 only triggers with the debug patch added is
that it deletes the symlink, so the final iflush shows the inode as
free.

I wrote a quick fstest to emulate the behavior of xfs/298, except that
it leaves the symlinks on the filesystem after inducing the "corrupt"
state.  Kernels going back at least as far as 4.18 have written out
symlink inodes in this manner and prior to 1eb70f54c445f they did not
object to reading them back in.

Because we've been writing out inodes this way for quite some time, the
only way to fix this is to relax the check for symbolic links.
Directories don't have this problem because di_size is bumped to
blocksize during the sf->data conversion.

Fixes: 1eb70f54c445f ("xfs: validate inode fork size against fork format")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 2305e64a4d5a9..88f4f2a1855ae 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -375,16 +375,27 @@ xfs_dinode_verify_fork(
 	 * For fork types that can contain local data, check that the fork
 	 * format matches the size of local data contained within the fork.
 	 *
+	 * A symlink with a small target can have a data fork can be in extents
+	 * format if xattrs were added (thus converting the data fork from
+	 * shortform to remote format) and then removed.
+	 *
 	 * For all types, check that when the size says the should be in extent
 	 * or btree format, the inode isn't claiming it is in local format.
 	 */
 	if (whichfork == XFS_DATA_FORK) {
-		if (S_ISDIR(mode) || S_ISLNK(mode)) {
+		if (S_ISDIR(mode)) {
 			if (be64_to_cpu(dip->di_size) <= fork_size &&
 			    fork_format != XFS_DINODE_FMT_LOCAL)
 				return __this_address;
 		}
 
+		if (S_ISLNK(mode)) {
+			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_EXTENTS &&
+			    fork_format != XFS_DINODE_FMT_LOCAL)
+				return __this_address;
+		}
+
 		if (be64_to_cpu(dip->di_size) > fork_size &&
 		    fork_format == XFS_DINODE_FMT_LOCAL)
 			return __this_address;
