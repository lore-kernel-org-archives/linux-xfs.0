Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DFD44A702;
	Wed, 21 Jan 2026 06:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977295; cv=none; b=KRgISyH4tjMvwh+fjuomvaVy/8dcLQiwGacournrO9jBCW3Gg3uitB7YZ++wk6DE5YY6Pm2rH8YVMjXMXs9AcRDihwDHu1cPVW+v0fEKqywCmHtZqNG0RtAOTNAufSW3Yx4H0s8uPwVTg4g4CvYyMs7L7oh8uUm8FS5LKGe4Ayg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977295; c=relaxed/simple;
	bh=KQjAYbXC+JrVV4sPRWLsWYskPn/EuEQytpgssjMmGWw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=jGBEmyLIsBvK4OpeG1ahTgDKT2//Cj0J/oyN+vhnqUqBA80PyDHouEulBZsHemwQctaOrZNtqEg7KNRwzkrpAE0y0YjlrnMgUXUYctJD66S6KzqN9ZcQ0QE8H7By+tLvxQuRBT+t4i0LYgY2M5a/3zObJKsVj2JfPakf16E+hPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6k40hss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6k40hss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D3EC116D0;
	Wed, 21 Jan 2026 06:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977294;
	bh=KQjAYbXC+JrVV4sPRWLsWYskPn/EuEQytpgssjMmGWw=;
	h=Date:Subject:From:To:Cc:From;
	b=C6k40hssj2z83uVmZYgA8hMyWeUjcigmsW9QnBSep5XPG4C9asYw6KN2FXzkC9DXc
	 BgNRqpjIZ6Ypd3a7ikV+UvsMaWX1Aryt2tBZxPoRNI92LG4rspcXTq3KLgv2iS2WW+
	 3pgD+BdllB9oZUcPHJmavhqnLG9JmZbC+qpmISQw8W8exh16YV2iIEe+mKrdRRTqft
	 y2XDUYHo7Y4aa5ImkVlcYsSUJT9NJWdZf6cOt/KCqPDRk6UfUxF714bH9JjvSs1hAF
	 +LV9hmikx4iI9M/O11Tu2W8087zAKdr88AuIuMi8xMuJWIV5pLiTIHrX9+FguREJmt
	 J8OeeCcXgjh9Q==
Date: Tue, 20 Jan 2026 22:34:53 -0800
Subject: [PATCHSET 2/3] xfs: fix problems in the attr leaf freemap code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Running generic/753 for hours revealed data corruption problems in the
attr leaf block space management code.  Under certain circumstances,
freemap entries are left with zero size but a nonzero offset.  If that
offset happens to be the same offset as the end of the entries array
during an attr set operation, the leaf entry table expansion will push
the freemap record offset upwards without checking for overlap with any
other freemap entries.  If there happened to be a second freemap entry
overlapping with the newly allocated leaf entry space, then the next
attr set operation might find that space and overwrite the leaf entry,
thereby corrupting the leaf block.

Fix this by zeroing the freemap offset any time we set the size to zero.
If a subsequent attr set operation finds no space in the freemap, it
will compact the block and regenerate the freemaps.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=attr-leaf-freemap-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=attr-leaf-freemap-fixes
---
Commits in this patchset:
 * xfs: delete attr leaf freemap entries when empty
 * xfs: fix freemap adjustments when adding xattrs to leaf blocks
 * xfs: refactor attr3 leaf table size computation
 * xfs: strengthen attr leaf block freemap checking
 * xfs: fix the xattr scrub to detect freemap/entries array collisions
 * xfs: fix remote xattr valuelblk check
---
 fs/xfs/libxfs/xfs_da_format.h |    2 -
 fs/xfs/libxfs/xfs_attr_leaf.c |  157 ++++++++++++++++++++++++++++++++---------
 fs/xfs/scrub/attr.c           |   59 ++++++++-------
 3 files changed, 155 insertions(+), 63 deletions(-)

