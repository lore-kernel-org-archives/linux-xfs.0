Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0CD527CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 16:34:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF94730404E
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 14:34:01 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id uZcSdCyo1LVMxPGg for <xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 14:34:00 -0800 (PST)
Message-ID: <512D3856.5050305@sandeen.net>
Date: Tue, 26 Feb 2013 16:33:58 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Read corruption on ARM
References: <CA+AKrqBQ=VG0oVsai+agywDKRgO9cG9AvT6mCTSZxKO3Si5Aiw@mail.gmail.com>
In-Reply-To: <CA+AKrqBQ=VG0oVsai+agywDKRgO9cG9AvT6mCTSZxKO3Si5Aiw@mail.gmail.com>
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
To: Jason Detring <detringj@gmail.com>
Cc: xfs@oss.sgi.com

On 2/26/13 3:58 PM, Jason Detring wrote:
> Hello list,
> 
> I'm seeing filesystem read corruption on my NAS box.
> 
> My machine is an ARMv5 unit; this guy here:
>    <http://buffalo.nas-central.org/wiki/Category:LSPro>
> The hard disk is a Seagate 2TB ST32000644NS enterprise drive on the
> SoC's SATA controller.
> The unit is on a UPS and almost never sees unclean stops.
> 
> # xfs_info /dev/sda4
> meta-data=/dev/sda4              isize=256    agcount=4, agsize=121469473 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=485877892, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=237245, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> This is a "from zero" clean installation since the original HDD was lost,
> so the original factory firmware is gone.  It runs Slackware ARM (-current) now.
> The majority of the disk, 1.9T, is an unmanaged XFS mass storage partition.
> The file system was created mid-2010 by then-current tools and kernels.
> The remainder is boot, OS, /home, and scratch on ext3.
> Mass storage is always mounted ro,noatime on system startup,
> then remounted rw,noatime when I am ready to start performing operations.
> Write caching is disabled on the HDD as part of OS startup,
> usually after ro mount but before rw.
> 
> I am currently running an unpatched, vanilla 3.7.9 kernel, though this
> corruption has been going on for over a year across many quarterly
> kernel releases.
> I had been working around it, but it's just now become irritating enough for
> me to look into it.  The other unresolved ARM report from about a month ago
> was enough to prod me into action. :-)
> 
> 
> The error seems to be triggered on some directory or file lookups, but not all.
> So, some files and directores can be opened in regular userspace or via NFS,
> but others are inaccessible.  This is not one or two files; it is
> often 1/4 to 1/3 of
> the entire file system.
> Each misread item triggers a backtrace in the kernel log similiar to this:
> 
> [  465.441259] c6a59000: 58 46 53 42 00 00 10 00 00 00 00 00 1c f5 e8
> 84  XFSB............
> [  465.449461] XFS (sda4): Internal error xfs_da_do_buf(2) at line
> 2192 of file fs/xfs/xfs_da_btree.c.  Caller 0xbf05de4c
> [  465.449461]
> [  465.461982] [<c001f0f4>] (unwind_backtrace+0x0/0x12c) from
> [<bf029ff0>] (xfs_corruption_error+0x58/0x74 [xfs])
> [  465.462606] [<bf029ff0>] (xfs_corruption_error+0x58/0x74 [xfs])
> from [<bf0588fc>] (xfs_da_read_buf+0x134/0x1b0 [xfs])
> [  465.463384] [<bf0588fc>] (xfs_da_read_buf+0x134/0x1b0 [xfs]) from
> [<bf05de4c>] (xfs_dir2_leaf_readbuf+0x3a4/0x5f4 [xfs])
> [  465.464230] [<bf05de4c>] (xfs_dir2_leaf_readbuf+0x3a4/0x5f4 [xfs])
> from [<bf05e574>] (xfs_dir2_leaf_getdents+0xfc/0x3cc [xfs])
> [  465.465016] [<bf05e574>] (xfs_dir2_leaf_getdents+0xfc/0x3cc [xfs])
> from [<bf05aaec>] (xfs_readdir+0xc4/0xd0 [xfs])
> [  465.465641] [<bf05aaec>] (xfs_readdir+0xc4/0xd0 [xfs]) from
> [<bf02ac08>] (xfs_file_readdir+0x44/0x54 [xfs])
> [  465.465919] [<bf02ac08>] (xfs_file_readdir+0x44/0x54 [xfs]) from
> [<c00c9644>] (vfs_readdir+0x7c/0xac)
> [  465.465979] [<c00c9644>] (vfs_readdir+0x7c/0xac) from [<c00c9810>]
> (sys_getdents64+0x64/0xcc)
> [  465.466035] [<c00c9810>] (sys_getdents64+0x64/0xcc) from
> [<c0019080>] (ret_fast_syscall+0x0/0x2c)
> [  465.466066] XFS (sda4): Corruption detected. Unmount and run xfs_repair
> 
> I've run xfs_repair offline on the hardware itself, but the tool never
> finds problems.
> Removing the disk from the NAS and mounting it in a desktop always
> shows a clean, readable filesystem.
> 
> 
> This also seems to impact the Raspberry Pi.  Below shows a 256 MB test
> case filesystem.
> The filesystem was created on an x86-64 box by mkfs.xfs 3.1.8 and
> populated by kernel 3.6.9.
> This failure report is Linux 3.6.11-g89caf39 built by GCC 4.7.2 from
>    <https://github.com/raspberrypi/linux/commits/rpi-3.6.y>
> The problem appears to be tied to the filesystem, not the media,
> since both an external USB reader and a loopback-mounted image on the
> unit's main SD media show the same backtrace.  The loopback image was
> captured on other hardware, then copied onto the RPi via network.
> 
> # xfs_info /dev/sdb1
> meta-data=/dev/sdb1              isize=256    agcount=4, agsize=15413 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=61651, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=1200, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> [   90.638514] XFS (sdb1): Mounting Filesystem
> [   92.154824] XFS (sdb1): Ending clean mount
> [   99.010151] db027000: 58 46 53 42 00 00 10 00 00 00 00 00 00 00 f0
> d3  XFSB............
> [   99.018213] XFS (sdb1): Internal error xfs_da_do_buf(2) at line
> 2192 of file fs/xfs/xfs_da_btree.c.  Caller 0xbf1448e4

So this came out of xfs_da_read_buf(), and it thought it was reading
metadata but got something it didn't recognize.

The hex up there shows that it got what looks like xfs superblock
magic.

> [   99.018213]
> [   99.030528] Backtrace:
> [   99.030605] [<c001c1f8>] (dump_backtrace+0x0/0x10c) from
> [<c0381244>] (dump_stack+0x18/0x1c)
> [   99.030653]  r6:bf171e38 r5:bf171e38 r4:bf171dd4 r3:dce6ac40
> [   99.030998] [<c038122c>] (dump_stack+0x0/0x1c) from [<bf1105f0>]
> (xfs_error_report+0x5c/0x68 [xfs])
> [   99.031329] [<bf110594>] (xfs_error_report+0x0/0x68 [xfs]) from
> [<bf110658>] (xfs_corruption_error+0x5c/0x78 [xfs])
> [   99.031346]  r5:00000001 r4:c1abf800
> [   99.031784] [<bf1105fc>] (xfs_corruption_error+0x0/0x78 [xfs]) from
> [<bf13fa58>] (xfs_da_read_buf+0x160/0x194 [xfs])
> [   99.031800]  r6:58465342 r5:dcdd9d80 r4:00000075
> [   99.032311] [<bf13f8f8>] (xfs_da_read_buf+0x0/0x194 [xfs]) from
> [<bf1448e4>] (xfs_dir2_leaf_readbuf+0x22c/0x628 [xfs])
> [   99.032822] [<bf1446b8>] (xfs_dir2_leaf_readbuf+0x0/0x628 [xfs])

when reading a leaf format directory

> from [<bf1451ac>] (xfs_dir2_leaf_getdents+0x134/0x3d4 [xfs])
> [   99.033326] [<bf145078>] (xfs_dir2_leaf_getdents+0x0/0x3d4 [xfs])
> from [<bf141a44>] (xfs_readdir+0xdc/0xe4 [xfs])
> [   99.033742] [<bf141968>] (xfs_readdir+0x0/0xe4 [xfs]) from
> [<bf111398>] (xfs_file_readdir+0x4c/0x5c [xfs])
> [   99.033939] [<bf11134c>] (xfs_file_readdir+0x0/0x5c [xfs]) from
> [<c00f1874>] (vfs_readdir+0xa0/0xc4)
> [   99.033954]  r7:dcdd9f78 r6:c00f158c r5:00000000 r4:dcf8aee0
> [   99.034004] [<c00f17d4>] (vfs_readdir+0x0/0xc4) from [<c00f1a50>]
> (sys_getdents64+0x68/0xd8)
> [   99.034052] [<c00f19e8>] (sys_getdents64+0x0/0xd8) from
> [<c0018900>] (ret_fast_syscall+0x0/0x30)
> [   99.034066]  r7:000000d9 r6:0068ff58 r5:006882a8 r4:00000000
> [   99.034101] XFS (sdb1): Corruption detected. Unmount and run xfs_repair
> 
> # xfs_info loop/
> meta-data=/dev/loop0             isize=256    agcount=4, agsize=15413 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=61651, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=1200, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> [ 1347.630983] XFS (loop0): Mounting Filesystem
> [ 1347.745898] XFS (loop0): Ending clean mount
> [ 1351.743284] db273000: 58 46 53 42 00 00 10 00 00 00 00 00 00 00 f0
> d3  XFSB............
> [ 1351.751716] XFS (loop0): Internal error xfs_da_do_buf(2) at line
> 2192 of file fs/xfs/xfs_da_btree.c.  Caller 0xbf1448e4
> [ 1351.751716]
> [ 1351.764072] Backtrace:
> [ 1351.764148] [<c001c1f8>] (dump_backtrace+0x0/0x10c) from
> [<c0381244>] (dump_stack+0x18/0x1c)
> [ 1351.764204]  r6:bf171e38 r5:bf171e38 r4:bf171dd4 r3:c189ac40
> [ 1351.764552] [<c038122c>] (dump_stack+0x0/0x1c) from [<bf1105f0>]
> (xfs_error_report+0x5c/0x68 [xfs])
> [ 1351.764924] [<bf110594>] (xfs_error_report+0x0/0x68 [xfs]) from
> [<bf110658>] (xfs_corruption_error+0x5c/0x78 [xfs])
> [ 1351.764945]  r5:00000001 r4:c1968000
> [ 1351.765386] [<bf1105fc>] (xfs_corruption_error+0x0/0x78 [xfs]) from
> [<bf13fa58>] (xfs_da_read_buf+0x160/0x194 [xfs])
> [ 1351.765403]  r6:58465342 r5:dce25d80 r4:00000075
> [ 1351.765920] [<bf13f8f8>] (xfs_da_read_buf+0x0/0x194 [xfs]) from
> [<bf1448e4>] (xfs_dir2_leaf_readbuf+0x22c/0x628 [xfs])
> [ 1351.766432] [<bf1446b8>] (xfs_dir2_leaf_readbuf+0x0/0x628 [xfs])
> from [<bf1451ac>] (xfs_dir2_leaf_getdents+0x134/0x3d4 [xfs])
> [ 1351.766942] [<bf145078>] (xfs_dir2_leaf_getdents+0x0/0x3d4 [xfs])
> from [<bf141a44>] (xfs_readdir+0xdc/0xe4 [xfs])
> [ 1351.767363] [<bf141968>] (xfs_readdir+0x0/0xe4 [xfs]) from
> [<bf111398>] (xfs_file_readdir+0x4c/0x5c [xfs])
> [ 1351.767557] [<bf11134c>] (xfs_file_readdir+0x0/0x5c [xfs]) from
> [<c00f1874>] (vfs_readdir+0xa0/0xc4)
> [ 1351.767574]  r7:dce25f78 r6:c00f158c r5:00000000 r4:c18e57e0
> [ 1351.767622] [<c00f17d4>] (vfs_readdir+0x0/0xc4) from [<c00f1a50>]
> (sys_getdents64+0x68/0xd8)
> [ 1351.767670] [<c00f19e8>] (sys_getdents64+0x0/0xd8) from
> [<c0018900>] (ret_fast_syscall+0x0/0x30)
> [ 1351.767683]  r7:000000d9 r6:00642f58 r5:0063b2a8 r4:00000000
> [ 1351.767719] XFS (loop0): Corruption detected. Unmount and run xfs_repair
> 
> 
> 
> Here's the kicker:  All this seems to happen only if xfs.ko is
> crosscompiled with GCC 4.6 or 4.7.

urk!  That is a kicker.

> A module (just the module, the rest of kernel can be built with
> anything) compiled with
> cross-GCC 4.4.1, 4.5.4, or curiously 4.8 (20130224) has no issue at all.
> I've kept an old 2009 Sourcery G++ (4.4.1) Lite toolchain around just
> for building kernels.
> I'd really like to retire it, but I'm a little afraid this is going to
> recur in newer compilers.

Maybe you can provide an xfs.ko built with each (for the same kernel)
with debug info, and we can compare the disassembly?

> Is there something in the path lookup routine that is disagreeable to
> GCCs targeting ARM?

at one point there were some alignment issues that went on, but hat
was for old ABI, etc.  I'm not aware of anything right now.

> Any other ideas on what could be happening?

Since you got xfs superblock magic, I wonder if you read block 0
rather than the intended block, due to $SOMETHING going wrong...

Enabling the trace_xfs_da_btree_corrupt tracepoint might yield more
info, can you do that?

I think it's:

# trace-cmd -e xfs_da_btree_corrupt &
# <do your dir read>
# fg
# ^C (ctrl-c trace-cmd)
# trace-cmd report

We might get more info about the buffer in question that way.

-Eric

> Thanks,
> Jason
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
