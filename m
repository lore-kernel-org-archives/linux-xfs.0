Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q23BbFKS020607 for <xfs@oss.sgi.com>; Sat, 3 Mar 2012 05:37:16 -0600
Received: from mx0.pronet.com.pl (mx0.pronet.com.pl [193.108.35.26]) by
	cuda.sgi.com with ESMTP id 32unQU9v20r2D2XC for
	<xfs@oss.sgi.com>; Sat, 03 Mar 2012 03:37:12 -0800 (PST)
Subject: Re: XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
	fs/xfs/xfs_buf.c, line: 598
From: =?UTF-8?Q?Rafa=C5=82?= Kupka <kupson@kupson.net>
In-Reply-To: <20120302104348.GA22230@infradead.org>
References: <1330539626.7615.73.camel@utemp.mieszkanie>
	<20120302104348.GA22230@infradead.org>
Date: Sat, 03 Mar 2012 12:37:07 +0100
Message-ID: <1330774627.32457.24.camel@utemp.mieszkanie>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, 2012-03-02 at 05:43 -0500, Christoph Hellwig wrote:
Hello,

> From the trace this looks like we got incorrect results from xfs_imap,
> which got some fairly significant changes between the two kernels
> you tested.  Can you check if 2.6.36 shows this issue?  It's the first
> kernel that had these big changes in inode lookup.

I've tested more kernels and here are results (linus git tree, no
additional patches):
- v2.6.36 -- good
- v2.6.38 -- good
- v2.6.39 -- bad, I/O error log entry and locked processes:

Mar  2 20:13:58 goscie kernel: [  431.392301] XFS (vda2): I/O error occurre=
d: meta-data dev vda2 block 0xe6700       ("xfs_trans_read_buf") error 5 bu=
f count 8192
Mar  2 20:13:58 goscie kernel: [  431.427181] XFS (vda2): xfs_imap_to_bp: x=
fs_trans_read_buf() returned error 5.
Mar  2 20:13:59 goscie kernel: [  433.086049] XFS (vda2): I/O error occurre=
d: meta-data dev vda2 block 0xe6700       ("xfs_trans_read_buf") error 5 bu=
f count 8192
Mar  2 20:13:59 goscie kernel: [  433.088638] XFS (vda2): xfs_imap_to_bp: x=
fs_trans_read_buf() returned error 5.
Mar  2 20:16:47 goscie kernel: [  600.584162] INFO: task cron:718 blocked f=
or more than 120 seconds.
Mar  2 20:16:47 goscie kernel: [  600.585520] "echo 0 > /proc/sys/kernel/hu=
ng_task_timeout_secs" disables this message.
Mar  2 20:16:47 goscie kernel: [  600.587651] cron            D ffff8800174=
d2180     0   718      1 0x00020000
Mar  2 20:16:47 goscie kernel: [  600.589632]  ffff8800174d2180 00000000000=
00082 ffffffff8100e0d1 ffff88001822c7a0
Mar  2 20:16:47 goscie kernel: [  600.592651]  0000000000013d40 ffff8800138=
31fd8 ffff880013831fd8 0000000000013d40
Mar  2 20:16:47 goscie kernel: [  600.595718]  ffff8800174d2180 ffff8800138=
30010 ffff88001fc13d40 ffff88001821ed00
Mar  2 20:16:47 goscie kernel: [  600.598314] Call Trace:
Mar  2 20:16:47 goscie kernel: [  600.598640]  [<ffffffff8100e0d1>] ? sched=
_clock+0x5/0x8
Mar  2 20:16:47 goscie kernel: [  600.599099]  [<ffffffff8139166c>] ? sched=
ule_timeout+0x2d/0xd7
Mar  2 20:16:47 goscie kernel: [  600.599503]  [<ffffffff81391fab>] ? __dow=
n_common+0x92/0xe3
Mar  2 20:16:47 goscie kernel: [  600.599935]  [<ffffffff811d7ba0>] ? _xfs_=
buf_find+0x1ed/0x2c8
Mar  2 20:16:47 goscie kernel: [  600.600383]  [<ffffffff8105f3bc>] ? down+=
0x27/0x37
Mar  2 20:16:47 goscie kernel: [  600.600782]  [<ffffffff811d6365>] ? xfs_b=
uf_lock+0x64/0xb0
Mar  2 20:16:47 goscie kernel: [  600.601179]  [<ffffffff811d7ba0>] ? _xfs_=
buf_find+0x1ed/0x2c8
Mar  2 20:16:47 goscie kernel: [  600.601581]  [<ffffffff811d7cd6>] ? xfs_b=
uf_get+0x5b/0x14f
Mar  2 20:16:47 goscie kernel: [  600.601986]  [<ffffffff811d7de0>] ? xfs_b=
uf_read+0x16/0xbf
Mar  2 20:16:47 goscie kernel: [  600.602360]  [<ffffffff811ce10a>] ? xfs_t=
rans_read_buf+0x52/0x573
Mar  2 20:16:47 goscie kernel: [  600.602750]  [<ffffffff811b65ee>] ? xfs_i=
map_to_bp+0x47/0x206
Mar  2 20:16:47 goscie kernel: [  600.603171]  [<ffffffff811d6c56>] ? xfs_b=
uf_rele+0xfa/0x17a
Mar  2 20:16:47 goscie kernel: [  600.603567]  [<ffffffff811b9531>] ? xfs_i=
read+0x59/0x1cc
Mar  2 20:16:47 goscie kernel: [  600.603983]  [<ffffffff811b3727>] ? xfs_i=
get+0x3e4/0x611
Mar  2 20:16:47 goscie kernel: [  600.612400]  [<ffffffff811d0d80>] ? xfs_l=
ookup+0xaa/0xd9
Mar  2 20:16:47 goscie kernel: [  600.612757]  [<ffffffff811dc6f3>] ? xfs_v=
n_lookup+0x3d/0x7c
Mar  2 20:16:47 goscie kernel: [  600.613142]  [<ffffffff810fed3f>] ? d_all=
oc_and_lookup+0x43/0x60
Mar  2 20:16:47 goscie kernel: [  600.613611]  [<ffffffff8110061c>] ? walk_=
component+0x161/0x30c
Mar  2 20:16:47 goscie kernel: [  600.613967]  [<ffffffff81101683>] ? path_=
lookupat+0xad/0x33f
Mar  2 20:16:47 goscie kernel: [  600.614398]  [<ffffffff81033b5a>] ? updat=
e_cfs_shares+0x7c/0x149
Mar  2 20:16:47 goscie kernel: [  600.614779]  [<ffffffff81101933>] ? do_pa=
th_lookup+0x1e/0x9a
Mar  2 20:16:47 goscie kernel: [  600.615125]  [<ffffffff810ff44d>] ? getna=
me_flags+0x14f/0x1c6
Mar  2 20:16:47 goscie kernel: [  600.615496]  [<ffffffff811023df>] ? user_=
path_at+0x48/0x7a
Mar  2 20:16:47 goscie kernel: [  600.615857]  [<ffffffff8105e7f5>] ? hrtim=
er_cancel+0xc/0x16
Mar  2 20:16:47 goscie kernel: [  600.616220]  [<ffffffff81391de2>] ? do_na=
nosleep+0x77/0xae
Mar  2 20:16:47 goscie kernel: [  600.616583]  [<ffffffff811078e7>] ? dput+=
0x84/0xe8
Mar  2 20:16:47 goscie kernel: [  600.616909]  [<ffffffff810fa00b>] ? vfs_f=
statat+0x43/0x70
Mar  2 20:16:47 goscie kernel: [  600.617247]  [<ffffffff8102dbc0>] ? sys32=
_stat64+0x11/0x29
Mar  2 20:16:47 goscie kernel: [  600.617621]  [<ffffffff81399180>] ? cstar=
_dispatch+0x7/0x2e
Mar  2 20:16:47 goscie kernel: [  600.617984] INFO: task xfsdump:1849 block=
ed for more than 120 seconds.
Mar  2 20:16:47 goscie kernel: [  600.618346] "echo 0 > /proc/sys/kernel/hu=
ng_task_timeout_secs" disables this message.
Mar  2 20:16:47 goscie kernel: [  600.618964] xfsdump         D ffff8800178=
936e0     0  1849   1826 0x00020000
Mar  2 20:16:47 goscie kernel: [  600.619448]  ffff8800178936e0 00000000000=
00086 ffff880000000000 ffffffff8160b020
Mar  2 20:16:47 goscie kernel: [  600.620276]  0000000000013d40 ffff88000d8=
41fd8 ffff88000d841fd8 0000000000013d40
Mar  2 20:16:47 goscie kernel: [  600.621068]  ffff8800178936e0 ffff88000d8=
40010 ffffea000053c950 0000000000000008
Mar  2 20:16:47 goscie kernel: [  600.621814] Call Trace:
Mar  2 20:16:47 goscie kernel: [  600.622155]  [<ffffffff8139166c>] ? sched=
ule_timeout+0x2d/0xd7
Mar  2 20:16:47 goscie kernel: [  600.622509]  [<ffffffff811ce10a>] ? xfs_t=
rans_read_buf+0x52/0x573
Mar  2 20:16:47 goscie kernel: [  600.622888]  [<ffffffff8119a361>] ? xfs_b=
tree_check_sblock+0x64/0x15e
Mar  2 20:16:47 goscie kernel: [  600.623308]  [<ffffffff81391fab>] ? __dow=
n_common+0x92/0xe3
Mar  2 20:16:47 goscie kernel: [  600.623650]  [<ffffffff811d7ba0>] ? _xfs_=
buf_find+0x1ed/0x2c8
Mar  2 20:16:47 goscie kernel: [  600.624065]  [<ffffffff8105f3bc>] ? down+=
0x27/0x37
Mar  2 20:16:47 goscie kernel: [  600.624398]  [<ffffffff811d6365>] ? xfs_b=
uf_lock+0x64/0xb0
Mar  2 20:16:47 goscie kernel: [  600.624739]  [<ffffffff811d7ba0>] ? _xfs_=
buf_find+0x1ed/0x2c8
Mar  2 20:16:47 goscie kernel: [  600.625127]  [<ffffffff811d7cd6>] ? xfs_b=
uf_get+0x5b/0x14f
Mar  2 20:16:47 goscie kernel: [  600.625475]  [<ffffffff811d7de0>] ? xfs_b=
uf_read+0x16/0xbf
Mar  2 20:16:47 goscie kernel: [  600.625820]  [<ffffffff811ce10a>] ? xfs_t=
rans_read_buf+0x52/0x573
Mar  2 20:16:47 goscie kernel: [  600.626198]  [<ffffffff811b65ee>] ? xfs_i=
map_to_bp+0x47/0x206
Mar  2 20:16:47 goscie kernel: [  600.626550]  [<ffffffff811b9531>] ? xfs_i=
read+0x59/0x1cc
Mar  2 20:16:47 goscie kernel: [  600.626888]  [<ffffffff811b3727>] ? xfs_i=
get+0x3e4/0x611
Mar  2 20:16:47 goscie kernel: [  600.627277]  [<ffffffff811d3715>] ? kmem_=
alloc+0x28/0x9e
Mar  2 20:16:47 goscie kernel: [  600.627641]  [<ffffffff811bc59b>] ? xfs_b=
ulkstat_one_int+0x9a/0x318
Mar  2 20:16:47 goscie kernel: [  600.628000]  [<ffffffff8117f3b4>] ? xfs_b=
stime_store_compat+0x4d/0x4d
Mar  2 20:16:47 goscie kernel: [  600.628433]  [<ffffffff8117fb58>] ? xfs_b=
ulkstat_one_compat+0x17/0x1c
Mar  2 20:16:47 goscie kernel: [  600.628857]  [<ffffffff811bc350>] ? xfs_b=
ulkstat+0x58c/0x73d
Mar  2 20:16:47 goscie kernel: [  600.629220]  [<ffffffff8117fb41>] ? xfs_c=
ompat_fssetdm_by_handle+0xc7/0xc7
Mar  2 20:16:47 goscie kernel: [  600.629635]  [<ffffffff8118006a>] ? xfs_c=
ompat_ioc_bulkstat+0x162/0x1cf
Mar  2 20:16:47 goscie kernel: [  600.630080]  [<ffffffff8103680c>] ? task_=
rq_lock+0x47/0x7a
Mar  2 20:16:47 goscie kernel: [  600.630463]  [<ffffffff81180462>] ? xfs_f=
ile_compat_ioctl+0x38b/0x465
Mar  2 20:16:47 goscie kernel: [  600.630829]  [<ffffffff81030962>] ? __wak=
e_up_common+0x41/0x78
Mar  2 20:16:47 goscie kernel: [  600.631177]  [<ffffffff810366c2>] ? __wak=
e_up+0x35/0x46
Mar  2 20:16:47 goscie kernel: [  600.631537]  [<ffffffff812915c0>] ? pty_w=
rite+0x48/0x53
Mar  2 20:16:47 goscie kernel: [  600.631895]  [<ffffffff8103e770>] ? perf_=
event_task_sched_out+0x48/0x54
Mar  2 20:16:47 goscie kernel: [  600.632285]  [<ffffffff8128cc83>] ? n_tty=
_write+0x322/0x360
Mar  2 20:16:47 goscie kernel: [  600.632635]  [<ffffffff8112dec3>] ? compa=
t_sys_ioctl+0x1bb/0xfb4
Mar  2 20:16:47 goscie kernel: [  600.632993]  [<ffffffff810086b8>] ? __swi=
tch_to+0x1c9/0x288
Mar  2 20:16:47 goscie kernel: [  600.633340]  [<ffffffff810379f3>] ? pick_=
next_task_fair+0xf9/0x10a
Mar  2 20:16:47 goscie kernel: [  600.633707]  [<ffffffff8102602a>] ? pvclo=
ck_clocksource_read+0x46/0xb4
Mar  2 20:16:47 goscie kernel: [  600.634079]  [<ffffffff810622ff>] ? timek=
eeping_get_ns+0xe/0x2e
Mar  2 20:16:47 goscie kernel: [  600.634430]  [<ffffffff81062975>] ? getns=
timeofday+0x4d/0x80
Mar  2 20:16:47 goscie kernel: [  600.634778]  [<ffffffff810629f5>] ? do_ge=
ttimeofday+0x10/0x2e
Mar  2 20:16:47 goscie kernel: [  600.635136]  [<ffffffff81399180>] ? cstar=
_dispatch+0x7/0x2e

- git revision 243b422af9ea9af4ead07a8ad54c90d4f9b6081a -- good
It's one patch before "xfs: preallocation transactions do not need to be sy=
nchronous"

- git revision c5850150d0b9ae16840c5d9846f9d5a759996a15:
    Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs
    =

    * 'for-linus' of git://oss.sgi.com/xfs/xfs:
      xfs: stop using the page cache to back the buffer cache
      xfs: register the inode cache shrinker before quotachecks
      xfs: xfs_trans_read_buf() should return an error on failure
      xfs: introduce inode cluster buffer trylocks for xfs_iflush
      vmap: flush vmap aliases when mapping fails
      xfs: preallocation transactions do not need to be synchronous
    =

Hung xfsdump (only?) without any additional log entries
(CONFIG_XFS_DEBUG is set):

Mar  3 12:05:57 goscie kernel: [  960.816216] INFO: task xfsdump:1519 block=
ed for more than 120 seconds.
Mar  3 12:05:57 goscie kernel: [  960.818113] "echo 0 > /proc/sys/kernel/hu=
ng_task_timeout_secs" disables this message.
Mar  3 12:05:57 goscie kernel: [  960.820223] xfsdump         D ffff88001e1=
96950     0  1519   1490 0x00020000
Mar  3 12:05:57 goscie kernel: [  960.821572]  ffff88001e196950 00000000000=
00086 ffff880000000000 ffffffff8160b020
Mar  3 12:05:57 goscie kernel: [  960.823618]  0000000000013d00 ffff8800099=
03fd8 ffff880009903fd8 0000000000013d00
Mar  3 12:05:57 goscie kernel: [  960.825707]  ffff88001e196950 ffff8800099=
02010 0000000100000000 0000000000000008
Mar  3 12:05:57 goscie kernel: [  960.827746] Call Trace:
Mar  3 12:05:57 goscie kernel: [  960.828672]  [<ffffffff81391493>] ? sched=
ule_timeout+0x2d/0xd7
Mar  3 12:05:57 goscie kernel: [  960.829937]  [<ffffffff811ce4d2>] ? xfs_t=
rans_read_buf+0x52/0x573
Mar  3 12:05:57 goscie kernel: [  960.831118]  [<ffffffff8119a8a5>] ? xfs_b=
tree_check_sblock+0x64/0x15e
Mar  3 12:05:57 goscie kernel: [  960.831459]  [<ffffffff81391dd2>] ? __dow=
n_common+0x92/0xe3
Mar  3 12:05:57 goscie kernel: [  960.831780]  [<ffffffff811d7fab>] ? _xfs_=
buf_find+0x1ed/0x2c8
Mar  3 12:05:57 goscie kernel: [  960.832125]  [<ffffffff8105f2fc>] ? down+=
0x27/0x37
Mar  3 12:05:57 goscie kernel: [  960.832424]  [<ffffffff811d6776>] ? xfs_b=
uf_lock+0x7c/0xc8
Mar  3 12:05:57 goscie kernel: [  960.832739]  [<ffffffff811d7fab>] ? _xfs_=
buf_find+0x1ed/0x2c8
Mar  3 12:05:57 goscie kernel: [  960.833068]  [<ffffffff811d80e1>] ? xfs_b=
uf_get+0x5b/0x14f
Mar  3 12:05:57 goscie kernel: [  960.833412]  [<ffffffff811d81eb>] ? xfs_b=
uf_read+0x16/0xbf
Mar  3 12:05:57 goscie kernel: [  960.833737]  [<ffffffff811ce4d2>] ? xfs_t=
rans_read_buf+0x52/0x573
Mar  3 12:05:57 goscie kernel: [  960.834071]  [<ffffffff811b6b2a>] ? xfs_i=
map_to_bp+0x47/0x206
Mar  3 12:05:57 goscie kernel: [  960.834396]  [<ffffffff811b9a6d>] ? xfs_i=
read+0x59/0x1cc
Mar  3 12:05:57 goscie kernel: [  960.834706]  [<ffffffff811b3c63>] ? xfs_i=
get+0x3e4/0x611
Mar  3 12:05:57 goscie kernel: [  960.835022]  [<ffffffff811d3b15>] ? kmem_=
alloc+0x60/0x9e
Mar  3 12:05:57 goscie kernel: [  960.835338]  [<ffffffff811bca6b>] ? xfs_b=
ulkstat_one_int+0x9a/0x318
Mar  3 12:05:57 goscie kernel: [  960.835677]  [<ffffffff8117f8d4>] ? xfs_b=
stime_store_compat+0x4d/0x4d
Mar  3 12:05:57 goscie kernel: [  960.836029]  [<ffffffff81180078>] ? xfs_b=
ulkstat_one_compat+0x17/0x1c
Mar  3 12:05:57 goscie kernel: [  960.836377]  [<ffffffff811bc820>] ? xfs_b=
ulkstat+0x58c/0x73d
Mar  3 12:05:57 goscie kernel: [  960.836697]  [<ffffffff81180061>] ? xfs_c=
ompat_fssetdm_by_handle+0xc7/0xc7
Mar  3 12:05:57 goscie kernel: [  960.837049]  [<ffffffff8118058a>] ? xfs_c=
ompat_ioc_bulkstat+0x162/0x1cf
Mar  3 12:05:57 goscie kernel: [  960.837439]  [<ffffffff810b1d7a>] ? gener=
ic_file_aio_read+0x58d/0x5a2
Mar  3 12:05:57 goscie kernel: [  960.837790]  [<ffffffff81180982>] ? xfs_f=
ile_compat_ioctl+0x38b/0x465
Mar  3 12:05:57 goscie kernel: [  960.838132]  [<ffffffff811b3219>] ? xfs_i=
unlock+0xea/0x147
Mar  3 12:05:57 goscie kernel: [  960.838467]  [<ffffffff811d1221>] ? xfs_f=
ree_eofblocks+0xaa/0x222
Mar  3 12:05:57 goscie kernel: [  960.838810]  [<ffffffff8112e413>] ? compa=
t_sys_ioctl+0x1bb/0xfb4
Mar  3 12:05:57 goscie kernel: [  960.846656]  [<ffffffff8102602a>] ? pvclo=
ck_clocksource_read+0x46/0xb4
Mar  3 12:05:57 goscie kernel: [  960.847015]  [<ffffffff8106222f>] ? timek=
eeping_get_ns+0xe/0x2e
Mar  3 12:05:57 goscie kernel: [  960.847343]  [<ffffffff810628a5>] ? getns=
timeofday+0x4d/0x80
Mar  3 12:05:57 goscie kernel: [  960.847664]  [<ffffffff81062925>] ? do_ge=
ttimeofday+0x10/0x2e
Mar  3 12:05:57 goscie kernel: [  960.847994]  [<ffffffff81398fc0>] ? cstar=
_dispatch+0x7/0x2e

I don't know if it's the same bug - there is no assertion nor I/O error
log entry...

Regards,
Rafa=B3 Kupka

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
