Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:9768 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751621AbcJCAGW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2016 20:06:22 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1bqqlt-0007Hx-KY
        for linux-xfs@vger.kernel.org; Mon, 03 Oct 2016 11:06:17 +1100
Date: Mon, 3 Oct 2016 11:06:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch rebased to 155cd433b516
Message-ID: <20161003000617.GL27872@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This was a rebase as I added fixes to the end
of stable topic branches and remerged them to rebuild the tree
cleanly. The tree, as it sits, is what I plan to send to Linus later
in the week, so if there's anything you notice wrong, please let me
know quickly...

The new head of the for-next branch is commit:

155cd433b516 Merge branch 'xfs-4.9-log-recovery-fixes' into for-next

New Commits:

Christoph Hellwig (3):
      [d5bfccdf38d0] ext2: fix possible integer truncation in ext2_iomap_be=
gin
      [a447d7cd15c7] xfs: update atime before I/O in xfs_file_dio_aio_read
      [0d5b0cf246a3] fs: update atime before I/O in generic_file_read_iter

Dave Chinner (5):
      [b036b97050a9] Merge branch 'iomap-4.9-misc-fixes-1' into for-next
      [79ad57612495] Merge branch 'xfs-4.9-reflink-prep' into for-next
      [a89b3f97bb7c] Merge branch 'xfs-4.9-delalloc-rework' into for-next
      [a1f45e668e14] Merge branch 'iomap-4.9-dax' into for-next
      [155cd433b516] Merge branch 'xfs-4.9-log-recovery-fixes' into for-next


Code Diffstat:

 fs/ext2/inode.c   |  2 +-
 fs/xfs/xfs_file.c |  3 ++-
 mm/filemap.c      | 14 +++++++-------
 3 files changed, 10 insertions(+), 9 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX8aD5AAoJEK3oKUf0dfodiVoP/2lOmppGDcMnQbGrp/ap/3z1
VnHKgNujpR3wzs3uIPRWl/ZJwmUlTihfrL3+HEucZiaE0bZtpfgwlMw7ESAxQeQP
raBvSHvVOawFOb0UqIYCn8cng7UC5CjJhMSYtmrLoc8CqOU01Y27w2ZaWPGmI1Bi
MD4W2urNtJRq2iJLlengigq9/vi4pi+AyD9SDf0KKmIub36QU+DitaMRXxlYotRr
/zNPeqRbgeDVm4kwQCj2yicvZsj716+l+nSstv25ux0niRm9/x1ymR06zRvMZfh/
SceakjICui/0QjI9xwPbEqJhnlJysRxFFNeSYJtf3xYVTup8P+ubntF2ZVTcfl93
jWqgpX1kd1y5NxRpWwspppTsWdoFCNxLcW9EFk6wljdCg0dJopvDxl7WhE6vRfdG
cl7uYUH90wRtA9y5+DcDE0y09SXshMPt1oyE1C+7wDxgDu490bdVAfPPEHVygPOX
1M+VlSsm6eKwNpS5oWEOSBdDmnEkNKU1wNuMWV9yiopwEqTL53A4WHP4A92pmRIq
xqq6sytYzbr6IDtuW4D5MwOICqMeLM07Zpd4rH1uZ1P+Nkv8WRSNVcyP8r0bRhH3
YSTGEacBe6fFyj4eeUIov3Fw+D9W+9X+b672r3EXmAfLwp2OvYMe7oA1ACqt3q6Z
Z9LEr9jJpHERxePh4RO5
=mUHp
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
