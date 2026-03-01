Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FF2145A1F;
	Sun,  1 Mar 2026 01:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329410; cv=none; b=dJ5qvVYiZzGP/76UBSYQIdTiWx9KGHCQCTkpVtN2ax9yAf93HMEsfXivR6n1f0Z3+XiaaA+uJZHr3Q3DOmI5E60kZa5Rao2/ZVqRS0IMrvoZlaUnq2nf3HWZ9oVBNsO7wNBwu8HrdnPCJSIYqeuKtp/hTOYDQan0PBbv6417kb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329410; c=relaxed/simple;
	bh=PShefgtIkhKsP7FMn+baeBYk1CpXzIzmx2W21XviXoM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kzlrBlyhaOkWU7pTI2G0BmnIJdBBLVQg07LRkJCjDyGtv8Ckr4VBhFfaMw6xOjchbyIDOB2rWNbRw69/WyD6QYGCglGuZ1bb/x5DVnwCHwQep15ZJNlJDBTbxvERMcGK/QSEabO3LnOAo1RO0KL6tVbnxudYQW/a08/OT3tx+kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KWg7a+cv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KWg7a+cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED74C19421;
	Sun,  1 Mar 2026 01:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329409;
	bh=PShefgtIkhKsP7FMn+baeBYk1CpXzIzmx2W21XviXoM=;
	h=From:To:Cc:Subject:Date:From;
	b=KWg7a+cvwjAJgzLBOr/xl4Phcgqp6YW8E9SzMD3ExY2w856xVx8D0izsiaoqrSX5n
	 zNTgEVtsDucGf4MeXJghsxSnFyK09jo3LmfcMOFIOFHiNzg8VZF+9D0YgsoLGPFMkg
	 5snPQBOzh+If0IHYICf58TewRPFQPQ7g/EQxxk1Gxr1MOl48TywgMW9YsQYylt3QKp
	 guAMAKFxnkbxDtDJQXsnU4uG4kuWi1KhWj3BKPLB0U7JXOPf7K2y9U5LVxYrx/79e2
	 SQsoRd7jPs2YF66jbohR1C7dXvINggQCUtYFtCMOO+ffwK7s8fy5hCgiHOVksV/hao
	 RS7SJeB4lf4xg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: delete attr leaf freemap entries when empty" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:43:25 -0500
Message-ID: <20260301014328.1705540-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 6f13c1d2a6271c2e73226864a0e83de2770b6f34 Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 23 Jan 2026 09:27:30 -0800
Subject: [PATCH] xfs: delete attr leaf freemap entries when empty

Back in commit 2a2b5932db6758 ("xfs: fix attr leaf header freemap.size
underflow"), Brian Foster observed that it's possible for a small
freemap at the end of the end of the xattr entries array to experience
a size underflow when subtracting the space consumed by an expansion of
the entries array.  There are only three freemap entries, which means
that it is not a complete index of all free space in the leaf block.

This code can leave behind a zero-length freemap entry with a nonzero
base.  Subsequent setxattr operations can increase the base up to the
point that it overlaps with another freemap entry.  This isn't in and of
itself a problem because the code in _leaf_add that finds free space
ignores any freemap entry with zero size.

However, there's another bug in the freemap update code in _leaf_add,
which is that it fails to update a freemap entry that begins midway
through the xattr entry that was just appended to the array.  That can
result in the freemap containing two entries with the same base but
different sizes (0 for the "pushed-up" entry, nonzero for the entry
that's actually tracking free space).  A subsequent _leaf_add can then
allocate xattr namevalue entries on top of the entries array, leading to
data loss.  But fixing that is for later.

For now, eliminate the possibility of confusion by zeroing out the base
of any freemap entry that has zero size.  Because the freemap is not
intended to be a complete index of free space, a subsequent failure to
find any free space for a new xattr will trigger block compaction, which
regenerates the freemap.

It looks like this bug has been in the codebase for quite a long time.

Cc: <stable@vger.kernel.org> # v2.6.12
Fixes: 1da177e4c3f415 ("Linux-2.6.12-rc2")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6061230b17ef5..c8c9737f04563 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1580,6 +1580,19 @@ xfs_attr3_leaf_add_work(
 				min_t(uint16_t, ichdr->freemap[i].size,
 						sizeof(xfs_attr_leaf_entry_t));
 		}
+
+		/*
+		 * Don't leave zero-length freemaps with nonzero base lying
+		 * around, because we don't want the code in _remove that
+		 * matches on base address to get confused and create
+		 * overlapping freemaps.  If we end up with no freemap entries
+		 * then the next _add will compact the leaf block and
+		 * regenerate the freemaps.
+		 */
+		if (ichdr->freemap[i].size == 0 && ichdr->freemap[i].base > 0) {
+			ichdr->freemap[i].base = 0;
+			ichdr->holes = 1;
+		}
 	}
 	ichdr->usedbytes += xfs_attr_leaf_entsize(leaf, args->index);
 }
-- 
2.51.0




