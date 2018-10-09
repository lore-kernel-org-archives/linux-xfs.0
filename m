Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48438 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725750AbeJJGOP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 02:14:15 -0400
Received: from Liberator-5.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5D83154F
        for <linux-xfs@vger.kernel.org>; Tue,  9 Oct 2018 17:54:49 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 5f56a56
Message-ID: <e2306f09-8443-b05a-4f2a-d840ba8384d9@sandeen.net>
Date: Tue, 9 Oct 2018 17:55:01 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HYLYmzWhmnrDa8AQENYXwAtVTW0hqjkjs"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HYLYmzWhmnrDa8AQENYXwAtVTW0hqjkjs
Content-Type: multipart/mixed; boundary="Hiu0F4WQoja4lKQ6DZAdBTsTabhX2hrGp";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <e2306f09-8443-b05a-4f2a-d840ba8384d9@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to 5f56a56

--Hiu0F4WQoja4lKQ6DZAdBTsTabhX2hrGp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

This update nukes the old unsupported/unloved platforms, fixes a bunch
of sparse checker warnings (but not all), syncs a little bit more of
4.19's libxfs, includes 2 of djwong's libxfs cleanups, tidies up some
mkfs behavior, and probably a couple other things.   See below.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

(I know there are still more outstanding patches on the list, will get
to the ones I know about next, but feel free to resend if you like.)

The new head of the for-next branch is commit:

5f56a56 libxfs: export unused nonstatic functions to quiet static checker=
s

Thanks,
-Eric

New Commits:

Brian Foster (1):
      [50fba28] xfs: remove last of unnecessary xfs_defer_cancel() caller=
s

Darrick J. Wong (2):
      [f2279d8] libxfs: check libxfs_trans_commit return values
      [31845e4] libxfs: clean up IRELE/iput callsites

Dave Chinner (1):
      [d7c2f6c] xfs: fix error handling in xfs_bmap_extents_to_btree

Eric Sandeen (19):
      [f69ea1f] xfs: don't treat unknown di_flags2 as corruption in scrub=

      [91b32a0] xfs: validate inode di_forkoff
      [c4bd48e] xfsprogs: remove irix platform files
      [36b6291] xfsprogs: remove bsd platform files
      [231a533] xfsprogs: remove darwin platform files
      [bf64c90] xfsprogs: remove PKG_PLATFORM macro
      [ea01951] scrub: remove redundant debug test
      [669be3c] xfsprogs: document environment variables
      [9fae859] xfsprogs: make scrub build config-optional
      [8791bf6] xfsprogs: define xfs_stack_trace() for debug builds
      [f6ebe7c] xfsprogs: minor sparse fixes
      [e66e9ee] xfsprogs: use ANSI declarations of void-arg functions
      [33dc45c] mkfs.xfs: include full parser prototype in subopts defini=
tion
      [3dd2705] xfsprogs: don't use 0 as pointer
      [7e4109b] libxfs: avoid redefinitions of macros in mount.h
      [73ab3f6] xfsprogs: remove write-only variables
      [00ff2b1] xfsprogs: make static things static
      [a5e0945] xfsprogs: kill EXTERN macro
      [5f56a56] libxfs: export unused nonstatic functions to quiet static=
 checker

Jan Tulak (2):
      [915a27a] mkfs: discard only after all validations
      [cb46aab] mkfs: move 'mounted' check before 'existing fs' check

Zorro Lang (1):
      [248b6f9] xfs_io: remove useless do_preadv and do_pwritev arguments=



Code Diffstat:

 Makefile                  |   8 +-
 configure.ac              |  21 ++--
 copy/xfs_copy.c           |  69 ++++++-----
 db/attrset.c              |   4 +-
 db/btblock.c              |   2 +-
 db/check.c                |   4 +-
 db/dir2sf.c               |   4 +-
 db/fsmap.c                |   2 +-
 db/init.c                 |   8 +-
 db/input.c                |   6 +-
 db/io.c                   |   2 +-
 db/io.h                   |   2 +-
 db/logformat.c            |   2 +-
 doc/INSTALL               |  54 ---------
 doc/README-env-vars.txt   |  26 ++++
 estimate/xfs_estimate.c   |  34 +++---
 fsr/Makefile              |   4 -
 fsr/xfs_fsr.c             |  50 ++++----
 include/Makefile          |   8 +-
 include/builddefs.in      |  17 +--
 include/darwin.h          | 303 ----------------------------------------=
-------
 include/freebsd.h         | 198 -------------------------------
 include/gnukfreebsd.h     | 144 ----------------------
 include/xfs.h             |   6 -
 include/xfs_inode.h       |   4 +-
 io/Makefile               |  19 +--
 io/bmap.c                 |   2 +-
 io/fiemap.c               |   2 +-
 io/freeze.c               |   4 +-
 io/fsmap.c                |   2 +-
 io/imap.c                 |   2 +-
 io/init.c                 |  13 +-
 io/io.h                   |   7 +-
 io/label.c                |   1 -
 io/madvise.c              |   2 +-
 io/mincore.c              |   2 +-
 io/mmap.c                 |  10 +-
 io/parent.c               |   2 +-
 io/pread.c                |   7 +-
 io/pwrite.c               |   5 +-
 io/readdir.c              |   2 +-
 io/seek.c                 |   4 +-
 io/stat.c                 |   8 +-
 libfrog/Makefile          |   9 +-
 libfrog/darwin.c          | 136 ---------------------
 libfrog/freebsd.c         | 193 ------------------------------
 libfrog/irix.c            | 103 ----------------
 libfrog/linux.c           |   2 -
 libfrog/paths.c           |  55 ---------
 libhandle/Makefile        |   4 -
 libxcmd/command.c         |   4 +-
 libxfs/cache.c            |   2 +-
 libxfs/init.c             |   6 +-
 libxfs/init.h             |   1 -
 libxfs/libxfs_priv.h      |  58 ++++++++-
 libxfs/rdwr.c             |  17 +--
 libxfs/util.c             |   6 +-
 libxfs/xfs_attr.c         |  28 ++---
 libxfs/xfs_attr_remote.c  |  10 +-
 libxfs/xfs_bmap.c         |  24 ++--
 libxfs/xfs_format.h       |   2 +
 libxfs/xfs_inode_buf.c    |  30 +++++
 logprint/log_misc.c       |  34 +++---
 logprint/log_print_all.c  |   2 +-
 logprint/logprint.c       |   6 +-
 m4/package_globals.m4     |   4 -
 m4/package_libcdev.m4     |  19 +--
 man/man8/xfs_quota.8      |  11 +-
 mdrestore/xfs_mdrestore.c |   6 +-
 mkfs/proto.c              |  48 ++++++--
 mkfs/xfs_mkfs.c           |  89 ++++++++------
 quota/Makefile            |   6 +-
 quota/darwin.c            |  21 ----
 quota/freebsd.c           |  19 ---
 quota/irix.c              |  54 ---------
 repair/agheader.c         |   2 +-
 repair/btree.c            |   2 +-
 repair/globals.c          | 121 ++++++++++++++++++-
 repair/globals.h          | 136 +++++++++++----------
 repair/incore_ext.c       |  10 +-
 repair/incore_ino.c       |   4 +-
 repair/phase6.c           | 114 +++++++++++++-----
 repair/phase7.c           |   2 +-
 repair/progress.c         |   2 +-
 repair/rmap.c             |   4 +-
 repair/sb.c               |   2 +-
 repair/scan.c             |   2 +-
 repair/versions.c         |  23 +++-
 repair/versions.h         |  16 +--
 rtcp/xfs_rtcp.c           |   4 +-
 scrub/Makefile            |   4 +-
 scrub/fscounters.c        |   2 +-
 scrub/inodes.c            |   6 +-
 scrub/scrub.c             |   2 +-
 scrub/xfs_scrub.c         |   2 +-
 spaceman/Makefile         |   6 +-
 spaceman/init.c           |   4 +-
 97 files changed, 757 insertions(+), 1798 deletions(-)
 create mode 100644 doc/README-env-vars.txt
 delete mode 100644 include/darwin.h
 delete mode 100644 include/freebsd.h
 delete mode 100644 include/gnukfreebsd.h
 delete mode 100644 libfrog/darwin.c
 delete mode 100644 libfrog/freebsd.c
 delete mode 100644 libfrog/irix.c
 delete mode 100644 quota/darwin.c
 delete mode 100644 quota/freebsd.c
 delete mode 100644 quota/irix.c


--Hiu0F4WQoja4lKQ6DZAdBTsTabhX2hrGp--

--HYLYmzWhmnrDa8AQENYXwAtVTW0hqjkjs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlu9McUACgkQIK4WkuE9
3uDQOA//TxwYLW0RhYq9yslAN6bbIYmsvlT/0rOwHKG7BwTqHF7uWd5JE1lHHd9J
PfrdN9prPwaRPkpm6M9fcG1/4gpHSc6ABzzjYun2azr74854it3tbLSiA7Jc/zjq
m1e05+OGEhqmPd4AxCSTsUf39zP35YOAtYgBVgYKl9aRMCv4S9Ql70W/xgjJYhEE
XG/TMJxbQ03Se9eWVaWKP61QtS35Mk/0PnJHrmQaZKo5iSlW3L2xZu6DgvHM+RS3
gFQ1wIr3zpGxcAHGJPMpSTvUEW5waJQFxypzgnjXbqdR1N15RxIYNOqNwFQQqL96
kaDwg3/iQ6oMm4v9dK/VTJ2hHMsjYAFF+GCH7laDOcLvZjPjhrS2wedgyb1hUa81
E6xmyitMgKPzKlGchwA95viGWxJ0JpLbp4iZNJ31RiSRUxg4nzYTZxPcUAHQ57pi
8cWvILZ3BHYi+AxVnykdgur1RbSFgozEIeDkfKAnvPkVsBYlQwUfFlNQtyIVnnUH
KmC40maOScFc35WK9oFmgaPwm2jAJQhFFz2TYyq1IoCIjQKMqM1byf3+hIVg5nPv
nS0/TOwOvQPAl5TS/G349lsdWwnOV6heMD8fTxY61LnPaT2oI6ZhOVmfgy/6ufwk
s0Q1kOBkjiLhio9NERvD8ZZAmEkMkcEWC95eUZw/yyc4GvC7NNM=
=6z7m
-----END PGP SIGNATURE-----

--HYLYmzWhmnrDa8AQENYXwAtVTW0hqjkjs--
