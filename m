Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56380 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750984AbdKIRMO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 12:12:14 -0500
Received: from [10.0.0.4] (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 44A498A
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2017 11:12:14 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 1480ecc / 4.14.0-rc1
Message-ID: <50f1c0a1-c0d7-5ac8-f584-88cb13e06461@sandeen.net>
Date: Thu, 9 Nov 2017 11:12:13 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with 4.14.0-rc1

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

Goldwyn, I'd like to get your pwritev2 stuff in for 4.14.0-rc2, sorry
for the late review on that.

I don't expect much more for 4.14.0, hope to get it out soon and then
pull in all the exciting new stuff on the list.

The new head of the master branch is commit:

1480ecc xfs_repair: always release btree buffers when refcountbt checks fail

New Commits:

Darrick J. Wong (11):
      [c91fbc6] db: increase metadump's default overly long extent discard  thre
      [45733f9] xfsprogs: explicitly cast troublesome types to match printf  for
      [f63cc53] xfs_io: add new error injection knobs to inject command
      [334124f] xfs_repair: fix bag memory overwrite problems
      [f9f4390] xfs_repair: clear DAX flag from non-file inodes
      [f869827] xfs_repair: fix cowextsize field checking and repairing
      [2f48a94] misc: enable ubsan if the builder wants it
      [6e298d6] misc: enable gcc/clang address sanitizer if the builder wants it
      [dcfb176] misc: enable thread sanitizer if the builder wants it
      [e22fc14] misc: fix ubsan warnings
      [1480ecc] xfs_repair: always release btree buffers when refcountbt checks 

Eric Sandeen (1):
      [9f4a556] xfs_metadump: zap stale data in DIR2_LEAF1 dirs

Felix Janda (1):
      [fea5d94] kill off u_int*_t types

Jan Tulak (1):
      [a294cd5] metadump: update manpage for dirty log/obfuscation issue

Liu Bo (1):
      [0c3974a] xfs_io: report io error for pwrite -W and -w

Luis R. Rodriguez (1):
      [b1d7b30] build: define _DEFAULT_SOURCE with _BSD_SOURCE for preadv

Zirong Lang (1):
      [0c9b1e9] xfsprogs: add xfs_spaceman to .gitignore


Code Diffstat:

 .gitignore              |  1 +
 Makefile                |  2 ++
 configure.ac            | 43 +++++++++++++++++++++++++++++++++++
 db/check.c              |  2 +-
 db/metadump.c           | 43 +++++++++++++++++++++++++++++++----
 debian/rules            |  4 ++--
 include/bitops.h        |  8 +++----
 include/builddefs.in    |  6 +++--
 include/buildmacros     |  2 +-
 include/command.h       |  6 ++---
 include/darwin.h        |  8 ++-----
 include/xfs_arch.h      |  2 +-
 io/fiemap.c             | 37 +++++++++++++++++--------------
 io/inject.c             |  8 ++++++-
 io/open.c               |  4 ++--
 io/pread.c              |  2 ++
 io/pwrite.c             | 16 ++++++++++----
 io/stat.c               | 26 +++++++++++-----------
 libxfs/xfs_format.h     |  2 +-
 m4/Makefile             |  1 +
 m4/package_libcdev.m4   |  1 +
 m4/package_sanitizer.m4 | 59 +++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_metadump.8 | 18 ++++++++++++++-
 repair/attr_repair.c    |  6 +++--
 repair/dinode.c         | 34 +++++++++++++++++++++++++++-
 repair/phase6.c         |  4 ++--
 repair/rmap.c           |  3 ++-
 repair/scan.c           |  9 +++++---
 repair/slab.c           |  2 +-
 29 files changed, 287 insertions(+), 72 deletions(-)
 create mode 100644 m4/package_sanitizer.m4
