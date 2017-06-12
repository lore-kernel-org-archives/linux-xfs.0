Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750868AbdFLMmQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jun 2017 08:42:16 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [xfstests PATCH v4 0/5] new tests for writeback error reporting behavior
Date: Mon, 12 Jun 2017 08:42:08 -0400
Message-Id: <20170612124213.14855-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>, tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com, ross.zwisler@linux.intel.com, corbet@lwn.net, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Eryu Guan <eguan@redhat.com>, David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

v4: respin set based on Eryu's comments

These tests are companion tests to the patchset I recently posted with
the cover letter:

    [PATCH v6 00/20] fs: enhanced writeback error reporting with errseq_t (pile #1)

This set just adds 3 new xfstests to test writeback behavior. One generic
filesystem test, one test for raw block devices, and one test for btrfs.
The tests work with dmerror to ensure that writeback fails, and then
tests how the kernel reports errors afterward.

xfs, ext2/3/4 and btrfs all pass on a kernel with the patchset above.

The one comment I couldn't really address from earlier review is that
we don't have a great way for xfstests to tell what sort of error
reporting behavior it should expect from the running kernel. That
makes it difficult to tell whether failure is expected during a given
run.

Maybe that's OK though and we should just let unconverted filesystems
fail this test?

Jeff Layton (5):
  generic: add a writeback error handling test
  ext4: allow ext4 to use $SCRATCH_LOGDEV
  generic: test writeback error handling on dmerror devices
  ext3: allow it to put journal on a separate device when doing
    scratch_mkfs
  btrfs: make a btrfs version of writeback error reporting test

 .gitignore                 |   1 +
 common/dmerror             |  13 ++-
 common/rc                  |  14 ++-
 doc/auxiliary-programs.txt |  16 ++++
 src/Makefile               |   2 +-
 src/dmerror                |  44 +++++++++
 src/fsync-err.c            | 223 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/999            |  93 +++++++++++++++++++
 tests/btrfs/group          |   1 +
 tests/generic/998          |  64 +++++++++++++
 tests/generic/998.out      |   2 +
 tests/generic/999          |  77 ++++++++++++++++
 tests/generic/999.out      |   3 +
 tests/generic/group        |   2 +
 14 files changed, 548 insertions(+), 7 deletions(-)
 create mode 100755 src/dmerror
 create mode 100644 src/fsync-err.c
 create mode 100755 tests/btrfs/999
 create mode 100755 tests/generic/998
 create mode 100644 tests/generic/998.out
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

-- 
2.13.0

