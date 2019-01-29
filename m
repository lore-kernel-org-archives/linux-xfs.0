Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44096 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728559AbfA2RFe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Jan 2019 12:05:34 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6017CB7C
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jan 2019 11:04:20 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 193bc42
Message-ID: <d5164ad2-1aed-0875-5032-64cea5be9afc@sandeen.net>
Date: Tue, 29 Jan 2019 11:05:32 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fA0sMke80S42M60YvJRegUyAgLf62BjeX"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fA0sMke80S42M60YvJRegUyAgLf62BjeX
Content-Type: multipart/mixed; boundary="QGOG54dU6xYi0faxmQF7wodzBfuhSEChR";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <d5164ad2-1aed-0875-5032-64cea5be9afc@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 193bc42

--QGOG54dU6xYi0faxmQF7wodzBfuhSEChR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

This is close to what xfsprogs-4.20 will (finally) be.  I'll review
Carlos' metadump patch for possible inclusion, and if anyone has other
outstanding patches that are better for 4.20 than 5.0, please let me know=

either via a re-submit, or just point me at the patch subjects.

Thanks,
-Eric

The new head of the for-next branch is commit:

193bc42 xfsprogs: Remove barrier/nobarrier mount options from xfs.5

New Commits:

Achilles Gaikwad (1):
      [b136f48] xfs_quota: fix false error reporting of project inheritan=
ce flag is not set

Brian Foster (1):
      [051dae5] xfs_repair: initialize non-leaf finobt blocks with correc=
t magic

Darrick J. Wong (2):
      [0ba6dae] xfs_repair: fix off by one error when rebuilding high key=
s
      [38c599e] xfs_db: fix finobt record decoding when sparse inodes ena=
bled

Eric Sandeen (4):
      [45571fd] xfs_repair: allow '/' in attribute names
      [17728a4] xfsprogs: remove generated scrub files under clean target=

      [e3f66d1] xfs_db: add -d to short help for write command
      [193bc42] xfsprogs: Remove barrier/nobarrier mount options from xfs=
=2E5

Stefan Ring (5):
      [11f3d9f] xfs_metadump: Extend data zapping to XFS_DIR{2,3}_LEAFN_M=
AGIC blocks
      [b04e7e9] xfs_metadump: Zap multi fsb blocks
      [c3387ef] xfs_metadump: Zap freeindex blocks in directory inodes
      [07b75e3] xfs_metadump: Zap unused space in inode btrees
      [b32d0eb] xfs_metadump: Zap dev inodes


Code Diffstat:

 db/metadump.c        | 132 +++++++++++++++++++++++++++++++++++++++++++++=
------
 db/type.c            |   2 +-
 db/write.c           |   2 +-
 man/man5/xfs.5       |  30 ++++++------
 man/man8/xfs_db.8    |   2 +-
 quota/project.c      |   2 +-
 repair/attr_repair.c |  20 +++++---
 repair/da_util.c     |  20 +++++---
 repair/da_util.h     |   3 +-
 repair/dir2.c        |  12 ++++-
 repair/phase5.c      |  12 ++---
 scrub/Makefile       |   2 +
 12 files changed, 183 insertions(+), 56 deletions(-)


--QGOG54dU6xYi0faxmQF7wodzBfuhSEChR--

--fA0sMke80S42M60YvJRegUyAgLf62BjeX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlxQh90ACgkQIK4WkuE9
3uAbjBAAjHSxkqUX88fOfDzaQuOht3NrnuOC6tNseXbotaGAGemudAAfLCanEdIF
nqjGdw/FBC6wpr6YkGeFy5iY5BQKcX7Mft9CaHWmBA6jZ7UfSMRcVll7dgbv6edm
IE5pG5PTuHX3Qf+ie+WTTDGhaFbNjLhOWtvHKtKyZrldxW27abjrOkgmkkpNJAGL
gjn5ewzcDyZefHplnNesP1sXNk+TvyThXpeMEjNOlm5zDkqxgJpXfJHirvsDAtwS
MN8y1hN1jzyLy1UToQddqaurpVfq+WPyKYsPHEQI1A8GxVGQt/k18IavN8nEKlR3
mfT5vD96v2nNWwcWokbHC6NBohOd9uPF013o+vPtif0ravjH01zbOVLkUngbo3/i
sShLfNAr5tnXBR3963HjFp4GfYr7utYwS84G+ISfuxnegUCFjgjLdu1VHfa6GBCA
LoroAXtC51cOzQ2Tz2jKJMgvZB9TVnsgbzJCjVNtarHsjCJ0x7FixCzYKGuWwmSF
Ei7FbGP+qzO6xBqd0ZKZNziFpEMpHcD+ZC7mbPKszsS2hrWPPbB9iBveQHsH5kpV
78wC5rdfvOQ+kvM0gKENIkt5sVSUXEQSbXnJ2LiMlp+XY91awyn9bIUpI9ISh4hW
BX5Xn0PZyG/1M7ADuA0WTIJNuXiF0kRUfYgUU+7Dkkcv+xsyWLU=
=CgQ9
-----END PGP SIGNATURE-----

--fA0sMke80S42M60YvJRegUyAgLf62BjeX--
