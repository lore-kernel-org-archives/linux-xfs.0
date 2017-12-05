Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:65530 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753038AbdLEX5G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Dec 2017 18:57:06 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [xfsprogs PATCH v2 0/3] Add necessary items for MAP_SYNC testing
Date: Tue,  5 Dec 2017 16:56:48 -0700
Message-Id: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>

This is the second revision of my MAP_SYNC + dm-log-writes support for
xfsprogs.  The previous revision can be found here:

https://lists.01.org/pipermail/linux-nvdimm/2017-November/013326.html

Changes since v1:

 - Updated the dm-log-writes support so that it uses libdevmapper
   instead of calling the "dmsetup" stand-alone exectuable via system().
   (Eric and Darrick)

 - Fixed our MAP_SYNC handling so that instead of defining the flags for
   systems that don't have them in the headers, just set them to 0 and
   fail when the -S flag is used. (Dan)

You can find an xfsprogs branch with this series here:

https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfsprogs-dev.git/log/?h=map_sync_v2

Both MAP_SYNC and the DAX enhancements for dm-log-writes can be found in
v4.15-rc*.  For ease of testing I've posted a kernel that is v4.14 plus
just those two patch series here:

https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/linux.git/log/?h=map_sync_dm_log_writes

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

Ross Zwisler (3):
  xfs_io: fix compiler warnings in getfsmap code
  xfs_io: add MAP_SYNC support to mmap()
  xfs_io: add a new 'log_writes' command

 configure.ac            |   2 +
 debian/control          |   2 +-
 include/builddefs.in    |   3 ++
 include/linux.h         |   8 ++++
 io/Makefile             |  10 +++++
 io/fsmap.c              |   4 +-
 io/init.c               |   1 +
 io/io.h                 |   7 ++++
 io/log_writes.c         | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
 io/mmap.c               |  23 ++++++++---
 m4/Makefile             |   1 +
 m4/package_devmapper.m4 |  11 ++++++
 m4/package_libcdev.m4   |  16 ++++++++
 man/man8/xfs_io.8       |  29 +++++++++++++-
 14 files changed, 208 insertions(+), 10 deletions(-)
 create mode 100644 io/log_writes.c
 create mode 100644 m4/package_devmapper.m4

-- 
2.14.3

