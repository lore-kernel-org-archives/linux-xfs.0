Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Aug 2008 11:08:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m78I8TL5013134
	for <xfs@oss.sgi.com>; Fri, 8 Aug 2008 11:08:30 -0700
Received: from dolly.gnuher.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8046D11F880C
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2008 11:09:42 -0700 (PDT)
Received: from dolly.gnuher.de (dolly.gnuher.de [212.227.64.154]) by cuda.sgi.com with ESMTP id JqNr6dgv8ppvDjYi for <xfs@oss.sgi.com>; Fri, 08 Aug 2008 11:09:42 -0700 (PDT)
Received: from ultimate100.geggus.net ([2a01:198:297:1::1])
	by dolly.gnuher.de (envelope-from
	<lists@fuchsschwanzdomain.de>)
	with esmtpsa (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	id 1KRWPF-000472-2A
	for xfs@oss.sgi.com; Fri, 08 Aug 2008 20:09:41 +0200
Received: from diesel.geggus.net ([192.168.3.2] ident=mail)
	by ultimate100.geggus.net (envelope-from
	<lists@fuchsschwanzdomain.de>)
	with esmtp (Exim 4.66)
	id 1KRWPD-0003jQ-8a
	for xfs@oss.sgi.com; Fri, 08 Aug 2008 20:09:39 +0200
Received: from sven  by diesel.geggus.net (envelope-from
	<lists@fuchsschwanzdomain.de>)
	with local (Exim 3.36)
	id 1KRWPD-0000zj-00
	for xfs@oss.sgi.com; Fri, 08 Aug 2008 20:09:39 +0200
Date: Fri, 8 Aug 2008 20:09:38 +0200
From: Sven Geggus <lists@fuchsschwanzdomain.de>
Subject: Ooops in Kernel 2.6.26.2
Message-ID: <20080808180938.GA3760@diesel.geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi there,

I've got a (somewhat) reproducable bug with Kernel 2.6.26.2

* Do an xfs-repair on the device (a dm-crypt in this case) just in
  case
* mount the device
* try to remove a given file (rm foo.html)

XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0
BUG: unable to handle kernel paging request at f3040f5f
IP: [<c01fd723>] xfs_log_done+0x86/0xa7
*pde = 35dea163 *pte = 33040160 
Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
Modules linked in: radeon drm rfcomm l2cap sym53c8xx scsi_transport_spi snd_via82xx 8139too snd_mpu401_uart snd_ens1371 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer via_agp snd_page_alloc agpgart

Pid: 4043, comm: rm Not tainted (2.6.26.2 #1)
EIP: 0060:[<c01fd723>] EFLAGS: 00010282 CPU: 0
EIP is at xfs_log_done+0x86/0xa7
EAX: 00000282 EBX: f3040f30 ECX: 00000000 EDX: f31d5c58
ESI: f304def0 EDI: 00000001 EBP: f31a5dcc ESP: f31a5db4
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process rm (pid: 4043, ti=f31a4000 task=f31d5c58 task.ti=f31a4000)
Stack: f47f8bf0 00000002 00000001 f31a5e04 0000000c f321ed88 f31a5ed4 c0206c8e 
       00000001 f3040f30 f321edb8 f321edb8 00000001 00000000 00000004 f31a5e0c 
       f47f8bf0 c020e7c9 c020e7c9 00000000 f321eed0 00000010 00000013 f47e2ab0 
Call Trace:
 [<c0206c8e>] ? _xfs_trans_commit+0x20c/0x36a
 [<c020e7c9>] ? kmem_zone_alloc+0x49/0x8f
 [<c020e7c9>] ? kmem_zone_alloc+0x49/0x8f
 [<c0207bbd>] ? xfs_trans_log_inode+0x14/0x2f
 [<c020d0ac>] ? xfs_remove+0x204/0x286
 [<c0214ba6>] ? xfs_vn_unlink+0x2e/0x4d
 [<c015e605>] ? vfs_unlink+0x5d/0xac
 [<c01601ab>] ? do_unlinkat+0x9b/0x133
 [<c0160253>] ? sys_unlink+0x10/0x12
 [<c0102cbe>] ? syscall_call+0x7/0xb
 =======================
Code: f6 43 2f 02 74 08 f7 c7 01 00 00 00 74 14 89 da 89 f0 e8 46 d7 ff ff 89 da 89 f0 e8 9e d9 ff ff eb 09 89 da 89 f0 e8 f6 fe ff ff <8a> 43 2f a8 02 74 0b 83 e7 01 75 06 83 c8 01 88 43 2f 8b 45 ec 
EIP: [<c01fd723>] xfs_log_done+0x86/0xa7 SS:ESP 0068:f31a5db4
---[ end trace fdfcf6b8ebb2164b ]---

Rebooting into my former kernel (2.6.25.10) I was now able to remove
the file without a kernel crash.

Unfortunately this may well mean that I can not reproduce this bug
anymore...

Sven

-- 
The main thing to note is that when you choose open source you don't
get a Windows operating system.
                                  (from http://www.dell.com/ubuntu)
/me is giggls@ircnet, http://sven.gegg.us/ on the Web
