Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1CAO3j7261632
	for <linux-xfs@oss.sgi.com>; Thu, 12 Feb 2009 04:24:04 -0600
Received: from mail-fx0-f17.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 047D610E5DB
	for <linux-xfs@oss.sgi.com>; Thu, 12 Feb 2009 02:23:27 -0800 (PST)
Received: from mail-fx0-f17.google.com (mail-fx0-f17.google.com
	[209.85.220.17]) by cuda.sgi.com with ESMTP id Y6SpOa6f6R5fYk4E
	for <linux-xfs@oss.sgi.com>; Thu, 12 Feb 2009 02:23:27 -0800 (PST)
Received: by fxm10 with SMTP id 10so34681fxm.20
	for <linux-xfs@oss.sgi.com>; Thu, 12 Feb 2009 02:23:26 -0800 (PST)
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Alessandro Bono <alessandro.bono@gmail.com>
In-Reply-To: <20090210104304.GP8830@disturbed>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208222859.GA2532@infradead.org>
	<1234132752.12370.0.camel@champagne.cantina>
	<20090208224249.GA11931@infradead.org>
	<1234133120.12370.7.camel@champagne.cantina>
	<20090209075308.GA7360@infradead.org> <20090210104304.GP8830@disturbed>
Content-Type: multipart/mixed; boundary="=-wB7tw1i+Q48e7GpfPeFA"
Date: Thu, 12 Feb 2009 10:47:57 +0100
Message-Id: <1234432077.9204.15.camel@champagne.cantina>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>


--=-wB7tw1i+Q48e7GpfPeFA
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2009-02-10 at 21:43 +1100, Dave Chinner wrote:
> On Mon, Feb 09, 2009 at 02:53:08AM -0500, Christoph Hellwig wrote:
> > On Sun, Feb 08, 2009 at 11:45:20PM +0100, Alessandro Bono wrote:
> > > sure, attached
> > 
> > That would be a missing PagePrivate bit in page_buffers() called from
> > end_buffer_async_write.  PG_private can only be cleared via drop_buffers
> > which requires the page not having PG_writeback set which must be
> > set until end_buffer_async_write is done.  Very strange, and all this
> > is generic code without xfs involvement.  Did this happen once
> > or can you reproduce it?
> 
> Hmmmm - i wonder if this has anything to do with the writeback fixes
> that went into 2.6.28.2? Alessandro, can you revert to 2.6.28.1 (not
> plain 2.6.28) and see if you can reproduce the problem?

another test another bug
kernel 2.6.29-rc4-git4 with DEBUG_PAGEALLOC and CONFIG_DEBUG_LIST
enabled (idea taken from a totally unrelated mail from Ingo Molnar to
catch a memory corruption), usual bug attached
2.6.27 from ubuntu not survived to rsync

btw my first report of a similar problem was with a kernel 2.6.26.6 but
at time I was using binary driver for my radeon card and Christoph
suggest me that I have to recreate problem without any binary driver
maybe it's not a recent regression, it's simply easier to hit with a
newer kernel

I don't have abandoned idea of a hardware problem but I don't know how
to be sure

any suggestion?

thanks

> 
> Cheers,
> 
> Dave.
-- 
---
Cordiali Saluti
Alessandro Bono

--=-wB7tw1i+Q48e7GpfPeFA
Content-Disposition: attachment; filename="bug-2.6.29-rc4-git4"
Content-Type: text/plain; name="bug-2.6.29-rc4-git4"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Feb 12 10:11:09 champagne kernel: [ 2447.523803] ------------[ cut here ]------------
Feb 12 10:11:09 champagne kernel: [ 2447.523808] kernel BUG at fs/buffer.c:534!
Feb 12 10:11:09 champagne kernel: [ 2447.523809] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
Feb 12 10:11:09 champagne kernel: [ 2447.523812] last sysfs file: /sys/class/power_supply/C1F4/charge_full
Feb 12 10:11:09 champagne kernel: [ 2447.523814] CPU 0
Feb 12 10:11:09 champagne kernel: [ 2447.523816] Modules linked in: usb_storage libusual af_packet binfmt_misc rfcomm bridge stp llc bnep sco l2cap acpi_cpuf
req cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative sbs sbshc pci_slot ipt_LOG xt_limit ipt_addrtype xt_st
ate xt_tcpudp xt_conntrack ip6table_filter ip6_tables ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf
_conntrack iptable_filter ip_tables x_tables ext3 jbd mbcache hp_wmi coretemp sbp2 loop snd_hda_codec_atihdmi snd_hda_codec_analog snd_hda_intel snd_hda_code
c snd_hwdep snd_pcm_oss snd_pcm snd_mixer_oss arc4 snd_seq_dummy ecb snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event iwlagn snd_seq parport_pc parpor
t iwlcore rfkill pcmcia snd_timer snd_seq_device btusb ricoh_mmc joydev mac80211 snd wmi container sdhci_pci sdhci bluetooth psmouse yenta_socket rsrc_nonsta
tic pcmcia_core serio_raw tpm_infineon tpm tpm_bios video output cfg80211 hp_accel lis3
Feb 12 10:11:09 champagne kernel: v02d battery ac button mmc_core led_class pcspkr iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc evdev dm_multipath x
fs exportfs sd_mod crc_t10dif sg sr_mod cdrom ohci1394 ahci ata_piix ieee1394 libata scsi_mod ehci_hcd uhci_hcd usbcore e1000e dm_crypt dm_mirror dm_region_h
ash dm_log dm_snapshot dm_mod thermal processor fan thermal_sys hwmon fuse
Feb 12 10:11:09 champagne kernel: [ 2447.523885] Pid: 2557, comm: xfsdatad/0 Not tainted 2.6.29-rc4-git4 #1 HP Compaq 8510p
Feb 12 10:11:09 champagne kernel: [ 2447.523886] RIP: 0010:[<ffffffff802bfc56>]  [<ffffffff802bfc56>] end_buffer_async_write+0x83/0xfb
Feb 12 10:11:09 champagne kernel: [ 2447.523893] RSP: 0000:ffff8801384bbe30  EFLAGS: 00010246
Feb 12 10:11:09 champagne kernel: [ 2447.523895] RAX: 0000000240000000 RBX: ffff880034be7e70 RCX: 0000000000000034
Feb 12 10:11:09 champagne kernel: [ 2447.523897] RDX: 000000000000000c RSI: 0000000000000001 RDI: ffff880034be7e70
Feb 12 10:11:09 champagne kernel: [ 2447.523899] RBP: ffff88000c777c60 R08: a000000000000000 R09: ffffffff8050f0cb
Feb 12 10:11:09 champagne kernel: [ 2447.523900] R10: 0000000000000002 R11: ffff88013b85fee0 R12: ffff8800015a7d80
Feb 12 10:11:09 champagne kernel: [ 2447.523902] R13: ffffe200012a960c R14: ffff88013b85ff00 R15: 0000000000000001
Feb 12 10:11:09 champagne kernel: [ 2447.523904] FS:  0000000000000000(0000) GS:ffffffff80592040(0000) knlGS:0000000000000000
Feb 12 10:11:09 champagne kernel: [ 2447.523906] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb 12 10:11:09 champagne kernel: [ 2447.523907] CR2: 00000000044d4ff0 CR3: 00000000b3d96000 CR4: 00000000000006e0
Feb 12 10:11:09 champagne kernel: [ 2447.523909] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 12 10:11:09 champagne kernel: [ 2447.523911] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 12 10:11:09 champagne kernel: [ 2447.523913] Process xfsdatad/0 (pid: 2557, threadinfo ffff8801384ba000, task ffff8801394f4420)
Feb 12 10:11:09 champagne kernel: [ 2447.523914] Stack:
Feb 12 10:11:09 champagne kernel: [ 2447.523915]  ffffffff80582800 ffffffff8040a2be ffff8801394f47a0 000000008029e721
Feb 12 10:11:09 champagne kernel: [ 2447.523918]  0000000000000286 ffff880034be7d20 ffff88000c777c60 ffff8800015a7d80
Feb 12 10:11:09 champagne kernel: [ 2447.523921]  ffff8800015a7c00 ffffffffa01becf5 ffff88000c777c60 ffff880139494c80
Feb 12 10:11:09 champagne kernel: [ 2447.523924] Call Trace:
Feb 12 10:11:09 champagne kernel: [ 2447.523925]  [<ffffffff8040a2be>] ? __down_write_nested+0x15/0x95
Feb 12 10:11:09 champagne kernel: [ 2447.523931]  [<ffffffffa01becf5>] ? xfs_destroy_ioend+0x33/0x7e [xfs]
Feb 12 10:11:09 champagne kernel: [ 2447.523954]  [<ffffffffa01bee64>] ? xfs_end_bio_delalloc+0x0/0x19 [xfs]
Feb 12 10:11:09 champagne kernel: [ 2447.523970]  [<ffffffff8024470a>] ? run_workqueue+0x79/0xfe
Feb 12 10:11:09 champagne kernel: [ 2447.523974]  [<ffffffff80244867>] ? worker_thread+0xd8/0xe7
Feb 12 10:11:09 champagne kernel: [ 2447.523976]  [<ffffffff80247bcd>] ? autoremove_wake_function+0x0/0x2e
Feb 12 10:11:09 champagne kernel: [ 2447.523979]  [<ffffffff8024478f>] ? worker_thread+0x0/0xe7
Feb 12 10:11:09 champagne kernel: [ 2447.523981]  [<ffffffff8024478f>] ? worker_thread+0x0/0xe7
Feb 12 10:11:09 champagne kernel: [ 2447.523983]  [<ffffffff80247882>] ? kthread+0x47/0x73
Feb 12 10:11:09 champagne kernel: [ 2447.523985]  [<ffffffff8020c5fa>] ? child_rip+0xa/0x20
Feb 12 10:11:09 champagne kernel: [ 2447.523988]  [<ffffffff8024783b>] ? kthread+0x0/0x73
Feb 12 10:11:09 champagne kernel: [ 2447.523990]  [<ffffffff8020c5f0>] ? child_rip+0x0/0x20
Feb 12 10:11:09 champagne kernel: [ 2447.523993] Code: 14 00 49 8b 45 18 48 8d 50 62 f0 80 48 62 20 48 8d 43 01 f0 80 4b 01 08 f0 80 23 fe f0 41 80 4d 00 02
49 8b 45 00 f6 c4 08 75 04 <0f> 0b eb fe 49 8b 6d 10 9c 41 5c fa eb 08 f3 90 f6 45 00 10 75
Feb 12 10:11:09 champagne kernel: [ 2447.524020] RIP  [<ffffffff802bfc56>] end_buffer_async_write+0x83/0xfb
Feb 12 10:11:09 champagne kernel: [ 2447.524023]  RSP <ffff8801384bbe30>
Feb 12 10:11:09 champagne kernel: [ 2447.524121] ---[ end trace 8372db6c09f46582 ]---

--=-wB7tw1i+Q48e7GpfPeFA
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-wB7tw1i+Q48e7GpfPeFA--
