Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:25606 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728944AbeJAHYY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 03:24:24 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1g6mOc-0005I6-0X
        for linux-xfs@vger.kernel.org; Mon, 01 Oct 2018 10:49:10 +1000
Date: Mon, 1 Oct 2018 10:49:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs-linux: for-next updated to e55ec4ddbef9
Message-ID: <20181001004909.GG18567@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs-linux repository at:

        git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.=20

This update contains fixes for the 4.19-rc6 cycle, I'll be pulling
in stuff for the 4.20 merge window over the next few days.

Cheers,

Dave.

The new head of the for-next branch is commit:

e55ec4ddbef9 xfs: fix error handling in xfs_bmap_extents_to_btree

----------------------------------------------------------------
Brian Foster (6):
      xfs: remove last of unnecessary xfs_defer_cancel() callers
      xfs: don't unlock invalidated buf on aborted tx commit
      xfs: clean up xfs_trans_brelse()
      xfs: refactor xfs_buf_log_item reference count handling
      xfs: remove invalid log recovery first/last cycle check
      iomap: set page dirty after partial delalloc on mkwrite

Christoph Hellwig (2):
      xfs: don't bring in extents in xfs_bmap_punch_delalloc_range
      xfs: skip delalloc COW blocks in xfs_reflink_end_cow

Darrick J. Wong (1):
      xfs: don't crash the vfs on a garbage inline symlink

Dave Chinner (3):
      xfs: avoid lockdep false positives in xfs_trans_alloc
      xfs: fix transaction leak in xfs_reflink_allocate_cow()
      xfs: fix error handling in xfs_bmap_extents_to_btree

Eric Sandeen (2):
      xfs: don't treat unknown di_flags2 as corruption in scrub
      xfs: validate inode di_forkoff

YueHaibing (1):
      xfs: remove duplicated include from alloc.c

 fs/iomap.c                      |   2 +-
 fs/xfs/libxfs/xfs_attr.c        |  28 +++-----
 fs/xfs/libxfs/xfs_attr_remote.c |  10 +--
 fs/xfs/libxfs/xfs_bmap.c        |  24 +++----
 fs/xfs/libxfs/xfs_format.h      |   2 +
 fs/xfs/libxfs/xfs_inode_buf.c   |  30 +++++++++
 fs/xfs/scrub/alloc.c            |   1 -
 fs/xfs/scrub/inode.c            |   4 +-
 fs/xfs/xfs_bmap_util.c          |  20 ++----
 fs/xfs/xfs_buf_item.c           | 119 ++++++++++++++++++----------------
 fs/xfs/xfs_buf_item.h           |   1 +
 fs/xfs/xfs_inode.c              |  10 +--
 fs/xfs/xfs_iops.c               |  12 +++-
 fs/xfs/xfs_log_recover.c        |  10 ---
 fs/xfs/xfs_reflink.c            | 137 ++++++++++++++++++++++++------------=
----
 fs/xfs/xfs_trace.h              |   1 -
 fs/xfs/xfs_trans.c              |  10 ++-
 fs/xfs/xfs_trans_buf.c          |  99 +++++++----------------------
 18 files changed, 256 insertions(+), 264 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbsW8FAAoJEK3oKUf0dfodcHQQAK+XEKMZQXKN0aUCcQBjAzaU
SoA8opFLU7knKIjBeaTOjhO5Iz8YaBmHlkSIuSPJv5imlrpI8Os/+vg1HhoiOcKW
UB5+PIQOHzauCatZ8TjWIWZXlr6ylTPRX7f8hPNJxa8uwIa7lK66u0XCEGImeV7L
6jGg3CRi6E2lP4FiEzdgZXt26CjLXp07IJNBy4KPrT/37jBHji1ccADj5O8DVTMX
H1vHTi+Fyb5fwOZ7eWLSMAYdpcMT2nQRDuCoziOGWzhij4/HhHPvIYj7ZA5a4Axv
2zaFXrHae+K+ON+1b5mO7Ro6ksOBk2jDifFnkitVzzcyd+07gJbKvb80UkZrV9AU
Y/FrZ6QljvnO8YVg7c6Ls5I9WuqifBiii74wj87MEbV6tQ1HUvTVM7BbrUD4x255
6jcNiA9yAqoILxwVnIEnRmiEKEUG0a5iNmIzJfIu5Q0rwFi1zv+p8jr481O3A95m
bttHa6JQKPhAcLzPS/aG6yrdRnqqsHaSWir8oR/FZ/yTn5utpQxZGmnpbhl1YEQv
9WwHEA9eo5eEw2ysnSryVYJWGmwNDrGp+dImr/aK+WMb3HHcaVzY9LEnM3N6Fnc4
uBRHgn4IQZdaOLbgkUF82SCPIycZVlTSsnLaOkMYdkQsKVoQdyv29B8oMtcC6dDE
by76wT4C1G/oFg/w2tcs
=le8Y
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
