Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB601C3BFC
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 10:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739959971; cv=none; b=VmU1ukT4o7Xldq+QjXLjk4TUAwEbrNWkWBUrPC0x+YwDclmwIss6WbiwAXgd+yvKZ02KMg7wZNSAjVARffrjujlVkoC8DQmVh/uZOeHfuio2SpH594m3uIr9+4cWUgo/BKygL58eSM5iGsGSA0oBNup8ZYVtK/ztxzC+0ZMemjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739959971; c=relaxed/simple;
	bh=ZKObJc8uojNBAzmAQLFD/LZCyKCnu6dmmz85ntF+qMc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=F3c3Nv1vSPiDjtoBbA5UIfCuyc0kPWdU3eGpSg2xquGkxGUr1JnGp5tFRcaQTPuoXVlnt6fv8m6/wYudnvv+Zr/HNDOSXwI3bCQVXEXKQSFE8m6K83TggCSKc56ljcyQUELg3PC5yjTKa3YPEoeUOdxitUVmgu0XzIzuagWjRa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/I8LX69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/I8LX69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7DDC4CED1;
	Wed, 19 Feb 2025 10:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739959971;
	bh=ZKObJc8uojNBAzmAQLFD/LZCyKCnu6dmmz85ntF+qMc=;
	h=Date:From:To:Cc:Subject:From;
	b=S/I8LX69wexo2ns/LGp1dCF/9FVxln7Ec2bao0vjkSlvaYd5Vu7FkBGJLYQ9LiPrY
	 AvAQoiT4vM5QwaPwAtR/dwJFrEIzuciZGNf7BvqD13CUNNLAh1Yj5vSdAf5Kl7Atdu
	 2tMlNPBSG+Bw1EPr8fdtFLAgnolmh/6GVmG+LZ0uRyspqpAbm55lMHZ4p/HHH1Qb4E
	 AwA4Ut4toa0lE1mFY7OMNziMbw+fdkPSOpTzfh9ABMfMFVMm2Z5b7U8YQMgGkMHWjB
	 6rKVvLsz6TKh+8b8PT4PxlTTvf6C2DA25zQilSIdR6KYK2347rV+onAk/s1fyFZ1yU
	 NviTJC0IOUFig==
Date: Wed, 19 Feb 2025 11:12:47 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for v6.14-rc4
Message-ID: <rjf47upmybci3sspru25djnbnd34k5r2cybp7t3t2gqhpzkypc@6s7ntozehtmm>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

This contains just a collection of bug fixes, nothing really stands out

Thanks,
Carlos

The following changes since commit a64dcfb451e254085a7daee5fe51bf22959d52d3:

  Linux 6.14-rc2 (2025-02-09 12:45:03 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.14-rc4

for you to fetch changes up to 2d873efd174bae9005776937d5ac6a96050266db:

  xfs: flush inodegc before swapon (2025-02-14 09:40:35 +0100)

----------------------------------------------------------------
XFS: Fixes for 6.14-rc4

----------------------------------------------------------------
Carlos Maiolino (1):
      xfs: Do not allow norecovery mount with quotacheck

Christoph Hellwig (2):
      xfs: rename xfs_iomap_swapfile_activate to xfs_vm_swap_activate
      xfs: flush inodegc before swapon

Darrick J. Wong (2):
      xfs: fix online repair probing when CONFIG_XFS_ONLINE_REPAIR=n
      xfs: fix data fork format filtering during inode repair

Lukas Herbolt (1):
      xfs: do not check NEEDSREPAIR if ro,norecovery mount.

 fs/xfs/scrub/common.h       |  5 -----
 fs/xfs/scrub/inode_repair.c | 12 ++++++++--
 fs/xfs/scrub/repair.h       | 11 ++++++++-
 fs/xfs/scrub/scrub.c        | 12 ++++++++++
 fs/xfs/xfs_aops.c           | 41 +++++++++++++++++++++++++++++----
 fs/xfs/xfs_qm_bhv.c         | 55 ++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_super.c          |  8 +++++--
 7 files changed, 114 insertions(+), 30 deletions(-)

