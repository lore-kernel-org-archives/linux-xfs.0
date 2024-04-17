Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E17171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390363; cv=none; b=O3HDC4unNDSpqf8fIbF23eiuxpvgRA5Kuu9pLwj7fpIKHvKArpZfbFY7bHMsezJaanVrEO+y5I8tN3sNg3XZU31k/3HQp0u3xzVUix+SOC4YtP6ndAIrtLd8B+6d/iOwWMl9IpZH/GZ03N+rEFU9aQljb0tEv3ygU3DP1DTJq+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390363; c=relaxed/simple;
	bh=kgQr2r+IJ/XTgqyQXWOV4eNjZOZ0OLoL/pNAG+SoVQA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nNYiVHeX2ZvfOIIB+0QuI69LalShXEJS3wXhldKGnLcNIi4Ge9FZRcq6vhW8r1YQQL7hr8ezRGrsZdoJfJkFQYMSCMv3RK+qIkGUXVfSqVMPJ/nxuN+jFj3BBOjqG3ycLvY02ryxTEUOF406d6h7eeDkxZdziZwl0nCOnN241Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fl8joxcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fl8joxcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D284C072AA;
	Wed, 17 Apr 2024 21:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390363;
	bh=kgQr2r+IJ/XTgqyQXWOV4eNjZOZ0OLoL/pNAG+SoVQA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fl8joxcwqHkhF24mHwaY0GFMJFjy05e28AxgP+nAMXvzgwe6mmHzbRSBkl/QvAcSQ
	 N70RFymlnu5nE5478bFnU/lOQBgb1rEBmg3kfMJX4Wxl1oAgxhbtD6KuzyFwMzME1A
	 ULbs3/88FzfQkC8T3jeloyeYANAxwH4FtxMNxb84YQyXNM1Xy5GVEK2g2OWYQzdMgX
	 pG90Ca1+t2cJAhV5/6VEC+O5cKfe5dLiRU+AvHr1tt7mdseEFpao23CIr5kbSFxR/e
	 VFoEYydaQwNwjgGKNISKJgqvwDdm8mo681L0PXk37pS/+0kIqnsbXaf4rzJ2H7bfMu
	 +VgEDuqWjBlTQ==
Date: Wed, 17 Apr 2024 14:46:02 -0700
Subject: [PATCH 6/8] xfs_repair: constrain attr fork extent count
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171338845870.1856674.1799595037972812764.stgit@frogsfrogsfrogs>
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

Don't let the attr fork extent count exceed the maximum possible value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index b8f5bf4e5..bf93a5790 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2050,6 +2050,7 @@ process_inode_attr_fork(
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	struct xfs_dinode	*dino = *dinop;
 	struct blkmap		*ablkmap = NULL;
+	xfs_extnum_t		max_nex;
 	int			repair = 0;
 	int			err;
 	int			try_rebuild = -1; /* don't know yet */
@@ -2071,6 +2072,11 @@ process_inode_attr_fork(
 	}
 
 	*anextents = xfs_dfork_attr_extents(dino);
+	max_nex = xfs_iext_max_nextents(
+			xfs_dinode_has_large_extent_counts(dino),
+			XFS_ATTR_FORK);
+	if (*anextents > max_nex)
+		*anextents = 1;
 	if (*anextents > be64_to_cpu(dino->di_nblocks))
 		*anextents = 1;
 

