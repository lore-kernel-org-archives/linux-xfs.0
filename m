Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 90D467F61
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 10:16:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 566AD304048
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 08:16:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id R0xsO2UiQXJfxGY1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Jun 2015 08:16:23 -0700 (PDT)
Date: Thu, 11 Jun 2015 11:16:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
Message-ID: <20150611151620.GB59168@bfoster.bfoster>
References: <5579296A.8010208@skylable.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5579296A.8010208@skylable.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@skylable.com>
Cc: Christopher Squires <christopher.squires@hgst.com>, Wayne Burri <wayne.burri@hgst.com>, Luca Gibelli <luca@skylable.com>, xfs@oss.sgi.com

On Thu, Jun 11, 2015 at 09:23:38AM +0300, T=F6r=F6k Edwin wrote:
> [1.] XFS on ARM corruption 'Structure needs cleaning'
> [2.] Full description of the problem/report:
> =

> I have been running XFS sucessfully on x86-64 for years, however I'm havi=
ng trouble running it on ARM.
> =

> Running the testcase below [7.] reliably reproduces the filesystem corrup=
tion starting from a freshly
> created XFS filesystem: running ls after 'sxadm node --new --batch /expor=
t/dfs/a/b' shows a 'Structure needs cleaning' error,
> and dmesg shows a corruption error [6.].
> xfs_repair 3.1.9 is not able to repair the corruption: after mounting the=
 repair filesystem
> I still get the 'Structure needs cleaning' error.
> =

> Note: using /export/dfs/a/b is important for reproducing the problem: if =
I only use one level of directories in /export/dfs then the problem
> doesn't reproduce. Also if I use a tuned version of sxadm that creates fe=
wer database files then the problem doesn't reproduce either.
> =

> [3.] Keywords: filesystems, XFS corruption, ARM
> [4.] Kernel information
> [4.1.] Kernel version (from /proc/version):
> Linux hornet34 3.14.3-00088-g7651c68 #24 Thu Apr 9 16:13:46 MDT 2015 armv=
7l GNU/Linux
> =

...
> [5.] Most recent kernel version which did not have the bug: Unknown, firs=
t kernel I try on ARM
> =

> [6.] dmesg stacktrace
> =

> [4627578.440000] XFS (sda4): Mounting Filesystem
> [4627578.510000] XFS (sda4): Ending clean mount
> [4627621.470000] dd6ee000: 58 46 53 42 00 00 10 00 00 00 00 00 37 40 21 0=
0  XFSB........7@!.
> [4627621.480000] dd6ee010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0  ................
> [4627621.490000] dd6ee020: 5b 08 7f 79 0e 3a 46 3d 9b ea 26 ad 9d 62 17 8=
d  [..y.:F=3D..&..b..
> [4627621.490000] dd6ee030: 00 00 00 00 20 00 00 04 00 00 00 00 00 00 00 8=
0  .... ...........

Just a data point... the magic number here looks like a superblock magic
(XFSB) rather than one of the directory magic numbers. I'm wondering if
a buffer disk address has gone bad somehow or another.

Does this happen to be a large block device? I don't see any partition
or xfs_info data below. If so, it would be interesting to see if this
reproduces on a smaller device. It does appear that the large block
device option is enabled in the kernel config above, however, so maybe
that's unrelated.

Brian

> [4627621.500000] XFS (sda4): Internal error xfs_dir3_data_read_verify at =
line 274 of file fs/xfs/xfs_dir2_data.c.  Caller 0xc01c1528
> [4627621.510000] CPU: 0 PID: 37 Comm: kworker/0:1H Not tainted 3.14.3-000=
88-g7651c68 #24
> [4627621.510000] Workqueue: xfslogd xfs_buf_iodone_work
> [4627621.510000] [<c0013948>] (unwind_backtrace) from [<c0011058>] (show_=
stack+0x10/0x14)
> [4627621.510000] [<c0011058>] (show_stack) from [<c01c3dc4>] (xfs_corrupt=
ion_error+0x54/0x70)
> [4627621.510000] [<c01c3dc4>] (xfs_corruption_error) from [<c01f7854>] (x=
fs_dir3_data_read_verify+0x60/0xd0)
> [4627621.510000] [<c01f7854>] (xfs_dir3_data_read_verify) from [<c01c1528=
>] (xfs_buf_iodone_work+0x7c/0x94)
> [4627621.510000] [<c01c1528>] (xfs_buf_iodone_work) from [<c00309f0>] (pr=
ocess_one_work+0xf4/0x32c)
> [4627621.510000] [<c00309f0>] (process_one_work) from [<c0030fb4>] (worke=
r_thread+0x10c/0x388)
> [4627621.510000] [<c0030fb4>] (worker_thread) from [<c0035e10>] (kthread+=
0xbc/0xd8)
> [4627621.510000] [<c0035e10>] (kthread) from [<c000e8f8>] (ret_from_fork+=
0x14/0x3c)
> [4627621.510000] XFS (sda4): Corruption detected. Unmount and run xfs_rep=
air
> [4627621.520000] XFS (sda4): metadata I/O error: block 0x6e804200 ("xfs_t=
rans_read_buf_map") error 117 numblks 8
> =

> [7.] Testcase:
> =

> $ curl -O http://vol-public.s3.indian.skylable.com:8008/armel/testcase/li=
bsx2_1.1-1_armel.deb
> $ curl -O http://vol-public.s3.indian.skylable.com:8008/armel/testcase/sx=
_1.1-1_armel.deb
> $ sudo dpkg -i libsx2_*.deb sx_*.deb
> $ sudo umount /export/dfs
> $ sudo mkfs.xfs -f /dev/sda4
> $ sudo mount /dev/sda4 /export/dfs
> $ sudo mkdir /export/dfs/a
> $ sudo sxadm node --new --batch /export/dfs/a/b
> $ sudo ls /export/dfs/a/b
> ls: reading directory /export/dfs/a/b: Structure needs cleaning
> $ dmesg
> $ sudo umount /export/dfs
> $ sudo xfs_repair /dev/sda4
> $ sudo mount /dev/sda4 /export/dfs
> $ sudo ls /export/dfs/a/b
> ls: reading directory /export/dfs/a/b: Structure needs cleaning
> =

> 'sxadm node --new' uses SQLite3 to create a set of new databases and repr=
oduces the problem reliably.
> However I was not able to reproduce this by just using the command-line s=
qlite tools.
> =

> The source code of sxadm can be found here if you want to build manually =
instead of using a package:
> http://gitweb.skylable.com/gitweb/?p=3Dsx.git;a=3Dsummary
> =

> [8.] Environment
> [8.1.] Software (add the output of the ver_linux script here)
> Linux hornet34 3.14.3-00088-g7651c68 #24 Thu Apr 9 16:13:46 MDT 2015 armv=
7l GNU/Linux
>  =

> Gnu C                  =

> binutils               =

> util-linux             2.20.1
> mount                  support
> module-init-tools      16
> e2fsprogs              1.42.9
> xfsprogs               3.1.9
> Linux C Library        2.17
> Dynamic linker (ldd)   2.17
> Procps                 3.3.9
> Net-tools              1.60
> Kbd                    =

> Sh-utils               8.21
> Modules Loaded =

> =

> [8.2.] Processor information (from /proc/cpuinfo):
> processor       : 0
> model name      : ARMv7 Processor rev 0 (v7l)
> Features        : swp half thumb fastmult edsp tls =

> CPU implementer : 0x41
> CPU architecture: 7
> CPU variant     : 0x4
> CPU part        : 0xc09
> CPU revision    : 0
> =

> Hardware        : hornet
> Revision        : 0000
> Serial          : 0000000000000000
> =

> [8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
> 14872000-14872fff : sn_dev
> 14a00000-14a3ffff : sn_dev
> 14050000-14050fff : uart
>   14050000-14050fff : uart-pl011
> 30000000-9fffffff : System RAM
>   30008000-304f616f : Kernel code
>   30518000-305ae327 : Kernel data
> =

> [8.6.] /proc/scsi/scsi:
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: HGST     Model: HUS724040ALS640  Rev: aH1F
>   Type:   Direct-Access                    ANSI  SCSI revision: 06
> =

> [8.7.] /proc/fs/xfs/stat:
> extent_alloc 199 5043 79 570
> abt 0 0 0 0
> blk_map 16325 7059 666 192 363 24055 0
> bmbt 0 0 0 0
> dir 461 594 476 18
> trans 9 4656 252
> ig 0 215 0 383 0 383 954
> log 30 546 0 74041 11
> push_ail 4971 0 1821 59 0 270 0 250 0 3
> xstrat 184 0
> rw 8005 8827
> attr 412 0 0 0
> icluster 22 17 250
> vnodes 4294966698 0 0 0 598 598 598 0
> buf 6693 101 6661 5 0 32 0 45 15
> abtb2 287 399 11 10 0 0 0 0 0 0 0 0 0 0 24
> abtc2 557 766 279 278 0 0 0 0 0 0 0 0 0 0 560
> bmbt2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> ibt2 1896 3700 7 5 0 0 0 0 0 0 0 0 0 0 2
> qm 0 0 0 0 0 0 0 0
> xpc 20508672 20922056 263794352
> debug 0
> =

> Best regards,
> --Edwin
> =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
