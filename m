Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 15:13:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9GMDNua027399
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:13:24 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42DC1508FF4
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:15:04 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id wayDOiW5ErqRp47s for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 15:15:04 -0700 (PDT)
Message-ID: <48F7BC9F.4080909@sandeen.net>
Date: Thu, 16 Oct 2008 17:13:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption on the arm(el) architecture
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com>
In-Reply-To: <20081016212500.GA27228@deprecation.cyrius.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

Martin Michlmayr wrote:
> Hi Eric,
> 
> I tried to reproduce this problem on my ARM machine and it's really
> easy to trigger.  See the transcript below.
> 
> I tried with 2.6.26.6 (without the ARM old ABI fix) and 2.6.27 (with
> the fix), and with xfsprogs 2.9.8-1.
> 
> Note that I'm actually using the ARM EABI, and not the old ABI.
> I'm not sure what Tobias used.
> 
> xfs.ko compiled with -g can be found at http://www.cyrius.com/tmp/xfs.ko.bz2
> (3.1 MB)

Thanks; a quick look at the disk structure sizes & offsets shows no
differences (as I'd hope/expect for ARM EABI).

> Here's the transcript.  It's really easy to trigger.  Just copy some
> files to the XFS partition (works) and then run 'ls' (oops):

So is this a regression?  did it used to work?  If so, when? :)

(just for the record; it didn't oops, it shut down the filesystem and
gave you a backtrace to the error...)

It's trying to get a buffer for a directory leaf block from disk, and
it's finding that the magic number is bad.

What's a little odd is that the buffer it dumped out looks like the
beginning of a perfectly valid superblock for your filesystem (magic,
block size, and block count all match).   If you printk the "bno"
variable right around line 2106 in xfs_da_btree.c, can you see what you get?

creating an xfs_metadump of the filesystem for examination on a non-arm
box might also be interesting.

Thanks,
-Eric

> debian:~# modprobe xfs
> debian:~# mkfs.xfs -f /dev/sda6
> meta-data=/dev/sda6              isize=256    agcount=4, agsize=17778431 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=71113722, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> debian:~# dmesg | tail -n 2
> [42949548.970000] SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
> [42949548.980000] SGI XFS Quota Management subsystem
> debian:~# mount /dev/sda6 /mnt
> debian:~# dmesg | tail -n 2
> [42949596.470000] XFS mounting filesystem sda6
> [42949596.610000] Ending clean XFS mount for filesystem: sda6
> debian:~# cp /usr/bin/* /mnt/
> debian:~# dmesg | tail -n 2
> [42949596.470000] XFS mounting filesystem sda6
> [42949596.610000] Ending clean XFS mount for filesystem: sda6
> debian:~# ls /mnt
> ls: reading directory /mnt: Structure needs cleaning
> debian:~# dmesg | tail -n 16
> [42949596.610000] Ending clean XFS mount for filesystem: sda6
> [42949619.790000] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 04 3d 1b fa  XFSB.........=..
> [42949619.800000] Filesystem "sda6": XFS internal error xfs_da_do_buf(2) at line 2107 of file fs/xfs/xfs_da_btree.c.  Caller 0xbf148b44
> [42949619.820000] [<c002a370>] (dump_stack+0x0/0x14) from [<bf154968>] (xfs_error_report+0x4c/0x5c [xfs])
> [42949619.820000] [<bf15491c>] (xfs_error_report+0x0/0x5c [xfs]) from [<bf1549d4>] (xfs_corruption_error+0x5c/0x68 [xfs])
> [42949619.830000]  r4:c7914400
> [42949619.840000] [<bf154978>] (xfs_corruption_error+0x0/0x68 [xfs]) from [<bf1489b8>] (xfs_da_do_buf+0x554/0x654 [xfs])
> [42949619.850000]  r6:bf148b44 r5:00000000 r4:c7073418
> [42949619.850000] [<bf148464>] (xfs_da_do_buf+0x0/0x654 [xfs]) from [<bf148b44>] (xfs_da_read_buf+0x34/0x3c [xfs])
> [42949619.860000] [<bf148b10>] (xfs_da_read_buf+0x0/0x3c [xfs]) from [<bf14edec>] (xfs_dir2_leaf_getdents+0x480/0x8b4 [xfs])
> [42949619.880000] [<bf14e96c>] (xfs_dir2_leaf_getdents+0x0/0x8b4 [xfs]) from [<bf14b07c>] (xfs_readdir+0xcc/0xe0 [xfs])
> [42949619.890000] [<bf14afb0>] (xfs_readdir+0x0/0xe0 [xfs]) from [<bf18140c>] (xfs_file_readdir+0x144/0x194 [xfs])
> [42949619.900000] [<bf1812c8>] (xfs_file_readdir+0x0/0x194 [xfs]) from [<c009ffb0>] (vfs_readdir+0x84/0xb8)
> [42949619.910000] [<c009ff2c>] (vfs_readdir+0x0/0xb8) from [<c00a0050>] (sys_getdents64+0x6c/0xc0)
> [42949619.920000] [<c009ffe4>] (sys_getdents64+0x0/0xc0) from [<c0025bc0>] (ret_fast_syscall+0x0/0x3c)
> [42949619.930000]  r7:000000d9 r6:0002a01c r5:0002a030 r4:00000000
> debian:~#
> 
