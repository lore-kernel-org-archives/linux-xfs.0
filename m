Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54052 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751728AbdIUVUR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 17:20:17 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id F3CD080F10A
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2017 16:20:08 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsdump: v3.1.8 released
Message-ID: <99a935a3-16cd-cd6a-1921-eea3780fc465@sandeen.net>
Date: Thu, 21 Sep 2017 16:20:09 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ugsh9a6Qh5efOcKU83glfLGDO7gkVT9jk"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ugsh9a6Qh5efOcKU83glfLGDO7gkVT9jk
Content-Type: multipart/mixed; boundary="Ctllbw0hPs6sRBWuTvw3wmgr5SHUPghON";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <99a935a3-16cd-cd6a-1921-eea3780fc465@sandeen.net>
Subject: [ANNOUNCE] xfsdump: v3.1.8 released

--Ctllbw0hPs6sRBWuTvw3wmgr5SHUPghON
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsdump repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated with the v3.1.8 release tag.

This release is comprised solely of fixes for building against musl
libc.  There are no other functional changes.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

9a066b8 xfsdump: Release v3.1.8

New Commits since v3.1.7:

Eric Sandeen (1):
      [9a066b8] xfsdump: Release v3.1.8

Felix Janda (8):
      [663f517] invutil/invidx: include <fcntl.h> for O_CREAT
      [b848d35] dump/content.c: Include <linux/limits.h> for XATTR_LIST_M=
AX
      [a03055f] common/main.c: Replace nonstandard SIGCLD by SIGCHLD
      [7a0a8e7] librmt/rmtopen: Prefer <signal.h> over <sys/signal.h>
      [cb66b83] dump/var.c: Include <limits.h> for PATH_MAX
      [dd47bfa] cleanup: Kill __[u]int*_t types
      [55b0f0e] common/types.h: explicitly define NBBY (bits per byte)
      [ce8b006] common/main.c: Include <locale.h>

Code Diffstat:

 VERSION                | 2 +-
 common/content_inode.h | 4 ++--
 common/hsmapi.c        | 2 +-
 common/main.c          | 3 ++-
 common/types.h         | 4 ++++
 configure.ac           | 2 +-
 debian/changelog       | 6 ++++++
 doc/CHANGES            | 3 +++
 doc/xfsdump.html       | 8 ++++----
 dump/content.c         | 1 +
 dump/var.c             | 1 +
 inventory/inv_oref.h   | 2 +-
 inventory/inv_priv.h   | 4 ++--
 inventory/inventory.h  | 2 +-
 invutil/invidx.c       | 1 +
 librmt/rmtopen.c       | 2 +-
 16 files changed, 32 insertions(+), 15 deletions(-)


--Ctllbw0hPs6sRBWuTvw3wmgr5SHUPghON--

--Ugsh9a6Qh5efOcKU83glfLGDO7gkVT9jk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJZxC0QAAoJECCuFpLhPd7gSsYQAJRJJFrZ0SsouDVJot+s0Qju
HfeqtsiiLhhzkpfbblm8l6zbHVLgZYJGObMIOECgKYH4viZnaO4pA6DbkaO7eA25
lV3TSlJLqJF1BTyzfUW2zkYIYlvbe1s+QlEJ8PcY9KpOCEYFqo9gu42dBq9eMJqX
rA6K1CpxKFYtlpzQpGLE2z7ZgMB9LCZxZJDBmVX08yvEYP+Lg2hR6ur6bxteY07M
Ju70NbBLUHLdo+4Wl1JOWo10d0zirJKQ1o8P+nX7ytyhQ0l/BobsY+Da0/P4mU10
cT0i8rwkgZM0ROWMseckhJEC3lCNbMM155Lw9qPNidfdTmM1NhhcyeCzd0ldzvlG
g0CaQBmTmOjuvD3XYc9TKjJ89c2NkzTzXkYqcpr9nLmGBZEuz/t8KYDX72ejaZww
y7CcDpVjXyA+8ISPlFJKFUdlOdWuTVLuPXNfcVf5WpKDmnmgeBv7ddPhjFzlEfBa
DbYG45LLsYxMjg7CvkOyTTAUfGUd6punBQEsK2EWFX2iNX4WfwKURvgvVMqnyr/u
brVCFwZm8z5lLS2McqiPo1XwaCP/b4YxwNKnWFdamwKSianw7gutNEXL7HU5j4q9
G5gEFQWAC2ocTUBohAP+8lLpMWo6n6WE7r6FBWvU4GCiae6CXM6csYGUjx1ZwFKd
OD1VrbiVrh1FoFxmk4bu
=hSXK
-----END PGP SIGNATURE-----

--Ugsh9a6Qh5efOcKU83glfLGDO7gkVT9jk--
