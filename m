Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:40653 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751747AbdF1GEY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jun 2017 02:04:24 -0400
Date: Wed, 28 Jun 2017 14:04:01 +0800
From: Dai Xiang <xiangx.dai@intel.com>
Subject: [QUESTION] xfstest generic/042 run failed
Message-ID: <20170628060401.GA11840@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: xiangx.dai@intel.com

I really do not know where is wrong:

root@ubuntu ~/xfstests# ./check generic/042
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 test 4.12.0-rc6
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda4
MOUNT_OPTIONS -- /dev/sda4 /fs/scratch

generic/042	 - output mismatch (see ~/xfstests/results//generic/042.out.bad)
    --- tests/generic/042.out	2017-05-31 18:15:23.000000000 +0800
    +++ ~/xfstests/results//generic/042.out.bad	2017-06-28 11:02:01.111749909 +0800
    @@ -5,6 +5,16 @@
     fpunch
     wrote 65536/65536 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    +0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
    +*
    +000f000 0000 0000 0000 0000 0000 0000 0000 0000
    +*
    ...
    (Run 'diff -u tests/generic/042.out ~/xfstests/results//generic/042.out.bad'  to see the entire diff)
Ran: generic/042
Failures: generic/042
Failed 1 of 1 tests

`falloc -k` can work, but `fpunch` and `fzero -k` can not.
I have little knowledge about them, could you help me?

Thanks
Dai Xiang
