Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 20:03:19 -0700 (PDT)
Received: from h1079484.serverkompetenz.net (ghostdub.de [81.169.157.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4G33EfB010782
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 20:03:15 -0700
Received: from hsi-kbw-091-089-007-028.hsi2.kabelbw.de ([91.89.7.28] helo=[192.168.1.129])
	by h1079484.serverkompetenz.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32)
	(Exim 4.50)
	id 1Ho992-0007Wg-TS
	for xfs@oss.sgi.com; Wed, 16 May 2007 04:21:41 +0200
Message-ID: <464A6AAD.1020408@rakka.de>
Date: Wed, 16 May 2007 04:21:33 +0200
From: outgoing@rakka.de
Reply-To: xfs@rakka.de
MIME-Version: 1.0
Subject: OOPS on 2.6.21-rc6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I got an oops while copying from an ro ntfs to a fresh xfs filesystem.
The cp process froze and was unkillable, some other processes also froze
(even though / was ext3).

After rebooting, recreating the xfs and starting the same copy process
again, another oops occured about 2G earlier than in the previous
copying. This time, nothing froze.

Kernel version: 2.6.21-rc6 #2 SMP PREEMPT i686 (self-compiled with
debian-lenny .config)
a "zgrep 4KSTACKS /proc/config.gz" shows nothing.



First oops:
BUG: unable to handle kernel paging request at virtual address 0000a702
 printing eip:
c018559f
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP
Modules linked in: usb_storage fuse nls_iso8859_1 isofs udf snd_rtctimer
xfs binfmt_misc radeon drm nfs nfsd exportfs lockd nfs_acl sunrpc ppdev
lp button ac battery ipv6 nls_utf8 ntfs sha256 aes cbc blkcipher
dm_crypt dm_snapshot dm_mirror sbp2 loop dm_mod snd_via82xx
snd_mpu401_uart snd_emu10k1_synth snd_emux_synth snd_seq_virmidi
snd_seq_midi_emul snd_emu10k1 firmware_class snd_ac97_codec ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_util_mem snd_hwdep
snd_seq_dummy snd_seq_midi snd_seq_oss snd_rawmidi snd_seq_midi_event
via_ircc parport_pc parport analog snd_seq snd_timer snd_seq_device irda
rtc pcspkr crc_ccitt i2c_viapro i2c_core snd emu10k1_gp gameport
soundcore shpchp pci_hotplug via_agp agpgart eth1394 tsdev evdev ext3
jbd mbcache raid10 raid456 xor raid1 raid0 multipath linear md_mod
ide_cd cdrom ide_disk ata_generic pata_via usbhid hid via82cxxx sd_mod
floppy via_rhine mii generic ide_core ehci_hcd r8169 uhci_hcd usbcore
ohci1394 ieee1394 sata_promise libata scsi_mod thermal processor fan
CPU:    0
EIP:    0060:[<c018559f>]    Not tainted VLI
EFLAGS: 00010002   (2.6.21-rc6 #2)
EIP is at end_buffer_async_write+0xbf/0x165
eax: f5722000   ebx: ca81af98   ecx: ca81af98   edx: 00000001
esi: 0000a702   edi: 00000202   ebp: c10cdbe8   esp: f5723f20
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process xfsdatad/0 (pid: 4618, ti=f5722000 task=f57c0540 task.ti=f5722000)
Stack: c0353fc8 c02a5d99 f5723f8c c02a5dc5 00000003 f5788be8 00000000
00000001
       f5723f64 c011c55f c3645c18 d114e2b0 00000202 d114e2d8 f94ec45d
f57c064c
       d114e2dc f5788bc0 c0130b6b 00000000 1bd31201 0000007b 00000202
f94ec4ea
Call Trace:
 [<c02a5d99>] __sched_text_start+0x689/0x738
 [<c02a5dc5>] __sched_text_start+0x6b5/0x738
 [<c011c55f>] __wake_up+0x32/0x43
 [<f94ec45d>] xfs_destroy_ioend+0x1d/0x56 [xfs]
 [<c0130b6b>] run_workqueue+0x85/0x125
 [<f94ec4ea>] xfs_end_bio_delalloc+0x0/0x8 [xfs]
 [<c0131492>] worker_thread+0xf9/0x124
 [<c011e5e2>] default_wake_function+0x0/0xc
 [<c0131399>] worker_thread+0x0/0x124
 [<c0133c01>] kthread+0xb2/0xdd
 [<c0133b4f>] kthread+0x0/0xdd
 [<c0104abf>] kernel_thread_helper+0x7/0x10
 =======================
Code: eb 28 89 e0 25 00 e0 ff ff ff 48 14 8b 40 08 a8 08 74 05 e8 6b 09
12 00 f3 90 89 e0 25 00 e0 ff ff ff 40 14 8b 06 a8 10 75 d8 90 <0f> ba
2e 04 19 c0 85 c0 75 ef 90 0f ba 33 08 89 d8 e8 ea ec ff
EIP: [<c018559f>] end_buffer_async_write+0xbf/0x165 SS:ESP 0068:f5723f20
note: xfsdatad/0[4618] exited with preempt_count 1



Second oops:
BUG: unable to handle kernel paging request at virtual address 287d423e
 printing eip:
f8f22e9f
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: binfmt_misc radeon drm nfs nfsd exportfs lockd
nfs_acl sunrpc ppdev lp button ac battery ipv6 xfs nls_utf8 ntfs fuse
sha256 aes cbc blkcipher dm_crypt dm_snapshot dm_mirror sbp2 loop dm_mod
snd_via82xx snd_mpu401_uart snd_emu10k1_synth snd_emux_synth
snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 firmware_class
snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc
snd_util_mem snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi
snd_seq_midi_event via_ircc snd_seq irda analog crc_ccitt parport_pc
parport i2c_viapro snd_timer snd_rawmidi snd_seq_device pcspkr i2c_core
snd via_agp agpgart rtc emu10k1_gp gameport soundcore shpchp pci_hotplug
tsdev evdev eth1394 ext3 jbd mbcache raid10 raid456 xor raid1 raid0
multipath linear md_mod ide_cd cdrom ide_disk ata_generic pata_via
usbhid hid via82cxxx sd_mod floppy via_rhine mii ehci_hcd generic
ide_core uhci_hcd usbcore r8169 ohci1394 ieee1394 sata_promise libata
scsi_mod thermal processor fan
CPU:    0
EIP:    0060:[<f8f22e9f>]    Not tainted VLI
EFLAGS: 00010203   (2.6.21-rc6 #2)
EIP is at xfs_count_page_state+0x27/0x62 [xfs]
eax: 2133c724   ebx: ec1bc128   ecx: c1b5de08   edx: 287d423e
esi: c1b5de04   edi: c1b5de0c   ebp: eec39400   esp: c1b5ddc4
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process kswapd0 (pid: 131, ti=c1b5c000 task=c1af0580 task.ti=c1b5c000)
Stack: c11677a0 000000d0 c1b5de04 f8f23d06 c1b5de04 ef946c50 00000000
00000001
       00000000 00000001 00000000 00000000 00000000 00000000 00000000
00000000
       00000001 00000000 00000000 f8f23cbb 000000d0 00000001 c032cac0
c014f9cc
Call Trace:
 [<f8f23d06>] xfs_vm_releasepage+0x4b/0xa5 [xfs]
 [<f8f23cbb>] xfs_vm_releasepage+0x0/0xa5 [xfs]
 [<c014f9cc>] try_to_release_page+0x30/0x42
 [<c0155064>] shrink_inactive_list+0x459/0x747
 [<c011e5d8>] try_to_wake_up+0x3a1/0x3ab
 [<c02a5d99>] __sched_text_start+0x689/0x738
 [<c02a5dc5>] __sched_text_start+0x6b5/0x738
 [<f9123127>] nfs_access_cache_shrinker+0x137/0x182 [nfs]
 [<c015541f>] shrink_zone+0xcd/0xf2
 [<c01558f1>] kswapd+0x2be/0x3ef
 [<c0133cd4>] autoremove_wake_function+0x0/0x35
 [<c0155633>] kswapd+0x0/0x3ef
 [<c0133c01>] kthread+0xb2/0xdd
 [<c0133b4f>] kthread+0x0/0xdd
 [<c0104abf>] kernel_thread_helper+0x7/0x10
 =======================
Code: 5f 89 d0 c3 57 89 d7 56 53 8b 74 24 10 89 c3 31 c0 c7 06 00 00 00
00 89 01 89 02 8b 03 f6 c4 08 75 04 0f 0b eb fe 8b 5b 0c 89 da <8b> 02
a8 01 74 0e 8b 02 a8 20 75 08 c7 01 01 00 00 00 eb 1c 8b
EIP: [<f8f22e9f>] xfs_count_page_state+0x27/0x62 [xfs] SS:ESP 0068:c1b5ddc4


    - Paul Goeser
