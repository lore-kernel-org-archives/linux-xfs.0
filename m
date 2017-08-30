Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38892 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdH3OvW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 10:51:22 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 00/14] Crash consistency xfstest using dm-log-writes
Date: Wed, 30 Aug 2017 17:51:32 +0300
Message-Id: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Hi all,

This is the 2nd revision of crash consistency patch set.
The main thing that changed since v1 is my confidence in the failures
reported by the test, along with some more debugging options for
running the test tools.

I've collected these patches that have been sitting in Josef Bacik's
tree for a few years and kicked them a bit into shape.
The dm-log-writes target has been merged to kernel v4.1, see:
https://github.com/torvalds/linux/blob/master/Documentation/device-mapper/log-writes.txt

For this posting, I kept the random seeds constant for the test.
I set these constant seeds after running with random seed for a little
while and getting failure reports. With the current values in the test
I was able to reproduce at high probablity failures with xfs, ext4 and btrfs.
The probablity of reproducing the failure is higher on a spinning disk.

For xfs, I posted a fix for potential data loss post fsync+crash.
For ext4, I posted a reliable reproducer using dm-flakey.
For btrfs, I shared the recorded log with Josef.

There is an outstanding problem with the test - when I run it with
kvm-xfstests, the test halts and I get soft lockup of log_writes_kthread.
I suppose its a bug in dm-log-writes with some kernel config or with virtio
I wasn't able to determine the reason and have little time to debug this.

Since dm-log-writes is anyway in upstream kernel, I don't think a bug
in dm-log-writes for a certain config is a reason to block this xfstest
from being merged.
Anyway, I would be glad if someone could take a look at the soft lockup
issue. Josef?

Thanks,
Amir.

Amir Goldstein (14):
  common/rc: convert some egrep to grep
  common/rc: fix _require_xfs_io_command params check
  fsx: fixes to random seed
  fsx: fix path of .fsx* files
  fsx: fix compile warnings
  fsx: add support for integrity check with dm-log-writes target
  fsx: add optional logid prefix to log messages
  fsx: add support for --record-ops
  fsx: add support for -g filldata
  log-writes: add replay-log program to replay dm-log-writes target
  replay-log: output log replay offset in verbose mode
  replay-log: add support for replaying ops in target device range
  fstests: add support for working with dm-log-writes target
  fstests: add crash consistency fsx test using dm-log-writes

 .gitignore                   |   1 +
 README                       |   2 +
 common/dmlogwrites           |  84 +++++++++
 common/rc                    |  15 +-
 doc/auxiliary-programs.txt   |   8 +
 doc/requirement-checking.txt |  20 +++
 ltp/fsx.c                    | 220 +++++++++++++++++++----
 src/Makefile                 |   2 +-
 src/log-writes/Makefile      |  23 +++
 src/log-writes/SOURCE        |   6 +
 src/log-writes/log-writes.c  | 410 +++++++++++++++++++++++++++++++++++++++++++
 src/log-writes/log-writes.h  |  72 ++++++++
 src/log-writes/replay-log.c  | 381 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/500            | 138 +++++++++++++++
 tests/generic/500.out        |   2 +
 tests/generic/group          |   1 +
 16 files changed, 1340 insertions(+), 45 deletions(-)
 create mode 100644 common/dmlogwrites
 create mode 100644 src/log-writes/Makefile
 create mode 100644 src/log-writes/SOURCE
 create mode 100644 src/log-writes/log-writes.c
 create mode 100644 src/log-writes/log-writes.h
 create mode 100644 src/log-writes/replay-log.c
 create mode 100755 tests/generic/500
 create mode 100644 tests/generic/500.out

-- 
2.7.4

