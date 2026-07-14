Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E6D35DA6A
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 08:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784019171; cv=none; b=r35ryj0SWnqRRoUmgi/bsDEtGC5S/r8eO4zKjp9E9aAce9V8GvsHs8KXX25ET5pB5wz7IIny/sBkVroJcy0i/SOYMwXoViTgcXML0gFglY3rN6nDQjBHWi1D4ScsJ3DNbC1Gfcu7hjhMeLC7m1PHvB5k9AfyOA6aMbgi7Ye+tpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784019171; c=relaxed/simple;
	bh=MRxZN58RCNS6CBVnVZDbllFBtxSUh1WP4Y+7nGJNF5Y=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ueHT00DUYIsrfDSvEku7dRxwUkgfpt4GL35748YK3l5YpMliwaYwEgkfh8hOaGeEOGkwT7JphoOjzKUxNszBKxKLTYh5b8YTOAv9Sd3MckJkhmKlR26fN4OcEds5yefcNcmX3jezQ175uAvZHsgi/OXkJqnysDrUdTbmynosSrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OYXxA7pp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OYXxA7pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4FE1F000E9
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 08:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784019170;
	bh=XqmmF3/D5yerfgUF8tE/1n0rjtBYmiry9ETKhdvsHv0=;
	h=Date:From:To:Subject;
	b=OYXxA7ppxPsFq/u98LPmI94+qipbmrwcUD/m4r+FfKnWBJTxCE9qOJAZ9SxWlYE7J
	 NFW+vyiHrGRkG/dSCv49NDD3KilY9v+RoH1EUnKNjO1xC0zTf2SN79Tthdukk4uYKN
	 g9k0DMP8HIVbffIB1Xiz9LyPYQuFNTH36cXdUj8+HA0ntUzRDulF7HHidLprzYBG2j
	 FfGPCMkaoV0PURrMCyxkXKc+Gq7SH0dA/ZXRKLryq8Z3cvJUi8BplyfDXE66wAzBd5
	 zWZdAGjeFZEVrVqSBENh9uZUTmbHiE38tLzV8hNk1JO1fbJp8JS2NFk6BLWfxlO4WM
	 HJVExrvcssP/g==
Date: Tue, 14 Jul 2026 10:52:46 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 11b039aa588b
Message-ID: <alX4xI5R8pG26dug@nidhogg.toxiclabs.cc>
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

11b039aa588b xfs: don't zap bmbt forks if they are MAXLEVELS tall

16 new commits:

Andrey Albershteyn (1):
      [9202ee546b0c] xfs: fix null pointer dereference in tracepoint

Darrick J. Wong (15):
      [ba5ea85a15bd] xfs: resample the data fork mapping after cycling ILOCK
      [6703032e46d1] xfs: don't replace the wrong part of the cow fork
      [13b496c74f27] xfs: make cow repair somewhat flaky when debugging knob enabled
      [0296824c9c8a] xfs: move cow_replace_mapping to xfs_bmap_util.c
      [9303ae0254cd] xfs: don't wrap around quota ids in dqiterate
      [21d7bae20902] xfs: use rtrefcount btree cursor in xchk_xref_is_rt_cow_staging
      [339221cf2071] xfs: use the rt version of the cow staging checker
      [356205a8c4bd] xfs: write the rg superblock when fixing it
      [4225af2efb21] xfs: grab rtrmap btree when checking rgsuper
      [1abdcea06bc3] xfs: set xfarray killable sort correctly
      [9d2bf2d60b31] xfs: fix off-by-one error when calling xchk_xref_has_rt_owner
      [86b7d76a1a4d] xfs: handle non-inode owners for rtrmap record checking
      [96869cc20ddd] xfs: fully check the parent handle when it points to the rootdir
      [5b75dcb0766d] xfs: clamp timestamp nanoseconds correctly
      [11b039aa588b] xfs: don't zap bmbt forks if they are MAXLEVELS tall

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
