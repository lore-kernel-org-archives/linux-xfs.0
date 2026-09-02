Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810383876BA;
	Wed,  2 Sep 2026 05:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327699; cv=none; b=D6N4sZjDyh/qLrpmo/h6zUsoWqhDj7puj5Kx9zPII3S7uXDN2sc15C1PPOhIH2tJ1IxNLqEChwKdH3Qq/EMCCQA2RPPVPTXE26rJijdNnohE4F59PkrDuLKlnnYQj3XQbjParFuTCNiNh0jjEYPgVjFkzGxay++DLBdJDnFMpZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327699; c=relaxed/simple;
	bh=d2hXwG/z4YRS5drfte7z7zWJ3nFuf2/1PJ/+G25ZMPI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=od40oUHtvJtMHNL6w7g+/BIrqOzDqNQv4EBixw9m4jXqJ0c4aCtfkaI5Ej/TcYJ7ottawW61JoJAHC5NGkzVDC0nco8V2QTm9l0FsIy25Xw4UzfgefAMO5kGFfrho6+MmkBolSrGai1BZlznxJ78r9gKAC6OhlRa4ShBnBJeoFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0Zodlsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0Zodlsj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0BD101F000E9;
	Wed,  2 Sep 2026 05:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327698;
	bh=Vz0TDMBxC2T2K7xP2OuIpNaRo3XEtb3onnY7tfSk2Xg=;
	h=Date:Subject:From:To:Cc;
	b=b0ZodlsjY15JuKFOzOgRV5ob0bSZbuG9LzU2GHcpNiAlfSadNNgP/uZ1BwFIx70TB
	 agacdEEFROYOVVQINeXqMR24dHE8UwSBXAq7te00MXzO+8tl9bVZhyy6VxroXljWY3
	 A7TYnJEMphlnC9+oSbdBB5a2VNeuilL8m2zwKQkag9vWit+4eNy0ojr9Jz5+B3KM2C
	 qzlk9nwR5Vq59JL4qe4ly/JDBgu0u4t/bS7yYDyUgwcLm919VOP4sIwbTiHoiBvVEn
	 fTV+09DdLOgzfv6mkGXVDqrBl7857vPUtdf9MzmwW4SoAFL/zPm/9a/jWCN3eqCcHm
	 x7iup5VZJAR4A==
Date: Tue, 01 Sep 2026 22:41:37 -0700
Subject: [PATCHSET v2 2/5] xfs: LLM-inspired bug fixes, part 6
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a sixth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
mwa...

v2: add RVBs, address some review comments

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-6
---
Commits in this patchset:
 * xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
 * xfs: preserve owner on in-memory btree creation
 * xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails
 * xfs: actually recover intended file sizes in xfs_xmi_item_recover_intent
 * xfs: don't modify file attributes or poke fsnotify for dry runs
 * xfs: fix bnobt repair space reservation disposal failure
---
 fs/xfs/libxfs/xfs_btree_mem.c     |    2 ++
 fs/xfs/libxfs/xfs_btree_staging.c |    4 +++-
 fs/xfs/libxfs/xfs_rtrmap_btree.c  |    2 +-
 fs/xfs/scrub/alloc_repair.c       |   18 ++++++++++++------
 fs/xfs/xfs_exchmaps_item.c        |   19 ++++++++++++++++++-
 fs/xfs/xfs_exchrange.c            |   12 +++++++++---
 6 files changed, 45 insertions(+), 12 deletions(-)

Unreviewed patches in this series are:

[PATCHSET v2 2/5] xfs: LLM-inspired bug fixes, part 6
  [PATCH 5/6] xfs: don't modify file attributes or poke fsnotify for
