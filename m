Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F756B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYJzEr1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD1FC433C8;
	Sun, 31 Dec 2023 19:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051379;
	bh=WhimTHfYGI6yAlTMoKZlmKC/WAs78SQ6wxoA3OrojMc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mYJzEr1Y9pzYmDmkHgi0hzyys08EYazx4gZJ+ZQwGJIW7K1OH8N1b5A3MIbSueblt
	 PahpJGJC+Hq4aE8W8CoVhe1udnWykU9mHi3wyEH/N4EtbM+mG7Yt/DxJid7thFYdru
	 GUm5+rclRjHVB9Sb8BjVFS/eQp5bTrEM+k3S3K+EmUXfElQlWj7JO1YHT8ObZb/l/H
	 z7RZOXkUZLUybWmCp7NQlkwh38mucWjrgUayMfc0LwBuG0Pyj2rdO5O3J0Oz2XOfhi
	 yRGqmpSwBLB6sRKX1bxrhS48R+O1KWB5dbngTiwM+KS7ZP3TYn9jan0ujlAm3R3COL
	 lPJm5MNlJYEZw==
Date: Sun, 31 Dec 2023 11:36:18 -0800
Subject: [PATCHSET v2.0 07/15] xfs: enable in-core block reservation for rt
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847925.1764226.3996380045217070282.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

In preparation for adding reverse mapping and refcounting to the
realtime device, enhance the metadir code to reserve free space for
btree shape changes as delayed allocation blocks.

This effectively allows us to pre-allocate space for the rmap and
refcount btrees in the same manner as we do for the data device
counterparts, which is how we avoid ENOSPC failures when space is low
but we've already committed to a COW operation.

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
 fs/xfs/libxfs/xfs_ag.c       |    4 -
 fs/xfs/libxfs/xfs_ag_resv.c  |   25 ++---
 fs/xfs/libxfs/xfs_ag_resv.h  |    2 
 fs/xfs/libxfs/xfs_errortag.h |    4 +
 fs/xfs/libxfs/xfs_imeta.c    |  191 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h    |   11 ++
 fs/xfs/libxfs/xfs_types.h    |    7 ++
 fs/xfs/scrub/repair.c        |    5 -
 fs/xfs/xfs_error.c           |    3 +
 fs/xfs/xfs_fsops.c           |   39 +++++----
 fs/xfs/xfs_fsops.h           |    2 
 fs/xfs/xfs_inode.h           |    3 +
 fs/xfs/xfs_mount.c           |   10 ++
 fs/xfs/xfs_mount.h           |    1 
 fs/xfs/xfs_rtalloc.c         |   23 +++++
 fs/xfs/xfs_rtalloc.h         |    5 +
 fs/xfs/xfs_super.c           |    6 -
 fs/xfs/xfs_trace.h           |   46 ++++++++++
 18 files changed, 337 insertions(+), 50 deletions(-)

