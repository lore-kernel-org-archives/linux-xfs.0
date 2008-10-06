Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Oct 2008 15:24:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m96MONiI028381
	for <xfs@oss.sgi.com>; Mon, 6 Oct 2008 15:24:24 -0700
Received: from mail1.g-b.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03CF74BECFE
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2008 15:26:01 -0700 (PDT)
Received: from mail1.g-b.net (mail1.g-b.net [64.191.66.247]) by cuda.sgi.com with ESMTP id KcyzlRuDYNkLqpLU for <xfs@oss.sgi.com>; Mon, 06 Oct 2008 15:26:01 -0700 (PDT)
Message-ID: <48EA9076.5030800@g-b.net>
Date: Mon, 06 Oct 2008 23:25:58 +0100
From: Albert Graham <albert.graham@g-b.net>
Reply-To: albert.graham@g-b.net
MIME-Version: 1.0
Subject: Re: XFS Regression Issue in kernel 2.6.26.3
References: <48E51BF5.3080100@g-b.net> <20081002235211.GI30001@disturbed>
In-Reply-To: <20081002235211.GI30001@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Albert Graham <albert.graham@g-b.net>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Thu, Oct 02, 2008 at 08:07:33PM +0100, Albert Graham wrote:
>> Hi Guys,
>>
>> I use Fedora 8 as my MythTV backend server which uses XFS, ISince 
>> upgrading from kernel-2.6.25 to kernel-2.6.26 I've been getting the 
>> following errors (see below).
> 
> The freespace btrees are getting out of sync for some reason.
> 
> That is, when we go to allocate an extent, we have to update two
> free space btrees. This shutdown:
> 
>> XFS internal error XFS_WANT_CORRUPTED_RETURN at line 280 of file fs/xfs/xfs_alloc.c.  Caller 0xf88e0018
> 
> Indicates the extent being allocated was not found in one of the
> two trees.
> 
> This corruption could have happened a long time ago in the past, and
> it may simply be coincidental that you've tripped over this at
> roughly the same time you upgraded the kernel.
> 
> Can you run xfs_check on the filesystem to determine if a freespace
> tree is corrupted (post the output if it is), then run xfs_repair
> to rebuild them?
> 
> Cheers,
> 
> Dave.

Hi Dave,


Thanks for responding, I've just spotted your mail.

You are correct on all assumptions.

1. The disk was almost full - 8G free of 1024G
2. I do think this happened sometime ago and the kernel update was coincidental - as previous kernels had same response.
3. xfs_repair did fix it (output was lost as I repaired it before reading your response - but see below)

In my case I have a 1TB file/dd image using XFS which is sitting on a 7TB XFS formatted disk.

The 1TB file was where there error was occuring, this file was mounted via losetup (/dev/loop7), however when I tried to 
mount it I got a segmentation fault and the following message

/usr/sbin/xfs_check: line 28:  3230 Floating point exceptionxfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1

I did search google for it (and google saved it for me, which is how I recalled it)


I also got a kernel panic/trace error which was logged via syslog, so that is posted below - hope this helps.

I had to use "xfs_repair -L /dev/loop7" to fix it as I was unable to replay the log via mounting, all seems fine now :)

I'm not able to show the output of the fixing process, but it was only about 20 lines long, mostly stating:

ag1
ag2
some other stuff..
ag3
etc..

Hope this helps - and thanks for your response.

Albert.


syslog output
==============

Oct  6 08:09:43 agraham kernel: BUG: unable to handle kernel NULL pointer dereference at 0000005c
Oct  6 08:09:43 agraham kernel: IP: [<f88e0cd0>] :xfs:xfs_alloc_increment+0xd9/0x155
Oct  6 08:09:43 agraham kernel: *pdpt = 0000000036451001 *pde = 000000023d1fc067
Oct  6 08:09:43 agraham kernel: Oops: 0000 [#1] SMP
Oct  6 08:09:43 agraham kernel: Modules linked in: sha256_generic aes_i586 aes_generic cbc dm_crypt crypto_blkcipher aoe 
nvidia(P)(U) tun saa7134_alsa loop nfsd lockd nfs_acl auth_rpcgss exportfs coretemp w83627ehf w83791d hwmon_vid hwmon 
sunrpc ipv6 bridge ext3 jbd mbcache dm_mirror dm_log dm_multipath dm_mod snd_emu10k1_synth snd_emux_synth sr_mod cdrom 
snd_seq_virmidi snd_seq_midi_emul ata_generic tuner_simple tuner_types tuner snd_emu10k1 snd_ac97_codec ac97_bus 
snd_usb_audio snd_usb_lib snd_rawmidi pata_acpi snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event saa7134 
snd_seq videodev snd_pcm_oss v4l1_compat snd_mixer_oss compat_ioctl32 v4l2_common videobuf_dma_sg videobuf_core snd_pcm 
ir_kbd_i2c snd_seq_device ir_common snd_timer snd_util_mem tveeprom snd_page_alloc pata_jmicron snd_hwdep firewire_ohci 
firewire_core pcspkr snd sky2 crc_itu_t iTCO_wdt i2c_i801 iTCO_vendor_support soundcore sg i2c_core ata_piix 
sata_promise ahci libata 3w_9xxx sd_mod scsi_mod xfs uhci_hcd ohci_hcd ehci_hcd [last unloade
Oct  6 08:09:43 agraham kernel: d: nvidia]
Oct  6 08:09:43 agraham kernel:
Oct  6 08:09:43 agraham kernel: Pid: 15036, comm: mount Tainted: P          (2.6.26.3-14.fc8PAE #1)
Oct  6 08:09:43 agraham kernel: EIP: 0060:[<f88e0cd0>] EFLAGS: 00010246 CPU: 3
Oct  6 08:09:43 agraham kernel: EIP is at xfs_alloc_increment+0xd9/0x155 [xfs]
Oct  6 08:09:43 agraham kernel: EAX: 00000000 EBX: f7d3af58 ECX: ee8ce000 EDX: 00000003
Oct  6 08:09:43 agraham kernel: ESI: f7d3af30 EDI: 00000002 EBP: f6d69b74 ESP: f6d69b58
Oct  6 08:09:43 agraham kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Oct  6 08:09:43 agraham kernel: Process mount (pid: 15036, ti=f6d69000 task=f5063200 task.ti=f6d69000)
Oct  6 08:09:43 agraham kernel: Stack: f6d69bf8 00000000 f7d3af95 00000000 000000fe 000000fd 00000000 f6d69c08
Oct  6 08:09:43 agraham kernel:        f88e1fb8 2c0018f8 ee8ce800 00000008 00000000 f6d69ba4 f6d69c14 00000000
Oct  6 08:09:43 agraham kernel:        f7d3a000 00000000 ee8d3200 ee8ce000 f6d69bc0 f51d8a80 0001f9c1 ee8ce000
Oct  6 08:09:43 agraham kernel: Call Trace:
Oct  6 08:09:43 agraham kernel:  [<f88e1fb8>] ? xfs_alloc_delrec+0x3b4/0x991 [xfs]
Oct  6 08:09:43 agraham kernel:  [<f88e25b8>] ? xfs_alloc_delete+0x23/0x72 [xfs]
Oct  6 08:09:43 agraham kernel:  [<f88df07f>] ? xfs_free_ag_extent+0x36d/0x574 [xfs]
Oct  6 08:09:43 agraham kernel:  [<f88e06a0>] ? xfs_free_extent+0xa9/0xc5 [xfs]
Oct  6 08:09:43 agraham kernel:  [<f8910cb1>] ? xlog_grant_log_space+0x1ad/0x1f2 [xfs]
Oct  6 08:09:43 agraham kernel:  [<f89235b6>] ? kmem_zone_alloc+0x4a/0x90 [xfs]
Oct  6 08:09:43 agraham kernel:  [<f8911d95>] ? xlog_recover_process_efi+0x185/0x1df [xfs]
Oct  6 08:09:43 agraham kernel:  [<f8913090>] ? xlog_recover_process_efis+0x42/0x73 [xfs]
Oct  6 08:09:43 agraham kernel:  [<f89130d6>] ? xlog_recover_finish+0x15/0x9c [xfs]
Oct  6 08:09:43 agraham kernel:  [<f890f278>] ? xfs_log_mount_finish+0x2c/0x35 [xfs]
Oct  6 08:09:43 agraham kernel:  [<f89184f7>] ? xfs_mountfs+0x46a/0x607 [xfs]
Oct  6 08:09:43 agraham kernel:  [<f89237a7>] ? kmem_zalloc+0x10/0x38 [xfs]
Oct  6 08:09:43 agraham kernel:  [<f8918c9e>] ? xfs_mru_cache_create+0xdf/0x10f [xfs]
Oct  6 08:09:43 agraham kernel:  [<f891e651>] ? xfs_mount+0x25f/0x2fa [xfs]
Oct  6 08:09:43 agraham kernel:  [<f892c138>] ? xfs_fs_fill_super+0xa7/0x1bf [xfs]
Oct  6 08:09:43 agraham kernel:  [<c048a909>] ? get_sb_bdev+0xca/0x110
Oct  6 08:09:43 agraham kernel:  [<f892aaca>] ? xfs_fs_get_sb+0x13/0x15 [xfs]
Oct  6 08:09:43 agraham kernel:  [<f892c091>] ? xfs_fs_fill_super+0x0/0x1bf [xfs]
Oct  6 08:09:43 agraham kernel:  [<c048a3f3>] ? vfs_kern_mount+0x81/0xf7
Oct  6 08:09:43 agraham kernel:  [<c048a4ad>] ? do_kern_mount+0x32/0xb9
Oct  6 08:09:43 agraham kernel:  [<c049d11c>] ? do_new_mount+0x46/0x71
Oct  6 08:09:43 agraham kernel:  [<c049d2f7>] ? do_mount+0x1b0/0x1ce
Oct  6 08:09:43 agraham kernel:  [<c046a0db>] ? __get_free_pages+0x1b/0x21
Oct  6 08:09:43 agraham kernel:  [<c049b313>] ? copy_mount_options+0x27/0x10b
Oct  6 08:09:43 agraham kernel:  [<c049d379>] ? sys_mount+0x64/0x9b
Oct  6 08:09:43 agraham kernel:  [<c0403b63>] ? sysenter_past_esp+0x78/0xb1
Oct  6 08:09:43 agraham kernel:  =======================
Oct  6 08:09:43 agraham kernel: Code: 83 c8 02 39 d0 74 0e b9 02 00 00 00 89 fa 89 f0 e8 09 51 01 00 ff 45 ec 47 83 c3 
04 0f b6 46 6c 39 c7 7c b4 8b 44 be 24 89 45 f0 <8b> 58 5c eb 5f 8b 46 04 8b 54 be 44 8b 88 98 01 00 00 c1 e2 02
Oct  6 08:09:43 agraham kernel: EIP: [<f88e0cd0>] xfs_alloc_increment+0xd9/0x155 [xfs] SS:ESP 0068:f6d69b58
Oct  6 08:09:43 agraham kernel: ---[ end trace 90b4802fd284c865 ]---
