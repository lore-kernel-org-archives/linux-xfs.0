Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:45095 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752171AbcJXKvS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2016 06:51:18 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1bycpv-0006nB-Cg
        for linux-xfs@vger.kernel.org; Mon, 24 Oct 2016 21:50:35 +1100
Date: Mon, 24 Oct 2016 21:50:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to b77428b12b55
Message-ID: <20161024105035.GZ14023@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

b77428b12b55 xfs: defer should abort intent items if the trans roll fails

New Commits:

Brian Foster (2):
      [7b7381f04356] xfs: fix up inode cowblocks tracking tracepoints
      [c17a8ef43d6b] xfs: clear cowblocks tag when cow fork is emptied

Darrick J. Wong (1):
      [b77428b12b55] xfs: defer should abort intent items if the trans roll=
 fails

Jan Kara (1):
      [c663e29f8885] fs: Do to trim high file position bits in iomap_page_m=
kwrite_actor


Code Diffstat:

 fs/iomap.c                |  3 +--
 fs/xfs/libxfs/xfs_defer.c | 17 +++++------------
 fs/xfs/xfs_icache.c       |  8 ++++----
 fs/xfs/xfs_reflink.c      |  6 +++++-
 4 files changed, 15 insertions(+), 19 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYDed6AAoJEK3oKUf0dfodo0oP/AxWsTfFGFBd/dyRjf72CN1Y
7lPtzddUm1xToYZx5JGENS15gZ50qEankjKk9INv5JsHsVxO/CcLQtW8GpGYqh8L
sPAYFaAt8p1QV/UjeqPZcalbzJ3ui6XiELJLkfInO4bbZlnHmZSVXXyfsOD8JiEM
vfsg87a6TxJhCb7wu8ZMEox6hrJxLZp8md3Y2PQAq1eWhlYuMJ8wUqeLoXprc3Z7
x3Es454okMhyHpDilKbG5BY2ocYpvrLk9C/RzhtO8MfAuu+gtECmSrS9wpxFlEZz
sGAHR4TM9A9kgn+2uMhSr71DRYRFwwTSFbevkTLwYEWcsuDApskkRd6pXz2sybXv
ROTecsN4bLHqa2+IDv8fL+0QMrqsn/WDD1QZrmtAL40BDpUvTMMUjMpqrnPrtwhK
XjLdzMQTEVPXZg/yFHexOwCRw+9faQ68WNv3p4BdUS/zYSTn+PtELxosiDdLR0BO
A39ASNsQmVJGYM+ghDs1SJOc0GeLS5w4yzbxxJhdNilqxPypAPf7n5HqpvuNXqs8
nQ6HhUxUpn5F8Y5Y/5fuiHhE+NpjKUqDDq5akCd0mXbDpoadu3NzNW9Rk4MbQzKT
X0uZwsJQK6LAO8I7XzJUDfw99v9hNNIg7MZqTJqMoLQcuB23ua9lQdHcI5Xs9Pr5
TEFuUqWcuhrGEvzNZJQa
=bxy5
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
