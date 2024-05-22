Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAAB1C6B4
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 06:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716357738; cv=none; b=HFCuzJZzTIOwRbjnKx1kWWX8HfWul/QBskKES9QpgiTDvwbrxUN3HbYcJjb0aVc7PE3B8DXl87Mru1T5gRsGfTM6ItA+9O1evtddF7pUzLB9Tyd0yCWKTTNx8DqLA8uCGPfilnVQ7GZjIqnJ98jsG3EISVq4T53FA4bESqabWCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716357738; c=relaxed/simple;
	bh=2t+w6r9L+RBAjIqAG5fVT1On6eMsHHgbG5Wr35+Qq/s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a/gHgZCcslr/956Gc3Mz9YKY33FFj2tk2KoVhgwyCJsbv1hE1/5f4mJ1GBaWL1+5DKgulJEGNYijCKhG+dLcX45Y8sYszJ9QMgYe7brr61bErgNSBGIlRlpyTYa2+anGlZ3camnA0c9xci8fsHzEICxcTKfJ14gx6lg+Eykl4tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etNW1Ca4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etNW1Ca4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F268C2BD11;
	Wed, 22 May 2024 06:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716357737;
	bh=2t+w6r9L+RBAjIqAG5fVT1On6eMsHHgbG5Wr35+Qq/s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=etNW1Ca4np2RNWrqdmW3Y2iF9HabDiUVZyxoLUBwYBwAWKrrEuO9YIubYs+4AnTED
	 P9ST2I/2an598XjXMuv5GhvIBNGMaEjHzSp+f/iUaDjnX/rYQd5VAgDu8bmmP5ou1Y
	 mliN+OHbh0WAemfzGtSe3k4xGB1+1XmVHnLJNWqKwMB0HaJxQ4SG2077UARjyhzqjs
	 05KKHH8Aq/VPGbo9ELq2dhYf1OeuLq3MN1Z71G7VRQsH+LPqh3/pF8KPiTlBplW3x2
	 /j4tvDde4w5rqIH5kVCc2xzKDZfOD713by4BkprO9nZA0bnQDb+5AqW4M84xz9C56F
	 hj7RybuUPsA2A==
Date: Tue, 21 May 2024 23:02:16 -0700
Subject: [PATCH 3/4] xfs: allow symlinks with short remote targets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171635763423.2619960.122476714020756620.stgit@frogsfrogsfrogs>
In-Reply-To: <171635763360.2619960.2969937208358016010.stgit@frogsfrogsfrogs>
References: <171635763360.2619960.2969937208358016010.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d79002343d0b..e7a7bfbe75b4 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -374,17 +374,37 @@ xfs_dinode_verify_fork(
 	/*
 	 * For fork types that can contain local data, check that the fork
 	 * format matches the size of local data contained within the fork.
-	 *
-	 * For all types, check that when the size says the should be in extent
-	 * or btree format, the inode isn't claiming it is in local format.
 	 */
 	if (whichfork == XFS_DATA_FORK) {
-		if (S_ISDIR(mode) || S_ISLNK(mode)) {
+		/*
+		 * A directory small enough to fit in the inode must be stored
+		 * in local format.  The directory sf <-> extents conversion
+		 * code updates the directory size accordingly.
+		 */
+		if (S_ISDIR(mode)) {
 			if (be64_to_cpu(dip->di_size) <= fork_size &&
 			    fork_format != XFS_DINODE_FMT_LOCAL)
 				return __this_address;
 		}
 
+		/*
+		 * A symlink with a target small enough to fit in the inode can
+		 * be stored in extents format if xattrs were added (thus
+		 * converting the data fork from shortform to remote format)
+		 * and then removed.
+		 */
+		if (S_ISLNK(mode)) {
+			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_EXTENTS &&
+			    fork_format != XFS_DINODE_FMT_LOCAL)
+				return __this_address;
+		}
+
+		/*
+		 * For all types, check that when the size says the fork should
+		 * be in extent or btree format, the inode isn't claiming to be
+		 * in local format.
+		 */
 		if (be64_to_cpu(dip->di_size) > fork_size &&
 		    fork_format == XFS_DINODE_FMT_LOCAL)
 			return __this_address;

