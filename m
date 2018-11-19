Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbeKSPnJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Nov 2018 10:43:09 -0500
Date: Mon, 19 Nov 2018 13:22:52 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH 0/6] xfstests: add copy/dedupe/clone to fsx/fsstress
Message-ID: <20181119052251.GQ2279@dhcp-12-117.nay.redhat.com>
References: <154215237717.21151.11976488103599724788.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154215237717.21151.11976488103599724788.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Nov 13, 2018 at 03:39:37PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> This series adds to fsx support for FICLONERANGE, FIDEDUPERANGE, and
> copy_file_range.  It adds to fsstress support for copy_file_range.
> There are known failures in 4.20-rc2, particularly with copy_file_range,
> so these patches provide a fstests base for everyone to start/continue
> looking for bugs.

Hi Darrick,

Your patches triggered 2 new failures on g/091 and g/263, refer to [1]. I can't
reproduce these failures on original xfstests [2]. I saw you were talking about g/091
in #xfs. Are these two failures same issue?

Thanks,
Zorro

[1]
# ./check --large-fs generic/075 generic/127 generic/112 generic/263 generic/091 generic/231 generic/499 generic/511 generic/469 generic/455 generic/456 generic/4
57 xfs/207
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 hp-dl580g7-04 4.18.0-39.el8.x86_64
MKFS_OPTIONS  -- -f -b size=2048 /dev/mapper/VG500T-LV500T
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/mapper/VG500T-LV500T /mnt/scratch

generic/075      15s
generic/091     [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//generic/091.out.bad)                                                                                
    --- tests/generic/091.out   2018-11-16 22:51:29.117927437 +0800
    +++ /root/git/xfstests/results//generic/091.out.bad 2018-11-19 11:18:21.618028378 +0800
    @@ -5,3 +5,31 @@
     fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
    +mapped writes DISABLED
    +Seed set to 1
    +skipping zero size read
    +truncating to largest ever: 0xe400
    ...
    (Run 'diff -u tests/generic/091.out /root/git/xfstests/results//generic/091.out.bad'  to see the entire diff)                                                                             
generic/112      16s
generic/127      225s
generic/231      179s
generic/263     [failed, exit status 1]- output mismatch (see /root/git/xfstests/results//generic/263.out.bad)                                                                                
    --- tests/generic/263.out   2018-11-16 22:51:29.172929902 +0800
    +++ /root/git/xfstests/results//generic/263.out.bad 2018-11-19 11:25:24.841385577 +0800
    @@ -1,3 +1,52 @@
     QA output created by 263
     fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
     fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
    +Seed set to 1
    +skipping zero size read
    +truncating to largest ever: 0xe400
    +fallocating to largest ever: 0x49915
    ...
    (Run 'diff -u tests/generic/263.out /root/git/xfstests/results//generic/263.out.bad'  to see the entire diff)                                                                             
generic/455      2024s
generic/456      27s
generic/457      350s
generic/469      1s
generic/499      26s
generic/511      2s
xfs/207  47s
Ran: generic/075 generic/091 generic/112 generic/127 generic/231 generic/263 generic/455 generic/456 generic/457 generic/469 generic/499 generic/511 xfs/207
Failures: generic/091 generic/263
Failed 2 of 13 tests

[2]
# ./check --large-fs generic/075 generic/127 generic/112 generic/263 generic/091 generic/231 generic/499 generic/511 generic/469 generic/455 generic/456 generic/457 xfs/207
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 hp-dl580g7-04 4.18.0-39.el8.x86_64
MKFS_OPTIONS  -- -f -bsize=4096 /dev/mapper/VG500T-LV500T
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/mapper/VG500T-LV500T /mnt/scratch

generic/075 18s ...  17s
generic/091 24s ...  16s
generic/112 18s ...  18s
generic/127 267s ...  214s
generic/231 199s ...  198s
generic/263 10s ...  9s
generic/455      2728s
generic/456 27s ...  26s
generic/457      367s
generic/469 1s ...  2s
generic/499 27s ...  24s
generic/511      3s
xfs/207  47s
Ran: generic/075 generic/091 generic/112 generic/127 generic/231 generic/263 generic/455 generic/456 generic/457 generic/469 generic/499 generic/511 xfs/207
Passed all 13 tests



> 
> --D
