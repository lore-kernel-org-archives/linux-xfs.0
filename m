Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1O9iUsv014709
	for <linux-xfs@oss.sgi.com>; Fri, 24 Feb 2012 03:44:30 -0600
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	jHb27w0nLh55E5KY (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <linux-xfs@oss.sgi.com>;
	Fri, 24 Feb 2012 01:44:29 -0800 (PST)
Received: by wibhi8 with SMTP id hi8so1510806wib.26
	for <linux-xfs@oss.sgi.com>; Fri, 24 Feb 2012 01:44:28 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 24 Feb 2012 15:14:28 +0530
Message-ID: <CADDb1s3hy-=vEWKevmtpbSLiPZ727SEa4P1XeRCb+xVeevzWnw@mail.gmail.com>
Subject: kernel BUG at fs/namei.c:1320!
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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
To: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@oss.sgi.com

I have encountered a BUG_ON in VFS

kernel version: 2.6.35.14
Architecture: ARM

Test Case: Tried to remove a file from a corrupted filesystem.

>From the trigger BUG_ON point it points that the inode which
is to be removed - has not matching parent directory from which it is
to be removed.

Even though -it is reasonable - to verify this parent/child behaviour,
but I have a
doubt about the placement of BUG_ON at this place. Because this leads to 'halt'
of complete system - even though it is related to particular filesystem(file).
So, instead of BUG_ON -> WARN_ON could have been used to highlight the issue.

Please share your opinion - also is this really related with the FS
corruption thing or can be
some issue with the dentry caching part?


kernel BUG at fs/namei.c:1320!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = deb5c000
[00000000] *pgd=a577d031, *pte=00000000, *ppte=00000000
...
...
PC is at __bug+0x2c/0x38
LR is at sub_preempt_count+0x4c/0x68
pc : [<c003f4b8>]    lr : [<c038f8ac>]    psr: 60000013
sp : deb39ed0  ip : deb39df0  fp : deb39edc
r10: 00000000  r9 : deb38000  r8 : c003b708
r7 : 00000028  r6 : 00000001  r5 : e401c9d0  r4 : e41a5220
r3 : 00000000  r2 : 40000000  r1 : c04b3ce4  r0 : 00000034
...
...
Backtrace(CPU 1):
[<c003f48c>] (__bug+0x0/0x38) from [<c0142cb0>] (may_delete+0x44/0x134)
[<c0142c6c>] (may_delete+0x0/0x134) from [<c014446c>] (vfs_rmdir+0x24/0xdc)
 r7:00000028 r6:0000000c r5:e401cbb8 r4:e41a5220
[<c0144448>] (vfs_rmdir+0x0/0xdc) from [<c0146068>] (do_rmdir+0xac/0xf8)
 r6:0000000c r5:00000000 r4:e41a5220 r3:e41a5220
[<c0145fbc>] (do_rmdir+0x0/0xf8) from [<c014610c>] (sys_rmdir+0x20/0x24)
 r5:ffffffff r4:00994388
[<c01460ec>] (sys_rmdir+0x0/0x24) from [<c003b4c0>] (ret_fast_syscall+0x0/0x48)
Code: e59f0010 e1a01003 eb0d28f0 e3a03000 (e5833000)


Thanks & Regards,
Amit Sahrawat

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
