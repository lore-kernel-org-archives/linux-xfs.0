Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6M8tDNe229571
	for <linux-xfs@oss.sgi.com>; Wed, 22 Jul 2009 03:55:13 -0500
Received: from mail-ew0-f213.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79EAE379FD8
	for <linux-xfs@oss.sgi.com>; Wed, 22 Jul 2009 01:55:55 -0700 (PDT)
Received: from mail-ew0-f213.google.com (mail-ew0-f213.google.com
	[209.85.219.213]) by cuda.sgi.com with ESMTP id
	P9mWpB10oDfJrYNj for <linux-xfs@oss.sgi.com>;
	Wed, 22 Jul 2009 01:55:55 -0700 (PDT)
Received: by ewy9 with SMTP id 9so44005ewy.20
	for <linux-xfs@oss.sgi.com>; Wed, 22 Jul 2009 01:55:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090721141225.GA24330@infradead.org>
References: <4A408316.2070903@news-service.com>
	<1587994907.388291245745033392.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<20090623171305.GB23971@infradead.org>
	<4A4A7205.6010101@news-service.com>
	<20090701124441.GA12844@infradead.org>
	<4A4CEEF2.7040101@news-service.com>
	<20090721141225.GA24330@infradead.org>
Date: Wed, 22 Jul 2009 10:55:54 +0200
Message-ID: <89c4f90c0907220155u5d9331dj3cbe53efcf6b51f2@mail.gmail.com>
Subject: Re: 2.6.30 panic - xfs_fs_destroy_inode
From: Tommy van Leeuwen <tommy@news-service.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Schreurs <patrick@news-service.com>, linux-xfs@oss.sgi.com, Lachlan McIlroy <lmcilroy@redhat.com>, Eric Sandeen <sandeen@sandeen.net>

Hi,

On Tue, Jul 21, 2009 at 4:12 PM, Christoph Hellwig<hch@infradead.org> wrote:
> On Thu, Jul 02, 2009 at 07:31:30PM +0200, Patrick Schreurs wrote:
>> Hi Christoph,
>>
>> With this patch we see the following:
>>
>> kernel BUG at fs/inode.c:1288!
>
> Okay, I think I figured out what this is. =A0You hit the case where
> we re-use an inode that is gone from the VFS point of view, but
> still in xfs reclaimable state. =A0We reinitialize it using
> inode_init_always, but inode_init_always does not touch i_state, which
> still includes I_CLEAR. =A0See the patch below which sets it to the
> expected state. =A0What really worries me is that I don't seem to be
> able to actually hit that case in testing.
>
> Can you try the patch below ontop of the previous one?
>
>
> Index: linux-2.6/fs/xfs/xfs_iget.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/xfs/xfs_iget.c =A0 =A02009-07-21 16:07:41.654923213=
 +0200
> +++ linux-2.6/fs/xfs/xfs_iget.c 2009-07-21 16:08:55.064151137 +0200
> @@ -206,6 +206,7 @@ xfs_iget_cache_hit(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_error;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode->i_state =3D I_LOCK|I_NEW;
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* If the VFS inode is being torn down, pa=
use and try again. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!igrab(inode))
>

Unfortunately we still get errors, with this patch on top of the
previous one: The difference is that is now crashes within an hour
instead of once a week, so that might be good for troubleshooting.

Jul 22 10:46:13 sb07 kernel: ------------[ cut here ]------------
Jul 22 10:46:13 sb07 kernel: kernel BUG at fs/inode.c:1288!
Jul 22 10:46:13 sb07 kernel: invalid opcode: 0000 [#1] SMP
Jul 22 10:46:13 sb07 kernel: last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
Jul 22 10:46:13 sb07 kernel: CPU 3
Jul 22 10:46:13 sb07 kernel: Modules linked in: cpufreq_ondemand
acpi_cpufreq ipmi_si ipmi_devintf ipmi_msghandler bonding rng_core
serio_raw e1000e bnx2 thermal processor 8250_pnp 8250 serial_core
thermal_sys
Jul 22 10:46:13 sb07 kernel: Pid: 251, comm: kswapd0 Not tainted
2.6.30.1-xfs #5 PowerEdge 1950
Jul 22 10:46:13 sb07 kernel: RIP: 0010:[<ffffffff8028aaab>]
[<ffffffff8028aaab>] iput+0x13/0x60
Jul 22 10:46:13 sb07 kernel: RSP: 0000:ffff88043fab1cb0  EFLAGS: 00010246
Jul 22 10:46:13 sb07 kernel: RAX: 0000000000000000 RBX:
ffff88006fcc7980 RCX: ffff88026411aaf0
Jul 22 10:46:13 sb07 kernel: RDX: ffff88006fcc79b0 RSI:
ffff88026411aa88 RDI: ffff88006fcc7980
Jul 22 10:46:13 sb07 kernel: RBP: ffff880373b1ecc8 R08:
ffff88043fab1cf0 R09: 0000000000000246
Jul 22 10:46:13 sb07 kernel: R10: 0000000000000010 R11:
ffffffff8028b7b0 R12: ffff88043c7f0400
Jul 22 10:46:13 sb07 kernel: R13: ffff88043fab1cf0 R14:
ffff88043c7f0518 R15: ffff88043fab1d64
Jul 22 10:46:13 sb07 kernel: FS:  0000000000000000(0000)
GS:ffff88002807f000(0000) knlGS:0000000000000000
Jul 22 10:46:13 sb07 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050=
03b
Jul 22 10:46:13 sb07 kernel: CR2: 00007f4078709320 CR3:
000000043bd8f000 CR4: 00000000000006a0
Jul 22 10:46:13 sb07 kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jul 22 10:46:13 sb07 kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jul 22 10:46:13 sb07 kernel: Process kswapd0 (pid: 251, threadinfo
ffff88043fab0000, task ffff88043fa726f0)
Jul 22 10:46:13 sb07 kernel: Stack:
Jul 22 10:46:13 sb07 kernel: ffff88026411aa80 ffffffff802884ff
0000000000000010 ffff88026411aa80
Jul 22 10:46:13 sb07 kernel: ffff8802978404c0 ffff8802978404c0
ffff88043fab1d00 ffff88043fab1d00
Jul 22 10:46:13 sb07 kernel: Call Trace:
Jul 22 10:46:13 sb07 kernel: [<ffffffff8028878b>] ?
__shrink_dcache_sb+0x26b/0x301
Jul 22 10:46:13 sb07 kernel: [<ffffffff80288900>] ?
shrink_dcache_memory+0xdf/0x16e
Jul 22 10:46:13 sb07 kernel: [<ffffffff8025e8a0>] ? kswapd+0x448/0x5bf
Jul 22 10:46:13 sb07 kernel: ffff88043c7f0400 ffffffff8028878b
00000000000000c0 0000000000000008
Jul 22 10:46:13 sb07 kernel: [<ffffffff802884ff>] ? d_kill+0x34/0x55
Jul 22 10:46:13 sb07 kernel: [<ffffffff8025e3e5>] ? shrink_slab+0xe0/0x153
Jul 22 10:46:13 sb07 kernel: [<ffffffff8025c692>] ?
isolate_pages_global+0x0/0x231
Jul 22 10:46:13 sb07 kernel: [<ffffffff8025e458>] ? kswapd+0x0/0x5bf
Jul 22 10:46:13 sb07 kernel: [<ffffffff8020bd7a>] ? child_rip+0xa/0x20
Jul 22 10:46:13 sb07 kernel: [<ffffffff8023e2d1>] ?
autoremove_wake_function+0x0/0x2e
Jul 22 10:46:13 sb07 kernel: [<ffffffff8025e458>] ? kswapd+0x0/0x5bf
Jul 22 10:46:13 sb07 kernel: [<ffffffff8023df28>] ? kthread+0x0/0x80
Jul 22 10:46:13 sb07 kernel: [<ffffffff802243ec>] ? __wake_up_common+0x44/0=
x73
Jul 22 10:46:13 sb07 kernel: [<ffffffff8023df7c>] ? kthread+0x54/0x80
Jul 22 10:46:13 sb07 kernel: [<ffffffff8020bd70>] ? child_rip+0x0/0x20
Jul 22 10:46:13 sb07 kernel: Code: 4b 70 be 01 00 00 00 48 89 df e8 c2
86 00 00 eb db 48 83 c4 28 5b 5d c3 53 48 85 ff 48 89 fb 74 55 48 83
bf f8 01 00 00 40 75 04 <0f> 0b eb fe 48 8d 7f 48 48 c7 c6 f0 2a 5c 80
e8 25 4b 0a 00 85
Jul 22 10:46:13 sb07 kernel: RIP  [<ffffffff8028aaab>] iput+0x13/0x60
Jul 22 10:46:13 sb07 kernel: RSP <ffff88043fab1cb0>
Jul 22 10:46:13 sb07 kernel: ---[ end trace 2d9673758108d2e3 ]---


Thanks,
Tommy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
