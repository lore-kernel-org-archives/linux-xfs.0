Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:46646 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752008AbcJTWOK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2016 18:14:10 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1bxLbB-0007n9-Li
        for linux-xfs@vger.kernel.org; Fri, 21 Oct 2016 09:14:05 +1100
Date: Fri, 21 Oct 2016 09:14:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 64e6428ddd00
Message-ID: <20161020221405.GO14023@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This is the first round of fixes for 4.9-rc3
after the reflink merge. It's a little bit bigger than I'd
anticipated, but most of that change is the refactoring that
Christoph has done on top of all his fixes. If I've missed anything
critical, please let me know.

-Dave.

The new head of the for-next branch is commit:

64e6428ddd00 xfs: remove xfs_bunmapi_cow

New Commits:

Christoph Hellwig (14):
      [0ee7a3f6b5b2] xfs: don't take the IOLOCK exclusive for direct I/O pa=
ge invalidation
      [4fbc2c65255f] xfs: remove the same fs check from xfs_file_share_range
      [a62e82b35b97] xfs: fix the same_inode check in xfs_file_share_range
      [576177818e6f] xfs: move inode locking from xfs_reflink_remap_range t=
o xfs_file_share_range
      [ec4075990255] xfs: remove xfs_file_wait_for_io
      [5faaf4fa0a20] xfs: merge xfs_reflink_remap_range and xfs_file_share_=
range
      [d33fd776f992] iomap: add IOMAP_REPORT
      [62c5ac89de7d] xfs: handle "raw" delayed extents xfs_reflink_trim_aro=
und_shared
      [5f9268ca53ac] xfs: don't bother looking at the refcount tree for rea=
ds
      [3ba020befef0] xfs: optimize writes to reflink files
      [fa5c836ca8eb] xfs: refactor xfs_bunmapi_cow
      [3e0ee78f7a5a] xfs: optimize xfs_reflink_cancel_cow_blocks
      [c1112b6e6266] xfs: optimize xfs_reflink_end_cow
      [64e6428ddd00] xfs: remove xfs_bunmapi_cow

Colin Ian King (1):
      [1d55a4bfd080] xfs: remove redundant assignment of ifp

Darrick J. Wong (3):
      [d099245297e2] xfs: unset MS_ACTIVE if mount fails
      [58d789678546] libxfs: clean up _calc_dquots_per_chunk
      [0a0af28cad9a] xfs: add xfs_trim_extent

Eric Biggers (1):
      [f1b8243c55ca] xfs: add some 'static' annotations

Eric Sandeen (1):
      [fe23759eaf2f] xfs: remove pointless error goto in xfs_bmap_remap_all=
oc

Geert Uytterhoeven (1):
      [1be7f9be0efa] xfs: Fix uninitialized variable in xfs_reflink_reserve=
_cow_range()

Roger Willcocks (1):
      [8cdcc8102c0c] libxfs: v3 inodes are only valid on crc-enabled filesy=
stems


Code Diffstat:

 fs/iomap.c                    |   2 +-
 fs/xfs/libxfs/xfs_bmap.c      | 418 ++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_bmap.h      |   8 +-
 fs/xfs/libxfs/xfs_btree.c     |   2 +-
 fs/xfs/libxfs/xfs_dquot_buf.c |   3 +-
 fs/xfs/libxfs/xfs_format.h    |   1 -
 fs/xfs/libxfs/xfs_inode_buf.c |  13 +-
 fs/xfs/libxfs/xfs_inode_buf.h |   2 +
 fs/xfs/xfs_file.c             | 232 +++------------------
 fs/xfs/xfs_iomap.c            |  57 ++++--
 fs/xfs/xfs_mount.c            |   1 +
 fs/xfs/xfs_reflink.c          | 495 ++++++++++++++++++++++++--------------=
-------
 fs/xfs/xfs_reflink.h          |  11 +-
 fs/xfs/xfs_sysfs.c            |   4 +-
 fs/xfs/xfs_trace.h            |   4 +-
 include/linux/iomap.h         |  17 +-
 16 files changed, 631 insertions(+), 639 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYCUGtAAoJEK3oKUf0dfodgzIQAIs+DjcfP3JuAWl/peVeu7Ff
adIISDwZS2VWp1KC+iGZQt4rASQ0349mKLHTV6O2pTqc20U9YwpneLqCPNKObGwG
QxYWfF5FSKwY3BvAWdxltDMHnefMVi0CgN615jndCOkFCtK9ljuz6/ZsHyjFAzkO
sJp+Te7JEFmRF3coOF2oN+VUG+kSSRAorYCdcEv3qO8LihRiB2LsosFXVDSj/R11
54aTO0tqpgJ6A4+V6nr05YV/c5scNvop/xj9/uFyiAJqoEG+2Hsf/djthIJMsI7X
i+6QO01nu1fLsnOGcS94PfAU9Lf4MnWu0qKHHA3FNS+A/hZkRHcJoDBYwJf5OK7h
7YNC/B06fJvgw0Vbv6HpjVnU9PSTvKATLI9mguHzzxfgB0ArV2rMp6qv/Jt+5aBX
yDMKnxMWt3BThwyZwdKJYm5MnYjjtVTKYJZsMdAPi5BaME5geUBkTfkd5X9fv0Z5
p2I8EtMzFkgbwOl4ljRbm/HUorag03U48+WsMI2AQpatWRg6JBNojquzk2yeJBqs
b4tiJBxPhlQlWb9r8s14FIBEhtI9Xo/JNX4z6TtwWtCZOZ9XtOfS40AYaZepg8UB
jUlQdXoSqPgBEiiw3HJP7JDp+CJQi6dJMoIHvE1Q+SixG+HSX8tEv60BlFRjvTnD
PCAIN68lSri/97UZEA9J
=qZfM
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
