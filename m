Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C20613A416
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717444484; cv=none; b=pvJb5FzCYgUGh1EKPj+yLVAe2YQCV64Xh511Btvzt2B8JpBaofjr1oieQGBFuNn8SwCylAxL0ZZCMLkrUHDFiN/bbuEb1lkW2MVaVuVcfdC0zqCGrTgkrZezYQpmzFFTwI+VLqNsZ9/wtHvdAvmRHGQ/tK5JcpWC/eLY4AFh5Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717444484; c=relaxed/simple;
	bh=g6dKkJFG8mg/Yd0PGFiYnHUPNRljZv4a4SdToIvQOlo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=pLHJtDZyPoxV9Gb6SdrxuErdQ6mV5Yw5s7kx310W/pLyN/KJtglsfeGxG6uZe0WVdyytyZ81mZ4GVYPCdtMOCqn9TtgyOW1KCKtqoMvxpyouyy9lVRbl11rYtxz/JgraeGPuGpF/L/0UB5Xy7aRiPeQKpj9bs8Zw6KPUcVYCAqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rttRxWos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rttRxWos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEBDC2BD10;
	Mon,  3 Jun 2024 19:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717444484;
	bh=g6dKkJFG8mg/Yd0PGFiYnHUPNRljZv4a4SdToIvQOlo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rttRxWos2v/ympV2vuohlvs26bH4gR/NTqzH1Y8ooVlpHOdl8bxxdOWBtzPOhWlIh
	 QDZNfo0zuCLkc9bG/Rtj+aJY7X1eYhAG1bHv2nzXlJYTC0BtkUWemql059E+SZc4vY
	 ABGACo2fpvEmxXLznob1yivTNcKKLhFub9XbnDQubUKYGZqCCRd4AixzNMmBceqVb0
	 PDrnfyDBeUs5QHMgEgLLBinYgLxl3rN95yEI7Zh4cDI5b2Rw1jci0JVkL1LaIS7cZY
	 fPgI2iG7iVTYpJ3Cd0oDeBhAld2va/H+Vhf6kPADP2dUKAUePHWkn70bjMr8NgyQsX
	 pvRmfWz22JP/g==
Date: Mon, 03 Jun 2024 12:54:43 -0700
Subject: [GIT PULL 01/10] libxfs: prepare to sync with 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171744443322.1510943.12835634898661730134.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240603195305.GE52987@frogsfrogsfrogs>
References: <20240603195305.GE52987@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit df4bd2d27189a98711fd35965c18bee25a25a9ea:

xfsprogs: Release v6.8.0 (2024-05-17 13:20:34 +0200)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/libxfs-6.9-sync-prep_2024-06-03

for you to fetch changes up to 493d04e97479b36f34a895171ed852cd2e3298b2:

libfrog: create a new scrub group for things requiring full inode scans (2024-06-03 11:37:35 -0700)

----------------------------------------------------------------
libxfs: prepare to sync with 6.9 [v30.5 01/35]

Apply some cleanups to libxfs before we synchronize it with the kernel.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
libxfs: actually set m_fsname
libxfs: clean up xfs_da_unmount usage
libfrog: create a new scrub group for things requiring full inode scans

io/scrub.c        |  1 +
libfrog/scrub.h   |  1 +
libxfs/init.c     | 24 +++++++++++++++++-------
scrub/phase5.c    | 22 ++++++++++++++++++++--
scrub/scrub.c     | 33 +++++++++++++++++++++++++++++++++
scrub/scrub.h     |  1 +
scrub/xfs_scrub.h |  1 +
7 files changed, 74 insertions(+), 9 deletions(-)

