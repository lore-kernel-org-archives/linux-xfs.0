Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3IJLw8V001959 for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 14:21:59 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0F1FBF69BD
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 12:25:19 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id ZpFqjFrU6FmIYZkc
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 12:25:19 -0700 (PDT)
Received: by bwg12 with SMTP id 12so8762208bwg.26
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 12:25:18 -0700 (PDT)
MIME-Version: 1.0
From: Anisse Astier <anisse@astier.eu>
Date: Mon, 18 Apr 2011 21:24:22 +0200
Message-ID: <BANLkTikh1i3aYgXNZut+AGT-1kz=aqv-Eg@mail.gmail.com>
Subject: xfs_repair crashing (versions 3.1.4 and 3.1.5)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

(first of all, I'm not subscribed to the list, Please cc-me on all replies)

On an ARM NAS, using kernel 2.6.36.2 I managed to crash my root xfs partiti=
on.

xfs_repair cannot then repair this partition and is crashing itself.

# xfs_info  /dev/sda2
meta-data=3D/dev/sda2              isize=3D256    agcount=3D32, agsize=3D76=
15249 blks
         =3D                       sectsz=3D512   attr=3D1
data     =3D                       bsize=3D4096   blocks=3D243687968, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D1
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D0
realtime =3Dnone                   extsz=3D65536  blocks=3D0, rtextents=3D0



I did a SMART test to ensure the disk didn't have any bad block:
SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      8327       =
  -

The dmesg log (on another recovery system with kernel 2.6.36-rc2) ; I
tried to mount the system :
[ 1003.257446] XFS mounting filesystem sda2
[ 1003.301519] Starting XFS recovery on filesystem: sda2 (logdev: internal)
[ 1003.303068] XFS: bad number of regions (28024) in inode log format
[ 1003.303142] XFS: log mount/recovery failed: error 5
[ 1003.303419] XFS: log mount failed

I then had no other choice than suppressing the log with xfs_repair -L.
xfs_repair crashed, but I was able to mount the filesystem(ro), but
once I tried accessing the corrupt files, xfs would go mad:
[13717.138896] UDF-fs: No partition found (1)
[13717.202112] XFS mounting filesystem sda2
[13717.274885] Ending clean XFS mount for filesystem: sda2
[43969.970648] sshd (1039): /proc/1039/oom_adj is deprecated, please
use /proc/1039/oom_score_adj instead.
[107180.252602] Filesystem "sda2": corrupt dinode 805341224, (btree
extents).  Unmount and run xfs_repair.
[107180.252691] Filesystem "sda2": XFS internal error
xfs_bmap_read_extents(1) at line 4178 of file
/home/simon/work/upstream/lacie-orion/fs/xfs/xfs_bmap.c.  Caller
0xc03fd760
[107180.252710]
[107180.252822] [<c0241474>] (unwind_backtrace+0x0/0xf0) from
[<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4)
[107180.252902] [<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4) from
[<c03fd760>] (xfs_iread_extents+0x98/0xc4)
[107180.252972] [<c03fd760>] (xfs_iread_extents+0x98/0xc4) from
[<c03df7f8>] (xfs_bmapi+0x20c/0xf20)
[107180.253035] [<c03df7f8>] (xfs_bmapi+0x20c/0xf20) from [<c04009d0>]
(xfs_iomap+0x184/0x2b4)
[107180.253096] [<c04009d0>] (xfs_iomap+0x184/0x2b4) from [<c0417b20>]
(__xfs_get_blocks+0x110/0x368)
[107180.253158] [<c0417b20>] (__xfs_get_blocks+0x110/0x368) from
[<c0417dc0>] (xfs_get_blocks+0x20/0x28)
[107180.253228] [<c0417dc0>] (xfs_get_blocks+0x20/0x28) from
[<c02e5580>] (do_mpage_readpage+0x2a0/0x720)
[107180.253296] [<c02e5580>] (do_mpage_readpage+0x2a0/0x720) from
[<c02e5b20>] (mpage_readpages+0xb8/0x114)
[107180.253372] [<c02e5b20>] (mpage_readpages+0xb8/0x114) from
[<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
[107180.253443] [<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
from [<c0292a28>] (ra_submit+0x24/0x28)
[107180.253510] [<c0292a28>] (ra_submit+0x24/0x28) from [<c0292eb0>]
(page_cache_sync_readahead+0x58/0x60)
[107180.253576] [<c0292eb0>] (page_cache_sync_readahead+0x58/0x60)
from [<c028c4b4>] (generic_file_aio_read+0x314/0x784)
[107180.253649] [<c028c4b4>] (generic_file_aio_read+0x314/0x784) from
[<c041c83c>] (xfs_file_aio_read+0x1e4/0x238)
[107180.253718] [<c041c83c>] (xfs_file_aio_read+0x1e4/0x238) from
[<c02b7e94>] (do_sync_read+0xa0/0xdc)
[107180.253780] [<c02b7e94>] (do_sync_read+0xa0/0xdc) from
[<c02b896c>] (vfs_read+0xa8/0x130)
[107180.253838] [<c02b896c>] (vfs_read+0xa8/0x130) from [<c02b8aa0>]
(sys_read+0x3c/0x68)
[107180.253895] [<c02b8aa0>] (sys_read+0x3c/0x68) from [<c023cd20>]
(ret_fast_syscall+0x0/0x2c)
[107180.254463] Filesystem "sda2": corrupt dinode 805341224, (btree
extents).  Unmount and run xfs_repair.
[107180.254535] Filesystem "sda2": XFS internal error
xfs_bmap_read_extents(1) at line 4178 of file
/home/simon/work/upstream/lacie-orion/fs/xfs/xfs_bmap.c.  Caller
0xc03fd760
[107180.254555]
[107180.254648] [<c0241474>] (unwind_backtrace+0x0/0xf0) from
[<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4)
[107180.254721] [<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4) from
[<c03fd760>] (xfs_iread_extents+0x98/0xc4)
[107180.254791] [<c03fd760>] (xfs_iread_extents+0x98/0xc4) from
[<c03df7f8>] (xfs_bmapi+0x20c/0xf20)
[107180.254853] [<c03df7f8>] (xfs_bmapi+0x20c/0xf20) from [<c04009d0>]
(xfs_iomap+0x184/0x2b4)
[107180.254912] [<c04009d0>] (xfs_iomap+0x184/0x2b4) from [<c0417b20>]
(__xfs_get_blocks+0x110/0x368)
[107180.254973] [<c0417b20>] (__xfs_get_blocks+0x110/0x368) from
[<c0417dc0>] (xfs_get_blocks+0x20/0x28)
[107180.255037] [<c0417dc0>] (xfs_get_blocks+0x20/0x28) from
[<c02df59c>] (block_read_full_page+0x190/0x3d8)
[107180.255106] [<c02df59c>] (block_read_full_page+0x190/0x3d8) from
[<c02e59f4>] (do_mpage_readpage+0x714/0x720)
[107180.255175] [<c02e59f4>] (do_mpage_readpage+0x714/0x720) from
[<c02e5b20>] (mpage_readpages+0xb8/0x114)
[107180.255245] [<c02e5b20>] (mpage_readpages+0xb8/0x114) from
[<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
[107180.255315] [<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
from [<c0292a28>] (ra_submit+0x24/0x28)
[107180.255382] [<c0292a28>] (ra_submit+0x24/0x28) from [<c0292eb0>]
(page_cache_sync_readahead+0x58/0x60)
[107180.255448] [<c0292eb0>] (page_cache_sync_readahead+0x58/0x60)
from [<c028c4b4>] (generic_file_aio_read+0x314/0x784)
[107180.255519] [<c028c4b4>] (generic_file_aio_read+0x314/0x784) from
[<c041c83c>] (xfs_file_aio_read+0x1e4/0x238)
[107180.255587] [<c041c83c>] (xfs_file_aio_read+0x1e4/0x238) from
[<c02b7e94>] (do_sync_read+0xa0/0xdc)
[107180.255648] [<c02b7e94>] (do_sync_read+0xa0/0xdc) from
[<c02b896c>] (vfs_read+0xa8/0x130)
[107180.255705] [<c02b896c>] (vfs_read+0xa8/0x130) from [<c02b8aa0>]
(sys_read+0x3c/0x68)
[107180.255761] [<c02b8aa0>] (sys_read+0x3c/0x68) from [<c023cd20>]
(ret_fast_syscall+0x0/0x2c)
[107180.256308] Filesystem "sda2": corrupt dinode 805341224, (btree
extents).  Unmount and run xfs_repair.
[107180.256377] Filesystem "sda2": XFS internal error
xfs_bmap_read_extents(1) at line 4178 of file
/home/simon/work/upstream/lacie-orion/fs/xfs/xfs_bmap.c.  Caller
0xc03fd760
[107180.256396]
[107180.256488] [<c0241474>] (unwind_backtrace+0x0/0xf0) from
[<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4)
[107180.256559] [<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4) from
[<c03fd760>] (xfs_iread_extents+0x98/0xc4)
[107180.256626] [<c03fd760>] (xfs_iread_extents+0x98/0xc4) from
[<c03df7f8>] (xfs_bmapi+0x20c/0xf20)
[107180.256687] [<c03df7f8>] (xfs_bmapi+0x20c/0xf20) from [<c04009d0>]
(xfs_iomap+0x184/0x2b4)
[107180.256747] [<c04009d0>] (xfs_iomap+0x184/0x2b4) from [<c0417b20>]
(__xfs_get_blocks+0x110/0x368)
[107180.256808] [<c0417b20>] (__xfs_get_blocks+0x110/0x368) from
[<c0417dc0>] (xfs_get_blocks+0x20/0x28)
[107180.256875] [<c0417dc0>] (xfs_get_blocks+0x20/0x28) from
[<c02e5580>] (do_mpage_readpage+0x2a0/0x720)
[107180.256942] [<c02e5580>] (do_mpage_readpage+0x2a0/0x720) from
[<c02e5b20>] (mpage_readpages+0xb8/0x114)
[107180.257011] [<c02e5b20>] (mpage_readpages+0xb8/0x114) from
[<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
[107180.257082] [<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
from [<c0292a28>] (ra_submit+0x24/0x28)
[107180.257148] [<c0292a28>] (ra_submit+0x24/0x28) from [<c0292eb0>]
(page_cache_sync_readahead+0x58/0x60)
[107180.257214] [<c0292eb0>] (page_cache_sync_readahead+0x58/0x60)
from [<c028c4b4>] (generic_file_aio_read+0x314/0x784)
[107180.257285] [<c028c4b4>] (generic_file_aio_read+0x314/0x784) from
[<c041c83c>] (xfs_file_aio_read+0x1e4/0x238)
[107180.257352] [<c041c83c>] (xfs_file_aio_read+0x1e4/0x238) from
[<c02b7e94>] (do_sync_read+0xa0/0xdc)
[107180.257413] [<c02b7e94>] (do_sync_read+0xa0/0xdc) from
[<c02b896c>] (vfs_read+0xa8/0x130)
[107180.257469] [<c02b896c>] (vfs_read+0xa8/0x130) from [<c02b8aa0>]
(sys_read+0x3c/0x68)
[107180.257525] [<c02b8aa0>] (sys_read+0x3c/0x68) from [<c023cd20>]
(ret_fast_syscall+0x0/0x2c)
[107180.258054] Filesystem "sda2": corrupt dinode 805341224, (btree
extents).  Unmount and run xfs_repair.
[107180.258121] Filesystem "sda2": XFS internal error
xfs_bmap_read_extents(1) at line 4178 of file
/home/simon/work/upstream/lacie-orion/fs/xfs/xfs_bmap.c.  Caller
0xc03fd760
[107180.258140]
[107180.258231] [<c0241474>] (unwind_backtrace+0x0/0xf0) from
[<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4)
[107180.265087] [<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4) from
[<c03fd760>] (xfs_iread_extents+0x98/0xc4)
[107180.265168] [<c03fd760>] (xfs_iread_extents+0x98/0xc4) from
[<c03df7f8>] (xfs_bmapi+0x20c/0xf20)
[107180.265230] [<c03df7f8>] (xfs_bmapi+0x20c/0xf20) from [<c04009d0>]
(xfs_iomap+0x184/0x2b4)
[107180.265290] [<c04009d0>] (xfs_iomap+0x184/0x2b4) from [<c0417b20>]
(__xfs_get_blocks+0x110/0x368)
[107180.265351] [<c0417b20>] (__xfs_get_blocks+0x110/0x368) from
[<c0417dc0>] (xfs_get_blocks+0x20/0x28)
[107180.265417] [<c0417dc0>] (xfs_get_blocks+0x20/0x28) from
[<c02df59c>] (block_read_full_page+0x190/0x3d8)
[107180.265487] [<c02df59c>] (block_read_full_page+0x190/0x3d8) from
[<c02e59f4>] (do_mpage_readpage+0x714/0x720)
[107180.265558] [<c02e59f4>] (do_mpage_readpage+0x714/0x720) from
[<c02e5b20>] (mpage_readpages+0xb8/0x114)
[107180.265631] [<c02e5b20>] (mpage_readpages+0xb8/0x114) from
[<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
[107180.265702] [<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
from [<c0292a28>] (ra_submit+0x24/0x28)
[107180.265769] [<c0292a28>] (ra_submit+0x24/0x28) from [<c0292eb0>]
(page_cache_sync_readahead+0x58/0x60)
[107180.265835] [<c0292eb0>] (page_cache_sync_readahead+0x58/0x60)
from [<c028c4b4>] (generic_file_aio_read+0x314/0x784)
[107180.265907] [<c028c4b4>] (generic_file_aio_read+0x314/0x784) from
[<c041c83c>] (xfs_file_aio_read+0x1e4/0x238)
[107180.265975] [<c041c83c>] (xfs_file_aio_read+0x1e4/0x238) from
[<c02b7e94>] (do_sync_read+0xa0/0xdc)
[107180.266036] [<c02b7e94>] (do_sync_read+0xa0/0xdc) from
[<c02b896c>] (vfs_read+0xa8/0x130)
[107180.266093] [<c02b896c>] (vfs_read+0xa8/0x130) from [<c02b8aa0>]
(sys_read+0x3c/0x68)
[107180.266150] [<c02b8aa0>] (sys_read+0x3c/0x68) from [<c023cd20>]
(ret_fast_syscall+0x0/0x2c)
[107180.266724] Filesystem "sda2": corrupt dinode 805341224, (btree
extents).  Unmount and run xfs_repair.
[107180.266794] Filesystem "sda2": XFS internal error
xfs_bmap_read_extents(1) at line 4178 of file
/home/simon/work/upstream/lacie-orion/fs/xfs/xfs_bmap.c.  Caller
0xc03fd760
[107180.266814]
[107180.266909] [<c0241474>] (unwind_backtrace+0x0/0xf0) from
[<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4)
[107180.266980] [<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4) from
[<c03fd760>] (xfs_iread_extents+0x98/0xc4)
[107180.267048] [<c03fd760>] (xfs_iread_extents+0x98/0xc4) from
[<c03df7f8>] (xfs_bmapi+0x20c/0xf20)
[107180.267109] [<c03df7f8>] (xfs_bmapi+0x20c/0xf20) from [<c04009d0>]
(xfs_iomap+0x184/0x2b4)
[107180.267168] [<c04009d0>] (xfs_iomap+0x184/0x2b4) from [<c0417b20>]
(__xfs_get_blocks+0x110/0x368)
[107180.267230] [<c0417b20>] (__xfs_get_blocks+0x110/0x368) from
[<c0417dc0>] (xfs_get_blocks+0x20/0x28)
[107180.267297] [<c0417dc0>] (xfs_get_blocks+0x20/0x28) from
[<c02e5580>] (do_mpage_readpage+0x2a0/0x720)
[107180.267364] [<c02e5580>] (do_mpage_readpage+0x2a0/0x720) from
[<c02e5b20>] (mpage_readpages+0xb8/0x114)
[107180.267434] [<c02e5b20>] (mpage_readpages+0xb8/0x114) from
[<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
[107180.267504] [<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
from [<c0292a28>] (ra_submit+0x24/0x28)
[107180.267571] [<c0292a28>] (ra_submit+0x24/0x28) from [<c0292eb0>]
(page_cache_sync_readahead+0x58/0x60)
[107180.267637] [<c0292eb0>] (page_cache_sync_readahead+0x58/0x60)
from [<c028c4b4>] (generic_file_aio_read+0x314/0x784)
[107180.267707] [<c028c4b4>] (generic_file_aio_read+0x314/0x784) from
[<c041c83c>] (xfs_file_aio_read+0x1e4/0x238)
[107180.267775] [<c041c83c>] (xfs_file_aio_read+0x1e4/0x238) from
[<c02b7e94>] (do_sync_read+0xa0/0xdc)
[107180.267836] [<c02b7e94>] (do_sync_read+0xa0/0xdc) from
[<c02b896c>] (vfs_read+0xa8/0x130)
[107180.267893] [<c02b896c>] (vfs_read+0xa8/0x130) from [<c02b8aa0>]
(sys_read+0x3c/0x68)
[107180.267949] [<c02b8aa0>] (sys_read+0x3c/0x68) from [<c023cd20>]
(ret_fast_syscall+0x0/0x2c)
[107180.270582] Filesystem "sda2": corrupt dinode 805341224, (btree
extents).  Unmount and run xfs_repair.
[107180.270656] Filesystem "sda2": XFS internal error
xfs_bmap_read_extents(1) at line 4178 of file
/home/simon/work/upstream/lacie-orion/fs/xfs/xfs_bmap.c.  Caller
0xc03fd760
[107180.270675]
[107180.270771] [<c0241474>] (unwind_backtrace+0x0/0xf0) from
[<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4)
[107180.270843] [<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4) from
[<c03fd760>] (xfs_iread_extents+0x98/0xc4)
[107180.270912] [<c03fd760>] (xfs_iread_extents+0x98/0xc4) from
[<c03df7f8>] (xfs_bmapi+0x20c/0xf20)
[107180.270973] [<c03df7f8>] (xfs_bmapi+0x20c/0xf20) from [<c04009d0>]
(xfs_iomap+0x184/0x2b4)
[107180.271033] [<c04009d0>] (xfs_iomap+0x184/0x2b4) from [<c0417b20>]
(__xfs_get_blocks+0x110/0x368)
[107180.271094] [<c0417b20>] (__xfs_get_blocks+0x110/0x368) from
[<c0417dc0>] (xfs_get_blocks+0x20/0x28)
[107180.271158] [<c0417dc0>] (xfs_get_blocks+0x20/0x28) from
[<c02df59c>] (block_read_full_page+0x190/0x3d8)
[107180.271228] [<c02df59c>] (block_read_full_page+0x190/0x3d8) from
[<c02e59f4>] (do_mpage_readpage+0x714/0x720)
[107180.271297] [<c02e59f4>] (do_mpage_readpage+0x714/0x720) from
[<c02e5b20>] (mpage_readpages+0xb8/0x114)
[107180.271368] [<c02e5b20>] (mpage_readpages+0xb8/0x114) from
[<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
[107180.271439] [<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
from [<c0292a28>] (ra_submit+0x24/0x28)
[107180.271506] [<c0292a28>] (ra_submit+0x24/0x28) from [<c0292eb0>]
(page_cache_sync_readahead+0x58/0x60)
[107180.271572] [<c0292eb0>] (page_cache_sync_readahead+0x58/0x60)
from [<c028c4b4>] (generic_file_aio_read+0x314/0x784)
[107180.271644] [<c028c4b4>] (generic_file_aio_read+0x314/0x784) from
[<c041c83c>] (xfs_file_aio_read+0x1e4/0x238)
[107180.271711] [<c041c83c>] (xfs_file_aio_read+0x1e4/0x238) from
[<c02b7e94>] (do_sync_read+0xa0/0xdc)
[107180.271772] [<c02b7e94>] (do_sync_read+0xa0/0xdc) from
[<c02b896c>] (vfs_read+0xa8/0x130)
[107180.271829] [<c02b896c>] (vfs_read+0xa8/0x130) from [<c02b8aa0>]
(sys_read+0x3c/0x68)
[107180.271885] [<c02b8aa0>] (sys_read+0x3c/0x68) from [<c023cd20>]
(ret_fast_syscall+0x0/0x2c)
[107180.272435] Filesystem "sda2": corrupt dinode 805341224, (btree
extents).  Unmount and run xfs_repair.
[107180.272505] Filesystem "sda2": XFS internal error
xfs_bmap_read_extents(1) at line 4178 of file
/home/simon/work/upstream/lacie-orion/fs/xfs/xfs_bmap.c.  Caller
0xc03fd760
[107180.272524]
[107180.272617] [<c0241474>] (unwind_backtrace+0x0/0xf0) from
[<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4)
[107180.272689] [<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4) from
[<c03fd760>] (xfs_iread_extents+0x98/0xc4)
[107180.272758] [<c03fd760>] (xfs_iread_extents+0x98/0xc4) from
[<c03df7f8>] (xfs_bmapi+0x20c/0xf20)
[107180.272819] [<c03df7f8>] (xfs_bmapi+0x20c/0xf20) from [<c04009d0>]
(xfs_iomap+0x184/0x2b4)
[107180.272878] [<c04009d0>] (xfs_iomap+0x184/0x2b4) from [<c0417b20>]
(__xfs_get_blocks+0x110/0x368)
[107180.272939] [<c0417b20>] (__xfs_get_blocks+0x110/0x368) from
[<c0417dc0>] (xfs_get_blocks+0x20/0x28)
[107180.273006] [<c0417dc0>] (xfs_get_blocks+0x20/0x28) from
[<c02e5580>] (do_mpage_readpage+0x2a0/0x720)
[107180.273073] [<c02e5580>] (do_mpage_readpage+0x2a0/0x720) from
[<c02e5b20>] (mpage_readpages+0xb8/0x114)
[107180.273143] [<c02e5b20>] (mpage_readpages+0xb8/0x114) from
[<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
[107180.273213] [<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
from [<c0292a28>] (ra_submit+0x24/0x28)
[107180.273280] [<c0292a28>] (ra_submit+0x24/0x28) from [<c0292eb0>]
(page_cache_sync_readahead+0x58/0x60)
[107180.273346] [<c0292eb0>] (page_cache_sync_readahead+0x58/0x60)
from [<c028c4b4>] (generic_file_aio_read+0x314/0x784)
[107180.273417] [<c028c4b4>] (generic_file_aio_read+0x314/0x784) from
[<c041c83c>] (xfs_file_aio_read+0x1e4/0x238)
[107180.273484] [<c041c83c>] (xfs_file_aio_read+0x1e4/0x238) from
[<c02b7e94>] (do_sync_read+0xa0/0xdc)
[107180.273544] [<c02b7e94>] (do_sync_read+0xa0/0xdc) from
[<c02b896c>] (vfs_read+0xa8/0x130)
[107180.273601] [<c02b896c>] (vfs_read+0xa8/0x130) from [<c02b8aa0>]
(sys_read+0x3c/0x68)
[107180.273657] [<c02b8aa0>] (sys_read+0x3c/0x68) from [<c023cd20>]
(ret_fast_syscall+0x0/0x2c)
[107180.274188] Filesystem "sda2": corrupt dinode 805341224, (btree
extents).  Unmount and run xfs_repair.
[107180.274256] Filesystem "sda2": XFS internal error
xfs_bmap_read_extents(1) at line 4178 of file
/home/simon/work/upstream/lacie-orion/fs/xfs/xfs_bmap.c.  Caller
0xc03fd760
[107180.274274]
[107180.274366] [<c0241474>] (unwind_backtrace+0x0/0xf0) from
[<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4)
[107180.274437] [<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4) from
[<c03fd760>] (xfs_iread_extents+0x98/0xc4)
[107180.274506] [<c03fd760>] (xfs_iread_extents+0x98/0xc4) from
[<c03df7f8>] (xfs_bmapi+0x20c/0xf20)
[107180.274567] [<c03df7f8>] (xfs_bmapi+0x20c/0xf20) from [<c04009d0>]
(xfs_iomap+0x184/0x2b4)
[107180.274627] [<c04009d0>] (xfs_iomap+0x184/0x2b4) from [<c0417b20>]
(__xfs_get_blocks+0x110/0x368)
[107180.274690] [<c0417b20>] (__xfs_get_blocks+0x110/0x368) from
[<c0417dc0>] (xfs_get_blocks+0x20/0x28)
[107180.274754] [<c0417dc0>] (xfs_get_blocks+0x20/0x28) from
[<c02df59c>] (block_read_full_page+0x190/0x3d8)
[107180.274823] [<c02df59c>] (block_read_full_page+0x190/0x3d8) from
[<c02e59f4>] (do_mpage_readpage+0x714/0x720)
[107180.274892] [<c02e59f4>] (do_mpage_readpage+0x714/0x720) from
[<c02e5b20>] (mpage_readpages+0xb8/0x114)
[107180.274961] [<c02e5b20>] (mpage_readpages+0xb8/0x114) from
[<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
[107180.275032] [<c0292958>] (__do_page_cache_readahead+0x1b0/0x25c)
from [<c0292a28>] (ra_submit+0x24/0x28)
[107180.275099] [<c0292a28>] (ra_submit+0x24/0x28) from [<c0292eb0>]
(page_cache_sync_readahead+0x58/0x60)
[107180.275165] [<c0292eb0>] (page_cache_sync_readahead+0x58/0x60)
from [<c028c4b4>] (generic_file_aio_read+0x314/0x784)
[107180.275236] [<c028c4b4>] (generic_file_aio_read+0x314/0x784) from
[<c041c83c>] (xfs_file_aio_read+0x1e4/0x238)
[107180.275304] [<c041c83c>] (xfs_file_aio_read+0x1e4/0x238) from
[<c02b7e94>] (do_sync_read+0xa0/0xdc)
[107180.275365] [<c02b7e94>] (do_sync_read+0xa0/0xdc) from
[<c02b896c>] (vfs_read+0xa8/0x130)
[107180.275422] [<c02b896c>] (vfs_read+0xa8/0x130) from [<c02b8aa0>]
(sys_read+0x3c/0x68)
[107180.275478] [<c02b8aa0>] (sys_read+0x3c/0x68) from [<c023cd20>]
(ret_fast_syscall+0x0/0x2c)
[107180.276018] Filesystem "sda2": corrupt dinode 805341224, (btree
extents).  Unmount and run xfs_repair.
[107180.276086] Filesystem "sda2": XFS internal error
xfs_bmap_read_extents(1) at line 4178 of file
/home/simon/work/upstream/lacie-orion/fs/xfs/xfs_bmap.c.  Caller
0xc03fd760
[107180.276105]
[107180.276196] [<c0241474>] (unwind_backtrace+0x0/0xf0) from
[<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4)
[107180.276268] [<c03dded8>] (xfs_bmap_read_extents+0x3d8/0x4a4) from
[<c03fd760>] (xfs_iread_extents+0x98/0xc4)
[107180.276337] [<c03fd760>] (xfs_iread_extents+0x98/0xc4) from
[<c03df7f8>] (xfs_bmapi+0x20c/0xf20)
[107180.276398] [<c03df7f8>] (xfs_bmapi+0x20c/0xf20) from [<c04009d0>]
(xfs_iomap+0x184/0x2b4)
[107180.276457] [<c04009d0>] (xfs_iomap+0x184/0x2b4) from [<c0417b20>]
(__xfs_get_blocks+0x110/0x368)
[107180.276518] [<c0417b20>] (__xfs_get_blocks+0x110/0x368) from
[<c0417dc0>] (xfs_get_blocks+0x20/0x28)
[107180.276581] [<c0417dc0>] (xfs_get_blocks+0x20/0x28) from
[<c02df59c>] (block_read_full_page+0x190/0x3d8)
[107180.276649] [<c02df59c>] (block_read_full_page+0x190/0x3d8) from
[<c02e59f4>] (do_mpage_readpage+0x714/0x720)
[107180.276718] [<c02e59f4>] (do_mpage_readpage+0x714/0x720) from
[<c02e5a4c>] (mpage_readpage+0x4c/0x68)
[107180.276783] [<c02e5a4c>] (mpage_readpage+0x4c/0x68) from
[<c028c720>] (generic_file_aio_read+0x580/0x784)
[107180.276850] [<c028c720>] (generic_file_aio_read+0x580/0x784) from
[<c041c83c>] (xfs_file_aio_read+0x1e4/0x238)
[107180.276918] [<c041c83c>] (xfs_file_aio_read+0x1e4/0x238) from
[<c02b7e94>] (do_sync_read+0xa0/0xdc)
[107180.276979] [<c02b7e94>] (do_sync_read+0xa0/0xdc) from
[<c02b896c>] (vfs_read+0xa8/0x130)
[107180.277035] [<c02b896c>] (vfs_read+0xa8/0x130) from [<c02b8aa0>]
(sys_read+0x3c/0x68)
[107180.277092] [<c02b8aa0>] (sys_read+0x3c/0x68) from [<c023cd20>]
(ret_fast_syscall+0x0/0x2c)
[110361.583746] Filesystem "sda2": corrupt dinode 1745220464, (btree
extents).  Unmount and run xfs_repair.
[110361.583837] Filesystem "sda2": XFS internal error
xfs_bmap_read_extents(1) at line 4178 of file
/home/simon/work/upstream/lacie-orion/fs/xfs/xfs_bmap.c.  Caller
0xc03fd760
[=85] lots of other similar messages.



Here is xfs_repair full log (*after* having supressed the log and
xfs_repair crashed one first time):
# xfs_repair -m 180 -n /dev/sda2
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
sb_ifree 2632, counted 2639
sb_fdblocks 152893952, counted 152663073
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
directory flags set on non-directory inode 101338767directory flags
set on non-directory inode 101338768directory flags set on
non-directory inode 101338769directory flags set on non-directory
inode 101338767, would fix bad flags.
directory flags set on non-directory inode 101338768, would fix bad flags.
directory flags set on non-directory inode 101338769, would fix bad flags.
        - agno =3D 1
directory flags set on non-directory inode 246530215directory flags
set on non-directory inode 246530216directory flags set on
non-directory inode 246530217directory flags set on non-directory
inode 246530218directory flags set on non-directory inode
246530219directory flags set on non-directory inode 246530215, would
fix bad flags.
directory flags set on non-directory inode 246530216, would fix bad flags.
directory flags set on non-directory inode 246530217, would fix bad flags.
directory flags set on non-directory inode 246530218, would fix bad flags.
directory flags set on non-directory inode 246530219, would fix bad flags.
        - agno =3D 2
directory flags set on non-directory inode 268435650directory flags
set on non-directory inode 268435652directory flags set on
non-directory inode 268435653directory flags set on non-directory
inode 268435654directory flags set on non-directory inode
268435655directory flags set on non-directory inode 268435656directory
flags set on non-directory inode 268435657directory flags set on
non-directory inode 268435658directory flags set on non-directory
inode 268435659directory flags set on non-directory inode
268435702directory flags set on non-directory inode 268435650, would
fix bad flags.
directory flags set on non-directory inode 268435652, would fix bad flags.
directory flags set on non-directory inode 268435653, would fix bad flags.
directory flags set on non-directory inode 268435654, would fix bad flags.
directory flags set on non-directory inode 268435655, would fix bad flags.
directory flags set on non-directory inode 268435656, would fix bad flags.
directory flags set on non-directory inode 268435657, would fix bad flags.
directory flags set on non-directory inode 268435658, would fix bad flags.
directory flags set on non-directory inode 268435659, would fix bad flags.
directory flags set on non-directory inode 268435702, would fix bad flags.
directory flags set on non-directory inode 328295871directory flags
set on non-directory inode 328295875directory flags set on
non-directory inode 328295871, would fix bad flags.
directory flags set on non-directory inode 328295875, would fix bad flags.
directory flags set on non-directory inode 334145166directory flags
set on non-directory inode 334145166, would fix bad flags.
        - agno =3D 3
directory flags set on non-directory inode 402653324directory flags
set on non-directory inode 402653326directory flags set on
non-directory inode 402653327directory flags set on non-directory
inode 402653328directory flags set on non-directory inode
402653329directory flags set on non-directory inode 402653332directory
flags set on non-directory inode 402653343directory flags set on
non-directory inode 402653354directory flags set on non-directory
inode 402653324, would fix bad flags.
directory flags set on non-directory inode 402653326, would fix bad flags.
directory flags set on non-directory inode 402653327, would fix bad flags.
directory flags set on non-directory inode 402653328, would fix bad flags.
directory flags set on non-directory inode 402653329, would fix bad flags.
directory flags set on non-directory inode 402653332, would fix bad flags.
directory flags set on non-directory inode 402653343, would fix bad flags.
directory flags set on non-directory inode 402653354, would fix bad flags.
directory flags set on non-directory inode 402890606directory flags
set on non-directory inode 402890607directory flags set on
non-directory inode 402890606, would fix bad flags.
directory flags set on non-directory inode 402890607, would fix bad flags.
directory flags set on non-directory inode 403009355directory flags
set on non-directory inode 403009356directory flags set on
non-directory inode 403009357directory flags set on non-directory
inode 403009358directory flags set on non-directory inode
403009359directory flags set on non-directory inode 403009360directory
flags set on non-directory inode 403009361directory flags set on
non-directory inode 403009362directory flags set on non-directory
inode 403009363directory flags set on non-directory inode
403009364directory flags set on non-directory inode 403009365directory
flags set on non-directory inode 403009366directory flags set on
non-directory inode 403009367directory flags set on non-directory
inode 403009368directory flags set on non-directory inode
403009369directory flags set on non-directory inode 403009370directory
flags set on non-directory inode 403009371directory flags set on
non-directory inode 403009372directory flags set on non-directory
inode 403009373directory flags set on non-directory inode
403009374directory flags set on non-directory inode 403009375directory
flags set on non-directory inode 403009355, would fix bad flags.
directory flags set on non-directory inode 403009356, would fix bad flags.
directory flags set on non-directory inode 403009357, would fix bad flags.
directory flags set on non-directory inode 403009358, would fix bad flags.
directory flags set on non-directory inode 403009359, would fix bad flags.
directory flags set on non-directory inode 403009360, would fix bad flags.
directory flags set on non-directory inode 403009361, would fix bad flags.
directory flags set on non-directory inode 403009362, would fix bad flags.
directory flags set on non-directory inode 403009363, would fix bad flags.
directory flags set on non-directory inode 403009364, would fix bad flags.
directory flags set on non-directory inode 403009365, would fix bad flags.
directory flags set on non-directory inode 403009366, would fix bad flags.
directory flags set on non-directory inode 403009367, would fix bad flags.
directory flags set on non-directory inode 403009368, would fix bad flags.
directory flags set on non-directory inode 403009369, would fix bad flags.
directory flags set on non-directory inode 403009370, would fix bad flags.
directory flags set on non-directory inode 403009371, would fix bad flags.
directory flags set on non-directory inode 403009372, would fix bad flags.
directory flags set on non-directory inode 403009373, would fix bad flags.
directory flags set on non-directory inode 403009374, would fix bad flags.
directory flags set on non-directory inode 403009375, would fix bad flags.
directory flags set on non-directory inode 403639392directory flags
set on non-directory inode 403639393directory flags set on
non-directory inode 403639446directory flags set on non-directory
inode 403639447directory flags set on non-directory inode 403639392,
would fix bad flags.
directory flags set on non-directory inode 403639393, would fix bad flags.
directory flags set on non-directory inode 403639446, would fix bad flags.
directory flags set on non-directory inode 403639447, would fix bad flags.
        - agno =3D 4
directory flags set on non-directory inode 536871105directory flags
set on non-directory inode 536871106directory flags set on
non-directory inode 536871107directory flags set on non-directory
inode 536871108directory flags set on non-directory inode
536871109directory flags set on non-directory inode 536871110directory
flags set on non-directory inode 536871111directory flags set on
non-directory inode 536871112directory flags set on non-directory
inode 536871113directory flags set on non-directory inode
536871114directory flags set on non-directory inode 536871115directory
flags set on non-directory inode 536871116directory flags set on
non-directory inode 536871117directory flags set on non-directory
inode 536871118directory flags set on non-directory inode
536871119directory flags set on non-directory inode 536871120directory
flags set on non-directory inode 536871121directory flags set on
non-directory inode 536871122directory flags set on non-directory
inode 536871123directory flags set on non-directory inode
536871124directory flags set on non-directory inode 536871125directory
flags set on non-directory inode 536871126directory flags set on
non-directory inode 536871127directory flags set on non-directory
inode 536871128directory flags set on non-directory inode 536871105,
would fix bad flags.
directory flags set on non-directory inode 536871106, would fix bad flags.
directory flags set on non-directory inode 536871107, would fix bad flags.
directory flags set on non-directory inode 536871108, would fix bad flags.
directory flags set on non-directory inode 536871109, would fix bad flags.
directory flags set on non-directory inode 536871110, would fix bad flags.
directory flags set on non-directory inode 536871111, would fix bad flags.
directory flags set on non-directory inode 536871112, would fix bad flags.
directory flags set on non-directory inode 536871113, would fix bad flags.
directory flags set on non-directory inode 536871114, would fix bad flags.
directory flags set on non-directory inode 536871115, would fix bad flags.
directory flags set on non-directory inode 536871116, would fix bad flags.
directory flags set on non-directory inode 536871117, would fix bad flags.
directory flags set on non-directory inode 536871118, would fix bad flags.
directory flags set on non-directory inode 536871119, would fix bad flags.
directory flags set on non-directory inode 536871120, would fix bad flags.
directory flags set on non-directory inode 536871121, would fix bad flags.
directory flags set on non-directory inode 536871122, would fix bad flags.
directory flags set on non-directory inode 536871123, would fix bad flags.
directory flags set on non-directory inode 536871124, would fix bad flags.
directory flags set on non-directory inode 536871125, would fix bad flags.
directory flags set on non-directory inode 536871126, would fix bad flags.
directory flags set on non-directory inode 536871127, would fix bad flags.
directory flags set on non-directory inode 536871128, would fix bad flags.
directory flags set on non-directory inode 616371991directory flags
set on non-directory inode 616371991, would fix bad flags.
directory flags set on non-directory inode 616414708directory flags
set on non-directory inode 616414708, would fix bad flags.
directory flags set on non-directory inode 616416581directory flags
set on non-directory inode 616416582directory flags set on
non-directory inode 616416584directory flags set on non-directory
inode 616416585directory flags set on non-directory inode
616416586directory flags set on non-directory inode 616416587directory
flags set on non-directory inode 616416588directory flags set on
non-directory inode 616416589directory flags set on non-directory
inode 616416590directory flags set on non-directory inode
616416591directory flags set on non-directory inode 616416592directory
flags set on non-directory inode 616416581, would fix bad flags.
directory flags set on non-directory inode 616416582, would fix bad flags.
directory flags set on non-directory inode 616416584, would fix bad flags.
directory flags set on non-directory inode 616416585, would fix bad flags.
directory flags set on non-directory inode 616416586, would fix bad flags.
directory flags set on non-directory inode 616416587, would fix bad flags.
directory flags set on non-directory inode 616416588, would fix bad flags.
directory flags set on non-directory inode 616416589, would fix bad flags.
directory flags set on non-directory inode 616416590, would fix bad flags.
directory flags set on non-directory inode 616416591, would fix bad flags.
directory flags set on non-directory inode 616416592, would fix bad flags.
directory flags set on non-directory inode 641897887directory flags
set on non-directory inode 641897888directory flags set on
non-directory inode 641897889directory flags set on non-directory
inode 641897890directory flags set on non-directory inode
641897891directory flags set on non-directory inode 641897887, would
fix bad flags.
directory flags set on non-directory inode 641897888, would fix bad flags.
directory flags set on non-directory inode 641897889, would fix bad flags.
directory flags set on non-directory inode 641897890, would fix bad flags.
directory flags set on non-directory inode 641897891, would fix bad flags.
        - agno =3D 5
directory flags set on non-directory inode 671088770directory flags
set on non-directory inode 671088771directory flags set on
non-directory inode 671088772directory flags set on non-directory
inode 671088773directory flags set on non-directory inode
671088774directory flags set on non-directory inode 671088775directory
flags set on non-directory inode 671088776directory flags set on
non-directory inode 671088777directory flags set on non-directory
inode 671088778directory flags set on non-directory inode
671088779directory flags set on non-directory inode 671088780directory
flags set on non-directory inode 671088781directory flags set on
non-directory inode 671088782directory flags set on non-directory
inode 671088783directory flags set on non-directory inode 671088770,
would fix bad flags.
directory flags set on non-directory inode 671088771, would fix bad flags.
directory flags set on non-directory inode 671088772, would fix bad flags.
directory flags set on non-directory inode 671088773, would fix bad flags.
directory flags set on non-directory inode 671088774, would fix bad flags.
directory flags set on non-directory inode 671088775, would fix bad flags.
directory flags set on non-directory inode 671088776, would fix bad flags.
directory flags set on non-directory inode 671088777, would fix bad flags.
directory flags set on non-directory inode 671088778, would fix bad flags.
directory flags set on non-directory inode 671088779, would fix bad flags.
directory flags set on non-directory inode 671088780, would fix bad flags.
directory flags set on non-directory inode 671088781, would fix bad flags.
directory flags set on non-directory inode 671088782, would fix bad flags.
directory flags set on non-directory inode 671088783, would fix bad flags.
directory flags set on non-directory inode 746391849directory flags
set on non-directory inode 746391850directory flags set on
non-directory inode 746391849, would fix bad flags.
directory flags set on non-directory inode 746391850, would fix bad flags.
        - agno =3D 6
directory flags set on non-directory inode 805306531directory flags
set on non-directory inode 805306532directory flags set on
non-directory inode 805306531, would fix bad flags.
directory flags set on non-directory inode 805306532, would fix bad flags.
directory flags set on non-directory inode 805341224directory flags
set on non-directory inode 805341224, would fix bad flags.
bad nblocks 25921 for inode 805341224, would reset to 26746
bad nextents 1019 for inode 805341224, would reset to 1023
directory flags set on non-directory inode 805341818directory flags
set on non-directory inode 805341820directory flags set on
non-directory inode 805341818, would fix bad flags.
directory flags set on non-directory inode 805341820, would fix bad flags.
directory flags set on non-directory inode 805342464directory flags
set on non-directory inode 805342470directory flags set on
non-directory inode 805342475directory flags set on non-directory
inode 805342464, would fix bad flags.
directory flags set on non-directory inode 805342470, would fix bad flags.
directory flags set on non-directory inode 805342475, would fix bad flags.
directory flags set on non-directory inode 805344788directory flags
set on non-directory inode 805344791directory flags set on
non-directory inode 805344788, would fix bad flags.
directory flags set on non-directory inode 805344791, would fix bad flags.
directory flags set on non-directory inode 805346208directory flags
set on non-directory inode 805346211directory flags set on
non-directory inode 805346225directory flags set on non-directory
inode 805346208, would fix bad flags.
directory flags set on non-directory inode 805346211, would fix bad flags.
directory flags set on non-directory inode 805346225, would fix bad flags.
directory flags set on non-directory inode 806351556directory flags
set on non-directory inode 806351557directory flags set on
non-directory inode 806351558directory flags set on non-directory
inode 806351556, would fix bad flags.
directory flags set on non-directory inode 806351557, would fix bad flags.
directory flags set on non-directory inode 806351558, would fix bad flags.
directory flags set on non-directory inode 838451867directory flags
set on non-directory inode 838451869directory flags set on
non-directory inode 838451867, would fix bad flags.
directory flags set on non-directory inode 838451869, would fix bad flags.
directory flags set on non-directory inode 838457645directory flags
set on non-directory inode 838457646directory flags set on
non-directory inode 838457647directory flags set on non-directory
inode 838457652directory flags set on non-directory inode
838457653directory flags set on non-directory inode 838457654directory
flags set on non-directory inode 838457645, would fix bad flags.
directory flags set on non-directory inode 838457646, would fix bad flags.
directory flags set on non-directory inode 838457647, would fix bad flags.
directory flags set on non-directory inode 838457652, would fix bad flags.
directory flags set on non-directory inode 838457653, would fix bad flags.
directory flags set on non-directory inode 838457654, would fix bad flags.
        - agno =3D 7
data fork in ino 939524167 claims free block 61620270
data fork in ino 939524167 claims free block 61620271
data fork in ino 939524169 claims free block 62968233
data fork in ino 939524169 claims free block 62968234
data fork in ino 939524170 claims free block 62379270
data fork in ino 939524170 claims free block 62379271
data fork in ino 939524171 claims free block 59720652
data fork in ino 939524171 claims free block 59720653
data fork in ino 939524173 claims free block 59720672
data fork in ino 939524173 claims free block 59720673
data fork in ino 939524174 claims free block 62749546
data fork in ino 939524174 claims free block 62749547
data fork in ino 939524177 claims free block 61619386
data fork in ino 939524177 claims free block 61619387
data fork in ino 939524179 claims free block 62873080
data fork in ino 939524179 claims free block 62873081
data fork in ino 939524180 claims free block 62809001
data fork in ino 939524180 claims free block 62809002
data fork in ino 939524181 claims free block 62868224
data fork in ino 939524181 claims free block 62868225
data fork in ino 939524183 claims free block 59725284
data fork in ino 939524183 claims free block 59725285
data fork in ino 939524184 claims free block 61796482
data fork in ino 939524184 claims free block 61796483
data fork in ino 939524185 claims free block 59721682
data fork in ino 939524185 claims free block 59721683
data fork in ino 939524187 claims free block 61630178
data fork in ino 939524187 claims free block 61630179
data fork in ino 939524190 claims free block 61636687
data fork in ino 939524190 claims free block 61636688
data fork in ino 939524191 claims free block 61401900
data fork in ino 939524191 claims free block 61401901
data fork in ino 939524192 claims free block 61577585
data fork in ino 939524192 claims free block 61577586
data fork in ino 939524194 claims free block 61618114
data fork in ino 939524194 claims free block 61618115
data fork in ino 939524196 claims free block 59720735
data fork in ino 939524196 claims free block 59720736
data fork in ino 939524198 claims free block 62989843
data fork in ino 939524198 claims free block 62989844
data fork in ino 939524199 claims free block 59720888
data fork in ino 939524199 claims free block 59720889
data fork in ino 939524201 claims free block 59952561
data fork in ino 939524201 claims free block 59952562
data fork in ino 939524203 claims free block 62868674
data fork in ino 939524203 claims free block 62868675
data fork in ino 939524207 claims free block 59720867
data fork in ino 939524207 claims free block 59720868
data fork in ino 939524209 claims free block 59720752
data fork in ino 939524209 claims free block 59720753
data fork in ino 939524211 claims free block 59721805
data fork in ino 939524211 claims free block 59721806
data fork in ino 939524212 claims free block 59720995
data fork in ino 939524212 claims free block 59720996
data fork in ino 939524215 claims free block 59721064
data fork in ino 939524215 claims free block 59721065
data fork in ino 939524216 claims free block 59721200
data fork in ino 939524216 claims free block 59721201
data fork in ino 939524218 claims free block 63065989
data fork in ino 939524218 claims free block 63065990
data fork in ino 939524223 claims free block 59721259
data fork in ino 939524223 claims free block 59721260
directory flags set on non-directory inode 939524226directory flags
set on non-directory inode 939524227directory flags set on
non-directory inode 939524228directory flags set on non-directory
inode 939524229directory flags set on non-directory inode
939524230directory flags set on non-directory inode 939524231directory
flags set on non-directory inode 939524232directory flags set on
non-directory inode 939524233directory flags set on non-directory
inode 939524234directory flags set on non-directory inode
939524235directory flags set on non-directory inode 939524236directory
flags set on non-directory inode 939524237directory flags set on
non-directory inode 939524238directory flags set on non-directory
inode 939524239directory flags set on non-directory inode
939524240directory flags set on non-directory inode 939524241directory
flags set on non-directory inode 939524242directory flags set on
non-directory inode 939524243directory flags set on non-directory
inode 939524244directory flags set on non-directory inode
939524245directory flags set on non-directory inode 939524246directory
flags set on non-directory inode 939524247directory flags set on
non-directory inode 939524248directory flags set on non-directory
inode 939524226, would fix bad flags.
directory flags set on non-directory inode 939524227, would fix bad flags.
directory flags set on non-directory inode 939524228, would fix bad flags.
directory flags set on non-directory inode 939524229, would fix bad flags.
directory flags set on non-directory inode 939524230, would fix bad flags.
directory flags set on non-directory inode 939524231, would fix bad flags.
directory flags set on non-directory inode 939524232, would fix bad flags.
directory flags set on non-directory inode 939524233, would fix bad flags.
directory flags set on non-directory inode 939524234, would fix bad flags.
directory flags set on non-directory inode 939524235, would fix bad flags.
directory flags set on non-directory inode 939524236, would fix bad flags.
directory flags set on non-directory inode 939524237, would fix bad flags.
directory flags set on non-directory inode 939524238, would fix bad flags.
directory flags set on non-directory inode 939524239, would fix bad flags.
directory flags set on non-directory inode 939524240, would fix bad flags.
directory flags set on non-directory inode 939524241, would fix bad flags.
directory flags set on non-directory inode 939524242, would fix bad flags.
directory flags set on non-directory inode 939524243, would fix bad flags.
directory flags set on non-directory inode 939524244, would fix bad flags.
directory flags set on non-directory inode 939524245, would fix bad flags.
directory flags set on non-directory inode 939524246, would fix bad flags.
directory flags set on non-directory inode 939524247, would fix bad flags.
directory flags set on non-directory inode 939524248, would fix bad flags.
data fork in ino 955529802 claims free block 61572054
data fork in ino 955529802 claims free block 61572055
data fork in ino 955529830 claims free block 62146030
data fork in ino 955529830 claims free block 62146031
data fork in ino 955537297 claims free block 62237684
data fork in ino 955537297 claims free block 62237685
directory flags set on non-directory inode 955540889directory flags
set on non-directory inode 955540890data fork in ino 955540881 claims
free block 59721351
data fork in ino 955540881 claims free block 59721352
data fork in ino 955540882 claims free block 59721602
data fork in ino 955540882 claims free block 59721603
directory flags set on non-directory inode 955540889, would fix bad flags.
directory flags set on non-directory inode 955540890, would fix bad flags.
data fork in ino 955540891 claims free block 61345045
data fork in ino 955540891 claims free block 61345046
data fork in ino 955540892 claims free block 62990868
data fork in ino 955540892 claims free block 62990869
data fork in ino 955540894 claims free block 61652753
data fork in ino 955540894 claims free block 61652754
data fork in ino 955540895 claims free block 61654910
data fork in ino 955540895 claims free block 61654911
data fork in ino 955544088 claims free block 63066071
data fork in ino 955544088 claims free block 63066072
data fork in ino 955544089 claims free block 59721317
data fork in ino 955544089 claims free block 59721318
imap claims a free inode 955546210 is in use, would correct imap and clear =
inode
data fork in ino 955555495 claims free block 59721874
data fork in ino 955555498 claims free block 61647866
data fork in ino 955555498 claims free block 61647867
data fork in ino 955555499 claims free block 61619323
data fork in ino 955555499 claims free block 61619324
data fork in ino 955555500 claims free block 61344954
data fork in ino 955555500 claims free block 61344955
data fork in ino 955555501 claims free block 62673438
data fork in ino 955555501 claims free block 62673439
data fork in ino 955555502 claims free block 60040137
data fork in ino 955555502 claims free block 60040138
data fork in ino 955555503 claims free block 59722055
data fork in ino 955555503 claims free block 59722056
data fork in ino 955555506 claims free block 59952729
data fork in ino 955555506 claims free block 59952730
data fork in ino 955555507 claims free block 59722230
imap claims in-use inode 955555507 is free, would correct imap
data fork in ino 955555510 claims free block 59721865
data fork in ino 955555510 claims free block 59721866
data fork in ino 955555511 claims free block 62989999
data fork in ino 955555511 claims free block 62990000
data fork in ino 955555512 claims free block 61629742
data fork in ino 955555512 claims free block 61629743
data fork in ino 955555514 claims free block 61351801
data fork in ino 955555514 claims free block 61351802
data fork in ino 955555515 claims free block 61342956
data fork in ino 955555515 claims free block 61342957
data fork in ino 955555516 claims free block 59725357
data fork in ino 955555516 claims free block 59725358
data fork in ino 955555517 claims free block 61967957
data fork in ino 955555517 claims free block 61967958
        - agno =3D 8
directory flags set on non-directory inode 1073741991directory flags
set on non-directory inode 1073742007directory flags set on
non-directory inode 1073742014directory flags set on non-directory
inode 1073742015directory flags set on non-directory inode 1073741991,
would fix bad flags.
directory flags set on non-directory inode 1073742007, would fix bad flags.
directory flags set on non-directory inode 1073742014, would fix bad flags.
directory flags set on non-directory inode 1073742015, would fix bad flags.
directory flags set on non-directory inode 1074554481directory flags
set on non-directory inode 1074554483directory flags set on
non-directory inode 1074554486directory flags set on non-directory
inode 1074554487directory flags set on non-directory inode
1074554489directory flags set on non-directory inode
1074554490directory flags set on non-directory inode
1074554491directory flags set on non-directory inode
1074554496directory flags set on non-directory inode
1074554507directory flags set on non-directory inode 1074554481, would
fix bad flags.
directory flags set on non-directory inode 1074554483, would fix bad flags.
directory flags set on non-directory inode 1074554486, would fix bad flags.
directory flags set on non-directory inode 1074554487, would fix bad flags.
directory flags set on non-directory inode 1074554489, would fix bad flags.
directory flags set on non-directory inode 1074554490, would fix bad flags.
directory flags set on non-directory inode 1074554491, would fix bad flags.
directory flags set on non-directory inode 1074554496, would fix bad flags.
directory flags set on non-directory inode 1074554507, would fix bad flags.
directory flags set on non-directory inode 1074558050directory flags
set on non-directory inode 1074558052directory flags set on
non-directory inode 1074558055directory flags set on non-directory
inode 1074558074directory flags set on non-directory inode 1074558050,
would fix bad flags.
directory flags set on non-directory inode 1074558052, would fix bad flags.
directory flags set on non-directory inode 1074558055, would fix bad flags.
directory flags set on non-directory inode 1074558074, would fix bad flags.
directory flags set on non-directory inode 1074559671directory flags
set on non-directory inode 1074559671, would fix bad flags.
directory flags set on non-directory inode 1074562103directory flags
set on non-directory inode 1074562103, would fix bad flags.
directory flags set on non-directory inode 1074651482directory flags
set on non-directory inode 1074651485directory flags set on
non-directory inode 1074651482, would fix bad flags.
directory flags set on non-directory inode 1074651485, would fix bad flags.
directory flags set on non-directory inode 1078343544directory flags
set on non-directory inode 1078343547directory flags set on
non-directory inode 1078343544, would fix bad flags.
directory flags set on non-directory inode 1078343547, would fix bad flags.
directory flags set on non-directory inode 1082336577directory flags
set on non-directory inode 1082336582directory flags set on
non-directory inode 1082336591directory flags set on non-directory
inode 1082336577, would fix bad flags.
directory flags set on non-directory inode 1082336582, would fix bad flags.
directory flags set on non-directory inode 1082336591, would fix bad flags.
directory flags set on non-directory inode 1086098920directory flags
set on non-directory inode 1086098921directory flags set on
non-directory inode 1086098924directory flags set on non-directory
inode 1086098920, would fix bad flags.
directory flags set on non-directory inode 1086098921, would fix bad flags.
directory flags set on non-directory inode 1086098924, would fix bad flags.
directory flags set on non-directory inode 1086410821directory flags
set on non-directory inode 1086410824directory flags set on
non-directory inode 1086410825directory flags set on non-directory
inode 1086410821, would fix bad flags.
directory flags set on non-directory inode 1086410824, would fix bad flags.
directory flags set on non-directory inode 1086410825, would fix bad flags.
        - agno =3D 9
directory flags set on non-directory inode 1207959682directory flags
set on non-directory inode 1207959683directory flags set on
non-directory inode 1207959684directory flags set on non-directory
inode 1207959685directory flags set on non-directory inode
1207959686directory flags set on non-directory inode
1207959687directory flags set on non-directory inode
1207959688directory flags set on non-directory inode
1207959689directory flags set on non-directory inode
1207959690directory flags set on non-directory inode
1207959691directory flags set on non-directory inode
1207959692directory flags set on non-directory inode
1207959693directory flags set on non-directory inode
1207959694directory flags set on non-directory inode
1207959695directory flags set on non-directory inode
1207959696directory flags set on non-directory inode
1207959697directory flags set on non-directory inode
1207959698directory flags set on non-directory inode
1207959699directory flags set on non-directory inode
1207959700directory flags set on non-directory inode
1207959701directory flags set on non-directory inode
1207959702directory flags set on non-directory inode
1207959703directory flags set on non-directory inode 1207959682, would
fix bad flags.
directory flags set on non-directory inode 1207959683, would fix bad flags.
directory flags set on non-directory inode 1207959684, would fix bad flags.
directory flags set on non-directory inode 1207959685, would fix bad flags.
directory flags set on non-directory inode 1207959686, would fix bad flags.
directory flags set on non-directory inode 1207959687, would fix bad flags.
directory flags set on non-directory inode 1207959688, would fix bad flags.
directory flags set on non-directory inode 1207959689, would fix bad flags.
directory flags set on non-directory inode 1207959690, would fix bad flags.
directory flags set on non-directory inode 1207959691, would fix bad flags.
directory flags set on non-directory inode 1207959692, would fix bad flags.
directory flags set on non-directory inode 1207959693, would fix bad flags.
directory flags set on non-directory inode 1207959694, would fix bad flags.
directory flags set on non-directory inode 1207959695, would fix bad flags.
directory flags set on non-directory inode 1207959696, would fix bad flags.
directory flags set on non-directory inode 1207959697, would fix bad flags.
directory flags set on non-directory inode 1207959698, would fix bad flags.
directory flags set on non-directory inode 1207959699, would fix bad flags.
directory flags set on non-directory inode 1207959700, would fix bad flags.
directory flags set on non-directory inode 1207959701, would fix bad flags.
directory flags set on non-directory inode 1207959702, would fix bad flags.
directory flags set on non-directory inode 1207959703, would fix bad flags.
        - agno =3D 10
directory flags set on non-directory inode 1342177409directory flags
set on non-directory inode 1342177410directory flags set on
non-directory inode 1342177411directory flags set on non-directory
inode 1342177412directory flags set on non-directory inode
1342177413directory flags set on non-directory inode
1342177414directory flags set on non-directory inode
1342177440directory flags set on non-directory inode
1342177441directory flags set on non-directory inode
1342177442directory flags set on non-directory inode
1342177443directory flags set on non-directory inode
1342177444directory flags set on non-directory inode 1342177409, would
fix bad flags.
directory flags set on non-directory inode 1342177410, would fix bad flags.
directory flags set on non-directory inode 1342177411, would fix bad flags.
directory flags set on non-directory inode 1342177412, would fix bad flags.
directory flags set on non-directory inode 1342177413, would fix bad flags.
directory flags set on non-directory inode 1342177414, would fix bad flags.
data fork in ino 1342177430 claims free block 83886084
directory flags set on non-directory inode 1342177440, would fix bad flags.
directory flags set on non-directory inode 1342177441, would fix bad flags.
directory flags set on non-directory inode 1342177442, would fix bad flags.
directory flags set on non-directory inode 1342177443, would fix bad flags.
directory flags set on non-directory inode 1342177444, would fix bad flags.
directory flags set on non-directory inode 1353070219directory flags
set on non-directory inode 1353070219, would fix bad flags.
directory flags set on non-directory inode 1353085647directory flags
set on non-directory inode 1353085649directory flags set on
non-directory inode 1353085647, would fix bad flags.
directory flags set on non-directory inode 1353085649, would fix bad flags.
directory flags set on non-directory inode 1353093344directory flags
set on non-directory inode 1353093344, would fix bad flags.
directory flags set on non-directory inode 1353122680directory flags
set on non-directory inode 1353122681directory flags set on
non-directory inode 1353122680, would fix bad flags.
directory flags set on non-directory inode 1353122681, would fix bad flags.
directory flags set on non-directory inode 1353201686directory flags
set on non-directory inode 1353201689directory flags set on
non-directory inode 1353201690directory flags set on non-directory
inode 1353201686, would fix bad flags.
directory flags set on non-directory inode 1353201689, would fix bad flags.
directory flags set on non-directory inode 1353201690, would fix bad flags.
directory flags set on non-directory inode 1356743573directory flags
set on non-directory inode 1356743574directory flags set on
non-directory inode 1356743582directory flags set on non-directory
inode 1356743583directory flags set on non-directory inode
1356743585directory flags set on non-directory inode
1356743590directory flags set on non-directory inode 1356743573, would
fix bad flags.
directory flags set on non-directory inode 1356743574, would fix bad flags.
directory flags set on non-directory inode 1356743582, would fix bad flags.
directory flags set on non-directory inode 1356743583, would fix bad flags.
directory flags set on non-directory inode 1356743585, would fix bad flags.
directory flags set on non-directory inode 1356743590, would fix bad flags.
directory flags set on non-directory inode 1378619422directory flags
set on non-directory inode 1378619422, would fix bad flags.
directory flags set on non-directory inode 1378637444directory flags
set on non-directory inode 1378637444, would fix bad flags.
        - agno =3D 11
directory flags set on non-directory inode 1476395138directory flags
set on non-directory inode 1476395139directory flags set on
non-directory inode 1476395140directory flags set on non-directory
inode 1476395143directory flags set on non-directory inode
1476395194directory flags set on non-directory inode
1476395196directory flags set on non-directory inode
1476395199directory flags set on non-directory inode 1476395138, would
fix bad flags.
directory flags set on non-directory inode 1476395139, would fix bad flags.
directory flags set on non-directory inode 1476395140, would fix bad flags.
directory flags set on non-directory inode 1476395143, would fix bad flags.
directory flags set on non-directory inode 1476395194, would fix bad flags.
directory flags set on non-directory inode 1476395196, would fix bad flags.
directory flags set on non-directory inode 1476395199, would fix bad flags.
directory flags set on non-directory inode 1477716387directory flags
set on non-directory inode 1477716387, would fix bad flags.
directory flags set on non-directory inode 1478103982directory flags
set on non-directory inode 1478103989directory flags set on
non-directory inode 1478103982, would fix bad flags.
directory flags set on non-directory inode 1478103989, would fix bad flags.
directory flags set on non-directory inode 1511529344directory flags
set on non-directory inode 1511529387directory flags set on
non-directory inode 1511529388directory flags set on non-directory
inode 1511529389directory flags set on non-directory inode
1511529390directory flags set on non-directory inode
1511529391directory flags set on non-directory inode 1511529344, would
fix bad flags.
directory flags set on non-directory inode 1511529387, would fix bad flags.
directory flags set on non-directory inode 1511529388, would fix bad flags.
directory flags set on non-directory inode 1511529389, would fix bad flags.
directory flags set on non-directory inode 1511529390, would fix bad flags.
directory flags set on non-directory inode 1511529391, would fix bad flags.
directory flags set on non-directory inode 1511534931directory flags
set on non-directory inode 1511534931, would fix bad flags.
        - agno =3D 12
directory flags set on non-directory inode 1610612868directory flags
set on non-directory inode 1610612891directory flags set on
non-directory inode 1610612868, would fix bad flags.
directory flags set on non-directory inode 1610612891, would fix bad flags.
data fork in regular inode 1610612918 claims used block 100663302
bad data fork in inode 1610612918
would have cleared inode 1610612918
data fork in ino 1610612919 claims free block 100725285
directory flags set on non-directory inode 1612086028directory flags
set on non-directory inode 1612086032directory flags set on
non-directory inode 1612086056directory flags set on non-directory
inode 1612086057directory flags set on non-directory inode 1612086028,
would fix bad flags.
directory flags set on non-directory inode 1612086032, would fix bad flags.
directory flags set on non-directory inode 1612086056, would fix bad flags.
directory flags set on non-directory inode 1612086057, would fix bad flags.
directory flags set on non-directory inode 1614013695directory flags
set on non-directory inode 1614013695, would fix bad flags.
directory flags set on non-directory inode 1628483272directory flags
set on non-directory inode 1628483273directory flags set on
non-directory inode 1628483274directory flags set on non-directory
inode 1628483275directory flags set on non-directory inode
1628483276directory flags set on non-directory inode
1628483277directory flags set on non-directory inode 1628483272, would
fix bad flags.
directory flags set on non-directory inode 1628483273, would fix bad flags.
directory flags set on non-directory inode 1628483274, would fix bad flags.
directory flags set on non-directory inode 1628483275, would fix bad flags.
directory flags set on non-directory inode 1628483276, would fix bad flags.
directory flags set on non-directory inode 1628483277, would fix bad flags.
directory flags set on non-directory inode 1630468486directory flags
set on non-directory inode 1630468487data fork in ino 1630468476
claims free block 101904288
directory flags set on non-directory inode 1630468486, would fix bad flags.
directory flags set on non-directory inode 1630468487, would fix bad flags.
        - agno =3D 13
directory flags set on non-directory inode 1744830600directory flags
set on non-directory inode 1744830611directory flags set on
non-directory inode 1744830600, would fix bad flags.
directory flags set on non-directory inode 1744830611, would fix bad flags.
directory flags set on non-directory inode 1745087116directory flags
set on non-directory inode 1745087120directory flags set on
non-directory inode 1745087148directory flags set on non-directory
inode 1745087149directory flags set on non-directory inode 1745087116,
would fix bad flags.
directory flags set on non-directory inode 1745087120, would fix bad flags.
directory flags set on non-directory inode 1745087148, would fix bad flags.
directory flags set on non-directory inode 1745087149, would fix bad flags.
directory flags set on non-directory inode 1745087173directory flags
set on non-directory inode 1745087186directory flags set on
non-directory inode 1745087208directory flags set on non-directory
inode 1745087215directory flags set on non-directory inode
1745087218directory flags set on non-directory inode 1745087173, would
fix bad flags.
directory flags set on non-directory inode 1745087186, would fix bad flags.
directory flags set on non-directory inode 1745087208, would fix bad flags.
directory flags set on non-directory inode 1745087215, would fix bad flags.
directory flags set on non-directory inode 1745087218, would fix bad flags.
directory flags set on non-directory inode 1745092002directory flags
set on non-directory inode 1745092002, would fix bad flags.
directory flags set on non-directory inode 1745096452directory flags
set on non-directory inode 1745096459directory flags set on
non-directory inode 1745096452, would fix bad flags.
directory flags set on non-directory inode 1745096459, would fix bad flags.
directory flags set on non-directory inode 1745195682directory flags
set on non-directory inode 1745195685directory flags set on
non-directory inode 1745195686directory flags set on non-directory
inode 1745195689directory flags set on non-directory inode 1745195682,
would fix bad flags.
directory flags set on non-directory inode 1745195685, would fix bad flags.
directory flags set on non-directory inode 1745195686, would fix bad flags.
directory flags set on non-directory inode 1745195689, would fix bad flags.
directory flags set on non-directory inode 1745220461directory flags
set on non-directory inode 1745220464directory flags set on
non-directory inode 1745220466directory flags set on non-directory
inode 1745220461, would fix bad flags.
directory flags set on non-directory inode 1745220464, would fix bad flags.
bad key in bmbt root (is 39216, would reset to 39340) in inode
1745220464 data fork
bad key in bmbt root (is 58437, would reset to 50150) in inode
1745220464 data fork
bad key in bmbt root (is 60970, would reset to 60722) in inode
1745220464 data fork
bad nblocks 26474 for inode 1745220464, would reset to 28964
bad nextents 1716 for inode 1745220464, would reset to 1837
directory flags set on non-directory inode 1745220466, would fix bad flags.
bad nblocks 43079 for inode 1745220466, would reset to 45879
bad nextents 1911 for inode 1745220466, would reset to 1977
directory flags set on non-directory inode 1762421760directory flags
set on non-directory inode 1762421783directory flags set on
non-directory inode 1762421760, would fix bad flags.
directory flags set on non-directory inode 1762421783, would fix bad flags.
directory flags set on non-directory inode 1782173010directory flags
set on non-directory inode 1782173019directory flags set on
non-directory inode 1782173020directory flags set on non-directory
inode 1782173010, would fix bad flags.
directory flags set on non-directory inode 1782173019, would fix bad flags.
directory flags set on non-directory inode 1782173020, would fix bad flags.
directory flags set on non-directory inode 1787508508directory flags
set on non-directory inode 1787508509directory flags set on
non-directory inode 1787508508, would fix bad flags.
directory flags set on non-directory inode 1787508509, would fix bad flags.
        - agno =3D 14
directory flags set on non-directory inode 1879048322directory flags
set on non-directory inode 1879048325directory flags set on
non-directory inode 1879048382directory flags set on non-directory
inode 1879048322, would fix bad flags.
directory flags set on non-directory inode 1879048325, would fix bad flags.
directory flags set on non-directory inode 1879048382, would fix bad flags.
directory flags set on non-directory inode 1880675338directory flags
set on non-directory inode 1880675339data fork in ino 1880675323
claims free block 117648959
data fork in ino 1880675323 claims free block 117648960
directory flags set on non-directory inode 1880675338, would fix bad flags.
directory flags set on non-directory inode 1880675339, would fix bad flags.
directory flags set on non-directory inode 1882600499directory flags
set on non-directory inode 1882600499, would fix bad flags.
directory flags set on non-directory inode 1886821170directory flags
set on non-directory inode 1886821173directory flags set on
non-directory inode 1886821170, would fix bad flags.
directory flags set on non-directory inode 1886821173, would fix bad flags.
data fork in ino 1905198992 claims free block 119075003
directory flags set on non-directory inode 1934032738directory flags
set on non-directory inode 1934032739directory flags set on
non-directory inode 1934032754directory flags set on non-directory
inode 1934032757directory flags set on non-directory inode 1934032738,
would fix bad flags.
directory flags set on non-directory inode 1934032739, would fix bad flags.
directory flags set on non-directory inode 1934032754, would fix bad flags.
directory flags set on non-directory inode 1934032757, would fix bad flags.
directory flags set on non-directory inode 1934131670directory flags
set on non-directory inode 1934131670, would fix bad flags.
        - agno =3D 15
directory flags set on non-directory inode 2013266054directory flags
set on non-directory inode 2013266055directory flags set on
non-directory inode 2013266056directory flags set on non-directory
inode 2013266057directory flags set on non-directory inode
2013266058directory flags set on non-directory inode
2013266059directory flags set on non-directory inode
2013266060directory flags set on non-directory inode
2013266061directory flags set on non-directory inode
2013266062directory flags set on non-directory inode
2013266063directory flags set on non-directory inode
2013266064directory flags set on non-directory inode
2013266065directory flags set on non-directory inode
2013266066directory flags set on non-directory inode
2013266067directory flags set on non-directory inode
2013266068directory flags set on non-directory inode
2013266069directory flags set on non-directory inode
2013266070directory flags set on non-directory inode
2013266071directory flags set on non-directory inode
2013266072directory flags set on non-directory inode 2013266054, would
fix bad flags.
directory flags set on non-directory inode 2013266055, would fix bad flags.
directory flags set on non-directory inode 2013266056, would fix bad flags.
directory flags set on non-directory inode 2013266057, would fix bad flags.
directory flags set on non-directory inode 2013266058, would fix bad flags.
directory flags set on non-directory inode 2013266059, would fix bad flags.
directory flags set on non-directory inode 2013266060, would fix bad flags.
directory flags set on non-directory inode 2013266061, would fix bad flags.
directory flags set on non-directory inode 2013266062, would fix bad flags.
directory flags set on non-directory inode 2013266063, would fix bad flags.
directory flags set on non-directory inode 2013266064, would fix bad flags.
directory flags set on non-directory inode 2013266065, would fix bad flags.
directory flags set on non-directory inode 2013266066, would fix bad flags.
directory flags set on non-directory inode 2013266067, would fix bad flags.
directory flags set on non-directory inode 2013266068, would fix bad flags.
directory flags set on non-directory inode 2013266069, would fix bad flags.
directory flags set on non-directory inode 2013266070, would fix bad flags.
directory flags set on non-directory inode 2013266071, would fix bad flags.
directory flags set on non-directory inode 2013266072, would fix bad flags.
directory flags set on non-directory inode 2063534968directory flags
set on non-directory inode 2063534969directory flags set on
non-directory inode 2063534968, would fix bad flags.
directory flags set on non-directory inode 2063534969, would fix bad flags.
        - agno =3D 16
directory flags set on non-directory inode 2148008067directory flags
set on non-directory inode 2148008068directory flags set on
non-directory inode 2148008069directory flags set on non-directory
inode 2148008070directory flags set on non-directory inode
2148008071directory flags set on non-directory inode
2148008072directory flags set on non-directory inode
2148008073directory flags set on non-directory inode
2148008074directory flags set on non-directory inode
2148008075directory flags set on non-directory inode
2148008076directory flags set on non-directory inode
2148008077directory flags set on non-directory inode
2148008078directory flags set on non-directory inode
2148008079directory flags set on non-directory inode
2148008080directory flags set on non-directory inode
2148008081directory flags set on non-directory inode
2148008082directory flags set on non-directory inode
2148008083directory flags set on non-directory inode
2148008084directory flags set on non-directory inode
2148008085directory flags set on non-directory inode
2148008086directory flags set on non-directory inode
2148008087directory flags set on non-directory inode
2148008108directory flags set on non-directory inode 2148008067, would
fix bad flags.
directory flags set on non-directory inode 2148008068, would fix bad flags.
directory flags set on non-directory inode 2148008069, would fix bad flags.
directory flags set on non-directory inode 2148008070, would fix bad flags.
directory flags set on non-directory inode 2148008071, would fix bad flags.
directory flags set on non-directory inode 2148008072, would fix bad flags.
directory flags set on non-directory inode 2148008073, would fix bad flags.
directory flags set on non-directory inode 2148008074, would fix bad flags.
directory flags set on non-directory inode 2148008075, would fix bad flags.
directory flags set on non-directory inode 2148008076, would fix bad flags.
directory flags set on non-directory inode 2148008077, would fix bad flags.
directory flags set on non-directory inode 2148008078, would fix bad flags.
directory flags set on non-directory inode 2148008079, would fix bad flags.
directory flags set on non-directory inode 2148008080, would fix bad flags.
directory flags set on non-directory inode 2148008081, would fix bad flags.
directory flags set on non-directory inode 2148008082, would fix bad flags.
directory flags set on non-directory inode 2148008083, would fix bad flags.
directory flags set on non-directory inode 2148008084, would fix bad flags.
directory flags set on non-directory inode 2148008085, would fix bad flags.
directory flags set on non-directory inode 2148008086, would fix bad flags.
directory flags set on non-directory inode 2148008087, would fix bad flags.
directory flags set on non-directory inode 2148008108, would fix bad flags.
directory flags set on non-directory inode 2164206856directory flags
set on non-directory inode 2164206856, would fix bad flags.
directory flags set on non-directory inode 2164230017directory flags
set on non-directory inode 2164230017, would fix bad flags.
directory flags set on non-directory inode 2164245770directory flags
set on non-directory inode 2164245770, would fix bad flags.
imap claims a free inode 2164245771 is in use, would correct imap and
clear inode
directory flags set on non-directory inode 2164421864directory flags
set on non-directory inode 2164421865directory flags set on
non-directory inode 2164421870directory flags set on non-directory
inode 2164421864, would fix bad flags.
directory flags set on non-directory inode 2164421865, would fix bad flags.
directory flags set on non-directory inode 2164421870, would fix bad flags.
directory flags set on non-directory inode 2164460311directory flags
set on non-directory inode 2164460314directory flags set on
non-directory inode 2164460324directory flags set on non-directory
inode 2164460326directory flags set on non-directory inode
2164460327directory flags set on non-directory inode 2164460311, would
fix bad flags.
directory flags set on non-directory inode 2164460314, would fix bad flags.
directory flags set on non-directory inode 2164460324, would fix bad flags.
directory flags set on non-directory inode 2164460326, would fix bad flags.
directory flags set on non-directory inode 2164460327, would fix bad flags.
directory flags set on non-directory inode 2169091276directory flags
set on non-directory inode 2169091278directory flags set on
non-directory inode 2169091276, would fix bad flags.
directory flags set on non-directory inode 2169091278, would fix bad flags.
directory flags set on non-directory inode 2171109009directory flags
set on non-directory inode 2171109009, would fix bad flags.
directory flags set on non-directory inode 2172422296directory flags
set on non-directory inode 2172422296, would fix bad flags.
directory flags set on non-directory inode 2172429655directory flags
set on non-directory inode 2172429655, would fix bad flags.
directory flags set on non-directory inode 2172520942directory flags
set on non-directory inode 2172520944directory flags set on
non-directory inode 2172520942, would fix bad flags.
directory flags set on non-directory inode 2172520944, would fix bad flags.
        - agno =3D 17
directory flags set on non-directory inode 2281701505directory flags
set on non-directory inode 2281701506directory flags set on
non-directory inode 2281701507directory flags set on non-directory
inode 2281701511directory flags set on non-directory inode
2281701515directory flags set on non-directory inode
2281701521directory flags set on non-directory inode
2281701525directory flags set on non-directory inode
2281701532directory flags set on non-directory inode 2281701505, would
fix bad flags.
directory flags set on non-directory inode 2281701506, would fix bad flags.
directory flags set on non-directory inode 2281701507, would fix bad flags.
directory flags set on non-directory inode 2281701511, would fix bad flags.
directory flags set on non-directory inode 2281701515, would fix bad flags.
directory flags set on non-directory inode 2281701521, would fix bad flags.
directory flags set on non-directory inode 2281701525, would fix bad flags.
directory flags set on non-directory inode 2281701532, would fix bad flags.
directory flags set on non-directory inode 2283178073directory flags
set on non-directory inode 2283178075directory flags set on
non-directory inode 2283178077directory flags set on non-directory
inode 2283178078directory flags set on non-directory inode
2283178079directory flags set on non-directory inode
2283178080directory flags set on non-directory inode
2283178093directory flags set on non-directory inode
2283178094directory flags set on non-directory inode
2283178095directory flags set on non-directory inode
2283178096directory flags set on non-directory inode
2283178100directory flags set on non-directory inode
2283178102directory flags set on non-directory inode
2283178104directory flags set on non-directory inode
2283178105directory flags set on non-directory inode 2283178073, would
fix bad flags.
directory flags set on non-directory inode 2283178075, would fix bad flags.
directory flags set on non-directory inode 2283178077, would fix bad flags.
directory flags set on non-directory inode 2283178078, would fix bad flags.
directory flags set on non-directory inode 2283178079, would fix bad flags.
directory flags set on non-directory inode 2283178080, would fix bad flags.
directory flags set on non-directory inode 2283178093, would fix bad flags.
directory flags set on non-directory inode 2283178094, would fix bad flags.
directory flags set on non-directory inode 2283178095, would fix bad flags.
directory flags set on non-directory inode 2283178096, would fix bad flags.
directory flags set on non-directory inode 2283178100, would fix bad flags.
bad key in bmbt root (is 73434, would reset to 74194) in inode
2283178100 data fork
bad fwd (right) sibling pointer (saw 145202888 should be NULLDFSBNO)
Segmentation fault


For those interested in reproducing this, I uploaded a metadump of the fs h=
ere:
http://dl.free.fr/r8SF7380x (40MB compressed dump)
(please note that I didn't try to reproduce the problem with a
restored metadump)


Anisse

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
