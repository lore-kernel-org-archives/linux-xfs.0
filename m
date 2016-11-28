Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:45001 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753327AbcK1Ets (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Nov 2016 23:49:48 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1cBDsv-0006BY-3C
        for linux-xfs@vger.kernel.org; Mon, 28 Nov 2016 15:49:45 +1100
Date: Mon, 28 Nov 2016 15:49:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to b7b26110edf8
Message-ID: <20161128044944.GZ28177@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aYDVKSzuImP48n7V"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--aYDVKSzuImP48n7V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

-Dave.

The new head of the for-next branch is commit:

b7b26110edf8 Merge branch 'xfs-4.10-misc-fixes-2' into for-next

New Commits:

Bhumika Goyal (2):
      [bb6e0ebed7f7] fs: xfs: xfs_icreate_item: constify xfs_item_ops struc=
ture
      [cf7841c12d85] fs: xfs: libxfs: constify xfs_nameops structures

Brian Foster (3):
      [974ae922efd9] xfs: track preallocation separately in xfs_bmapi_reser=
ve_delalloc()
      [0260d8ff5f76] xfs: clean up cow fork reservation and tag inodes corr=
ectly
      [f782088c9e5d] xfs: pass post-eof speculative prealloc blocks to bmapi

Christoph Hellwig (14):
      [93533c7855c3] xfs: new inode extent list lookup helpers
      [86685f7ba5c0] xfs: cleanup xfs_bmap_last_before
      [334f3423d6a6] xfs: use new extent lookup helpers in xfs_bmapi_read
      [2d58f6ef79db] xfs: use new extent lookup helpers in xfs_bmapi_write
      [7efc794561f6] xfs: use new extent lookup helpers in __xfs_bunmapi
      [65c5f419788d] xfs: remove prev argument to xfs_bmapi_reserve_delalloc
      [656152e552e5] xfs: use new extent lookup helpers xfs_file_iomap_begi=
n_delay
      [2755fc443850] xfs: use new extent lookup helpers in __xfs_reflink_re=
serve_cow
      [092d5d9d5812] xfs: cleanup xfs_reflink_find_cow_mapping
      [86f12ab05ffc] xfs: use new extent lookup helpers in xfs_reflink_trim=
_irec_to_next_cow
      [df5ab1b5a841] xfs: use new extent lookup helpers in xfs_reflink_canc=
el_cow_blocks
      [4ab8671c1962] xfs: use new extent lookup helpers in xfs_reflink_end_=
cow
      [6edc977f775e] xfs: remove xfs_bmap_search_extents
      [0e8d630ba039] xfs: remove NULLEXTNUM

Darrick J. Wong (2):
      [fd26a88093ba] xfs: factor rmap btree size into the indlen calculatio=
ns
      [fba3e594ef0a] xfs: always succeed when deduping zero bytes

Dave Chinner (2):
      [ed24bee6f26b] Merge branch 'xfs-4.10-extent-lookup' into for-next
      [b7b26110edf8] Merge branch 'xfs-4.10-misc-fixes-2' into for-next

Eric Sandeen (1):
      [1247ec4c5f6e] xfs: add XBF_XBF_NO_IOACCT to buf trace output


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c       | 274 +++++++++++++++----------------------=
----
 fs/xfs/libxfs/xfs_bmap.h       |   9 +-
 fs/xfs/libxfs/xfs_dir2.c       |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  46 +++++++
 fs/xfs/libxfs/xfs_inode_fork.h |   6 +
 fs/xfs/libxfs/xfs_types.h      |   1 -
 fs/xfs/xfs_aops.c              |  16 +--
 fs/xfs/xfs_buf.h               |   1 +
 fs/xfs/xfs_icreate_item.c      |   2 +-
 fs/xfs/xfs_iomap.c             |  54 ++++----
 fs/xfs/xfs_reflink.c           | 143 ++++++++-------------
 fs/xfs/xfs_reflink.h           |   4 +-
 12 files changed, 239 insertions(+), 319 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--aYDVKSzuImP48n7V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYO7doAAoJEK3oKUf0dfodf1IP/i6kBFQwe5VoXekEBGHIKp0A
4RBgl3XeOoCRmFXqjg7a958oseROh5pRtsxuhGUGoQPVIKkBZMwuNdhZ4wis6SsJ
NH8sbmOZcZzkluEmPLEYP39RnPwMY91OBJn9Hkj4kan0NjGQW5qwfMJi0W3ySZuF
kJEkoq/urfREsrLRLX9KAuqmBtcMYL+wt3XMK6nSzAjYLmdWKyLsjp4dwp2+QMDa
nIfcc9aFCk+wpOSrllXSG8djng27X6/x3kT8/iiu1CWhJNS3QK9ltWjSASS+seW7
alyTlaLHMQLwthX0leYYbccZJowHYe2whYgIq7EnB2H9Rv8TLqVruafrvPzouwKo
4dn6p96WUxkVTLeDEDUsG1S6MuuC94PALpsiMUvQVSP9xPO44vxdyWyIYQKzF5GG
EYhcvZH7TRMEJLcsH/Uyh9xsNlpHJPbyE+EhbRdLvlDughe6vi1m4EcEi5otPuXG
+mXIWk7DTTXvpooM8OjeFvILkymbotgweEI/P5FPBFZQLpmZNxdaCo4K8ajH4T/J
pVyIEBagKrTVTeZTpblCURQ95Qicf4ZMEQjUa5vJCVVAM24TfhMGasxZ7k2hv0Az
s55JQkYNw99a8cenHnsV1hRpvdsrdeDjeAZDHqBEtgoQzH9upl9E/oRtMxQzTXmA
PkzcTVYGK3j5K7utLS/r
=kAuj
-----END PGP SIGNATURE-----

--aYDVKSzuImP48n7V--
