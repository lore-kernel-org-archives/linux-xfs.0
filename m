Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264FA31D75A
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 15:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757087957; cv=none; b=LokV9AmvXdCUSyN4mLXB2ORcW8M+HB295pv8xZdm1DM4lyPpqLkC3VDmv9p2lDUJkHk0x6cDgyIo2Z6GsEjOX9RFQvX9iwiwJU7QJ837nvePb+30+LE08SZv9TW6Bk43oPG+p44TeadWcwBG705UDXZgmjwoxBKVqyu9a7xi0ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757087957; c=relaxed/simple;
	bh=YjUcQoGPTz16kaFeIozLFET57awL+hTkJvwLGDXrMY4=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=G9jg8fm/UXqioNfrYIGg6RNYqyDOrl+FzzagCHVpy0V0RZDuYwqQCz0LqW+SUQecaNWPmJQa9ydtAKdv8t4CH0NnA1HD0h5s61lAcpfr6Sb0HoRz2p8tS9qCKCAZ4H92GYegYW80ogjbYcl4qRyKUVd+a0KtPnwqSybHwljVLZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUUdWhhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUUdWhhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C47C4CEF1;
	Fri,  5 Sep 2025 15:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757087957;
	bh=YjUcQoGPTz16kaFeIozLFET57awL+hTkJvwLGDXrMY4=;
	h=Date:Subject:From:To:Cc:From;
	b=IUUdWhhX4A5YaTqI4yHxywzbD6/SE9Vq3iHZlTL/SC4Qw8Fw/AEmxy0o4pRU2eUuY
	 XLA+LJNVvtE1uPQatVxVpYcyxmhLxQjVGXiYaFcPN4RjIXzwLb6LrMGuG2s12nEBk5
	 88jsNh0u8d6kjgtrKBXWCaA5OOxASMRC5usdVYH4Mjct/BpQ2visFS8FlWNu+Fhsqh
	 b0UonM2qODt//JScWeCUb2oOnv1zyPEXari7mvTECQN6GBzRZH33yaptH137LDy8rk
	 Rby54stTijM81pQPyolbxb81Kpv5DoeN40mu6akYvFwmfLdO0/9TUEtgSC7p+mItAb
	 E1SaoEKiy6Jig==
Date: Fri, 05 Sep 2025 08:59:16 -0700
Subject: [GIT PULL 6.18 2/2] xfs: kconfig and feature changes for 2025 LTS
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org, preichl@redhat.com
Message-ID: <175708766783.3403120.8622863816662379875.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 07c34f8cef69cb8eeef69c18d6cf0c04fbee3cb3:

xfs: use deferred reaping for data device cow extents (2025-09-05 08:48:23 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/kconfig-2025-changes_2025-09-05

for you to fetch changes up to 0ff51a1fd786f47ba435ede6209046959bad54a8:

xfs: enable online fsck by default in Kconfig (2025-09-05 08:48:24 -0700)

----------------------------------------------------------------
xfs: kconfig and feature changes for 2025 LTS [6.18 v2 2/2]

Ahead of the 2025 LTS kernel, disable by default the two features that
we promised to turn off in September 2025: V4 filesystems, and the
long-broken ASCII case insensitive directories.

Since online fsck has not had any major issues in the 16 months since it
was merged upstream, let's also turn that on by default.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: disable deprecated features by default in Kconfig
xfs: remove deprecated mount options
xfs: remove deprecated sysctl knobs
xfs: enable online fsck by default in Kconfig

fs/xfs/xfs_linux.h                |  2 --
fs/xfs/xfs_mount.h                | 12 ++++----
fs/xfs/xfs_sysctl.h               |  3 --
Documentation/admin-guide/xfs.rst | 57 ++++++-------------------------------
fs/xfs/Kconfig                    | 22 ++++----------
fs/xfs/libxfs/xfs_attr_leaf.c     | 23 ++++-----------
fs/xfs/libxfs/xfs_bmap.c          | 14 ++-------
fs/xfs/libxfs/xfs_ialloc.c        |  4 +--
fs/xfs/libxfs/xfs_inode_util.c    | 11 -------
fs/xfs/libxfs/xfs_sb.c            |  9 ++----
fs/xfs/xfs_globals.c              |  2 --
fs/xfs/xfs_icache.c               |  6 ++--
fs/xfs/xfs_iops.c                 | 12 ++++----
fs/xfs/xfs_mount.c                | 13 ---------
fs/xfs/xfs_super.c                | 60 ++-------------------------------------
fs/xfs/xfs_sysctl.c               | 29 +------------------
16 files changed, 43 insertions(+), 236 deletions(-)

