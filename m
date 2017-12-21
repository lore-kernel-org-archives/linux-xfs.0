Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:57506 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752066AbdLUWIK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Dec 2017 17:08:10 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [xfsprogs PATCH v4 0/2] Add necessary items for MAP_SYNC testing
Date: Thu, 21 Dec 2017 15:07:58 -0700
Message-Id: <20171221220800.14382-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>

This is the fourth revision of my MAP_SYNC + dm-log-writes support for
xfsprogs.  The previous revision can be found here:

https://lists.01.org/pipermail/linux-nvdimm/2017-December/013473.html

Changes since v3:

 - Fixed indentation of variable declarations (Darrick).

 - Added a comment for the case where MAP_SYNC and MAP_SHARED_VALIDATE
   aren't defined in system headers and we fail an msync command
   (Darrick).
 
 - Dropped patch 1 of the previous series which fixed compiler warnings.
   A fix for this issue was already submitted by Dave.

---

As suggested by Dave Chinner:

    As I say to all these sorts of one-off test prgrams: please add the
    new MAP_SYNC flag to xfs_io rather than writing a one-off
    test program to set it and write some data.

    And if we're going to be adding special custom tests just because
    we need to insert dm-log marks, add that functionality to xfs_io,
    too.

    That way we can create complex custom dm logwrite tests without
    needing one-off test programs for them all...

This series enhances xfs_io by adding support for the MAP_SYNC mmap() flag
and for dm-log-writes marks.  This allows the resulting xfstest for
MAP_SYNC to be much simpler and have no custom C programs.

Ross Zwisler (2):
  xfs_io: add MAP_SYNC support to mmap()
  xfs_io: add a new 'log_writes' command

 configure.ac            |   2 +
 debian/control          |   2 +-
 include/builddefs.in    |   3 ++
 include/linux.h         |   8 ++++
 io/Makefile             |  10 +++++
 io/init.c               |   1 +
 io/io.h                 |   7 ++++
 io/log_writes.c         | 106 ++++++++++++++++++++++++++++++++++++++++++++++++
 io/mmap.c               |  29 ++++++++++---
 m4/Makefile             |   1 +
 m4/package_devmapper.m4 |  11 +++++
 m4/package_libcdev.m4   |  16 ++++++++
 man/man8/xfs_io.8       |  29 ++++++++++++-
 13 files changed, 217 insertions(+), 8 deletions(-)
 create mode 100644 io/log_writes.c
 create mode 100644 m4/package_devmapper.m4

-- 
2.14.3

