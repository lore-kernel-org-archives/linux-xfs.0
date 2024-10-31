Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4537C1CF29C
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416810; cv=none; b=b+wUA+LNMVH3b9x6sz7mzIZmxo/ZcDB4nuamrI8o28wXkWjvTZp82JKX9Mwgu+xkXKxtqWKEhrBUTNDRWHd2hVWRRYG2oTRqrMB4Kd8Qiy00bJ1kBzZR9OFbkWIOZ4sdk/jlHYukFhbimTjKgqqysl4YUQ1DNtLIUnumlhUx8Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416810; c=relaxed/simple;
	bh=Tafz5opgBwt8wSSVY3T1qgX0rq3DMyJ2ZMoMUZz3cZ8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c1n3s1oHPBLwOU5ntclBkgOR6aREn/WJZsP41JkQ6nIw1aFvCVG8E+PVCibxcogR5stL+A7Ea7XN5H0b/DpzKUj7rghoM02DfsMOkyTfYiQp0WfEu7CbrpVqDwNdIZNdiYOsEyGJva9gS87BMVZiqlXi+Nc6JymZ6LfRWeKw0E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r0a8GUJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r0a8GUJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22950C4CEC3;
	Thu, 31 Oct 2024 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416810;
	bh=Tafz5opgBwt8wSSVY3T1qgX0rq3DMyJ2ZMoMUZz3cZ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r0a8GUJ4V2QMqAtTp8z9dHLqzIe45sYupQ0l2LAdZeuKBo5IRpOMxvXL+7FbhF+d7
	 EupElYeWGRFvUstn8bIYK7hMQvZdVyTvltaRw+wemcE6d1IaPFMbPtxnLZTOwAj2kG
	 pCaECtb+t9w4WU7SNsRuoRkick58PTi1iT7xV7DTHXhgAi4hwpPRabHkT49DpP7nV9
	 Zurfpecv/TApGy6ntz8tFLhjCRPZv7yvSFsb+R/jLeQCu2aRoeDU9IGl8Q5q+y4rhm
	 Rjri0TA7FvS4thM7tQroTmSmf8NLGd6ZdA1q83IHiiXOYcpS5juCPnFEQ14yRUPXeW
	 c0djPmVK3HpJw==
Date: Thu, 31 Oct 2024 16:20:09 -0700
Subject: [PATCH 3/7] libxfs: remove unused xfs_inode fields
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566952.963918.16788605025792856310.stgit@frogsfrogsfrogs>
In-Reply-To: <173041566899.963918.1566223803606797457.stgit@frogsfrogsfrogs>
References: <173041566899.963918.1566223803606797457.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove these unused fields; on the author's system this reduces the
struct size from 560 bytes to 448.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h |    4 ----
 1 file changed, 4 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 170cc5288d3645..f250102ff19d65 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -215,7 +215,6 @@ typedef struct xfs_inode {
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
-	struct xfs_buftarg	i_dev;		/* dev for this inode */
 	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
 	struct xfs_ifork	i_df;		/* data fork */
 	struct xfs_ifork	i_af;		/* attribute fork */
@@ -239,9 +238,6 @@ typedef struct xfs_inode {
 	xfs_agino_t		i_next_unlinked;
 	xfs_agino_t		i_prev_unlinked;
 
-	xfs_extnum_t		i_cnextents;	/* # of extents in cow fork */
-	unsigned int		i_cformat;	/* format of cow fork */
-
 	xfs_fsize_t		i_size;		/* in-memory size */
 	struct inode		i_vnode;
 } xfs_inode_t;

