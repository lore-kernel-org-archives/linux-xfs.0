Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41928 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbeBBV1B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Feb 2018 16:27:01 -0500
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6603D2B0F
        for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2018 15:26:38 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to ffdd272
Message-ID: <053a5823-432e-25c0-e5d1-d5a80b1fe300@sandeen.net>
Date: Fri, 2 Feb 2018 15:26:59 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8fxBDI9fUJNjcKo4dpaylDmk3SiRxroEi"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8fxBDI9fUJNjcKo4dpaylDmk3SiRxroEi
Content-Type: multipart/mixed; boundary="dnmX9j7ZhfGREHfvynIBAM2oMqGJV6Tom";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <053a5823-432e-25c0-e5d1-d5a80b1fe300@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to ffdd272

--dnmX9j7ZhfGREHfvynIBAM2oMqGJV6Tom
Content-Type: text/plain; charset=utf-8
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

The vast majority of this is the new scrub userspace code from
Darrick.

The new head of the for-next branch is commit:

ffdd272 xfs_scrub: handle scrub-only kernels more helpfully

New Commits:

Darrick J. Wong (34):
      [ba795fb] xfs_db: interpret inode timestamps as signed integers
      [25f9772] misc: ubsan fixes
      [91c7d13] mkfs: don't crash on dswidth overflow
      [0b1cf8b] mkfs: don't call values 'illegal', they're invalid
      [7d25f65] mkfs: always explain why numeric inputs are invalid
      [95b1e50] xfs_scrub: create online filesystem scrub program
      [f0585fc] xfs_scrub: common error handling
      [828105d] xfs_scrub: set up command line argument parsing
      [173a028] xfs_scrub: dispatch the various phases of the scrub progr=
am
      [e031d90] xfs_scrub: figure out how many threads we're going to nee=
d
      [a555a1f] xfs_scrub: create an abstraction for a block device
      [50a573a] xfs_scrub: find XFS filesystem geometry
      [372d4ba] xfs_scrub: add inode iteration functions
      [bc94c5d] xfs_scrub: add space map iteration functions
      [c6eb0ff] xfs_scrub: add file space map iteration functions
      [604dd33] xfs_scrub: filesystem counter collection functions
      [fd7d73c] xfs_scrub: wrap the scrub ioctl
      [e758ad0] xfs_scrub: scan filesystem and AG metadata
      [d11cc69] xfs_scrub: thread-safe stats counter
      [fa16b37] xfs_scrub: scan inodes
      [c4892e7] xfs_scrub: check directory connectivity
      [396cd02] xfs_scrub: warn about suspicious characters in directory/=
xattr n
      [4bbed4e] xfs_scrub: warn about normalized Unicode name collisions
      [0cf6f68] xfs_scrub: create a bitmap data structure
      [2000470] xfs_scrub: create infrastructure to read verify data bloc=
ks
      [b364a9c] xfs_scrub: scrub file data blocks
      [03c0cd8] xfs_scrub: optionally use SCSI READ VERIFY commands to sc=
rub dat
      [698c6c7] xfs_scrub: check summary counters
      [7e36bc0] xfs_scrub: fstrim the free areas if there are no errors o=
n the f
      [ed60d21] xfs_scrub: progress indicator
      [f1dca11] xfs_scrub: create a script to scrub all xfs filesystems
      [824b580] xfs_scrub: integrate services with systemd
      [5c7826c] debian/control: remove nonexistent libreadline5-dev build=
 depend
      [1985247] xfs_scrub: wire up repair ioctl

Eric Sandeen (2):
      [16adcb8] mkfs: more sunit/swidth sanity checking
      [ffdd272] xfs_scrub: handle scrub-only kernels more helpfully


Code Diffstat:

 .gitignore                       |   5 +
 Makefile                         |   3 +-
 configure.ac                     |  11 +
 db/bit.c                         |   4 +-
 db/fprint.c                      |   3 +-
 debian/control                   |   4 +-
 debian/postinst                  |   3 +
 include/builddefs.in             |  12 +
 include/ptvar.h                  |  32 ++
 libfrog/Makefile                 |   1 +
 libfrog/ptvar.c                  | 133 +++++++
 m4/Makefile                      |   3 +
 m4/package_attr.m4               |  23 ++
 m4/package_libcdev.m4            |  76 ++++
 m4/package_services.m4           |  77 ++++
 m4/package_unistring.m4          |  19 +
 man/man8/xfs_scrub.8             | 147 ++++++++
 man/man8/xfs_scrub_all.8         |  32 ++
 mkfs/xfs_mkfs.c                  |  34 +-
 repair/sb.c                      |   4 +-
 scrub/Makefile                   | 142 +++++++
 scrub/bitmap.c                   | 410 ++++++++++++++++++++
 scrub/bitmap.h                   |  38 ++
 scrub/common.c                   | 391 +++++++++++++++++++
 scrub/common.h                   |  92 +++++
 scrub/counter.c                  | 104 ++++++
 scrub/counter.h                  |  29 ++
 scrub/disk.c                     | 315 ++++++++++++++++
 scrub/disk.h                     |  40 ++
 scrub/filemap.c                  | 157 ++++++++
 scrub/filemap.h                  |  39 ++
 scrub/fscounters.c               | 212 +++++++++++
 scrub/fscounters.h               |  29 ++
 scrub/inodes.c                   | 297 +++++++++++++++
 scrub/inodes.h                   |  32 ++
 scrub/phase1.c                   | 245 ++++++++++++
 scrub/phase2.c                   | 148 ++++++++
 scrub/phase3.c                   | 169 +++++++++
 scrub/phase4.c                   |  96 +++++
 scrub/phase5.c                   | 314 ++++++++++++++++
 scrub/phase6.c                   | 544 +++++++++++++++++++++++++++
 scrub/phase7.c                   | 266 +++++++++++++
 scrub/progress.c                 | 223 +++++++++++
 scrub/progress.h                 |  33 ++
 scrub/read_verify.c              | 270 ++++++++++++++
 scrub/read_verify.h              |  50 +++
 scrub/scrub.c                    | 783 +++++++++++++++++++++++++++++++++=
++++++
 scrub/scrub.h                    |  82 ++++
 scrub/spacemap.c                 | 256 +++++++++++++
 scrub/spacemap.h                 |  31 ++
 scrub/unicrash.c                 | 392 ++++++++++++++++++++
 scrub/unicrash.h                 |  47 +++
 scrub/vfs.c                      | 248 +++++++++++++
 scrub/vfs.h                      |  33 ++
 scrub/xfs_scrub.c                | 765 +++++++++++++++++++++++++++++++++=
+++++
 scrub/xfs_scrub.h                | 128 +++++++
 scrub/xfs_scrub@.service.in      |  20 +
 scrub/xfs_scrub_all.cron.in      |   1 +
 scrub/xfs_scrub_all.in           | 203 ++++++++++
 scrub/xfs_scrub_all.service.in   |  10 +
 scrub/xfs_scrub_all.timer        |  11 +
 scrub/xfs_scrub_fail             |  26 ++
 scrub/xfs_scrub_fail@.service.in |  10 +
 tools/find-api-violations.sh     |   2 +-
 64 files changed, 8338 insertions(+), 21 deletions(-)
 create mode 100644 include/ptvar.h
 create mode 100644 libfrog/ptvar.c
 create mode 100644 m4/package_attr.m4
 create mode 100644 m4/package_services.m4
 create mode 100644 m4/package_unistring.m4
 create mode 100644 man/man8/xfs_scrub.8
 create mode 100644 man/man8/xfs_scrub_all.8
 create mode 100644 scrub/Makefile
 create mode 100644 scrub/bitmap.c
 create mode 100644 scrub/bitmap.h
 create mode 100644 scrub/common.c
 create mode 100644 scrub/common.h
 create mode 100644 scrub/counter.c
 create mode 100644 scrub/counter.h
 create mode 100644 scrub/disk.c
 create mode 100644 scrub/disk.h
 create mode 100644 scrub/filemap.c
 create mode 100644 scrub/filemap.h
 create mode 100644 scrub/fscounters.c
 create mode 100644 scrub/fscounters.h
 create mode 100644 scrub/inodes.c
 create mode 100644 scrub/inodes.h
 create mode 100644 scrub/phase1.c
 create mode 100644 scrub/phase2.c
 create mode 100644 scrub/phase3.c
 create mode 100644 scrub/phase4.c
 create mode 100644 scrub/phase5.c
 create mode 100644 scrub/phase6.c
 create mode 100644 scrub/phase7.c
 create mode 100644 scrub/progress.c
 create mode 100644 scrub/progress.h
 create mode 100644 scrub/read_verify.c
 create mode 100644 scrub/read_verify.h
 create mode 100644 scrub/scrub.c
 create mode 100644 scrub/scrub.h
 create mode 100644 scrub/spacemap.c
 create mode 100644 scrub/spacemap.h
 create mode 100644 scrub/unicrash.c
 create mode 100644 scrub/unicrash.h
 create mode 100644 scrub/vfs.c
 create mode 100644 scrub/vfs.h
 create mode 100644 scrub/xfs_scrub.c
 create mode 100644 scrub/xfs_scrub.h
 create mode 100644 scrub/xfs_scrub@.service.in
 create mode 100644 scrub/xfs_scrub_all.cron.in
 create mode 100644 scrub/xfs_scrub_all.in
 create mode 100644 scrub/xfs_scrub_all.service.in
 create mode 100644 scrub/xfs_scrub_all.timer
 create mode 100755 scrub/xfs_scrub_fail
 create mode 100644 scrub/xfs_scrub_fail@.service.in


--dnmX9j7ZhfGREHfvynIBAM2oMqGJV6Tom--

--8fxBDI9fUJNjcKo4dpaylDmk3SiRxroEi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlp016QACgkQIK4WkuE9
3uDnYQ/9EgZLC6m68f/fF71oGg/50IOve7MLYxPkdCJ+WF3HAAl6DbppF54UePB4
yAHmyuZGwRAQnhTwx3mmHzRwKuMBZfF1qIgbW13mlyIykPpss5QkVytSwGtrl509
6jrJnDE+Zn4bbJoDhXrLG6jnTDb2F6FEMMR+z/FUrcu6muGE5poMMx3gGOm9ybGB
VZyiFR1YnyxMVtBhiL2nT/D/fcJ82S30NbNcF6f1thkSj3MaZnldPkUOq6WHAiDj
wvVgtPhhTbC8JZRh+9KtXSWZMFu9YFnGIDHjqg4hDPdCWCIpMd3PwxdSoVyZhRCq
rDttkh7iG6sGCKqIwIJOuyTgFgeNRVyG3f7PdqxbWzXx5u1XawRL7Hexf1U4ZRx6
egFc1OJ9imPLk3UH9Fte5fehWmLDdOKnQ7GS4ZovyfJXyvjLZJ5YegUz1w6KU3kq
ZqSWkC5f2Ku9lt9e32lsrNEKtLaybrMRXoRaA1zqzPfVxgM8bRJuG1KJVQJkBbqJ
7JXkptXfFKmNJzLDwtaRAj+DKiW0bNTMOP/IhupLfyzAtBuTqjO2Cvu+gp6biHaG
mHrYgj1oJfXMp0nVcBYV//Pl0e05cqSefFpb7GbVlDx2cFU5DWTOONa0Ynj0SqqW
VplQVnLgugynRdfCuR6/HAKhahH0Pdzy612rzMezOYNv3JuYyDk=
=WuLx
-----END PGP SIGNATURE-----

--8fxBDI9fUJNjcKo4dpaylDmk3SiRxroEi--
