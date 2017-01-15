Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59916 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751200AbdAOSxo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Jan 2017 13:53:44 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 25CBA628EDA
        for <linux-xfs@vger.kernel.org>; Sun, 15 Jan 2017 12:52:53 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 29043c6
Message-ID: <e65b56ac-7e4f-8e0b-e891-a6c7cc3ee82f@sandeen.net>
Date: Sun, 15 Jan 2017 12:53:36 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5tUH3ApNbQA9sRIN4lWgME5KUAsoLHM04"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5tUH3ApNbQA9sRIN4lWgME5KUAsoLHM04
Content-Type: multipart/mixed; boundary="XsBT7AReOOO4c0nEMEEEvtCB8TgrkQbwF";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <e65b56ac-7e4f-8e0b-e891-a6c7cc3ee82f@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 29043c6

--XsBT7AReOOO4c0nEMEEEvtCB8TgrkQbwF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This is a largish collection of various fixes, enhancements, and
updates.  After a little soak time, I'll merge this plus the
libxfs/ changes currently in for-next to master.  Any testing and/or
bug reports are most welcome.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

29043c6 xfs_repair: update the manual content about xfs_repair exit statu=
s

New Commits:

Anna Schumaker (1):
      [4314180] xfs_io: Improvements to copy_range return code handling

Darrick J. Wong (4):
      [2ca36c2] xfs_io: prefix dedupe command error messages consistently=

      [0bd6599] xfs_io: fix the minimum arguments to the reflink command
      [c327e1f] xfs_io: fix some documentation problems
      [9fcc120] xfs_repair.8: document dirty log conditions

Dave Chinner (6):
      [7a9b731] libxcmd: check CMD_FLAG_GLOBAL inside args_command()
      [ef346a2] libxcmd: rename args_command to command_iterator
      [d6ac046] libxcmd: merge command() and iterate_command()
      [92058d2] libxcmd: don't check generic library commands
      [16bf046] xfs_io: make various commands one-shot only
      [58a1899] libxcmd: add non-iterating user commands

Deepa Dinamani (1):
      [8211d1b] xfs_io: implement 'utimes' command

Eric Biggers (2):
      [06e7a37] xfs_io.8: remove duplicate .TP commands
      [0cf66b0] xfs_io: implement 'set_encpolicy' and 'get_encpolicy' com=
mands

Eric Sandeen (5):
      [3c84c54] xfs_logprint: di_gen is unsigned
      [5e303e2] xfsprogs: fix a couple 32-bit build warnings
      [11613dd] Update licenses in COPYING file
      [1f31bd2] build: add tar.xz target
      [1162297] libxfs-apply: minor improvements

Gwendal Grignou (1):
      [0a71e38] build: Allow compiling xfsprogs in a cross compile enviro=
nment

Jan Engelhardt (2):
      [30a0fce] build: resolve autoheader warning
      [8432255] build: add missing AC_PROG_INSTALL

Ralph Sennhauser (1):
      [2b86cff] xfs_io: fix building with musl

Zirong Lang (1):
      [29043c6] xfs_repair: update the manual content about xfs_repair ex=
it status


Code Diffstat:

 Makefile                 |  10 +-
 configure.ac             |  21 ++-
 doc/COPYING              | 414 ++++-------------------------------------=
------
 include/builddefs.in     |   6 +-
 include/command.h        |  13 +-
 include/input.h          |   1 +
 io/Makefile              |   6 +-
 io/copy_file_range.c     |   5 +-
 io/encrypt.c             | 302 ++++++++++++++++++++++++++++++++++
 io/file.c                |   4 +-
 io/freeze.c              |   4 +-
 io/getrusage.c           |   3 +-
 io/imap.c                |   2 +-
 io/init.c                |  29 ++--
 io/inject.c              |   2 +-
 io/io.h                  |   2 +
 io/link.c                |   2 +-
 io/mmap.c                |   7 +-
 io/open.c                |   7 +-
 io/readdir.c             |  11 +-
 io/reflink.c             |  14 +-
 io/resblks.c             |   2 +-
 io/shutdown.c            |   2 +-
 io/sync.c                |   3 +-
 io/utimes.c              |  81 ++++++++++
 libxcmd/command.c        | 159 ++++++++++++------
 libxcmd/help.c           |   2 +-
 libxcmd/input.c          |  22 +++
 libxcmd/quit.c           |   2 +-
 libxfs/Makefile          |   4 +-
 logprint/log_print_all.c |   2 +-
 m4/package_types.m4      |   1 +
 man/man8/xfs_io.8        |  86 ++++++++--
 man/man8/xfs_repair.8    |  35 +++-
 quota/init.c             |  13 +-
 quota/init.h             |   2 -
 quota/path.c             |   4 +-
 quota/report.c           |   2 +-
 tools/libxfs-apply       |  14 +-
 39 files changed, 779 insertions(+), 522 deletions(-)
 create mode 100644 io/encrypt.c
 create mode 100755 io/utimes.c



--XsBT7AReOOO4c0nEMEEEvtCB8TgrkQbwF--

--5tUH3ApNbQA9sRIN4lWgME5KUAsoLHM04
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYe8U3AAoJECCuFpLhPd7g64IP/jO3KMj4vK/UALEpmJL1MiUh
tFEs08e4f7jfy/xr9nhSVZ0kML0hFQlvw7qbiW0xGbbD0RKMdFVgww/WLvI7TPQo
SWddXqLv+F/F/FMztnZ27EJH4nQPLTOogJ5tvEQidKzg9yLfj9IyWk2yVgTivE15
eYfG6HHZSC0mygcWWB/128Z4JI9tjOLw3SdQItk5qYSJrDfs1yMcU9yCWeSaC0cp
lbKngrpQg3FX58g99sAVS9aLdbeG92aXm6vvVIgrd+rqypp/uGE8qqPDpmVOKnl+
QOKENPR8L3CZsMfz8n7p06Xl3DkIEUeS9AlMtbqGyRktAH7cChpc+/TU7mVUdthC
03mLe0BwQWNgNWnoKGEGNZYCmMMqJgd3IPCmdxjudge5xX2xfsGFJjN1b5zlA5EU
qFFf8cuGdd9aIPjzwYZZlKpm77a95ohU4vXi2vCrqWscoK4JAtvc9qSqL6CV5IOK
YbuSxwCN/pMamKeQ82rIISDWPxmuvhrOzAV9i1+BdmaGPV66HX+6wpAC/jByRmCo
NEm/vxMJucOn/x3vzRMKCy6pa5kZsqjuBzZOuuzbyNEpLU4VmR6CBGU0yK4KY2j/
L7y+6UWkQl6E9HeZl8xscNvpleord1lRW39qlhv1A91mjejEwYI2MLsy2DALaFwJ
kfGCaVSjOzKrZ32I9TVx
=Fjpu
-----END PGP SIGNATURE-----

--5tUH3ApNbQA9sRIN4lWgME5KUAsoLHM04--
