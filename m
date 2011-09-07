Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p87B54Ks153060 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 06:05:05 -0500
Received: from icaras.de.unfix.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87A3C1418E8
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 04:05:02 -0700 (PDT)
Received: from icaras.de.unfix.org (icaras.de.unfix.org [78.47.209.234]) by
	cuda.sgi.com with ESMTP id cx9CxHaKOieagWFW for
	<xfs@oss.sgi.com>; Wed, 07 Sep 2011 04:05:02 -0700 (PDT)
Received: from yomi.ch.unfix.org (yomi.ch.unfix.org
	[IPv6:2a02:2528:ff42:99:ca2a:14ff:fe1f:2b7b])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: jeroen)
	by icaras.de.unfix.org (Postfix) with ESMTPSA id 31BFD801C2BF
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 13:04:53 +0200 (CEST)
Message-ID: <4E674FD6.8030408@unfix.org>
Date: Wed, 07 Sep 2011 13:04:54 +0200
From: Jeroen Massar <jeroen@unfix.org>
MIME-Version: 1.0
Subject: CPU stuck for 67s (kernel BUG) + in xfs_trans_committed_bulk while
	deleting lots a files (mostly hard-links)
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
To: xfs@oss.sgi.com

Hi,

Googling around I found other folks also ran into similar issues when
they have massive amounts of hard-links between backup directories from
the result of making backups of dirs which contain eg in my case upto 1M
of files, then having 300 days of backups and you get the idea ;)

Of course, you don't want to keep those backups forever-ever, even
though they don't take that much space, and thus one tries to delete
them with a simple 'rm -rf backup-2011-0*' to get rid of the beginning
of the year. Unfortunately that results in a more-or-less system stall
for some time where one fortunately is able to get a ^C through at one
point and break the rm and it becomes functional again after spewing
lots of kernel mesaages through syslog (see below).

I've found that using:
yes| rm -rfvi backup-2011-0*

does mostly work, as then the outbut buffering apparently takes long
enough to delay the individual rm's and all seems mostly peachy.
But that is not a proper fix of course, especially as that really takes
hours upon hours to complete.

As partially mentioned in the kernel BUG message this is Debian's
edition of linux-image-2.6.39-2-amd64 and according to the Debian
changelogs nothing new has been introduced. 3.0.0-3 is available, but as
kernel.org is down, bit hard to figure out what changes where made
between those versions and if they can affect this at all...

Anybody any ideas? :)

Greets,
 Jeroen

--

# xfs_info /
meta-data=/dev/md0               isize=256    agcount=32,
agsize=34339136 blks
         =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=1098851952, imaxpct=5
         =                       sunit=16     swidth=48 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=196608 blocks=0, rtextents=0

And yes it is getting pretty full:

/dev/md0              4.1T  4.0T  155G  97% /

Which is why I am trying to get rid of old backups ;)

One of the dmesg entries (except for timing the stack is all the same):

[6216996.064015] BUG: soft lockup - CPU#0 stuck for 67s! [kworker/0:2:10679]
[6216996.068004] Modules linked in: nls_utf8 ntfs sg affs loop ppdev
parport xt_tcpudp iptable_nat iptable_filter ip_tables ip6table_filter
ip6_tables veth bridge stp nf_nat_ftp nf_conntrack_ftp ipt_LOG
nf_nat_sip nf_conntrack_sip ipt_MASQUERADE nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 x_tables nf_conntrack dme1737 hwmon_vid sit tunnel4 tun
ide_generic ide_gd_mod ide_core asix usbnet snd_pcm i2c_i801 snd_timer
snd leds_ss4200 soundcore mii i2c_core rng_core psmouse evdev
snd_page_alloc serio_raw pcspkr processor button thermal_sys xfs raid456
md_mod async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy
async_tx sd_mod crc_t10dif ahci sata_sil24 libahci libata uhci_hcd
ehci_hcd scsi_mod usbcore e1000e [last unloaded: scsi_wait_scan]
[6216996.068004] CPU 0
[6216996.068004] Modules linked in: nls_utf8 ntfs sg affs loop ppdev
parport xt_tcpudp iptable_nat iptable_filter ip_tables ip6table_filter
ip6_tables veth bridge stp nf_nat_ftp nf_conntrack_ftp ipt_LOG
nf_nat_sip nf_conntrack_sip ipt_MASQUERADE nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 x_tables nf_conntrack dme1737 hwmon_vid sit tunnel4 tun
ide_generic ide_gd_mod ide_core asix usbnet snd_pcm i2c_i801 snd_timer
snd leds_ss4200 soundcore mii i2c_core rng_core psmouse evdev
snd_page_alloc serio_raw pcspkr processor button thermal_sys xfs raid456
md_mod async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy
async_tx sd_mod crc_t10dif ahci sata_sil24 libahci libata uhci_hcd
ehci_hcd scsi_mod usbcore e1000e [last unloaded: scsi_wait_scan]
[6216996.068004]
[6216996.068004] Pid: 10679, comm: kworker/0:2 Not tainted
2.6.39-2-amd64 #1 Intel SS4200-E/SS4200-E
[6216996.068004] RIP: 0010:[<ffffffffa0208362>]  [<ffffffffa0208362>]
xfs_trans_ail_update_bulk+0x16b/0x1e0 [xfs]
[6216996.068004] RSP: 0018:ffff88000827bbc0  EFLAGS: 00000202
[6216996.068004] RAX: ffff8800737ce078 RBX: 0000000000000002 RCX:
00000009000af336
[6216996.068004] RDX: ffff88002cf42ed0 RSI: 0000000000000009 RDI:
ffff880002bfaec0
[6216996.068004] RBP: ffff8800174b9b70 R08: 0000000000000000 R09:
dead000000200200
[6216996.068004] R10: dead000000100100 R11: 0000000000000001 R12:
ffffffff8133978e
[6216996.068004] R13: ffff8800375bb800 R14: dead000000100100 R15:
ffffffff810ec533
[6216996.068004] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[6216996.068004] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[6216996.068004] CR2: 000000000259a088 CR3: 0000000002331000 CR4:
00000000000006f0
[6216996.068004] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[6216996.068004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[6216996.068004] Process kworker/0:2 (pid: 10679, threadinfo
ffff88000827a000, task ffff880072b2c860)
[6216996.068004] Stack:
[6216996.068004]  ffff880002bfaec0 ffff880002bfaef0 0000000000000000
ffff8800474570f0
[6216996.068004]  0000000000000009 ffff880056b154c0 ffff880002bfaec0
000af33500000001
[6216996.068004]  ffff8800174b9b70 ffff8800174b9b70 0000000000000000
ffff8800174b9b70
[6216996.068004] Call Trace:
[6216996.068004]  [<ffffffffa02070bf>] ?
xfs_trans_committed_bulk+0xc5/0x13f [xfs]
[6216996.068004]  [<ffffffffa01fe2fc>] ? xlog_cil_committed+0x24/0xc2 [xfs]
[6216996.068004]  [<ffffffffa01fb232>] ?
xlog_state_do_callback+0x13a/0x228 [xfs]
[6216996.068004]  [<ffffffffa021066e>] ? xfs_buf_relse+0x12/0x12 [xfs]
[6216996.068004]  [<ffffffff81059f07>] ? process_one_work+0x1d1/0x2ee
[6216996.068004]  [<ffffffff8105be67>] ? worker_thread+0x12d/0x247
[6216996.068004]  [<ffffffff8105bd3a>] ? manage_workers+0x177/0x177
[6216996.068004]  [<ffffffff8105bd3a>] ? manage_workers+0x177/0x177
[6216996.068004]  [<ffffffff8105ef05>] ? kthread+0x7a/0x82
[6216996.068004]  [<ffffffff81339ee4>] ? kernel_thread_helper+0x4/0x10
[6216996.068004]  [<ffffffff8105ee8b>] ? kthread_worker_fn+0x147/0x147
[6216996.068004]  [<ffffffff81339ee0>] ? gs_change+0x13/0x13
[6216996.068004] Code: 49 89 54 24 08 eb 5b 48 8b 43 10 eb 1a 48 8b 48
10 48 89 ce 48 c1 ee 20 3b 74 24 20 75 05 44 39 e9 74 10 72 0e eb 65 48
8b 50 08 <4c> 39 e0 0f 18 0a 75 da 48 8b 4c 24 40 48 8d 54 24 40 48 39 d1
[6216996.068004] Call Trace:
[6216996.068004]  [<ffffffffa02070bf>] ?
xfs_trans_committed_bulk+0xc5/0x13f [xfs]
[6216996.068004]  [<ffffffffa01fe2fc>] ? xlog_cil_committed+0x24/0xc2 [xfs]
[6216996.068004]  [<ffffffffa01fb232>] ?
xlog_state_do_callback+0x13a/0x228 [xfs]
[6216996.068004]  [<ffffffffa021066e>] ? xfs_buf_relse+0x12/0x12 [xfs]
[6216996.068004]  [<ffffffff81059f07>] ? process_one_work+0x1d1/0x2ee
[6216996.068004]  [<ffffffff8105be67>] ? worker_thread+0x12d/0x247
[6216996.068004]  [<ffffffff8105bd3a>] ? manage_workers+0x177/0x177
[6216996.068004]  [<ffffffff8105bd3a>] ? manage_workers+0x177/0x177
[6216996.068004]  [<ffffffff8105ef05>] ? kthread+0x7a/0x82
[6216996.068004]  [<ffffffff81339ee4>] ? kernel_thread_helper+0x4/0x10
[6216996.068004]  [<ffffffff8105ee8b>] ? kthread_worker_fn+0x147/0x147
[6216996.068004]  [<ffffffff81339ee0>] ? gs_change+0x13/0x13

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
