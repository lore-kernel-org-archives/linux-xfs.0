Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C6032939D;
	Fri, 23 Jan 2026 07:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151662; cv=none; b=FEZp03SMUrKqRwintSZ6Jtk1ROLsU22oogp/VgJ5EIcpuS9l39MqyaDKB3g4bunsKbC2QeAHQAaiLfKxZSPPFYLh8/YHyx+JzfKP+qNcdXYmVsPOoljJieLBGDDlGMTi4xRudSuiB1XZRyD2rG3mUnoE056EB6KrIDkC6SOzk9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151662; c=relaxed/simple;
	bh=1coq9RY1hDSojshdeTf2DUuQ2A9kRnwJ90pthJoBv44=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J1H3IJuZEzd2RlqjH5QYjbIJbpCLJOYAeET7GNidF0EqOkJ1VjWrVD+7rvIaE1Yuev/RfQCGSfi4GqOVvsfS+iPUI2mlmCEhitPTQbJpKvJJWlWgE1ocX8KQkzNcavrMJ4qn33f1KkEhJuLVGJNwrluwIKzdNPheP+ctcbAcPk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rco7efLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rco7efLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E25C4CEF1;
	Fri, 23 Jan 2026 07:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151661;
	bh=1coq9RY1hDSojshdeTf2DUuQ2A9kRnwJ90pthJoBv44=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rco7efLk7KZyNbalc5EnvZH/epMvaGEGi3YYvlThEALlg4/B8m/NxFbEGRNwC6giY
	 +eVIiJyCaDy1hJy0YfwMnVGhOEVGhCs+TZHGbbOMu54SXqa6y3GGhu6PVYv6u9/FRe
	 2XqZM+OytlZ6jeMGUwmg8m7dDKm97WHtPcuGHDmEVMnHdNPqeZUCOdd1wgtATNHxBd
	 AD8ifi2rtdAi24Eopr0Dzpg7a5knyeGPwcVwD8Y7DCPJFAlpDn4KjW2mB8GIAUcs52
	 QOP7JpU/PXsClAKcdvtY+LEdnZtKRk7KGOoIVs0pcDjaGsJZ5ed1BVswI+a/r1o5ZB
	 BQGndzpCRbkZw==
Date: Thu, 22 Jan 2026 23:01:01 -0800
Subject: [PATCH 1/6] xfs: delete attr leaf freemap entries when empty
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176915153034.1677392.8452885009754140060.stgit@frogsfrogsfrogs>
In-Reply-To: <176915152981.1677392.17448598289298023614.stgit@frogsfrogsfrogs>
References: <176915152981.1677392.17448598289298023614.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

