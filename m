Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753554AbdEIQMx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 12:12:53 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [xfstests PATCH v2 0/3] xfstest for updated writeback error handling
Date: Tue,  9 May 2017 12:12:42 -0400
Message-Id: <20170509161245.29908-1-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, fstests@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, rpeterso@redhat.com, bo.li.liu@oracle.com

I've numbered the new test as 999 for the moment so as not to collide with
tests being added while I've been working on this. I can change that and
resend if this should go in.

I'm working on a set of kernel patches to change how writeback errors
are handled and reported in the kernel. Instead of reporting a
writeback error to only the first fsync caller on the file, I aim
to make the kernel report them once on every file description:

   http://www.spinics.net/lists/kernel/msg2504453.html

This patch adds a test for the new behavior, on local filesystems that
can handle journalling to a separate device. Basically, open many fds to
the same file, turn on dm_error, write to each of the fds, and then
fsync them all to ensure that they all get an error back. Then, flip the
device back to working, reopen the files and ensure that no error is
reported.

With the kernel patch series in place, ext4 and xfs now pass. btrfs still
clears the error after the first fsync, so it seems like it still needs a
bit of work.

Jeff Layton (3):
  generic: add a writeback error handling test
  ext4: allow ext4 to use $SCRATCH_LOGDEV
  btrfs: allow it to use $SCRATCH_LOGDEV

 common/dmerror        |  13 +++--
 common/rc             |   5 ++
 src/Makefile          |   2 +-
 src/fsync-err.c       | 138 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999     |  75 +++++++++++++++++++++++++++
 tests/generic/999.out |   3 ++
 tests/generic/group   |   1 +
 tools/dmerror         |  47 +++++++++++++++++
 8 files changed, 278 insertions(+), 6 deletions(-)
 create mode 100644 src/fsync-err.c
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out
 create mode 100755 tools/dmerror

-- 
2.9.3

