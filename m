Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n47NXDk9235853 for <xfs@oss.sgi.com>; Thu, 7 May 2009 18:33:13 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FEA01D1AD99
	for <xfs@oss.sgi.com>; Thu,  7 May 2009 16:33:16 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id RHrYaBz3mo1vs79j for
	<xfs@oss.sgi.com>; Thu, 07 May 2009 16:33:16 -0700 (PDT)
Message-ID: <4A036FBC.9020201@sandeen.net>
Date: Thu, 07 May 2009 18:33:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
In-Reply-To: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Alexander Beregalov wrote:
> # xfs_db -r /dev/sdc1
> xfs_db> frag
> actual 23805, ideal 22890, fragmentation factor 3.84%
> # xfs_fsr -v /dev/sdc1
> /mnt/c start inode=0
> ino=158
> extents before:3 after:1 DONE ino=158
> 
>  then it hangs

Ok, yep with the testcase I proposed I see this on the fedora
2.6.30-rc4.git3 x86 kernel as well:

# for I in `seq 10 -1 0`; do
 dd if=/dev/zero of=fragfile bs=4k count=1 seek=$I conv=notrunc oflag=sync
done

# xfs_fsr fragfile

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
xfs_fsr/1459 is trying to release lock (&(&ip->i_iolock)->mr_lock) at:
[<e248dedb>] xfs_iunlock+0x2c/0x92 [xfs]
but there are no more locks to release!

other info that might help us debug this:
no locks held by xfs_fsr/1459.

stack backtrace:
Pid: 1459, comm: xfs_fsr Not tainted 2.6.30-0.78.rc4.git3.fc12.i586 #1
Call Trace:
 [<c07e2f2e>] ? printk+0x22/0x3c
 [<c0465f34>] print_unlock_inbalance_bug+0xb3/0xd1
 [<e248dedb>] ? xfs_iunlock+0x2c/0x92 [xfs]
 [<c04661e2>] lock_release+0xd0/0x1a6
 [<c04571ce>] up_write+0x29/0x50
 [<e248dedb>] xfs_iunlock+0x2c/0x92 [xfs]
 [<e2496bdb>] xfs_swap_extents+0x427/0x4cc [xfs]
 [<e2496d5a>] xfs_swapext+0xda/0x11c [xfs]
 [<c0a4586d>] ? kobject_uevent_init+0x30/0x6d
 [<e24b2386>] xfs_file_ioctl+0x4ac/0x67e [xfs]
 [<c0592f00>] ? avc_has_perm_noaudit+0x3b1/0x3cc
 [<e24b1eda>] ? xfs_file_ioctl+0x0/0x67e [xfs]
 [<c04ec8fa>] vfs_ioctl+0x29/0x91
 [<c04ecdf8>] do_vfs_ioctl+0x496/0x4e3
 [<c0a4586d>] ? kobject_uevent_init+0x30/0x6d
 [<c05946b7>] ? selinux_file_ioctl+0x4d/0x62
 [<c0a4586d>] ? kobject_uevent_init+0x30/0x6d
 [<c04ece9a>] sys_ioctl+0x55/0x86
 [<c040c6cb>] ? syscall_trace_enter+0xea/0x10f
 [<c040419c>] syscall_call+0x7/0xb
 [<c0a4586d>] ? kobject_uevent_init+0x30/0x6d

there are 2 subsequent unlocks for the same inode:

1:
xfs_iunlock: ip ca2304c0 ino 132  flags 0x5
Pid: 3648, comm: xfs_fsr Not tainted 2.6.30-0.78.rc4.git3.fc12.i586 #1
Call Trace:
 [<e3a81ee7>] xfs_iunlock+0x38/0xb9 [xfs]
 [<e3a82404>] xfs_iput+0x20/0x40 [xfs]
 [<e3a8793b>] xfs_inode_item_unlock+0x82/0x97 [xfs]
 [<e3a9a288>] xfs_trans_unlock_chunk+0x96/0xe1 [xfs]
 [<e3a9a37a>] xfs_trans_unlock_items+0x4f/0xd4 [xfs]
 [<e3a985a9>] _xfs_trans_commit+0x275/0x307 [xfs]
 [<e3a8ac27>] xfs_swap_extents+0x403/0x4cc [xfs]
 [<e3a8adca>] xfs_swapext+0xda/0x11c [xfs]
 [<e3aa63f6>] xfs_file_ioctl+0x4ac/0x67e [xfs]
 [<c04ec8fa>] vfs_ioctl+0x29/0x91
 [<c04ecdf8>] do_vfs_ioctl+0x496/0x4e3
 [<c04ece9a>] sys_ioctl+0x55/0x86
 [<c040419c>] syscall_call+0x7/0xb

2:
xfs_iunlock: ip ca230980 ino 131  flags 0x5
Pid: 3648, comm: xfs_fsr Not tainted 2.6.30-0.78.rc4.git3.fc12.i586 #1
Call Trace:
 [<e3a81ee7>] xfs_iunlock+0x38/0xb9 [xfs]
 [<e3a8ac4b>] xfs_swap_extents+0x427/0x4cc [xfs]
 [<e3a8adca>] xfs_swapext+0xda/0x11c [xfs]
 [<e3aa63f6>] xfs_file_ioctl+0x4ac/0x67e [xfs]
 [<c04ec8fa>] vfs_ioctl+0x29/0x91
 [<c04ecdf8>] do_vfs_ioctl+0x496/0x4e3
 [<c04ece9a>] sys_ioctl+0x55/0x86
 [<c040419c>] syscall_call+0x7/0xb

Looking into it ... not sure offhand what caused this.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
