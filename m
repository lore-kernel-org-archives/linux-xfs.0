Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150216.yqkeh6a5fgvw573h@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mail-ot0-f177.google.com ([74.125.82.177]:34212 "EHLO
        mail-ot0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751265AbdBWUOs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Feb 2017 15:14:48 -0500
Received: by mail-ot0-f177.google.com with SMTP id x10so1474887otb.1
        for <linux-xfs@vger.kernel.org>; Thu, 23 Feb 2017 12:14:48 -0800 (PST)
MIME-Version: 1.0
From: Mathias Troiden <mathias.troiden@gmail.com>
Date: Thu, 23 Feb 2017 23:14:47 +0300
Message-ID: <CADcJnz_TWkhhPVr7fmVHoZtjOkGDJxTqtcuz_Ef15rguUW3bdA@mail.gmail.com>
Subject: xfs_repair fails to recognize corruption reported by kernel -
 possible bug?
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Original topic: https://bbs.archlinux.org/viewtopic.php?pid=1692896

Hi list,

My system fails to start login manager with following messages in journal:

>kernel: ffff88040e8bc030: 58 67 db ca 2a 3a dd b8 00 00 00 00 00 00 00 00  Xg..*:..........
>kernel: XFS (sda1): Internal error xfs_iread at line 514 of file fs/xfs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x2b1/0x940 [xfs]
>kernel: XFS (sda1): Corruption detected. Unmount and run xfs_repair
>kernel: XFS (sda1): xfs_iread: validation failed for inode 34110192 failed
>kernel: ffff88040e8bc000: 49 4e a1 ff 03 01 00 00 00 00 00 00 00 00 00 00  IN..............
>kernel: ffff88040e8bc010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
>kernel: ffff88040e8bc020: 58 aa 04 b8 2e e3 65 3a 57 41 fe 12 00 00 00 00  X.....e:WA......
>kernel: ffff88040e8bc030: 58 67 db ca 2a 3a dd b8 00 00 00 00 00 00 00 00  Xg..*:..........
>kernel: XFS (sda1): Internal error xfs_iread at line 514 of file fs/xfs/libxfs/xfs_inode_buf.c.  Caller xfs_iget+0x2b1/0x940 [xfs]
>kernel: XFS (sda1): Corruption detected. Unmount and run xfs_repair


and subsequent core dump of the login manager.


However, neither 'xfs_repair -d' run from running system nor
'xfs_repair -n' run from liveUSB recognized a problem i.e. returned
output expected of clean FS.

Memtester, 'find /mnt/ -type f -exec dd if={} of=/dev/null status=none
\;', SMART test outputs are also clean.

The issue I've encountered after logging into tty2 was that I couldn't
start X - perhaps that's where the corruption occured:
>sudo startx
>zsh: command startx not found

sda1 is my root partition.

Mathias
