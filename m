Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 597177CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 20:43:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2BEEF304032
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 18:43:15 -0700 (PDT)
Received: from mail-qk0-f172.google.com (mail-qk0-f172.google.com
	[209.85.220.172]) by cuda.sgi.com with ESMTP id
	q5AZa38ceHTC2N4B (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2016 18:43:12 -0700 (PDT)
Received: by mail-qk0-f172.google.com with SMTP id u63so16604830qkh.0
	for <xfs@oss.sgi.com>; Mon, 06 Jun 2016 18:43:12 -0700 (PDT)
MIME-Version: 1.0
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Date: Mon, 6 Jun 2016 19:43:11 -0600
Message-ID: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
Subject: crash in xfs in current
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Dear Dave and Everyone,

Today I crashed twice in a row in 4.7-rc1.
This was the message and trace:

Jun  6 18:07:34 router-dev kernel: [  134.297442] XFS: Assertion
failed: args->op_flags & XFS_DA_OP_OKNOENT, file:
fs/xfs/libxfs/xfs_dir2_leaf.c, line: 1307
Jun  6 18:07:34 router-dev kernel: [  134.297459] ------------[ cut
here ]------------
Jun  6 18:07:34 router-dev kernel: [  134.297474] kernel BUG at
fs/xfs/xfs_message.c:113!
Jun  6 18:07:34 router-dev kernel: [  134.297485] invalid opcode: 0000 [#1] SMP
Jun  6 18:07:34 router-dev kernel: [  134.297494] Modules linked in:
pl2303 usbserial snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic 8250_dw snd_hda_intel snd_hda_codec snd_hda_core
x86_pkg_temp_thermal snd_hwdep intel_powerclamp
i2c_designware_platform i2c_designware_core snd_pcm snd_seq_midi
snd_seq_midi_event coretemp kvm_intel kvm snd_rawmidi snd_seq
snd_seq_device iwlmvm irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel aes_x86_64 lrw snd_timer
glue_helper ablk_helper snd cryptd iwlwifi input_leds soundcore
serio_raw mei_me mei intel_lpss_acpi intel_lpss_pci acpi_als
intel_lpss shpchp binfmt_misc kfifo_buf industrialio acpi_pad mac_hid
parport_pc ppdev lp parport autofs4 xfs libcrc32c i
915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops hid_generic mxm_wmi r8169 ahci usbhid i2c_hid mii drm
libahci hid wmi video pinctrl_sunrisepoint pinctrl_intel
Jun  6 18:07:34 router-dev kernel: [  134.297712] CPU: 2 PID: 2115
Comm: aptitude Tainted: G     U          4.7.0-rc1-wt+ #8
Jun  6 18:07:34 router-dev kernel: [  134.297728] Hardware name: MSI
MS-7971/Z170A PC MATE (MS-7971), BIOS A.70 01/25/2016
Jun  6 18:07:34 router-dev kernel: [  134.297744] task:
ffff8804165f9e80 ti: ffff8803f7eb8000 task.ti: ffff8803f7eb8000
Jun  6 18:07:34 router-dev kernel: [  134.297759] RIP:
0010:[<ffffffffc0359080>]  [<ffffffffc0359080>] assfail+0x20/0x30
[xfs]
Jun  6 18:07:34 router-dev kernel: [  134.297796] RSP:
0018:ffff8803f7ebbbb8  EFLAGS: 00010246
Jun  6 18:07:34 router-dev kernel: [  134.297808] RAX:
0000000000000000 RBX: ffff8803fd5ce480 RCX: 0000000000000000
Jun  6 18:07:34 router-dev kernel: [  134.297822] RDX:
00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc038c74a
Jun  6 18:07:34 router-dev kernel: [  134.297837] RBP:
ffff8803f7ebbbb8 R08: 0000000000000000 R09: 0000000000000000
Jun  6 18:07:34 router-dev kernel: [  134.297852] R10:
000000000000000a R11: f000000000000000 R12: ffff8803fd5ce480
Jun  6 18:07:34 router-dev kernel: [  134.297874] R13:
0000000000000062 R14: ffff880035b5c000 R15: ffff8803fd5ce480
Jun  6 18:07:34 router-dev kernel: [  134.297889] FS:
00007ff14ad84780(0000) GS:ffff88046ec80000(0000)
knlGS:0000000000000000
Jun  6 18:07:34 router-dev kernel: [  134.297906] CS:  0010 DS: 0000
ES: 0000 CR0: 0000000080050033
Jun  6 18:07:34 router-dev kernel: [  134.297918] CR2:
000055b4b6869d98 CR3: 00000003f87f3000 CR4: 00000000003406e0
Jun  6 18:07:34 router-dev kernel: [  134.297932] DR0:
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun  6 18:07:34 router-dev kernel: [  134.297947] DR3:
0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun  6 18:07:34 router-dev kernel: [  134.297962] Stack:
Jun  6 18:07:34 router-dev kernel: [  134.297967]  ffff8803f7ebbc40
ffffffffc0322277 ffff8803f7ebbc58 00000000ffffffff
Jun  6 18:07:34 router-dev kernel: [  134.297986]  ffff8803ffffffff
ffff880414673840 ffff8803f610b000 0000000000000000
Jun  6 18:07:34 router-dev kernel: [  134.298004]  ffff880452bed380
0000000000000000 ffff003c00a7d2f1 00000000b56d2e47
Jun  6 18:07:34 router-dev kernel: [  134.298022] Call Trace:
Jun  6 18:07:34 router-dev kernel: [  134.298039]
[<ffffffffc0322277>] xfs_dir2_leaf_lookup_int+0x237/0x350 [xfs]
Jun  6 18:07:34 router-dev kernel: [  134.298064]
[<ffffffffc03229e1>] xfs_dir2_leaf_replace+0x41/0x190 [xfs]
Jun  6 18:07:34 router-dev kernel: [  134.298088]
[<ffffffffc031c06c>] xfs_dir_replace+0x18c/0x1b0 [xfs]
Jun  6 18:07:34 router-dev kernel: [  134.298114]
[<ffffffffc035653f>] xfs_rename+0x45f/0x9d0 [xfs]
Jun  6 18:07:34 router-dev kernel: [  134.298128]
[<ffffffff819ccf1f>] ? _raw_write_lock_irqsave+0x2f/0x40
Jun  6 18:07:34 router-dev kernel: [  134.298155]
[<ffffffffc034f892>] xfs_vn_rename+0xb2/0xe0 [xfs]
Jun  6 18:07:34 router-dev kernel: [  134.298169]
[<ffffffff8122e824>] vfs_rename+0x5a4/0x940
Jun  6 18:07:34 router-dev kernel: [  134.298182]
[<ffffffff81354900>] ? security_path_rename+0x90/0xe0
Jun  6 18:07:34 router-dev kernel: [  134.298195]
[<ffffffff81233475>] SyS_rename+0x3d5/0x3f0
Jun  6 18:07:34 router-dev kernel: [  134.298207]
[<ffffffff819cd236>] entry_SYSCALL_64_fastpath+0x1e/0xa8
Jun  6 18:07:34 router-dev kernel: [  134.298221] Code: 00 66 2e 0f 1f
84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 c7 c6 90 84
39 c0 48 89 fa 31 ff 48 89 e5 e8 b0 f8 ff ff <0f> 0b 0f 1f 40 00 66 2e
0f 1f 84 00 00 00 00 00 0f 1f 44 00
00
Jun  6 18:07:34 router-dev kernel: [  134.298312] RIP
[<ffffffffc0359080>] assfail+0x20/0x30 [xfs]
Jun  6 18:07:34 router-dev kernel: [  134.298339]  RSP <ffff8803f7ebbbb8>
Jun  6 18:07:34 router-dev kernel: [  134.303832] ---[ end trace
7894462e3381a043 ]---

0x760b0 is in assfail (fs/xfs/xfs_message.c:113).
108     void
109     assfail(char *expr, char *file, int line)
110     {
111             xfs_emerg(NULL, "Assertion failed: %s, file: %s, line: %d",
112                     expr, file, line);
113             BUG();
114     }
115
116     void
117     xfs_hex_dump(void *p, int length)

Ok, so this function is called.
The line is: ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
The function that the assert was called was:

/*
* Look up name/hash in the leaf block.
* Fill in indexp with the found index, and dbpp with the data buffer.
* If not found dbpp will be NULL, and ENOENT comes back.
* lbpp will always be filled in with the leaf buffer unless there's an error.
*/
static int                                      /* error */
xfs_dir2_leaf_lookup_int

The assert took place right after this loop:
        /*
        * Loop over all the entries with the right hash value
        * looking to match the name.
        */
       for (lep = &ents[index];
            index < leafhdr.count && be32_to_cpu(lep->hashval) == args->hashval;
            lep++, index++)

I seem to be able to hit this bug rather frequently.
So I put in some instrumentation to print out the flags next time I
hit it and save a core file to another fs.
Is this is known bug to you or?
Thanks,

Reinoud.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
