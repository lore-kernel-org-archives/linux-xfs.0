Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AFF31D74B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 15:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087732; cv=none; b=qt+I/95ubG1LggNvbQs+9VaukEbm7qj6bozjWslLz5xJJ53vjYKJNbxwF4ZZ0Hrwo6mTpeu679D/eOcPYEygEKdDZk2S1v3vGt2EccjYRIuSKFP4ahvGInbKUlcAJPbHA8BeXuTy9iZ/akxmEsrYtV6PU77FENtWhuIBu3RKOOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087732; c=relaxed/simple;
	bh=kabeK1kX5yDYfHH0tdtp9vVqU5y1p62RiLMcKGDYgAA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ifRVzokzOA+7ZOlMWINJcC/kK0d0ZCRQMHQkQdNTPgBJoRVLOIklmPknTNgZfiEUXS/P+b4OyAxVxo3U0TkC8y5qHKm1AlwqVUt08CoxB0NuiP0oLIVGGYjoMAXHZkKm8/X+Rc+N2uRvh7LtlQp+kDQGskiiF9GN6DQZQxR5Wbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qecz/VWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qecz/VWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A36C4CEF1;
	Fri,  5 Sep 2025 15:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087732;
	bh=kabeK1kX5yDYfHH0tdtp9vVqU5y1p62RiLMcKGDYgAA=;
	h=Date:Subject:From:To:Cc:From;
	b=Qecz/VWCQevdwpcTd8JW38o1m5KqknGhVgf93JrWVUxG5cgVoU5nXllBsoXgbWoHr
	 PrCdyTu8FMctsq5vCCv+zO74RwmK/9BtqISUMyvfQk6UqDLmIeyjo/YVnZo7G7pCNV
	 XlC0DNBWrUiZEqmpx8PD98ncW5bTipxMHI2lkoifGocbIu88l4OdMKRTHNFE0ED9tQ
	 XwKPZbqh212cVlsJu85ouKZ42gmLLUIuLmUJdX3M5Pc/rUdwPhscYmcUgNbcmgxtuS
	 1OnHzSMzSKKckkG04YGliLM9JkgEWm4wtMFEXX1X6PeAPGpJBwtGR0+oMXRTt0uWbZ
	 UL1Q9v6uDAqkw==
Date: Fri, 05 Sep 2025 08:55:31 -0700
Subject: [PATCHSET 6.18 v2 2/2] xfs: kconfig and feature changes for 2025 LTS
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, preichl@redhat.com, linux-xfs@vger.kernel.org
Message-ID: <175708765462.3402932.11803651576398863761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Ahead of the 2025 LTS kernel, disable by default the two features that
we promised to turn off in September 2025: V4 filesystems, and the
long-broken ASCII case insensitive directories.

Since online fsck has not had any major issues in the 16 months since it
was merged upstream, let's also turn that on by default.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=kconfig-2025-changes
---
Commits in this patchset:
 * xfs: disable deprecated features by default in Kconfig
 * xfs: remove deprecated mount options
 * xfs: remove deprecated sysctl knobs
 * xfs: enable online fsck by default in Kconfig
---
 fs/xfs/xfs_linux.h                |    2 -
 fs/xfs/xfs_mount.h                |   12 ++++---
 fs/xfs/xfs_sysctl.h               |    3 --
 Documentation/admin-guide/xfs.rst |   57 +++++------------------------------
 fs/xfs/Kconfig                    |   22 ++++----------
 fs/xfs/libxfs/xfs_attr_leaf.c     |   23 +++-----------
 fs/xfs/libxfs/xfs_bmap.c          |   14 ++-------
 fs/xfs/libxfs/xfs_ialloc.c        |    4 +-
 fs/xfs/libxfs/xfs_inode_util.c    |   11 -------
 fs/xfs/libxfs/xfs_sb.c            |    9 ++----
 fs/xfs/xfs_globals.c              |    2 -
 fs/xfs/xfs_icache.c               |    6 +---
 fs/xfs/xfs_iops.c                 |   12 +++----
 fs/xfs/xfs_mount.c                |   13 --------
 fs/xfs/xfs_super.c                |   60 +------------------------------------
 fs/xfs/xfs_sysctl.c               |   29 +-----------------
 16 files changed, 43 insertions(+), 236 deletions(-)

