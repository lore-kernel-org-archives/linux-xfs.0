Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:46480 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751655AbdDFAoW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 20:44:22 -0400
Received: from localhost (localhost [IPv6:::1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by trent.utfs.org (Postfix) with ESMTPS id 18480605C8
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2017 02:36:13 +0200 (CEST)
Date: Wed, 5 Apr 2017 17:36:13 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Metadata corruption detected at xfs_inode_buf_verify
Message-ID: <alpine.DEB.2.21.1.1704051729340.1086@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi,

I have a raspberrypi and try to use that as a small file server. After
trying to delete a ~1TB direcory, it locked up and was then power cycled. 
Now I cannot mount the XFS partition any more:

===============================================
$ mount -t xfs /dev/mapper/owc1 /mnt/disk
mount: mount /dev/mapper/owc1 on /mnt/disk failed: Structure needs cleaning

   [producing lots of messages in dmesg, see below]


$ xfs_repair -v /dev/mapper/owc1
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
        - block cache size set to 26024 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 3455547 tail block 3450129
ERROR: The filesystem has valuable metadata changes in a log which needs 
[...]
===============================================

Mounting with -o ro,norecovery works, and the directory I wanted to remove 
is still there, in parts - only about 200 GB have been deleted.

Full script log and .config: http://nerdbynature.de/bits/4.11.0-rc5/xfs/

Any ideas on how to solve this?

Thanks,
Christian.
-- 
BOFH excuse #431:

Borg implants are failing
