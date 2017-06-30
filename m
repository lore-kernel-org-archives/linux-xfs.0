Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45114 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751970AbdF3Thu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Jun 2017 15:37:50 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 19C7F686CAB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jun 2017 14:37:44 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.12.0-rc1 released
Message-ID: <0b5c49e5-feb3-95e5-08c0-6b2d17709516@sandeen.net>
Date: Fri, 30 Jun 2017 14:37:37 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MwNATWJLn7AKFNotk6SqoTPsrOamLxQLr"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MwNATWJLn7AKFNotk6SqoTPsrOamLxQLr
Content-Type: multipart/mixed; boundary="rxxBMC58Wx5AnDGDudCwmfXgp7JRIUL2t";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <0b5c49e5-feb3-95e5-08c0-6b2d17709516@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.12.0-rc1 released

--rxxBMC58Wx5AnDGDudCwmfXgp7JRIUL2t
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with xfsprogs: v4.12.0-rc1

This is just a small delta over the last update, and reflects
the bulk of the content that will be in 4.12.  Feature-ish-wise,
it's:

xfsprogs-4.12.0-rc1 (30 Jun 2017)
        - xfs_spaceman: new space management tool (Dave Chinner, Darrick =
Wong)
        - xfs_io: implement fsmap command (Darrick Wong)
        - xfs_repair: fix 512 sector image repair on 4k sector host (Zorr=
o Lang)
        - xfs_growfs: ensure target is an active xfs mountpoint (Bill O'D=
onnell)
        - xfs_metadump: warn about corruption if log is dirty (Jan Tulak)=

        - xfs_metadump: tag metadump with informational flags (Eric Sande=
en)
        - xfs_db: fix 'type' command for interesting geoms (Bill O'Donnel=
l)
        - xfs_db: add alignment filter to freesp command (Eric Sandeen)
        - libxfs: use crc32c slice-by-8 variant by default (Darrick Wong)=

        - update Polish translation (Jakub Bogusz)

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

(jeffm: I want to get your xfs_repair patches in but have not
had time to completely wrap my head around the pthreads stuff,
and will get it in for the next release, sorry.)

The new head of the for-next branch is commit:

1d7d0b1 xfsprogs: Release v4.12.0-rc1

New Commits:

Bill O'Donnell (5):
      [55f224b] xfs_db: update buffer size when new type is set
      [db23e0f] xfs_db: improve argument naming in set_cur and set_iocur_=
type
      [e177680] xfs_spaceman: fix potential memory leak by malloc in scan=
_ag
      [1cda909] xfs_spaceman: close open file for error case in openfile(=
)
      [eb125dc] xfs_spaceman: fix potential overflowing expression in tri=
m_f()

Darrick J. Wong (2):
      [73a423b] xfs_db: identify attr dabtree field types correctly
      [6644005] libxfs: fix fsmap.h inclusion

Eric Sandeen (1):
      [1d7d0b1] xfsprogs: Release v4.12.0-rc1


Code Diffstat:

 VERSION           |  4 ++--
 configure.ac      |  2 +-
 db/attr.c         | 24 ++++++++++++++++++++++--
 db/attr.h         |  2 ++
 db/field.c        |  6 ++++--
 db/field.h        |  1 +
 db/io.c           | 40 ++++++++++++++++++++++++----------------
 db/io.h           |  6 +++---
 doc/CHANGES       | 12 ++++++++++++
 include/linux.h   |  4 +++-
 spaceman/file.c   |  1 +
 spaceman/freesp.c |  2 ++
 spaceman/trim.c   |  2 +-
 13 files changed, 78 insertions(+), 28 deletions(-)


--rxxBMC58Wx5AnDGDudCwmfXgp7JRIUL2t--

--MwNATWJLn7AKFNotk6SqoTPsrOamLxQLr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJZVqiIAAoJECCuFpLhPd7gT4YQAK76nVqle1/JVhPbIUoFxEf9
PzUiC3xKfdfdAc8fqdFfoDyKx6YMVCJmotem9KTzWpsOGlS0V8IQCzwTDoSitIUE
4bxkanfF/TfUl0IhbaePtd41yLLt3fq/cDs+VYE2kojJ3+3T4pANM+NUscLfJO9E
aJtFISNvUSxTuVBRF7HlvKmvwaydAj6yXcm2s9lLg14Oktj74kqcM9PNMCjW48Jl
UhPBZV66iEAokgwAjC6Gc4AJyRH4zbGRrYsXNytoRCywDT70GeokaBbGL4xTf4Cy
xSZdvjEXYoAHFvcYSzmPJYaOkDGiXsyXkZt3zfVGJzeyQCoRp8fceMbPScXSIjjX
sZNHHjFhlmvMPMKH1yN/JBgBDvBGqI8OGHVvMeLGxMlXBKLSpgGT6c1J/Ub50CT5
9djU+KE0jBqhhwhncyCoBBI3MjKit3puDKH9n14OwmEyACMSs7WhjNitk+Ls/WbW
nArUEqADxIUwE12lwFku2XjWKAVhEjY7unauploUz6eS1uqxtmF8uRtzhfxBRw+9
ph/h1xIlJiERafdd64rFaJoz2cPT+nVVqJKf28Nd9tWW0zpn8qKnPC49bcBh43kU
hbOSk5AoFupIlA6RPyoOE5cR69nhdCubvsbf1K5HH/exoNwdvS7h9kQ82FUx6+t+
pWsVBTk7kFmhbKK5Hmpc
=eyzf
-----END PGP SIGNATURE-----

--MwNATWJLn7AKFNotk6SqoTPsrOamLxQLr--
