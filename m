Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090D048F832;
	Tue, 13 Oct 2026 06:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871524; cv=none; b=gdLwvV9y0xllB4PKFXAzwIznO+Q9wSY4nQkqzjcs3WCXpw7vGXtKFiEEqbIvIoSM9fltP8J9LSkX8uwxDx0jj12erh97RjpIYyWQWtFzRJRt+z2M3aZjk2mp566s8vqgf9WHljNTq1Doy4DUzG4mTwtc07fWxPvnyynckRB9YeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871524; c=relaxed/simple;
	bh=afmUuv47h+3Fz7V7Gzi/94npXG6eg5z4rW2PocFq8io=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=X8N4gs+jDFEPIF327YGralxVIhi0nx1yNt9biADPRy5T4aJbliOjLY94m2FPVyNqFRpx1Wncg/uPoaY6msCvJZKAncrfwUUYT/9lE2U7puxcQXAmV83xl5TWmnapiBkxq5IaYY8wLRIsZeHGdK7R6JmthTQVqkudoZEJsK1tH5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=go5nxrk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="go5nxrk5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D5E661F000FF;
	Tue, 13 Oct 2026 06:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871522;
	bh=LwDHkOT8JVTU1kxy53d3y2iYIOYJ+r02Osta4uCxVTA=;
	h=Date:Subject:From:To:Cc;
	b=go5nxrk5eIkIiX+WU2xNrBinBvT3RFpsXpXUyka/5cHbX4vqRZO19CVIif3rBAVan
	 S5TPOCGEiwatlC/jyHUVN3mt9M5ht3UJ+ya9DFsiVzArXQoDIM4NkFL61bUhZXNdt7
	 LHoPm4GO6hdC/tUnno7SmFDhkHWI4FDg5wAvFCpn3F8Iz3JAyV0dw0REMewN0omvdH
	 12gL8P1/stk4wRbgImbxW38RkZTWyF/qlvEUh1kRynhV/rqqdi5extrqAuGufap46a
	 hGKTSh3QGUvAyX80vxnuEPdgpxwp91rnjZXvvbOwUvrWpE9mPikOBIBmWOcC/0H8WQ
	 GfKfYLM1KI0QQ==
Date: Mon, 12 Oct 2026 23:05:22 -0700
Subject: [PATCHSET v2 2/2] xfs: LLM-inspired bug fixes, part 23
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a twenty-third batch of xfs fixes resulting from a LLaMma.  Mwa
mwa mwa... this is the final batch of fixes from me.

v2: fix issues pointed out by reviewers.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=llm-fixes-23
---
Commits in this patchset:
 * xfs: don't set a metadata directory's parent to sb_rootino
 * xfs: don't rescan ifree and icount when frozen
 * xfs: rescan the AGs if incore delalloc counter is negative
 * xfs: don't try to repair rtsummary if the summary file isn't computed
 * xfs: update quota flags on secondary supers when metadir enabled
 * xfs: refactor directory data block walking loops in scrub
 * xfs: improve dirent bounds checking in scrub and repair
 * xfs: drop unnecessary sa parameter from the xrep_ag init functions
 * xfs: drop unnecessary sr parameter from xrep_rtgroup init functions
 * xfs: drop unnecessary sa parameter from xchk_ag init functions
 * xfs: drop unnecessary sr parameter from xchk_rtgroup init functions
 * xfs: refactor inode forkoff to byte conversions
---
 fs/xfs/libxfs/xfs_bmap.h         |    6 ++
 fs/xfs/libxfs/xfs_format.h       |    6 ++
 fs/xfs/scrub/common.h            |   46 +++++++---------
 fs/xfs/scrub/repair.h            |   11 ++--
 fs/xfs/scrub/rtsummary.h         |    1 
 fs/xfs/xfs_inode.h               |    2 -
 fs/xfs/xfs_quota.h               |    9 +++
 fs/xfs/libxfs/xfs_attr_leaf.c    |   12 ++--
 fs/xfs/libxfs/xfs_bmap.c         |    4 +
 fs/xfs/libxfs/xfs_inode_buf.c    |    4 +
 fs/xfs/libxfs/xfs_inode_util.c   |    2 -
 fs/xfs/scrub/agheader.c          |   16 +++---
 fs/xfs/scrub/alloc_repair.c      |    4 +
 fs/xfs/scrub/bmap.c              |   13 ++--
 fs/xfs/scrub/bmap_repair.c       |   15 ++---
 fs/xfs/scrub/btree.c             |    4 +
 fs/xfs/scrub/common.c            |   50 ++++++++++-------
 fs/xfs/scrub/cow_repair.c        |   12 ++--
 fs/xfs/scrub/dir.c               |  110 +++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/dir_repair.c        |  105 +++++++++++++++++++++++++++++-------
 fs/xfs/scrub/fscounters.c        |   26 ++++++++-
 fs/xfs/scrub/ialloc_repair.c     |    4 +
 fs/xfs/scrub/inode.c             |    6 +-
 fs/xfs/scrub/inode_repair.c      |   10 ++-
 fs/xfs/scrub/refcount_repair.c   |    4 +
 fs/xfs/scrub/repair.c            |   23 ++++----
 fs/xfs/scrub/rgsuper.c           |    4 +
 fs/xfs/scrub/rmap_repair.c       |    8 +--
 fs/xfs/scrub/rtbitmap.c          |    4 +
 fs/xfs/scrub/rtbitmap_repair.c   |    4 +
 fs/xfs/scrub/rtrefcount.c        |    8 +--
 fs/xfs/scrub/rtrefcount_repair.c |    8 +--
 fs/xfs/scrub/rtrmap.c            |    4 +
 fs/xfs/scrub/rtrmap_repair.c     |   12 ++--
 fs/xfs/scrub/rtsummary.c         |   13 +++-
 fs/xfs/scrub/rtsummary_repair.c  |    2 -
 fs/xfs/scrub/scrub.c             |    6 +-
 fs/xfs/xfs_mount.c               |    9 +++
 fs/xfs/xfs_qm.c                  |   36 ++++++++++++
 39 files changed, 432 insertions(+), 191 deletions(-)

Unreviewed in this series:

[PATCHSET v2 2/2] xfs: LLM-inspired bug fixes, part 23
  [PATCH 03/12] xfs: rescan the AGs if incore delalloc counter is
  [PATCH 05/12] xfs: update quota flags on secondary supers when
