Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F2ED57F59
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 20:25:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E147E304053
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 18:25:41 -0700 (PDT)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com
	[209.85.216.171]) by cuda.sgi.com with ESMTP id
	xH8AIGh47xAFdsGp (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 18:25:39 -0700 (PDT)
Received: by mail-qc0-f171.google.com with SMTP id x3so18147387qcv.2
	for <xfs@oss.sgi.com>; Tue, 09 Sep 2014 18:25:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <540FA586.9090308@mygrande.net>
References: <540F1B01.3020700@mygrande.net> <20140909220645.GH20518@dastard>
	<540FA586.9090308@mygrande.net>
Date: Tue, 9 Sep 2014 21:25:37 -0400
Message-ID: <CAA43vkVYX+zJQcoTH2iSX7rS9B1D=mnTeyS0QqP+fbKxVY0YZA@mail.gmail.com>
Subject: Re: Corrupted files
From: Sean Caron <scaron@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4329095177125380481=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Leslie Rhorer <lrhorer@mygrande.net>, Sean Caron <scaron@umich.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4329095177125380481==
Content-Type: multipart/alternative; boundary=047d7bdca458e10c0d0502abed22

--047d7bdca458e10c0d0502abed22
Content-Type: text/plain; charset=UTF-8

Hi Leslie,

You really don't want to be running "green" anything in an array... that is
a ticking time bomb just waiting to go off... let me tell you... At my
installation, a predecessor had procured a large number of green drives
because they were very inexpensive and regrets were had by all. Lousy
performance, lots of spurious ejection/RAID gremlins and the failure rate
on the WDC Greens is just appalling...

BBWC stands for Battery Backed Write Cache; this is a feature of hardware
RAID cards; it is just like it says on the tin; a bit (usually half a gig,
or a gig, or two...) of nonvolatile cache that retains writes to the array
in case of power failure, etc. If you have BBWC enabled but your battery is
dead, bad things can happen. Not applicable for JBOD software RAID.

I hold firm to my beliefs on xfs_repair :) As I say, you'll see a variety
of opinions here.

Best,

Sean




On Tue, Sep 9, 2014 at 9:12 PM, Leslie Rhorer <lrhorer@mygrande.net> wrote:

> On 9/9/2014 5:06 PM, Dave Chinner wrote:
>
>> Fristly, more infomration is required, namely versions and actual
>> error messages:
>>
>
>         Indubitably:
>
> RAID-Server:/# xfs_repair -V
> xfs_repair version 3.1.7
> RAID-Server:/# uname -r
> 3.2.0-4-amd64
>
> 4.0 GHz FX-8350 eight core processor
>
> RAID-Server:/# cat /proc/meminfo /proc/mounts /proc/partitions
> MemTotal:        8099916 kB
> MemFree:         5786420 kB
> Buffers:          112684 kB
> Cached:           457020 kB
> SwapCached:            0 kB
> Active:           521800 kB
> Inactive:         457268 kB
> Active(anon):     276648 kB
> Inactive(anon):   140180 kB
> Active(file):     245152 kB
> Inactive(file):   317088 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:      12623740 kB
> SwapFree:       12623740 kB
> Dirty:                20 kB
> Writeback:             0 kB
> AnonPages:        409488 kB
> Mapped:            47576 kB
> Shmem:              7464 kB
> Slab:             197100 kB
> SReclaimable:     112644 kB
> SUnreclaim:        84456 kB
> KernelStack:        2560 kB
> PageTables:         8468 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    16673696 kB
> Committed_AS:    1010172 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      339140 kB
> VmallocChunk:   34359395308 kB
> HardwareCorrupted:     0 kB
> AnonHugePages:         0 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:       65532 kB
> DirectMap2M:     5120000 kB
> DirectMap1G:     3145728 kB
> rootfs / rootfs rw 0 0
> sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
> proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
> udev /dev devtmpfs rw,relatime,size=10240k,nr_inodes=1002653,mode=755 0 0
> devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000
> 0 0
> tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=809992k,mode=755 0 0
> /dev/disk/by-uuid/fa5c404a-bfcb-43de-87ed-e671fda1ba99 / ext4
> rw,relatime,errors=remount-ro,user_xattr,barrier=1,data=ordered 0 0
> tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
> tmpfs /run/shm tmpfs rw,nosuid,nodev,noexec,relatime,size=4144720k 0 0
> /dev/md1 /boot ext2 rw,relatime,errors=continue 0 0
> rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
> Backup:/Backup /Backup nfs rw,relatime,vers=3,rsize=
> 524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,
> retrans=2,sec=sys,mountaddr=192.168.1.51,mountvers=3,
> mountport=39597,mountproto=tcp,local_lock=none,addr=192.168.1.51 0 0
> Backup:/var/www /var/www/backup nfs rw,relatime,vers=3,rsize=
> 524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,
> retrans=2,sec=sys,mountaddr=192.168.1.51,mountvers=3,
> mountport=39597,mountproto=tcp,local_lock=none,addr=192.168.1.51 0 0
> /dev/md0 /RAID xfs rw,relatime,attr2,delaylog,sunit=2048,swidth=12288,noquota
> 0 0
> major minor  #blocks  name
>
>    8        0  125034840 sda
>    8        1      96256 sda1
>    8        2  112305152 sda2
>    8        3   12632064 sda3
>    8       16 125034840 sdb
>    8       17      96256 sdb1
>    8       18  112305152 sdb2
>    8       19   12632064 sdb3
>    8       48 3907018584 sdd
>    8       32 3907018584 sdc
>    8       64 1465138584 sde
>    8       80 1465138584 sdf
>    8       96 1465138584 sdg
>    8      112 3907018584 sdh
>    8      128 3907018584 sdi
>    8      144 3907018584 sdj
>    8      160 3907018584 sdk
>    9        1      96192 md1
>    9        2  112239488 md2
>    9        3   12623744 md3
>    9        0 23441319936 md0
>    9       10 4395021312 md10
>
> RAID-Server:/# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1] [raid0]
> md10 : active raid0 sdf[0] sde[2] sdg[1]
>       4395021312 blocks super 1.2 512k chunks
>
> md0 : active raid6 md10[12] sdc[13] sdk[10] sdj[11] sdi[15] sdh[8] sdd[9]
>       23441319936 blocks super 1.2 level 6, 1024k chunk, algorithm 2 [8/7]
> [UUU_UUUU]
>       bitmap: 29/30 pages [116KB], 65536KB chunk
>
> md3 : active (auto-read-only) raid1 sda3[0] sdb3[1]
>       12623744 blocks super 1.2 [3/2] [UU_]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
>
> md2 : active raid1 sda2[0] sdb2[1]
>       112239488 blocks super 1.2 [3/2] [UU_]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
>
> md1 : active raid1 sda1[0] sdb1[1]
>       96192 blocks [3/2] [UU_]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
>
> unused devices: <none>
>
>         Six of the drives are 4T spindles (a mixture of makes and
> models).  The three drives comprising MD10 are WD 1.5T green drives.  These
> are in place to take over the function of one of the kicked 4T drives.
> Md1, 2, and 3 are not data drives and are not suffering any issue.
>
>         I'm not sure what is meant by "write cache status" in this
> context. The machine has been rebooted more than once during recovery and
> the FS has been umounted and xfs_repair run several times.
>
>         I don't know for what the acronym BBWC stands.
>
> RAID-Server:/# xfs_info /dev/md0
> meta-data=/dev/md0               isize=256    agcount=43, agsize=137356288
> blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=5860329984, imaxpct=5
>          =                       sunit=256    swidth=1536 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
>         The system performs just fine, other than the aforementioned, with
> loads in excess of 3Gbps.  That is internal only.  The LAN link is ony
> 1Gbps, so no external request exceeds about 950Mbps.
>
>  http://xfs.org/index.php/XFS_FAQ#Q:_What_information_
>> should_I_include_when_reporting_a_problem.3F
>>
>> dmesg, in particular, should tell use what the corruption being
>> encountered is when stat fails.
>>
>
> RAID-Server:/# ls "/RAID/DVD/Big Sleep, The (1945)/VIDEO_TS/VTS_01_1.VOB"
> ls: cannot access /RAID/DVD/Big Sleep, The (1945)/VIDEO_TS/VTS_01_1.VOB:
> Structure needs cleaning
> RAID-Server:/# dmesg | tail -n 30
> ...
> [192173.363981] XFS (md0): corrupt dinode 41006, extent total = 1, nblocks
> = 0.
> [192173.363988] ffff8802338b8e00: 49 4e 81 b6 02 02 00 00 00 00 03 e8 00
> 00 03 e8  IN..............
> [192173.363996] XFS (md0): Internal error xfs_iformat(1) at line 319 of
> file /build/linux-eKuxrT/linux-3.2.60/fs/xfs/xfs_inode.c.  Caller
> 0xffffffffa0509318
> [192173.363999]
> [192173.364062] Pid: 10813, comm: ls Not tainted 3.2.0-4-amd64 #1 Debian
> 3.2.60-1+deb7u3
> [192173.364065] Call Trace:
> [192173.364097]  [<ffffffffa04d3731>] ? xfs_corruption_error+0x54/0x6f
> [xfs]
> [192173.364134]  [<ffffffffa0509318>] ? xfs_iread+0x9f/0x177 [xfs]
> [192173.364170]  [<ffffffffa0508efa>] ? xfs_iformat+0xe3/0x462 [xfs]
> [192173.364204]  [<ffffffffa0509318>] ? xfs_iread+0x9f/0x177 [xfs]
> [192173.364240]  [<ffffffffa0509318>] ? xfs_iread+0x9f/0x177 [xfs]
> [192173.364268]  [<ffffffffa04d6ebe>] ? xfs_iget+0x37c/0x56c [xfs]
> [192173.364300]  [<ffffffffa04e13b4>] ? xfs_lookup+0xa4/0xd3 [xfs]
> [192173.364328]  [<ffffffffa04d9e5a>] ? xfs_vn_lookup+0x3f/0x7e [xfs]
> [192173.364344]  [<ffffffff81102de9>] ? d_alloc_and_lookup+0x3a/0x60
> [192173.364357]  [<ffffffff8110388d>] ? walk_component+0x219/0x406
> [192173.364370]  [<ffffffff81104721>] ? path_lookupat+0x7c/0x2bd
> [192173.364383]  [<ffffffff81036628>] ? should_resched+0x5/0x23
> [192173.364396]  [<ffffffff8134f144>] ? _cond_resched+0x7/0x1c
> [192173.364408]  [<ffffffff8110497e>] ? do_path_lookup+0x1c/0x87
> [192173.364420]  [<ffffffff81106407>] ? user_path_at_empty+0x47/0x7b
> [192173.364434]  [<ffffffff813533d8>] ? do_page_fault+0x30a/0x345
> [192173.364448]  [<ffffffff810d6a04>] ? mmap_region+0x353/0x44a
> [192173.364460]  [<ffffffff810fe45a>] ? vfs_fstatat+0x32/0x60
> [192173.364471]  [<ffffffff810fe590>] ? sys_newstat+0x12/0x2b
> [192173.364483]  [<ffffffff813509f5>] ? page_fault+0x25/0x30
> [192173.364495]  [<ffffffff81355452>] ? system_call_fastpath+0x16/0x1b
> [192173.364503] XFS (md0): Corruption detected. Unmount and run xfs_repair
>
>         That last line, by the way, is why I ran umount and xfs_repair.
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--047d7bdca458e10c0d0502abed22
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Leslie,<div><br></div><div>You really don&#39;t want to=
 be running &quot;green&quot; anything in an array... that is a ticking tim=
e bomb just waiting to go off... let me tell you... At my installation, a p=
redecessor had procured a large number of green drives because they were ve=
ry inexpensive and regrets were had by all. Lousy performance, lots of spur=
ious ejection/RAID gremlins and the failure rate on the WDC Greens is just =
appalling...</div><div><br></div><div>BBWC stands for Battery Backed Write =
Cache; this is a feature of hardware RAID cards; it is just like it says on=
 the tin; a bit (usually half a gig, or a gig, or two...) of nonvolatile ca=
che that retains writes to the array in case of power failure, etc. If you =
have BBWC enabled but your battery is dead, bad things can happen. Not appl=
icable for JBOD software RAID.</div><div><br></div><div>I hold firm to my b=
eliefs on xfs_repair :) As I say, you&#39;ll see a variety of opinions here=
.=C2=A0</div><div><br></div><div>Best,</div><div><br></div><div>Sean</div><=
div><br></div><div><br></div><div><br></div></div><div class=3D"gmail_extra=
"><br><div class=3D"gmail_quote">On Tue, Sep 9, 2014 at 9:12 PM, Leslie Rho=
rer <span dir=3D"ltr">&lt;<a href=3D"mailto:lrhorer@mygrande.net" target=3D=
"_blank">lrhorer@mygrande.net</a>&gt;</span> wrote:<br><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex"><span class=3D"">On 9/9/2014 5:06 PM, Dave Chinner wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Fristly, more infomration is required, namely versions and actual<br>
error messages:<br>
</blockquote>
<br></span>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Indubitably:<br>
<br>
RAID-Server:/# xfs_repair -V<br>
xfs_repair version 3.1.7<br>
RAID-Server:/# uname -r<br>
3.2.0-4-amd64<br>
<br>
4.0 GHz FX-8350 eight core processor<br>
<br>
RAID-Server:/# cat /proc/meminfo /proc/mounts /proc/partitions<br>
MemTotal:=C2=A0 =C2=A0 =C2=A0 =C2=A0 8099916 kB<br>
MemFree:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A05786420 kB<br>
Buffers:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 112684 kB<br>
Cached:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0457020 kB<br>
SwapCached:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 kB<br>
Active:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0521800 kB<br>
Inactive:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0457268 kB<br>
Active(anon):=C2=A0 =C2=A0 =C2=A0276648 kB<br>
Inactive(anon):=C2=A0 =C2=A0140180 kB<br>
Active(file):=C2=A0 =C2=A0 =C2=A0245152 kB<br>
Inactive(file):=C2=A0 =C2=A0317088 kB<br>
Unevictable:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 kB<br>
Mlocked:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 kB<br>
SwapTotal:=C2=A0 =C2=A0 =C2=A0 12623740 kB<br>
SwapFree:=C2=A0 =C2=A0 =C2=A0 =C2=A012623740 kB<br>
Dirty:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 20 kB<br>
Writeback:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 kB<br>
AnonPages:=C2=A0 =C2=A0 =C2=A0 =C2=A0 409488 kB<br>
Mapped:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 47576 kB<br>
Shmem:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 7464 kB<br>
Slab:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0197100 kB<br>
SReclaimable:=C2=A0 =C2=A0 =C2=A0112644 kB<br>
SUnreclaim:=C2=A0 =C2=A0 =C2=A0 =C2=A0 84456 kB<br>
KernelStack:=C2=A0 =C2=A0 =C2=A0 =C2=A0 2560 kB<br>
PageTables:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A08468 kB<br>
NFS_Unstable:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 kB<br>
Bounce:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 kB<br>
WritebackTmp:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 kB<br>
CommitLimit:=C2=A0 =C2=A0 16673696 kB<br>
Committed_AS:=C2=A0 =C2=A0 1010172 kB<br>
VmallocTotal:=C2=A0 =C2=A034359738367 kB<br>
VmallocUsed:=C2=A0 =C2=A0 =C2=A0 339140 kB<br>
VmallocChunk:=C2=A0 =C2=A034359395308 kB<br>
HardwareCorrupted:=C2=A0 =C2=A0 =C2=A00 kB<br>
AnonHugePages:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 kB<br>
HugePages_Total:=C2=A0 =C2=A0 =C2=A0 =C2=A00<br>
HugePages_Free:=C2=A0 =C2=A0 =C2=A0 =C2=A0 0<br>
HugePages_Rsvd:=C2=A0 =C2=A0 =C2=A0 =C2=A0 0<br>
HugePages_Surp:=C2=A0 =C2=A0 =C2=A0 =C2=A0 0<br>
Hugepagesize:=C2=A0 =C2=A0 =C2=A0 =C2=A02048 kB<br>
DirectMap4k:=C2=A0 =C2=A0 =C2=A0 =C2=A065532 kB<br>
DirectMap2M:=C2=A0 =C2=A0 =C2=A05120000 kB<br>
DirectMap1G:=C2=A0 =C2=A0 =C2=A03145728 kB<br>
rootfs / rootfs rw 0 0<br>
sysfs /sys sysfs rw,nosuid,nodev,noexec,<u></u>relatime 0 0<br>
proc /proc proc rw,nosuid,nodev,noexec,<u></u>relatime 0 0<br>
udev /dev devtmpfs rw,relatime,size=3D10240k,nr_<u></u>inodes=3D1002653,mod=
e=3D755 0 0<br>
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D<u></u>5,mode=3D620,=
ptmxmode=3D000 0 0<br>
tmpfs /run tmpfs rw,nosuid,noexec,relatime,<u></u>size=3D809992k,mode=3D755=
 0 0<br>
/dev/disk/by-uuid/fa5c404a-<u></u>bfcb-43de-87ed-e671fda1ba99 / ext4 rw,rel=
atime,errors=3Dremount-ro,<u></u>user_xattr,barrier=3D1,data=3D<u></u>order=
ed 0 0<br>
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,<u></u>relatime,size=3D5120k 0=
 0<br>
tmpfs /run/shm tmpfs rw,nosuid,nodev,noexec,<u></u>relatime,size=3D4144720k=
 0 0<br>
/dev/md1 /boot ext2 rw,relatime,errors=3Dcontinue 0 0<br>
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0<br>
Backup:/Backup /Backup nfs rw,relatime,vers=3D3,rsize=3D<u></u>524288,wsize=
=3D524288,namlen=3D<u></u>255,hard,proto=3Dtcp,timeo=3D600,<u></u>retrans=
=3D2,sec=3Dsys,mountaddr=3D<u></u>192.168.1.51,mountvers=3D3,<u></u>mountpo=
rt=3D39597,mountproto=3D<u></u>tcp,local_lock=3Dnone,addr=3D192.<u></u>168.=
1.51 0 0<br>
Backup:/var/www /var/www/backup nfs rw,relatime,vers=3D3,rsize=3D<u></u>524=
288,wsize=3D524288,namlen=3D<u></u>255,hard,proto=3Dtcp,timeo=3D600,<u></u>=
retrans=3D2,sec=3Dsys,mountaddr=3D<u></u>192.168.1.51,mountvers=3D3,<u></u>=
mountport=3D39597,mountproto=3D<u></u>tcp,local_lock=3Dnone,addr=3D192.<u><=
/u>168.1.51 0 0<br>
/dev/md0 /RAID xfs rw,relatime,attr2,delaylog,<u></u>sunit=3D2048,swidth=3D=
12288,<u></u>noquota 0 0<br>
major minor=C2=A0 #blocks=C2=A0 name<br>
<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A0 0=C2=A0 125034840 sda<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A0 1=C2=A0 =C2=A0 =C2=A0 96256 sda1<=
br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A0 2=C2=A0 112305152 sda2<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A0 3=C2=A0 =C2=A012632064 sda3<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"tel:16%20%20125034840" =
value=3D"+16125034840" target=3D"_blank">16  125034840</a> sdb<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A017=C2=A0 =C2=A0 =C2=A0 96256 sdb1<=
br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A018=C2=A0 112305152 sdb2<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A019=C2=A0 =C2=A012632064 sdb3<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A048 3907018584 sdd<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A032 3907018584 sdc<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A064 1465138584 sde<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A080 1465138584 sdf<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 =C2=A096 1465138584 sdg<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 112 3907018584 sdh<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 128 3907018584 sdi<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 144 3907018584 sdj<br>
=C2=A0 =C2=A08=C2=A0 =C2=A0 =C2=A0 160 3907018584 sdk<br>
=C2=A0 =C2=A09=C2=A0 =C2=A0 =C2=A0 =C2=A0 1=C2=A0 =C2=A0 =C2=A0 96192 md1<b=
r>
=C2=A0 =C2=A09=C2=A0 =C2=A0 =C2=A0 =C2=A0 2=C2=A0 112239488 md2<br>
=C2=A0 =C2=A09=C2=A0 =C2=A0 =C2=A0 =C2=A0 3=C2=A0 =C2=A012623744 md3<br>
=C2=A0 =C2=A09=C2=A0 =C2=A0 =C2=A0 =C2=A0 0 23441319936 md0<br>
=C2=A0 =C2=A09=C2=A0 =C2=A0 =C2=A0 =C2=A010 4395021312 md10<br>
<br>
RAID-Server:/# cat /proc/mdstat<br>
Personalities : [raid6] [raid5] [raid4] [raid1] [raid0]<br>
md10 : active raid0 sdf[0] sde[2] sdg[1]<br>
=C2=A0 =C2=A0 =C2=A0 4395021312 blocks super 1.2 512k chunks<br>
<br>
md0 : active raid6 md10[12] sdc[13] sdk[10] sdj[11] sdi[15] sdh[8] sdd[9]<b=
r>
=C2=A0 =C2=A0 =C2=A0 23441319936 blocks super 1.2 level 6, 1024k chunk, alg=
orithm 2 [8/7] [UUU_UUUU]<br>
=C2=A0 =C2=A0 =C2=A0 bitmap: 29/30 pages [116KB], 65536KB chunk<br>
<br>
md3 : active (auto-read-only) raid1 sda3[0] sdb3[1]<br>
=C2=A0 =C2=A0 =C2=A0 12623744 blocks super 1.2 [3/2] [UU_]<br>
=C2=A0 =C2=A0 =C2=A0 bitmap: 1/1 pages [4KB], 65536KB chunk<br>
<br>
md2 : active raid1 sda2[0] sdb2[1]<br>
=C2=A0 =C2=A0 =C2=A0 112239488 blocks super 1.2 [3/2] [UU_]<br>
=C2=A0 =C2=A0 =C2=A0 bitmap: 1/1 pages [4KB], 65536KB chunk<br>
<br>
md1 : active raid1 sda1[0] sdb1[1]<br>
=C2=A0 =C2=A0 =C2=A0 96192 blocks [3/2] [UU_]<br>
=C2=A0 =C2=A0 =C2=A0 bitmap: 1/1 pages [4KB], 65536KB chunk<br>
<br>
unused devices: &lt;none&gt;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Six of the drives are 4T spindles (a mixture of=
 makes and models).=C2=A0 The three drives comprising MD10 are WD 1.5T gree=
n drives.=C2=A0 These are in place to take over the function of one of the =
kicked 4T drives.=C2=A0 Md1, 2, and 3 are not data drives and are not suffe=
ring any issue.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 I&#39;m not sure what is meant by &quot;write c=
ache status&quot; in this context. The machine has been rebooted more than =
once during recovery and the FS has been umounted and xfs_repair run severa=
l times.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 I don&#39;t know for what the acronym BBWC stan=
ds.<br>
<br>
RAID-Server:/# xfs_info /dev/md0<br>
meta-data=3D/dev/md0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
isize=3D256=C2=A0 =C2=A0 agcount=3D43, agsize=3D137356288 blks<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sectsz=3D512=C2=A0 =C2=A0attr=
=3D2<br>
data=C2=A0 =C2=A0 =C2=A0=3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bsize=3D4096=C2=A0 =C2=A0blocks=3D586032=
9984, imaxpct=3D5<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sunit=3D256=C2=A0 =C2=A0 swidt=
h=3D1536 blks<br>
naming=C2=A0 =C2=A0=3Dversion 2=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 bsize=3D4096=C2=A0 =C2=A0ascii-ci=3D0<br>
log=C2=A0 =C2=A0 =C2=A0 =3Dinternal=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0bsize=3D4096=C2=A0 =C2=A0blocks=3D521728, version=3D2<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sectsz=3D512=C2=A0 =C2=A0sunit=
=3D8 blks, lazy-count=3D1<br>
realtime =3Dnone=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0extsz=3D4096=C2=A0 =C2=A0blocks=3D0, rtextents=3D0<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 The system performs just fine, other than the a=
forementioned, with loads in excess of 3Gbps.=C2=A0 That is internal only.=
=C2=A0 The LAN link is ony 1Gbps, so no external request exceeds about 950M=
bps.<span class=3D""><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_in=
clude_when_reporting_a_problem.3F" target=3D"_blank">http://xfs.org/index.p=
hp/XFS_<u></u>FAQ#Q:_What_information_<u></u>should_I_include_when_<u></u>r=
eporting_a_problem.3F</a><br>
<br>
dmesg, in particular, should tell use what the corruption being<br>
encountered is when stat fails.<br>
</blockquote>
<br></span>
RAID-Server:/# ls &quot;/RAID/DVD/Big Sleep, The (1945)/VIDEO_TS/VTS_01_1.V=
OB&quot;<br>
ls: cannot access /RAID/DVD/Big Sleep, The (1945)/VIDEO_TS/VTS_01_1.VOB: St=
ructure needs cleaning<br>
RAID-Server:/# dmesg | tail -n 30<br>
...<br>
[192173.363981] XFS (md0): corrupt dinode 41006, extent total =3D 1, nblock=
s =3D 0.<br>
[192173.363988] ffff8802338b8e00: 49 4e 81 b6 02 02 00 00 00 00 03 e8 00 00=
 03 e8=C2=A0 IN..............<br>
[192173.363996] XFS (md0): Internal error xfs_iformat(1) at line 319 of fil=
e /build/linux-eKuxrT/linux-3.2.<u></u>60/fs/xfs/xfs_inode.c.=C2=A0 Caller =
0xffffffffa0509318<br>
[192173.363999]<br>
[192173.364062] Pid: 10813, comm: ls Not tainted 3.2.0-4-amd64 #1 Debian 3.=
2.60-1+deb7u3<br>
[192173.364065] Call Trace:<br>
[192173.364097]=C2=A0 [&lt;ffffffffa04d3731&gt;] ? xfs_corruption_error+0x5=
4/0x6f [xfs]<br>
[192173.364134]=C2=A0 [&lt;ffffffffa0509318&gt;] ? xfs_iread+0x9f/0x177 [xf=
s]<br>
[192173.364170]=C2=A0 [&lt;ffffffffa0508efa&gt;] ? xfs_iformat+0xe3/0x462 [=
xfs]<br>
[192173.364204]=C2=A0 [&lt;ffffffffa0509318&gt;] ? xfs_iread+0x9f/0x177 [xf=
s]<br>
[192173.364240]=C2=A0 [&lt;ffffffffa0509318&gt;] ? xfs_iread+0x9f/0x177 [xf=
s]<br>
[192173.364268]=C2=A0 [&lt;ffffffffa04d6ebe&gt;] ? xfs_iget+0x37c/0x56c [xf=
s]<br>
[192173.364300]=C2=A0 [&lt;ffffffffa04e13b4&gt;] ? xfs_lookup+0xa4/0xd3 [xf=
s]<br>
[192173.364328]=C2=A0 [&lt;ffffffffa04d9e5a&gt;] ? xfs_vn_lookup+0x3f/0x7e =
[xfs]<br>
[192173.364344]=C2=A0 [&lt;ffffffff81102de9&gt;] ? d_alloc_and_lookup+0x3a/=
0x60<br>
[192173.364357]=C2=A0 [&lt;ffffffff8110388d&gt;] ? walk_component+0x219/0x4=
06<br>
[192173.364370]=C2=A0 [&lt;ffffffff81104721&gt;] ? path_lookupat+0x7c/0x2bd=
<br>
[192173.364383]=C2=A0 [&lt;ffffffff81036628&gt;] ? should_resched+0x5/0x23<=
br>
[192173.364396]=C2=A0 [&lt;ffffffff8134f144&gt;] ? _cond_resched+0x7/0x1c<b=
r>
[192173.364408]=C2=A0 [&lt;ffffffff8110497e&gt;] ? do_path_lookup+0x1c/0x87=
<br>
[192173.364420]=C2=A0 [&lt;ffffffff81106407&gt;] ? user_path_at_empty+0x47/=
0x7b<br>
[192173.364434]=C2=A0 [&lt;ffffffff813533d8&gt;] ? do_page_fault+0x30a/0x34=
5<br>
[192173.364448]=C2=A0 [&lt;ffffffff810d6a04&gt;] ? mmap_region+0x353/0x44a<=
br>
[192173.364460]=C2=A0 [&lt;ffffffff810fe45a&gt;] ? vfs_fstatat+0x32/0x60<br=
>
[192173.364471]=C2=A0 [&lt;ffffffff810fe590&gt;] ? sys_newstat+0x12/0x2b<br=
>
[192173.364483]=C2=A0 [&lt;ffffffff813509f5&gt;] ? page_fault+0x25/0x30<br>
[192173.364495]=C2=A0 [&lt;ffffffff81355452&gt;] ? system_call_fastpath+0x1=
6/0x1b<br>
[192173.364503] XFS (md0): Corruption detected. Unmount and run xfs_repair<=
br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 That last line, by the way, is why I ran umount=
 and xfs_repair.<div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
______________________________<u></u>_________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/<u></u>listinfo/xfs</a><br>
</div></div></blockquote></div><br></div>

--047d7bdca458e10c0d0502abed22--


--===============4329095177125380481==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4329095177125380481==--
