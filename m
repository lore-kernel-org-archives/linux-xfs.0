Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o91K5AMb119342 for <xfs@oss.sgi.com>; Fri, 1 Oct 2010 15:05:10 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 049A11E74326
	for <xfs@oss.sgi.com>; Fri,  1 Oct 2010 13:06:09 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	gxWBehkeJX5OOLi0 for <xfs@oss.sgi.com>;
	Fri, 01 Oct 2010 13:06:09 -0700 (PDT)
Received: by qyk36 with SMTP id 36so3621945qyk.5
	for <xfs@oss.sgi.com>; Fri, 01 Oct 2010 13:06:09 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 1 Oct 2010 17:06:08 -0300
Message-ID: <AANLkTi=kzGSGtmk8a_eu5n9w6wbvt_f28Va9gSeWNgCe@mail.gmail.com>
Subject: xfs_db -c frag -r /dev/sdb1 segmentation fault
From: Robert Pipca <robertpipca@gmail.com>
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
To: xfs@oss.sgi.com, Robert Pipca <robertpipca@gmail.com>

Hi,

I'm using kernel 2.6.34.7 on a gentoo amd64 system.

Towards the end of the command, I get:

read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
16384) = 16384
lseek(4, 352256, SEEK_SET)              = 352256
read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
16384) = 16384
lseek(4, 376832, SEEK_SET)              = 376832
read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
16384) = 16384
lseek(4, 393216, SEEK_SET)              = 393216
read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
16384) = 16384
lseek(4, 417792, SEEK_SET)              = 417792
read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
16384) = 16384
lseek(4, 434176, SEEK_SET)              = 434176
read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
16384) = 16384
lseek(4, 450560, SEEK_SET)              = 450560
read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
16384) = 16384
lseek(4, 475136, SEEK_SET)              = 475136
read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
16384) = 16384
lseek(4, 491520, SEEK_SET)              = 491520
read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
16384) = 16384
lseek(4, 516096, SEEK_SET)              = 516096
read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
16384) = 16384
lseek(4, 14190936064, SEEK_SET)         = 14190936064
read(4, "BMAP\0\0\0\n\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\0\0\0\0\0\0\0\0\0"...,
4096) = 4096
lseek(4, 532480, SEEK_SET)              = 532480
read(4, "IN\201\240\2\3\0\0\0\0\377\376\0\0\377\376\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\21L"...,
16384) = 16384
lseek(4, 37129601024, SEEK_SET)         = 37129601024
read(4, "BMAP\0\0\0\n\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\0\0\0\0\0\0\0\0\0"...,
4096) = 4096
lseek(4, 37028130816, SEEK_SET)         = 37028130816
read(4, "BMAP\0\0\0\n\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\0\0\0\0\0\0\0\0\0"...,
4096) = 4096
lseek(4, 36522024960, SEEK_SET)         = 36522024960
read(4, "\177\260g\203\223s\231\364\273\222\276\34\363~\253\355\271\271\17h\237\v\357\274\230\25\334\351x\2719&\34"...,
4096) = 4096
brk(0x26af000)                          = 0x26af000
brk(0x26a0000)                          = 0x26a0000
mmap(NULL, 200704, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0x7ff07237e000
brk(0x2690000)                          = 0x2690000
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV +++


Is this a kernel or a XFS problem?

Cheers,

- Robert

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
