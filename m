Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n19B7N7K241874
	for <linux-xfs@oss.sgi.com>; Mon, 9 Feb 2009 05:07:24 -0600
Received: from mail-fx0-f12.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF1E618F2F71
	for <linux-xfs@oss.sgi.com>; Mon,  9 Feb 2009 03:06:45 -0800 (PST)
Received: from mail-fx0-f12.google.com (mail-fx0-f12.google.com
	[209.85.220.12]) by cuda.sgi.com with ESMTP id j8FrS0mIxfE4JCZx
	for <linux-xfs@oss.sgi.com>; Mon, 09 Feb 2009 03:06:45 -0800 (PST)
Received: by fxm5 with SMTP id 5so642107fxm.20
	for <linux-xfs@oss.sgi.com>; Mon, 09 Feb 2009 03:06:45 -0800 (PST)
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
From: Alessandro Bono <alessandro.bono@gmail.com>
In-Reply-To: <20090209075308.GA7360@infradead.org>
References: <1234011974.7435.11.camel@champagne.cantina>
	<20090208222859.GA2532@infradead.org>
	<1234132752.12370.0.camel@champagne.cantina>
	<20090208224249.GA11931@infradead.org>
	<1234133120.12370.7.camel@champagne.cantina>
	<20090209075308.GA7360@infradead.org>
Content-Type: multipart/mixed; boundary="=-rXq4RUyDVrzU2JG/c0Qa"
Date: Mon, 09 Feb 2009 10:02:28 +0100
Message-Id: <1234170148.7544.10.camel@champagne.cantina>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs <linux-xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>


--=-rXq4RUyDVrzU2JG/c0Qa
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2009-02-09 at 02:53 -0500, Christoph Hellwig wrote:
> On Sun, Feb 08, 2009 at 11:45:20PM +0100, Alessandro Bono wrote:
> > sure, attached
> 
> That would be a missing PagePrivate bit in page_buffers() called from
> end_buffer_async_write.  PG_private can only be cleared via drop_buffers
> which requires the page not having PG_writeback set which must be
> set until end_buffer_async_write is done.  Very strange, and all this
> is generic code without xfs involvement.  Did this happen once
> or can you reproduce it?
> 

this night to eliminate ext4 from equation I reformatted usb disk in xfs
and started rsync as usual (after a machine restart)
this is the result (also attached for better readability)


Feb  9 01:33:17 champagne kernel: [ 3689.392066] ------------[ cut
here ]------------
Feb  9 01:33:17 champagne kernel: [ 3689.392071] kernel BUG at
fs/buffer.c:470!
Feb  9 01:33:17 champagne kernel: [ 3689.392072] invalid opcode: 0000
[#1] SMP
Feb  9 01:33:17 champagne kernel: [ 3689.392075] last sysfs
file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
Feb  9 01:33:17 champagne kernel: [ 3689.392077] CPU 1
Feb  9 01:33:17 champagne kernel: [ 3689.392078] Modules linked in:
usb_storage libusual af_packet binfmt_misc rfcomm bridge stp llc bnep
sco l2cap acpi_cpu
freq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand
freq_table cpufreq_conservative sbs sbshc pci_slot ipt_LOG xt_limit
ipt_addrtype xt_
state xt_tcpudp xt_conntrack ip6table_filter ip6_tables ipv6 nf_nat_irc
nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_conntrack_ftp
 nf_conntrack iptable_filter ip_tables x_tables ext3 jbd mbcache hp_wmi
coretemp sbp2 loop arc4 ecb snd_seq_dummy iwlagn snd_seq_oss iwlcore
snd_seq_midi sn
d_hda_intel rfkill snd_rawmidi snd_pcm_oss snd_mixer_oss pcmcia mac80211
lis3lv02d leds_hp_disk snd_seq_midi_event tpm_infineon tpm tpm_bios
btusb parport_p
c parport sdhci_pci sdhci mmc_core ricoh_mmc yenta_socket rsrc_nonstatic
pcmcia_core video output bluetooth led_class wmi pcspkr evdev container
snd_pcm snd
_page_alloc button snd_seq ac cfg80211 iTCO_wdt iTCO_vendor_support
psmouse serio_raw snd_hwd
Feb  9 01:33:17 champagne kernel: p battery snd_timer snd_seq_device snd
dm_multipath soundcore xfs sd_mod crc_t10dif sg sr_mod cdrom ohci1394
ahci ata_piix
 ieee1394 libata scsi_mod ehci_hcd uhci_hcd usbcore e1000e dm_crypt
dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal processor fan
thermal_sys hwm
on fuse
Feb  9 01:33:17 champagne kernel: [ 3689.392149] Pid: 2490, comm:
xfsdatad/1 Not tainted 2.6.28.4 #1
Feb  9 01:33:17 champagne kernel: [ 3689.392151] RIP:
0010:[<ffffffff802b5c78>]  [<ffffffff802b5c78>] end_buffer_async_write
+0x8f/0x12c
Feb  9 01:33:17 champagne kernel: [ 3689.392158] RSP:
0018:ffff8801389a3e40  EFLAGS: 00010246
Feb  9 01:33:17 champagne kernel: [ 3689.392159] RAX: 0000000000000000
RBX: 0000000000000001 RCX: 000000000000000b
Feb  9 01:33:17 champagne kernel: [ 3689.392161] RDX: 0000000000000000
RSI: ffffe200014d7edc RDI: 0000000000000040
Feb  9 01:33:17 champagne kernel: [ 3689.392163] RBP: ffff8800358ef930
R08: 4000000000000000 R09: ffff880039f25302
Feb  9 01:33:17 champagne kernel: [ 3689.392165] R10: ffff88003782e4e0
R11: ffff8801389a3dd0 R12: ffff88013880b088
Feb  9 01:33:17 champagne kernel: [ 3689.392166] R13: ffff88013b85fee0
R14: ffffe200014d7edc R15: 0000000000000001
Feb  9 01:33:17 champagne kernel: [ 3689.392169] FS:
0000000000000000(0000) GS:ffff88013b803a00(0000) knlGS:0000000000000000
Feb  9 01:33:17 champagne kernel: [ 3689.392171] CS:  0010 DS: 0018 ES:
0018 CR0: 000000008005003b
Feb  9 01:33:17 champagne kernel: [ 3689.392172] CR2: 00007f49ba397000
CR3: 000000006e112000 CR4: 00000000000006e0
Feb  9 01:33:17 champagne kernel: [ 3689.392174] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Feb  9 01:33:17 champagne kernel: [ 3689.392176] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  9 01:33:17 champagne kernel: [ 3689.392178] Process xfsdatad/1
(pid: 2490, threadinfo ffff8801389a2000, task ffff880139f9cc50)
Feb  9 01:33:17 champagne kernel: [ 3689.392180] Stack:
Feb  9 01:33:17 champagne kernel: [ 3689.392181]  ffff8801389a3e50
ffffffff8022806f 0000000000000286 ffffffff8030be35
Feb  9 01:33:17 champagne kernel: [ 3689.392184]  ffff8800358efaf0
ffff8800379e7960 ffff88013880b088 ffff88013b85fee0
Feb  9 01:33:17 champagne kernel: [ 3689.392187]  ffff88013b85ff00
ffffffffa01c5269 ffffffffa01c53db ffff88013880b080
Feb  9 01:33:17 champagne kernel: [ 3689.392190] Call Trace:
Feb  9 01:33:17 champagne kernel: [ 3689.392191]  [<ffffffff8022806f>] ?
need_resched+0x1e/0x28
Feb  9 01:33:17 champagne kernel: [ 3689.392195]  [<ffffffff8030be35>] ?
__up_write+0x12/0x45
Feb  9 01:33:17 champagne kernel: [ 3689.392201]  [<ffffffffa01c5269>] ?
xfs_destroy_ioend+0x23/0x71 [xfs]
Feb  9 01:33:17 champagne kernel: [ 3689.392225]  [<ffffffffa01c53db>] ?
xfs_end_bio_delalloc+0x0/0x19 [xfs]
Feb  9 01:33:17 champagne kernel: [ 3689.392243]  [<ffffffffa01c53db>] ?
xfs_end_bio_delalloc+0x0/0x19 [xfs]
Feb  9 01:33:17 champagne kernel: [ 3689.392259]  [<ffffffff80242d5e>] ?
run_workqueue+0x79/0xfe
Feb  9 01:33:17 champagne kernel: [ 3689.392263]  [<ffffffff80242ed3>] ?
worker_thread+0xf0/0x102
Feb  9 01:33:17 champagne kernel: [ 3689.392265]  [<ffffffff802461cd>] ?
autoremove_wake_function+0x0/0x2e
Feb  9 01:33:17 champagne kernel: [ 3689.392269]  [<ffffffff80242de3>] ?
worker_thread+0x0/0x102
Feb  9 01:33:17 champagne kernel: [ 3689.392271]  [<ffffffff80245ea2>] ?
kthread+0x47/0x73
Feb  9 01:33:17 champagne kernel: [ 3689.392274]  [<ffffffff80231bfa>] ?
schedule_tail+0x27/0x60
Feb  9 01:33:17 champagne kernel: [ 3689.392277]  [<ffffffff8020c3f9>] ?
child_rip+0xa/0x11
Feb  9 01:33:17 champagne kernel: [ 3689.392280]  [<ffffffff80245e5b>] ?
kthread+0x0/0x73
Feb  9 01:33:17 champagne kernel: [ 3689.392283]  [<ffffffff8020c3ef>] ?
child_rip+0x0/0x11
Feb  9 01:33:17 champagne kernel: [ 3689.392285] Code: 8b 46 18 48 8d 50
62 f0 80 48 62 20 48 8d 45 01 f0 80 4d 01 08 f0 80 65 00 fe f0 41 80 0e
02 4c 89 f7 e8 f4 e3 ff ff 85 c0 75 04 <0f> 0b eb fe 4d 8b 66 10 9c 41
5d fa eb 13 f3 90 4c 89 e6 bf 04
Feb  9 01:33:17 champagne kernel: [ 3689.392307] RIP
[<ffffffff802b5c78>] end_buffer_async_write+0x8f/0x12c
Feb  9 01:33:17 champagne kernel: [ 3689.392310]  RSP <ffff8801389a3e40>
Feb  9 01:33:17 champagne kernel: [ 3689.392312] ---[ end trace
0c3741da6a2192b7 ]---

-- 
---
Cordiali Saluti
Alessandro Bono

--=-rXq4RUyDVrzU2JG/c0Qa
Content-Disposition: attachment; filename="bug3-2.2.28.4"
Content-Type: text/plain; name="bug3-2.2.28.4"; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Feb  9 01:33:17 champagne kernel: [ 3689.392066] ------------[ cut here ]--=
----------
Feb  9 01:33:17 champagne kernel: [ 3689.392071] kernel BUG at fs/buffer.c:=
470!
Feb  9 01:33:17 champagne kernel: [ 3689.392072] invalid opcode: 0000 [#1] =
SMP=20
Feb  9 01:33:17 champagne kernel: [ 3689.392075] last sysfs file: /sys/devi=
ces/system/cpu/cpu1/cache/index2/shared_cpu_map
Feb  9 01:33:17 champagne kernel: [ 3689.392077] CPU 1=20
Feb  9 01:33:17 champagne kernel: [ 3689.392078] Modules linked in: usb_sto=
rage libusual af_packet binfmt_misc rfcomm bridge stp llc bnep sco l2cap ac=
pi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondema=
nd freq_table cpufreq_conservative sbs sbshc pci_slot ipt_LOG xt_limit ipt_=
addrtype xt_state xt_tcpudp xt_conntrack ip6table_filter ip6_tables ipv6 nf=
_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv=
4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables ext3 jbd =
mbcache hp_wmi coretemp sbp2 loop arc4 ecb snd_seq_dummy iwlagn snd_seq_oss=
 iwlcore snd_seq_midi snd_hda_intel rfkill snd_rawmidi snd_pcm_oss snd_mixe=
r_oss pcmcia mac80211 lis3lv02d leds_hp_disk snd_seq_midi_event tpm_infineo=
n tpm tpm_bios btusb parport_pc parport sdhci_pci sdhci mmc_core ricoh_mmc =
yenta_socket rsrc_nonstatic pcmcia_core video output bluetooth led_class wm=
i pcspkr evdev container snd_pcm snd_page_alloc button snd_seq ac cfg80211 =
iTCO_wdt iTCO_vendor_support psmouse serio_raw snd_hwd
Feb  9 01:33:17 champagne kernel: p battery snd_timer snd_seq_device snd dm=
_multipath soundcore xfs sd_mod crc_t10dif sg sr_mod cdrom ohci1394 ahci at=
a_piix ieee1394 libata scsi_mod ehci_hcd uhci_hcd usbcore e1000e dm_crypt d=
m_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal processor fan the=
rmal_sys hwmon fuse
Feb  9 01:33:17 champagne kernel: [ 3689.392149] Pid: 2490, comm: xfsdatad/=
1 Not tainted 2.6.28.4 #1
Feb  9 01:33:17 champagne kernel: [ 3689.392151] RIP: 0010:[<ffffffff802b5c=
78>]  [<ffffffff802b5c78>] end_buffer_async_write+0x8f/0x12c
Feb  9 01:33:17 champagne kernel: [ 3689.392158] RSP: 0018:ffff8801389a3e40=
  EFLAGS: 00010246
Feb  9 01:33:17 champagne kernel: [ 3689.392159] RAX: 0000000000000000 RBX:=
 0000000000000001 RCX: 000000000000000b
Feb  9 01:33:17 champagne kernel: [ 3689.392161] RDX: 0000000000000000 RSI:=
 ffffe200014d7edc RDI: 0000000000000040
Feb  9 01:33:17 champagne kernel: [ 3689.392163] RBP: ffff8800358ef930 R08:=
 4000000000000000 R09: ffff880039f25302
Feb  9 01:33:17 champagne kernel: [ 3689.392165] R10: ffff88003782e4e0 R11:=
 ffff8801389a3dd0 R12: ffff88013880b088
Feb  9 01:33:17 champagne kernel: [ 3689.392166] R13: ffff88013b85fee0 R14:=
 ffffe200014d7edc R15: 0000000000000001
Feb  9 01:33:17 champagne kernel: [ 3689.392169] FS:  0000000000000000(0000=
) GS:ffff88013b803a00(0000) knlGS:0000000000000000
Feb  9 01:33:17 champagne kernel: [ 3689.392171] CS:  0010 DS: 0018 ES: 001=
8 CR0: 000000008005003b
Feb  9 01:33:17 champagne kernel: [ 3689.392172] CR2: 00007f49ba397000 CR3:=
 000000006e112000 CR4: 00000000000006e0
Feb  9 01:33:17 champagne kernel: [ 3689.392174] DR0: 0000000000000000 DR1:=
 0000000000000000 DR2: 0000000000000000
Feb  9 01:33:17 champagne kernel: [ 3689.392176] DR3: 0000000000000000 DR6:=
 00000000ffff0ff0 DR7: 0000000000000400
Feb  9 01:33:17 champagne kernel: [ 3689.392178] Process xfsdatad/1 (pid: 2=
490, threadinfo ffff8801389a2000, task ffff880139f9cc50)
Feb  9 01:33:17 champagne kernel: [ 3689.392180] Stack:
Feb  9 01:33:17 champagne kernel: [ 3689.392181]  ffff8801389a3e50 ffffffff=
8022806f 0000000000000286 ffffffff8030be35
Feb  9 01:33:17 champagne kernel: [ 3689.392184]  ffff8800358efaf0 ffff8800=
379e7960 ffff88013880b088 ffff88013b85fee0
Feb  9 01:33:17 champagne kernel: [ 3689.392187]  ffff88013b85ff00 ffffffff=
a01c5269 ffffffffa01c53db ffff88013880b080
Feb  9 01:33:17 champagne kernel: [ 3689.392190] Call Trace:
Feb  9 01:33:17 champagne kernel: [ 3689.392191]  [<ffffffff8022806f>] ? ne=
ed_resched+0x1e/0x28
Feb  9 01:33:17 champagne kernel: [ 3689.392195]  [<ffffffff8030be35>] ? __=
up_write+0x12/0x45
Feb  9 01:33:17 champagne kernel: [ 3689.392201]  [<ffffffffa01c5269>] ? xf=
s_destroy_ioend+0x23/0x71 [xfs]
Feb  9 01:33:17 champagne kernel: [ 3689.392225]  [<ffffffffa01c53db>] ? xf=
s_end_bio_delalloc+0x0/0x19 [xfs]
Feb  9 01:33:17 champagne kernel: [ 3689.392243]  [<ffffffffa01c53db>] ? xf=
s_end_bio_delalloc+0x0/0x19 [xfs]
Feb  9 01:33:17 champagne kernel: [ 3689.392259]  [<ffffffff80242d5e>] ? ru=
n_workqueue+0x79/0xfe
Feb  9 01:33:17 champagne kernel: [ 3689.392263]  [<ffffffff80242ed3>] ? wo=
rker_thread+0xf0/0x102
Feb  9 01:33:17 champagne kernel: [ 3689.392265]  [<ffffffff802461cd>] ? au=
toremove_wake_function+0x0/0x2e
Feb  9 01:33:17 champagne kernel: [ 3689.392269]  [<ffffffff80242de3>] ? wo=
rker_thread+0x0/0x102
Feb  9 01:33:17 champagne kernel: [ 3689.392271]  [<ffffffff80245ea2>] ? kt=
hread+0x47/0x73
Feb  9 01:33:17 champagne kernel: [ 3689.392274]  [<ffffffff80231bfa>] ? sc=
hedule_tail+0x27/0x60
Feb  9 01:33:17 champagne kernel: [ 3689.392277]  [<ffffffff8020c3f9>] ? ch=
ild_rip+0xa/0x11
Feb  9 01:33:17 champagne kernel: [ 3689.392280]  [<ffffffff80245e5b>] ? kt=
hread+0x0/0x73
Feb  9 01:33:17 champagne kernel: [ 3689.392283]  [<ffffffff8020c3ef>] ? ch=
ild_rip+0x0/0x11
Feb  9 01:33:17 champagne kernel: [ 3689.392285] Code: 8b 46 18 48 8d 50 62=
 f0 80 48 62 20 48 8d 45 01 f0 80 4d 01 08 f0 80 65 00 fe f0 41 80 0e 02 4c=
 89 f7 e8 f4 e3 ff ff 85 c0 75 04 <0f> 0b eb fe 4d 8b 66 10 9c 41 5d fa eb =
13 f3 90 4c 89 e6 bf 04=20
Feb  9 01:33:17 champagne kernel: [ 3689.392307] RIP  [<ffffffff802b5c78>] =
end_buffer_async_write+0x8f/0x12c
Feb  9 01:33:17 champagne kernel: [ 3689.392310]  RSP <ffff8801389a3e40>
Feb  9 01:33:17 champagne kernel: [ 3689.392312] ---[ end trace 0c3741da6a2=
192b7 ]---

--=-rXq4RUyDVrzU2JG/c0Qa
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-rXq4RUyDVrzU2JG/c0Qa--
