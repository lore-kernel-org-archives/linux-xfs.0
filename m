Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UIK3MX063904 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 13:20:03 -0500
Received: from mail-da0-f53.google.com (mail-da0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id IPkFdxuSlwBKvFQ9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 30 Oct 2012 11:21:52 -0700 (PDT)
Received: by mail-da0-f53.google.com with SMTP id g9so251920dad.26
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 11:21:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121029125330.GS29378@dastard>
References: <CADLDEKtkwaitKCsU21JnsesM70H5AwkEFQFcdmOHE0JU9Oa8nw@mail.gmail.com>
	<20121029125330.GS29378@dastard>
Date: Tue, 30 Oct 2012 09:58:03 +0100
Message-ID: <CADLDEKv8Y0Z+4gfJYhxi=-CejkkdaGBjtx1og6n8G6z1o9xpSA@mail.gmail.com>
Subject: Re: Daily crash in xfs_cmn_err
From: Juerg Haefliger <juergh@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 29, 2012 at 1:53 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Oct 29, 2012 at 11:55:15AM +0100, Juerg Haefliger wrote:
>> Hi,
>>
>> I have a node that used to crash every day at 6:25am in xfs_cmn_err
>> (Null pointer dereference).
>
> Stack trace, please.


[128185.204521] BUG: unable to handle kernel NULL pointer dereference
at 00000000000000f8
[128185.213436] IP: [<ffffffffa010c95f>] xfs_cmn_err+0x4f/0xc0 [xfs]
[128185.220302] PGD 17dd180067 PUD 17ddddf067 PMD 0
[128185.225612] Oops: 0000 [#1] SMP
[128185.229359] last sysfs file: /sys/module/ip_tables/initstate
[128185.235802] CPU 6
[128185.237937] Modules linked in: ipmi_devintf ipmi_si
ipmi_msghandler xt_recent xt_multiport bridge xt_conntrack iptable_nat
iptable_mangle nbd ebtable_nat ebtables kvm_intel kvm ib_iser rdma_cm
ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp
libiscsi scsi_transport_iscsi 8021q garp stp ipt_REJECT ipt_LOG
xt_limit xt_tcpudp ipt_addrtype xt_state ip6table_filter ip6_tables
nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables
x_tables ghes i7core_edac lp serio_raw hed edac_core parport xfs
exportfs usbhid hid igb hpsa dca
[128185.299779]
[128185.301565] Pid: 25484, comm: logrotate Not tainted
2.6.38-15-server #62~lp1026116slubv201208301417 HP SE2170s /SE2170s
[128185.317470] RIP: 0010:[<ffffffffa010c95f>] [<ffffffffa010c95f>]
xfs_cmn_err+0x4f/0xc0 [xfs]
[128185.327065] RSP: 0018:ffff880bdd6bba78 EFLAGS: 00010246
[128185.333118] RAX: 0000000000000000 RBX: ffff8817de320dc0 RCX:
ffffffffa01152d8
[128185.341232] RDX: 0000000000000000 RSI: ffff880bdd6bbab8 RDI:
ffffffffa011b65b
[128185.349347] RBP: ffff880bdd6bbae8 R08: ffffffffa011a47a R09:
00000000000005a9
[128185.357463] R10: 0000000000000003 R11: 0000000000000000 R12:
ffff8817dde5c230
[128185.365579] R13: 0000000000000075 R14: 00000000000046c2 R15:
0000000000000080
[128185.373695] FS: 00007fb25e73c7c0(0000) GS:ffff88183fc00000(0000)
knlGS:0000000000000000
[128185.382877] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[128185.389415] CR2: 00000000000000f8 CR3: 00000017de695000 CR4:
00000000000006e0
[128185.397531] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[128185.405647] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[128185.413761] Process logrotate (pid: 25484, threadinfo
ffff880bdd6ba000, task ffff880bbe9ec590)
[128185.423524] Stack:
[128185.425891] ffffffffa00c2d72 00000000000000bd ffff880b00000020
ffff880bdd6bbaf8
[128185.434325] ffff880bdd6bbab8 ffff880bdea3b800 ffffffffa01152d8
ffff880bdd6bba88
[128185.442774] ffff880bdd6bbb74 00000000000046c2 ffff880bdd6bbb08
ffffffffa00ac33e
[128185.451212] Call Trace:
[128185.454077] [<ffffffffa00c2d72>] ?
xfs_btree_rec_addr.clone.7+0x12/0x20 [xfs]
[128185.462298] [<ffffffffa00ac33e>] ? xfs_alloc_get_rec+0x2e/0x80 [xfs]
[128185.469624] [<ffffffffa00d72e0>] xfs_error_report+0x40/0x50 [xfs]
[128185.476656] [<ffffffffa00af31b>] ? xfs_free_extent+0x9b/0xc0 [xfs]
[128185.483785] [<ffffffffa00ad550>] xfs_free_ag_extent+0x4a0/0x760 [xfs]
[128185.491203] [<ffffffffa00af31b>] xfs_free_extent+0x9b/0xc0 [xfs]
[128185.498138] [<ffffffffa00be144>] xfs_bmap_finish+0x164/0x1b0 [xfs]
[128185.505271] [<ffffffffa00de1f9>] xfs_itruncate_finish+0x159/0x360 [xfs]
[128185.512889] [<ffffffffa00faac9>] xfs_inactive+0x319/0x470 [xfs]
[128185.519730] [<ffffffffa0108cde>] xfs_fs_evict_inode+0x9e/0xf0 [xfs]
[128185.526949] [<ffffffff8117dd34>] evict+0x24/0xc0
[128185.532323] [<ffffffff8117e8ca>] iput_final+0x16a/0x250
[128185.538379] [<ffffffff8117e9eb>] iput+0x3b/0x50
[128185.543656] [<ffffffff8117acc0>] d_kill+0xe0/0x120
[128185.549224] [<ffffffff8117bc32>] dput+0xd2/0x1a0
[128185.554600] [<ffffffff8116673b>] __fput+0x13b/0x1f0
[128185.560265] [<ffffffff81166815>] fput+0x25/0x30
[128185.565543] [<ffffffff81163130>] filp_close+0x60/0x90
[128185.571402] [<ffffffff81163937>] sys_close+0xb7/0x120
[128185.577262] [<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
[128185.584091] Code: 8d 75 10 48 8d 45 a0 c7 45 a0 20 00 00 00 48 c7
c7 5b b6 11 a0 48 89 4d c0 48 89 75 a8 48 8d 75 d0 48 89 45 c8 31 c0
48 89 75 b0 <48> 8b b2 f8 00 00 00 48 8d 55 c0 e8 07 bd 4c e1 c9 c3 48
c7 c7
[128185.606061] RIP [<ffffffffa010c95f>] xfs_cmn_err+0x4f/0xc0 [xfs]
[128185.613010] RSP <ffff880bdd6bba78>
[128185.617025] CR2: 00000000000000f8


mp passed to xfs_cmn_err was a Null pointer  and mp->m_fsname in the
printk line caused the crash (offset of m_fsname is 0xf8).

Error message extracted from the dump:
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1449 of file
fs/xfs/xfs_alloc.c.

And the comments in the source:
1444 /*
1445 * If this failure happens the request to free this
1446 * space was invalid, it's (partly) already free.
1447 * Very bad.
1448 */
1449 XFS_WANT_CORRUPTED_GOTO(gtbno >= bno + len, error0);


>> 1) I was under the impression that during the mounting of an XFS
>> volume some sort of check/repair is performed.  How does that differ
>> from running xfs_check and/or xfs_repair?
>
> Journal recovery is performed at mount time, not a consistency
> check.
>
> http://en.wikipedia.org/wiki/Filesystem_journaling

Ah OK. Thanks for the clarification.


>> 2) Any ideas how the filesystem might have gotten into this state? I
>> don't have the history of that node but it's possible that it crashed
>> previously due to an unrelated problem. Could this have left the
>> filesystem is this state?
>
> <shrug>
>
> How long is a piece of string?
>
>> 3) What exactly does the ouput of the xfs_check mean? How serious is
>> it? Are those warning or errors? Will some of them get cleanup up
>> during the mounting of the filesystem?
>
> xfs_check is deprecated.  The output of xfs_repair indicates
> cross-linked extent indexes. Will only get properly detected and
> fixed by xfs_repair. And "fixed" may mean corrupt files are removed
> from the filesystem - repair does nto guarantee that your data is
> preserved or consistent after it runs, just that the filesystem is
> consistent and error free.
>
>> 4) We have a whole bunch of production nodes running the same kernel.
>> I'm more than a little concerned that we might have a ticking timebomb
>> with some filesystems being in a state that might trigger a crash
>> eventually. Is there any way to perform a live check on a mounted
>> filesystem so that I can get an idea of how big of a problem we have
>> (if any)?
>
> Read the xfs_repair man page?
>
> -n     No modify mode. Specifies that xfs_repair should not
>        modify the filesystem but should only scan the  filesystem
>        and indicate what repairs would have been made.
> .....
>
> -d     Repair dangerously. Allow xfs_repair to repair an XFS
>        filesystem mounted read only. This is typically done on a
>        root fileystem from single user mode, immediately followed by
>        a reboot.
>
> So, remount read only, run xfs_repair -d -n will check the
> filesystem as best as can be done online. If there are any problems,
> then you can repair them and immediately reboot.
>
>> i don't claim to know exactly what I'm doing but I picked a
>> node, froze the filesystem and then ran a modified xfs_check (which
>> bypasses the is_mounted check and ignores non-committed metadata) and
>> it did report some issues. At this point I believe those are false
>> positive. Do you have any suggestions short of rebooting the nodes and
>> running xfs_check on the unmounted filesystem?
>
> Don't bother with xfs_check. xfs_repair will detect all the same
> errors (and more) and can fix them at the same time.

Thanks for the hints.

...Juerg


> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
