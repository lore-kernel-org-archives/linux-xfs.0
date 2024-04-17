Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02896171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390379; cv=none; b=CrxJYO0CzN9WzCYzQhdnhLohiNIz0ToGcrbroQFybNESW1AF1TzV0OlL7vDMWkFhuyIXQ2D53V3aLrI4fKMeakeppO7BrRx6ohEj2kvHWgEVm+192zzmzCR+QpkIM6p/n9Pa7NDtAtSjRP5ZwXCVd21bZJ6o7d7ggCV5SmFwJvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390379; c=relaxed/simple;
	bh=nB73d/Rr7EyyWmy/GdhjOAfKf3ihw3Q4eAXZbo19YBk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gYaSNWWk3uDS/lLtleBdRfSBV4KfyFU3+bgcorZF2B0iOfXvAgs6glWNrP+oU91ibqXOAwAWNNxkKyLHtFMpRK1PIcwqbAXxMZPpuCWxOKzPkwfJwYx/JLXTZ1Z33T4cKiUu8XkVsBB/QVWJcH84RENB4jt7rNW3X4jrZp7iCqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fh21mqwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fh21mqwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA944C072AA;
	Wed, 17 Apr 2024 21:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390378;
	bh=nB73d/Rr7EyyWmy/GdhjOAfKf3ihw3Q4eAXZbo19YBk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fh21mqwoi3+j3F8ZF27OekqCpEzf9rBxUtr3J7V1DF61CdxeirP/Bue0Uu0eSxeM1
	 Fv+3GkFVI8p/uyoLUyRGCmY2jAblYyuanwUV3EAhAcXgYiiZZtKImHKz3EWD6hA3Si
	 1vXA944uXNRMNx9p+uYrG6Vm0js+y6OeZyQ1jK5sp41zCWPx6RGMdj3r7R5SV7qAdt
	 Folp7jakQKJrg64rlaAig8mreF574Kcu9KXYKoaNA6+3kyKWFATXXfleCEGgWKfSLJ
	 vsdMgNIxPMWGbNIUPDxYRKbeZbchhbrhun5En2ZY2qjUWvABwH5EUI9cnzirJDyJ6A
	 J9hszSYVBF4lg==
Date: Wed, 17 Apr 2024 14:46:18 -0700
Subject: [PATCH 7/8] xfs_repair: don't create block maps for data files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171338845885.1856674.12758541407573493199.stgit@frogsfrogsfrogs>
In-Reply-To: <171338845773.1856674.2763970395218819820.stgit@frogsfrogsfrogs>
References: <171338845773.1856674.2763970395218819820.stgit@frogsfrogsfrogs>
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

Repair only queries inode block maps for inode forks that map filesystem
metadata.  IOWs, it only uses it for directories, quota files, symlinks,
and realtime space metadata.  It doesn't use it for regular files or
realtime files, so exclude its use for these files to reduce processing
times for heavily fragmented regular files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index bf93a5790..94f5fdcb4 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1930,8 +1930,14 @@ process_inode_data_fork(
 	if (*nextents > be64_to_cpu(dino->di_nblocks))
 		*nextents = 1;
 
-
-	if (dino->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
+	/*
+	 * Repair doesn't care about the block maps for regular file data
+	 * because it never tries to read data blocks.  Only spend time on
+	 * constructing a block map for directories, quota files, symlinks,
+	 * and realtime space metadata.
+	 */
+	if (dino->di_format != XFS_DINODE_FMT_LOCAL &&
+	    (type != XR_INO_RTDATA && type != XR_INO_DATA))
 		*dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);
 	*nextents = 0;
 

