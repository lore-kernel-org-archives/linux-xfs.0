Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929DCDDDC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 00:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051432; cv=none; b=ZLEtbSWyoLVVxifzh2WOjFpDgykyIfWw6UV7vrY1T59CxtcUzbLUu1O8klTLb+5p7dAEC8x1c+wM/HJdWqjUDdU6pmtsVOmInrNo7gQmlm8V0yWhHK6LPJNS7ldITFDSjYYPavI0/lGOcAi9ewKCQWWcCCLyp4QR7QawgJRAaSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051432; c=relaxed/simple;
	bh=Z9c/euzo2J2tCiy1P1Ku79dD8zSrcFc/Rm4cHAQE+24=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WAVlaTrygu+rKBB9n4hwHc+voYi0HVEYNTgvZu5AqKYW4hPiJw2pYPul/rusdXg65XJPbNH87m0EFD9orn+LCSqPq6Wfh0Bn8fT0qf/OLfLj+GfHqE3fLj7egfju4bwud4GzNa/7IgQRXmNPi18Lc7DfeThefudAdwCpxryVEaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c3Yvywcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c3Yvywcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CE6C4CED3;
	Fri, 13 Dec 2024 00:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051432;
	bh=Z9c/euzo2J2tCiy1P1Ku79dD8zSrcFc/Rm4cHAQE+24=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c3YvywcjKjZ8AfRl/A1FBP/kQeU16i5r4Ulku29K3Hz3E8LB059f0WxvWW7L9Zlup
	 U7KWnOXYcRW2vkY78VA/Xa5cisfPrIPBScbaSwKjLOODHK0ZPkxOuEjZGJV0uR8x43
	 tLqcjvvc70DCTIP9UPDoAFfHkadVB9pTWDOu25VLG6Z4oKUAk+Ku6i0nfG+0RR5sS/
	 oQOMMWqPNgJeqApZMxFdMxJhKg2fgNC5sheNJot/9A8mNtQvmHxKVucgnXzyiDJY0H
	 btKHi/nrHIQWFwdS4wtDeHcnKAw0O5jzzEabpaP5ujhYYSh7v9LpHQ8h1PgRDu+CBC
	 zyRqSLHij3LpQ==
Date: Thu, 12 Dec 2024 16:57:11 -0800
Subject: [PATCHSET v6.0 2/5] xfs: enable in-core block reservation for rt
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405122694.1181241.15502767706128799927.stgit@frogsfrogsfrogs>
In-Reply-To: <20241213005314.GJ6678@frogsfrogsfrogs>
References: <20241213005314.GJ6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

In preparation for adding reverse mapping and refcounting to the
realtime device, enhance the metadir code to reserve free space for
btree shape changes as delayed allocation blocks.

This enables us to pre-allocate space for the rmap and refcount btrees
in the same manner as we do for the data device counterparts, which is
how we avoid ENOSPC failures when space is low but we've already
committed to a COW operation.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reserve-rt-metadata-space

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=reserve-rt-metadata-space
---
Commits in this patchset:
 * xfs: prepare to reuse the dquot pointer space in struct xfs_inode
 * xfs: allow inode-based btrees to reserve space in the data device
---
 fs/xfs/libxfs/xfs_ag_resv.c  |    3 +
 fs/xfs/libxfs/xfs_attr.c     |    4 -
 fs/xfs/libxfs/xfs_bmap.c     |    4 -
 fs/xfs/libxfs/xfs_errortag.h |    4 +
 fs/xfs/libxfs/xfs_metadir.c  |    4 +
 fs/xfs/libxfs/xfs_metafile.c |  205 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_metafile.h |   11 ++
 fs/xfs/libxfs/xfs_types.h    |    7 +
 fs/xfs/scrub/tempfile.c      |    1 
 fs/xfs/xfs_dquot.h           |    3 +
 fs/xfs/xfs_error.c           |    3 +
 fs/xfs/xfs_exchrange.c       |    3 +
 fs/xfs/xfs_fsops.c           |   17 +++
 fs/xfs/xfs_inode.h           |   16 +++
 fs/xfs/xfs_mount.c           |   10 ++
 fs/xfs/xfs_mount.h           |    1 
 fs/xfs/xfs_qm.c              |    2 
 fs/xfs/xfs_quota.h           |    5 -
 fs/xfs/xfs_rtalloc.c         |   21 ++++
 fs/xfs/xfs_rtalloc.h         |    5 +
 fs/xfs/xfs_trace.h           |   45 +++++++++
 fs/xfs/xfs_trans.c           |    4 +
 fs/xfs/xfs_trans_dquot.c     |    8 +-
 23 files changed, 367 insertions(+), 19 deletions(-)

