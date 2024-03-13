Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98C42F2B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294439; cv=none; b=Ek5myWN8hfnnqQOKElcXEFylnNFob2Rr8bJKgJHyDqXqMQUoMgYwjHIB9fw4kYGy2/j1DVrVKgiIFSzyT7n/ggx3zm/sEymowt5JOPdH6Svvd2T1KDmEKH9mQBD7w3M/6Ik+GtMrfJNaJ4CaHug0mVuTxh3A41vfnLZusGT3mAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294439; c=relaxed/simple;
	bh=hlPuqQVgKhfOc0N+vxvB+d+gnJetmVu+WWix7P8T0FM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gsF36d4aI1A7mbrHePd52ItZ5ZDlJYwznPWpfhFuzIey3taKaF9ixqVKbT9nna0GO6ERYz1B899KZziHdPCyUpVxNmuGEtTGNpgewAdkpQb/AoIhVxgmwNCy7ct38P/FnzehIhB3/MoFl4/ERFFg1iwVhTzj5NinfKpX5GNYV4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyHtrn0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyHtrn0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4A5C433F1;
	Wed, 13 Mar 2024 01:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294439;
	bh=hlPuqQVgKhfOc0N+vxvB+d+gnJetmVu+WWix7P8T0FM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gyHtrn0R5c/hoKleiSKmqL3NAZfAkOsfFuyKWmM68jySb56ufl6vrghbpClmJDw7m
	 Ob7mQEHCOB7tYLyBIBXGWQGbBEuiS5ABAu9SQ1cWsI2p5SYiCZ/LPaNNAuyweL10hE
	 3Beyt8gBCBVehbxN/Aa5yfrREChE6bL9Y/3ELA8bM5ZaftADI9GO6yPhKLYmbiQa98
	 1XZvKsJNQPpmZNLPSWCaSwodrE8Ya4K1kzfxrx6byQbFfC4WniRIvus/R/z0DAEK0h
	 CiYlP07RjWYYIyQSpI96vr13NKWgLpoMlF1Q4nWnG40XqUBQO0P1GGs3HaRr2MaXLb
	 4T6k7Sd6pqS5A==
Date: Tue, 12 Mar 2024 18:47:18 -0700
Subject: [PATCHSET 01/10] xfsprogs: convert utilities to use new rt helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
In-Reply-To: <20240313014127.GJ1927156@frogsfrogsfrogs>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
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

The patches in this series clean up a lot of realtime space usage code
the userspace utilities.  This involves correcting incorrect type usage,
renaming variables to reflect their actual usage; and converting open
code logic to use the new helpers that were just added to libxfs.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fix-realtime-units
---
Commits in this patchset:
 * libxfs: fix incorrect porting to 6.7
 * mkfs: fix log sunit rounding when external logs are in use
 * xfs_repair: fix confusing rt space units in the duplicate detection code
 * libxfs: create a helper to compute leftovers of realtime extents
 * libxfs: use helpers to convert rt block numbers to rt extent numbers
 * xfs_repair: convert utility to use new rt extent helpers and types
 * mkfs: convert utility to use new rt extent helpers and types
 * xfs_{db,repair}: convert open-coded xfs_rtword_t pointer accesses to helper
 * xfs_repair: convert helpers for rtbitmap block/wordcount computations
 * xfs_{db,repair}: use accessor functions for bitmap words
 * xfs_{db,repair}: use helpers for rtsummary block/wordcount computations
 * xfs_{db,repair}: use accessor functions for summary info words
 * xfs_{db,repair}: use m_blockwsize instead of sb_blocksize for rt blocks
---
 db/check.c               |   90 ++++++++++++++++++++++++++++++++++++----------
 include/libxfs.h         |    4 ++
 libxfs/Makefile          |    1 +
 libxfs/init.c            |    8 ++--
 libxfs/libxfs_api_defs.h |    8 ++++
 libxfs/logitem.c         |    3 +-
 libxfs/trans.c           |    3 +-
 libxfs/xfs_rtbitmap.c    |    2 +
 libxfs/xfs_rtbitmap.h    |    3 --
 mkfs/proto.c             |   41 ++++++++++++++-------
 mkfs/xfs_mkfs.c          |   16 ++++++--
 repair/agheader.h        |    2 +
 repair/dinode.c          |   21 ++++++-----
 repair/globals.c         |    4 +-
 repair/globals.h         |    4 +-
 repair/incore.c          |   16 ++++----
 repair/incore.h          |   15 +++-----
 repair/incore_ext.c      |   74 ++++++++++++++++++++------------------
 repair/phase4.c          |   16 ++++----
 repair/phase6.c          |   28 +++++++++++---
 repair/rt.c              |   64 ++++++++++++++++++++++-----------
 repair/rt.h              |    6 +--
 repair/scan.c            |    2 +
 23 files changed, 278 insertions(+), 153 deletions(-)

