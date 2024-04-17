Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA6337163
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388562; cv=none; b=nXr4sMqQ+dor2Pb4xXkIzRt/V5qes6dGorUpwhkdb/Q5bBVxAiJv2ceiMHP1yK56JfyYyUe1KbRl8beXi55l1EgzCWUTx/b9vihEGNdCaB8zIfue++2woxF+TzcbU7UGCxEiVTumiJG65TeyWELJkyaEyDSkQAJY/WKAj5xaey4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388562; c=relaxed/simple;
	bh=Ek3LJfHq+HuN588ZY/xB+ZknbbHY/bQVxKfG0QlFl2Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VOAxqFuikMqWYUySaPBo1jbPBVaYUm/fNKc8Bz6ha/5fFvSeGI8jIxbA3Jbr/qXRNy3GivA79qp2HOr/tBFza1czjTaPxOkzMGbqUunVlPWiERFjMm41mcRNcfl11QXjHOE2UMQKq9xNFMd7Qw8ZUCne0b5Lo3HS9Qxl0ZAynoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkvwH6Jk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkvwH6Jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7EAC072AA;
	Wed, 17 Apr 2024 21:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388562;
	bh=Ek3LJfHq+HuN588ZY/xB+ZknbbHY/bQVxKfG0QlFl2Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GkvwH6JkvJ8S4NIuRopK0uPGlA8OQvhLz0t89oBI4BtPIAF5/kjpG0Z37l68RZdIU
	 gh3OB65axp5vLUn8UnoAn+Ugo3L9tBsMNoY7J26dH05XF84UbAocyR36pmz+9HgK6K
	 M/wxbePrX3bu+g0VOcLJVSck1QUr8fvpuZgUk9asOy8FLoju05g5RIuJ5SpixJA6Yl
	 VPrVbmpam/+PRLm0YBaIH2OpMzm3oa+itOWR2/Pi9lzB6X3IjCQZcqENNfp+Y+Ubn0
	 M5xh8EEFVnDg0S7zMJ6rwsOQe1xL/XgL29myJ00s/5xw0wJ0+PrRps14bmCQVjKvP4
	 MP7tV4xXcddyA==
Date: Wed, 17 Apr 2024 14:16:01 -0700
Subject: [PATCHSET 03/11] xfsprogs: convert utilities to use new rt helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417211156.GA11948@frogsfrogsfrogs>
References: <20240417211156.GA11948@frogsfrogsfrogs>
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

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fix-realtime-units-6.7
---
Commits in this patchset:
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
 db/check.c               |   89 ++++++++++++++++++++++++++++++++++++----------
 libxfs/init.c            |    8 ++--
 libxfs/libxfs_api_defs.h |    8 ++++
 libxfs/logitem.c         |    3 +-
 libxfs/trans.c           |    3 +-
 mkfs/proto.c             |   41 ++++++++++++++-------
 repair/agheader.h        |    2 +
 repair/dinode.c          |   21 ++++++-----
 repair/globals.c         |    4 +-
 repair/globals.h         |    4 +-
 repair/incore.c          |   16 ++++----
 repair/incore.h          |   15 +++-----
 repair/incore_ext.c      |   74 ++++++++++++++++++++------------------
 repair/phase4.c          |   16 ++++----
 repair/phase6.c          |   28 +++++++++++---
 repair/rt.c              |   63 +++++++++++++++++++++++----------
 repair/rt.h              |    6 +--
 repair/scan.c            |    2 +
 18 files changed, 261 insertions(+), 142 deletions(-)

