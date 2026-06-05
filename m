Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCB63955F3
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jun 2026 09:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780653503; cv=none; b=ecnEsUCrmhy995vdsd6NRSlx2fJvnLDSJYPlqRj+Ue2wBXtu8OFXOghaC2ofLAvp+DwY6qsOL6jOYVF4ip6oKAxr2R/iTzHUMBztXIMQYd39Vk3urPJ/JUU+aEseHnTsgdz4313QPzCIIdH6iOX7Fj1ZDqUBWJYICrsZKw22ePA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780653503; c=relaxed/simple;
	bh=+UhjZpC8XiYxZoikwE/XZRugsHuLd2WwguLQ9/GqIHM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kW/6t0Kbh3LHKhUXoEkdSsvs0NWkXgQC3gxbJQZsMjOIxmR72Q8yYpCxxpSzKxf3wGURFaP5HJ47jlERsLioXQsD5oLOAWzmGKnLeWdbvz/bTZdmGHPs0TACAsqV5IQ3J4Ic7ove0X5ko298ZrUBXkwnkYzokQw4yWPrTkNziRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnYIMbdp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnYIMbdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194331F00893;
	Fri,  5 Jun 2026 09:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780653501;
	bh=0iFCnrvsFhemrGh87eMYtm0if4vajmnjdpsuCau0CTI=;
	h=Date:From:To:Cc:Subject;
	b=nnYIMbdpIF5Nw/MDQNxjYfWLt+nVTXetzTACpknebXUdIrDWiJEA56170x0+kf+RA
	 ICKRSXfbKLzpm7OGRjuKpo7zdHEyO5v12A35wsvW20leMpY1LJ0wCTFHnZ4fQZNGSZ
	 XpI6uek8UpgKosdeWtkZJddfCHET5qvRDKcT9a+6Yx04I2WPZR8sicHj/SPsd+Zjjo
	 n8uUoYi+MpKaXadhfbkH4zQ4YRMRlLa/13B0HVZTIJQYgsXI0OVbrlirrAXAZfFi/w
	 QaQifhcGAKA9H3boIrh++4fCPIsdW26MIEOhXpPWQDMR9YrW1c1PbamE3friufVcxW
	 FnHYFTsZN4zsQ==
Date: Fri, 5 Jun 2026 11:58:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.1-rc7
Message-ID: <aiKcvJ5B_vMKZSup@nidhogg.toxiclabs.cc>
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

This includes a collection of fixes mostly towards the RT device,
including a small refactor that has no functional change.

An attempt merge against your current TOT has been successful.

Thanks,
Carlos

"The following changes since commit 8339dd0e5090f092c525c5e04b2a75ec5e5305a6:

  Merge tag 'xfs-fixes-7.1-rc5' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux into test_merge (2026-05-23 16:15:18 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.1-rc7

for you to fetch changes up to dabfaca8140f64535a79020f0f86ea56f5db5bb2:

  xfs: Remove mention of PageWriteback (2026-05-30 08:26:18 +0200)

----------------------------------------------------------------
xfs: fixes for v7.1-rc7

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (3):
      xfs: drop the RTG reference later in xfs_ioc_rtgroup_geometry
      xfs: factor rtgroup geom write pointer reporting into a helper
      xfs: abort mount if xfs_fs_reserve_ag_blocks fails

Dai Ngo (2):
      xfs: fix use of uninitialized imap in xfs_fs_map_blocks error path
      xfs: fix overlapping extents returned for pNFS LAYOUTGET

Hans Holmberg (1):
      xfs: handle racing deletions in xfs_zone_gc_iter_irec

Matthew Wilcox (Oracle) (1):
      xfs: Remove mention of PageWriteback

Yingjie Gao (2):
      xfs: fix error returns in CoW fork repair
      xfs: fix rtgroup cleanup in CoW fork repair

 fs/xfs/scrub/cow_repair.c | 12 +++---------
 fs/xfs/xfs_ioctl.c        | 47 +++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_mount.c        |  7 +++++--
 fs/xfs/xfs_pnfs.c         | 11 +++++++----
 fs/xfs/xfs_reflink.c      | 14 +++++++-------
 fs/xfs/xfs_zone_gc.c      |  2 +-
 6 files changed, 50 insertions(+), 43 deletions(-)"
