Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717C135966
	for <linux-xfs@vger.kernel.org>; Sat, 30 May 2026 06:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780122908; cv=none; b=tu3OnL4T1n0SUHzQe+8psZaYPTL4pg1RGYtt2IeU2pPbOA3q01pBhibDTYkF//QB1RO3FMYvWBalSUbfUhRjrkeSDT4tFS/Co3e7MQD0kDQxXqUiD7d9WkFto7/iGIXUQlWwJuS77RjtnYw+t+XeS78xaCQ7iMJwS8+FPuaLiIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780122908; c=relaxed/simple;
	bh=BzzGyUDx4B8et40NvWdt4RVCLps91ae/oVlXdYaUQwU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RnVYlRSIIUT/cCDqToxouA50ZngYc3LBC2ozPj1rx6AWC0dlazMp4gsFuAlpHFvjfHW4Oto3WAVgwCzAr7YEdK6zpWOiUMBf1SQWu8TAH6iQKH2fUP+iKg8D+8PL9aSB9cysKXd5YO4x+1r/ExhhAim5mpNUczqZ0jiemOlRPA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kvAzqN9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvAzqN9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D78F1F00893
	for <linux-xfs@vger.kernel.org>; Sat, 30 May 2026 06:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780122907;
	bh=pnXTzDUEel2vFqlnjNnJjpbTI+dLxdyxigujx6B47QY=;
	h=Date:From:To:Subject;
	b=kvAzqN9qRZdK+o+XQly8BjgT+UkIAPExyvvpWrLCPNHAAlX3MUK1irSd6Cp0l1ToJ
	 zBaUwzhiP57HdXwwo34LOU+ZxR55jABvkSzIoCCWZJ3zRxIWHnR2bQGidDrYlZ/RuV
	 2ouP0BAT45KUmtlPfqb8NWS8MYJ0TuxNx0O8Ib/LBMUr+f12Jaqwk8vvzjmxs3bS00
	 6I1Cq6sEj0NdKxkddekbuL+YzYKybeQAtY/iVv8wjK+vEGEz4Dwr1IRkS3l3D0zbFQ
	 pKN10LM1s24DWAupvwqbgT3+bw8qAtxIDwVWHvwDVgS0qFeP1loNJCpYMIMfgrztin
	 YkQbxPHfAhs4A==
Date: Sat, 30 May 2026 08:35:03 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next **REBASED** to dabfaca8140f
Message-ID: <ahqEd3riQNrXWlzz@nidhogg.toxiclabs.cc>
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

has just been **REBASED**.

FWIW, I had a problem with my testing system and I couldn't properly
test those patches for this -rc, I'll send those patches early next
week.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

dabfaca8140f xfs: Remove mention of PageWriteback

9 new commits:

Christoph Hellwig (3):
      [c316bb56bf4d] xfs: drop the RTG reference later in xfs_ioc_rtgroup_geometry
      [2fa29c1a1677] xfs: factor rtgroup geom write pointer reporting into a helper
      [8070a50b8897] xfs: abort mount if xfs_fs_reserve_ag_blocks fails

Dai Ngo (2):
      [97bdbf2613eb] xfs: fix use of uninitialized imap in xfs_fs_map_blocks error path
      [36ca6f11424a] xfs: fix overlapping extents returned for pNFS LAYOUTGET

Hans Holmberg (1):
      [bc95fa240a1b] xfs: handle racing deletions in xfs_zone_gc_iter_irec

Matthew Wilcox (Oracle) (1):
      [dabfaca8140f] xfs: Remove mention of PageWriteback

Yingjie Gao (2):
      [fcf4faba9f98] xfs: fix error returns in CoW fork repair
      [c3e073894379] xfs: fix rtgroup cleanup in CoW fork repair

Code Diffstat:

 fs/xfs/scrub/cow_repair.c | 12 +++---------
 fs/xfs/xfs_ioctl.c        | 47 +++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_mount.c        |  7 +++++--
 fs/xfs/xfs_pnfs.c         | 11 +++++++----
 fs/xfs/xfs_reflink.c      | 14 +++++++-------
 fs/xfs/xfs_zone_gc.c      |  2 +-
 6 files changed, 50 insertions(+), 43 deletions(-)
