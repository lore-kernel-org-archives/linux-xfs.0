Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815224C62E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391687; cv=none; b=Pe8PiI/sh8H8uhyjjyWx/jNue3vukba6G+je2ry9d3nrq7R4tt7x7kKR8Sq5ao8tsGMoF3z5uFb47srfNAXWAYBWFz60qWJ3rMlKHh5g1OWSWT8zLBq/lGHTzPYf2kniQNrTqmBJctxNyHgX5knOR6f36TfbZsGfOKSitmzoSL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391687; c=relaxed/simple;
	bh=9mCznXq8Z0jQO0ZeJOBqbEP2w1GuTvJLIAlOO8paUsI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=MHpoH7BLIV+4vmR0JlzArzv8TpJ6uopSKyIEAE0xPoLvvw/kAD9XnJ7Dy4KtulbThGiV5oo9ngfs4YZBEgxNaKzXyoF7HxMmQvAN3yN2n1+MLvK7eDnMTjc01kbg1EWVRrNlkqALl/FrJq4ReXWOxnQlzXt6W48yDQ/MMUeGeRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G3Guw4U+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G3Guw4U+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075ABC072AA;
	Wed, 17 Apr 2024 22:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391687;
	bh=9mCznXq8Z0jQO0ZeJOBqbEP2w1GuTvJLIAlOO8paUsI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G3Guw4U+fTc658rfbTX/MUlS9/rjGPbioyOSNmqYq7vXP2Vaw/FA8Z+zKfRdFnLa4
	 wrQUOhQFQBNvAfuOU88KRMqUjerAj8OBgSsE7nNV01No8V7IzzhE3L4SNejyVXYuRP
	 dxGxIsDOq87dtmbktwC402cRTUkuS9G4/mduVOIjxT/MToDO6buKyBcrgEqI5SaX0T
	 FNkdczS/5oiZDlT85XgYxGqxdn+EhCIAvFdJXR+AAXCycn9yfRE3t2OxE/1es0K6NI
	 D5Dvuz9LccCqh+KoyhI/ciATOrNVSWbvKvhgYNpiXismfPeeLm0ayXVNmVLasKwSMF
	 7GzMuM4lbSMHg==
Date: Wed, 17 Apr 2024 15:08:06 -0700
Subject: [GIT PULL 03/11] xfsprogs: convert utilities to use new rt helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: bodonnel@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171339159101.1911630.4622170395153672296.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240417220440.GB11948@frogsfrogsfrogs>
References: <20240417220440.GB11948@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 94f4f0a7321d52edaa998367cccbe4dd16f1053a:

mkfs: fix log sunit rounding when external logs are in use (2024-04-17 14:06:22 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/fix-realtime-units-6.7_2024-04-17

for you to fetch changes up to 9c69d1c725391f9a65fa8d6d2be337466918e248:

xfs_{db,repair}: use m_blockwsize instead of sb_blocksize for rt blocks (2024-04-17 14:06:23 -0700)

----------------------------------------------------------------
xfsprogs: convert utilities to use new rt helpers [03/20]

The patches in this series clean up a lot of realtime space usage code
the userspace utilities.  This involves correcting incorrect type usage,
renaming variables to reflect their actual usage; and converting open
code logic to use the new helpers that were just added to libxfs.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (11):
xfs_repair: fix confusing rt space units in the duplicate detection code
libxfs: create a helper to compute leftovers of realtime extents
libxfs: use helpers to convert rt block numbers to rt extent numbers
xfs_repair: convert utility to use new rt extent helpers and types
mkfs: convert utility to use new rt extent helpers and types
xfs_{db,repair}: convert open-coded xfs_rtword_t pointer accesses to helper
xfs_repair: convert helpers for rtbitmap block/wordcount computations
xfs_{db,repair}: use accessor functions for bitmap words
xfs_{db,repair}: use helpers for rtsummary block/wordcount computations
xfs_{db,repair}: use accessor functions for summary info words
xfs_{db,repair}: use m_blockwsize instead of sb_blocksize for rt blocks

db/check.c               | 89 +++++++++++++++++++++++++++++++++++++-----------
libxfs/init.c            |  8 ++---
libxfs/libxfs_api_defs.h |  8 +++++
libxfs/logitem.c         |  3 +-
libxfs/trans.c           |  3 +-
mkfs/proto.c             | 41 +++++++++++++++-------
repair/agheader.h        |  2 +-
repair/dinode.c          | 21 +++++++-----
repair/globals.c         |  4 +--
repair/globals.h         |  4 +--
repair/incore.c          | 16 ++++-----
repair/incore.h          | 15 ++++----
repair/incore_ext.c      | 74 +++++++++++++++++++++-------------------
repair/phase4.c          | 16 ++++-----
repair/phase6.c          | 28 +++++++++++----
repair/rt.c              | 63 +++++++++++++++++++++++-----------
repair/rt.h              |  6 ++--
repair/scan.c            |  2 +-
18 files changed, 261 insertions(+), 142 deletions(-)

