Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40120 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727681AbeLLRud (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Dec 2018 12:50:33 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 79D3E562
        for <linux-xfs@vger.kernel.org>; Wed, 12 Dec 2018 11:50:24 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 2a5eb70
Message-ID: <52d12d2f-bb0f-c87e-5eec-67af66ffeab6@sandeen.net>
Date: Wed, 12 Dec 2018 11:50:31 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NvCQglaQOiVW8hVQE97SKKpDRChxt80qa"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NvCQglaQOiVW8hVQE97SKKpDRChxt80qa
Content-Type: multipart/mixed; boundary="vYZLwPR4DzQSGYh9um3rm9HaLMPqtNjiK";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <52d12d2f-bb0f-c87e-5eec-67af66ffeab6@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 2a5eb70

--vYZLwPR4DzQSGYh9um3rm9HaLMPqtNjiK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is the libxfs syncup and a handful of other commits.  Yes, the
metadump fixes are still pending.  Feel free to remind/ping other
stuff that's not in this update.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please ping me or resubmit them to linux-xfs@vger.kernel.org so they
can be picked up in the next update.

The new head of the for-next branch is commit:

2a5eb70 xfs_db: teach the frag command about sparse inode chunks

Thanks,
-Eric

New Commits:

Allison Henderson (4):
      [2860efe] xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
      [6db48a6] xfs: Add helper function xfs_attr_try_sf_addname
      [932b563] xfs: Add attibute set and helper functions
      [05b0a4a] xfs: Add attibute remove and helper functions

Christoph Hellwig (1):
      [b7fdeb4] xfs: remove suport for filesystems without unwritten exte=
nt flag

Darrick J. Wong (7):
      [782a18d] xfs_io.8: rearrange command listings by section
      [3d2195e] xfs_repair: rebuild directory when non-root leafn blocks =
claim b
      [f9c9fd9] xfs_repair: skip block reservation when fixing freelist
      [300661d] xfs_scrub: handle totally empty inode chunks
      [058f45d] xfs_scrub: fix fractional reporting of single inodes
      [f26db47] xfs_scrub: move everything to /usr/sbin
      [9b92d4b] xfs_db: add missing string name for DBM_COWDATA

Dave Chinner (6):
      [f26e485] xfs: fix overflow in xfs_attr3_leaf_verify
      [eda2a7e] xfs: finobt AG reserves don't consider last AG can be a r=
unt
      [3833299] xfs: delalloc -> unwritten COW fork allocation can go wro=
ng
      [1a05efb] io: open pipes in non-blocking mode
      [2c8482a] xfs_io: allow open file permissions to be changed
      [2a42470] xfs_io: copy_file_range length is a size_t

Eric Sandeen (4):
      [dbd3d46] xfs: fix inverted return from xfs_btree_sblock_verify_crc=

      [80afe23] xfsprogs: don't install xfs_scrub man pages if config'd o=
ff
      [153d2ff] mkfs.xfs: null-terminate symlinks created via protofile
      [2a5eb70] xfs_db: teach the frag command about sparse inode chunks


Code Diffstat:

 db/check.c                |  11 +
 db/frag.c                 |  61 +++--
 db/sb.c                   |   6 +-
 io/copy_file_range.c      |   6 +-
 io/open.c                 |  67 ++++++
 libxfs/libxfs_api_defs.h  |   1 +
 libxfs/xfs_attr.c         | 236 +++++++++++--------
 libxfs/xfs_attr.h         | 150 ++++++++++++
 libxfs/xfs_attr_leaf.c    |  11 +-
 libxfs/xfs_bmap.c         |  75 +++---
 libxfs/xfs_bmap.h         |   1 +
 libxfs/xfs_btree.c        |   2 +-
 libxfs/xfs_format.h       |   8 +-
 libxfs/xfs_ialloc_btree.c |  11 +-
 libxfs/xfs_sb.c           |   5 +-
 man/man8/Makefile         |   6 +-
 man/man8/xfs_io.8         | 570 ++++++++++++++++++++++++----------------=
------
 mkfs/proto.c              |  13 +-
 repair/dinode.c           |  18 +-
 repair/dir2.c             |  15 +-
 repair/rmap.c             |   3 +-
 repair/sb.c               |   7 +-
 repair/versions.c         |   5 +-
 scrub/Makefile            |  12 +-
 scrub/common.c            |   5 +-
 scrub/common.h            |   2 +-
 scrub/inodes.c            |   6 +
 scrub/phase7.c            |  34 +--
 28 files changed, 833 insertions(+), 514 deletions(-)
 create mode 100644 libxfs/xfs_attr.h


--vYZLwPR4DzQSGYh9um3rm9HaLMPqtNjiK--

--NvCQglaQOiVW8hVQE97SKKpDRChxt80qa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlwRSmgACgkQIK4WkuE9
3uDFHA/+PyMhwo3QTT6qbtImPQxMDxTJXITmmE1FNo3SkIR8yPN3PFa9Sq4CsaA1
D8cRyxO8qNpM1o4EkUou6E87VcQ7pAxd7itMAWlZqQYCXoSR/XoZHyQ/4Anl+VBp
8hrn4XDWgvsY/UtJxZEY73NWdZeC+jcFXD7JuPzf1lM01YvdIGQqCS4cBHebPShu
+rCrJSLxYbO+9Fel7Th69a6pVJzIS9odAbBBjQSkn5HRKTRV8n5k40F+qylTqVYs
eOZFYSd7Ong4FEGFeiyYEo/TGcoAXvg3xfqLP3gUAZI/qfGCYTIK33BACNWJ4NrZ
96FjJX2r9qAJkh5t170fGjyFyLBGgXi+Q0G1HsKVnPpN/Sjlv6uvs6s66AxKsmQt
cnUOvcrY/qFQpIe4LkzXuNmCKV9kJSnc43JYtuimxbj1zXAPQGIelp+kfxs+NnpQ
/1eXJIb903Rr/BA9KgnOnn7Zq7eSr4zfZOdu6mDeSK21uJktjPyt6KQtGwlJkeIP
v2pwS/5yzPXH1gafOhGATf3xrxwQ8DAhho17o4VklZSCp20VHrsvkTDNpfS2NZm0
emDgePUj45bAY6s0vzJsniXZXNPuReDHX4iPHoeFInJEH10prE+XaTT3XyUWVQGw
3bMz+/Z4/7yxJ8OjrE4N/0/4L9YVrAghvhqKMpUC7oAQYOhBEpY=
=XTtS
-----END PGP SIGNATURE-----

--NvCQglaQOiVW8hVQE97SKKpDRChxt80qa--
