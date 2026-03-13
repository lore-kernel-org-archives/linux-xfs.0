Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932A0349B0C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413885; cv=none; b=P8CNWmrxbGY+SQ3b55w2XM+DQ4heM3J1YrUwS/qGmIA6m2tcf39/+BAXV2sXIQJ3nZ81eTw8iVbVJBzjUy75ucOuqIKdFxgclr/+rtdwFyiuh97jVcIhitv4EleORRRrTHgEbtb+Xh/KusfkKUatdsvOLql96/m8y6dwPhy2tpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413885; c=relaxed/simple;
	bh=O7gzJ5jZ2UP3LbxHcgVu82wCJ5m9QabktWXXk7yEHUI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PLjBSxb9e6ZLSTZF604zVv5ejjjY5WglVB2oRvQ6gIP57qfyTOnQx6MXmeUMuKSxmoTONmSNwRpxTJTRYDeR7FT4Fl0Spu0B8UHsoZawV9eVG0JXMmAYydxF6OTsbu3ZLIfsrvyJDa9HUZpjokWTcUekLREE4ym7ZAWLE9srXlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=knZ2v7Ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="knZ2v7Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EA7C19421;
	Fri, 13 Mar 2026 14:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773413885;
	bh=O7gzJ5jZ2UP3LbxHcgVu82wCJ5m9QabktWXXk7yEHUI=;
	h=Date:From:To:Cc:Subject:From;
	b=knZ2v7UlG/I+44+uTI0swCj20ZSbyLPEqI4sgD1Ut0MEIu1SQdwWdxI9VPpv82Bh1
	 MFhCffeiR4sntn6GJYAnL/1WO6YTuXEWHb/1Q4TuqeYjNX2lSfxqIYTd2Td3+jDhIr
	 QmTMNhFuKoT/CoUhRxwLzVhscQWXB+AC516Mcu7PvAXXeguTYD7hhKaNeWEWAqVGnl
	 BFFSoW4aRFk2YHz+LB0kqXhO2J5Y1pmXQBXBqcIstOg99a5EJP05ST85F8qr0w+UqM
	 EIyypOO0PPSeab/Odw1zqA6avq/jBHic6XKTCLSNDdcvKGYdOWE+E8lYqa6GHcyYl5
	 fV1nj1GZVSH4A==
Date: Fri, 13 Mar 2026 15:58:01 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.0-rc4
Message-ID: <abQjwPYZiCGnCVbM@nidhogg.toxiclabs.cc>
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

Most relevant patches IMHO are a couple race fixes found on
the new healthmon mechanism, and another flushing dquots
during filesystem shutdown.

Thanks,
Carlos

"The following changes since commit 650b774cf94495465d6a38c31bb1a6ce697b6b37:

  xfs: add static size checks for ioctl UABI (2026-02-25 13:58:50 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.0-rc4

for you to fetch changes up to 362c490980867930a098b99f421268fbd7ca05fd:

  xfs: fix integer overflow in bmap intent sort comparator (2026-03-11 13:21:42 +0100)

----------------------------------------------------------------
xfs: fixes for 7.0-rc4

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Carlos Maiolino (1):
      xfs: fix returned valued from xfs_defer_can_append

Damien Le Moal (1):
      xfs: remove scratch field from struct xfs_gc_bio

Darrick J. Wong (2):
      xfs: fix race between healthmon unmount and read_iter
      xfs: fix undersized l_iclog_roundoff values

Long Li (3):
      xfs: remove redundant set null for ip->i_itemp
      xfs: ensure dquot item is deleted from AIL only after log shutdown
      xfs: fix integer overflow in bmap intent sort comparator

hongao (1):
      xfs: Remove redundant NULL check after __GFP_NOFAIL

 fs/xfs/libxfs/xfs_da_btree.c |  8 ++------
 fs/xfs/libxfs/xfs_defer.c    |  2 +-
 fs/xfs/xfs_bmap_item.c       |  2 +-
 fs/xfs/xfs_dquot.c           |  8 +++++++-
 fs/xfs/xfs_healthmon.c       | 17 ++++++++++-------
 fs/xfs/xfs_icache.c          |  1 -
 fs/xfs/xfs_log.c             |  2 ++
 fs/xfs/xfs_zone_gc.c         |  2 --
 8 files changed, 23 insertions(+), 19 deletions(-)"
