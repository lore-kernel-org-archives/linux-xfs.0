Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7A11B4224
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497011; cv=none; b=IgcQc2/lcAnvqgDDxwAcCaZJTn1P0XzJun13Ye5vdBKOeOEKxQwouKuQ/9/kzqpywNhV4Bx1Jt/b/a6s4liWF+qErZ06eNGXLWkgWf05KugPV0g/0eNxEPvlQ6NXrWVlgfaLox2WUyMw/nCSQoBN1bnKVl6+EP0aLhRB5jZ/gjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497011; c=relaxed/simple;
	bh=yKKav8RRZK5MSRbyC6YW368Gs+CEvGiyTpJ7vdXSP5U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j3UeLUK731iKV3QvdGv2oo0Jlf5rYdRLSpr/i/vvicV+zlQKoOyJLha1CuXp+2anqyosFS7w8zvQYxqKBZiWKmfFcOkYzS8VnlKWuU7NtlLRTCK36yf+8w5cZRCzjJ2FIiXTpImaEFviZheidzPRCwaQcPFR6EgeEKjWtWNxIy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QMzGWFxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QMzGWFxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4356CC19423;
	Tue,  3 Mar 2026 00:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497011;
	bh=yKKav8RRZK5MSRbyC6YW368Gs+CEvGiyTpJ7vdXSP5U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QMzGWFxlrQ1aA8QjsTxfee6QueD6PiiVD/XoNMGWPwVvybPXPde365vBXAUpnjn9Y
	 np6BDatm1t9wPietl6cEQbzJ+x3cSN7ak7C2Gp5ig62EAABMEWG8DR+chU0lxrfOHW
	 AjcOn6DJSX62uwhrlhE35OttlGa4/2g2UezA1KbYhiZdEDwVq/HdwzZJfTJsuN4/18
	 mkGkEIKLFVB5p2I22n+m007eNTlhcgpJfA/Vw4WtjQIJ5XSs5wF8JWj+yyno7jYXOp
	 6Jx7Zz6L0nFHm80wzYalY4601kgvrSjC3j4np3YeUKf426iWfr8hPvg9oA0qqqT6dJ
	 2GMwOmMeX6qCw==
Date: Mon, 02 Mar 2026 16:16:50 -0800
Subject: [PATCH 18/36] xfs: delete attr leaf freemap entries when empty
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249638110.457970.10467840904925325688.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 6f13c1d2a6271c2e73226864a0e83de2770b6f34

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

Fixes: 1da177e4c3f415 ("Linux-2.6.12-rc2")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr_leaf.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index ff1085f0b3afe4..f5ea39abf04a35 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1577,6 +1577,19 @@ xfs_attr3_leaf_add_work(
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

