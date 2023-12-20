Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC1B1CA93
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maiolino.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b="Bn4Xl4s3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maiolino.me;
	s=protonmail; t=1703061396; x=1703320596;
	bh=IScsvlfKqvIyRL1koZ0R/J5JsEqqrfScw3IMsXnvjgM=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Bn4Xl4s3j/ppNgsZzwNS0ZrC7Y4L2pKossBd8+wVcKA56u3Cj3onjjqv/X4yDFsoi
	 DEpGK/Ehx+DsUky8jmSjZe36Ihc7onPvS9PhPQFpnJel1L5e0W61hNb/zy0NBQaPh4
	 DGDEtYZa4U1+TSMIRSxDTdvewnnsx6UJ+VkqHAtmbtBOGy5rvSFXKwREu7VYFaBIti
	 XIZ5wTNOQ9FZLwtZIWz8XGJrMLdyHxC+0VXA3xAGPPFsetVSkYlp16WlTigtxcQIGD
	 eSS7o5xMLpa5x8NYr2DYl63lZx+9JhQDLRGb/ZuX7DZOiD/C2GypOloJxKQlgyh1jQ
	 ca2kZV6OFz0TQ==
Date: Wed, 20 Dec 2023 08:36:17 +0000
To: linux-xfs@vger.kernel.org
From: Carlos Maiolino <carlos@maiolino.me>
Subject: [ANNOUNCE] xfsprogs: for-next updated to fc83c7574
Message-ID: <dskfaggepbcqpi3bkohog5vz537qzntue75hv6zvrnls7cd2x3@h3mwrg4x7vbt>
Feedback-ID: 28765827:user:proton
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------6d5cba85cfbb5e03bb3b31b99076b06e014406db5d893b22507d4715f3f6dede"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------6d5cba85cfbb5e03bb3b31b99076b06e014406db5d893b22507d4715f3f6dede
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 Dec 2023 09:36:14 +0100
From: Carlos Maiolino <carlos@maiolino.me>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to fc83c7574
Message-ID: <dskfaggepbcqpi3bkohog5vz537qzntue75hv6zvrnls7cd2x3@h3mwrg4x7vbt>
MIME-Version: 1.0
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

fc83c7574b1fb2258c9403461e55b0cb091c670c

24 new commits:

Christoph Hellwig (23):
      [73352da7d] libxfs: remove the unused icache_flags member from struct libxfs_xinit
      [74c77adf5] libxfs: remove the dead {d,log,rt}path variables in libxfs_init
      [e634be8f1] libxfs/frog: remove latform_find{raw,block}path
      [732f5b904] libxfs: remove the volname concept
      [7b17b49e7] xfs_logprint: move all code to set up the fake xlog into logstat()
      [809310c4a] libxlog: remove the verbose argument to xlog_is_dirty
      [09746c2a7] libxlog: add a helper to initialize a xlog without clobbering the x structure
      [c42edb2e8] libxlog: don't require a libxfs_xinit structure for xlog_init
      [cf9162582] libxlog: remove the global libxfs_xinit x structure
      [01dcfd9e4] libxfs: rename struct libxfs_xinit to libxfs_init
      [ddd9942bc] libxfs: pass a struct libxfs_init to libxfs_mount
      [ca8cc76e8] libxfs: pass a struct libxfs_init to libxfs_alloc_buftarg
      [b6e08bf37] libxfs: merge the file vs device cases in libxfs_init
      [23d889559] libxfs: making passing flags to libxfs_init less confusing
      [8798d4a6a] libxfs: remove the setblksize == 1 case in libxfs_device_open
      [a3106f329] libfrog: make platform_set_blocksize exit on fatal failure
      [f73596118] libxfs: remove dead size < 0 checks in libxfs_init
      [4f112cb17] libxfs: mark libxfs_device_{open,close} static
      [652683748] libxfs: return the opened fd from libxfs_device_open
      [024b577aa] libxfs: pass the device fd to discard_blocks
      [28cd682be] xfs_repair: remove various libxfs_device_to_fd calls
      [7b47b1bc2] libxfs: stash away the device fd in struct xfs_buftarg
      [fc83c7574] libxfs: split out a libxfs_dev structure from struct libxfs_init

Eric Biggers (1):
      [e97caf714] xfs_io/encrypt: support specifying crypto data unit size

Code Diffstat:

 configure.ac          |   1 +
 copy/xfs_copy.c       |  19 +--
 db/crc.c              |   2 +-
 db/fuzz.c             |   2 +-
 db/info.c             |   2 +-
 db/init.c             |  29 ++--
 db/init.h             |   3 +-
 db/metadump.c         |   4 +-
 db/output.c           |   2 +-
 db/sb.c               |  18 +--
 db/write.c            |   2 +-
 growfs/xfs_growfs.c   |  24 +--
 include/builddefs.in  |   4 +
 include/libxfs.h      |  87 ++++++-----
 include/libxlog.h     |   7 +-
 include/xfs_mount.h   |   3 +-
 io/encrypt.c          |  72 ++++++---
 libfrog/linux.c       |  39 ++---
 libfrog/platform.h    |   6 +-
 libxfs/init.c         | 398 +++++++++++++++-----------------------------------
 libxfs/libxfs_io.h    |   5 +-
 libxfs/rdwr.c         |  16 +-
 libxfs/topology.c     |  23 +--
 libxfs/topology.h     |   4 +-
 libxlog/util.c        |  49 +++----
 logprint/logprint.c   |  79 +++++-----
 m4/package_libcdev.m4 |  21 +++
 man/man8/xfs_io.8     |   5 +-
 mkfs/xfs_mkfs.c       | 249 +++++++++++++------------------
 repair/globals.h      |   2 +
 repair/init.c         |  40 +++--
 repair/phase2.c       |  27 +---
 repair/prefetch.c     |   2 +-
 repair/protos.h       |   2 +-
 repair/sb.c           |  18 +--
 repair/xfs_repair.c   |  15 +-
 36 files changed, 537 insertions(+), 744 deletions(-)

--------6d5cba85cfbb5e03bb3b31b99076b06e014406db5d893b22507d4715f3f6dede
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wnUEARYIACcFAmWCp4EJEOk12U/828uvFiEEj32Dn/1+aNUZzl9s6TXZT/zb
y68AAHKJAQDZABAUbzCyODROt1ops90lkvSvWgv3BP85rYUYsfrffQD9EwL9
83K9y0IOOKq30/55+15YJTqjUWRciqVXMKJTaAc=
=ZT2z
-----END PGP SIGNATURE-----


--------6d5cba85cfbb5e03bb3b31b99076b06e014406db5d893b22507d4715f3f6dede--

