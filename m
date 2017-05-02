Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60166 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750769AbdEBQ0B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 May 2017 12:26:01 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 75F7F6125D5
        for <linux-xfs@vger.kernel.org>; Tue,  2 May 2017 11:26:00 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: v4.11.0-rc2 released
Message-ID: <1ae3341e-d343-8fd9-30fe-7e21ba684ccc@sandeen.net>
Date: Tue, 2 May 2017 11:25:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.11.0-rc2.

I expect that this will be 4.11.0 final, but please give it a quick
sanity check and let me know if anything is broken or missing.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

b194269 xfsprogs: Release v4.11.0-rc2

New Commits:

Darrick J. Wong (5):
      [ca13892] xfs_db.8: document write -d option
      [6f7f892] xfs_db: allow write -d to inodes
      [966ef87] xfs_db: don't print arrays off the end of a buffer
      [58615a7] xfs_db: use iocursor type to guess btree geometry if bad magic
      [21f0bff] xfs_db: dump metadata btrees via 'btdump'

Eric Sandeen (5):
      [aa13f87] xfs_db: allow write -d to dqblks
      [dc6b7f7] xfs_io: fix statx definition for non-x86 architecture
      [23069a9] mkfs.xfs: Assign proper defaults to rmapbt and reflink flags
      [b61fdae] xfs_io: fix statx call for changed UAPI
      [b194269] xfsprogs: Release v4.11.0-rc2

chandan (1):
      [4a7aa05] xfs_io: Add statx support for PowerPC architecture


Code Diffstat:

 VERSION           |   2 +-
 configure.ac      |   2 +-
 db/Makefile       |   2 +-
 db/btblock.c      |  58 +++++++++--
 db/btdump.c       | 294 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/command.c      |   1 +
 db/command.h      |   2 +
 db/io.c           |  22 ++++
 db/io.h           |   2 +
 db/print.c        |  15 ++-
 db/write.c        |  11 +-
 doc/CHANGES       |   6 ++
 io/stat.c         |   2 +-
 io/statx.h        |  14 ++-
 man/man8/xfs_db.8 |  20 +++-
 mkfs/xfs_mkfs.c   |   4 +-
 16 files changed, 433 insertions(+), 24 deletions(-)
 create mode 100644 db/btdump.c
