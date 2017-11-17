Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55943 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760992AbdKQUZh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Nov 2017 15:25:37 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [xfsprogs PATCH 0/2] Add necessary items for MAP_SYNC testing
Date: Fri, 17 Nov 2017 13:25:22 -0700
Message-Id: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, fstests <fstests@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>

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

You can find an xfsprogs branch with this series here:

https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/xfsprogs-dev.git/log/?h=map_sync

Both MAP_SYNC and the DAX enhancements for dm-log-writes will be found in
the upcoming v4.15-rc1.  For ease of testing I've posted a kernel that is
v4.14 plus just those two patch series here:

https://git.kernel.org/pub/scm/linux/kernel/git/zwisler/linux.git/log/?h=map_sync_dm_log_writes

Ross Zwisler (2):
  xfs_io: add MAP_SYNC support to mmap()
  xfs_io: add a new 'log_writes' command

 configure.ac          |  1 +
 include/builddefs.in  |  1 +
 include/linux.h       |  5 ++++
 io/Makefile           |  5 ++--
 io/init.c             |  1 +
 io/io.h               |  2 ++
 io/log_writes.c       | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
 io/mmap.c             | 19 +++++++++----
 m4/package_libcdev.m4 | 16 +++++++++++
 man/man8/xfs_io.8     | 25 ++++++++++++++++-
 10 files changed, 145 insertions(+), 8 deletions(-)
 create mode 100644 io/log_writes.c

--
2.9.5

