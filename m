Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752618AbcIUEXV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Sep 2016 00:23:21 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6A619C05490D
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2016 04:23:20 +0000 (UTC)
Received: from localhost (dhcp-12-196.nay.redhat.com [10.66.12.196])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u8L4NJUG003514
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2016 00:23:19 -0400
Date: Wed, 21 Sep 2016 12:23:18 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: xfs/032 find xfs corruption
Message-ID: <20160921042318.GR12847@dhcp12-143.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

xfs/032 trigger xfs(v4/v5) corruption after run it several times:
[root@dhcp-13-149 xfstests-dev]# xfs_repair -n ~/xfs-032.img 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
sb_icount 64, counted 256
sb_ifree 61, counted 242
sb_fdblocks 1038280, counted 1035431
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
entry "d8" in shortform directory 1572896 references free inode 38
would have junked entry "d8" in directory inode 1572896
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "d8" in shortform directory inode 1572896 points to free inode 38
would junk entry
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 524320, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 1069090 nlinks from 2 to 1
would have reset inode 1572896 nlinks from 4 to 3
No modify flag set, skipping filesystem flush and exiting.

xfs/032 try to test different sectorsize and blocksize, I hit this bug
on different size everytime. V4 and V5 XFS all can trigger this bug.

Test on upstream linux 4.8-rc7, xfsprogs v4.8.0-rc1.

Even merged Eric's patch:
 [PATCH] xfs_copy: Fix meta UUID handling on multiple copies
I still can reproduce this bug.

Thanks,
Zorro
