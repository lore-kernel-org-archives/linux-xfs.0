Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:39578 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032939AbeBNQ4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 11:56:33 -0500
MIME-Version: 1.0
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Wed, 14 Feb 2018 10:56:31 -0600
Message-ID: <CA+EzBbBtpD=shOwnWLwTfkb-mmyaznndGNL3saSEobX0uT7MfA@mail.gmail.com>
Subject: Behavior of falloc collapse range when preceded by falloc keep size :
 Possible eof block loss
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

Hi,

I am Jayashree Mohan, a PhD student at the University of Texas at
Austin, working with Prof. Vijay Chidambaram. I've been working on the
Crashmonkey project, which is a test harness for file system crash
consistency checks[1].

While trying to reproduce some of the reported bugs on filesystems
using CrashMonkey we stumbled upon the following issue:

Whenever we have a collapse_range operation that follows fallocate
with keep_size that allocated blocks beyond the end-of-file, the eof
blocks are lost due to the collapse_range operation in f2fs and xfs.

Consider the following workload(The number within the braces indicate
the start and end offsets)
1. Write (0 - 428K)
     Sync()
2. Fallocate keep_size (428K - 432K )
3. Fallocate collapse_range (112K - 128K)

If we now stat the file, the result is as follows for ext4:
 1. After write (0-428K)
  Size: 438272     Blocks: 856        IO Block: 1024   regular file

 2. Falloc keep_size 428K - 432K
  Size: 438272     Blocks: 864        IO Block: 1024   regular file

 3. Falloc collapse_range 112K - 128K
  Size: 421888     Blocks: 832        IO Block: 1024   regular file

The block count at the end of collapse_range is 32 blocks less than
step 2, which corresponds to the 16K range that was collapsed. So this
behavior makes sense. However consider the same for f2fs and xfs,

If we now stat the file, the result is as follows for f2fs:
 1. After write (0-428K)
  Size: 438272     Blocks: 856        IO Block: 4096   regular file

 2. Falloc keep_size 428K - 432K
  Size: 438272     Blocks: 864        IO Block: 4096   regular file

 3. Falloc collapse_range 112K - 128K
  Size: 421888     Blocks: 824        IO Block: 4096   regular file

If we now stat the file, the result is as follows for xfs:
 1. After write (0-428K)
  Size: 438272     Blocks: 856        IO Block: 4096   regular file
xfs_bmap :  0: [0..855]: 160..1015

 2. Falloc keep_size 428K - 432K
  Size: 438272     Blocks: 864        IO Block: 4096   regular file
xfs_bmap : 0: [0..855]: 160..1015
                  1: [856..863]: 1016..1023

 3. Falloc collapse_range 112K - 128K
  Size: 421888     Blocks: 824        IO Block: 4096   regular file
xfs_bmap : 0: [0..223]: 160..383
                   1: [224..823]: 416..1015

If we didn't have the keep_size option with fallocate in step 2, then
we see the xfs_bmap after step 3 to be
0: [0..223]: 160..383
1: [224..823]: 416..1015
2: [824..831]: 1016..1023

This clearly shows, the blocks allocated beyond the eof are lost
during the collapse_range operation, if keep_size was specified while
allocating these blocks. This behavior is seen in both f2fs and xfs,
while ext4 seems to preserve the allocated blocks. All these were
tested on linux kernel 4.15. Shouldn't f2fs and xfs also behave like
ext4?

Let me know if I am missing some detail.

[1] https://github.com/utsaslab/crashmonkey

Thanks,
Jayashree
