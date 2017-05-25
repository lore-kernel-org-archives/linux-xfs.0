Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41317 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756827AbdEYIov (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 May 2017 04:44:51 -0400
Date: Thu, 25 May 2017 16:44:48 +0800
From: Dai Xiang <xiangx.dai@intel.com>
Subject: [lkp-developer] how to fix [not run] xfs_io fzero failed (old
 kernel/wrong fs?)
Message-ID: <20170525084448.GA27518@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: xiangx.dai@intel.com

Hi, everyone!

I met issues are as below:
generic/008      [not run] xfs_io fzero failed (old kernel/wrong fs?)
generic/009      [not run] xfs_io fzero failed (old kernel/wrong fs?)
generic/012      [not run] xfs_io fcollapse failed (old kernel/wrong
fs?)
generic/016      [not run] xfs_io fcollapse failed (old kernel/wrong
fs?)
generic/021      [not run] xfs_io fcollapse failed (old kernel/wrong
fs?)
generic/022      [not run] xfs_io fcollapse failed (old kernel/wrong
fs?)
generic/031      [not run] xfs_io fcollapse failed (old kernel/wrong
fs?)
generic/033      [not run] xfs_io fzero failed (old kernel/wrong fs?)
generic/058      [not run] xfs_io finsert failed (old kernel/wrong
fs?)
generic/060      [not run] xfs_io finsert failed (old kernel/wrong
fs?)
generic/061      [not run] xfs_io finsert failed (old kernel/wrong
fs?)
generic/064      [not run] xfs_io finsert failed (old kernel/wrong
fs?)
generic/072      [not run] xfs_io fcollapse failed (old kernel/wrong
fs?)

I read the code and retry to exec xfs_io:

root@snb-drag /lkp/benchmarks/xfstests# export TEST_DIR=/fs/sda5
root@snb-drag /lkp/benchmarks/xfstests# export TEST_DEV=/dev/sda5
root@snb-drag /lkp/benchmarks/xfstests#  export FSTYP=btrfs
root@snb-drag /lkp/benchmarks/xfstests# export SCRATCH_MNT=/fs/scratch
root@snb-drag /lkp/benchmarks/xfstests# ./check  generic/008  
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 snb-drag 4.12.0-rc1

generic/008      [not run] xfs_io fzero failed (old kernel/wrong fs?)
Not run: generic/008
Passed all 0 tests
root@snb-drag /fs/sda5# uname -r
4.12.0-rc1
root@snb-drag /fs/sda5# uname -m
x86_64
root@snb-drag /fs/sda5# export FSTYP=xfs  
root@snb-drag /fs/sda5# xfs_io  -c "pwrite 0 20k" -c "fsync" -c "fzero
4k 8k" $TEST_DIR/$$.xfs_io
wrote 20480/20480 bytes at offset 0
20 KiB, 5 ops; 0.0000 sec (2.725 GiB/sec and 714285.7143 ops/sec)
fallocate: Operation not supported
root@snb-drag /fs/sda5# export FSTYP=ext4
root@snb-drag /fs/sda5# xfs_io  -c "pwrite 0 20k" -c "fsync" -c "fzero
4k 8k" $TEST_DIR/$$.xfs_io
wrote 20480/20480 bytes at offset 0
20 KiB, 5 ops; 0.0000 sec (3.179 GiB/sec and 833333.3333 ops/sec)
fallocate: Operation not supported


root@snb-drag /fs/sda5# xfs_io -F -f -c "pwrite 0 20k" -c "fsync" -c
"fzero 4k 8k" $TEST_DIR/$$.xfs_io
wrote 20480/20480 bytes at offset 0
20 KiB, 5 ops; 0.0000 sec (1.467 GiB/sec and 384615.3846 ops/sec)
fallocate: Operation not supported

>From the output, I can not know how to fix?
The kernel is enough new and the fs seems right.
Could you help me?

Thanks
Dai Xiang
