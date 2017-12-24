Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:54650 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750968AbdLXJga (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 24 Dec 2017 04:36:30 -0500
Date: Sun, 24 Dec 2017 01:28:29 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: WARNING: CPU: 1 PID: 1384 at lib/iov_iter.c:695
 copy_page_to_iter+0x240/0x3b0
Message-ID: <alpine.DEB.2.21.9.1712240111060.5962@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Hi,

this just happened on an i686 machine of mine:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 1384 at lib/iov_iter.c:695 copy_page_to_iter+0x240/0x3b0
Modules linked in: xfs algif_skcipher af_alg uas nfsv4 dns_resolver nfs 
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_meta 
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 lz4 nf_defrag_ipv4 
lz4_compress nft_ct nf_conntrack libcrc32c crc32c_generic nft_set_hash 
nf_tables_inet nf_tables_ipv6 nf_tables_ipv4 nf_tables nfnetlink 
cpufreq_conservative sch_fq_codel zram evdev tg3 ptp pps_core lpc_ich 
libphy input_leds ideapad_laptop sparse_keymap wmi serpent_sse2_i586 
thermal serpent_generic lrw glue_helper ablk_helper cryptd video xts 
dm_crypt acpi_cpufreq arc4 iTCO_wdt iTCO_vendor_support i2c_i801 fscache 
loop coretemp battery b43 bcma mac80211 cfg80211 dm_mod dax ssb mmc_core 
rfkill led_class rng_core pcmcia pcmcia_core nfsd auth_rpcgss oid_registry 
ac nfs_acl lockd grace
 sunrpc usb_storage sd_mod atkbd libps2 uhci_hcd ata_piix libata scsi_mod 
ehci_pci ehci_hcd usbcore usb_common i8042 serio jfs [last unloaded: 
soundcore]
CPU: 1 PID: 1384 Comm: java Not tainted 4.14.4-1.0-ARCH #1
Hardware name: LENOVO                           Lenovo          /Mariana , BIOS 14CN94WW   06/29/2009
task: f27c1380 task.stack: f1c64000
EIP: copy_page_to_iter+0x240/0x3b0
EFLAGS: 00010286 CPU: 1
EAX: 00001000 EBX: ffb48000 ECX: 000002c0 EDX: 8001006c
ESI: f67ecb60 EDI: 00000d40 EBP: f1c65e30 ESP: f1c65e08
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 80050033 CR2: 09f060cc CR3: 3260f000 CR4: 000006d0
Call Trace:
 ? touch_atime+0x2b/0xb0
 generic_file_read_iter+0x458/0x8c0
 ? xfs_ilock+0x10d/0x150 [xfs]
 ? xfs_file_buffered_aio_read+0xed/0x100 [xfs]
 xfs_file_buffered_aio_read+0x4e/0x100 [xfs]
 ? set_next_entity+0x13f/0x8b0
 xfs_file_read_iter+0x54/0xc0 [xfs]
 __vfs_read+0xe7/0x140
 vfs_read+0x7b/0x130
 SyS_pread64+0x81/0xb0
 do_fast_syscall_32+0x71/0x1d0
 entry_SYSENTER_32+0x4e/0x7c
EIP: 0xb7f69cd9
EFLAGS: 00000293 CPU: 1
EAX: ffffffda EBX: 0000009b ECX: 23c77f10 EDX: 0000001a
ESI: 156172c0 EDI: 00000000 EBP: b7f50e70 ESP: 1f32ea60
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
Code: 75 ec e9 ff fe ff ff 8d 74 26 00 8b 55 ec 8b 45 08 85 d2 8b 58 0c 74 
09 e8 6e d7 ff ff 84 c0 75 1a 31 f6 e9 13 ff ff ff 8d 76 00 <0f> ff 31 f6 
83 c4 1c 5b 89 f0 5e 5f 5d c3 66 90 8b 7d 08 8b 45
---[ end trace 0002deba6d00a28c ]---



This i686 laptop is running 4.14.4-1.0-ARCH [0] and is usually running 
just fine, although memory pressure is usually quite hight due to some 
Java program running on that machine. For some reason the system was even 
more busy today, commands would take a long time to complete and I 
rebooted the machine. Shortly after boot (and after starting this Java 
program again), the warning above happened.

I couldn't find this exact message in the archives, the closest thing I 
found was (mentioning that "EIP:copy_page_to_iter" message):
 
 > 4879b7ae05 ("Merge tag 'dmaengine-4.12-rc1' of .."): WARNING: kernel 
 > stack regs at bd92bc2e in 01-cpu-hotplug:3811 has bad 'bp' value 000001be
 > https://patchwork.kernel.org/patch/9981273/

The XFS file system is mounted with:

 > XFS (dm-2): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
 > XFS (dm-2): EXPERIMENTAL reflink feature enabled. Use at your own risk!

But I did not experience any problems with that, yet :)

Full dmesg & .config: http://nerdbynature.de/bits/4.14/

Any pointers?

Thanks,
Christian.

$ mount | grep xfs
/dev/mapper/opt on /opt type xfs (rw,nosuid,nodev,relatime,attr2,inode64,noquota)

$ xfs_info /opt/
meta-data=/dev/mapper/opt        isize=512    agcount=4, agsize=9079797 
blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=1
         =                       reflink=1
data     =                       bsize=4096   blocks=36319185, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=17733, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


[0] https://mirror.archlinux32.org/i686/core/linux-4.14.4-1.0-i686.pkg.tar.xz
-- 
BOFH excuse #413:

Cow-tippers tipped a cow onto the server.
