Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937B81292E5
	for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2024 13:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708089055; cv=none; b=QEVoPG+0fJgBXOE5Tg1Ku4+H+XtyQZwBBghAMhHjTnLGECsWtIGaPo2NVKjB4LxakqQyB82bda7wRS8BeJ5fwDVWEzo+/2rNclf6kA+g8dUzlOi59UBSzZyTq+pDU1NdpsGUvn6G7k4C8rQ91097xSnK5Q5UvVWzdRwJ4TidYCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708089055; c=relaxed/simple;
	bh=jbvXXrATI9ogILURXDvZLB2uAwpUrNB1CypBZXDh/mg=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=T19yYrz4TIlu0kt+Npvel386hjMcg0152TlaU8NA61bDEIm/kVc/9m4hEigS9hCesihjws/vRr+qdLWAlyFqHtqyX+stkSToUfjmYYq6DyJrf2nlegiBcZbgU7kFBQbIMwqtmkspZFIeG4tPUvtlMu3xXDqVC/6oBotdxe0xCTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me; spf=pass smtp.mailfrom=maiolino.me; dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b=jeFE4Sv2; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maiolino.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b="jeFE4Sv2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maiolino.me;
	s=protonmail; t=1708089026; x=1708348226;
	bh=h9ES/3NrOVIicxvVP+alybeLux8fX9YrggO9Ghhp3Ns=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=jeFE4Sv2SRrvgkCSXZRUB7w0u2KUkbrjrdcGSb6rnMHAwZbRBv3xSOEQTR0+v+nkH
	 nYMPa97qSdIIEb2ltjzcQCOZEkaP0Y3dtXXS6hoZoSimrob3Mydk2jmgZQrWS1EQmL
	 7iqWG0e9jOQNd+cHCnuDIV3XW1m2/DJ8mKccyXhqkUTO2IqX143y4IKes1iZ/ixNqA
	 CyNcn9Fe9rO9fgax8bJAI0YOLbXQDaEw834oyXbxB08VUHEA/JTbEVwl6og8NOb6Bf
	 bgMYTRA9cVVQWBH89fF22d8IoAuImC+mCScTmAnuaCPwd8/7xBgJvlmmCuu77mkEX2
	 4n60ZNRPfeMKQ==
Date: Fri, 16 Feb 2024 13:10:15 +0000
To: linux-xfs@vger.kernel.org
From: Carlos Maiolino <carlos@maiolino.me>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 53d96fc6b
Message-ID: <lqvwplz5ztgxyxwju3gqikulgoji5d7sksn4uhlanlsfxtrhsr@uylkawjxhbjw>
Feedback-ID: 28765827:user:proton
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------2836d9625e5a36dec9d0e6a3b8905aebbf8e6103853ed38e849181585c667737"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------2836d9625e5a36dec9d0e6a3b8905aebbf8e6103853ed38e849181585c667737
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Feb 2024 14:10:11 +0100
From: Carlos Maiolino <carlos@maiolino.me>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 53d96fc6b
Message-ID: <lqvwplz5ztgxyxwju3gqikulgoji5d7sksn4uhlanlsfxtrhsr@uylkawjxhbjw>
MIME-Version: 1.0
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

This update containes exclusively a libxfs-sync for Linux 6.7.
I'll try to do a new push most late on Monday with patches already queued up.


Carlos


The new head of the for-next branch is commit:

53d96fc6b19415dfe1dedcf95099b3333ae4fe92

35 new commits:

Darrick J. Wong (27):
      [e2b01f5c2] xfs: bump max fsgeom struct version
      [4dbd57621] xfs: hoist freeing of rt data fork extent mappings
      [06d168b5b] xfs: fix units conversion error in xfs_bmap_del_extent_delay
      [a8616431b] xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
      [73b5e7703] xfs: convert xfs_extlen_t to xfs_rtxlen_t in the rt allocator
      [75986bcbc] xfs: convert rt bitmap/summary block numbers to xfs_fileoff_t
      [3fb28b11a] xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
      [95bc0a4d2] xfs: rename xfs_verify_rtext to xfs_verify_rtbext
      [817e92371] xfs: convert rt extent numbers to xfs_rtxnum_t
      [48afbdc52] xfs: create a helper to convert rtextents to rtblocks
      [43ed0e42a] xfs: create a helper to compute leftovers of realtime extents
      [a01e6467b] xfs: create a helper to convert extlen to rtextlen
      [1dac259cf] xfs: create helpers to convert rt block numbers to rt extent numbers
      [b261e7937] xfs: convert do_div calls to xfs_rtb_to_rtx helper calls
      [a5dc53fef] xfs: create rt extent rounding helpers for realtime extent blocks
      [5afaf8203] xfs: use shifting and masking when converting rt extents, if possible
      [75e15fbcb] xfs: convert the rtbitmap block and bit macros to static inline functions
      [18b4102ae] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
      [c1f9bc4bc] xfs: convert open-coded xfs_rtword_t pointer accesses to helper
      [ccffd2f94] xfs: convert rt summary macros to helpers
      [3789ac007] xfs: create helpers for rtbitmap block/wordcount computations
      [3d763f980] xfs: create a helper to handle logging parts of rt bitmap/summary blocks
      [f4a0432b7] xfs: use accessor functions for bitmap words
      [75805b294] xfs: create helpers for rtsummary block/wordcount computations
      [b16c5a811] xfs: use accessor functions for summary info words
      [ae3912187] xfs: simplify xfs_rtbuf_get calling conventions
      [93b4decb3] xfs: simplify rt bitmap/summary block accessor functions

Dave Chinner (2):
      [f827e51c9] xfs: consolidate realtime allocation arguments
      [53d96fc6b] xfs: inode recovery does not validate the recovered inode

Jeff Layton (1):
      [bb16db6ad] xfs: convert to new timestamp accessors

Long Li (2):
      [bb98a33c1] xfs: factor out xfs_defer_pending_abort
      [97165047c] xfs: abort intent items when recovery intents fail

Omar Sandoval (3):
      [52273f22c] xfs: cache last bitmap block in realtime allocator
      [35c3aa608] xfs: invert the realtime summary cache
      [8fdde9dd4] xfs: fix internal error from AGFL exhaustion

Code Diffstat:

 db/check.c               |   5 +-
 include/libxfs.h         |   1 +
 include/xfs_inode.h      |  74 ++++-
 include/xfs_mount.h      |   2 +
 libxfs/libxfs_api_defs.h |   1 +
 libxfs/libxfs_priv.h     |  79 ++---
 libxfs/util.c            |   2 +-
 libxfs/xfs_alloc.c       |  27 +-
 libxfs/xfs_bmap.c        |  44 +--
 libxfs/xfs_defer.c       |  28 +-
 libxfs/xfs_defer.h       |   2 +-
 libxfs/xfs_format.h      |  34 +-
 libxfs/xfs_inode_buf.c   |  13 +-
 libxfs/xfs_rtbitmap.c    | 809 ++++++++++++++++++++++++++---------------------
 libxfs/xfs_rtbitmap.h    | 386 ++++++++++++++++++++++
 libxfs/xfs_sb.c          |   2 +
 libxfs/xfs_sb.h          |   2 +-
 libxfs/xfs_trans_inode.c |   2 +-
 libxfs/xfs_trans_resv.c  |  10 +-
 libxfs/xfs_types.c       |   4 +-
 libxfs/xfs_types.h       |  10 +-
 mkfs/proto.c             |   2 +-
 repair/rt.c              |   5 +-
 23 files changed, 1043 insertions(+), 501 deletions(-)
 create mode 100644 libxfs/xfs_rtbitmap.h

--------2836d9625e5a36dec9d0e6a3b8905aebbf8e6103853ed38e849181585c667737
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wnUEARYIACcFAmXPXrYJEOk12U/828uvFiEEj32Dn/1+aNUZzl9s6TXZT/zb
y68AAMvpAPsHYZcyS1qiNX8LXY1KP0OZqCinxba+j074YpyAbaBFBwD+IG+L
XPLLVHKjMMQgG3kVE6Ffapmb9LnMlHjos4Zw5wI=
=GIJw
-----END PGP SIGNATURE-----


--------2836d9625e5a36dec9d0e6a3b8905aebbf8e6103853ed38e849181585c667737--

