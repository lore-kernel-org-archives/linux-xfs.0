Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58094 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFYVIs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 17:08:48 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 09BFF1170C
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 16:08:37 -0500 (CDT)
Subject: [ANNOUNCE] xfsprogs for-next rebased to 8bfb5eac
From: Eric Sandeen <sandeen@sandeen.net>
References: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>
Message-ID: <14670eb1-0e0e-b669-7d85-0f4589e13bf9@sandeen.net>
Date: Tue, 25 Jun 2019 16:08:45 -0500
MIME-Version: 1.0
In-Reply-To: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LBuaNj7teEoAVl9mo8lADRsYgqwoR20DR"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LBuaNj7teEoAVl9mo8lADRsYgqwoR20DR
Content-Type: multipart/mixed; boundary="cW2K9kKYJ9KMx3k9WcMoiL7AIuE4fRgy0";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <14670eb1-0e0e-b669-7d85-0f4589e13bf9@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next rebased to 8bfb5eac
References: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>
In-Reply-To: <637c74e5-01b9-af25-0576-ba544ff8f0e6@sandeen.net>

--cW2K9kKYJ9KMx3k9WcMoiL7AIuE4fRgy0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been rebased(!)

[I am on fire today, and accidentally pushed some unreviewed manpage
changes, go, me!]

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

8bfb5eac (HEAD -> for-next, origin/for-next, korg/for-next) xfs_quota: fi=
x built-in help for project setup

New Commits:

Amir Goldstein (1):
      [e0bdad06] xfs_info: limit findmnt to find mounted xfs filesystems

Darrick J. Wong (4):
      [b6ad9957] libfrog: don't set negative errno in conversion function=
s
      [b089256c] libfrog: cvt_u64 should use strtoull, not strtoll
      [8da52988] mkfs: validate start and end of aligned logs
      [f1572219] xfs_io: repair_f should use its own name

Eric Sandeen (1):
      [8bfb5eac] xfs_quota: fix built-in help for project setup


Code Diffstat:

 io/scrub.c           |  2 +-
 libfrog/convert.c    | 22 +++++++++++-----------
 mkfs/xfs_mkfs.c      | 15 ++++++++++++++-
 quota/project.c      |  2 +-
 spaceman/xfs_info.sh |  2 +-
 5 files changed, 28 insertions(+), 15 deletions(-)


--cW2K9kKYJ9KMx3k9WcMoiL7AIuE4fRgy0--

--LBuaNj7teEoAVl9mo8lADRsYgqwoR20DR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl0SjV0ACgkQIK4WkuE9
3uCHFA//XlQvrnVYkubjZd5d/QdVcUNmFvcVNiylaDwp52N+K1RQgbhsth893Afi
HlSalBZIEmSzdt5SMvMqeMaj1Adh6k1CPoYqxFmFwmcQTC7uTZJhfVZDVmYPL+5L
8kB+eV8+jLEw1WLmCjL1GyIjmBcW9mtD24Mm9lgCmGCxNZovWXR8rp3t/6xZWauE
AzZnwP5PYhNzueMHd190XfdiJ9T7HziZkL5OjxYkAnXtfI9UywA03bqhdr2eFbUB
7H3Yw495y8ox0xrI262k9VbFyrRQ9SGLAerC5YVYgNT+v5c3EIjyHt++ReEtUymY
LCMzISL3zskRKrxD+tN/iRAuzIjxXc5NzuO9QAM2/gSeykAUyxvpPS+RYaBF2mUL
+C34KftDufprJ15D2LaSbGVi2Ha/vqlRXPX7BWpH3XKgcTE9J2E0swZOULEH4Ar2
cZrynxUqQ3rYW6u58Nzq4I53pjfOhyaL1XC4beYAniP1btj3/UyOVP2Rvz0KT13r
O1ZSbsv3dHvR2t54c1H6WQKB18sTq6UDpgrxzRxjmi9dX/7/szTAz2GVaqQ/GhSS
Rer7f8Ney50ZX+zdl08Wo9gcPHyHDqvDEylF1gmvvH1Fwsy1UqIJg3iMZsMCNHRN
pcFaGczH29x0+VJsVPiH+t+i2vpgtJBS/euIaH7jk68Qp9PKVto=
=9pWq
-----END PGP SIGNATURE-----

--LBuaNj7teEoAVl9mo8lADRsYgqwoR20DR--
