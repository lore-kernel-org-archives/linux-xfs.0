Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A561B299
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716307593; cv=none; b=NoTNIQuX9p0pufc1yhm3qCh9hFgH0YkQDUZzMFGDS/1q3gxLioU+fvxp3LgIdhPXZD9iWkjLVQMMCvkC8YOVOyvonM75IpoFgOXNtpm/MndZerSIXsZX38cvn/FXcXJBf0C3WdB8pAVQmL1f90j7RnD/LnyTblTsdjQYT86Wqck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716307593; c=relaxed/simple;
	bh=+NLhcv7MupuBKPgvTGhoScbzu57ISUrbZVj4yxqPH4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r0f/bWjnSGNH7z5Jeq4N9VlGsncT+N+hk9R17QyubvmTWtRgsgisz/w4IV2Enf4/ikvofBYS9K+6UNgzsD4QVzWctTir/E/UtDfCPUSsftoDGQsGOaouOwrELJeBwzPzaO3HSoP1hT2nsEFfN2UllEinSr76goSoR1dD5NTSpVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LzbuOkK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzbuOkK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBC3C2BD11;
	Tue, 21 May 2024 16:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716307592;
	bh=+NLhcv7MupuBKPgvTGhoScbzu57ISUrbZVj4yxqPH4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LzbuOkK7mxTVQ3H2/SS5HfAmTWJP0PNGO+1GIQBHcMysb0pWSFY1vUfVuLM+2NVVn
	 pqxmTiBixCRRLJvenfMrtgWvRLR0kOaD8+Af2aSHcHyFmMhud3yVfkfDDObF0Q5JBo
	 x19o/64j6Pwuf6WUoYg/HW2+mie8CDfQ9BdSO9V9hHCQWpXyxM1NL+fHvYrW/JxnvN
	 Y3sQLNmrJdFlSWoM/uAuylf9Fp8B0+valykZ2gn/nTEIucHCGq8NmO7ZOt40jIaOY9
	 3mxdtppy5Bw2Ak+OmXix3Ew4mWAXZFOUGDVlP1O35/9IikZSGBUUSubBpeAW6TpLQm
	 GJhN1KOUpdQHA==
Date: Tue, 21 May 2024 09:06:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] xfs: allow symlinks with short remote targets
Message-ID: <20240521160631.GS25518@frogsfrogsfrogs>
References: <20240521010447.GM25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521010447.GM25518@frogsfrogsfrogs>

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
v2: relocate comments, fix borken sentence
---
 fs/xfs/libxfs/xfs_inode_buf.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 2305e64a4d5a9..9caf9aa2221d3 100644
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
