Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from queue01a.mail.zen.net.uk ([212.23.3.234]:53156 "EHLO
        queue01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727726AbeJFUdy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 16:33:54 -0400
Received: from [212.23.1.20] (helo=smarthost03a.mail.zen.net.uk)
        by queue01a.mail.zen.net.uk with esmtp (Exim 4.72)
        (envelope-from <dave@howorth.org.uk>)
        id 1g8mEp-0008Os-Co
        for linux-xfs@vger.kernel.org; Sat, 06 Oct 2018 13:03:19 +0000
Received: from [88.97.62.77] (helo=acer-suse.lan)
        by smarthost03a.mail.zen.net.uk with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <dave@howorth.org.uk>)
        id 1g8mEn-0005YB-Uu
        for linux-xfs@vger.kernel.org; Sat, 06 Oct 2018 13:03:18 +0000
Date: Sat, 6 Oct 2018 14:03:17 +0100
From: Dave Howorth <dave@howorth.org.uk>
Subject: XFS mount problem
Message-ID: <20181006140317.148fe46d@acer-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We had a very brief power-glitch last night, but it was enough to cause
my PC to reboot. But the reboot didn't come up cleanly.

It was complaining about not being able to mount an XFS filesystem
that I use for storing recorded TV programmes. In fact mount claims
'wrong fs type':

# mount -v /srv/live-tv/
mount: /srv/live-tv: wrong fs type, bad option, bad superblock
on /dev/mapper/mint_vg-live--tv_lv, missing codepage or helper program,
or other error.

The mount is being tried against fstab:

# grep live-tv /etc/fstab
#LABEL=LiveTV         /srv/live-tv         xfs        noatime,noacl 0 2
/dev/mint_vg/live-tv_lv   /srv/live-tv    xfs        noatime,noacl 0 2

I normally mount this filesystem by label but I commented that out to
get the system to boot and I added the /dev line as a more basic method
to see if it helped, but it gives the same error.

# l /dev/mint_vg/live-tv_lv
lrwxrwxrwx 1 root root 7 Oct  6 09:45 /dev/mint_vg/live-tv_lv -> ../dm-3

The XFS filesystem is in an LV. lv/pv/vgscan all report everything
normal; I don't think there's a problem at the LVM level.

I tried xfs_repair -n:

# xfs_repair -n /dev/dm-3
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ALERT: The filesystem has valuable metadata changes in a log which is
being ignored because the -n option was used.  Expect spurious
inconsistencies which may be resolved by first mounting the filesystem
to replay the log.
        - scan filesystem freespace and inode maps...
sb_ifree 81, counted 80
sb_fdblocks 12504226, counted 12276402
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
imap claims a free inode 135 is in use, would correct imap and clear
inode
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
entry "Coronation Street Omnibus.ts" at block 0 offset 3848 in
directory inode 96 references free inode 135 would clear inode number
in entry at offset 3848...
        - agno = 3
        - agno = 2
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "Coronation Street Omnibus.ts" in directory inode 96 points to
free inode 135, would junk entry bad hash table for directory inode 96
(no data entry): would rebuild
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.


This is openSUSE Leap 15.0

I'm a bit stuck now; my XFS foo is not strong today, it seems. Can
anybody suggest what my next steps should be? I'll keep googling but I
hope somebody may have more informed ideas :)
