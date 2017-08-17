Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56393 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751616AbdHQMN1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 08:13:27 -0400
From: Hannes Reinecke <hare@suse.de>
Subject: xfs_repair fails to clean directory inode
Message-ID: <9c1f39a3-c4cf-e98d-4331-475b037268b7@suse.de>
Date: Thu, 17 Aug 2017 14:13:24 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

Hi all,

I've managed to corrupt my fs after a storage array failure earlier this
week. After calling 'xfs_repair -L' on the FS running xfs_repair
consistently gives me:

# xfs_repair /dev/dm-2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bogus .. inode number (0) in directory inode 128, clearing inode number
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 1
        - agno = 3
bogus .. inode number (0) in directory inode 128, clearing inode number
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

irrespective on how many times I'm calling xfs_repair.
(And yes, this is with latest xfsprogs)

FWIW, running xfs_repair with ASSERT enables gives me:
# ./repair/xfs_repair /dev/dm-2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
bogus .. inode number (0) in directory inode 128, clearing inode number
xfs_repair: dir2.c:1419: process_dir2: Assertion `(ino !=
mp->m_sb.sb_rootino && ino != *parent) || (ino == mp->m_sb.sb_rootino &&
(ino == *parent || need_root_dotdot == 1))' failed.
Aborted (core dumped)

Needless to say, the kernel refuses to mount that fs.

The really annoying thing is that this FS hosted my various development
git trees, and I really would hate to see the data gone.

Thanks for any hints.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
