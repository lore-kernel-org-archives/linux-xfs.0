Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F029370D75
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 16:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784217975; cv=none; b=uTcrM7vbSJ4QiGmT3KDzDVSztUedplxZF+ChG84YRmEuYhM4+iOaE2EYdaskY90qy/v7ddYRwH5Uu7ahj7K0C49zFwwwrnNETi508nm7QIqJ6onts2Yg8mVe9ZCYKh1+Z4J/9V+dIhbgIQAnLJjaLzrxaXgoqa+0YuEEAXFpN44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784217975; c=relaxed/simple;
	bh=fhmjoWEFEAu+H48AwGtQz11W9XtZiZC5LTdJteUpaKs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bn3XzkqOBPnPkJ1OmlssgdE8P8kXFyb11GvN/3SgzptpEsfu8O3azorJ/GyYpxp3CP7ZdqLD73x5Kz44G6LxPJN2Pt99W9cdRu7toHPoIxR4dhsO+Yt+DTYSaPA5USscKGajF16ccHuztP8H+aAQdFixJBl/r8BZJIrdxITJch8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BwshQ1ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BwshQ1ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDBD1F000E9;
	Thu, 16 Jul 2026 16:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784217973;
	bh=IvuSe7m6Rf4SfgR0u4Yt9MYKy5rWMzw0uFnPM9zHZl4=;
	h=Date:From:To:Cc:Subject;
	b=BwshQ1ck0YYlBR8tT+8XgqTZededNTegmA3cAf4wvbs0f4qv/FH8Me+NaUG2wTziB
	 AZna6DeoIJff/kVk1qRRRZlIH7BUhEe6H6a29iYuynnyN7cIw9I/zR4Om+YbqikL3y
	 21xbz69MEjH/b5j8iT2kXwtIghNctVj/Q9sJ8+/mnxbewWmAd6LrLS9+gnvsj7UJUe
	 jv8AXx5BVPuFCKd4zBB5vnlHofgprEY3WpCLkQ1nS73hWsnHlOFxlLbpqhOSU04fiV
	 S3mK6g7rjYIIHMXwS5ST5fieJLXv+ctjDzON8UQDibQZbChQU1exBS9WL+eyhCS7Ft
	 vlNUMqaaXxaww==
Date: Thu, 16 Jul 2026 18:06:09 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.2-rc4
Message-ID: <alkAOxMdRvYOKSm2@nidhogg.toxiclabs.cc>
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

This contains mostly a series of bug fixes found by different LLM models

Thanks,
Carlos

"The following changes since commit e4281086ae6caf006b6ef0670479eb5f96880fb9:

  xfs: simplify __xfs_buf_ioend (2026-07-01 12:29:50 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.2-rc4

for you to fetch changes up to 59c462b0f5cfa107794228051724b34ae9334168:

  xfs: don't zap bmbt forks if they are MAXLEVELS tall (2026-07-14 11:01:47 +0200)

----------------------------------------------------------------
xfs: fixes for v7.2-rc4

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Andrey Albershteyn (1):
      xfs: fix null pointer dereference in tracepoint

Cen Zhang (1):
      xfs: tie zoned sysfs lifetime to zone info

Darrick J. Wong (15):
      xfs: resample the data fork mapping after cycling ILOCK
      xfs: don't replace the wrong part of the cow fork
      xfs: make cow repair somewhat flaky when debugging knob enabled
      xfs: move cow_replace_mapping to xfs_bmap_util.c
      xfs: don't wrap around quota ids in dqiterate
      xfs: use rtrefcount btree cursor in xchk_xref_is_rt_cow_staging
      xfs: use the rt version of the cow staging checker
      xfs: write the rg superblock when fixing it
      xfs: grab rtrmap btree when checking rgsuper
      xfs: set xfarray killable sort correctly
      xfs: fix off-by-one error when calling xchk_xref_has_rt_owner
      xfs: handle non-inode owners for rtrmap record checking
      xfs: fully check the parent handle when it points to the rootdir
      xfs: clamp timestamp nanoseconds correctly
      xfs: don't zap bmbt forks if they are MAXLEVELS tall

Jinliang Zheng (1):
      xfs: use xfs_csn_t for xlog_cil_push_now() push_seq parameter

Weiming Shi (3):
      xfs: drop ASSERT(0) on unrecognized log item type
      xfs: splice unsorted log items back to the transaction after the loop
      xfs: fail recovery on a committed log item with no regions

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
 fs/xfs/xfs_log_cil.c        |   2 +-
 fs/xfs/xfs_log_recover.c    |  26 +++++--
 fs/xfs/xfs_reflink.c        |  36 +++++++++
 fs/xfs/xfs_sysfs.c          |  28 ++++---
 fs/xfs/xfs_sysfs.h          |   2 +
 fs/xfs/xfs_trace.h          |  41 ++++++++++
 fs/xfs/xfs_zone_alloc.c     |   8 ++
 21 files changed, 339 insertions(+), 168 deletions(-)"
