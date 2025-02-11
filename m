Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B841E5734
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 08:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739263481; cv=none; b=EAZOdC6Mv4pKIF32kI1L4Vavo6/KbxL9yngnibFJuiTLBI777E3NRlQRhn7CuOthKW9FoXXASufWmdEdsSpexfALNmnEQ0JaiCVxjE+emre+pJId8MTwKN7sJiglx1AmOAqq59agy/yJRpY/8Gkfd+giOTaBBQuvTO47CCGglJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739263481; c=relaxed/simple;
	bh=5XMHUbddiiU6PWOBVesb8NMdwLkxYcB9Jh0opzorLw8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pINeu1ud7EE1DSrJn9XqOgnH2vCMHZC/xPsUFx8k7JQdkggBfcISSfsOdKnGFxU9pGZkpq/F71vUyR1V4YJPzrhb72ZbgwVHvFP9/2V2uHihEa+nQK+Zbnvp5io8OEYqA22rYqpSBlWPcICcMXXozrGuFua7xgWEg7DmAbCb2aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHl86sKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHl86sKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D774C4CEDD
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 08:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739263481;
	bh=5XMHUbddiiU6PWOBVesb8NMdwLkxYcB9Jh0opzorLw8=;
	h=Date:From:To:Subject:From;
	b=LHl86sKUcrCdq/JYssCdSZ2kR3TqJcz66QpHyq1AN020gGDhG+FY0W93k9vu+5Lqx
	 nPrrqZNzXHB/M/m7B6bbvSceNrjAjkwqBFXxxcmOg1CAKPnqsLU6gBucMS7gpyCFEO
	 rmfTrvxIit5ez9bopb03SH+uKtve9HjvqAvugy0JwZwrCI+n+qJDcOv2kCWSb0+7EB
	 bNJsn9qyqG1pnGlpDotRSXwlbnTU9fYGOdp92u7OUP21g0D7+kl8VR4gdrG9Adxvqd
	 8y/WGI06jh0RXvoLEbJRlX6kVidiL+eKg6wU/RM/73h7I0A4I4hXlqqdy7VWWtVDin
	 R1f2taCeY3jag==
Date: Tue, 11 Feb 2025 09:44:36 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 35010cc72acc
Message-ID: <ibywlmce6lhsmkgbil2m2ltkz4cmqqaaihkejahdlmkq4qlydi@seoyagz2usal>
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

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

35010cc72acc xfs: flush inodegc before swapon

7 new commits:

Carlos Maiolino (2):
      [84ea4c9d978b] Merge tag 'fixes-6.14_2025-02-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into next-rc
      [18df3ca14c34] xfs: Do not allow norecovery mount with quotacheck

Christoph Hellwig (2):
      [6f7ce473cca4] xfs: rename xfs_iomap_swapfile_activate to xfs_vm_swap_activate
      [35010cc72acc] xfs: flush inodegc before swapon

Darrick J. Wong (2):
      [bc0651d93a7b] xfs: fix online repair probing when CONFIG_XFS_ONLINE_REPAIR=n
      [0ab5a2b9378b] xfs: fix data fork format filtering during inode repair

Lukas Herbolt (1):
      [263b984ae26b] xfs: do not check NEEDSREPAIR if ro,norecovery mount.

Code Diffstat:

 fs/xfs/scrub/common.h       |  5 -----
 fs/xfs/scrub/inode_repair.c | 12 ++++++++--
 fs/xfs/scrub/repair.h       | 11 ++++++++-
 fs/xfs/scrub/scrub.c        | 12 ++++++++++
 fs/xfs/xfs_aops.c           | 41 +++++++++++++++++++++++++++++----
 fs/xfs/xfs_qm_bhv.c         | 55 ++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_super.c          |  8 +++++--
 7 files changed, 114 insertions(+), 30 deletions(-)
