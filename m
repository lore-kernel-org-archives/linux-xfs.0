Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n22DafMU213253
	for <linux-xfs@oss.sgi.com>; Mon, 2 Mar 2009 07:36:42 -0600
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30EDC164755
	for <linux-xfs@oss.sgi.com>; Mon,  2 Mar 2009 05:36:13 -0800 (PST)
Received: from mx1.suse.de (mail.suse.de [195.135.220.2]) by cuda.sgi.com with
	ESMTP id iHH66FxnG1BiEf2L for <linux-xfs@oss.sgi.com>;
	Mon, 02 Mar 2009 05:36:13 -0800 (PST)
Date: Mon, 2 Mar 2009 14:36:10 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
Message-ID: <20090302133609.GD23880@duck.suse.cz>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208222859.GA2532@infradead.org>
	<1234132752.12370.0.camel@champagne.cantina>
	<20090208224249.GA11931@infradead.org>
	<1234133120.12370.7.camel@champagne.cantina>
	<20090209075308.GA7360@infradead.org>
	<20090210104304.GP8830@disturbed>
	<1234432077.9204.15.camel@champagne.cantina>
	<20090226165838.GA9602@atrey.karlin.mff.cuni.cz>
	<1235763895.5743.3.camel@champagne>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1235763895.5743.3.camel@champagne>
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
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri 27-02-09 20:44:55, Alessandro Bono wrote:
> On Thu, 2009-02-26 at 17:58 +0100, Jan Kara wrote:
> ....
> > > any suggestion?
> >   Hmm, are you still able to reproduce the problem? As I'm looking into
> > registers in your dump, no register really seems to contain sensible page
> > flags so it could be some corruption of page pointer. If you are still
> > able to reproduce, could you please do so with the attached patch
> > applied? It will dump us much more information... Thanks.
> > 
> > 								Honza
> > 
> 
> this time with plain xfs, no lvm no dm_crypt
> just to add some info
> xfs fs created with this command
> 
> mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i attr=2 -d agcount=4
> -L store /dev/sdb1
  OK, thanks for the data. I've looked at both your traces and I think the
most likely cause is a bit-flip in memory. Look: The page address (we got
from bh->b_page) is ffffe20000885604. IMHO it should be ffffe20000885600
because if you look e.g. at mapping, it is 000ac69affff8800, which is a
bogus value but it would look like a valid pointer if we shift it by 32
bits to the left. The same with private pointer. Index also looks absurdly
high but low 32-bits are actually 0 and previous 4 bytes in the page
structure (we have them shown in the upper 4 bytes of mapping pointer)
contain 0x000ac69a => so given together page index would be 706202 -
perfectly sensible value.
  And in the second report it is the same. Also buffer head looks perfectly
valid in both cases.
  Such bit flips are usually caused by faulty memory or other HW (io
controler etc.) so I suggest trying to shuffle the hardware somehow -
change memory DIMMs as a starter, running memtest if you don't have a spare
DIMMs but it is not an exception that even though memtest runs just fine
for a long time, memory is really at fault.

								Honza

> Feb 27 19:20:28 champagne kernel: [ 2664.993272] Buffer ffff8800371e7e70 of page ffffe20000885604 not private! Some data to debug:
> Feb 27 19:20:28 champagne kernel: [ 2664.993282] flags: 240000000, mapping: 000ac69affff8800, index: 54276223274057728, private: 2489e50ffff8800
> Feb 27 19:20:28 champagne kernel: [ 2664.993288] Buffer: state=125, block=23795642, b_size=4096, b_this_page=ffff8800371e7e70
> Feb 27 19:20:28 champagne kernel: [ 2664.993293] Other buffers in the page:
> Feb 27 19:20:28 champagne kernel: [ 2664.993355] ------------[ cut here ]------------
> Feb 27 19:20:28 champagne kernel: [ 2664.993361] Kernel BUG at ffffffff802b3653 [verbose debug info unavailable]
> Feb 27 19:20:28 champagne kernel: [ 2664.993366] invalid opcode: 0000 [#1] SMP
> Feb 27 19:20:28 champagne kernel: [ 2664.993373] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> Feb 27 19:20:28 champagne kernel: [ 2664.993378] CPU 1
> Feb 27 19:20:28 champagne kernel: [ 2664.993382] Modules linked in: xfs nls_iso8859_1 nls_cp437 vfat fat nls_base usb_storage libusual af_packet binfmt_misc rfcomm bridge stp llc bnep sco l2cap kvm_intel kvm ppdev ipv6 acpi_cpufreq cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_ondemand freq_table cpufreq_conservative pci_slot sbs sbshc iptable_filter ip_tables x_tables dm_crypt sbp2 lp snd_hda_intel snd_hwdep snd_pcm_oss arc4 snd_pcm snd_page_alloc ecb snd_mixer_oss snd_seq_dummy snd_seq_oss iwlagn iwlcore usbhid snd_seq_midi rfkill btusb snd_rawmidi snd_seq_midi_event snd_seq hid parport_pc snd_timer mac80211 pcmcia bluetooth parport snd_seq_device lis3lv02d leds_hp_disk sdhci_pci sdhci snd video output ricoh_mmc pcspkr tpm_infineon tpm tpm_bios cfg80211 mmc_core led_class yenta_socket rsrc_nonstatic pcmcia_core psmouse container wmi battery ac button soundcore serio_raw iTCO_wdt iTCO_vendor_support evdev dm_multipath ext3 jbd mbcache sr_mod cdrom sg sd_mod cr!
 c_t10dif ohci1394 ata_piix ahci ieee1394 l
> Feb 27 19:20:28 champagne kernel: bata scsi_mod ehci_hcd uhci_hcd usbcore e1000e dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal processor fan thermal_sys hwmon fuse
> Feb 27 19:20:28 champagne kernel: [ 2664.993553] Pid: 8367, comm: xfsdatad/1 Not tainted 2.6.28.7 #1
> Feb 27 19:20:28 champagne kernel: [ 2664.993558] RIP: 0010:[<ffffffff802b3653>]  [<ffffffff802b3653>] end_buffer_async_write+0x119/0x18d
> Feb 27 19:20:28 champagne kernel: [ 2664.993573] RSP: 0018:ffff880084555e40  EFLAGS: 00010246
> Feb 27 19:20:28 champagne kernel: [ 2664.993578] RAX: 0000000240000000 RBX: ffff8800371e7e70 RCX: ffffffff80554d00
> Feb 27 19:20:28 champagne kernel: [ 2664.993584] RDX: ffff8800a7ae3000 RSI: 0000000000000046 RDI: ffffffff80572f50
> Feb 27 19:20:28 champagne kernel: [ 2664.993589] RBP: ffff8800371e7e70 R08: 0000000000000000 R09: 0000000000000000
> Feb 27 19:20:28 champagne kernel: [ 2664.993594] R10: 000000000000000a R11: 0000000000018600 R12: ffff8801159fd288
> Feb 27 19:20:28 champagne kernel: [ 2664.993599] R13: ffffe20000885604 R14: ffff88013b85ff00 R15: 0000000000000001
> Feb 27 19:20:28 champagne kernel: [ 2664.993605] FS:  0000000000000000(0000) GS:ffff88013b803a00(0000) knlGS:0000000000000000
> Feb 27 19:20:28 champagne kernel: [ 2664.993611] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> Feb 27 19:20:28 champagne kernel: [ 2664.993616] CR2: 00007f9deefb8ca8 CR3: 0000000117829000 CR4: 00000000000026e0
> Feb 27 19:20:28 champagne kernel: [ 2664.993621] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Feb 27 19:20:28 champagne kernel: [ 2664.993626] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Feb 27 19:20:28 champagne kernel: [ 2664.993632] Process xfsdatad/1 (pid: 8367, threadinfo ffff880084554000, task ffff88008c1222b0)
> Feb 27 19:20:28 champagne kernel: [ 2664.993636] Stack:
> Feb 27 19:20:28 champagne kernel: [ 2664.993640]  0000000000000282 0000000000000004 ffff88000248b6c0 ffff8801159fd288
> Feb 27 19:20:28 champagne kernel: [ 2664.993648]  ffff88013b85fee0 0000000000000000 ffff88010dc356c0 ffff8801159fd288
> Feb 27 19:20:28 champagne kernel: [ 2664.993657]  ffff88013b85fee0 ffffffffa055a9f9 ffffffffa055ab6b ffff8801159fd280
> Feb 27 19:20:28 champagne kernel: [ 2664.993667] Call Trace:
> Feb 27 19:20:28 champagne kernel: [ 2664.993671]  [<ffffffffa055a9f9>] ? xfs_destroy_ioend+0x23/0x71 [xfs]
> Feb 27 19:20:28 champagne kernel: [ 2664.993723]  [<ffffffffa055ab6b>] ? xfs_end_bio_delalloc+0x0/0x19 [xfs]
> Feb 27 19:20:28 champagne kernel: [ 2664.993770]  [<ffffffffa055ab6b>] ? xfs_end_bio_delalloc+0x0/0x19 [xfs]
> Feb 27 19:20:28 champagne kernel: [ 2664.993815]  [<ffffffff8023fdc2>] ? run_workqueue+0x79/0xfe
> Feb 27 19:20:28 champagne kernel: [ 2664.993826]  [<ffffffff8023ff1f>] ? worker_thread+0xd8/0xe7
> Feb 27 19:20:28 champagne kernel: [ 2664.993834]  [<ffffffff80243254>] ? autoremove_wake_function+0x0/0x2e
> Feb 27 19:20:28 champagne kernel: [ 2664.993842]  [<ffffffff8023fe47>] ? worker_thread+0x0/0xe7
> Feb 27 19:20:28 champagne kernel: [ 2664.993849]  [<ffffffff80242f42>] ? kthread+0x47/0x73
> Feb 27 19:20:28 champagne kernel: [ 2664.993856]  [<ffffffff8022ec78>] ? schedule_tail+0x27/0x5f
> Feb 27 19:20:28 champagne kernel: [ 2664.993864]  [<ffffffff8020c199>] ? child_rip+0xa/0x11
> Feb 27 19:20:28 champagne kernel: [ 2664.993872]  [<ffffffff80242efb>] ? kthread+0x0/0x73
> Feb 27 19:20:28 champagne kernel: [ 2664.993879]  [<ffffffff8020c18f>] ? child_rip+0x0/0x11
> Feb 27 19:20:28 champagne kernel: [ 2664.993885] Code: 10 4c 8b 43 20 48 8b 13 48 89 de 48 c7 c7 f8 ef 46 80 31 c0 e8 b2 db 13 00 48 8b 5b 08 48 39 eb 75 d7 49 8b 45 00 f6 c4 08 75 04 <0f> 0b eb fe 49 8b 5d 10 9c 41 5c fa eb 07 f3 90 f603 10 75 f9
> Feb 27 19:20:28 champagne kernel: [ 2664.993950] RIP  [<ffffffff802b3653>] end_buffer_async_write+0x119/0x18d
> Feb 27 19:20:28 champagne kernel: [ 2664.993959]  RSP <ffff880084555e40>
> Feb 27 19:20:28 champagne kernel: [ 2664.993985] ---[ end trace 2d34f97811caf921 ]---
> 

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
