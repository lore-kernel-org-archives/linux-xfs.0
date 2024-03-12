Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B0978286
	for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254319; cv=none; b=Wl90Qy9wuRuj5dqvkUbCkutc6WmKLjzGlG1qouWrbunjqxcbMV0/lGsL031jHhau3p8kHvQ8y9+ePTVwdkuKV6Dg4sHh8NGugOci5w8Scm2ZR0xqrg2NfOrt0L5HOcjfIDBMTAp4Ddq3kDUZZP263sPgM7gOJH9rROm1/c1uC/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254319; c=relaxed/simple;
	bh=XL3+k/y/DQuQRT4hzFN0I9mNNGtKmhnjIxH6vLM+EQk=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=htiS2MVMiGapXcm4ACPabK0aeIA2tJejmzIlutq4SyLC5SprxTBijzPRp9G9o3+K032V6Rh9u1i3Lh6+xBuul1sVuBvwFD9p4T81pVNaIkHCY78wiFIudPi3cSnSR+XPX6cY/Jt3o9lslA8oBnGbN2ukuUs+VROEDAa+qjP17J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me; spf=pass smtp.mailfrom=maiolino.me; dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b=HyTaY8I5; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maiolino.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b="HyTaY8I5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maiolino.me;
	s=protonmail; t=1710254300; x=1710513500;
	bh=EmvoJb9t+ULApoN/diS0TXT7/mqK7KQm4wQTbX8XObc=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=HyTaY8I57Y+9bvIqdXIPtke/En+we7yS6oGRNnIwjZvBQYaMGinJrZEUpwDfsQM13
	 s1dOh2X6O8k2tsBYzYdyl7wnCqBs/bNpGI/pjQBlHPfbPE1bLCe+6SDLTF9XveYrCq
	 gAdK+Nn5nndgsOHY0MZQkSRoL+q3grcWy0nuBzCsEFaX0H6Ll1X8tbYoTT6erlw0l4
	 opbd2y6uQLXUirD0f7aCdVKaSfViVRNXx0y1csThCIouzmXP6T72PZdtX0X8YYI5eI
	 NNOwtlzPvs+vzJcT/G9eQAJSh0wMPtfeHrBBMBQhhPApqJfVnnUCC3tZWoTv8MFhQl
	 +R/qaUpE8a9mA==
Date: Tue, 12 Mar 2024 14:38:05 +0000
To: linux-xfs@vger.kernel.org
From: Carlos Maiolino <carlos@maiolino.me>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 127b66a4d
Message-ID: <kj4r4hxnifrr5oxpbn7wvabasyg4xpi46j2bauo6auqzs7mlsl@oi2ed6v373au>
Feedback-ID: 28765827:user:proton
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------cefba3c8be0a68da1d08470580405f31247be73a75606ffe5fc9789beaf84655"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------cefba3c8be0a68da1d08470580405f31247be73a75606ffe5fc9789beaf84655
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Mar 2024 15:38:02 +0100
From: Carlos Maiolino <carlos@maiolino.me>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 127b66a4d
Message-ID: <kj4r4hxnifrr5oxpbn7wvabasyg4xpi46j2bauo6auqzs7mlsl@oi2ed6v373au>
MIME-Version: 1.0
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

127b66a4d8afc6f3dfe8929c01b1f1e63c1ebf31

5 new commits:

Bastian Germann (1):
      [86f3757ae] debian: Increase build verbosity, add terse support

Darrick J. Wong (1):
      [127b66a4d] xfs_db: don't hardcode 'type data' size at 512b

Sam James (2):
      [ebe85b803] io: Adapt to >= 64-bit time_t
      [9dae86dce] build: Request 64-bit time_t where possible

Violet Purcell (1):
      [9e726740f] Remove use of LFS64 interfaces

Code Diffstat:

 copy/xfs_copy.c           |  2 +-
 db/block.c                |  3 ++-
 db/io.c                   |  3 ++-
 debian/rules              |  4 ++++
 fsr/xfs_fsr.c             |  2 +-
 include/builddefs.in      |  4 ++--
 io/bmap.c                 |  6 +++---
 io/copy_file_range.c      |  4 ++--
 io/cowextsize.c           |  6 +++---
 io/fadvise.c              |  2 +-
 io/fiemap.c               |  6 +++---
 io/fsmap.c                |  6 +++---
 io/io.h                   | 10 +++++-----
 io/madvise.c              |  2 +-
 io/mincore.c              |  2 +-
 io/mmap.c                 | 13 +++++++------
 io/pread.c                | 22 +++++++++++-----------
 io/pwrite.c               | 20 ++++++++++----------
 io/reflink.c              |  4 ++--
 io/seek.c                 |  6 +++---
 io/sendfile.c             |  6 +++---
 io/stat.c                 |  8 ++++----
 io/sync_file_range.c      |  2 +-
 io/truncate.c             |  2 +-
 libxfs/rdwr.c             |  8 ++++----
 mdrestore/xfs_mdrestore.c |  2 +-
 repair/prefetch.c         |  2 +-
 scrub/spacemap.c          |  6 +++---
 spaceman/freesp.c         |  4 ++--
 spaceman/trim.c           |  2 +-
 30 files changed, 88 insertions(+), 81 deletions(-)

--------cefba3c8be0a68da1d08470580405f31247be73a75606ffe5fc9789beaf84655
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wnUEARYIACcFAmXwaMwJEOk12U/828uvFiEEj32Dn/1+aNUZzl9s6TXZT/zb
y68AAOg4AQCdLhjr+hZq4ApuQF45ts7R+HO7v33Xr3Yp5/gOclWv3wD/cJ+E
k7qYY6Fe3O4pYWN6XMnJIgA5O8HPi/6J8qNzyAg=
=nQqV
-----END PGP SIGNATURE-----


--------cefba3c8be0a68da1d08470580405f31247be73a75606ffe5fc9789beaf84655--

