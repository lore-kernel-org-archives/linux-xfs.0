Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CBBFBF3
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 17:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718214403; cv=none; b=MuWttwHj8GWOL0cQsRy8y2Cr0hSvlo+7+EOnU60gKZ70kLG1xKWRM2OxUSI6lRGxX40fSWJgCxScWAzp0QlvGCXaXOL7JVFs65pdrNshcEUtpfFHQbCua6w0JjyAaN/w/KFb9lxL1UPQu1KetogEh7j9ZD0IivUeXWOyAEzjXLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718214403; c=relaxed/simple;
	bh=ZPbs78fpYpBKmXEsfn1htyt57Z+vCAHnCz8bewR3bmY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=sB4QN81kzp2+W5Wgo7KkEa0yoJ5wLFsF5dE7R6lIih2cBrDpmayK0SF6lT/K1VYQNq7uNKaOuHVK7ERs4q/0Vexo8J/eAnQI7KLojMnrHT3XC4dVXGD8VWlJ20JBmlRMkB+T65HzgJ5CpcNPVubHuur+TeiPiSudmAvgIO9Z2wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFs/HU8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFs/HU8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1519BC116B1;
	Wed, 12 Jun 2024 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718214403;
	bh=ZPbs78fpYpBKmXEsfn1htyt57Z+vCAHnCz8bewR3bmY=;
	h=Date:Subject:From:To:Cc:From;
	b=mFs/HU8uV/KfRgYZiKWzDGOMsOA+BV3CMXvqpASzjir9YvTWWai5lwthPPZJJXR8o
	 o6aDhQ9EDkglQ7eHGXJZWMjXOPiGj5S2v3ghKXPfbkH1V2UPSFwk+PwIJmEszvYUgT
	 YYOYc7cpCX8qokreVXJOS7lNpTHV1QSndTr08IwC/uMUuITxHEahTJyKWYS9E2/n5z
	 brqpKRw8LmNIYH+kTko7tbFpQLVG+dtm+xzLOZ2C9VT+hYnjBDX/+LU2HOAorlM0OE
	 lxHdjzIBbb2q+KpcCtvDPVE5461ivGWMxg1ccZ3oL2OfU4A4EBtfs/qDAYGVsbIdCF
	 BdaDMrnW9KXWA==
Date: Wed, 12 Jun 2024 10:46:41 -0700
Subject: [PATCHSET] xfs: random fixes for 6.10
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here are some bugfixes for 6.10.  The first two patches are from hch,
and fix some longstanding delalloc leaks that only came to light now
that we've enabled it for realtime.

The second two fixes are from me -- one fixes a bug when we run out
of space for cow preallocations when alwayscow is turned on (xfs/205),
and the other corrects overzealous inode validation that causes log
recovery failure with generic/388.

The last patch is a debugging patch to ensure that transactions never
commit corrupt inodes, buffers, or dquots.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-6.10
---
Commits in this patchset:
 * xfs: don't treat append-only files as having preallocations
 * xfs: fix freeing speculative preallocations for preallocated files
 * xfs: restrict when we try to align cow fork delalloc to cowextsz hints
 * xfs: allow unlinked symlinks and dirs with zero size
 * xfs: verify buffer, inode, and dquot items every tx commit
---
 fs/xfs/libxfs/xfs_bmap.c      |   14 +++++++++++---
 fs/xfs/libxfs/xfs_bmap.h      |    2 +-
 fs/xfs/libxfs/xfs_inode_buf.c |   23 ++++++++++++++++++-----
 fs/xfs/xfs_bmap_util.c        |   37 +++++++++++++++++++++++--------------
 fs/xfs/xfs_bmap_util.h        |    2 +-
 fs/xfs/xfs_buf_item.c         |   32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot_item.c       |   31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c           |    4 ++--
 fs/xfs/xfs_inode.c            |   14 ++++----------
 fs/xfs/xfs_inode_item.c       |   32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c            |   14 ++++++++++++--
 11 files changed, 167 insertions(+), 38 deletions(-)

