Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35634 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbeLBI1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 03:27:52 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9C83C2AC29
        for <linux-xfs@vger.kernel.org>; Sun,  2 Dec 2018 08:27:48 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201823] inconsistent behaviour of xfs_db, xfs_repair and
 xfs_scrub
Date: Sun, 02 Dec 2018 08:27:48 +0000
Message-ID: <bug-201823-201763-g0zFYvo6Gi@https.bugzilla.kernel.org/>
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

--- Comment #4 from matthias@bodenbinder.de ---
The error occurs also with unmounted drive. Sorry for posting the output of the
"xfs_db -r" command this is misleading.

The first thing I did is checking it with a KNOPPIX 8.2 live CD. xfs_db is
showing the erros but xfs_repair does not repair anything.

Here the relevant outputs. /dev/sde1 is not mounted:

######

knoppix@Microknoppix:~$ uname -a
Linux Microknoppix 4.16.5-64 #1 SMP PREEMPT Sun Apr 29 17:09:15 CEST 2018
x86_64 GNU/Linux

######

knoppix@Microknoppix:~$ xfs_db /dev/sde1
xfs_db> frag
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
Metadata corruption detected at xfs_inode block 0x2341340/0x8000
aktuell 977134, ideal 970700, Unterteilungsfaktor 0,66%
Note, this number is largely meaningless.
Files on this filesystem average 1,01 extents per file
xfs_db> inode 0x2341340
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
Metadata corruption detected at xfs_inode block 0x1bab340/0x2000
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
xfs_db> q

######

knoppix@Microknoppix:~$ xfs_repair -V
xfs_repair Version 4.9.0

######

knoppix@Microknoppix:~$ xfs_repair /dev/sde1
Phase 1 - Superblock finden und überprüfen...
Phase 2 - ein internes Protokoll benutzen
        - Null-Protokoll...
        - freier Speicher und Inode-Karten des Dateisystems werden
gescannt...
        - Wurzel-Inode-Stück gefunden
Phase 3 - für jedes AG...
        - agi unverknüpfte Listen werden gescannt und bereinigt...
        - bekannte Inodes werden behandelt und Inode-Entdeckung wird
durchgeführt...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - neu entdeckte Inodes werden behandelt...
Phase 4 - auf doppelte Blöcke überprüfen...
        - Liste mit doppeltem Ausmaß wird eingerichtet...
        - es wird geprüft ob Inodes Blocks doppelt beanspruchen...
        - agno = 3
        - agno = 2
        - agno = 1
        - agno = 0
Phase 5 - AG-Köpfe und Bäume werden erneut gebildet...
        - Superblock wird zurückgesetzt...
Phase 6 - Inode-Verbindbarkeit wird geprüft...
        - Inhalte der Echtzeit-Bitmaps und Zusammenfassungs-Inodes werden
zurückgesetzt
        - Dateisystem wird durchquert ...
        - durchqueren beendet ...
        - nicht verbundene Inodes werden nach lost+found verschoben ...
Phase 7 - Verweisanzahl wird geprüft und berichtigt...
erledigt

######

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
