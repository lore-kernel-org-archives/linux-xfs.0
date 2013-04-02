Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0F81C7F84
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 13:44:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 924A3AC005
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 11:44:18 -0700 (PDT)
Received: from mail-ve0-f194.google.com (mail-ve0-f194.google.com
	[209.85.128.194]) by cuda.sgi.com with ESMTP id
	LsYvnBNiJ9pIBoZY (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 11:44:16 -0700 (PDT)
Received: by mail-ve0-f194.google.com with SMTP id ox1so229348veb.9
	for <xfs@oss.sgi.com>; Tue, 02 Apr 2013 11:44:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 2 Apr 2013 11:44:15 -0700
Message-ID: <CA+dre-c0K=AWRNRPgNVWANNkMW++FXEJvQzSe=68_JXyJMeNxQ@mail.gmail.com>
Subject: 88TB filesystem going off-line without warning
From: L Ox <lox8096@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0781890511248329542=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0781890511248329542==
Content-Type: multipart/alternative; boundary=20cf307f3642d4e3f304d9651f49

--20cf307f3642d4e3f304d9651f49
Content-Type: text/plain; charset=ISO-8859-1

Hi,

We have a new Linux/XFS deployment (about a month old) and randomly without
warning the XFS filesystem will go off-line. We are running Scientific
Linux release 5.9 with the latest updates.

# uname -a
Linux node24 2.6.18-348.3.1.el5 #1 SMP Mon Mar 11 15:43:13 EDT 2013 x86_64
x86_64 x86_64 GNU/Linux

# cat /etc/redhat-release
Scientific Linux release 5.9 (Boron)

Here are the errors we see in /var/log/messages after the initial off-line
event:

-- snip --

Apr  2 07:50:28 node24 kernel: xfs_iunlink_remove: xfs_inotobp()  returned
an error 22 on dm-6.  Returning error.
Apr  2 07:50:28 node24 kernel: xfs_inactive:  xfs_ifree() returned an error
= 22 on dm-6
Apr  2 07:50:28 node24 kernel: xfs_force_shutdown(dm-6,0x1) called from
line 1419 of file fs/xfs/xfs_vnodeops.c.  Return address =
0xffffffff8855b86b
Apr  2 07:50:28 node24 kernel: Filesystem dm-6: I/O Error Detected.
Shutting down filesystem: dm-6
Apr  2 07:50:28 node24 kernel: Please umount the filesystem, and rectify
the problem(s)
Apr  2 07:50:52 node24 kernel: Filesystem dm-6: xfs_log_force: error 5
returned.
Apr  2 07:51:52 node24 last message repeated 2 times

-- snip --

Here are the messages after I umount/xfs_repair/mount the filesystem:

-- snip --

Apr  2 10:23:04 node24 kernel: xfs_force_shutdown(dm-6,0x1) called from
line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xffffffff8855c0fe
Apr  2 10:23:07 node24 kernel: Filesystem dm-6: xfs_log_force: error 5
returned.
Apr  2 10:23:07 node24 last message repeated 4 times
Apr  2 10:24:08 node24 kernel: Filesystem dm-6: Disabling barriers, trial
barrier write failed
Apr  2 10:24:08 node24 kernel: XFS mounting filesystem dm-6
Apr  2 10:24:08 node24 kernel: Starting XFS recovery on filesystem: dm-6
(logdev: internal)
Apr  2 10:24:10 node24 kernel: Ending XFS recovery on filesystem: dm-6
(logdev: internal)
Apr  2 10:24:17 node24 multipathd: dm-6: umount map (uevent)
Apr  2 10:58:54 node24 kernel: Filesystem dm-6: Disabling barriers, trial
barrier write failed
Apr  2 10:58:54 node24 kernel: XFS mounting filesystem dm-6

-- snip --

We are taking 6 devices from a SAN and using LVM to effectively create a
RAID0 block devices which XFS is sitting on. We do not see any multipathd
errors.

I created the filesystem using this command.

# mkfs.xfs -f -d su=256k,sw=6,sectsize=4096,unwritten=0 -i attr=2 -l
sectsize=4096,lazy-count=1 -r extsize=4096 /dev/mapper/vol_d24-root

Here are the mount options:

# cat /etc/fstab | grep xfs
/dev/mapper/vol_d24-root            /archive/d24       xfs
defaults,inode64        0 9

# mount | grep xfs
/dev/mapper/vol_d24-root on /archive/d24 type xfs (rw,inode64)

Here is the output of xfs_info:

# xfs_info /dev/mapper/vol_d24-root
meta-data=/dev/mapper/vol_d24-root isize=256    agcount=88,
agsize=268435392 blks
         =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=23441774592, imaxpct=25
         =                       sunit=64     swidth=384 blks, unwritten=0
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

After the initial off-line event I:
- umount
- ran xfs_repair (it told me to mount/umount and then re-run xfs_repair)
- mount
- umount
- xfs_repair

Here is the output of xfs_repair:

-- snip --

# xfs_repair /dev/mapper/vol_d24-root
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
2acde2416940: Badness in key lookup (length)
bp=(bno 14657493984, len 16384 bytes) key=(bno 14657493984, len 8192 bytes)
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
2acde2416940: Badness in key lookup (length)
bp=(bno 26065183200, len 16384 bytes) key=(bno 26065183200, len 8192 bytes)
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
2acde2e17940: Badness in key lookup (length)
bp=(bno 43039175488, len 16384 bytes) key=(bno 43039175488, len 8192 bytes)
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
2acde0613940: Badness in key lookup (length)
bp=(bno 101051527232, len 16384 bytes) key=(bno 101051527232, len 8192
bytes)
2acde0613940: Badness in key lookup (length)
bp=(bno 101081120768, len 16384 bytes) key=(bno 101081120768, len 8192
bytes)
2acde0613940: Badness in key lookup (length)
bp=(bno 102336613216, len 16384 bytes) key=(bno 102336613216, len 8192
bytes)
        - agno = 48
        - agno = 49
2acde2416940: Badness in key lookup (length)
bp=(bno 107185599392, len 16384 bytes) key=(bno 107185599392, len 8192
bytes)
2acde1014940: Badness in key lookup (length)
bp=(bno 107606543312, len 16384 bytes) key=(bno 107606543312, len 8192
bytes)
2acde1014940: Badness in key lookup (length)
bp=(bno 107674994560, len 16384 bytes) key=(bno 107674994560, len 8192
bytes)
2acde1014940: Badness in key lookup (length)
bp=(bno 107675078656, len 16384 bytes) key=(bno 107675078656, len 8192
bytes)
2acde1014940: Badness in key lookup (length)
bp=(bno 107675078688, len 16384 bytes) key=(bno 107675078688, len 8192
bytes)
2acde1014940: Badness in key lookup (length)
bp=(bno 107675078720, len 16384 bytes) key=(bno 107675078720, len 8192
bytes)
2acde1014940: Badness in key lookup (length)
bp=(bno 107675175008, len 16384 bytes) key=(bno 107675175008, len 8192
bytes)
2acde1014940: Badness in key lookup (length)
bp=(bno 107704942624, len 16384 bytes) key=(bno 107704942624, len 8192
bytes)
2acde1014940: Badness in key lookup (length)
bp=(bno 107763211904, len 16384 bytes) key=(bno 107763211904, len 8192
bytes)
        - agno = 50
2acde1014940: Badness in key lookup (length)
bp=(bno 109436122656, len 16384 bytes) key=(bno 109436122656, len 8192
bytes)
2acde2e17940: Badness in key lookup (length)
bp=(bno 110466056352, len 16384 bytes) key=(bno 110466056352, len 8192
bytes)
2acde2e17940: Badness in key lookup (length)
bp=(bno 110603835392, len 16384 bytes) key=(bno 110603835392, len 8192
bytes)
        - agno = 51
        - agno = 52
        - agno = 53
        - agno = 54
        - agno = 55
        - agno = 56
        - agno = 57
        - agno = 58
        - agno = 59
        - agno = 60
        - agno = 61
2acde2416940: Badness in key lookup (length)
bp=(bno 132435472416, len 16384 bytes) key=(bno 132435472416, len 8192
bytes)
        - agno = 62
2acde2416940: Badness in key lookup (length)
bp=(bno 135330780000, len 16384 bytes) key=(bno 135330780000, len 8192
bytes)
2acde2416940: Badness in key lookup (length)
bp=(bno 135508074496, len 16384 bytes) key=(bno 135508074496, len 8192
bytes)
2acde2416940: Badness in key lookup (length)
bp=(bno 135675982432, len 16384 bytes) key=(bno 135675982432, len 8192
bytes)
        - agno = 63
        - agno = 64
        - agno = 65
        - agno = 66
        - agno = 67
        - agno = 68
        - agno = 69
        - agno = 70
        - agno = 71
        - agno = 72
        - agno = 73
        - agno = 74
        - agno = 75
        - agno = 76
        - agno = 77
        - agno = 78
        - agno = 79
        - agno = 80
        - agno = 81
        - agno = 82
        - agno = 83
        - agno = 84
        - agno = 85
        - agno = 86
        - agno = 87
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 2
        - agno = 3
        - agno = 8
        - agno = 9
        - agno = 4
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 19
        - agno = 20
        - agno = 18
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - agno = 32
        - agno = 33
        - agno = 34
        - agno = 35
        - agno = 36
        - agno = 37
        - agno = 38
        - agno = 39
        - agno = 40
        - agno = 41
        - agno = 42
        - agno = 43
        - agno = 44
        - agno = 45
        - agno = 46
        - agno = 47
        - agno = 48
        - agno = 49
        - agno = 50
        - agno = 51
        - agno = 52
        - agno = 53
        - agno = 54
        - agno = 55
        - agno = 56
        - agno = 57
        - agno = 58
        - agno = 59
        - agno = 60
        - agno = 61
        - agno = 62
        - agno = 63
        - agno = 64
        - agno = 65
        - agno = 66
        - agno = 67
        - agno = 68
        - agno = 69
        - agno = 70
        - agno = 71
        - agno = 72
        - agno = 73
        - agno = 74
        - agno = 75
        - agno = 76
        - agno = 77
        - agno = 78
        - agno = 79
        - agno = 80
        - agno = 81
        - agno = 82
        - agno = 83
        - agno = 84
        - agno = 85
        - agno = 86
        - agno = 87
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 202102936036, moving to lost+found
disconnected inode 215350040250, moving to lost+found
disconnected inode 215350208634, moving to lost+found
disconnected inode 271016406074, moving to lost+found
Phase 7 - verify and correct link counts...
done

-- snip --

Any ideas?

Thanks

--20cf307f3642d4e3f304d9651f49
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>We have a new Linux/XFS deployment (about a mon=
th old) and randomly without warning the XFS filesystem will go off-line. W=
e are running Scientific Linux release 5.9 with the latest updates.<br><br>
# uname -a<br>Linux node24 2.6.18-348.3.1.el5 #1 SMP Mon Mar 11 15:43:13 ED=
T 2013 x86_64 x86_64 x86_64 GNU/Linux<br><br># cat /etc/redhat-release<br>S=
cientific Linux release 5.9 (Boron)<br><br>Here are the errors we see in /v=
ar/log/messages after the initial off-line event:<br>
<br>-- snip --<br><br>Apr=A0 2 07:50:28 node24 kernel: xfs_iunlink_remove: =
xfs_inotobp()=A0 returned an error 22 on dm-6.=A0 Returning error.<br>Apr=
=A0 2 07:50:28 node24 kernel: xfs_inactive:=A0 xfs_ifree() returned an erro=
r =3D 22 on dm-6<br>
Apr=A0 2 07:50:28 node24 kernel: xfs_force_shutdown(dm-6,0x1) called from l=
ine 1419 of file fs/xfs/xfs_vnodeops.c.=A0 Return address =3D 0xffffffff885=
5b86b<br>Apr=A0 2 07:50:28 node24 kernel: Filesystem dm-6: I/O Error Detect=
ed.=A0 Shutting down filesystem: dm-6<br>
Apr=A0 2 07:50:28 node24 kernel: Please umount the filesystem, and rectify =
the problem(s)<br>Apr=A0 2 07:50:52 node24 kernel: Filesystem dm-6: xfs_log=
_force: error 5 returned.<br>Apr=A0 2 07:51:52 node24 last message repeated=
 2 times<br>
<br>-- snip --<br><br>Here are the messages after I umount/xfs_repair/mount=
 the filesystem:<br><br>-- snip --<br><br>Apr=A0 2 10:23:04 node24 kernel: =
xfs_force_shutdown(dm-6,0x1) called from line 420 of file fs/xfs/xfs_rw.c.=
=A0 Return address =3D 0xffffffff8855c0fe<br>
Apr=A0 2 10:23:07 node24 kernel: Filesystem dm-6: xfs_log_force: error 5 re=
turned.<br>Apr=A0 2 10:23:07 node24 last message repeated 4 times<br>Apr=A0=
 2 10:24:08 node24 kernel: Filesystem dm-6: Disabling barriers, trial barri=
er write failed<br>
Apr=A0 2 10:24:08 node24 kernel: XFS mounting filesystem dm-6<br>Apr=A0 2 1=
0:24:08 node24 kernel: Starting XFS recovery on filesystem: dm-6 (logdev: i=
nternal)<br>Apr=A0 2 10:24:10 node24 kernel: Ending XFS recovery on filesys=
tem: dm-6 (logdev: internal)<br>
Apr=A0 2 10:24:17 node24 multipathd: dm-6: umount map (uevent)<br>Apr=A0 2 =
10:58:54 node24 kernel: Filesystem dm-6: Disabling barriers, trial barrier =
write failed<br>Apr=A0 2 10:58:54 node24 kernel: XFS mounting filesystem dm=
-6<br>
<br>-- snip --<br><br>We are taking 6 devices from a SAN and using LVM to e=
ffectively create a RAID0 block devices which XFS is sitting on. We do not =
see any multipathd errors.<br><br>I created the filesystem using this comma=
nd.<br>
<br># mkfs.xfs -f -d su=3D256k,sw=3D6,sectsize=3D4096,unwritten=3D0 -i attr=
=3D2 -l sectsize=3D4096,lazy-count=3D1 -r extsize=3D4096 /dev/mapper/vol_d2=
4-root<br><br>Here are the mount options:<br><br># cat /etc/fstab | grep xf=
s<br>/dev/mapper/vol_d24-root=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /archive/d24=
=A0=A0=A0=A0=A0=A0 xfs defaults,inode64=A0=A0=A0=A0=A0=A0=A0 0 9<br>
<br># mount | grep xfs<br>/dev/mapper/vol_d24-root on /archive/d24 type xfs=
 (rw,inode64)<br><br>Here is the output of xfs_info:<br><br># xfs_info /dev=
/mapper/vol_d24-root<br>meta-data=3D/dev/mapper/vol_d24-root isize=3D256=A0=
=A0=A0 agcount=3D88, agsize=3D268435392 blks<br>
=A0=A0=A0=A0=A0=A0=A0=A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 sectsz=3D4096=A0 attr=3D2<br>data=A0=A0=A0=A0 =3D=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bsize=3D409=
6=A0=A0 blocks=3D23441774592, imaxpct=3D25<br>=A0=A0=A0=A0=A0=A0=A0=A0 =3D=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sunit=3D=
64=A0=A0=A0=A0 swidth=3D384 blks, unwritten=3D0<br>naming=A0=A0 =3Dversion =
2=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bsize=3D4096 <br>
log=A0=A0=A0=A0=A0 =3Dinternal=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bs=
ize=3D4096=A0=A0 blocks=3D32768, version=3D2<br>=A0=A0=A0=A0=A0=A0=A0=A0 =
=3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sects=
z=3D4096=A0 sunit=3D1 blks, lazy-count=3D1<br>realtime =3Dnone=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 extsz=3D4096=A0=A0 blocks=3D0, r=
textents=3D0<br><br>
After the initial off-line event I:<br>- umount<br>- ran xfs_repair (it tol=
d me to mount/umount and then re-run xfs_repair)<br>- mount<br>- umount<br>=
- xfs_repair<br><br>Here is the output of xfs_repair:<br><br>-- snip --<br>
<br># xfs_repair /dev/mapper/vol_d24-root<br>Phase 1 - find and verify supe=
rblock...<br>Phase 2 - using internal log<br>=A0=A0=A0=A0=A0=A0=A0 - zero l=
og...<br>=A0=A0=A0=A0=A0=A0=A0 - scan filesystem freespace and inode maps..=
.<br>=A0=A0=A0=A0=A0=A0=A0 - found root inode chunk<br>
Phase 3 - for each AG...<br>=A0=A0=A0=A0=A0=A0=A0 - scan and clear agi unli=
nked lists...<br>=A0=A0=A0=A0=A0=A0=A0 - process known inodes and perform i=
node discovery...<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 0<br>=A0=A0=A0=A0=A0=
=A0=A0 - agno =3D 1<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 2<br>=A0=A0=A0=A0=
=A0=A0=A0 - agno =3D 3<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 4<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 5<br=
>2acde2416940: Badness in key lookup (length)<br>bp=3D(bno 14657493984, len=
 16384 bytes) key=3D(bno 14657493984, len 8192 bytes)<br>=A0=A0=A0=A0=A0=A0=
=A0 - agno =3D 6<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 7<br>=A0=A0=A0=A0=A0=
=A0=A0 - agno =3D 8<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 9<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 10<b=
r>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 11<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 1=
2<br>2acde2416940: Badness in key lookup (length)<br>bp=3D(bno 26065183200,=
 len 16384 bytes) key=3D(bno 26065183200, len 8192 bytes)<br>=A0=A0=A0=A0=
=A0=A0=A0 - agno =3D 13<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 14<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 15<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 16<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
17<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 18<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 19<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 20<br>2acde2e17940: Badness in k=
ey lookup (length)<br>bp=3D(bno 43039175488, len 16384 bytes) key=3D(bno 43=
039175488, len 8192 bytes)<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 21<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 22<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 23<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
24<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 25<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 26<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 27<br>=A0=A0=A0=A0=A0=A0=A0 - ag=
no =3D 28<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 29<br>=A0=A0=A0=A0=A0=A0=A0 -=
 agno =3D 30<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 31<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 32<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 33<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
34<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 35<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 36<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 37<br>=A0=A0=A0=A0=A0=A0=A0 - ag=
no =3D 38<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 39<br>=A0=A0=A0=A0=A0=A0=A0 -=
 agno =3D 40<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 41<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 42<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 43<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
44<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 45<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 46<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 47<br>2acde0613940: Badness in k=
ey lookup (length)<br>bp=3D(bno 101051527232, len 16384 bytes) key=3D(bno 1=
01051527232, len 8192 bytes)<br>
2acde0613940: Badness in key lookup (length)<br>bp=3D(bno 101081120768, len=
 16384 bytes) key=3D(bno 101081120768, len 8192 bytes)<br>2acde0613940: Bad=
ness in key lookup (length)<br>bp=3D(bno 102336613216, len 16384 bytes) key=
=3D(bno 102336613216, len 8192 bytes)<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 48<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 49<=
br>2acde2416940: Badness in key lookup (length)<br>bp=3D(bno 107185599392, =
len 16384 bytes) key=3D(bno 107185599392, len 8192 bytes)<br>2acde1014940: =
Badness in key lookup (length)<br>
bp=3D(bno 107606543312, len 16384 bytes) key=3D(bno 107606543312, len 8192 =
bytes)<br>2acde1014940: Badness in key lookup (length)<br>bp=3D(bno 1076749=
94560, len 16384 bytes) key=3D(bno 107674994560, len 8192 bytes)<br>2acde10=
14940: Badness in key lookup (length)<br>
bp=3D(bno 107675078656, len 16384 bytes) key=3D(bno 107675078656, len 8192 =
bytes)<br>2acde1014940: Badness in key lookup (length)<br>bp=3D(bno 1076750=
78688, len 16384 bytes) key=3D(bno 107675078688, len 8192 bytes)<br>2acde10=
14940: Badness in key lookup (length)<br>
bp=3D(bno 107675078720, len 16384 bytes) key=3D(bno 107675078720, len 8192 =
bytes)<br>2acde1014940: Badness in key lookup (length)<br>bp=3D(bno 1076751=
75008, len 16384 bytes) key=3D(bno 107675175008, len 8192 bytes)<br>2acde10=
14940: Badness in key lookup (length)<br>
bp=3D(bno 107704942624, len 16384 bytes) key=3D(bno 107704942624, len 8192 =
bytes)<br>2acde1014940: Badness in key lookup (length)<br>bp=3D(bno 1077632=
11904, len 16384 bytes) key=3D(bno 107763211904, len 8192 bytes)<br>=A0=A0=
=A0=A0=A0=A0=A0 - agno =3D 50<br>
2acde1014940: Badness in key lookup (length)<br>bp=3D(bno 109436122656, len=
 16384 bytes) key=3D(bno 109436122656, len 8192 bytes)<br>2acde2e17940: Bad=
ness in key lookup (length)<br>bp=3D(bno 110466056352, len 16384 bytes) key=
=3D(bno 110466056352, len 8192 bytes)<br>
2acde2e17940: Badness in key lookup (length)<br>bp=3D(bno 110603835392, len=
 16384 bytes) key=3D(bno 110603835392, len 8192 bytes)<br>=A0=A0=A0=A0=A0=
=A0=A0 - agno =3D 51<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 52<br>=A0=A0=A0=A0=
=A0=A0=A0 - agno =3D 53<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 54<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 55<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 56<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 57<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
58<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 59<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 60<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 61<br>2acde2416940: Badness in k=
ey lookup (length)<br>bp=3D(bno 132435472416, len 16384 bytes) key=3D(bno 1=
32435472416, len 8192 bytes)<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 62<br>2acde2416940: Badness in key lookup =
(length)<br>bp=3D(bno 135330780000, len 16384 bytes) key=3D(bno 13533078000=
0, len 8192 bytes)<br>2acde2416940: Badness in key lookup (length)<br>bp=3D=
(bno 135508074496, len 16384 bytes) key=3D(bno 135508074496, len 8192 bytes=
)<br>
2acde2416940: Badness in key lookup (length)<br>bp=3D(bno 135675982432, len=
 16384 bytes) key=3D(bno 135675982432, len 8192 bytes)<br>=A0=A0=A0=A0=A0=
=A0=A0 - agno =3D 63<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 64<br>=A0=A0=A0=A0=
=A0=A0=A0 - agno =3D 65<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 66<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 67<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 68<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 69<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
70<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 71<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 72<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 73<br>=A0=A0=A0=A0=A0=A0=A0 - ag=
no =3D 74<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 75<br>=A0=A0=A0=A0=A0=A0=A0 -=
 agno =3D 76<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 77<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 78<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 79<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
80<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 81<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 82<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 83<br>=A0=A0=A0=A0=A0=A0=A0 - ag=
no =3D 84<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 85<br>=A0=A0=A0=A0=A0=A0=A0 -=
 agno =3D 86<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 87<br>=A0=A0=A0=A0=A0=A0=A0 - process newl=
y discovered inodes...<br>Phase 4 - check for duplicate blocks...<br>=A0=A0=
=A0=A0=A0=A0=A0 - setting up duplicate extent list...<br>=A0=A0=A0=A0=A0=A0=
=A0 - check for inodes claiming duplicate blocks...<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 0<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 1<br=
>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 5<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 6<b=
r>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 7<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 2<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 3<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 8=
<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 9<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
4<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 10<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 11<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 12<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 13<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
14<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 15<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 16<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 17<br>=A0=A0=A0=A0=A0=A0=A0 - ag=
no =3D 19<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 20<br>=A0=A0=A0=A0=A0=A0=A0 -=
 agno =3D 18<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 21<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 22<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 23<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
24<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 25<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 26<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 27<br>=A0=A0=A0=A0=A0=A0=A0 - ag=
no =3D 28<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 29<br>=A0=A0=A0=A0=A0=A0=A0 -=
 agno =3D 30<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 31<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 32<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 33<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
34<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 35<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 36<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 37<br>=A0=A0=A0=A0=A0=A0=A0 - ag=
no =3D 38<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 39<br>=A0=A0=A0=A0=A0=A0=A0 -=
 agno =3D 40<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 41<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 42<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 43<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
44<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 45<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 46<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 47<br>=A0=A0=A0=A0=A0=A0=A0 - ag=
no =3D 48<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 49<br>=A0=A0=A0=A0=A0=A0=A0 -=
 agno =3D 50<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 51<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 52<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 53<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
54<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 55<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 56<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 57<br>=A0=A0=A0=A0=A0=A0=A0 - ag=
no =3D 58<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 59<br>=A0=A0=A0=A0=A0=A0=A0 -=
 agno =3D 60<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 61<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 62<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 63<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
64<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 65<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 66<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 67<br>=A0=A0=A0=A0=A0=A0=A0 - ag=
no =3D 68<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 69<br>=A0=A0=A0=A0=A0=A0=A0 -=
 agno =3D 70<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 71<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 72<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 73<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
74<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 75<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 76<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 77<br>=A0=A0=A0=A0=A0=A0=A0 - ag=
no =3D 78<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 79<br>=A0=A0=A0=A0=A0=A0=A0 -=
 agno =3D 80<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 81<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 82<=
br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 83<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D =
84<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 85<br>=A0=A0=A0=A0=A0=A0=A0 - agno =
=3D 86<br>=A0=A0=A0=A0=A0=A0=A0 - agno =3D 87<br>Phase 5 - rebuild AG heade=
rs and trees...<br>=A0=A0=A0=A0=A0=A0=A0 - reset superblock...<br>
Phase 6 - check inode connectivity...<br>=A0=A0=A0=A0=A0=A0=A0 - resetting =
contents of realtime bitmap and summary inodes<br>=A0=A0=A0=A0=A0=A0=A0 - t=
raversing filesystem ...<br>=A0=A0=A0=A0=A0=A0=A0 - traversal finished ...<=
br>=A0=A0=A0=A0=A0=A0=A0 - moving disconnected inodes to lost+found ...<br>
disconnected inode 202102936036, moving to lost+found<br>disconnected inode=
 215350040250, moving to lost+found<br>disconnected inode 215350208634, mov=
ing to lost+found<br>disconnected inode 271016406074, moving to lost+found<=
br>
Phase 7 - verify and correct link counts...<br>done<br><br>-- snip --<br><b=
r>Any ideas?<br><br>Thanks</div>

--20cf307f3642d4e3f304d9651f49--


--===============0781890511248329542==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0781890511248329542==--
