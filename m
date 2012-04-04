Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q349K7vE118924 for <xfs@oss.sgi.com>; Wed, 4 Apr 2012 04:20:07 -0500
Received: from mx0.pronet.com.pl (mx0.pronet.com.pl [193.108.35.26]) by
	cuda.sgi.com with ESMTP id yDNRa7825jGuccCp for
	<xfs@oss.sgi.com>; Wed, 04 Apr 2012 02:20:03 -0700 (PDT)
Subject: Re: XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
	fs/xfs/xfs_buf.c, line: 598
From: =?UTF-8?Q?Rafa=C5=82?= Kupka <kupson@kupson.net>
In-Reply-To: <1333123361.30824.19.camel@utemp.mieszkanie>
References: <1330539626.7615.73.camel@utemp.mieszkanie>
	<20120302104348.GA22230@infradead.org>
	<1330774627.32457.24.camel@utemp.mieszkanie>
	<20120303114413.GA18748@infradead.org>
	<1330983612.28645.18.camel@utemp.mieszkanie>
	<20120306203020.GG3592@dastard>
	<1331233817.20679.18.camel@utemp.mieszkanie>
	<1332777925.14696.194.camel@utemp.mieszkanie>
	<20120327032843.GV5091@dastard>  <20120327101750.GA5091@dastard>
	<1333123361.30824.19.camel@utemp.mieszkanie>
Date: Wed, 04 Apr 2012 11:19:57 +0200
Message-ID: <1333531197.5109.114.camel@utemp.mieszkanie>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, 2012-03-30 at 18:02 +0200, Rafa=B3 Kupka wrote:
> On Tue, 2012-03-27 at 21:17 +1100, Dave Chinner wrote:
Hi,

I've collected more data.

> I've applied this patch to linus/v3.3 kernel. There is no more I/O
> errors but xfsdump still hangs.
[other details in my previous e-mail]

This new code is executed but broken struct xfs_buf is never reclaimed
from the cache:

         xfsdump-1455  [000] .... 40888.509350: xfs_perag_get: dev 254:2 ag=
no 1 refcount 441 caller _xfs_buf_find
         xfsdump-1455  [000] .... 40888.509355: xfs_perag_put: dev 254:2 ag=
no 1 refcount 440 caller _xfs_buf_find
         xfsdump-1455  [000] .... 40888.509356: xfs_buf_trylock: dev 254:2 =
bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|ASYNC=
|BROKEN|TRYLOCK|PAGES caller _xfs_buf_find
         xfsdump-1455  [000] .... 40888.509357: xfs_buf_find_broken: dev 25=
4:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|L=
OCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1455  [000] .... 40888.509358: xfs_buf_unlock: dev 254:2 b=
no 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 1 flags READ|ASYNC|=
BROKEN|TRYLOCK|PAGES caller xfs_buf_relse
         xfsdump-1455  [000] .... 40888.509359: xfs_buf_rele: dev 254:2 bno=
 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 1 flags READ|ASYNC|BR=
OKEN|TRYLOCK|PAGES caller _xfs_buf_find
         xfsdump-1455  [000] .... 40888.513340: xfs_perag_get: dev 254:2 ag=
no 1 refcount 441 caller _xfs_buf_find
         xfsdump-1455  [000] .... 40888.513345: xfs_perag_put: dev 254:2 ag=
no 1 refcount 440 caller _xfs_buf_find
         xfsdump-1455  [000] .... 40888.513346: xfs_buf_trylock: dev 254:2 =
bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|ASYNC=
|BROKEN|TRYLOCK|PAGES caller _xfs_buf_find
         xfsdump-1455  [000] .... 40888.513347: xfs_buf_find_broken: dev 25=
4:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|L=
OCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1455  [000] .... 40888.513348: xfs_buf_unlock: dev 254:2 b=
no 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 1 flags READ|ASYNC|=
BROKEN|TRYLOCK|PAGES caller xfs_buf_relse
         xfsdump-1455  [000] .... 40888.513349: xfs_buf_rele: dev 254:2 bno=
 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 1 flags READ|ASYNC|BR=
OKEN|TRYLOCK|PAGES caller _xfs_buf_find
         xfsdump-1455  [000] .... 40888.517336: xfs_perag_get: dev 254:2 ag=
no 1 refcount 441 caller _xfs_buf_find
         xfsdump-1455  [000] .... 40888.517341: xfs_perag_put: dev 254:2 ag=
no 1 refcount 440 caller _xfs_buf_find
         xfsdump-1455  [000] .... 40888.517342: xfs_buf_trylock: dev 254:2 =
bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|ASYNC=
|BROKEN|TRYLOCK|PAGES caller _xfs_buf_find
         xfsdump-1455  [000] .... 40888.517343: xfs_buf_find_broken: dev 25=
4:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|L=
OCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1455  [000] .... 40888.517344: xfs_buf_unlock: dev 254:2 b=
no 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 1 flags READ|ASYNC|=
BROKEN|TRYLOCK|PAGES caller xfs_buf_relse
         xfsdump-1455  [000] .... 40888.517345: xfs_buf_rele: dev 254:2 bno=
 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 1 flags READ|ASYNC|BR=
OKEN|TRYLOCK|PAGES caller _xfs_buf_find

As I lurked to XFS mailing list I see that better fix is to never put
half-initialized buf into rbtree.
http://article.gmane.org/gmane.comp.file-systems.xfs.general/44356

I've tried another simple patch. If these broken XBF_READ_AHEAD buffers
can be picked up by non read-ahead code (as long as it's in rbtree)
maybe it's not reasonable to treat them specially in
xfs_buf_allocate_memory().

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e24b320..d18c070 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -341,11 +341,13 @@ use_alloc_page:
 retry:
                page =3D alloc_page(gfp_mask);
                if (unlikely(page =3D=3D NULL)) {
+                       /*
                        if (flags & XBF_READ_AHEAD) {
                                bp->b_page_count =3D i;
                                error =3D ENOMEM;
                                goto out_free_pages;
                        }
+                        */
 =

                        /*
                         * This could deadlock.

Patch is probably broken by Evolution but you can see what I've done.

XFS patched this way survived my test for a long(er) time without hangs.

Retries counter in /proc/fs/xfs/stat raises slowly as expected.
"buf 13869637 753868 13946555 17174 8848657 92215 555 146160 90802"

There is one "XFS: possible memory allocation deadlock" message as you
can see in kernel logs below.

Yet there is another (really?) assertion:
Apr  4 02:58:22 goscie kernel: [    5.617480] sshd (892): /proc/892/oom_adj=
 is deprecated, please use /proc/892/oom_score_adj instead.
Apr  4 04:35:14 goscie kernel: [ 5817.096240] XFS: possible memory allocati=
on deadlock in xfs_buf_allocate_memory (mode:0x1200)
Apr  4 04:41:24 goscie kernel: [ 6187.984118] XFS: Assertion failed: ((ifla=
gs & BMV_IF_DELALLOC) !=3D 0) || (map[i].br_startblock !=3D DELAYSTARTBLOCK=
), file: fs/xfs/xfs_bmap.c, line: 5612
Apr  4 04:41:24 goscie kernel: [ 6187.986603] ------------[ cut here ]-----=
-------
Apr  4 04:41:24 goscie kernel: [ 6187.987608] kernel BUG at fs/xfs/xfs_mess=
age.c:101!
Apr  4 04:41:24 goscie kernel: [ 6187.988050] invalid opcode: 0000 [#1] SMP
Apr  4 04:41:24 goscie kernel: [ 6187.988050] CPU 0
Apr  4 04:41:24 goscie kernel: [ 6187.988050] Modules linked in: loop tpm_t=
is psmouse i2c_piix4 tpm i2c_core evdev pcspkr tpm_bios serio_raw processor=
 thermal_sys button xfs sg ata_generic ata_piix libata scsi_mod virtio_net =
[last unloaded: scsi_wait_scan]
Apr  4 04:41:24 goscie kernel: [ 6187.988050]
Apr  4 04:41:24 goscie kernel: [ 6187.988050] Pid: 3019, comm: xfsdump Not =
tainted 3.3.0xfsdump1-00001-g26e1ccc-dirty #4 Bochs Bochs
Apr  4 04:41:24 goscie kernel: [ 6187.988050] RIP: 0010:[<ffffffffa009043e>=
]  [<ffffffffa009043e>] assfail+0x1d/0x23 [xfs]
Apr  4 04:41:24 goscie kernel: [ 6187.988050] RSP: 0000:ffff880011c71af8  E=
FLAGS: 00010296
Apr  4 04:41:24 goscie kernel: [ 6187.988050] RAX: 00000000000000a0 RBX: ff=
ff88000317b6a0 RCX: 0000000007b707b7
Apr  4 04:41:24 goscie kernel: [ 6187.988050] RDX: 0000000000000000 RSI: 00=
00000000000046 RDI: 0000000000000246
Apr  4 04:41:24 goscie kernel: [ 6187.988050] RBP: ffff880011c71bb8 R08: 00=
00000000000000 R09: ffffffff8167d50a
Apr  4 04:41:24 goscie kernel: [ 6187.988050] R10: 0000000000000000 R11: ff=
ff88001780d000 R12: 0000000000000000
Apr  4 04:41:24 goscie kernel: [ 6187.988050] R13: ffff8800153080f0 R14: ff=
ff880003130800 R15: ffff8800031cd840
Apr  4 04:41:24 goscie kernel: [ 6187.988050] FS:  0000000000000000(0000) G=
S:ffff880017c00000(0063) knlGS:00000000f765c700
Apr  4 04:41:24 goscie kernel: [ 6187.988050] CS:  0010 DS: 002b ES: 002b C=
R0: 0000000080050033
Apr  4 04:41:24 goscie kernel: [ 6187.988050] CR2: 00000000f586541c CR3: 00=
00000012155000 CR4: 00000000000006f0
Apr  4 04:41:24 goscie kernel: [ 6187.988050] DR0: 0000000000000000 DR1: 00=
00000000000000 DR2: 0000000000000000
Apr  4 04:41:24 goscie kernel: [ 6187.988050] DR3: 0000000000000000 DR6: 00=
000000ffff0ff0 DR7: 0000000000000400
Apr  4 04:41:24 goscie kernel: [ 6187.988050] Process xfsdump (pid: 3019, t=
hreadinfo ffff880011c70000, task ffff8800120dd750)
Apr  4 04:41:24 goscie kernel: [ 6187.988050] Stack:
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  ffff880011c71bb8 ffffffffa00=
a6fdc ffff8800031cd988 00000005115338c0
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  0000001000000005 00000000000=
00008 ffff88000317b600 000000000000c000
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  ffff880015308000 00000008000=
00000 ffffffffa008b2d2 000000008115ecf6
Apr  4 04:41:24 goscie kernel: [ 6187.988050] Call Trace:
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffffa00a6fdc>] ? xfs_g=
etbmap+0x45b/0x5ae [xfs]
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffffa008b2d2>] ? xfs_o=
pen_by_handle+0x182/0x182 [xfs]
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffffa008b3f0>] ? xfs_i=
oc_getbmapx+0x4e/0x85 [xfs]
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffffa008c8f6>] ? xfs_f=
ile_ioctl+0x43f/0x751 [xfs]
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffff810be2f2>] ? __loc=
k_page_killable+0x5d/0x63
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffff81106cc7>] ? __den=
try_open+0x1d6/0x2c8
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffff81105ca6>] ? fd_in=
stall+0x27/0x4f
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffffa008b2ad>] ? xfs_o=
pen_by_handle+0x15d/0x182 [xfs]
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffffa00eb0f7>] ? xfs_f=
ile_compat_ioctl+0x355/0x486 [xfs]
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffffa008a3b7>] ? xfs_i=
unlock+0xea/0x146 [xfs]
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffffa009509f>] ? xfs_f=
ree_eofblocks+0xa5/0x217 [xfs]
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffff81142365>] ? compa=
t_sys_ioctl+0x1a5/0xe28
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffff81071d92>] ? timek=
eeping_get_ns+0xd/0x2a
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffff810729fa>] ? getns=
timeofday+0x4d/0x80
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffff81072a7a>] ? do_ge=
ttimeofday+0x10/0x2f
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  [<ffffffff81361a36>] ? cstar=
_dispatch+0x7/0x21
Apr  4 04:41:24 goscie kernel: [ 6187.988050] Code: 89 64 24 28 e8 86 fc ff=
 ff 48 83 c4 68 c3 48 89 f1 41 89 d0 48 83 ec 08 48 89 fa 48 c7 c6 7b 6f 0f=
 a0 31 ff 31 c0 e8 8d ff ff ff <0f> 0b eb fe 90 90 45 31 c0 31 c0 48 83 7f =
38 00 75 67 e9 bd 00
Apr  4 04:41:24 goscie kernel: [ 6187.988050] RIP  [<ffffffffa009043e>] ass=
fail+0x1d/0x23 [xfs]
Apr  4 04:41:24 goscie kernel: [ 6187.988050]  RSP <ffff880011c71af8>
Apr  4 04:41:24 goscie kernel: [ 6188.005126] ---[ end trace 00a3f5114a46a7=
b5 ]---

Should I investigate further or it is related to my (broken) patch?

Best Regards,
Rafal Kupka

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
