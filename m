Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC65829DFB
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 09:45:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A87BB304032
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 07:45:10 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id UH3g0Qwt193DKpjt (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Apr 2015 07:45:07 -0700 (PDT)
Subject: Bug#782012: xfs_admin: Changing UUID destroys Filesystem
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.782012.B.142833136717913@bugs.debian.org>
Message-ID: <552299A0.1070508@sandeen.net>
Date: Mon, 06 Apr 2015 09:35:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
References: <20150406132342.2635.15072.reportbug@phoenix.lab.swapon.de>
In-Reply-To: <20150406132342.2635.15072.reportbug@phoenix.lab.swapon.de>
Reply-To: Eric Sandeen <sandeen@sandeen.net>, 782012@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "F. Stoyan" <fstoyan@swapon.de>, 782012@bugs.debian.org, Debian Bug Tracking System <submit@bugs.debian.org>

v5 filesystems stamp the filesystem UUID into many pieces of metadata;
changing it only in the superblock via xfs_admin makes every other bit
of metadata look wrong.

We need to disable the ability to change UUID in xfs_admin, I'll send
a patch.

Thanks for the report,
-Eric

On 4/6/15 8:23 AM, F. Stoyan wrote:
> Package: xfsprogs
> Version: 3.2.1
> Severity: normal
> 
> Dear Maintainer,
> 
> after changing the UUID of an existing not mounted XFS-V5 Filesystem it can't be
> mounted anymore. xfs_repair fix this, but the remaining filsystem is empty.
> Here is what happend in detail:
> 
> root@vger:~# xfs_admin -u /dev/mapper/rvg-sav 
> UUID = a2320a38-0c83-478e-bc31-4bc3fb253fdd
> 
> root@vger:~# xfs_admin -U a2320a38-0c83-478e-bc31-4bc3fb253fde /dev/mapper/rvg-sav
> Clearing log and setting UUID
> writing all SBs
> new UUID = a2320a38-0c83-478e-bc31-4bc3fb253fde
> 
> root@vger:~# mount /dev/mapper/rvg-sav /tmp/sav
> mount: mount /dev/mapper/rvg-sav on /tmp/sav failed: Structure needs cleaning
> 
> [  696.826336] XFS (dm-5): Mounting V5 Filesystem
> [  696.866945] XFS (dm-5): xfs_iread: validation failed for inode 96 failed
> [  696.867000] ffff8800b9981000: 49 4e 41 ed 03 01 00 00 00 00 00 00 00 00 00 00  INA.............
> [  696.867053] ffff8800b9981010: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [  696.867105] ffff8800b9981020: 55 22 7a 21 2c 67 43 83 55 22 79 cf 08 76 b6 6a  U"z!,gC.U"y..v.j
> [  696.867157] ffff8800b9981030: 55 22 79 cf 08 76 b6 6a 00 00 00 00 00 00 00 35  U"y..v.j.......5
> [  696.867242] XFS (dm-5): Internal error xfs_iread at line 392 of file /build/linux-SAvLSw/linux-3.16.7-ckt7/fs/xfs/xfs_inode_buf.c.  Caller xfs_iget+0x24b/0x690 [xfs]
> [  696.867322] CPU: 1 PID: 1761 Comm: mount Not tainted 3.16.0-4-amd64 #1 Debian 3.16.7-ckt7-1
> [  696.867324] Hardware name: LENOVO 7666A26/7666A26, BIOS 7NETC0WW (2.20 ) 03/12/2009
> [  696.867326]  0000000000000001 ffffffff81509e7c ffff8801365d6000 ffffffffa023b5cb
> [  696.867330]  00000188b87b4a40 ffffffffa0240f6b ffff8800ba194400 ffff8801365d6000
> [  696.867333]  0000000000000075 0000000000000000 ffffffffa0286aea ffffffffa0240f6b
> [  696.867337] Call Trace:
> [  696.867345]  [<ffffffff81509e7c>] ? dump_stack+0x41/0x51
> [  696.867358]  [<ffffffffa023b5cb>] ? xfs_corruption_error+0x5b/0x80 [xfs]
> [  696.867372]  [<ffffffffa0240f6b>] ? xfs_iget+0x24b/0x690 [xfs]
> [  696.867389]  [<ffffffffa0286aea>] ? xfs_iread+0xea/0x400 [xfs]
> [  696.867402]  [<ffffffffa0240f6b>] ? xfs_iget+0x24b/0x690 [xfs]
> [  696.867415]  [<ffffffffa0240f6b>] ? xfs_iget+0x24b/0x690 [xfs]
> [  696.867429]  [<ffffffffa024d270>] ? xfs_parseargs+0xb80/0xb80 [xfs]
> [  696.867444]  [<ffffffffa024a397>] ? xfs_mountfs+0x3e7/0x700 [xfs]
> [  696.867458]  [<ffffffffa024d503>] ? xfs_fs_fill_super+0x293/0x310 [xfs]
> [  696.867463]  [<ffffffff811aae46>] ? mount_bdev+0x1a6/0x1e0
> [  696.867467]  [<ffffffff811ab6d4>] ? mount_fs+0x34/0x1a0
> [  696.867472]  [<ffffffff811c4f22>] ? vfs_kern_mount+0x62/0x110
> [  696.867476]  [<ffffffff811c77aa>] ? do_mount+0x23a/0xaf0
> [  696.867480]  [<ffffffff81157c8d>] ? memdup_user+0x3d/0x70
> [  696.867484]  [<ffffffff811c8351>] ? SyS_mount+0x81/0xc0
> [  696.867488]  [<ffffffff8150ff6d>] ? system_call_fast_compare_end+0x10/0x15
> [  696.867490] XFS (dm-5): Corruption detected. Unmount and run xfs_repair
> [  696.867529] XFS (dm-5): failed to read root inode
> 
> root@vger:~# xfs_repair /dev/mapper/rvg-sav 
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> Metadata corruption detected at block 0x800008/0x1000
> Metadata corruption detected at block 0x8/0x1000
> Metadata corruption detected at block 0x1800008/0x1000
> Metadata corruption detected at block 0x800010/0x1000
> bad uuid a2320a38-0c83-478e-bc31-4bc3fb253fdd for agf 1
> bad uuid a2320a38-0c83-478e-bc31-4bc3fb253fdd for agi 1
> reset bad agf for ag 1
> reset bad agi for ag 1
> Metadata corruption detected at block 0x1000008/0x1000
> Metadata corruption detected at block 0x1800010/0x1000
> bad uuid a2320a38-0c83-478e-bc31-4bc3fb253fdd for agf 3
> bad uuid a2320a38-0c83-478e-bc31-4bc3fb253fdd for agi 3
> reset bad agf for ag 3
> reset bad agi for ag 3
> Metadata corruption detected at block 0x10/0x1000
> bad uuid a2320a38-0c83-478e-bc31-4bc3fb253fdd for agf 0
> bad uuid a2320a38-0c83-478e-bc31-4bc3fb253fdd for agi 0
> reset bad agf for ag 0
> reset bad agi for ag 0
> Metadata corruption detected at block 0x800018/0x1000
> Metadata corruption detected at block 0x1000010/0x1000
> bad uuid a2320a38-0c83-478e-bc31-4bc3fb253fdd for agf 2
> bad uuid a2320a38-0c83-478e-bc31-4bc3fb253fdd for agi 2
> reset bad agf for ag 2
> reset bad agi for ag 2
> Metadata corruption detected at block 0x1800018/0x1000
> Metadata corruption detected at block 0x800020/0x1000
> btree block 1/4 is suspect, error 117
> Metadata corruption detected at block 0x1000018/0x1000
> Metadata corruption detected at block 0x18/0x1000
> Metadata corruption detected at block 0x1800020/0x1000
> btree block 3/4 is suspect, error 117
> Metadata corruption detected at block 0x1000020/0x1000
> btree block 2/4 is suspect, error 117
> Metadata corruption detected at block 0x20/0x1000
> Metadata corruption detected at block 0x1800028/0x1000
> btree block 3/5 is suspect, error 117
> Metadata corruption detected at block 0x800028/0x1000
> btree block 1/5 is suspect, error 117
> 
> btree block 0/4 is suspect, error 117
> Metadata corruption detected at block 0x1000028/0x1000
> btree block 2/5 is suspect, error 117
> Metadata corruption detected at block 0x1800030/0x1000
> btree block 3/6 is suspect, error 117
> Metadata corruption detected at block 0x800030/0x1000
> btree block 1/6 is suspect, error 117
> Metadata corruption detected at block 0x28/0x1000
> btree block 0/5 is suspect, error 117
> Metadata corruption detected at block 0x1000030/0x1000
> btree block 2/6 is suspect, error 117
> Metadata corruption detected at block 0x1800038/0x1000
> btree block 3/7 is suspect, error 117
> Metadata corruption detected at block 0x800038/0x1000
> btree block 1/7 is suspect, error 117
> Metadata corruption detected at block 0x30/0x1000
> Metadata corruption detected at block 0x1000038/0x1000
> btree block 2/7 is suspect, error 117
> btree block 0/6 is suspect, error 117
> Metadata corruption detected at block 0x38/0x1000
> btree block 0/7 is suspect, error 117
> undiscovered finobt record, ino 96 (0/96)
> root inode chunk not found
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
> found inodes not in the inode allocation tree
>         - process known inodes and perform inode discovery...
>         - agno = 0
> UUID mismatch on inode 96
> UUID mismatch on inode 97
> UUID mismatch on inode 98
> UUID mismatch on inode 99
> UUID mismatch on inode 100
> UUID mismatch on inode 101
> UUID mismatch on inode 102
> UUID mismatch on inode 103
> UUID mismatch on inode 104
> UUID mismatch on inode 105
> UUID mismatch on inode 106
> UUID mismatch on inode 107
> UUID mismatch on inode 108
> UUID mismatch on inode 109
> UUID mismatch on inode 110
> UUID mismatch on inode 111
> UUID mismatch on inode 112
> UUID mismatch on inode 113
> UUID mismatch on inode 114
> UUID mismatch on inode 115
> UUID mismatch on inode 116
> UUID mismatch on inode 117
> UUID mismatch on inode 118
> UUID mismatch on inode 119
> UUID mismatch on inode 120
> UUID mismatch on inode 121
> UUID mismatch on inode 122
> UUID mismatch on inode 123
> UUID mismatch on inode 124
> UUID mismatch on inode 125
> UUID mismatch on inode 126
> UUID mismatch on inode 127
> UUID mismatch on inode 128
> UUID mismatch on inode 129
> UUID mismatch on inode 130
> UUID mismatch on inode 131
> UUID mismatch on inode 132
> UUID mismatch on inode 133
> UUID mismatch on inode 134
> UUID mismatch on inode 135
> UUID mismatch on inode 136
> UUID mismatch on inode 137
> UUID mismatch on inode 138
> UUID mismatch on inode 139
> UUID mismatch on inode 140
> UUID mismatch on inode 141
> UUID mismatch on inode 142
> UUID mismatch on inode 143
> UUID mismatch on inode 144
> UUID mismatch on inode 145
> UUID mismatch on inode 146
> UUID mismatch on inode 147
> UUID mismatch on inode 148
> UUID mismatch on inode 149
> UUID mismatch on inode 150
> UUID mismatch on inode 151
> UUID mismatch on inode 152
> UUID mismatch on inode 153
> UUID mismatch on inode 154
> UUID mismatch on inode 155
> UUID mismatch on inode 156
> UUID mismatch on inode 157
> UUID mismatch on inode 158
> UUID mismatch on inode 159
> UUID mismatch on inode 96
> cleared root inode 96
> UUID mismatch on inode 97
> cleared realtime bitmap inode 97
> UUID mismatch on inode 98
> cleared realtime summary inode 98
> UUID mismatch on inode 99
> cleared inode 99
> UUID mismatch on inode 100
> cleared inode 100
> UUID mismatch on inode 101
> cleared inode 101
> UUID mismatch on inode 102
> cleared inode 102
> UUID mismatch on inode 103
> cleared inode 103
> UUID mismatch on inode 104
> cleared inode 104
> UUID mismatch on inode 105
> cleared inode 105
> UUID mismatch on inode 106
> cleared inode 106
> UUID mismatch on inode 107
> cleared inode 107
> UUID mismatch on inode 108
> cleared inode 108
> UUID mismatch on inode 109
> cleared inode 109
> UUID mismatch on inode 110
> cleared inode 110
> UUID mismatch on inode 111
> cleared inode 111
> UUID mismatch on inode 112
> cleared inode 112
> UUID mismatch on inode 113
> cleared inode 113
> UUID mismatch on inode 114
> cleared inode 114
> UUID mismatch on inode 115
> cleared inode 115
> UUID mismatch on inode 116
> cleared inode 116
> UUID mismatch on inode 117
> cleared inode 117
> UUID mismatch on inode 118
> cleared inode 118
> UUID mismatch on inode 119
> cleared inode 119
> UUID mismatch on inode 120
> cleared inode 120
> UUID mismatch on inode 121
> cleared inode 121
> UUID mismatch on inode 122
> cleared inode 122
> UUID mismatch on inode 123
> cleared inode 123
> UUID mismatch on inode 124
> cleared inode 124
> UUID mismatch on inode 125
> cleared inode 125
> UUID mismatch on inode 126
> cleared inode 126
> UUID mismatch on inode 127
> cleared inode 127
> UUID mismatch on inode 128
> cleared inode 128
> UUID mismatch on inode 129
> cleared inode 129
> UUID mismatch on inode 130
> cleared inode 130
> UUID mismatch on inode 131
> cleared inode 131
> UUID mismatch on inode 132
> cleared inode 132
> UUID mismatch on inode 133
> cleared inode 133
> UUID mismatch on inode 134
> cleared inode 134
> UUID mismatch on inode 135
> cleared inode 135
> UUID mismatch on inode 136
> cleared inode 136
> UUID mismatch on inode 137
> cleared inode 137
> UUID mismatch on inode 138
> cleared inode 138
> UUID mismatch on inode 139
> cleared inode 139
> UUID mismatch on inode 140
> cleared inode 140
> UUID mismatch on inode 141
> cleared inode 141
> UUID mismatch on inode 142
> cleared inode 142
> UUID mismatch on inode 143
> cleared inode 143
> UUID mismatch on inode 144
> cleared inode 144
> UUID mismatch on inode 145
> cleared inode 145
> UUID mismatch on inode 146
> cleared inode 146
> UUID mismatch on inode 147
> cleared inode 147
> UUID mismatch on inode 148
> cleared inode 148
> UUID mismatch on inode 149
> cleared inode 149
> UUID mismatch on inode 150
> cleared inode 150
> UUID mismatch on inode 151
> cleared inode 151
> UUID mismatch on inode 152
> cleared inode 152
> UUID mismatch on inode 153
> cleared inode 153
> UUID mismatch on inode 154
> cleared inode 154
> UUID mismatch on inode 155
> cleared inode 155
> UUID mismatch on inode 156
> cleared inode 156
> UUID mismatch on inode 157
> cleared inode 157
> UUID mismatch on inode 158
> cleared inode 158
> UUID mismatch on inode 159
> cleared inode 159
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
> root inode lost
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
> reinitializing root directory
> reinitializing realtime bitmap inode
> reinitializing realtime summary inode
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> resetting inode 96 nlinks from 1 to 2
> done
> 
> root@vger:~# mount /dev/mapper/rvg-sav /tmp/sav
> 
> [  811.386714] XFS (dm-5): Mounting V5 Filesystem
> [  811.432582] XFS (dm-5): Ending clean mount
> 
> 
> root@vger:~# ls -la /tmp/sav/
> total 0
> drwxr-xr-x  2 root root   6 Apr  6 14:40 .
> drwxrwxrwt 10 root root 200 Apr  6 14:38 ..
> 
> 
> 
> -- System Information:
> Debian Release: 8.0
>   APT prefers testing-proposed-updates
>   APT policy: (500, 'testing-proposed-updates'), (500, 'testing'), (1, 'experimental')
> Architecture: amd64 (x86_64)
> 
> Kernel: Linux 3.16.0-4-amd64 (SMP w/2 CPU cores)
> Locale: LANG=de_DE.UTF-8, LC_CTYPE=de_DE.UTF-8 (charmap=UTF-8)
> Shell: /bin/sh linked to /bin/dash
> Init: systemd (via /run/systemd/system)
> 
> Versions of packages xfsprogs depends on:
> ii  libblkid1     2.25.2-6
> ii  libc6         2.19-17
> ii  libreadline5  5.2+dfsg-2
> ii  libuuid1      2.25.2-6
> 
> xfsprogs recommends no packages.
> 
> Versions of packages xfsprogs suggests:
> ii  acl      2.2.52-2
> pn  attr     <none>
> pn  quota    <none>
> pn  xfsdump  <none>
> 
> -- no debconf information
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
