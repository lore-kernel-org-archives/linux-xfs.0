Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 793A47F61
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 15:29:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 055EAAC002
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 13:29:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TTD4hxhZADApKyqO for <xfs@oss.sgi.com>;
	Thu, 11 Jun 2015 13:29:06 -0700 (PDT)
Message-ID: <5579EF91.4000109@sandeen.net>
Date: Thu, 11 Jun 2015 15:29:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
References: <5579296A.8010208@skylable.com>	<20150611151620.GB59168@bfoster.bfoster>	<5579A904.3020204@skylable.com>	<5579AE85.5080203@sandeen.net>	<5579B034.4070503@sandeen.net>
	<5579B804.9050707@skylable.com> <5579EA91.3090707@sandeen.net>
In-Reply-To: <5579EA91.3090707@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?windows-1252?Q?T=F6r=F6k_Edwin?= <edwin@skylable.com>, Brian Foster <bfoster@redhat.com>
Cc: Christopher Squires <christopher.squires@hgst.com>, Wayne Burri <wayne.burri@hgst.com>, Luca Gibelli <luca@skylable.com>, xfs@oss.sgi.com

On 6/11/15 3:07 PM, Eric Sandeen wrote:
> On 6/11/15 11:32 AM, T=F6r=F6k Edwin wrote:
> =

>> All commands below were run on armv7, and unmounted, the files from
>> /tmp copied over to x86-64, gzipped and uploaded, they were never
>> mounted on x86-64:
>>
>> # dd if=3D/dev/zero of=3D/tmp/xfs2.test bs=3D1M count=3D40
>> 40+0 records in
>> 40+0 records out
>> 41943040 bytes (42 MB) copied, 0.419997 s, 99.9 MB/s
>> # mkfs.xfs /tmp/xfs2.test
>> meta-data=3D/tmp/xfs2.test         isize=3D256    agcount=3D2, agsize=3D=
5120 blks
>>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D0
>> data     =3D                       bsize=3D4096   blocks=3D10240, imaxpc=
t=3D25
>>          =3D                       sunit=3D0      swidth=3D0 blks
>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
>> log      =3Dinternal log           bsize=3D4096   blocks=3D1200, version=
=3D2
>>          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-c=
ount=3D1
>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
>> # cp /tmp/xfs2.test /tmp/xfs2.test.orig
>> # umount /export/dfs
>> # mount -o loop -t xfs /tmp/xfs2.test /export/dfs
>> # mkdir /export/dfs/a
>> # sxadm node --new --batch /export/dfs/a/b
>> # ls /export/dfs/a/b
>> ls: reading directory /export/dfs/a/b: Structure needs cleaning
> =

> ok, so dir a/b/ is inode 150400
> =

> # ls -id mnt/a/b
> 150400 mnt/a/b
> =

> xfs_db> inode 150400
> xfs_db> p
> ...
> core.format =3D 2 (extents)
> ...
> u.bmx[0-2] =3D [startoff,startblock,blockcount,extentflag] 0:[0,9420,1,0]=
 1:[1,9553,1,0] 2:[8388608,9489,1,0]
> =

> so those are the blocks it should be reading as directory data; somehow i=
t's finding a superblock instead (?!)
> =

> None of those physical blocks are particularly interesting; 9420, 9553, 9=
489 - nothing that could/should be weirdly shifted or overflowed or bit-fli=
pped to read block 0, AFAICT.
> =

> The hexdump below has superblock magic, and this filesystem has only 2 su=
perblocks, at fs block 0 and fs block 8192.  Nothing really in common with =
the 3 directory blocks above.
> =

>> # umount /export/dfs
>> # cp /tmp/xfs2.test /tmp/xfs2.test.corrupted
>> # dmesg >/tmp/dmesg
>> # exit
>>
>> the latest corruption message from dmesg:
>> [4744604.870000] XFS (loop0): Mounting Filesystem
>> [4744604.900000] XFS (loop0): Ending clean mount
>> [4745016.610000] dc61e000: 58 46 53 42 00 00 10 00 00 00 00 00 00 00 28 =
00  XFSB..........(.
>> [4745016.620000] dc61e010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00  ................
>> [4745016.630000] dc61e020: 64 23 d2 06 32 2e 4c 20 82 6e f0 36 a7 d9 54 =
f9  d#..2.L .n.6..T.
>> [4745016.640000] dc61e030: 00 00 00 00 00 00 20 04 00 00 00 00 00 00 00 =
80  ...... .........
>> [4745016.640000] XFS (loop0): Internal error xfs_dir3_data_read_verify a=
t line 274 of file fs/xfs/xfs_dir2_data.c.  Caller 0xc01c1528
>> [4745016.650000] CPU: 0 PID: 37 Comm: kworker/0:1H Not tainted 3.14.3-00=
088-g7651c68 #24
>> [4745016.650000] Workqueue: xfslogd xfs_buf_iodone_work
>> [4745016.650000] [<c0013948>] (unwind_backtrace) from [<c0011058>] (show=
_stack+0x10/0x14)
>> [4745016.650000] [<c0011058>] (show_stack) from [<c01c3dc4>] (xfs_corrup=
tion_error+0x54/0x70)
>> [4745016.650000] [<c01c3dc4>] (xfs_corruption_error) from [<c01f7854>] (=
xfs_dir3_data_read_verify+0x60/0xd0)
>> [4745016.650000] [<c01f7854>] (xfs_dir3_data_read_verify) from [<c01c152=
8>] (xfs_buf_iodone_work+0x7c/0x94)
>> [4745016.650000] [<c01c1528>] (xfs_buf_iodone_work) from [<c00309f0>] (p=
rocess_one_work+0xf4/0x32c)
>> [4745016.650000] [<c00309f0>] (process_one_work) from [<c0030fb4>] (work=
er_thread+0x10c/0x388)
>> [4745016.650000] [<c0030fb4>] (worker_thread) from [<c0035e10>] (kthread=
+0xbc/0xd8)
>> [4745016.650000] [<c0035e10>] (kthread) from [<c000e8f8>] (ret_from_fork=
+0x14/0x3c)
>> [4745016.650000] XFS (loop0): Corruption detected. Unmount and run xfs_r=
epair
>> [4745016.650000] XFS (loop0): metadata I/O error: block 0xa000 ("xfs_tra=
ns_read_buf_map") error 117 numblks 8
> =

> ok, block 0xA000 (in sectors) is sector 40960...
> =

> xfs_db> daddr 40960
> xfs_db> fsblock =

> current fsblock is 8192
> xfs_db> type text
> xfs_db> p
> 000:  58 46 53 42 00 00 10 00 00 00 00 00 00 00 28 00  XFSB............
> 010:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 020:  64 23 d2 06 32 2e 4c 20 82 6e f0 36 a7 d9 54 f9  d...2.L..n.6..T.
> =

> ...
> =

> Right, so it's reading the 2nd superblock in xfs_dir3_data_read_verify.  =
Huh?
> (I could have imagined some weird scenario where we read block 0, but 819=
2?
> Very strange).
> =

> Hm, I don't think this can be readahead, it'd not get to this verifier AF=
AICT.
> =

> Given that the image is enough to reproduce via just mount; ls - we shoul=
d be
> able to reproduce this, given the right hardware, and get to the bottom o=
f it.

One other thing that might help:

# trace-cmd record -e xfs\* &
# <mount the image and do the ls test>
# kill %1
# trace-cmd report > trace_report.txt

and provide that info along w/ the dmesg when it fails.
(I assume it's the same, but just to be sure)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
