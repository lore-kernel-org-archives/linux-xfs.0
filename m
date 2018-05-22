Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25232 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751571AbeEVA3p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 May 2018 20:29:45 -0400
From: Dave Jiang <dave.jiang@intel.com>
Subject: xfs regression
Message-ID: <446e1035-335f-afe1-3448-8428a338a1ad@intel.com>
Date: Mon, 21 May 2018 17:29:44 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Darrick,
I may have hit an xfs regression that shows up in 4.16 that fails
xfstest xfs/348. I have bisected it to this commit:
9cfb9b47479e237d217dbcfafe034cbf98f45909 ("xfs: provide a centralized
method for verifying inline fork data")

# ./check xfs/348
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 skx-ntbusd 4.15.0-rc7+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/pmem0p2
/mnt/xfstests_scratch

xfs/348 29s ... - output mismatch (see
/root/xfstests/xfstests-dev/results//xfs/348.out.bad)
    --- tests/xfs/348.out       2017-10-19 10:57:22.561819578 -0700
    +++ /root/xfstests/xfstests-dev/results//xfs/348.out.bad
2018-05-21 17:13:39.171256163 -0700
    @@ -239,7 +239,7 @@
     would have junked entry "DIR" in directory PARENT_INO
     would have junked entry "EMPTY" in directory PARENT_INO
     would have junked entry "FIFO" in directory PARENT_INO
    -stat: 'SCRATCH_MNT/test/DIR' is a symbolic link
    +stat: cannot stat 'SCRATCH_MNT/test/DIR': Structure needs cleaning
     stat: 'SCRATCH_MNT/test/DATA' is a symbolic link
     stat: cannot stat 'SCRATCH_MNT/test/EMPTY': Structure needs cleaning
    ...
    (Run 'diff -u tests/xfs/348.out
/root/xfstests/xfstests-dev/results//xfs/348.out.bad'  to see the entire
diff)
Ran: xfs/348
Failures: xfs/348
Failed 1 of 1 tests

-- 

Dave Jiang
Software Engineer, SSG/OTC
Intel Corp.
dave.jiang@intel.com
