Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D0833D5
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738278; cv=none; b=a0ueXo1mXoJtEAXVDJxwwjunDPkdzsT6PrKJjWIQtoqnNZo8b5Tu8ss6O9z0DFrtxOJConWjuxwmWDbgDaD0dMWyULQtI/LoHTMUQh3Enxpk/s7Xsr5xr0h3q+pWh04h2V78dP/0eLRX99oFEAgO+VNz0k7vR4MQFXf4jyAJu5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738278; c=relaxed/simple;
	bh=SUxXk/d6Di34HzOP+BqlV+rya6+1jiTshokluM59l9k=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=batjZeiutFbmKef1lCTej6Ph0rH1ttkdKGwoWuKdgGNgianHm/UwKOYKk7YUYnajbbmVMu0qN6x8PpS8NZwIs2AOPzptT8zy2T3JKglm8hKVXfz+LAHRr/7pNnU7O9CPEErp9L5w6SCrslg2cfN0Y9L+AyrxU9ExMTbzQvIjoC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7sROnav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7sROnav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0EBC433F1;
	Sat, 24 Feb 2024 01:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738278;
	bh=SUxXk/d6Di34HzOP+BqlV+rya6+1jiTshokluM59l9k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o7sROnav25IeN3sApW7vENlMI5LXx+77GDVZRrCk1Wv+m2RF5fyvXTd4XhRGr5QLU
	 DAk5PeTdDMairJoc1CFmeuaHPq0ttlv14JaKjQoc4S3kfSkDwXJ4TqCL/O5puzou+Z
	 O+/Cspnnt6VPHVKMS7QG+0xhq6JWyNKCGg+Is8g4PU2+hcEOBoknjbhzqPBNCxI3fJ
	 qy1noBPlwthyP/Zxr1rDT+I62HXrDnudpdJkeBMfrtcmgVomAfYlfpie1nZTt6XC6T
	 BexZPz2FyFiLeXFnrQEpqf4EKboMSX+cDOavLiHHg2YjQdFyZW6TW/Nys3DPxxTiX2
	 ubEZRDvbsRmTw==
Date: Fri, 23 Feb 2024 17:31:18 -0800
Subject: [GIT PULL 9/18] xfs: btree check cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873803840.1891722.16794150368300526439.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit ec793e690f801d97a7ae2a0d429fea1fee4d44aa:

xfs: remove xfs_btnum_t (2024-02-22 12:40:51 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/btree-check-cleanups-6.9_2024-02-23

for you to fetch changes up to 79e72304dcba471e5c0dea2f3c67fe1a0558c140:

xfs: factor out a __xfs_btree_check_lblock_hdr helper (2024-02-22 12:40:59 -0800)

----------------------------------------------------------------
xfs: btree check cleanups [v29.3 09/18]

Minor cleanups for the btree block pointer checking code.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (10):
xfs: simplify xfs_btree_check_sblock_siblings
xfs: simplify xfs_btree_check_lblock_siblings
xfs: open code xfs_btree_check_lptr in xfs_bmap_btree_to_extents
xfs: consolidate btree ptr checking
xfs: misc cleanups for __xfs_btree_check_sblock
xfs: remove the crc variable in __xfs_btree_check_lblock
xfs: tighten up validation of root block in inode forks
xfs: consolidate btree block verification
xfs: rename btree helpers that depends on the block number representation
xfs: factor out a __xfs_btree_check_lblock_hdr helper

fs/xfs/libxfs/xfs_alloc_btree.c    |   8 +-
fs/xfs/libxfs/xfs_bmap.c           |   2 +-
fs/xfs/libxfs/xfs_bmap_btree.c     |   8 +-
fs/xfs/libxfs/xfs_btree.c          | 252 ++++++++++++++++++-------------------
fs/xfs/libxfs/xfs_btree.h          |  44 ++-----
fs/xfs/libxfs/xfs_ialloc_btree.c   |   8 +-
fs/xfs/libxfs/xfs_refcount_btree.c |   8 +-
fs/xfs/libxfs/xfs_rmap_btree.c     |   8 +-
fs/xfs/scrub/btree.c               |  21 +---
9 files changed, 159 insertions(+), 200 deletions(-)

