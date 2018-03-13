Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:34823 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932211AbeCMCP1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Mar 2018 22:15:27 -0400
Received: by mail-ua0-f169.google.com with SMTP id c40so8229185uae.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Mar 2018 19:15:26 -0700 (PDT)
MIME-Version: 1.0
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Mon, 12 Mar 2018 21:15:25 -0500
Message-ID: <CA+EzBbCtp9wKC=KeN+N1iZDa2+TsWxVho3aUkeXJXguVswkChA@mail.gmail.com>
Subject: XFS crash consistency bug : Loss of fsynced metadata operation
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>, Ashlie Martinez <ashmrtn@utexas.edu>

Hi,

We've encountered what seems to be a crash consistency bug in
xfs(kernel 4.15) due to the interaction between delayed allocated
write and an unaligned fallocate(zero range) : Fallocate_zero_range is
not persisted even when followed by a fsync - thereby leading to a
loss of fsynced metadata operation on a file.

Say we create a disk image with known data and quick format it.
1. Now write 65K of data to a new file
2. Zero out a part of the above file using falloc_zero_range (60K+128)
- (60K+128+4096) - an unaligned block
3. fsync the above file
4. Crash

If we crash after the fsync, and allow reordering of the block IOs
between two flush/fua commands using Crashmonkey[1], then we can end
up not persisting the zero_range command in step 2 above, even if we
crashed after a fsync.

This workload was inspired from xfstest/generic_042, which tests for
stale data exposure using aligned fallocate commands. It's worth
noting that f2fs and btrfs passes our test clean - irrespective of the
order of bios, user data is intact and fzero operation is correctly persisted.

To reproduce this bug using CrashMonkey, simply run :
./c_harness -f /dev/sda -d /dev/cow_ram0 -t xfs -e 102400 -s 1000 -v
tests/generic_042/generic_042_fzero_unaligned.so

and take a look at the <timestamp>-generic_042_fzero_unaligned.log
created in the build directory. This file has the list of block IOs
issued during the workload and the permutation of bios that lead to
this bug. You can also verify using blktrace that CrashMonkey only
reorders bios between two barrier operations(thereby such a crash
state could be encountered due to reordering blocks at the storage
stack). Note that tools like dm-log-writes cannot capture this bug
because this arises due to reordering blocks between barrier
operations.

Possible reason for this bug :
On closely inspecting the reason for this bug, we discovered that the
problem lies in updating a data block twice, without a barrier
operation between the two updates. The blktrace for the above
mentioned workload shows that sector 280 is updated twice - probably
first due to the write and later due to the fzero operation. However
notice that there is no barrier between the two updates, and using
Crashmonkey we see the above mentioned bug when these two updates to
the same block are reordered. Essentially, a reordering here means
fzero goes through first, and is later overwritten by the delayed
allocated write.

 0.000179069  7104  Q  WS 280 + 16 [c_harness]
 0.000594994  7104  Q   R 280 + 8 [c_harness]
 0.000598216  7104  Q   R 288 + 8 [c_harness]
 0.000620552  7104  Q  WS 160 + 120 [c_harness]
 0.000653742  7104  Q  WS 280 + 16 [c_harness]
 0.000733154  7104  Q FWFSM 102466 + 3 [c_harness]

This seems to be a bug, as it is not persisting the metadata operation
even in the presence of fsync.

Let me know if I am missing some detail here.

[1] https://github.com/utsaslab/crashmonkey.git

Thanks,
Jayashree Mohan
