Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E199EC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 20:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78D861AA4
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 20:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhJAUfF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Oct 2021 16:35:05 -0400
Received: from sandeen.net ([63.231.237.45]:53250 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355034AbhJAUfE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Oct 2021 16:35:04 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7B72314A18
        for <linux-xfs@vger.kernel.org>; Fri,  1 Oct 2021 15:32:39 -0500 (CDT)
To:     xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 7c432f77
Message-ID: <bddb12ee-3726-2bd3-764d-654d54625535@sandeen.net>
Date:   Fri, 1 Oct 2021 15:33:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9frgLgUAGwF6E99hgYvIpC4lf6FJT55z7"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9frgLgUAGwF6E99hgYvIpC4lf6FJT55z7
Content-Type: multipart/mixed; boundary="BYlyVDYf2yceXP2842ZfdWnYzLOhq1V9x";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <bddb12ee-3726-2bd3-764d-654d54625535@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 7c432f77

--BYlyVDYf2yceXP2842ZfdWnYzLOhq1V9x
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

7c432f77 misc: convert utilities to use "fallthrough;"

New Commits:

Darrick J. Wong (5):
       [ec4e15fd] mkfs: move mkfs/proto.c declarations to mkfs/proto.h
       [6bc3531c] libfrog: move topology.[ch] to libxfs
       [b9ee1227] libxfs: port xfs_set_inode_alloc from the kernel
       [8fb63e2a] libxfs: fix whitespace inconsistencies with kernel
       [7c432f77] misc: convert utilities to use "fallthrough;"

Dave Chinner (3):
       [e4da1b16] xfsprogs: introduce liburcu support
       [686bddf9] libxfs: add spinlock_t wrapper
       [de555f66] atomic: convert to uatomic

Gustavo A. R. Silva (1):
       [df9c7d8d] xfs: Fix fall-through warnings for Clang


Code Diffstat:

  configure.ac                   |   3 +
  copy/Makefile                  |   3 +-
  copy/xfs_copy.c                |   3 +
  db/Makefile                    |   3 +-
  db/type.c                      |   2 +-
  debian/control                 |   2 +-
  growfs/Makefile                |   3 +-
  growfs/xfs_growfs.c            |   6 +-
  include/Makefile               |   1 +
  include/atomic.h               |  65 +++++++++++++++---
  include/builddefs.in           |   4 +-
  include/libxfs.h               |   2 +
  include/linux.h                |  21 ++++++
  include/platform_defs.h.in     |   1 +
  include/spinlock.h             |  25 +++++++
  include/xfs_inode.h            |   1 +
  include/xfs_mount.h            |   2 +
  include/xfs_multidisk.h        |   5 --
  include/xfs_trans.h            |   1 +
  libfrog/Makefile               |   2 -
  libfrog/workqueue.c            |   3 +
  libxfs/Makefile                |  10 +--
  libxfs/init.c                  | 149 ++++++++++++++++++++++++++--------=
-------
  libxfs/libxfs_priv.h           |   7 +-
  libxfs/logitem.c               |   4 +-
  libxfs/rdwr.c                  |   2 +
  {libfrog =3D> libxfs}/topology.c |   5 +-
  {libfrog =3D> libxfs}/topology.h |   6 +-
  libxfs/xfs_ag_resv.c           |   4 +-
  libxfs/xfs_alloc.c             |   2 +-
  libxfs/xfs_btree.h             |   2 +-
  libxfs/xfs_da_btree.c          |   2 +-
  libxfs/xfs_rmap_btree.h        |   2 +-
  logprint/Makefile              |   3 +-
  m4/Makefile                    |   1 +
  m4/package_urcu.m4             |  22 ++++++
  mdrestore/Makefile             |   3 +-
  mkfs/Makefile                  |   2 +-
  mkfs/proto.c                   |   1 +
  mkfs/proto.h                   |  13 ++++
  mkfs/xfs_mkfs.c                |   2 +-
  repair/Makefile                |   2 +-
  repair/dinode.c                |  18 ++---
  repair/phase4.c                |   4 +-
  repair/prefetch.c              |   9 ++-
  repair/progress.c              |   4 +-
  repair/sb.c                    |   1 -
  repair/scan.c                  |   4 +-
  scrub/Makefile                 |   3 +-
  scrub/inodes.c                 |   2 +-
  scrub/progress.c               |   2 +
  scrub/repair.c                 |   2 +-
  scrub/scrub.c                  |   8 +--
  53 files changed, 327 insertions(+), 132 deletions(-)
  create mode 100644 include/spinlock.h
  rename {libfrog =3D> libxfs}/topology.c (99%)
  rename {libfrog =3D> libxfs}/topology.h (88%)
  create mode 100644 m4/package_urcu.m4
  create mode 100644 mkfs/proto.h


--BYlyVDYf2yceXP2842ZfdWnYzLOhq1V9x--

--9frgLgUAGwF6E99hgYvIpC4lf6FJT55z7
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAmFXcI4FAwAAAAAACgkQIK4WkuE93uCc
LA/+JDxM6yhtNobukABg7GGX+rFx6xRM8SG3fH22xSbJIf8k1vygeC65wazutnBTxInZnS9JE717
Z1Lyq6/BAyxaeqmE33WQBikWLpVElgWAUck6/A5ZqMe+08u/maopAbKTneJrYatM1nT/8JLmJFFY
QSs6W8UB30CKB3bbLU4bNTIvAdGEQ1e/ByARrSnrwf84FcacokIGSkGJ/PMVoYBkD235Fdgmw+5z
Uj8nnhGhXVrhkK08YVnIRbgEtKWrtVitfDcIhJcgAl/sRIy7QL587ih5spH+9UlOjN3FInQo+bva
0gfr5EIg06Z9+GaZkeDcB1160SnnYpWm9nYwxSDCW+Hc1h3kjCCbS+ZqWC8llG2z1BvL+D9HGoSh
gp3OnJ9ELbsngAEf6CINhfgUtAYRIePXHhkOSj7bdtCdk2O21j8HiLvRAbXW/QNzwCLSQMdy8llY
3LmFMZf2l2R4BbbDN6DTebu/cPkY3yY6l/1oOGt0AHSUFBGJjyPo51IjmZcxaYyZkLDGB4DG13mE
8/lThC+wHoBbdWckDeMg9xw0gWICThsdHvaONJO+snOkVWEBaNKgzAzOPJ7fBGYqXW6TxEBGhVW2
FHF21CEMNQhM7Lp1ZRY39KNLzVnfNoBTxSNman+PJtNWNQdqZWY8zNwQW1wLfwVcO7+1dEzXjj+J
Ez0=
=i3VZ
-----END PGP SIGNATURE-----

--9frgLgUAGwF6E99hgYvIpC4lf6FJT55z7--
