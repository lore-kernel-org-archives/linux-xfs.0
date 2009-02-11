Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1BLoRP4157596
	for <linux-xfs@oss.sgi.com>; Wed, 11 Feb 2009 15:50:27 -0600
Received: from mail-fx0-f13.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDCA51B3D300
	for <linux-xfs@oss.sgi.com>; Wed, 11 Feb 2009 13:49:49 -0800 (PST)
Received: from mail-fx0-f13.google.com (mail-fx0-f13.google.com
	[209.85.220.13]) by cuda.sgi.com with ESMTP id qaqSE0Mr30VDMaB8
	for <linux-xfs@oss.sgi.com>; Wed, 11 Feb 2009 13:49:49 -0800 (PST)
Received: by fxm6 with SMTP id 6so64588fxm.20
	for <linux-xfs@oss.sgi.com>; Wed, 11 Feb 2009 13:49:48 -0800 (PST)
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Alessandro Bono <alessandro.bono@gmail.com>
In-Reply-To: <20090210104304.GP8830@disturbed>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208222859.GA2532@infradead.org>
	<1234132752.12370.0.camel@champagne.cantina>
	<20090208224249.GA11931@infradead.org>
	<1234133120.12370.7.camel@champagne.cantina>
	<20090209075308.GA7360@infradead.org> <20090210104304.GP8830@disturbed>
Content-Type: multipart/mixed; boundary="=-AsZrEsM1dZBUUDrkH6vq"
Date: Wed, 11 Feb 2009 22:47:06 +0100
Message-Id: <1234388826.8844.22.camel@champagne.cantina>
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


--=-AsZrEsM1dZBUUDrkH6vq
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
> 

Hi Dave

I tried 2.6.28.1 and on the morning pc was dead, blocked without any
possibility to interact so no bug to report (if really needed I can
connect a serial console)
I also tried 2.6.29-rc4-git3 and with rsync I hit this bug (also
attached)


[ 2591.213457] ------------[ cut
here ]------------                                                                                                          
[ 2591.213464] kernel BUG at
fs/buffer.c:534!                                                                                                                
[ 2591.213466] invalid opcode: 0000 [#1]
SMP                                                                                                                 
[ 2591.213470] last sysfs
file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map                                                                     
[ 2591.213473] CPU
1                                                                                                                                         
[ 2591.213475] Modules linked in: af_packet binfmt_misc rfcomm bridge
stp llc bnep sco l2cap acpi_cpufreq cpufreq_userspace cpufreq_stats
cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative sbs
sbshc pci_slot ipt_LOG xt_limit ipt_addrtype xt_state xt_tcpudp
xt_conntrack ip6table_filter ip6_tables ipv6 nf_nat_irc nf_conntrack_irc
nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp
nf_conntrack iptable_filter ip_tables x_tables ext3 jbd mbcache
usb_storage libusual hp_wmi coretemp sbp2 loop snd_hda_codec_atihdmi
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi arc4
snd_rawmidi ecb snd_seq_midi_event snd_seq snd_timer snd_seq_device
iwlagn sdhci_pci sdhci pcmcia btusb parport_pc mmc_core iwlcore rfkill
parport video ricoh_mmc container mac80211 joydev bluetooth tpm_infineon
tpm tpm_bios snd output psmouse serio_raw yenta_socket rsrc_nonstatic
pcmcia_core wmi cfg80211 battery ac button hp_accel led_class lis3lv02d
pcspkr soundcore snd_page_alloc iTCO_wdt iTCO_vendor_supportevdev
dm_multipath xfs exportfs sd_mod crc_t10dif sg sr_mod cdrom ohci1394
ahci ata_piix ieee1394 libata scsi_mod ehci_hcd uhci_hcd e1000e usbcore
dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal
processor fan thermal_sys hwmon fuse
[ 2591.213579] Pid: 2555, comm: xfsdatad/1 Not tainted 2.6.29-rc4-git3
#1
[ 2591.213582] RIP: 0010:[<ffffffff802c0cbc>]  [<ffffffff802c0cbc>]
end_buffer_async_write+0x83/0xfb
[ 2591.213591] RSP: 0018:ffff880138957e30  EFLAGS: 00010246
[ 2591.213594] RAX: 0000000280000000 RBX: ffff8800353e7e70 RCX:
ffff8800b540aca8
[ 2591.213597] RDX: 0000000000005252 RSI: 0000000000000001 RDI:
ffff8800353e7e70
[ 2591.213599] RBP: ffff8800b540ac60 R08: ffff8800b540ac60 R09:
ffff8800b540a5a0
[ 2591.213602] R10: ffff88003781c660 R11: ffff8800b540a5a0 R12:
ffff8800ae0b9440
[ 2591.213604] R13: ffffe20003e35cb4 R14: ffff88013b85ff00 R15:
0000000000000001
[ 2591.213607] FS:  0000000000000000(0000) GS:ffff88013b803b80(0000)
knlGS:0000000000000000
[ 2591.213610] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 2591.213612] CR2: 00007fd4f8238998 CR3: 00000000a1c3f000 CR4:
00000000000006e0
[ 2591.213615] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 2591.213618] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 2591.213620] Process xfsdatad/1 (pid: 2555, threadinfo
ffff880138956000, task ffff8801384bbde0)
[ 2591.213623] Stack:
[ 2591.213624]  ffffffff80584800 ffffffff8040c6d7 ffff8801384bc160
000000018022bd08
[ 2591.213628]  0000000000000286 ffff8800a2015460 ffff8800b540ac60
ffff8800ae0b9440
[ 2591.213633]  ffff8800ae0b92c0 ffffffffa01bfd51 ffff8800b540ac60
ffff880138877500
[ 2591.213637] Call Trace:
[ 2591.213639]  [<ffffffff8040c6d7>] ? __down_write_nested+0x15/0x9d
[ 2591.213647]  [<ffffffffa01bfd51>] ? xfs_destroy_ioend+0x33/0x7e [xfs]
[ 2591.213680]  [<ffffffffa01bfec0>] ? xfs_end_bio_delalloc+0x0/0x19
[xfs]
[ 2591.213706]  [<ffffffff8024483e>] ? run_workqueue+0x79/0xfe
[ 2591.213711]  [<ffffffff8024499b>] ? worker_thread+0xd8/0xe7
[ 2591.213715]  [<ffffffff80247d9d>] ? autoremove_wake_function+0x0/0x2e
[ 2591.213719]  [<ffffffff802448c3>] ? worker_thread+0x0/0xe7
[ 2591.213723]  [<ffffffff802448c3>] ? worker_thread+0x0/0xe7
[ 2591.213727]  [<ffffffff80247a46>] ? kthread+0x47/0x73
[ 2591.213730]  [<ffffffff8020c5fa>] ? child_rip+0xa/0x20
[ 2591.213735]  [<ffffffff802479ff>] ? kthread+0x0/0x73
[ 2591.213739]  [<ffffffff8020c5f0>] ? child_rip+0x0/0x20
[ 2591.213742] Code: 14 00 49 8b 45 18 48 8d 50 62 f0 80 48 62 20 48 8d
43 01 f0 80 4b 01 08 f0 80 23 fe f0 41 80 4d 00 02 49 8b 45 00 f6 c4 08
75 04 <0f> 0b eb fe 49 8b 6d 10 9c 41 5c fa eb 08 f3 90 f6 45 00 10 75
[ 2591.213775] RIP  [<ffffffff802c0cbc>] end_buffer_async_write
+0x83/0xfb
[ 2591.213779]  RSP <ffff880138957e30>
[ 2591.213782] ---[ end trace 32b0459ad0d88916 ]---



from fs/buffer.c

                }
                set_bit(AS_EIO, &page->mapping->flags);
                set_buffer_write_io_error(bh);
                clear_buffer_uptodate(bh);
                SetPageError(page);
        }

        first = page_buffers(page);   <----  line 534
        local_irq_save(flags);
        bit_spin_lock(BH_Uptodate_Lock, &first->b_state);

        clear_buffer_async_write(bh);
        unlock_buffer(bh);
        tmp = bh->b_this_page;


seems the same problem
Now I'll switch back to 2.6.27 based ubuntu kernel and I'll see if that
kernel survive to rsync
If you have any suggestion or patch or something to test tell me

thanks

> Cheers,
> 
> Dave.
-- 
---
Cordiali Saluti
Alessandro Bono

--=-AsZrEsM1dZBUUDrkH6vq
Content-Disposition: attachment; filename="bug-2.6.29-rc4-git3"
Content-Type: text/plain; name="bug-2.6.29-rc4-git3"; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[ 2591.213457] ------------[ cut here ]------------                        =
                                                                           =
      =20
[ 2591.213464] kernel BUG at fs/buffer.c:534!                              =
                                                                           =
      =20
[ 2591.213466] invalid opcode: 0000 [#1] SMP                               =
                                                                           =
      =20
[ 2591.213470] last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/s=
hared_cpu_map                                                              =
      =20
[ 2591.213473] CPU 1                                                       =
                                                                           =
      =20
[ 2591.213475] Modules linked in: af_packet binfmt_misc rfcomm bridge stp l=
lc bnep sco l2cap acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powe=
rsave cpufreq_ondemand freq_table cpufreq_conservative sbs sbshc pci_slot i=
pt_LOG xt_limit ipt_addrtype xt_state xt_tcpudp xt_conntrack ip6table_filte=
r ip6_tables ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrac=
k_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_table=
s x_tables ext3 jbd mbcache usb_storage libusual hp_wmi coretemp sbp2 loop =
snd_hda_codec_atihdmi snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_=
hwdep snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_m=
idi arc4 snd_rawmidi ecb snd_seq_midi_event snd_seq snd_timer snd_seq_devic=
e iwlagn sdhci_pci sdhci pcmcia btusb parport_pc mmc_core iwlcore rfkill pa=
rport video ricoh_mmc container mac80211 joydev bluetooth tpm_infineon tpm =
tpm_bios snd output psmouse serio_raw yenta_socket rsrc_nonstatic pcmcia_co=
re wmi cfg80211 battery ac button hp_accel led_class lis3lv02d pcspkr sound=
core snd_page_alloc iTCO_wdt iTCO_vendor_supportevdev dm_multipath xfs expo=
rtfs sd_mod crc_t10dif sg sr_mod cdrom ohci1394 ahci ata_piix ieee1394 liba=
ta scsi_mod ehci_hcd uhci_hcd e1000e usbcore dm_crypt dm_mirror dm_region_h=
ash dm_log dm_snapshot dm_mod thermal processor fan thermal_sys hwmon fuse
[ 2591.213579] Pid: 2555, comm: xfsdatad/1 Not tainted 2.6.29-rc4-git3 #1
[ 2591.213582] RIP: 0010:[<ffffffff802c0cbc>]  [<ffffffff802c0cbc>] end_buf=
fer_async_write+0x83/0xfb
[ 2591.213591] RSP: 0018:ffff880138957e30  EFLAGS: 00010246
[ 2591.213594] RAX: 0000000280000000 RBX: ffff8800353e7e70 RCX: ffff8800b54=
0aca8
[ 2591.213597] RDX: 0000000000005252 RSI: 0000000000000001 RDI: ffff8800353=
e7e70
[ 2591.213599] RBP: ffff8800b540ac60 R08: ffff8800b540ac60 R09: ffff8800b54=
0a5a0
[ 2591.213602] R10: ffff88003781c660 R11: ffff8800b540a5a0 R12: ffff8800ae0=
b9440
[ 2591.213604] R13: ffffe20003e35cb4 R14: ffff88013b85ff00 R15: 00000000000=
00001
[ 2591.213607] FS:  0000000000000000(0000) GS:ffff88013b803b80(0000) knlGS:=
0000000000000000
[ 2591.213610] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 2591.213612] CR2: 00007fd4f8238998 CR3: 00000000a1c3f000 CR4: 00000000000=
006e0
[ 2591.213615] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 2591.213618] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 2591.213620] Process xfsdatad/1 (pid: 2555, threadinfo ffff880138956000, =
task ffff8801384bbde0)
[ 2591.213623] Stack:
[ 2591.213624]  ffffffff80584800 ffffffff8040c6d7 ffff8801384bc160 00000001=
8022bd08
[ 2591.213628]  0000000000000286 ffff8800a2015460 ffff8800b540ac60 ffff8800=
ae0b9440
[ 2591.213633]  ffff8800ae0b92c0 ffffffffa01bfd51 ffff8800b540ac60 ffff8801=
38877500
[ 2591.213637] Call Trace:
[ 2591.213639]  [<ffffffff8040c6d7>] ? __down_write_nested+0x15/0x9d
[ 2591.213647]  [<ffffffffa01bfd51>] ? xfs_destroy_ioend+0x33/0x7e [xfs]
[ 2591.213680]  [<ffffffffa01bfec0>] ? xfs_end_bio_delalloc+0x0/0x19 [xfs]
[ 2591.213706]  [<ffffffff8024483e>] ? run_workqueue+0x79/0xfe
[ 2591.213711]  [<ffffffff8024499b>] ? worker_thread+0xd8/0xe7
[ 2591.213715]  [<ffffffff80247d9d>] ? autoremove_wake_function+0x0/0x2e
[ 2591.213719]  [<ffffffff802448c3>] ? worker_thread+0x0/0xe7
[ 2591.213723]  [<ffffffff802448c3>] ? worker_thread+0x0/0xe7
[ 2591.213727]  [<ffffffff80247a46>] ? kthread+0x47/0x73
[ 2591.213730]  [<ffffffff8020c5fa>] ? child_rip+0xa/0x20
[ 2591.213735]  [<ffffffff802479ff>] ? kthread+0x0/0x73
[ 2591.213739]  [<ffffffff8020c5f0>] ? child_rip+0x0/0x20
[ 2591.213742] Code: 14 00 49 8b 45 18 48 8d 50 62 f0 80 48 62 20 48 8d 43 =
01 f0 80 4b 01 08 f0 80 23 fe f0 41 80 4d 00 02 49 8b 45 00 f6 c4 08 75 04 =
<0f> 0b eb fe 49 8b 6d 10 9c 41 5c fa eb 08 f3 90 f6 45 00 10 75
[ 2591.213775] RIP  [<ffffffff802c0cbc>] end_buffer_async_write+0x83/0xfb
[ 2591.213779]  RSP <ffff880138957e30>
[ 2591.213782] ---[ end trace 32b0459ad0d88916 ]---


--=-AsZrEsM1dZBUUDrkH6vq
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-AsZrEsM1dZBUUDrkH6vq--
