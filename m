Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38544 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725728AbeLBG07 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 01:26:59 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F04242C081
        for <linux-xfs@vger.kernel.org>; Sat,  1 Dec 2018 19:13:47 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201823] inconsistent behaviour of xfs_db, xfs_repair and
 xfs_scrub
Date: Sat, 01 Dec 2018 19:13:48 +0000
Message-ID: <bug-201823-201763-4McAsgf3TH@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201823-201763@https.bugzilla.kernel.org/>
References: <bug-201823-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201823

--- Comment #1 from matthias@bodenbinder.de ---
I see that inode 0x234134 has a bad v3.crc:

xfs_db> inode 0x2341340
Metadata corruption detected at 0x56047ae6a3f3, xfs_inode block
0x1bab340/0x4000
Metadata CRC error detected for ino 36967232
xfs_db> p
core.magic = 0x3132
core.mode = 033062
core.version = 32
core.format = 56
core.nlinkv2 = 775108409
core.onlink = 14649
core.projid_lo = 12597
core.projid_hi = 8268
core.uid = 775371058
core.gid = 925645104
core.flushiter = 13361
core.atime.sec = Wed May 24 22:18:58 2000
core.atime.nsec = 775173426
core.mtime.sec = Thu Aug 17 12:56:03 1995
core.mtime.nsec = 540555575
core.ctime.sec = Fri Jul 29 00:54:45 1994
core.ctime.nsec = 875313459
core.size = 3328777196389539896
core.nblocks = 4123096260573147948
core.extsize = 959655481
core.nextents = 942880825
core.naextents = 8248
core.forkoff = 57
core.aformat = 57
core.dmevmask = 0x2e343530
core.dmstate = 13612
core.newrtbm = 0
core.prealloc = 1
core.realtime = 1
core.immutable = 0
core.append = 1
core.sync = 1
core.noatime = 0
core.nodump = 0
core.rtinherit = 1
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 1
core.extszinherit = 1
core.nodefrag = 1
core.filestream = 0
core.gen = 775371064
next_unlinked = 959717452
v3.crc = 0x20393031 (bad)
v3.change_count = 3330188947660289070
v3.lsn = 0x3130373037204320
v3.flags2 = 0x3930322e33333631
v3.cowextsize = 741946158
v3.crtime.sec = Wed Mar 26 15:01:29 1997
v3.crtime.nsec = 858665010
v3.inumber = 4123108269418885678
v3.uuid = 34333636-2c39-322e-3238-333338203930
v3.reflink = 0
v3.cowextsz = 0
u3 = (leer)
a = (leer)

I would like to know which file belongs to that inode before I try recalculate
it. But "blockget -n" is always running out of memory. 

Anyways, why isnt xfs_repair fixing this? Why isnt xfs_scrub showing this?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
