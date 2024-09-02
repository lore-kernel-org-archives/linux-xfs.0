Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15241A3AA4
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725302571; cv=none; b=JGvW/BlJhvO02dbs0zq6Sq0Wg8FV1WRs/wYYd7xohG+r7GKSWGO4InsqAqyWUQhrmsQ1Ih7/KzhYMYq0sGQ1D77V1yKIW3nmjos5qLoP5acUbt4NmooePUWAtxvXLftZcsS+5qmu4pw+ebZ1jwSk/Y0IQ6YtzCYKy+eSCeFaz6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725302571; c=relaxed/simple;
	bh=f8grYn2+lK3Nk2Yei7tiCmxSs8D5EYasaC9dBKvC2zw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=fTJ9sD5vcLCIL3IpULwg+Lz7X7gvBekDDzZmRQHlwHJBcDAUZm+cDETSABLvl3fd/liGsRo4nPnCOpO6JkKbF0zHMOjleaRwp8/FTLDfubR2W/5hWWZxe17UAiyIWMMKE5pkU748eKXieNiN/zWc1BlwzaDMMnmHtErys5osS3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cMg9faI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cMg9faI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA2DC4CEC2;
	Mon,  2 Sep 2024 18:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725302571;
	bh=f8grYn2+lK3Nk2Yei7tiCmxSs8D5EYasaC9dBKvC2zw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cMg9faI/vXedhTTe2+ToX1nMPlP2ZZSWHMroDxCEDrfZiYIdXEnGleb9kBta/IgMA
	 HOQ/7G2v1zmMLqBQb5VZDo2kReHNXTQWLZyJguhvE8It+G7wXInTG1/T15HoumqjVJ
	 t45y8gfUjR4d9iGi0YjEDaZ4STOCB6PeNFDlVLQBqziFT7GCT7q5EIqxlTwkuPUPcy
	 FjNtlfCh8YE+hmchDzx2AofpF0ETdgafLhV+/UrYzuXgEwYa5mxTEtNOBwGdW7QM8R
	 BXGPuSw5EMSQWqpmgW7I06sh0AJxt/fJYo0w/HqMox9ti9A/DzEIfIf6X15Iep2N12
	 Y9+kho7aIrHLQ==
Date: Mon, 02 Sep 2024 11:42:50 -0700
Subject: [GIT PULL 5/8] xfs: cleanups for the realtime allocator
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172530248351.3348968.12421656957345647056.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240902184002.GY6224@frogsfrogsfrogs>
References: <20240902184002.GY6224@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.12-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit df8b181f1551581e96076a653cdca43468093c0f:

xfs: simplify xfs_rtalloc_query_range (2024-09-01 08:58:19 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/rtalloc-cleanups-6.12_2024-09-02

for you to fetch changes up to 2ca7b9d7b80810b2b45b78b8a4b4fa78a1ddc2dd:

xfs: move xfs_ioc_getfsmap out of xfs_ioctl.c (2024-09-01 08:58:19 -0700)

----------------------------------------------------------------
xfs: cleanups for the realtime allocator [v4.2 5/8]

This third series cleans up the realtime allocator code so that it'll be
somewhat less difficult to figure out what on earth it's doing.  We also
rearrange the fsmap code a bit.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (7):
xfs: clean up the ISVALID macro in xfs_bmap_adjacent
xfs: factor out a xfs_rtallocate helper
xfs: rework the rtalloc fallback handling
xfs: factor out a xfs_rtallocate_align helper
xfs: make the rtalloc start hint a xfs_rtblock_t
xfs: remove xfs_{rtbitmap,rtsummary}_wordcount
xfs: replace m_rsumsize with m_rsumblocks

Darrick J. Wong (3):
xfs: add xchk_setup_nothing and xchk_nothing helpers
xfs: rearrange xfs_fsmap.c a little bit
xfs: move xfs_ioc_getfsmap out of xfs_ioctl.c

fs/xfs/libxfs/xfs_bmap.c        |  55 +++---
fs/xfs/libxfs/xfs_rtbitmap.c    |  33 +---
fs/xfs/libxfs/xfs_rtbitmap.h    |   7 -
fs/xfs/libxfs/xfs_trans_resv.c  |   2 +-
fs/xfs/scrub/common.h           |  29 +--
fs/xfs/scrub/rtsummary.c        |  11 +-
fs/xfs/scrub/rtsummary.h        |   2 +-
fs/xfs/scrub/rtsummary_repair.c |  12 +-
fs/xfs/scrub/scrub.h            |  29 +--
fs/xfs/xfs_fsmap.c              | 402 ++++++++++++++++++++++++++--------------
fs/xfs/xfs_fsmap.h              |   6 +-
fs/xfs/xfs_ioctl.c              | 130 -------------
fs/xfs/xfs_mount.h              |   2 +-
fs/xfs/xfs_rtalloc.c            | 246 ++++++++++++++----------
14 files changed, 477 insertions(+), 489 deletions(-)

