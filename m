Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B4913FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688176; cv=none; b=Gtn8N0/g+0ow8Kh7VbSwCPCukMn3vPtgjsWyTvNGsN+nCiFR1nNMuLWIMJK30PP2Uvuzea2JLHJAyVNoGMNIf2nt9K9N4EP6oLx9hi0DrRHHjk2Dr017QkohI2lViSYqCKtOHDUmRbFCPSTOBtgT/sq98eaP28T/6lPwFesv9ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688176; c=relaxed/simple;
	bh=Gx3P87NrAeSx9kAapYNWQ4nZAvn8AshBTgeMzedYHsQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IKHv1abz8OD6KwpOQj+iQCmntgOtTD/uPvV30rg0SxRB0W4w300NJT+2ToejrQmHitWdviVfkmGI2D1oQZc8KCr4wYaCDxMzF93ZSQ4pCv9AvyIETDoOOH5bV22UvPEJ5fG/cb9nuYun+rmr2SVbThXjcI1cRg6Z+nbdNuc4MkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cjczCLcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cjczCLcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192DFC4CED2;
	Tue, 31 Dec 2024 23:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688175;
	bh=Gx3P87NrAeSx9kAapYNWQ4nZAvn8AshBTgeMzedYHsQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cjczCLcmB05GtwH+kRrIEIF1nzMQbocfqiYhnPxqw6m8yT/hfjaH+EvDqd5bFcv6l
	 V861qpGuUmV1YlqKX5LE8snL64cpruIVi84oqfG5vVnuP1kXC/SJMgqioMW9wCpBnp
	 GSkfbXCbezg01AqzWY93zrCCnImWBJl7VDJSyIw8K/wqi/VVq8YonP3E2AL0u6aXBG
	 6ZWwQy2s9q8Ub0V2Sy5j0yfMBX81r+kvx89OvyPcUQz8j+ZZB4UYawud8kx6nlWww4
	 K41sjlD1NngpZ0bO1kWZsGsZ8vGb2nAN1cT8ip3p7jasjTxSgbfkieHRtlO3mS/kgr
	 Ol4YBWIFLHTgA==
Date: Tue, 31 Dec 2024 15:36:14 -0800
Subject: [PATCH 1/1] xfs: Don't free EOF blocks on close when extent size
 hints are set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: dchinner@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <173568752897.2704305.6672105459508175150.stgit@frogsfrogsfrogs>
In-Reply-To: <173568752878.2704305.6940024185435305877.stgit@frogsfrogsfrogs>
References: <173568752878.2704305.6940024185435305877.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dave Chinner <david@fromorbit.com>

When we have a workload that does open/write/close on files with
extent size hints set in parallel with other allocation, the file
becomes rapidly fragmented. This is due to close() calling
xfs_release() and removing the preallocated extent beyond EOF.  This
occurs for both buffered and direct writes that append to files with
extent size hints.

The existing open/write/close hueristic in xfs_release() does not
catch this as writes to files using extent size hints do not use
delayed allocation and hence do not leave delayed allocation blocks
allocated on the inode that can be detected in xfs_release(). Hence
XFS_IDIRTY_RELEASE never gets set.

In xfs_file_release(), we can tell whether the inode has extent size
hints set and skip EOF block truncation. We add this check to
xfs_can_free_eofblocks() so that we treat the post-EOF preallocated
extent like intentional preallocation and so are persistent unless
directly removed by userspace.

Before:

Test 2: Extent size hint fragmentation counts

/mnt/scratch/file.0: 1002
/mnt/scratch/file.1: 1002
/mnt/scratch/file.2: 1002
/mnt/scratch/file.3: 1002
/mnt/scratch/file.4: 1002
/mnt/scratch/file.5: 1002
/mnt/scratch/file.6: 1002
/mnt/scratch/file.7: 1002

After:

Test 2: Extent size hint fragmentation counts

/mnt/scratch/file.0: 4
/mnt/scratch/file.1: 4
/mnt/scratch/file.2: 4
/mnt/scratch/file.3: 4
/mnt/scratch/file.4: 4
/mnt/scratch/file.5: 4
/mnt/scratch/file.6: 4
/mnt/scratch/file.7: 4

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b0096ff91000ce..783349f2361ad3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -527,8 +527,9 @@ xfs_can_free_eofblocks(
 	 * Do not free real extents in preallocated files unless the file has
 	 * delalloc blocks and we are forced to remove them.
 	 */
-	if ((ip->i_diflags & XFS_DIFLAG_PREALLOC) && !ip->i_delayed_blks)
-		return false;
+	if (xfs_get_extsz_hint(ip) || (ip->i_diflags & XFS_DIFLAG_APPEND))
+		if (ip->i_delayed_blks == 0)
+			return false;
 
 	/*
 	 * Do not try to free post-EOF blocks if EOF is beyond the end of the

