Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A5C37F37
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 14:49:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F12B4AC003
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 12:49:51 -0700 (PDT)
Received: from skeena.net ([199.60.222.33]) by cuda.sgi.com with ESMTP id
	112ofeymSSmVgzxS (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 12:49:47 -0700 (PDT)
Received: from innuk.localdomain (S01061caff7de9d56.gv.shawcable.net
	[184.66.28.75])
	(using SSLv3 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: felix@skeena.net)
	by skeena.net (Postfix) with ESMTPSA id 2E84C125BDA5
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 12:49:49 -0700 (PDT)
Date: Sat, 3 May 2014 12:49:33 -0700
From: Marcel (Felix) Giannelia <info@skeena.net>
Subject: xfs_iflush_int: Bad inode, xfs_do_force_shutdown from xfs_inode.c
	during file copy
Message-ID: <20140503124933.7ed0ff3e@innuk.localdomain>
Mime-Version: 1.0
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
To: xfs@oss.sgi.com

Hi,

I just had the following happen on a server that's never had any
previous issues with XFS:

I was copying an 8 GB file onto an XFS filesystem, when the copy
aborted with an I/O error message and I was forced to unmount and
xfs_repair the filesystem before it would mount again. Relevant dmesg
messages below.

Some other information that might be relevant:

- Distribution & kernel version: Debian 7, uname -a returns:

Linux hostname 3.2.0-4-686-pae #1 SMP Debian 3.2.41-2+deb7u2 i686 GNU/Linux

- This filesystem is on a software (mdadm) RAID 1 array, backed by
  2 disks.

- The drives underneath the RAID reported no errors, and there were no
  errors from either the RAID layer or the disk layer in dmesg. One hard
  drive shows no change in SMART status; the other one's reallocated
  sector count has increased by 1 since the last time I checked (1
  month ago), but there are no logged errors.

- The filesystem is 174 GB and contains 2.5 million (i.e. 2484996)
  files, and had 20 GB of free space. A day or two ago it contained
  around 4 million files and was almost completely full (2 GB free
  space), and the most recent activity before this problem was the
  deletion of about 1.5 million files. (Over 24 hours passed between
  deletion of these files and the attempt to copy the 8 GB file.)

- The file I was copying was a virtual disk image from a virtual
  machine that I had shut down about 5 seconds before starting the 
  copy, so it is likely that some of the file's data had not yet
  been committed to disk on the source filesystem, and it is also
  possible that the source file's metadata and contents
  (but not size) changed during the copy. The source filesystem is
  also xfs.

- A few weeks ago, one of the disks in the RAID 1 array failed and I
  replaced it with two disks, bringing the number of disks in the array
  up to 3. This seemed to cause performance issues (writes took too
  long to complete, causing disk timeouts in the virtual machines), so
  the third disk was removed and the array was changed back to 2 disks.

- I have never seen memory issues in this server before (I ran an
  overnight memtest when it was first set up, but that was a year ago),
  and after this error I ran the userspace program "memtester", as I
  cannot take the server offline. This is a fairly limited test (I was
  only able to test 1 GB of free memory), but it found no problems.

- The problem has not recurred -- after doing xfs_repair and remounting
  the filesystem, I was able to copy that same file without issues. I
  since have also copied another virtual machine disk of the same size,
  while the VM was running, without problems.


Output of xfs_info for the filesystem:

meta-data=/dev/md126             isize=256    agcount=4, agsize=11375416 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=45501664, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=22217, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


dmesg entries:

> Immediately after the cp command exited with "i/o error":

XFS (md126): xfs_iflush_int: Bad inode 939480132, ptr 0xd12fa080, magic number 0x494d
XFS (md126): xfs_do_force_shutdown(0x8) called from line 2606 of file /build/buildd-linux_3.2.41-2+deb7u2-i386-G4jjsr/linux-3.2.41/fs/xfs/xfs_inode.c.  Return address = 0xf88319b4
XFS (md126): Corruption of in-memory data detected.  Shutting down filesystem
XFS (md126): Please umount the filesystem and rectify the problem(s)
Buffer I/O error on device md126, logical block 5673596
lost page write due to I/O error on md126

(about 10 more of the "Buffer I/O error / lost page" messages)


> I then unmounted the filesystem, which caused these lines in dmesg:

XFS (md126): xfs_log_force: error 5 returned.
XFS (md126): xfs_log_force: error 5 returned.
XFS (md126): xfs_log_force: error 5 returned.
XFS (md126): xfs_do_force_shutdown(0x1) called from line 1033 of file /build/buildd-linux_3.2.41-2+deb7u2-i386-G4jjsr/linux-3.2.41/fs/xfs/xfs_buf.c.  Return address = 0xf87fd1a7
XFS (md126): xfs_log_force: error 5 returned.
XFS (md126): xfs_log_force: error 5 returned.


> I then tried to mount the filesystem again and got:

XFS (md126): Mounting Filesystem
XFS (md126): Starting recovery (logdev: internal)
XFS (md126): xlog_recover_inode_pass2: Bad inode log record, rec ptr 0xe153d720, ino 939480132
XFS (md126): Internal error xlog_recover_inode_pass2(2) at line 2259 of file /build/buildd-linux_3.2.41-2+deb7u2-i386-G4jjsr/linux-3.2.41/fs/xfs/xfs_log_recover.c.  Caller 0xf8835e66

Pid: 30323, comm: mount Tainted: G           O 3.2.0-4-686-pae #1 Debian 3.2.41-2+deb7u2
Call Trace:
 [<f8834fb9>] ? xlog_recover_inode_pass2+0x206/0x60a [xfs]
 [<f8835e66>] ? xlog_recover_commit_trans+0x5f/0x80 [xfs]
 [<f8835e66>] ? xlog_recover_commit_trans+0x5f/0x80 [xfs]
 [<f8835fb8>] ? xlog_recover_process_data+0x131/0x1bd [xfs]
 [<f8836277>] ? xlog_do_recovery_pass+0x233/0x57b [xfs]
 [<c1038fa5>] ? vprintk+0x3ae/0x3df
 [<f8836636>] ? xlog_do_log_recovery+0x77/0x92 [xfs]
 [<f8836663>] ? xlog_do_recover+0x12/0xab [xfs]
 [<f8836876>] ? xlog_recover+0x6d/0x79 [xfs]
 [<f883cb53>] ? xfs_log_mount+0xab/0x109 [xfs]
 [<f8838c30>] ? xfs_mountfs+0x2b6/0x501 [xfs]
 [<f8806ff8>] ? xfs_mru_cache_create+0xeb/0x112 [xfs]
 [<f8808839>] ? xfs_fs_fill_super+0x145/0x205 [xfs]
 [<c10ce843>] ? mount_bdev+0x11f/0x16d
 [<f88086f4>] ? xfs_parseargs+0x8da/0x8da [xfs]
 [<c10a0036>] ? move_active_pages_to_lru+0xab/0xde
 [<c10c1536>] ? __kmalloc_track_caller+0x9b/0xa7
 [<f88071f3>] ? xfs_fs_mount+0xe/0x11 [xfs]
 [<f88086f4>] ? xfs_parseargs+0x8da/0x8da [xfs]
 [<c10cef2b>] ? mount_fs+0x55/0x122
 [<c10df139>] ? vfs_kern_mount+0x4a/0x77
 [<c10df459>] ? do_kern_mount+0x2f/0xac
 [<c10e0763>] ? do_mount+0x5d0/0x61e
 [<c12c1631>] ? _cond_resched+0x5/0x18
 [<c10a6b88>] ? memdup_user+0x26/0x43
 [<c10e09ea>] ? sys_mount+0x67/0x96
 [<c12c6e1f>] ? sysenter_do_call+0x12/0x28
XFS (md126): log mount/recovery failed: error 117
XFS (md126): log mount failed


After this, I ran xfs_repair with -L. xfs_repair noted the same bad inode
number and deleted the file I had tried to copy, but otherwise made no changes
that I could see. After this, the filesystem mounted normally and there were no
further issues.

~Felix.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
