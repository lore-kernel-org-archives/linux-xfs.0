Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43386 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726127AbfACTyC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 14:54:02 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 46A4B26223
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jan 2019 19:54:01 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202127] New: cannot mount or create xfs on a  597T device
Date: Thu, 03 Jan 2019 19:54:01 +0000
Message-ID: <bug-202127-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202127

            Bug ID: 202127
           Summary: cannot mount or create xfs on a  597T device
           Product: File System
           Version: 2.5
    Kernel Version: 4.20.0-arch1-1-ARCH #1 SMP PREEMPT Mon Dec 24 03:00:40
                    UTC 2018 x86_64 GNU/Linux
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: daimh@umich.edu
        Regression: No

Created attachment 280259
  --> https://bugzilla.kernel.org/attachment.cgi?id=280259&action=edit
output of "mkfs -t xfs -f /dev/sda"

mkfs.xfs version 4.19.0

While mounting an XFS file system created under kernel 4.17.0, the error is
# mount /dev/sda /treehouse/watsons_lab/s1/
mount: /treehouse/watsons_lab/s1: mount(2) system call failed: Structure needs
cleaning.
#dmesg
[  397.225921] XFS (sda): SB stripe unit sanity check failed
[  397.226007] XFS (sda): Metadata corruption detected at
xfs_sb_read_verify+0x106/0x180 [xfs], xfs_sb block 0xffffffffffffffff 
[  397.226090] XFS (sda): Unmount and run xfs_repair
[  397.226126] XFS (sda): First 128 bytes of corrupted metadata buffer:
[  397.226173] 00000000: 58 46 53 42 00 00 10 00 00 00 00 22 c9 7a 00 00 
XFSB.......".z..
[  397.226228] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
................
[  397.226283] 00000020: c3 44 e5 14 dd 09 45 69 b0 7d 3f 9b 4b 0a fa d9 
.D....Ei.}?.K...
[  397.226337] 00000030: 00 00 00 11 60 00 00 08 00 00 00 00 00 00 08 00 
....`...........
[  397.226392] 00000040: 00 00 00 00 00 00 08 01 00 00 00 00 00 00 08 02 
................
[  397.226474] 00000050: 00 00 00 01 0f ff fe 00 00 00 02 2d 00 00 00 00 
...........-....
[  397.226530] 00000060: 00 07 f6 00 bd a5 10 00 02 00 00 08 00 00 00 00 
................
[  397.226585] 00000070: 00 00 00 00 00 00 00 00 0c 0c 09 03 1c 00 00 01 
................
[  397.226651] XFS (sda): SB validate failed with error -117.

#mkfs -t xfs -f /dev/sda &> mkfs.log  #the log file is attached.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
