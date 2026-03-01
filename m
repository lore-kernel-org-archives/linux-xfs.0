Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA08259C80;
	Sun,  1 Mar 2026 02:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330511; cv=none; b=Y+mL1Nrs0LBwXoYOKwjQrDSP3IvYXaU2iU4S4if335GdeR//U0OuUuLpUy9kj4SR2QmJXfdEP0MQPugJclVYtY/dHufhtP0XTlDVYA6Ty2cmn2qRq+bU9CQY693fROvCAOtWCl7+FwuNnbI28N1sYHJbcnWCICnqmb0+jViU5eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330511; c=relaxed/simple;
	bh=SZO6Likc2aVLQlPtgAoK7KLCxUevkiBSncbR5E9FjHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gEemhXH3QDADiVtLhWhBOsyo0hzIX6SD9VkGLZveL9hHu7hzlNNHjJrimsamytNqg5obepnju+NBkohPTRjNArEg+NKTa8GLOuRKXSl6awNT5gwjCYPLcWCyfxAUH+h818ooszx2WQ5cx0mM77y6mUpsBYyad/YzPJ2fSD1RvEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnKt79yo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnKt79yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181B5C19421;
	Sun,  1 Mar 2026 02:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330511;
	bh=SZO6Likc2aVLQlPtgAoK7KLCxUevkiBSncbR5E9FjHo=;
	h=From:To:Cc:Subject:Date:From;
	b=hnKt79yo1TSZlYrsg5B0fGDqWAZbbki8RlyP/vouxFQng7CBVUclCKSW6SzS796vm
	 vv7sYDrcNkmPmSk+DAGM02tymr6jkDdNoYxFgYKgvnQNoZoVxttOp+6Z6r87b9uX2/
	 bBL78ETVZVov3dPrG4i3Il/SuUdjX0956rjr4ihxybjWyaPjkIBZMQBI9iX+2c3L9K
	 kMf+8Bt03LYyyEsdA2/b1J1q0wMFGc/+QWHXPodyz7ZU5mZpgAVGXfpXbFfT0Z0Li2
	 hTGCDs9IRt6jRfqlue7e/K7s1S287a+/100SDX/B10a7p4QkA2PhMd0KnM3hmRWJz2
	 wT3JF84yY6gZA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: delete attr leaf freemap entries when empty" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:01:47 -0500
Message-ID: <20260301020149.1729196-1-sashal@kernel.org>
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

The patch below does not apply to the 5.10-stable tree.
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




