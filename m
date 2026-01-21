Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D973449EAD;
	Wed, 21 Jan 2026 06:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977478; cv=none; b=tJDmeCBL7uBgLKZhaYQ+EU9QU0maNrUcYKuwWqKkKI17/mG4r3cBwJiJDZA6PZJ6TTHOgVNJeYLfnOKWH2WVLy0vePvosIoVq2ZC7gtwjXyCbBdFAxHlzMZcwFU0plW+r6A2IMj0dbcyBSny23KORcSdYAI8AwImfLS9xOg9SAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977478; c=relaxed/simple;
	bh=PUEHv+vuw4f0+Ta6hLUNC4WI0ByzaoOn9fPsR5L3Pnk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DbV/Yjz907LyVYCXX/oH0Dr2WdB90c1vy9jyJI6ab0DyLmmSlIHs4ZSoACrdfav5FceqWfPk/bZ0bdUD2Hflrp3t+ya8m7zf5bA6ZqgZABbLhuzDa7f5U9uNqVra/xoMFuvqyYg8++J6HtgPbaC8ljFUTjIMlcsqtYRYo84R8+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+xjljNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+xjljNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCEBC116D0;
	Wed, 21 Jan 2026 06:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977477;
	bh=PUEHv+vuw4f0+Ta6hLUNC4WI0ByzaoOn9fPsR5L3Pnk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X+xjljNIGK+eKwo2uEvVHAYv+vcmDISxiiB0s45Kt8+Pa+amxKQ1JX3BCVP0ldWHW
	 7DWRIsXs4XmowX1JVBehjSyak09qcU5m6ufvsLzLQBQgRlj0mUztsIk8i+KJabcIrz
	 jFLaebBkcnad6edKwYHxeloIo1uDSymD5JJTeUBnmvRR/RGUcUf1eFa34KlyEC672z
	 zXdfmBooRtYG3AKY55h/qli+bncimywcmZrNhdrrp4+fLdsI0PCQVvGOQR/OACVVbL
	 TOw2li6p88O0WAl+Hteo7cVnEp9t0Rv0Ln1xtsBxjLyD8E9KQv6UlrgMHSNN/ecJsh
	 46UQPI4ZqBuxQ==
Date: Tue, 20 Jan 2026 22:37:57 -0800
Subject: [PATCH 1/6] xfs: delete attr leaf freemap entries when empty
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176897695577.202569.9464144622549604714.stgit@frogsfrogsfrogs>
In-Reply-To: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
References: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

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
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 91c1b30ebaab31..33c6c468ad8d55 100644
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

