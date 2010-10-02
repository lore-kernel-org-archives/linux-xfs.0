Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o92Ac6P3175418 for <xfs@oss.sgi.com>; Sat, 2 Oct 2010 05:38:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1CEEEA3F74
	for <xfs@oss.sgi.com>; Sat,  2 Oct 2010 03:52:27 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	u4mybhfFiuix3h3G for <xfs@oss.sgi.com>;
	Sat, 02 Oct 2010 03:52:27 -0700 (PDT)
Date: Sat, 2 Oct 2010 20:39:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_db -c frag -r /dev/sdb1 segmentation fault
Message-ID: <20101002103902.GE4681@dastard>
References: <AANLkTi=kzGSGtmk8a_eu5n9w6wbvt_f28Va9gSeWNgCe@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=kzGSGtmk8a_eu5n9w6wbvt_f28Va9gSeWNgCe@mail.gmail.com>
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
To: Robert Pipca <robertpipca@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 01, 2010 at 05:06:08PM -0300, Robert Pipca wrote:
> Hi,
> 
> I'm using kernel 2.6.34.7 on a gentoo amd64 system.
> 
> Towards the end of the command, I get:
> 
> read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
> 16384) = 16384
> lseek(4, 352256, SEEK_SET)              = 352256
> read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
> 16384) = 16384
> lseek(4, 376832, SEEK_SET)              = 376832
> read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
> 16384) = 16384
> lseek(4, 393216, SEEK_SET)              = 393216
> read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
> 16384) = 16384
> lseek(4, 417792, SEEK_SET)              = 417792
> read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
> 16384) = 16384
> lseek(4, 434176, SEEK_SET)              = 434176
> read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
> 16384) = 16384
> lseek(4, 450560, SEEK_SET)              = 450560
> read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
> 16384) = 16384
> lseek(4, 475136, SEEK_SET)              = 475136
> read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
> 16384) = 16384
> lseek(4, 491520, SEEK_SET)              = 491520
> read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
> 16384) = 16384
> lseek(4, 516096, SEEK_SET)              = 516096
> read(4, "INA\350\2\1\0\0\0\0\377\376\0\0\377\376\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\1L"...,
> 16384) = 16384
> lseek(4, 14190936064, SEEK_SET)         = 14190936064
> read(4, "BMAP\0\0\0\n\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\0\0\0\0\0\0\0\0\0"...,
> 4096) = 4096
> lseek(4, 532480, SEEK_SET)              = 532480
> read(4, "IN\201\240\2\3\0\0\0\0\377\376\0\0\377\376\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\21L"...,
> 16384) = 16384
> lseek(4, 37129601024, SEEK_SET)         = 37129601024
> read(4, "BMAP\0\0\0\n\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\0\0\0\0\0\0\0\0\0"...,
> 4096) = 4096
> lseek(4, 37028130816, SEEK_SET)         = 37028130816
> read(4, "BMAP\0\0\0\n\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\377\0\0\0\0\0\0\0\0\0"...,
> 4096) = 4096
> lseek(4, 36522024960, SEEK_SET)         = 36522024960
> read(4, "\177\260g\203\223s\231\364\273\222\276\34\363~\253\355\271\271\17h\237\v\357\274\230\25\334\351x\2719&\34"...,
> 4096) = 4096
> brk(0x26af000)                          = 0x26af000
> brk(0x26a0000)                          = 0x26a0000
> mmap(NULL, 200704, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
> -1, 0) = 0x7ff07237e000
> brk(0x2690000)                          = 0x2690000
> --- SIGSEGV (Segmentation fault) @ 0 (0) ---
> +++ killed by SIGSEGV +++
> 
> 
> Is this a kernel or a XFS problem?

It's an xfs_db problem. what version are you running (xfs_db -V)?
Can you build a non-stripped xfs_db executable and run it under gdb
so we can get a stack trace and location of where the SEGV is
occurring?

Note that the crash could be caused by a corrupted filesystem.
Running xfs_repair -n over the filesystem will tell you if there are
any problems in the filesystem. If there are, can you post the
output of the repair command as well?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
