Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751337AbdBJERn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Feb 2017 23:17:43 -0500
Date: Fri, 10 Feb 2017 11:53:48 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: [BUG 4.10-rc7] sb_fdblocks inconsistency in xfs/297 test
Message-ID: <20170210035348.GA7075@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, mhocko@suse.com

Hi,

I was testing 4.10-rc7 kernel and noticed that xfs_repair reported XFS
corruption after fstests xfs/297 test. This didn't happen with 4.10-rc6
kernel, and git bisect pointed the first bad commit to

commit d1908f52557b3230fbd63c0429f3b4b748bf2b6d
Author: Michal Hocko <mhocko@suse.com>
Date:   Fri Feb 3 13:13:26 2017 -0800

    fs: break out of iomap_file_buffered_write on fatal signals

    Tetsuo has noticed that an OOM stress test which performs large write
    requests can cause the full memory reserves depletion.  He has tracked
    this down to the following path
....

It's the sb_fdblocks field reports inconsistency:
...
Phase 2 - using internal log   
        - zero log...
        - scan filesystem freespace and inode maps...
sb_fdblocks 3367765, counted 3367863
        - 11:37:41: scanning filesystem freespace - 16 of 16 allocation groups done
        - found root inode chunk
...

And it can be reproduced almost 100% with all XFS test configurations
(e.g. xfs_4k xfs_2k_reflink), on all test hosts I tried (so I didn't
bother pasting my detailed test and host configs, if more info is needed
please let me know).

Thanks,
Eryu

P.S. full xfs_repair -n output

*** xfs_repair -n output ***   
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log   
        - zero log...
        - scan filesystem freespace and inode maps...
sb_fdblocks 3367765, counted 3367863
        - 11:37:41: scanning filesystem freespace - 16 of 16 allocation groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - 11:37:41: scanning agi unlinked lists - 16 of 16 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 15
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - 11:37:42: process known inodes and inode discovery - 13760 of 13760 inodes done
        - process newly discovered inodes...
        - 11:37:42: process newly discovered inodes - 16 of 16 allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 11:37:42: setting up duplicate extent list - 16 of 16 allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 3
        - agno = 1
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - 11:37:42: check for inodes claiming duplicate blocks - 13760 of 13760 inodes done
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
        - 11:37:43: verify and correct link counts - 16 of 16 allocation groups done
No modify flag set, skipping filesystem flush and exiting.
