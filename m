Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1TJEtZE040028 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 13:14:55 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id rDF9Vl86Pj98iIwZ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 11:14:48 -0800 (PST)
Date: Wed, 29 Feb 2012 20:14:45 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: Soft lockup problem
Message-ID: <20120229191445.GB20922@quack.suse.cz>
References: <CAOgv-ziomS-+ML0Xb4oSoWTjzkG8BBBQcMjXwn7rjQV2pFtQ6Q@mail.gmail.com>
	<20120206225122.GF24840@quack.suse.cz>
	<CAOgv-zjjwoTnN7=a1kRHL_yVRzc5w3BfUfsY0_X61-rjzJJ2Hg@mail.gmail.com>
	<20120207165452.GA1043@quack.suse.cz>
	<CAOgv-zi74c9DPm8rQc2zYE=xLyMCU18g845oT02TeP5oZsJaQA@mail.gmail.com>
	<CAOgv-zjF3YSLuGu0p0xkCp5ZfWu2H1Xg8aQ7xcpCQqWOdwh1aA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOgv-zjF3YSLuGu0p0xkCp5ZfWu2H1Xg8aQ7xcpCQqWOdwh1aA@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Gerard Saraber <gsaraber@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

  Hi,

On Wed 29-02-12 12:20:10, Gerard Saraber wrote:
> I have another update, after rebooting two days ago,
> it's now running :
> Linux xenbox 3.2.5 #1 SMP Tue Feb 7 13:51:06 CST 2012 x86_64 Intel(R)
> Xeon(R) CPU 5140 @ 2.33GHz GenuineIntel GNU/Linux
> =

> I noticed high load on the machine, and another dump in the logs about
> stuck processes, so I ran ctrl+alt+sysrq + w and got this log
> [attached below]
> =

> I hope finally getting the right log will be helpful!
  Thanks for the traces. I was looking at them and I don't see the
immediate problem. There is a task (kswapd0) reclaiming XFS inodes and
waiting for IO to complete. Quite some other tasks are waiting in
xfs_reclaim_inodes_ag() for reclaim mutex. Since some of them are called
from NFS code (e.g. nfs4_process_open1()), that seems to be a reason why
other tasks are blocked in nfs4_lock_state().

So all in all it seems like some problem in how mm does reclaim or we are
inefficient doing inode reclaim in XFS or for some reason the IO is too
slow. As a result we are low on memory and things go bad.  Do you know with
which kernel version the problem started to appear?

								Honza


> On Mon, Feb 27, 2012 at 8:38 AM, Gerard Saraber <gsaraber@gmail.com> wrot=
e:
> > Hi everyone,
> > It finally did it again, it took longer then I expected, it also
> > locked itself up so bad that I couldn't get into it to hit
> > ctrl+alt+sysrq+w ..
> > I had turned on the debugging feature that automatically logs the hung
> > tasks, and I've attached the log below, I hope it's helpful.
> >
> > I was running 3.2.4 from kernel.org on a 4 core Xeon machine:
> > model name =A0 =A0 =A0: Intel(R) Xeon(R) CPU =A0 =A0 =A0 =A0 =A0 =A0514=
0 =A0@ 2.33GHz
> >
> > 6GB Ram
> >
> > 2x Intel 80003ES2LAN Gigabit Ethernet Controllers bonded together
> > 2 LSI SAS controllers:
> > 08:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068E
> > PCI-Express Fusion-MPT SAS (rev 08)
> > 0a:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS
> > 2008 [Falcon] (rev 03)
> >
> > 16 =A0drives in a mix of 2 and 3TB, in 3 raid5 arrays and combined
> > together with LVM
> > /dev/mapper/pool-main =A0 23T =A0 12T =A0 11T =A052%
> > for a 23TB volume formatted with XFS.
> >
> > The root partition is ext4 on an older SATA drive, the reason I bring
> > this up is that when I hit (on a whim) ctrl+sysrq+J that is supposed
> > to unfreeze frozen filesystems, the console started dumping lots of
> > messages about attempting to unfreeze /dev/sda3 [my root partition] so
> > maybe there's a problem with my sda drive.
> > But I get no i/o or other errors in my logs at all. I monitor all
> > drives with smartd to head off any drive failures before they happen
> > and it seems to think sda is fine.
> >
> > Hopefully my attached log helps.
> > I appreciate any input, also please call me an idiot if I'm missing
> > something obvious.
> >
> > -Gerard Saraber
> >
> >
> > On Tue, Feb 7, 2012 at 10:54 AM, Jan Kara <jack@suse.cz> wrote:
> >> On Tue 07-02-12 10:35:37, Gerard Saraber wrote:
> >>> On Mon, Feb 6, 2012 at 4:51 PM, Jan Kara <jack@suse.cz> wrote:
> >>> > On Mon 06-02-12 09:40:45, Gerard Saraber wrote:
> >>> >> Greetings everyone,
> >>> >> I've been having a bit of a problem since upgrading to the linux 3=
.x
> >>> >> series, I have a machine that we're using as a NAS that runs vario=
us
> >>> >> rsync processes (mostly at night), lately after a day or two, I wi=
ll
> >>> >> come in in the morning to a load average of 49, but the machine not
> >>> >> really doing anything, when trying to run 'dstat' the command just
> >>> >> hung with no output at all. there were no errors in the logs, or e=
ven
> >>> >> anything that would vaguely point at anything I could work with.
> >>> >> So needing to get the machine back to work I attempted to reboot it
> >>> >> "shutdown -r now" on console... it gives a nice message saying it's
> >>> >> going to reboot, but nothing ever happens.. the only way to reboot=
 it
> >>> >> is by using ctrl + alt + sysrq + b. after which the machine reboots
> >>> >> and the raid array comes back clean.
> >>> >>
> >>> >> I'm not sure how to troubleshoot this, any pointers would be appre=
ciated.
> >>> >>
> >>> >> I'm compiling 3.2.4 at the moment and found a bunch of possibly us=
eful
> >>> >> options in the kernel debugging section:
> >>> >> detect hard/soft lockups and detect hung tasks, maybe it'll give me
> >>> >> something more to go on.
> >>> >>
> >>> >> Some details about the machine:
> >>> >> Linux xenbox 3.2.2 #1 SMP Sun Jan 29 10:28:22 CST 2012 x86_64 Inte=
l(R)
> >>> >> Xeon(R) CPU 5140 @ 2.33GHz GenuineIntel GNU/Linux
> >>> >> It has 3 software raid arrays (2 x 5 drives and 1 x 4 drives) LVM'=
ed
> >>> >> together into a 23TB XFS filesystem.
> >>> >> 6GB memory and a pair of Intel Gigabit ethernet controllers bonded=
 together.
> >>> > =A0Hmm, might be some deadlock in the filesystem. Adding XFS guys t=
o CC.
> >>> > Can you run 'echo w >/proc/sysrq-trigger' and post output of dmesg =
here?
> >>> >
> >>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> >>> > --
> >>> > Jan Kara <jack@suse.cz>
> >>> > SUSE Labs, CR
> >>>
> >>> Thanks for the quick reply,
> >>> the machine is running good at the moment so I'm not sure if the
> >>> output helps, but here it is:
> >>> [I'll also be sure to grab this log the next time it locks]
> >> =A0Yeah. Sorry, I was not clear but I meant you should grab the traces=
 when
> >> the machine locks up again...
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> >>
> >> --
> >> Jan Kara <jack@suse.cz>
> >> SUSE Labs, CR

> Feb 29 12:05:38 [kernel] [186732.828746] SysRq : Show Blocked State
> Feb 29 12:05:38 [kernel] [186732.828829]   task                        PC=
 stack   pid father
> Feb 29 12:05:38 [kernel] [186732.828833] kthreadd        D 00000000000000=
00  2560     2      0 0x00000000
> Feb 29 12:05:38 [kernel] [186732.828839]  ffff8801b78836c0 00000000000000=
46 ffffffff8189813a 0000000000000001
> Feb 29 12:05:38 [kernel] [186732.828845]  ffff880100000000 00000000001d28=
80 ffff8801b7879340 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.828850]  ffff8801b7883fd8 ffff8801b78820=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.828856] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.828865]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.828869]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.828873]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.828876]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.828881]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.828885]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.828888]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.828894]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.828900]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.828904]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.828907]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.828911]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.828916]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.828920]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.828924]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.828928]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.828933]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.828937]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.828941]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.828945]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.828949]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.828959]  [<ffffffff810915e9>] do_fork+0x=
59/0x350
> Feb 29 12:05:38 [kernel] [186732.828963]  [<ffffffff810ce685>] ? trace_ha=
rdirqs_on_caller+0x105/0x190
> Feb 29 12:05:38 [kernel] [186732.828967]  [<ffffffff810ce71d>] ? trace_ha=
rdirqs_on+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.828971]  [<ffffffff8107d350>] ? finish_t=
ask_switch+0x80/0x110
> Feb 29 12:05:38 [kernel] [186732.828974]  [<ffffffff810bb325>] ? sched_cl=
ock_local+0x25/0x90
> Feb 29 12:05:38 [kernel] [186732.828979]  [<ffffffff8104a54c>] kernel_thr=
ead+0x6c/0x70
> Feb 29 12:05:38 [kernel] [186732.828984]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.828988]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.828991]  [<ffffffff810b4cc2>] kthreadd+0=
x122/0x160
> Feb 29 12:05:38 [kernel] [186732.828995]  [<ffffffff810ce685>] ? trace_ha=
rdirqs_on_caller+0x105/0x190
> Feb 29 12:05:38 [kernel] [186732.828998]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829002]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829006]  [<ffffffff810b4ba0>] ? tsk_fork=
_get_node+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829009]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829015] kswapd0         D 00000000000000=
00  2248   590      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829020]  ffff8801b70872c0 00000000000000=
46 ffffffff8189813a 0000000000000006
> Feb 29 12:05:38 [kernel] [186732.829025]  0000000000000000 00000000001d28=
80 ffff8801b7a1b9c0 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829030]  ffff8801b7087fd8 ffff8801b70860=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829035] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829039]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829042]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829048]  [<ffffffff816cb13d>] md_flush_r=
equest+0x7d/0x140
> Feb 29 12:05:38 [kernel] [186732.829052]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829056]  [<ffffffff816c3c28>] make_reque=
st+0x428/0x430
> Feb 29 12:05:38 [kernel] [186732.829059]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829063]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829066]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829070]  [<ffffffff816cf14f>] ? md_make_=
request+0x13f/0x2b0
> Feb 29 12:05:38 [kernel] [186732.829074]  [<ffffffff816da24b>] ? dm_reque=
st+0x13b/0x230
> Feb 29 12:05:38 [kernel] [186732.829080]  [<ffffffff816cf078>] ? md_make_=
request+0x68/0x2b0
> Feb 29 12:05:38 [kernel] [186732.829084]  [<ffffffff810b9d5e>] ? up_read+=
0x1e/0x40
> Feb 29 12:05:38 [kernel] [186732.829087]  [<ffffffff816da24b>] ? dm_reque=
st+0x13b/0x230
> Feb 29 12:05:38 [kernel] [186732.829091]  [<ffffffff816da13e>] ? dm_reque=
st+0x2e/0x230
> Feb 29 12:05:38 [kernel] [186732.829095]  [<ffffffff8145c722>] generic_ma=
ke_request+0xc2/0x100
> Feb 29 12:05:38 [kernel] [186732.829099]  [<ffffffff8145d4d5>] submit_bio=
+0x75/0xf0
> Feb 29 12:05:38 [kernel] [186732.829104]  [<ffffffff81341a82>] _xfs_buf_i=
oapply+0x162/0x1d0
> Feb 29 12:05:38 [kernel] [186732.829108]  [<ffffffff81394111>] ? xlog_bds=
trat+0x21/0x60
> Feb 29 12:05:38 [kernel] [186732.829111]  [<ffffffff81341bca>] xfs_buf_io=
request+0x4a/0xa0
> Feb 29 12:05:38 [kernel] [186732.829115]  [<ffffffff81394111>] xlog_bdstr=
at+0x21/0x60
> Feb 29 12:05:38 [kernel] [186732.829118]  [<ffffffff81395d9e>] xlog_sync+=
0x23e/0x3d0
> Feb 29 12:05:38 [kernel] [186732.829122]  [<ffffffff81396793>] xlog_state=
_release_iclog+0xe3/0xf0
> Feb 29 12:05:38 [kernel] [186732.829125]  [<ffffffff81397258>] xlog_write=
+0x618/0x780
> Feb 29 12:05:38 [kernel] [186732.829129]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829132]  [<ffffffff81398830>] ? xlog_cil=
_push+0x1c0/0x3b0
> Feb 29 12:05:38 [kernel] [186732.829136]  [<ffffffff813988a9>] xlog_cil_p=
ush+0x239/0x3b0
> Feb 29 12:05:38 [kernel] [186732.829139]  [<ffffffff81399184>] xlog_cil_f=
orce_lsn+0x114/0x120
> Feb 29 12:05:38 [kernel] [186732.829143]  [<ffffffff81397871>] _xfs_log_f=
orce_lsn+0x51/0x2f0
> Feb 29 12:05:38 [kernel] [186732.829147]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829151]  [<ffffffff81386675>] ? xfs_iunp=
in_wait+0x45/0xd0
> Feb 29 12:05:38 [kernel] [186732.829155]  [<ffffffff81397b23>] xfs_log_fo=
rce_lsn+0x13/0x40
> Feb 29 12:05:38 [kernel] [186732.829158]  [<ffffffff8189b68b>] ? _raw_spi=
n_unlock_irqrestore+0x3b/0x70
> Feb 29 12:05:38 [kernel] [186732.829162]  [<ffffffff813846f5>] xfs_iunpin=
_nowait+0x35/0x70
> Feb 29 12:05:38 [kernel] [186732.829165]  [<ffffffff81386675>] xfs_iunpin=
_wait+0x45/0xd0
> Feb 29 12:05:38 [kernel] [186732.829170]  [<ffffffff8107cab6>] ? try_wait=
_for_completion+0x46/0x60
> Feb 29 12:05:38 [kernel] [186732.829173]  [<ffffffff81352274>] xfs_reclai=
m_inode+0xb4/0x2c0
> Feb 29 12:05:38 [kernel] [186732.829177]  [<ffffffff81352fdf>] xfs_reclai=
m_inodes_ag+0x23f/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829180]  [<ffffffff81352e78>] ? xfs_recl=
aim_inodes_ag+0xd8/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829188]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829192]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829195]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829199]  [<ffffffff81141fda>] kswapd+0x7=
0a/0xa60
> Feb 29 12:05:38 [kernel] [186732.829203]  [<ffffffff810b4e30>] ? wake_up_=
bit+0x40/0x40
> Feb 29 12:05:38 [kernel] [186732.829206]  [<ffffffff811418d0>] ? try_to_f=
ree_pages+0x110/0x110
> Feb 29 12:05:38 [kernel] [186732.829210]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829214]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829217]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829221]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829224]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829232] exim            D 00000000000000=
00  2816  2718      1 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829237]  ffff8801afb837c0 00000000000000=
46 ffffffff8189813a 0000000000000001
> Feb 29 12:05:38 [kernel] [186732.829242]  ffff880100000000 00000000001d28=
80 ffff8801af161340 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829248]  ffff8801afb83fd8 ffff8801afb820=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829253] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829256]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829259]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829263]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829266]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829270]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829273]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829277]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829280]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829284]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829288]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829291]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829295]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829302]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829313]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829316]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829320]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829324]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829328]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829332]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829336]  [<ffffffff81090212>] copy_proce=
ss+0x122/0x1470
> Feb 29 12:05:38 [kernel] [186732.829339]  [<ffffffff8189b68b>] ? _raw_spi=
n_unlock_irqrestore+0x3b/0x70
> Feb 29 12:05:38 [kernel] [186732.829343]  [<ffffffff810ce71d>] ? trace_ha=
rdirqs_on+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829347]  [<ffffffff810915e9>] do_fork+0x=
59/0x350
> Feb 29 12:05:38 [kernel] [186732.829350]  [<ffffffff81095b9c>] ? do_wait+=
0x12c/0x250
> Feb 29 12:05:38 [kernel] [186732.829354]  [<ffffffff8189c02c>] ? sysret_c=
heck+0x27/0x62
> Feb 29 12:05:38 [kernel] [186732.829358]  [<ffffffff8104b0e3>] sys_clone+=
0x23/0x30
> Feb 29 12:05:38 [kernel] [186732.829361]  [<ffffffff8189c363>] stub_clone=
+0x13/0x20
> Feb 29 12:05:38 [kernel] [186732.829365]  [<ffffffff8189bffb>] ? system_c=
all_fastpath+0x16/0x1b
> Feb 29 12:05:38 [kernel] [186732.829368] gkrellmd        D 00000000000000=
00  1872  2732      1 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829373]  ffff8801afafd7c0 00000000000000=
46 ffffffff8189813a 0000000000000000
> Feb 29 12:05:38 [kernel] [186732.829378]  ffff880100000000 00000000001d28=
80 ffff8801b1996040 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829383]  ffff8801afafdfd8 ffff8801afafc0=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829388] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829391]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829395]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829398]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829402]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829405]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829412]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829416]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829420]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829423]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829427]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829430]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829434]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829438]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829441]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829445]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829448]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829452]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829455]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829459]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829463]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829467]  [<ffffffff8114e7ab>] ? might_fa=
ult+0x3b/0x90
> Feb 29 12:05:38 [kernel] [186732.829471]  [<ffffffff81090212>] copy_proce=
ss+0x122/0x1470
> Feb 29 12:05:38 [kernel] [186732.829476]  [<ffffffff8119c185>] ? dput+0x1=
45/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829479]  [<ffffffff8114e7f4>] ? might_fa=
ult+0x84/0x90
> Feb 29 12:05:38 [kernel] [186732.829482]  [<ffffffff8114e7ab>] ? might_fa=
ult+0x3b/0x90
> Feb 29 12:05:38 [kernel] [186732.829486]  [<ffffffff810915e9>] do_fork+0x=
59/0x350
> Feb 29 12:05:38 [kernel] [186732.829490]  [<ffffffff8189c02c>] ? sysret_c=
heck+0x27/0x62
> Feb 29 12:05:38 [kernel] [186732.829493]  [<ffffffff8104b0e3>] sys_clone+=
0x23/0x30
> Feb 29 12:05:38 [kernel] [186732.829497]  [<ffffffff8189c363>] stub_clone=
+0x13/0x20
> Feb 29 12:05:38 [kernel] [186732.829500]  [<ffffffff8189bffb>] ? system_c=
all_fastpath+0x16/0x1b
> Feb 29 12:05:38 [kernel] [186732.829503] smbd            D 00000000000000=
00  2792  2878      1 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829508]  ffff8801b57037c0 00000000000000=
46 ffffffff8189813a 0000000000000001
> Feb 29 12:05:38 [kernel] [186732.829513]  ffff880100000000 00000000001d28=
80 ffff8801b7a6cd00 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829524] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829527]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829531]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829534]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829548]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829552]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829555]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829559]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829563]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81090212>] copy_proce=
ss+0x122/0x1470
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b9d5e>] ? up_read+=
0x1e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810915e9>] do_fork+0x=
59/0x350
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8114e7ab>] ? might_fa=
ult+0x3b/0x90
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8ca>] ? retint_s=
wapgs+0xe/0x13
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8104b0e3>] sys_clone+=
0x23/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189c363>] stub_clone=
+0x13/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189bffb>] ? system_c=
all_fastpath+0x16/0x1b
> Feb 29 12:05:38 [kernel] [186732.829564] sshd            D 00000000000000=
00  2920  2919      1 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801afbb57c0 00000000000000=
46 ffffffff8189813a 0000000000000002
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff8801b7946040 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801afbb5fd8 ffff8801afbb40=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81090212>] copy_proce=
ss+0x122/0x1470
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810915e9>] do_fork+0x=
59/0x350
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8114e7ab>] ? might_fa=
ult+0x3b/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8104b0e3>] sys_clone+=
0x23/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189c363>] stub_clone=
+0x13/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189bffb>] ? system_c=
all_fastpath+0x16/0x1b
> Feb 29 12:05:38 [kernel] [186732.829564] cron            D 00000000000000=
00  2504  2952      1 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801afaf77c0 00000000000000=
46 ffffffff8189813a 0000000000000001
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff8801b7ab8000 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801afaf7fd8 ffff8801afaf60=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8114e7ab>] ? might_fa=
ult+0x3b/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81090212>] copy_proce=
ss+0x122/0x1470
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8119c185>] ? dput+0x1=
45/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8114e7f4>] ? might_fa=
ult+0x84/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8114e7ab>] ? might_fa=
ult+0x3b/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810915e9>] do_fork+0x=
59/0x350
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189c02c>] ? sysret_c=
heck+0x27/0x62
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8104b0e3>] sys_clone+=
0x23/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189c363>] stub_clone=
+0x13/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189bffb>] ? system_c=
all_fastpath+0x16/0x1b
> Feb 29 12:05:38 [kernel] [186732.829564] xfsaild/dm-0    D 00000000000000=
00  3800  3130      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880185593b40 00000000000000=
46 ffffffff8189813a ffffffff810c7b3d
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff8801b1b34d00 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880185593fd8 ffff8801855920=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139864c>] xlog_wait+=
0x6c/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189acdd>] ? _raw_spi=
n_lock+0x5d/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81399184>] xlog_cil_f=
orce_lsn+0x114/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb325>] ? sched_cl=
ock_local+0x25/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810a1900>] ? try_to_d=
el_timer_sync+0xe0/0xe0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813975a6>] _xfs_log_f=
orce+0x66/0x2a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139b710>] ? xfsaild+=
0x110/0x700
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813977f3>] xfs_log_fo=
rce+0x13/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139b73d>] xfsaild+0x=
13d/0x700
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1656  3221      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801b0b81c40 00000000000000=
46 ffffffff8189813a 0000000000000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff8801b7a6b9c0 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801b0b81fd8 ffff8801b0b800=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] nfs4_lock_=
state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812eb2e7>] nfsd4_open=
+0xb7/0x400
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812e97ee>] nfsd4_proc=
_compound+0x1ae/0x5d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183c625>] svc_proces=
s_common+0x345/0x690
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183cca1>] svc_proces=
s+0x101/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d85>] nfsd+0xb5/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1480  3222      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801b0afbc40 00000000000000=
46 ffffffff8189813a 0000000000000003
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff880164900000 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801b0afbfd8 ffff8801b0afa0=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] nfs4_lock_=
state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812eb2e7>] nfsd4_open=
+0xb7/0x400
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812e97ee>] nfsd4_proc=
_compound+0x1ae/0x5d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d9663>] nfsd_dispa=
tch+0xe3/0x220
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183c625>] svc_proces=
s_common+0x345/0x690
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183cca1>] svc_proces=
s+0x101/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d85>] nfsd+0xb5/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801648a5c40 00000000000000=
46 ffffffff8189813a 0000000000000001
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff880164901340 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801648a5fd8 ffff8801648a40=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] nfs4_lock_=
state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812eb2e7>] nfsd4_open=
+0xb7/0x400
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812e97ee>] nfsd4_proc=
_compound+0x1ae/0x5d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d9663>] nfsd_dispa=
tch+0xe3/0x220
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183c625>] svc_proces=
s_common+0x345/0x690
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183cca1>] svc_proces=
s+0x101/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d85>] nfsd+0xb5/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1544  3224      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff88018579f4a0 00000000000000=
46 ffffffff8189813a 0000000000000001
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff880164902680 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff88018579ffd8 ffff88018579e0=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce4a1>] ? mark_hel=
d_locks+0x81/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8116b141>] alloc_page=
s_current+0xa1/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81174335>] new_slab+0=
x265/0x300
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81176b5a>] __slab_all=
oc+0x2ca/0x540
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff814773c8>] ? idr_pre_=
get+0x68/0x90
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8117891b>] kmem_cache=
_alloc+0xdb/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff814773c8>] idr_pre_ge=
t+0x68/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f506a>] nfs4_alloc=
_stid+0x1a/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f8e26>] nfsd4_proc=
ess_open1+0x176/0x3d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812eb2fa>] nfsd4_open=
+0xca/0x400
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812e97ee>] nfsd4_proc=
_compound+0x1ae/0x5d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d9663>] nfsd_dispa=
tch+0xe3/0x220
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183c625>] svc_proces=
s_common+0x345/0x690
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183cca1>] svc_proces=
s+0x101/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d85>] nfsd+0xb5/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1400  3225      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880164699c40 00000000000000=
46 ffffffff8189813a 0000000000000002
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff8801649039c0 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] nfs4_lock_=
state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812eb2e7>] nfsd4_open=
+0xb7/0x400
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812e97ee>] nfsd4_proc=
_compound+0x1ae/0x5d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d9663>] nfsd_dispa=
tch+0xe3/0x220
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183c625>] svc_proces=
s_common+0x345/0x690
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183cca1>] svc_proces=
s+0x101/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d85>] nfsd+0xb5/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  2120  3226      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801647b17a0 00000000000000=
46 ffffffff8189813a 0000000000000002
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff880164904d00 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801647b1fd8 ffff8801647b00=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8116b141>] alloc_page=
s_current+0xa1/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8184b05c>] svc_recv+0=
xec/0x900
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d6d>] nfsd+0x9d/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1880  3227      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880164cb37a0 00000000000000=
46 ffffffff8189813a 0000000000000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff880164906040 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880164cb3fd8 ffff880164cb20=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8116b141>] alloc_page=
s_current+0xa1/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1768  3228      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880164dadc40 00000000000000=
46 ffffffff8189813a 0000000000000002
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff880164db0000 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880164dadfd8 ffff880164dac0=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] nfs4_lock_=
state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812eb2e7>] nfsd4_open=
+0xb7/0x400
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812e97ee>] nfsd4_proc=
_compound+0x1ae/0x5d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d9663>] nfsd_dispa=
tch+0xe3/0x220
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183c625>] svc_proces=
s_common+0x345/0x690
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183cca1>] svc_proces=
s+0x101/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1928  3229      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880164ecf940 00000000000000=
46 ffffffff8189813a ffffffff810c7b3d
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff880164db1340 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880164ecffd8 ffff880164ece0=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8172154d>] __lock_soc=
k+0x6d/0xa0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4e30>] ? wake_up_=
bit+0x40/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189aff2>] ? _raw_spi=
n_lock_bh+0x62/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81721639>] lock_sock_=
nested+0x39/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8178b640>] tcp_recvms=
g+0x30/0xb00
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff817230cf>] ? sock_upd=
ate_classid+0x5f/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff817b0208>] inet_recvm=
sg+0xc8/0xf0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81723110>] ? sock_upd=
ate_classid+0xa0/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8171d518>] sock_recvm=
sg+0xf8/0x130
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810a18a5>] ? try_to_d=
el_timer_sync+0x85/0xe0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8171d58f>] kernel_rec=
vmsg+0x3f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183e1ae>] svc_tcp_re=
cvfrom+0x36e/0x760
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8184b256>] ? svc_recv=
+0x2e6/0x900
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d6d>] nfsd+0x9d/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1480  3230      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880164fc9c40 00000000000000=
46 ffffffff8189813a 0000000000000003
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff880164db2680 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880164fc9fd8 ffff880164fc80=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] nfs4_lock_=
state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812eb2e7>] nfsd4_open=
+0xb7/0x400
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d9663>] nfsd_dispa=
tch+0xe3/0x220
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183c625>] svc_proces=
s_common+0x345/0x690
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183cca1>] svc_proces=
s+0x101/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d85>] nfsd+0xb5/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1704  3231      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801650cb2d0 00000000000000=
46 00000000001d3300 0000000000000001
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801650cb260 00000000001d28=
80 ffff880164db39c0 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801650cbfd8 ffff8801650ca0=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce4a1>] ? mark_hel=
d_locks+0x81/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8116b141>] alloc_page=
s_current+0xa1/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81174335>] new_slab+0=
x265/0x300
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81176b5a>] __slab_all=
oc+0x2ca/0x540
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8178976c>] ? sk_strea=
m_alloc_skb+0x3c/0x130
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce4a1>] ? mark_hel=
d_locks+0x81/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81179c33>] __kmalloc_=
node_track_caller+0x83/0x190
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811770bf>] ? kmem_cac=
he_alloc_node+0x2f/0x130
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8178976c>] ? sk_strea=
m_alloc_skb+0x3c/0x130
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81726965>] __alloc_sk=
b+0x75/0x170
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8178976c>] sk_stream_=
alloc_skb+0x3c/0x130
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8178a9f2>] tcp_sendpa=
ge+0x3f2/0x740
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff817230cf>] ? sock_upd=
ate_classid+0x5f/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff817b03ee>] inet_sendp=
age+0xce/0x130
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff817b0320>] ? inet_sen=
dmsg+0xf0/0xf0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81723110>] ? sock_upd=
ate_classid+0xa0/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8171bee3>] kernel_sen=
dpage+0x53/0x80
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183f2e2>] svc_send_c=
ommon+0x62/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183f42e>] svc_sendto=
+0x5e/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce4a1>] ? mark_hel=
d_locks+0x81/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce685>] ? trace_ha=
rdirqs_on_caller+0x105/0x190
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899108>] ? mutex_lo=
ck_nested+0x278/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8184ad59>] ? svc_send=
+0x59/0xf0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183f604>] svc_tcp_se=
ndto+0x34/0xa0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8184adab>] svc_send+0=
xab/0xf0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183ccc0>] svc_proces=
s+0x120/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d85>] nfsd+0xb5/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1848  3232      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801651c57a0 00000000000000=
46 ffffffff8189813a 0000000000000003
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff880164db4d00 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801651c5fd8 ffff8801651c40=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183e34d>] ? svc_tcp_=
recvfrom+0x50d/0x760
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8116b141>] alloc_page=
s_current+0xa1/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8184b05c>] svc_recv+0=
xec/0x900
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d6d>] nfsd+0x9d/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1304  3233      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801652e5c40 00000000000000=
46 ffffffff8189813a 0000000000000003
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801652e5fd8 ffff8801652e40=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] nfs4_lock_=
state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812eb2e7>] nfsd4_open=
+0xb7/0x400
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812e97ee>] nfsd4_proc=
_compound+0x1ae/0x5d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d9663>] nfsd_dispa=
tch+0xe3/0x220
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183c625>] svc_proces=
s_common+0x345/0x690
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183cca1>] svc_proces=
s+0x101/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d85>] nfsd+0xb5/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1848  3234      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801653dfc40 00000000000000=
46 ffffffff8189813a 0000000000000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff8801653e0000 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801653dffd8 ffff8801653de0=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] nfs4_lock_=
state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812eb2e7>] nfsd4_open=
+0xb7/0x400
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812e97ee>] nfsd4_proc=
_compound+0x1ae/0x5d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183c625>] svc_proces=
s_common+0x345/0x690
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183cca1>] svc_proces=
s+0x101/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d85>] nfsd+0xb5/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  2024  3235      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801654e9c40 00000000000000=
46 ffffffff8189813a 0000000000000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff8801653e1340 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801654e9fd8 ffff8801654e80=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] nfs4_lock_=
state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812eb2e7>] nfsd4_open=
+0xb7/0x400
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812e97ee>] nfsd4_proc=
_compound+0x1ae/0x5d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d9663>] nfsd_dispa=
tch+0xe3/0x220
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183c625>] svc_proces=
s_common+0x345/0x690
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183cca1>] svc_proces=
s+0x101/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d85>] nfsd+0xb5/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] nfsd            D 00000000000000=
00  1304  3236      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8801656032d0 00000000000000=
46 ffffffff8189813a 0000000000000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880100000000 00000000001d28=
80 ffff8801653e2680 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880165603fd8 ffff8801656020=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce4a1>] ? mark_hel=
d_locks+0x81/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8116b141>] alloc_page=
s_current+0xa1/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81174335>] new_slab+0=
x265/0x300
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81176b5a>] __slab_all=
oc+0x2ca/0x540
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8178976c>] ? sk_strea=
m_alloc_skb+0x3c/0x130
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce4a1>] ? mark_hel=
d_locks+0x81/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81179c33>] __kmalloc_=
node_track_caller+0x83/0x190
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811770bf>] ? kmem_cac=
he_alloc_node+0x2f/0x130
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8178976c>] ? sk_strea=
m_alloc_skb+0x3c/0x130
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81726965>] __alloc_sk=
b+0x75/0x170
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8178976c>] sk_stream_=
alloc_skb+0x3c/0x130
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8178a9f2>] tcp_sendpa=
ge+0x3f2/0x740
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff817b03ee>] inet_sendp=
age+0xce/0x130
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff817b0320>] ? inet_sen=
dmsg+0xf0/0xf0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81723110>] ? sock_upd=
ate_classid+0xa0/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8171bee3>] kernel_sen=
dpage+0x53/0x80
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183f2e2>] svc_send_c=
ommon+0x62/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183f42e>] svc_sendto=
+0x5e/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce4a1>] ? mark_hel=
d_locks+0x81/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189911c>] ? mutex_lo=
ck_nested+0x28c/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce685>] ? trace_ha=
rdirqs_on_caller+0x105/0x190
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899108>] ? mutex_lo=
ck_nested+0x278/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8184ad59>] ? svc_send=
+0x59/0xf0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183f604>] svc_tcp_se=
ndto+0x34/0xa0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8184adab>] svc_send+0=
xab/0xf0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8183ccc0>] svc_proces=
s+0x120/0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8d85>] nfsd+0xb5/=
0x150
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812d8cd0>] ? nfsd_shu=
tdown+0x30/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] kworker/u:4     D 00000000000000=
00  4520 23447      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8800471c3af0 00000000000000=
46 ffff8800471c3a70 ffffffff810bb325
> Feb 29 12:05:38 [kernel] [186732.829564]  00000000001d3300 00000000001d28=
80 ffff8801b5af2680 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb325>] ? sched_cl=
ock_local+0x25/0x90
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898985>] schedule_t=
imeout+0x1f5/0x2e0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b63b>] ? _raw_spi=
n_unlock_irq+0x2b/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce685>] ? trace_ha=
rdirqs_on_caller+0x105/0x190
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff818978e0>] wait_for_c=
ommon+0xc0/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81897a28>] wait_for_c=
ompletion+0x18/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81897846>] ? wait_for=
_common+0x26/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810af11b>] create_wor=
ker+0xbb/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810af31d>] manage_wor=
kers.clone.20+0x11d/0x240
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810af6c8>] worker_thr=
ead+0x288/0x340
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810af440>] ? manage_w=
orkers.clone.20+0x240/0x240
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] kworker/u:2     D 00000000000000=
00  4520 25347      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8800a9a05c50 00000000000000=
46 ffffffff8189813a 0000000000000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff8800a9a05fd8 ffff8800a9a040=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] ? nfs4_loc=
k_state+0x12/0x20
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f61e2>] nfs4_lock_=
state+0x12/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f88c5>] laundromat=
_main+0x25/0x410
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ada09>] process_on=
e_work+0x1a9/0x4f0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ad99a>] ? process_=
one_work+0x13a/0x4f0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff812f88a0>] ? nfsd4_ex=
change_id+0x440/0x440
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810af5a2>] worker_thr=
ead+0x162/0x340
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810af440>] ? manage_w=
orkers.clone.20+0x240/0x240
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] kworker/3:3     D 00000000000000=
00  4264 27581      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff88000ec6d640 00000000000000=
46 ffffffff8189813a 0000000000000006
> Feb 29 12:05:38 [kernel] [186732.829564]  0000000000000001 00000000001d28=
80 ffff8801b26ab9c0 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff88000ec6dfd8 ffff88000ec6c0=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816cb13d>] md_flush_r=
equest+0x7d/0x140
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81088560>] ? try_to_w=
ake_up+0x2d0/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816cf14f>] ? md_make_=
request+0x13f/0x2b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816da24b>] ? dm_reque=
st+0x13b/0x230
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816cf184>] md_make_re=
quest+0x174/0x2b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816cf078>] ? md_make_=
request+0x68/0x2b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b9d5e>] ? up_read+=
0x1e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816da24b>] ? dm_reque=
st+0x13b/0x230
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816da13e>] ? dm_reque=
st+0x2e/0x230
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8145c722>] generic_ma=
ke_request+0xc2/0x100
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8145d4d5>] submit_bio=
+0x75/0xf0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81341a82>] _xfs_buf_i=
oapply+0x162/0x1d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81394111>] ? xlog_bds=
trat+0x21/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81341bca>] xfs_buf_io=
request+0x4a/0xa0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81394111>] xlog_bdstr=
at+0x21/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81395d9e>] xlog_sync+=
0x23e/0x3d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81397258>] xlog_write=
+0x618/0x780
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81398830>] ? xlog_cil=
_push+0x1c0/0x3b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813988a9>] xlog_cil_p=
ush+0x239/0x3b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81399184>] xlog_cil_f=
orce_lsn+0x114/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce4a1>] ? mark_hel=
d_locks+0x81/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81397871>] _xfs_log_f=
orce_lsn+0x51/0x2f0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce71d>] ? trace_ha=
rdirqs_on+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81393d3b>] xfs_trans_=
commit+0x28b/0x2a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134782d>] xfs_fs_log=
_dummy+0x5d/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81351e14>] xfs_sync_w=
orker+0x84/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ad99a>] ? process_=
one_work+0x13a/0x4f0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81351d90>] ? xfs_sync=
_inode_attr+0xf0/0xf0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810af5a2>] worker_thr=
ead+0x162/0x340
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810af440>] ? manage_w=
orkers.clone.20+0x240/0x240
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] kworker/0:1     D 00000000000000=
00  1928 27768      2 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff88005ee6d460 00000000000000=
46 ffffffff8189813a 0000000000000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880000000000 00000000001d28=
80 ffff8801653e6040 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff88005ee6dfd8 ffff88005ee6c0=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810d633d>] ? __module=
_text_address+0xd/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce4a1>] ? mark_hel=
d_locks+0x81/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8116b141>] alloc_page=
s_current+0xa1/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81174335>] new_slab+0=
x265/0x300
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81176b5a>] __slab_all=
oc+0x2ca/0x540
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8112f3a0>] ? mempool_=
alloc_slab+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce4a1>] ? mark_hel=
d_locks+0x81/0x160
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ce71d>] ? trace_ha=
rdirqs_on+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8112f3a0>] ? mempool_=
alloc_slab+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8117891b>] kmem_cache=
_alloc+0xdb/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811082c2>] ? __delaya=
cct_blkio_end+0x32/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8112f3a0>] mempool_al=
loc_slab+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4e30>] ? wake_up_=
bit+0x40/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811b9919>] bio_alloc_=
bioset+0x39/0xf0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816ceef9>] ? submit_f=
lushes+0xd9/0x1f0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816cb2d5>] bio_alloc_=
mddev+0x35/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816cef2e>] submit_flu=
shes+0x10e/0x1f0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816ceef9>] ? submit_f=
lushes+0xd9/0x1f0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ada09>] process_on=
e_work+0x1a9/0x4f0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810ad99a>] ? process_=
one_work+0x13a/0x4f0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff816cee20>] ? md_do_sy=
nc+0xcd0/0xcd0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810af5a2>] worker_thr=
ead+0x162/0x340
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b48c6>] kthread+0x=
a6/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b4>] kernel_thr=
ead_helper+0x4/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b8dd>] ? retint_r=
estore_args+0xe/0xe
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810b4820>] ? __init_k=
thread_worker+0x70/0x70
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189e1b0>] ? gs_chang=
e+0xb/0xb
> Feb 29 12:05:38 [kernel] [186732.829564] rsync           D 00000000000000=
00  1976 28091  28084 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff88000bcc7478 00000000000000=
46 ffffffff8189813a 0000000000000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880000000001 00000000001d28=
80 ffff880165682680 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff88000bcc7fd8 ffff88000bcc60=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81899095>] ? mutex_lo=
ck_nested+0x205/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8116b141>] alloc_page=
s_current+0xa1/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8112cc27>] __page_cac=
he_alloc+0x87/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113871a>] __do_page_=
cache_readahead+0x13a/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113869e>] ? __do_pag=
e_cache_readahead+0xbe/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81138a2c>] ra_submit+=
0x1c/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81138b3e>] ondemand_r=
eadahead+0x10e/0x2b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81138b70>] ? ondemand=
_readahead+0x140/0x2b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81138daf>] page_cache=
_sync_readahead+0x2f/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8112e774>] generic_fi=
le_aio_read+0x444/0x740
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81344fc9>] xfs_file_a=
io_read+0x179/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8118444a>] do_sync_re=
ad+0xda/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811c1898>] ? fsnotify=
+0x1d8/0x320
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811c1745>] ? fsnotify=
+0x85/0x320
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8143f1d6>] ? security=
_file_permission+0x96/0xb0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81897e1c>] ? __schedu=
le+0x3ec/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81184edf>] sys_read+0=
x4f/0xa0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189bffb>] system_cal=
l_fastpath+0x16/0x1b
> Feb 29 12:05:38 [kernel] [186732.829564] run-crons       D 00000000000000=
00  2904 28235  28234 0x00000000
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff88005199b7c0 00000000000000=
46 ffffffff8189813a 0000000000000001
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff880000000000 00000000001d28=
80 ffff880165680000 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564]  ffff88005199bfd8 ffff88005199a0=
00 00000000001d2880 00000000001d2880
> Feb 29 12:05:38 [kernel] [186732.829564] Call Trace:
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189813a>] ? __schedu=
le+0x70a/0x920
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189841a>] schedule+0=
x3a/0x50
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81898fed>] mutex_lock=
_nested+0x15d/0x330
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] ? xfs_recl=
aim_inodes_ag+0x2ee/0x3a0
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8135308e>] xfs_reclai=
m_inodes_ag+0x2ee/0x3a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb57f>] ? local_cl=
ock+0x4f/0x60
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8139bdf2>] ? xfs_ail_=
push_all+0x42/0x90
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189b6e6>] ? _raw_spi=
n_unlock+0x26/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff813532ce>] xfs_reclai=
m_inodes_nr+0x2e/0x40
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8134f840>] xfs_fs_fre=
e_cached_objects+0x10/0x20
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811881f1>] prune_supe=
r+0x101/0x1b0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8113eb45>] shrink_sla=
b+0x165/0x2d0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff811414e7>] do_try_to_=
free_pages+0x267/0x460
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81141856>] try_to_fre=
e_pages+0x96/0x110
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81134ecd>] __alloc_pa=
ges_nodemask+0x4cd/0x820
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810bb4b8>] ? sched_cl=
ock_cpu+0xa8/0x120
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff81090212>] copy_proce=
ss+0x122/0x1470
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c81ed>] ? lock_rel=
ease_holdtime+0x3d/0x1a0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810cd87f>] ? lock_rel=
ease_non_nested+0x37f/0x3c0
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810c7b3d>] ? trace_ha=
rdirqs_off+0xd/0x10
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff810915e9>] do_fork+0x=
59/0x350
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8114e7ab>] ? might_fa=
ult+0x3b/0x90
>                 - Last output repeated twice -
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189c02c>] ? sysret_c=
heck+0x27/0x62
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8104b0e3>] sys_clone+=
0x23/0x30
> Feb 29 12:05:38 [kernel] [186732.829564]  [<ffffffff8189bffb>] ? system_c=
all_fastpath+0x16/0x1b
> Feb 29 12:05:38 [kernel] [186732.829564] Sched Debug Version: v0.10, 3.2.=
5 #1
> Feb 29 12:05:38 [kernel] [186732.829564] ktime                           =
        : 186732833.030196
> Feb 29 12:05:38 [kernel] [186732.829564] sched_clk                       =
        : 186363810.286830
> Feb 29 12:05:38 [kernel] [186732.829564] cpu_clk                         =
        : 186732829.564698
> Feb 29 12:05:38 [kernel] [186732.829564] jiffies                         =
        : 4481400126
> Feb 29 12:05:38 [kernel] [186732.829564] sched_clock_stable              =
        : 0
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] sysctl_sched
> Feb 29 12:05:38 [kernel] [186732.829564]   .sysctl_sched_latency         =
           : 18.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .sysctl_sched_min_granularity =
           : 2.250000
> Feb 29 12:05:38 [kernel] [186732.829564]   .sysctl_sched_wakeup_granulari=
ty         : 3.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .sysctl_sched_child_runs_first=
           : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .sysctl_sched_features        =
           : 24119
> Feb 29 12:05:38 [kernel] [186732.829564]   .sysctl_sched_tunable_scaling =
           : 1 (logaritmic)
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] cpu#0, 2333.084 MHz
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_running                   =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load                         =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_switches                  =
 : 127626917
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_load_updates              =
 : 64695581
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_uninterruptible           =
 : -5185
> Feb 29 12:05:38 [kernel] [186732.829564]   .clock                        =
 : 186732809.005246
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[0]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[1]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[2]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[3]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[4]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .yld_count                    =
 : 2
> Feb 29 12:05:38 [kernel] [186732.829564]   .sched_switch                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .sched_goidle                 =
 : 59908314
> Feb 29 12:05:38 [kernel] [186732.829564]   .avg_idle                     =
 : 1000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .ttwu_count                   =
 : 70228802
> Feb 29 12:05:38 [kernel] [186732.829564]   .ttwu_local                   =
 : 49835264
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] cfs_rq[0]:/
> Feb 29 12:05:38 [kernel] [186732.829564]   .exec_clock                   =
 : 12099620.925352
> Feb 29 12:05:38 [kernel] [186732.829564]   .MIN_vruntime                 =
 : 0.000001
> Feb 29 12:05:38 [kernel] [186732.829564]   .min_vruntime                 =
 : 10865130.739847
> Feb 29 12:05:38 [kernel] [186732.829564]   .max_vruntime                 =
 : 0.000001
> Feb 29 12:05:38 [kernel] [186732.829564]   .spread                       =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .spread0                      =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_spread_over               =
 : 633
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_running                   =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load                         =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_avg                     =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_period                  =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_contrib                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_tg                      =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] rt_rq[0]:
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_nr_running                =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_throttled                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_time                      =
 : 0.010808
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_runtime                   =
 : 950.000000
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] runnable tasks:
> Feb 29 12:05:38 [kernel] [186732.829564]             task   PID         t=
ree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> Feb 29 12:05:38 [kernel] [186732.829564] --------------------------------=
--------------------------------------------------------------------------
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] cpu#1, 2333.084 MHz
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_running                   =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load                         =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_switches                  =
 : 128426315
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_load_updates              =
 : 65499669
> Feb 29 12:05:38 [kernel] [186732.829564]   .next_balance                 =
 : 4481.400004
> Feb 29 12:05:38 [kernel] [186732.829564]   .curr->pid                    =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .clock                        =
 : 186732704.045991
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[0]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[1]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[2]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[3]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[4]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .yld_count                    =
 : 3
> Feb 29 12:05:38 [kernel] [186732.829564]   .sched_switch                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .sched_count                  =
 : 128816327
> Feb 29 12:05:38 [kernel] [186732.829564]   .sched_goidle                 =
 : 60378764
> Feb 29 12:05:38 [kernel] [186732.829564]   .avg_idle                     =
 : 1000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .ttwu_count                   =
 : 70202501
> Feb 29 12:05:38 [kernel] [186732.829564]   .ttwu_local                   =
 : 50152935
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] cfs_rq[1]:/
> Feb 29 12:05:38 [kernel] [186732.829564]   .exec_clock                   =
 : 11942938.971418
> Feb 29 12:05:38 [kernel] [186732.829564]   .MIN_vruntime                 =
 : 0.000001
> Feb 29 12:05:38 [kernel] [186732.829564]   .min_vruntime                 =
 : 10965585.421468
> Feb 29 12:05:38 [kernel] [186732.829564]   .max_vruntime                 =
 : 0.000001
> Feb 29 12:05:38 [kernel] [186732.829564]   .spread                       =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .spread0                      =
 : 100454.681621
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_spread_over               =
 : 637
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_running                   =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load                         =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_avg                     =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_contrib                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_tg                      =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] rt_rq[1]:
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_nr_running                =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_throttled                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_time                      =
 : 0.011839
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_runtime                   =
 : 950.000000
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] runnable tasks:
> Feb 29 12:05:38 [kernel] [186732.829564]             task   PID         t=
ree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> Feb 29 12:05:38 [kernel] [186732.829564] --------------------------------=
--------------------------------------------------------------------------
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] cpu#2, 2333.084 MHz
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_running                   =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load                         =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_switches                  =
 : 124877810
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_load_updates              =
 : 63257405
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_uninterruptible           =
 : 4945
> Feb 29 12:05:38 [kernel] [186732.829564]   .next_balance                 =
 : 4481.400130
> Feb 29 12:05:38 [kernel] [186732.829564]   .curr->pid                    =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .clock                        =
 : 186732830.026053
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[0]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[1]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[2]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[3]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[4]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .yld_count                    =
 : 1
> Feb 29 12:05:38 [kernel] [186732.829564]   .sched_switch                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .sched_count                  =
 : 125239550
> Feb 29 12:05:38 [kernel] [186732.829564]   .sched_goidle                 =
 : 59393188
> Feb 29 12:05:38 [kernel] [186732.829564]   .avg_idle                     =
 : 1000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .ttwu_count                   =
 : 60314669
> Feb 29 12:05:38 [kernel] [186732.829564]   .ttwu_local                   =
 : 44799719
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] cfs_rq[2]:/autogroup-41
> Feb 29 12:05:38 [kernel] [186732.829564]   .exec_clock                   =
 : 1550.967553
> Feb 29 12:05:38 [kernel] [186732.829564]   .MIN_vruntime                 =
 : 0.000001
> Feb 29 12:05:38 [kernel] [186732.829564]   .min_vruntime                 =
 : 1549.918977
> Feb 29 12:05:38 [kernel] [186732.829564]   .max_vruntime                 =
 : 0.000001
> Feb 29 12:05:38 [kernel] [186732.829564]   .spread                       =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .spread0                      =
 : -10863580.820870
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_running                   =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load                         =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_avg                     =
 : 5119.999488
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_period                  =
 : 6.468593
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_contrib                 =
 : 791
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_tg                      =
 : 791
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->exec_start               =
 : 186732828.548911
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->vruntime                 =
 : 8360658.005921
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->sum_exec_runtime         =
 : 1552.122095
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.wait_start    =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.sleep_start   =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.block_start   =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.sleep_max     =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.block_max     =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.exec_max      =
 : 3.133477
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.slice_max     =
 : 1.465148
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.wait_max      =
 : 3.850534
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.wait_sum      =
 : 133.221461
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.wait_count    =
 : 16329
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->load.weight              =
 : 2
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] cfs_rq[2]:/
> Feb 29 12:05:38 [kernel] [186732.829564]   .exec_clock                   =
 : 9867308.118613
> Feb 29 12:05:38 [kernel] [186732.829564]   .MIN_vruntime                 =
 : 0.000001
> Feb 29 12:05:38 [kernel] [186732.829564]   .min_vruntime                 =
 : 8360666.433800
> Feb 29 12:05:38 [kernel] [186732.829564]   .max_vruntime                 =
 : 0.000001
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_spread_over               =
 : 745
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_running                   =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load                         =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_avg                     =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_period                  =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_contrib                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_tg                      =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] rt_rq[2]:
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_nr_running                =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_throttled                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_time                      =
 : 0.007240
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_runtime                   =
 : 950.000000
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] runnable tasks:
> Feb 29 12:05:38 [kernel] [186732.829564]             task   PID         t=
ree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> Feb 29 12:05:38 [kernel] [186732.829564] --------------------------------=
--------------------------------------------------------------------------
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] cpu#3, 2333.084 MHz
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_running                   =
 : 2
> Feb 29 12:05:38 [kernel] [186732.829564]   .load                         =
 : 2048
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_switches                  =
 : 124026375
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_load_updates              =
 : 62682931
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_uninterruptible           =
 : 3772
> Feb 29 12:05:38 [kernel] [186732.829564]   .next_balance                 =
 : 4481.400098
> Feb 29 12:05:38 [kernel] [186732.829564]   .curr->pid                    =
 : 2991
> Feb 29 12:05:38 [kernel] [186732.829564]   .clock                        =
 : 186732828.596971
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[0]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[1]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[2]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[3]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .cpu_load[4]                  =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .yld_count                    =
 : 4
> Feb 29 12:05:38 [kernel] [186732.829564]   .sched_switch                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .sched_count                  =
 : 124393065
> Feb 29 12:05:38 [kernel] [186732.829564]   .sched_goidle                 =
 : 58899951
> Feb 29 12:05:38 [kernel] [186732.829564]   .avg_idle                     =
 : 1000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .ttwu_count                   =
 : 59877024
> Feb 29 12:05:38 [kernel] [186732.829564]   .ttwu_local                   =
 : 44537104
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] cfs_rq[3]:/autogroup-42
> Feb 29 12:05:38 [kernel] [186732.829564]   .MIN_vruntime                 =
 : 0.000001
> Feb 29 12:05:38 [kernel] [186732.829564]   .min_vruntime                 =
 : 626168.958817
> Feb 29 12:05:38 [kernel] [186732.829564]   .max_vruntime                 =
 : 0.000001
> Feb 29 12:05:38 [kernel] [186732.829564]   .spread                       =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .spread0                      =
 : -10238961.781030
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_spread_over               =
 : 23016
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_running                   =
 : 1
> Feb 29 12:05:38 [kernel] [186732.829564]   .load                         =
 : 1024
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_avg                     =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_period                  =
 : 9.999999
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_contrib                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_tg                      =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->exec_start               =
 : 186732828.596971
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->vruntime                 =
 : 8279374.470424
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->sum_exec_runtime         =
 : 263285.952949
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.wait_start    =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.sleep_start   =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.block_start   =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.sleep_max     =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.block_max     =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.exec_max      =
 : 13.400424
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.slice_max     =
 : 46.505344
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.wait_max      =
 : 16.575587
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.wait_sum      =
 : 2448.726587
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->statistics.wait_count    =
 : 242426
> Feb 29 12:05:38 [kernel] [186732.829564]   .se->load.weight              =
 : 1024
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564]   .exec_clock                   =
 : 9783020.902642
> Feb 29 12:05:38 [kernel] [186732.829564]   .MIN_vruntime                 =
 : 8279372.216698
> Feb 29 12:05:38 [kernel] [186732.829564]   .min_vruntime                 =
 : 8279380.963316
> Feb 29 12:05:38 [kernel] [186732.829564]   .max_vruntime                 =
 : 8279372.216698
> Feb 29 12:05:38 [kernel] [186732.829564]   .spread                       =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .spread0                      =
 : -2585749.776531
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_spread_over               =
 : 1511
> Feb 29 12:05:38 [kernel] [186732.829564]   .nr_running                   =
 : 2
> Feb 29 12:05:38 [kernel] [186732.829564]   .load                         =
 : 2048
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_avg                     =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_period                  =
 : 0.000000
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_contrib                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .load_tg                      =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] rt_rq[3]:
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_nr_running                =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_throttled                 =
 : 0
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_time                      =
 : 0.109158
> Feb 29 12:05:38 [kernel] [186732.829564]   .rt_runtime                   =
 : 950.000000
> Feb 29 12:05:38 [kernel] [186732.829564] =

> Feb 29 12:05:38 [kernel] [186732.829564] runnable tasks:
> Feb 29 12:05:38 [kernel] [186732.829564]             task   PID         t=
ree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> Feb 29 12:05:38 [kernel] [186732.829564] --------------------------------=
--------------------------------------------------------------------------
> Feb 29 12:05:38 [kernel] [186732.829564] R           bash  2991    626164=
.399889      1092   120    626164.399889       164.832603 186663838.488864 =
/autogroup-42
> Feb 29 12:05:38 [kernel] [186732.829564]      kworker/3:1 27652   8279372=
.216698     31913   120   8279372.216698      2529.050613   7144046.892045 /
> Feb 29 12:05:38 [kernel] [186732.829564] =

> =


-- =

Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
