Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C29305045
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 08:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768552967; cv=none; b=g0aHdlrh2XVfxmH92GVSOHRW3Q7AvtVYBmePU+sqGIraBndWaJsFQ4etILMyhBgUyoavrhDH8AFjTFVfLDqxzgKHoIZoDX64XfT/FQlrr6eVDKS/0VOOkhNri9y9H3rnZvhleG8L5lLBkPPxqRiWj/4JQ43f7seYz9Ifa+kwmwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768552967; c=relaxed/simple;
	bh=KYACjmyW918SPd7Yl5GSZIs+Mrll5qpLDvZRJ0xHj4I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=j2Et7BMp7Q11BzFRoMNUZhGrwDlrF0CAm4jfGZdAGaXR1oRl1HZwWJnLjFlONC5gPGpm3xn7Vqh+oHlXJy3d7OwDqX2SZjLPFnshvLnizO2R2gDXNxM6v0RJwuWbsWkJ7RVGOWnUjpzTtVSvoyn1JXaRpqhSWFBKCBgCdsrul4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogLlz5G8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogLlz5G8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7801C116C6;
	Fri, 16 Jan 2026 08:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768552966;
	bh=KYACjmyW918SPd7Yl5GSZIs+Mrll5qpLDvZRJ0xHj4I=;
	h=Date:From:To:Cc:Subject:From;
	b=ogLlz5G8Qv+lbqFJlAb1RIvvRRa2D9qF1F1oUan+vCPzGRe1SRY38yqqIckqxiWSJ
	 ELxz9SUJY39xbYsHHlEuCE2Hxn/xTLYNznKCRqMR8wCp6swRPYOekvLTx/CfAzJNhQ
	 7l0BVYiPo54PVGbMW79P1iPdfIWqVf1Ta8HOtsZVDLFXg/fkYcQyE0neVmKZYVI85Q
	 LufrTFOZDpxtSFzQxXwYdJAkhB/t6YCaRKQ5LiWonrLSskDeNr+KALROXP45ZfIc//
	 2s/fyRYaAnllEA1WaXWhifn0fxK9RUxMWTOQJGHFjdNvmm36PwTut3tvM4dzO9bYyI
	 bTiVUyK1xb8cQ==
Date: Fri, 16 Jan 2026 09:42:43 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v6.19-rc6
Message-ID: <aWnwAp-ev5kagXmo@nidhogg.toxiclabs.cc>
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

There is nothing special about this pull request, just a few obvious
fixes and some 'cosmetic' changes.

While these patches are not yet on the linux-next, I've been testing
them for a while now and I didn't want to wait until the last minute to
send them to v6.19.

Thanks,
Carlos

"The following changes since commit dc68c0f601691010dd5ae53442f8523f41a53131:

  xfs: fix the zoned RT growfs check for zone alignment (2025-12-17 10:27:02 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.19-rc6

for you to fetch changes up to c360004c0160dbe345870f59f24595519008926f:

  xfs: set max_agbno to allow sparse alloc of last full inode chunk (2026-01-13 10:45:55 +0100)

----------------------------------------------------------------
xfs: fixes for v6.19-rc6

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Brian Foster (1):
      xfs: set max_agbno to allow sparse alloc of last full inode chunk

Christoph Hellwig (3):
      xfs: mark __xfs_rtgroup_extents static
      xfs: fix an overly long line in xfs_rtgroup_calc_geometry
      xfs: improve the assert at the top of xfs_log_cover

Dan Carpenter (1):
      xfs: fix memory leak in xfs_growfs_check_rtgeom()

Nirjhar Roy (IBM) (2):
      xfs: Fix the return value of xfs_rtcopy_summary()
      xfs: Fix xfs_grow_last_rtg()

 fs/xfs/libxfs/xfs_ialloc.c  | 11 +++++-----
 fs/xfs/libxfs/xfs_rtgroup.c | 53 +++++++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_rtgroup.h |  2 --
 fs/xfs/xfs_log.c            |  8 ++++---
 fs/xfs/xfs_rtalloc.c        |  6 ++---
 5 files changed, 41 insertions(+), 39 deletions(-)"
