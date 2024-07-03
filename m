Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1AA191F91
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720042837; cv=none; b=W7614yQ4wbAOkTcUtqeSRf6I8yZGnHcBggLxf8NMzsHI5oJDZ78QhSdM3wl8Ylj8RyZVw1fQfYuEy7lzME3lnK91BTgrGUM5xvl1Vf9MVK9XkAo3xPtTWU46bKWZxv0/YnHoG7zxsyAaF4W7Dtt3SaMsK4csYUb8xSBc90SRDnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720042837; c=relaxed/simple;
	bh=rv5LIa/9ZlgWbpGsDkMI5BURzSuY0se1pRrhqyqSkKw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=T0ejP+UIoJq9lRp2mq/OPlBvyl2VE9XLtyOLNzxFOQjPqeLdh9r61xj7JetE/EeIJWV6L9hvQqL8HJjV3yt5+nJHhzaAgso8YN06ulkrokIGTxIMTPmpWC1CjoiHwa/7aV3gJU2ZxLyFbsalDhSYgtWtM5QmeSnfrCXLzzvmueM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hKrBHXj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hKrBHXj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFC8C2BD10;
	Wed,  3 Jul 2024 21:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720042837;
	bh=rv5LIa/9ZlgWbpGsDkMI5BURzSuY0se1pRrhqyqSkKw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hKrBHXj0Q8IoBxKkt6MlplVRry4Q4bB0Q4zFR6BGgDxwvfuAmGMONjdbU/oNUTSF3
	 5801FvjaeiL/Ml+vhZ8V9yx/+2kWkpYrpBvMfhl+DGLCcwgZ0otKefHJm3LtzqSopt
	 FCEZEFNDWqw7Dh/g5icozBrMGLsHbO7WqES3F5EaqUztDMBeKW2UHcyFEYscs1pgCn
	 4IZeJ34owUppKCJCPOrSMZ1ALI4bhEOkz7ZDSrAAqDkPSZeiMQxhxgJLos8rQO0BnU
	 lEhy4Kl7rL9tralL3T+NlykGUR4QBfyMW6jDEJ9GabpJAwvURKDdTkt/ztS5Ar1Z2J
	 28L54Zbcv0/Ow==
Date: Wed, 03 Jul 2024 14:40:36 -0700
Subject: [GIT PULL 2/4] xfs: extent free log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004279355.3366224.7392694697851842624.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240703211310.GJ612460@frogsfrogsfrogs>
References: <20240703211310.GJ612460@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit ac3a0275165b4f80d9b7b516d6a8f8b308644fff:

xfs: don't use the incore struct xfs_sb for offsets into struct xfs_dsb (2024-07-02 11:37:00 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/extfree-intent-cleanups-6.11_2024-07-02

for you to fetch changes up to 84a3c1576c5aade32170fae6c61d51bd2d16010f:

xfs: move xfs_extent_free_defer_add to xfs_extfree_item.c (2024-07-02 11:37:03 -0700)

----------------------------------------------------------------
xfs: extent free log intent cleanups [v3.0 2/4]

This series cleans up some warts in the extent freeing log intent code.
We start by acknowledging that this mechanism does not have anything to
do with the bmap code by moving it to xfs_alloc.c and giving the
function a more descriptive name.  Then we clean up the tracepoints and
the _finish_one call paths to pass the intent structure around.  This
reduces the overhead when the tracepoints are disabled and will make
things much cleaner when we start adding realtime support in the next
patch.  I also incorporated a bunch of cleanups from Christoph Hellwig.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (6):
xfs: pass the fsbno to xfs_perag_intent_get
xfs: add a xefi_entry helper
xfs: reuse xfs_extent_free_cancel_item
xfs: factor out a xfs_efd_add_extent helper
xfs: remove duplicate asserts in xfs_defer_extent_free
xfs: remove xfs_defer_agfl_block

Darrick J. Wong (3):
xfs: clean up extent free log intent item tracepoint callsites
xfs: convert "skip_discard" to a proper flags bitset
xfs: move xfs_extent_free_defer_add to xfs_extfree_item.c

fs/xfs/libxfs/xfs_ag.c             |   2 +-
fs/xfs/libxfs/xfs_alloc.c          |  93 ++++++++----------------------
fs/xfs/libxfs/xfs_alloc.h          |  12 ++--
fs/xfs/libxfs/xfs_bmap.c           |  12 ++--
fs/xfs/libxfs/xfs_bmap_btree.c     |   2 +-
fs/xfs/libxfs/xfs_ialloc.c         |   5 +-
fs/xfs/libxfs/xfs_ialloc_btree.c   |   2 +-
fs/xfs/libxfs/xfs_refcount.c       |   6 +-
fs/xfs/libxfs/xfs_refcount_btree.c |   2 +-
fs/xfs/scrub/newbt.c               |   5 +-
fs/xfs/scrub/reap.c                |   7 ++-
fs/xfs/xfs_bmap_item.c             |   6 +-
fs/xfs/xfs_drain.c                 |   8 +--
fs/xfs/xfs_drain.h                 |   5 +-
fs/xfs/xfs_extfree_item.c          | 115 +++++++++++++++++--------------------
fs/xfs/xfs_extfree_item.h          |   6 ++
fs/xfs/xfs_refcount_item.c         |   5 +-
fs/xfs/xfs_reflink.c               |   2 +-
fs/xfs/xfs_rmap_item.c             |   5 +-
fs/xfs/xfs_trace.h                 |  33 +++++------
20 files changed, 141 insertions(+), 192 deletions(-)

