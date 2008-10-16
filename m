Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 18:05:56 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G15t3F015355
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 18:05:55 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id 590468F80BA
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 18:07:32 -0700 (PDT)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA20314 for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 12:07:30 +1100
Message-ID: <48F6A19D.9080900@sgi.com>
Date: Thu, 16 Oct 2008 12:06:21 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: another problem with latest code drops
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

fsstress started reporting these errors

fsstress: check_cwd failure
fsstress: check_cwd failure
fsstress: check_cwd failure
fsstress: check_cwd failure
fsstress: check_cwd failure
...

The filesystem is mounted on /mnt/data but the mount point is now toast.

wipeout:/mnt # mount
...
/dev/mapper/dm0 on /mnt/data type xfs (rw,logdev=/dev/ram0,nobarrier)


wipeout:/mnt # ls -alF
/bin/ls: data: Input/output error
total 4
drwxr-xr-x  6 root root   57 Aug  8 03:09 ./
drwxr-xr-x 21 root root 4096 Oct 15 11:56 ../
?---------  0 root root    0 Dec 31  1969 data
drwxr-xr-x  2 root root    6 Jul 16 08:21 home/

Root inode is 128?

wipeout:/mnt # xfs_db -f /dev/mapper/dm0 
xfs_db> inode 128
xfs_db> print
core.magic = 0x494e
core.mode = 040755
core.version = 2
core.format = 2 (extents)
core.nlinkv2 = 11
core.onlink = 0
core.projid = 0
core.uid = 0
core.gid = 0
core.flushiter = 3
core.atime.sec = Wed Oct 15 12:02:22 2008
core.atime.nsec = 254053000
core.mtime.sec = Wed Oct 15 13:00:56 2008
core.mtime.nsec = 340001031
core.ctime.sec = Wed Oct 15 13:00:56 2008
core.ctime.nsec = 340001031
core.size = 4096
core.nblocks = 1
core.extsize = 0
core.nextents = 1
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 0
next_unlinked = null
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,18,1,0]

Looks okay, must be corrupt in memory only.


I can't cd into the filesystem but luckily I still had a shell open in the filesystem.

wipeout:/mnt/data/temp # ls -alF
/bin/ls: reading directory .: Input/output error
total 0
wipeout:/mnt/data/temp # ls -alF file_1
/bin/ls: file_1: Input/output error
?--------- 0 root root 0 1969-12-31 18:00 file_1
wipeout:/mnt/data/temp # ls -alF file_2
/bin/ls: file_2: Input/output error
?--------- 0 root root 0 1969-12-31 18:00 file_2
wipeout:/mnt/data/temp # ls -alF file_3
/bin/ls: file_3: Input/output error
?--------- 0 root root 0 1969-12-31 18:00 file_3
wipeout:/mnt/data/temp # ls -alF file_4
/bin/ls: file_4: Input/output error
?--------- 0 root root 0 1969-12-31 18:00 file_4
wipeout:/mnt/data/temp # ls -alF file_5
/bin/ls: file_5: Input/output error
?--------- 0 root root 0 1969-12-31 18:00 file_5
...
/bin/ls: file_710: Input/output error
?--------- 0 root root 0 1969-12-31 18:00 file_710
wipeout:/mnt/data/temp # ls -alF file_711
/bin/ls: file_711: Input/output error
?--------- 0 root root 0 1969-12-31 18:00 file_711
wipeout:/mnt/data/temp # ls -alF file_712
/bin/ls: file_712: Input/output error
?--------- 0 root root 0 1969-12-31 18:00 file_712

Lots of files toasted here too.

Here's a hint as to what's gone wrong.

Oct 16 09:54:54 wipeout kernel: [79179.449760] Filesystem "dm-0": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff8118
d422
Oct 16 09:54:54 wipeout kernel: [79179.449773] Pid: 6679, comm: fsstress Not tainted 2.6.27-rc8 #192
Oct 16 09:54:54 wipeout kernel: [79179.449775] 
Oct 16 09:54:54 wipeout kernel: [79179.449775] Call Trace:
Oct 16 09:54:54 wipeout kernel: [79179.449784]  [<ffffffff81176d54>] xfs_error_report+0x3c/0x3e
Oct 16 09:54:54 wipeout kernel: [79179.449789]  [<ffffffff8118d422>] ? xfs_rename+0x703/0x745
Oct 16 09:54:54 wipeout kernel: [79179.449795]  [<ffffffff8118e9cb>] xfs_trans_cancel+0x5f/0xfc
Oct 16 09:54:54 wipeout kernel: [79179.449799]  [<ffffffff8118d422>] xfs_rename+0x703/0x745
Oct 16 09:54:54 wipeout kernel: [79179.449805]  [<ffffffff8119d4b2>] xfs_vn_rename+0x5d/0x61
Oct 16 09:54:54 wipeout kernel: [79179.449810]  [<ffffffff810ab449>] vfs_rename+0x2b2/0x42e
Oct 16 09:54:54 wipeout kernel: [79179.449815]  [<ffffffff810ad0f2>] sys_renameat+0x16d/0x1e3
Oct 16 09:54:54 wipeout kernel: [79179.449821]  [<ffffffff810a66d2>] ? sys_newstat+0x31/0x3c
Oct 16 09:54:54 wipeout kernel: [79179.449826]  [<ffffffff810ad17e>] sys_rename+0x16/0x18
Oct 16 09:54:54 wipeout kernel: [79179.449831]  [<ffffffff8100bf3b>] system_call_fastpath+0x16/0x1b
Oct 16 09:54:54 wipeout kernel: [79179.449835] 
Oct 16 09:54:54 wipeout kernel: [79179.449840] xfs_force_shutdown(dm-0,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff8118e9e4
Oct 16 09:54:54 wipeout kernel: [79179.449851] xfs_imap_to_bp: xfs_trans_read_buf()returned an error 5 on dm-0.  Returning error.
Oct 16 09:54:54 wipeout kernel: [79179.449862] xfs_imap_to_bp: xfs_trans_read_buf()returned an error 5 on dm-0.  Returning error.
Oct 16 09:54:54 wipeout kernel: [79179.449867] Filesystem "dm-0": Corruption of in-memory data detected.  Shutting down filesystem: dm-0
Oct 16 09:54:54 wipeout kernel: [79179.449873] Pid: 6679, comm: fsstress Not tainted 2.6.27-rc8 #192
Oct 16 09:54:54 wipeout kernel: [79179.449878] 
Oct 16 09:54:54 wipeout kernel: [79179.449878] Call Trace:
Oct 16 09:54:54 wipeout kernel: [79179.449883]  [<ffffffff81195daf>] xfs_do_force_shutdown+0xac/0x138
Oct 16 09:54:54 wipeout kernel: [79179.449887]  [<ffffffff8118e9e4>] ? xfs_trans_cancel+0x78/0xfc
Oct 16 09:54:54 wipeout kernel: [79179.449892]  [<ffffffff8118e9e4>] xfs_trans_cancel+0x78/0xfc
Oct 16 09:54:54 wipeout kernel: [79179.449896]  [<ffffffff8118d422>] xfs_rename+0x703/0x745
Oct 16 09:54:54 wipeout kernel: [79179.449901]  [<ffffffff8119d4b2>] xfs_vn_rename+0x5d/0x61
Oct 16 09:54:54 wipeout kernel: [79179.449906]  [<ffffffff810ab449>] vfs_rename+0x2b2/0x42e
Oct 16 09:54:54 wipeout kernel: [79179.449911]  [<ffffffff810ad0f2>] sys_renameat+0x16d/0x1e3
Oct 16 09:54:54 wipeout kernel: [79179.449916]  [<ffffffff810a66d2>] ? sys_newstat+0x31/0x3c
Oct 16 09:54:54 wipeout kernel: [79179.449920]  [<ffffffff810ad17e>] sys_rename+0x16/0x18
Oct 16 09:54:54 wipeout kernel: [79179.449964]  [<ffffffff8100bf3b>] system_call_fastpath+0x16/0x1b
Oct 16 09:54:54 wipeout kernel: [79179.449966] 
Oct 16 09:54:54 wipeout kernel: [79179.449966] Please umount the filesystem, and rectify the problem(s)
Oct 16 09:54:54 wipeout kernel: [79179.450069] xfs_imap_to_bp: xfs_trans_read_buf()returned an error 5 on dm-0.  Returning error.
Oct 16 09:54:54 wipeout kernel: [79179.450119] xfs_imap_to_bp: xfs_trans_read_buf()returned an error 5 on dm-0.  Returning error.
Oct 16 09:54:54 wipeout kernel: [79179.450125] xfs_imap_to_bp: xfs_trans_read_buf()returned an error 5 on dm-0.  Returning error.
Oct 16 09:54:54 wipeout kernel: [79179.450268] xfs_imap_to_bp: xfs_trans_read_buf()returned an error 5 on dm-0.  Returning error.
Oct 16 09:54:54 wipeout kernel: [79179.450273] xfs_imap_to_bp: xfs_trans_read_buf()returned an error 5 on dm-0.  Returning error.

But doesn't explain why the mode of all the files is zeroed out
and with the root inode busted I can't unmount.
