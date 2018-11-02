Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33016 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbeKCBXZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Nov 2018 21:23:25 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1184BD5A
        for <linux-xfs@vger.kernel.org>; Fri,  2 Nov 2018 11:14:58 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to v4.19.0-rc1
Message-ID: <39a3713e-8490-8ad5-fd61-66fdc8fd0208@sandeen.net>
Date: Fri, 2 Nov 2018 11:15:43 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A394C6BwE0SHYgAPSE3I7LxyIj9JBtpSL"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A394C6BwE0SHYgAPSE3I7LxyIj9JBtpSL
Content-Type: multipart/mixed; boundary="YRHOsfMHIgMN1pwTsOAaMYkG6S0yuzm7b";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <39a3713e-8490-8ad5-fd61-66fdc8fd0208@sandeen.net>
Subject: [ANNOUNCE] xfsprogs for-next updated to v4.19.0-rc1

--YRHOsfMHIgMN1pwTsOAaMYkG6S0yuzm7b
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

If you have any /bugfixes/ that need to make it to 4.19, now's
the time to speak up.  This is essentially what 4.19.0 will look
like barring any late-breaking bug discoveries.

The new head of the for-next branch is commit:

6c26bea xfsprogs: Release v4.19.0-rc1

This will likely be merged to master in a day or two.

New Commits:

Brian Foster (1):
      [50fba28] xfs: remove last of unnecessary xfs_defer_cancel() caller=
s

Darrick J. Wong (7):
      [f2279d8] libxfs: check libxfs_trans_commit return values
      [31845e4] libxfs: clean up IRELE/iput callsites
      [2937043] xfs_scrub_all: fix systemd escaping again
      [d18ae0e] misc: only build with lto if explicitly enabled
      [f6302b0] xfs_scrub: lack of kernel support is not a service failur=
e
      [c8dc76e] libxfs: add missing agfl free deferred op type
      [99a5535] xfs_io: add crc32 self test

Dave Chinner (5):
      [d7c2f6c] xfs: fix error handling in xfs_bmap_extents_to_btree
      [9060cb3] xfsprogs: document changes for 4.19.0-rc0
      [b9df750] xfsprogs: remove unused functions
      [71a6af8] Revert "xfs_repair: treat zero da btree pointers as corru=
ption"
      [119383b] xfs_repair: don't dirty inodes unconditionally when testi=
ng unli

Eric Sandeen (45):
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
 checke
      [b657185] xfsprogs: don't include all xfs headers just for crc32
      [6a40ccc] xfs_db: convert single-bit bitfields to bools
      [8e1338f] xfsprogs: minor endian annotation fixes
      [2bba5a0] xfsprogs: avoid redefinition of NBBY
      [4a87b33] xfsprogs: include headers for extern variables
      [4e00636] libxfs: add several zone extern declarations to libxfs_pr=
iv.h
      [1281240] libxfs: silence static warnings about platform_* function=
s
      [011f253] xfs_io: include io.h to silence static function warnings
      [7ed3b9b] libxfs: silence sparse static function warnings in util.c=

      [37717cc] avl64: export avl64_firstino / avl64_firstino from avl64.=
h
      [28e36fc] xfsprogs: misc static function warning fixes
      [4add9d5] xfsprogs: don't shadow global libxfs_init x variable
      [86715cc] xfs_io: rename global buffer variable
      [4a706e0] xfs_logprint: fix shadow var in xlog_print_trans_buffer
      [925638b] xfs_repair: fix 'bno' shadow vars in scan.c
      [4ace28d] xfs_scrub: remove shadow var from run_scrub_phases()
      [8ab6f7e] xfs_metadump: remove shadow variable
      [440cb37] libfrog: change project entity variable scope to local/st=
atic.
      [d4739a5] xfsprogs: enable sparse checking with make C=3D1
      [e51fde0] xfsprogs: enable sparse checking with make C=3D2
      [44ec419] xfsprogs: remove retpoline support
      [1624c34] xfs_repair: initialize realloced bplist in longform_dir2_=
entry_c
      [ea7be34] xfs_repair: continue after xfs_bunmapi deadlock avoidance=

      [7cf2aa1] xfs_repair: kick processing thread if ra_count is at limi=
t
      [cb5de90] xfs_db: print freecount in xfs_inobt_rec as unsigned
      [6c26bea] xfsprogs: Release v4.19.0-rc1

Jan Tulak (2):
      [915a27a] mkfs: discard only after all validations
      [cb46aab] mkfs: move 'mounted' check before 'existing fs' check

Zorro Lang (1):
      [248b6f9] xfs_io: remove useless do_preadv and do_pwritev arguments=



Code Diffstat:

 Makefile                   |  22 +-
 VERSION                    |   2 +-
 configure.ac               |  28 +-
 copy/xfs_copy.c            |  71 +++--
 db/attrset.c               |   4 +-
 db/btblock.c               |   4 +-
 db/check.c                 |  23 +-
 db/crc.c                   |   7 +-
 db/dir2sf.c                |   4 +-
 db/fsmap.c                 |   2 +-
 db/fuzz.c                  |   1 +
 db/hash.c                  |   1 +
 db/init.c                  |   8 +-
 db/input.c                 |   6 +-
 db/io.c                    |   2 +-
 db/io.h                    |  10 +-
 db/logformat.c             |   3 +-
 db/metadump.c              |  13 +-
 db/symlink.c               |   2 +-
 db/text.c                  |   1 +
 db/write.c                 |   4 +-
 debian/changelog           |  13 +
 doc/CHANGES                |  25 ++
 doc/INSTALL                |  54 ----
 doc/README-env-vars.txt    |  26 ++
 doc/sparse.txt             |  12 +-
 estimate/xfs_estimate.c    |  34 +--
 fsr/Makefile               |   4 -
 fsr/xfs_fsr.c              |  50 ++--
 include/Makefile           |   8 +-
 include/avl64.h            |   6 +
 include/builddefs.in       |  24 +-
 include/buildrules         |  19 ++
 include/crc32cselftest.h   | 706 +++++++++++++++++++++++++++++++++++++++=
++++++
 include/darwin.h           | 303 -------------------
 include/freebsd.h          | 198 -------------
 include/gnukfreebsd.h      | 144 ---------
 include/platform_defs.h.in |   2 +
 include/xfs.h              |   6 -
 include/xfs_inode.h        |   4 +-
 io/Makefile                |  21 +-
 io/bmap.c                  |   2 +-
 io/crc32cselftest.c        |  37 +++
 io/fiemap.c                |   2 +-
 io/freeze.c                |   4 +-
 io/fsmap.c                 |   2 +-
 io/getrusage.c             |   1 +
 io/imap.c                  |   2 +-
 io/init.c                  |  14 +-
 io/io.h                    |  12 +-
 io/label.c                 |   1 -
 io/log_writes.c            |   1 +
 io/madvise.c               |   2 +-
 io/mincore.c               |   2 +-
 io/mmap.c                  |  16 +-
 io/parent.c                |   2 +-
 io/pread.c                 |  63 ++--
 io/pwrite.c                |  33 +--
 io/readdir.c               |   2 +-
 io/seek.c                  |   4 +-
 io/stat.c                  |   8 +-
 libfrog/Makefile           |   9 +-
 libfrog/crc32.c            | 675 +--------------------------------------=
----
 libfrog/darwin.c           | 136 ---------
 libfrog/freebsd.c          | 193 -------------
 libfrog/irix.c             | 103 -------
 libfrog/linux.c            |   3 +-
 libfrog/paths.c            |  55 ----
 libfrog/projects.c         |  12 +-
 libhandle/Makefile         |   4 -
 libxcmd/command.c          |   4 +-
 libxfs/cache.c             |   2 +-
 libxfs/defer_item.c        |  44 +++
 libxfs/init.c              |  15 +-
 libxfs/init.h              |   4 +-
 libxfs/libxfs_priv.h       |  65 ++++-
 libxfs/rdwr.c              |  25 +-
 libxfs/util.c              |  68 +----
 libxfs/xfs_attr.c          |  28 +-
 libxfs/xfs_attr_remote.c   |  10 +-
 libxfs/xfs_bmap.c          |  24 +-
 libxfs/xfs_format.h        |   2 +
 libxfs/xfs_inode_buf.c     |  30 ++
 logprint/log_misc.c        |  82 +++---
 logprint/log_print_all.c   |   2 +-
 logprint/logprint.c        |   6 +-
 m4/package_globals.m4      |   4 -
 m4/package_libcdev.m4      |  41 +--
 man/man8/xfs_io.8          |   4 +
 man/man8/xfs_quota.8       |  11 +-
 mdrestore/xfs_mdrestore.c  |   6 +-
 mkfs/proto.c               |  48 ++-
 mkfs/xfs_mkfs.c            |  89 +++---
 quota/Makefile             |   6 +-
 quota/darwin.c             |  21 --
 quota/freebsd.c            |  19 --
 quota/irix.c               |  54 ----
 repair/agheader.c          |   2 +-
 repair/btree.c             |  23 --
 repair/dinode.c            |  24 +-
 repair/dir2.c              |   6 +-
 repair/globals.c           | 121 +++++++-
 repair/globals.h           | 136 +++++----
 repair/incore_ext.c        |  10 +-
 repair/incore_ino.c        |   4 +-
 repair/phase2.c            |   2 -
 repair/phase6.c            | 148 +++++++---
 repair/phase7.c            |   2 +-
 repair/prefetch.c          |   4 +
 repair/progress.c          |   2 +-
 repair/rmap.c              |   7 +-
 repair/sb.c                |   2 +-
 repair/scan.c              |  24 +-
 repair/scan.h              |   2 +
 repair/versions.c          |  23 +-
 repair/versions.h          |  16 +-
 rtcp/xfs_rtcp.c            |   4 +-
 scrub/Makefile             |   4 +-
 scrub/fscounters.c         |   2 +-
 scrub/inodes.c             |   6 +-
 scrub/scrub.c              |   2 +-
 scrub/xfs_scrub.c          |  17 +-
 scrub/xfs_scrub.h          |   2 +
 scrub/xfs_scrub_all.in     |   9 +-
 spaceman/Makefile          |   6 +-
 spaceman/init.c            |   4 +-
 126 files changed, 1850 insertions(+), 2755 deletions(-)
 create mode 100644 doc/README-env-vars.txt
 create mode 100644 include/crc32cselftest.h
 delete mode 100644 include/darwin.h
 delete mode 100644 include/freebsd.h
 delete mode 100644 include/gnukfreebsd.h
 create mode 100644 io/crc32cselftest.c
 delete mode 100644 libfrog/darwin.c
 delete mode 100644 libfrog/freebsd.c
 delete mode 100644 libfrog/irix.c
 delete mode 100644 quota/darwin.c
 delete mode 100644 quota/freebsd.c
 delete mode 100644 quota/irix.c


--YRHOsfMHIgMN1pwTsOAaMYkG6S0yuzm7b--

--A394C6BwE0SHYgAPSE3I7LxyIj9JBtpSL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlvceDAACgkQIK4WkuE9
3uBo8g//UfuD+pRQtoUPJY7xYXOTMbxURpTvbgN1Rba3qC84u8yjcmtqLp+I6Bi3
uiQWGYD6eQFvQhSgRfhJFq/dJ0DfkNhNOSXdYLZ/Zmdsr6w9hhU+i69itRKD+LHO
pRQNKbzvwdMK9w0Dh2m942kLr5CeN9K2uaBQG/I4J/RgQG/4hnC5Yl/tTy6N2yCP
t1ptfK0w29c8P6Wr9m71MM5bqLbBpfKKeb5Ht71Qv93jnraceEuWzVdxv1IpL2mo
a8asFpzz6J+BKe4iw0oegiIzrReBm0uF3O4y4HUnMBcKr78JH0yQ4MN81XFt9RWl
TQTR29bu7/6rythVoJF3MXtJ+ACuBjLN6kjHADZaVoK702KWmUtXSneuKOg3mYXy
ILFW6jpqRoIME7Hf7YUa1rvaeGPpuqODE29eUsCOXdh4uITLPhoASgX9V01rNsQn
ZW0ck/WHzCVCSVKV3ykCB60b8xyFTNp0jyoCqSelI4wPpYc7jOP9numKIVaDkF8I
bYALvEp5nzDzoa94mKJmVbqCemZtccHg+n5wEZY9DO6bf7VpY5b/nZVj4ovuaPuh
kmg/WAmrYzZnCwl9f6YR1UGZg3SLdLhoHCrT9vtu1fkYSYLQrEmp4b/8cgsuia8+
/fIjXFbokhNa4ijzqRQj/P7TqITjksPvcYWnK+g52+Jz/+WUknQ=
=pHyq
-----END PGP SIGNATURE-----

--A394C6BwE0SHYgAPSE3I7LxyIj9JBtpSL--
