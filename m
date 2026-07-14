Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1525543CEFD
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 09:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020805; cv=none; b=CsPdw9NkwNZLv0NNL8mwWsMZSzZsfFFs941zuhekVdqGDCB32HgzX33XjZhe5yUC/mno0c6B+/IodNJj96HsGNbbuAYHhVsCGvON6s3FyYtqCBoF53WTO2/9H/j2uIxzLyfDI8pElMCL3X5EEOFtmS+fZm7zUQUPL/8HY3IQY6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020805; c=relaxed/simple;
	bh=xKwCzuxcGP6m/D280sEV1GQaafmyKwkShCpfohy7xdY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=McIowFnCdPY+iY3wM9zPpZPAOpiRsractlOUcE3NCnjBPOxe4Ty31W9dEZWgNHZLwqUpaXIQga+MyoBfCrNrrg/2mtEx24JyIYHD0dTTMlxoLNXoM3/TU9kQcb9O1bU8ZABBCZGfEp5SHjSS5aUwnzR2fblWq1yZ0elzjrAMwJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARamMpAM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARamMpAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B781F000E9
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 09:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020804;
	bh=bUppdkcVVx5HxeLhShlH3kMVKhydz5NNIr2ah5R3KJQ=;
	h=Date:From:To:Subject;
	b=ARamMpAMW2TVwkDsI9WwLO1HKORarBch4te/fsM0oz0w+9PAKy6TZFkFl2YjhhqyG
	 BPPo+V6G7mI1AC3QQyyZ272xr0Ce9z53vu80o2gsK9SReipIcJ2VsZewwnQ1rvIcs9
	 RjV+a+qRPvOjyIeVmA+jWQZzeh3YCOfipygd6wz77GBlj8Hebsibdh2kg9yChAlz3N
	 KT0WumZE+WcEyjt6twsSAQzwOoMzZDEDTxoqEnrLQKqhrV7GszFnPum4NU98aC/mcJ
	 KS21uhvyFpIwKke0AloSIYDiZu6e14gcSCuIs81dv8/Ag3GSKyW9rxIOKfCQIjrhwk
	 5cL5vKJKTbXew==
Date: Tue, 14 Jul 2026 11:20:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 59c462b0f5cf
Message-ID: <alX-zGY2VuvxZFxL@nidhogg.toxiclabs.cc>
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

My apologies for the extra announce. There are no changes between this and
the previous one, only a coupl tags that I missed adding on the previous patches.

The new head of the for-next branch is commit:

59c462b0f5cf xfs: don't zap bmbt forks if they are MAXLEVELS tall

16 new commits:

Andrey Albershteyn (1):
      [9202ee546b0c] xfs: fix null pointer dereference in tracepoint

Darrick J. Wong (15):
      [2f4acd0fcd86] xfs: resample the data fork mapping after cycling ILOCK
      [a1caeeadbf57] xfs: don't replace the wrong part of the cow fork
      [bcb0621204e6] xfs: make cow repair somewhat flaky when debugging knob enabled
      [60a1dde9d289] xfs: move cow_replace_mapping to xfs_bmap_util.c
      [d766e4e5e85d] xfs: don't wrap around quota ids in dqiterate
      [ee248157da50] xfs: use rtrefcount btree cursor in xchk_xref_is_rt_cow_staging
      [881f2eb0fcde] xfs: use the rt version of the cow staging checker
      [9af789fa274b] xfs: write the rg superblock when fixing it
      [ea6e2d9de25d] xfs: grab rtrmap btree when checking rgsuper
      [540ddc626245] xfs: set xfarray killable sort correctly
      [5d72a68f2007] xfs: fix off-by-one error when calling xchk_xref_has_rt_owner
      [353a5900bc85] xfs: handle non-inode owners for rtrmap record checking
      [ba150ce63453] xfs: fully check the parent handle when it points to the rootdir
      [15e38a9366b3] xfs: clamp timestamp nanoseconds correctly
      [59c462b0f5cf] xfs: don't zap bmbt forks if they are MAXLEVELS tall

Code Diffstat:

 fs/xfs/libxfs/xfs_defer.c   |   2 +-
 fs/xfs/scrub/cow_repair.c   | 177 +++++++++++++++++++++-----------------------
 fs/xfs/scrub/dirtree.c      |  16 ++--
 fs/xfs/scrub/dqiterate.c    |   2 +-
 fs/xfs/scrub/inode_repair.c |   4 +-
 fs/xfs/scrub/rgsuper.c      |  14 +++-
 fs/xfs/scrub/rtbitmap.c     |   2 +-
 fs/xfs/scrub/rtrefcount.c   |   2 +-
 fs/xfs/scrub/rtrmap.c       |   8 +-
 fs/xfs/scrub/scrub.h        |   6 +-
 fs/xfs/scrub/trace.h        |  35 ---------
 fs/xfs/scrub/xfarray.c      |   3 +-
 fs/xfs/xfs_bmap_util.c      |  89 ++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h      |   4 +
 fs/xfs/xfs_reflink.c        |  36 +++++++++
 fs/xfs/xfs_trace.h          |  41 ++++++++++
 16 files changed, 293 insertions(+), 148 deletions(-)
