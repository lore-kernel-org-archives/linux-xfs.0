Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBEF221F0C
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039341; cv=none; b=pVJzP88w9yK68VqukUhMp/+86PEunSRVy6tZrvWUsZdIjXmMN2dEFzGyHiQGC1mTsSTeCZkmtFunx6bh21wIYLjRhzlB75g9aTmWjdpkQqVOJ+VrbTcKaWQtdzv+J1TOvofhiKgmewsO4u9l8cjoIGgyrkIKbF+jz6QFRJPgTho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039341; c=relaxed/simple;
	bh=YvMDHzDaLy/Gev0tE+3xTXdTKO9EmudkZG9YKjkpbdI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fRS91l2hjH1ZtQEhJBywGNH7nR9aSV5XCYLwOHW9ksm+QwheTxjX6aUu4iUYIiGp1jGwnm/6rrpfgbytdtMFt1rrM13J33ajSxyR1aspGa7AzeKOCZdWXncvVPBMxTkF4QEiWfk8qzxPtu/QxDEEQK5WjntItRqlEj1bzyXyRwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IdX0KbYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IdX0KbYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1B1C4CEF1
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761039341;
	bh=YvMDHzDaLy/Gev0tE+3xTXdTKO9EmudkZG9YKjkpbdI=;
	h=Date:From:To:Subject:From;
	b=IdX0KbYkLm7fu6q5f2PkKjcP1j/khRdDNBm3dTBeCUYPuT7cW2QrB990nPZjE8Hha
	 AK22RHwwk183ggfNqF9F+bb3EqeI6wIypPB1ZfbJFF+Owgm7JzjCjAE0D4uAbRPOn3
	 pu5mqhfae+Y09rhMPk9Dz8Ygkh24/OccrS50RIaarFriqepK1+TAsZMKKTcGhZjBn8
	 CNoYuWswV7Buj8nK60MGkkcdrFvu5YZbAvjvt1H7GXB95/VoRBQWVZ8XmME5wBMtkN
	 Pe+c3fvJ/McYh9GA7S5ETCOdu+KBGttEXzKyDb809rPx1eEIHxtDHPU7h8DzJa06x/
	 bkuMM6r/SLZaQ==
Date: Tue, 21 Oct 2025 11:35:37 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 0f41997b1b2b
Message-ID: <ucid7qzb2e34ydc5ay4xt6oekqvw4c5d5kfskoont7gezmbozu@ippdbguippu6>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

My apologies for the quick rebase on top of the previous update, but
three of the patches were added by mistake as they are not ready yet, so
this rebase remove such patches.

The new head of the for-next branch is commit:

0f41997b1b2b xfs: don't use __GFP_NOFAIL in xfs_init_fs_context

6 new commits:

Christoph Hellwig (3):
      [a8c861f401b4] xfs: avoid busy loops in GCD
      [ca3d643a9701] xfs: cache open zone in inode->i_private
      [0f41997b1b2b] xfs: don't use __GFP_NOFAIL in xfs_init_fs_context

Damien Le Moal (2):
      [914f377075d6] xfs: Improve CONFIG_XFS_RT Kconfig help
      [b00bcb190eef] xfs: do not tightly pack-write large files

Geert Uytterhoeven (1):
      [f5caeb3689ea] xfs: XFS_ONLINE_SCRUB_STATS should depend on DEBUG_FS

Code Diffstat:

 fs/xfs/Kconfig          |  11 +++-
 fs/xfs/xfs_mount.h      |   1 -
 fs/xfs/xfs_super.c      |   8 ++-
 fs/xfs/xfs_zone_alloc.c | 148 ++++++++++++++++++++----------------------------
 fs/xfs/xfs_zone_gc.c    |  81 ++++++++++++++------------
 fs/xfs/xfs_zone_priv.h  |   2 +
 6 files changed, 125 insertions(+), 126 deletions(-)
