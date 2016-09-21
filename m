Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755366AbcIUDIn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Sep 2016 23:08:43 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E00E88E69C
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2016 03:08:42 +0000 (UTC)
Received: from localhost (dhcp12-196.nay.redhat.com [10.66.12.196] (may be forged))
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u8L38fwB008646
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2016 23:08:42 -0400
Date: Wed, 21 Sep 2016 11:08:41 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: xfs/181 trigger xfs corruption on ppc64le
Message-ID: <20160921030841.GQ12847@dhcp12-143.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

There's a XFS (v4/v5) corruption from xfs/181. If run xfs/181 on ppc64le
10~100 times (more or less) with 1k or 4k block size, it'll trigger a
corruption:
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
attribute entry #0 in attr block 0, inode 25194 is INCOMPLETE
problem with attribute contents in inode 25194
would clear attr fork
bad nblocks 33 for inode 25194, would reset to 0
bad anextents 1 for inode 25194, would reset to 0
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
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
*** end xfs_repair output

The ppc64le machine has 64k page size. Above corruption only can be reproduced
on ppc64le machine until now. The full output (on v4 1k blksize XFS) as below:
http://paste.fedoraproject.org/431761/14744268/



Then I tried to test with 64k blocksize, I got another problem which easiler
to reproduce, ppc64 and aarch64 which have 64 pagesize all can trigger this
problem too:
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
agi unlinked bucket 0 is 1088 in ag 0 (inode=1088)
agi unlinked bucket 1 is 1089 in ag 0 (inode=1089)
agi unlinked bucket 2 is 1090 in ag 0 (inode=1090)
agi unlinked bucket 3 is 1091 in ag 0 (inode=1091)
...
...
agi unlinked bucket 60 is 1084 in ag 0 (inode=1084)
agi unlinked bucket 61 is 1085 in ag 0 (inode=1085)
agi unlinked bucket 62 is 1086 in ag 0 (inode=1086)
agi unlinked bucket 63 is 1087 in ag 0 (inode=1087)
sb_ifree 124, counted 6
sb_fdblocks 237036, counted 245112
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
Metadata corruption detected at xfs_attr3_leaf block 0x3f80/0x10000
wrong FS UUID, inode 1145 attr block 16256
problem with attribute contents in inode 1145
would clear attr fork
bad nblocks 1 for inode 1145, would reset to 0
bad anextents 1 for inode 1145, would reset to 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 3
        - agno = 1
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 1027, would move to lost+found
disconnected inode 1028, would move to lost+found
disconnected inode 1029, would move to lost+found
disconnected inode 1030, would move to lost+found
...
...
disconnected inode 1140, would move to lost+found
disconnected inode 1141, would move to lost+found
disconnected inode 1142, would move to lost+found
disconnected inode 1143, would move to lost+found
disconnected inode 1144, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 1027 nlinks from 0 to 1
would have reset inode 1028 nlinks from 0 to 1
would have reset inode 1029 nlinks from 0 to 1
would have reset inode 1030 nlinks from 0 to 1
...
...
would have reset inode 1141 nlinks from 0 to 1
would have reset inode 1142 nlinks from 0 to 1
would have reset inode 1143 nlinks from 0 to 1
would have reset inode 1144 nlinks from 0 to 1
No modify flag set, skipping filesystem flush and exiting.

Thanks,
Zorro
