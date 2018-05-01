Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51982 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751512AbeEADEA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 23:04:00 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5F8B4479AE3
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 22:02:46 -0500 (CDT)
Subject: Re: [ANNOUNCE] xfsprogs: for-next rebased to 43d5ec8
From: Eric Sandeen <sandeen@sandeen.net>
References: <b8905265-4c18-d927-9a92-9cfededb8ae0@sandeen.net>
Message-ID: <f85ca497-3de0-329c-a4aa-a6dd5494c3ef@sandeen.net>
Date: Mon, 30 Apr 2018 22:03:57 -0500
MIME-Version: 1.0
In-Reply-To: <b8905265-4c18-d927-9a92-9cfededb8ae0@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JeiK6FsETBWH3jplHmP2Y1Qg2JyvKYBgO"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JeiK6FsETBWH3jplHmP2Y1Qg2JyvKYBgO
Content-Type: multipart/mixed; boundary="2MCZuLAXV8gsMRFw24zVB7S52hKecIcv7";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <f85ca497-3de0-329c-a4aa-a6dd5494c3ef@sandeen.net>
Subject: Re: [ANNOUNCE] xfsprogs: for-next rebased to 43d5ec8
References: <b8905265-4c18-d927-9a92-9cfededb8ae0@sandeen.net>
In-Reply-To: <b8905265-4c18-d927-9a92-9cfededb8ae0@sandeen.net>

--2MCZuLAXV8gsMRFw24zVB7S52hKecIcv7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

And due to the 4.16.1 release I'm about to do, which I did
out of order, I promptly rebased for-next, so the new head of for-next is=
 now:

4152dae Merge branch 'libxfs-4.17-sync' into for-next

and for-next also includes the minor 4.16.1 update, a release for which
I'll send out momentarily.

Sorry about the churn.

-Eric

On 4/30/18 9:18 PM, Eric Sandeen wrote:
> Hi folks,
>=20
> The for-next branch of the xfsprogs repository at:
>=20
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>=20
> has just been updated.  I've merged the 4.17 libxfs changes from the
> libxfs-4.17-sync branch into for-next.
>=20
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.
>=20
> The new head of the for-next branch is commit:
>=20
> 43d5ec8 Merge branch 'libxfs-4.17-sync' into for-next
>=20
> New Commits:
>=20
> Brian Foster (4):
>       [65a15e0] xfs: rename agfl perag res type to rmapbt
>       [9760cac] xfs: account only rmapbt-used blocks against rmapbt per=
ag res
>       [8dbee8f] xfs: detect agfl count corruption and reset agfl
>       [19fbb9d] xfs: clean up xfs_mount allocation and dynamic initiali=
zers
>=20
> Carlos Maiolino (1):
>       [97b3ffd] Cleanup old XFS_BTREE_* traces
>=20
> Darrick J. Wong (7):
>       [6da71a8] xfs: convert a few more directory asserts to corruption=

>       [15348e0] xfs: sanity-check the unused space before trying to use=
 it
>       [0cf6a3a] xfs: refactor bmap record validation
>       [b02a2c9] xfs: refactor inode verifier error logging
>       [43f7ceb] xfs: refactor inode buffer verifier error logging
>       [fd0c360] xfs: move inode extent size hint validation to libxfs
>       [2949b46] xfs: don't accept inode buffers with suspicious unlinke=
d chains
>=20
> Dave Chinner (2):
>       [b816550] xfs: convert XFS_AGFL_SIZE to a helper function
>       [d206fcb] xfs: remove dead inode version setting code
>=20
> Eric Sandeen (2):
>       [1421de3] xfs: non-scrub - remove unused function parameters
>       [43d5ec8] Merge branch 'libxfs-4.17-sync' into for-next
>=20
>=20
> Code Diffstat:
>=20
>  db/agfl.c                   |   2 +-
>  db/check.c                  |   6 +--
>  db/freesp.c                 |   6 +--
>  db/metadump.c               |   2 +-
>  include/libxfs.h            |   1 +
>  include/xfs_mount.h         |  10 +++--
>  include/xfs_trace.h         |   2 +
>  libxfs/libxfs_api_defs.h    |   2 +
>  libxfs/libxfs_priv.h        |  11 ++++++
>  libxfs/xfs_ag_resv.c        |  39 ++++++++++---------
>  libxfs/xfs_ag_resv.h        |  31 +++++++++++++++
>  libxfs/xfs_alloc.c          | 145 ++++++++++++++++++++++++++++++++++++=
++++++++++++++++++++++++-----------
>  libxfs/xfs_alloc.h          |   7 ++--
>  libxfs/xfs_alloc_btree.c    |   8 +---
>  libxfs/xfs_bmap.c           |  54 +++++++++++++++++++++++----
>  libxfs/xfs_bmap.h           |   5 ++-
>  libxfs/xfs_bmap_btree.c     |   4 +-
>  libxfs/xfs_bmap_btree.h     |  14 -------
>  libxfs/xfs_btree.c          | 127 +++++-------------------------------=
--------------------------
>  libxfs/xfs_btree.h          |  25 +------------
>  libxfs/xfs_dir2.h           |   2 +-
>  libxfs/xfs_dir2_block.c     |  59 +++++++++++++++++------------
>  libxfs/xfs_dir2_data.c      |  78 +++++++++++++++++++++++++++++-------=
--
>  libxfs/xfs_dir2_leaf.c      |  13 +++++--
>  libxfs/xfs_dir2_node.c      |  16 +++++---
>  libxfs/xfs_format.h         |  13 +------
>  libxfs/xfs_ialloc.c         |   2 +-
>  libxfs/xfs_ialloc_btree.c   |  11 ++----
>  libxfs/xfs_inode_buf.c      | 124 ++++++++++++++++++++++++++++++++++++=
++++++++++++++++++++----
>  libxfs/xfs_inode_buf.h      |   5 +++
>  libxfs/xfs_inode_fork.c     |  27 +++++++++-----
>  libxfs/xfs_refcount.c       |  22 ++++-------
>  libxfs/xfs_refcount_btree.c |  10 +----
>  libxfs/xfs_refcount_btree.h |   3 +-
>  libxfs/xfs_rmap.c           |   3 +-
>  libxfs/xfs_rmap_btree.c     |  17 ++++-----
>  libxfs/xfs_rmap_btree.h     |   2 +-
>  libxfs/xfs_sb.c             |  11 ++----
>  libxfs/xfs_trans_resv.c     |  10 ++---
>  mkfs/xfs_mkfs.c             |   4 +-
>  repair/agheader.c           |  12 +++---
>  repair/phase5.c             |  20 +++++-----
>  repair/rmap.c               |   2 +-
>  repair/scan.c               |   6 +--
>  44 files changed, 585 insertions(+), 388 deletions(-)
>=20


--2MCZuLAXV8gsMRFw24zVB7S52hKecIcv7--

--JeiK6FsETBWH3jplHmP2Y1Qg2JyvKYBgO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlrn2R0ACgkQIK4WkuE9
3uD9dw/7BGTvPfDjVrnaQEJB68tDAQeuT9XnL8/a+tGoLINBwNb1k7w6cEj9iXRg
8IZEkMqgpz/wuVD/sq5XeR1IC3+ofbaHSp5R3iKtUA1BNMysg4B6unvy26fgkhXE
NYRBaFdUPBDaDsJqUwfUMCNmMiaL92vakmd1P/MxPuHfGIkIEX0iLWGLqYGEaqAN
XcYtkwjsC/Cc6KTdzO+doJSrww5b9x5MYJEeFQ9qGraRycVdolay9VFGnehD6sqx
3K+5uRmIC+VovCy7CK6T4QPC0R6FbVgsX6vQLQF4soqpMB0kLB/0efLv7slriFiV
dAD5GRkMFlhM9uAV/H7CFr/0uSXvBRDUjwR+smLEFg4Plt4UtjPSRg5M9Gc5X49w
6YG8m2TaIpNWwIKPVWU5T4qPDQPiXIfJ7TbAu6sczUlrEr9BGY1y3S/7RTzUPMBP
6uqDebXn0W7hLXFYt18bw0r9qouvO/7dklQ+GRO3XlbfTCgjkmIRuXcAhTbBUTg3
bxbHkrBdmL9IbhNnMkux2sBwwo9tQqBOjASdwjsC1ICd/K9vQEySpzzrwrwkRe1P
8yX4sJHJMyxLmVSuMZiSPtxDXRqhzgAhMvb95iXk2KQJ6h3Fxb6QkgrKdiblezUK
3Cs6CKmxCqTIA/wfxPibYv1K6AbdLXlqc+ctgnS8qa/1/2S3QyI=
=IG6E
-----END PGP SIGNATURE-----

--JeiK6FsETBWH3jplHmP2Y1Qg2JyvKYBgO--
