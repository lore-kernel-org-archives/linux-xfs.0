Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7CDAE7F3F
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 12:08:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 104C5AC002
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 10:08:01 -0700 (PDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	fKyPC9QyekedLuS2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Aug 2014 10:07:58 -0700 (PDT)
Received: by mail-wi0-f180.google.com with SMTP id n3so1119862wiv.7
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 10:07:57 -0700 (PDT)
Message-ID: <FD1EFC95933E43F49A5588ECF9C93B93@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <4B2A412C75324EE9880358513C069476@alyakaslap>
	<9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
	<20140804230721.GA20518@dastard>
	<AC10852F403846A182491ED8071135ED@alyakaslap>
	<20140806152042.GB39990@bfoster.bfoster>
	<CAOcd+r3bC59m7Rh-3tmjrnWnF5XoPQfE=U+=hz78NcAGu+Ou1g@mail.gmail.com>
	<20140811132057.GA1186@bfoster.bfoster>
	<20140811215207.GS20518@dastard>
	<20140812120341.GA46654@bfoster.bfoster>
	<DC407F6E8F8C4EE1AF7117D7D6ABF282@alyakaslap>
	<20140812235615.GB20518@dastard>
In-Reply-To: <20140812235615.GB20518@dastard>
Subject: Re: use-after-free on log replay failure
Date: Wed, 13 Aug 2014 20:07:58 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

Hi Dave,
I compiled kernel 3.16 today, top commit being:
commit 19583ca584d6f574384e17fe7613dfaeadcdc4a6
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Aug 3 15:25:02 2014 -0700

    Linux 3.16


(also had to use the updated copy of dm-linear from 3.16).

I would say that the problem reproduces, but it looks a little differently. 
Typical flow is:

Aug 13 19:45:48 vc-00-00-1383-dev kernel: [  143.521383] XFS (dm-0): 
Mounting V4 Filesystem
Aug 13 19:45:48 vc-00-00-1383-dev kernel: [  143.558558] XFS (dm-0): Sleep 
10s before log recovery
Aug 13 19:45:58 vc-00-00-1383-dev kernel: [  153.560139] XFS (dm-0): 
Starting recovery (logdev: internal)
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.085826] XFS (dm-0): 
metadata I/O error: block 0x1 ("xlog_recover_iodone") error 28 numblks 1
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.087336] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 383 of file 
/mnt/share/src/linux-mainline/fs/xfs/xfs_log_recover.c.  Return address = 
0xffffffffa030d5f8
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.087341] XFS (dm-0): I/O 
Error Detected. Shutting down filesystem
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.088455] XFS (dm-0): Please 
umount the filesystem and rectify the problem(s)
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.088601] XFS (dm-0): 
metadata I/O error: block 0x8 ("xlog_recover_iodone") error 28 numblks 8
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.088605] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 383 of file 
/mnt/share/src/linux-mainline/fs/xfs/xfs_log_recover.c.  Return address = 
0xffffffffa030d5f8
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.088658] XFS (dm-0): 
metadata I/O error: block 0x10 ("xlog_recover_iodone") error 28 numblks 8
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.088663] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 383 of file 
/mnt/share/src/linux-mainline/fs/xfs/xfs_log_recover.c.  Return address = 
0xffffffffa030d5f8
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.088702] XFS (dm-0): 
metadata I/O error: block 0x40 ("xlog_recover_iodone") error 28 numblks 16
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.088714] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 383 of file 
/mnt/share/src/linux-mainline/fs/xfs/xfs_log_recover.c.  Return address = 
0xffffffffa030d5f8
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.088719] XFS (dm-0): 
metadata I/O error: block 0xa00060 ("xlog_recover_iodone") error 28 numblks 
16
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.088731] XFS (dm-0): 
xfs_do_force_shutdown(0x1) called from line 383 of file 
/mnt/share/src/linux-mainline/fs/xfs/xfs_log_recover.c.  Return address = 
0xffffffffa030d5f8
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.096288] XFS (dm-0): log 
mount/recovery failed: error 28
Aug 13 19:45:59 vc-00-00-1383-dev kernel: [  154.096482] XFS (dm-0): log 
mount failed

So there is no clearly-looking problem like with my development kernel 
(which also had KMEMLEAK enabled, which changes timings significantly). 
However, after several seconds, kernel panics sporadically with stacks like 
[1], [2], and sometimes KVM dies on me with messages like[3], [4]. So 
definitely this test corrupts some internal kernel structures, and with 
KMEMLEAK enabled this corruption is more clear.

I put the metadump from this experiment here:
https://drive.google.com/file/d/0ByBy89zr3kJNSGxoc3U4X1lOZ2s/edit?usp=sharing

Thanks,
Alex.


[1]
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.223389] BUG: unable to 
handle kernel paging request at 00007f9e50678000
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] IP: 
[<ffffffff811923a8>] kmem_cache_alloc+0x68/0x160
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] PGD 362b8067 PUD 
7a9d9067 PMD 7849f067 PTE 0
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] Oops: 0000 [#1] SMP
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] Modules linked in: 
xfs(O) libcrc32c dm_linear_custom(O) deflate ctr twofish_generic 
twofish_x86_64_3way glue_helper lrw xts gf128mul twofish_x86_64 
twofish_common camellia_generic serpent_generic blowfish_generic 
blowfish_x86_64 blowfish_common cast5_generic cast_common des_generic cmac 
xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo dm_round_robin nfsd 
nfs_acl ppdev dm_multipath psmouse parport_pc serio_raw i2c_piix4 mac_hid lp 
rpcsec_gss_krb5 parport auth_rpcgss oid_registry nfsv4 nfs fscache lockd 
sunrpc floppy
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] CPU: 1 PID: 3302 
Comm: cron Tainted: G           O  3.16.0-999-generic #201408131143
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] Hardware name: 
Bochs Bochs, BIOS Bochs 01/01/2007
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] task: 
ffff88007a9d48c0 ti: ffff88007aeb0000 task.ti: ffff88007aeb0000
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] RIP: 
0010:[<ffffffff811923a8>]  [<ffffffff811923a8>] kmem_cache_alloc+0x68/0x160
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] RSP: 
0018:ffff88007aeb3cc0  EFLAGS: 00010286
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] RAX: 
0000000000000000 RBX: ffff88007a137048 RCX: 000000000001ff04
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] RDX: 
000000000001ff03 RSI: 00000000000000d0 RDI: 0000000000015d20
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] RBP: 
ffff88007aeb3d10 R08: ffff88007fc95d20 R09: 0000000000000003
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] R10: 
0000000000000003 R11: ffff8800362b83d0 R12: ffff88007d001b00
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] R13: 
00007f9e50678000 R14: ffffffff811767fd R15: 00000000000000d0
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] FS: 
00007f9e5066b7c0(0000) GS:ffff88007fc80000(0000) knlGS:0000000000000000
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] CS:  0010 DS: 0000 
ES: 0000 CR0: 000000008005003b
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] CR2: 
00007f9e50678000 CR3: 0000000036743000 CR4: 00000000000006e0
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] Stack:
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019]  00007f9e4e9d4fff 
ffffffff811767d6 0000000000000040 0000000000000048
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019]  ffff88007aeb3d40 
ffff88007a137048 ffff88007af7cb80 ffff880079814da8
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019]  ffff88007af7cc38 
ffff88007af7cc48 ffff88007aeb3d40 ffffffff811767fd
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] Call Trace:
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff811767d6>] ? anon_vma_fork+0x56/0x130
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff811767fd>] anon_vma_fork+0x7d/0x130
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff816d0426>] dup_mmap+0x1c5/0x380
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff816d069f>] dup_mm+0xbe/0x155
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff816d07fc>] copy_mm+0xc6/0xe9
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff81054174>] copy_process.part.35+0x694/0xe90
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff810549f0>] copy_process+0x80/0x90
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff81054b12>] do_fork+0x62/0x280
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff812ca6ee>] ? cap_task_setnice+0xe/0x10
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff812cbfd6>] ? security_task_setnice+0x16/0x20
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff8106a648>] ? set_one_prio+0x88/0xd0
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff81054db6>] SyS_clone+0x16/0x20
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff816e9b39>] stub_clone+0x69/0x90
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] 
[<ffffffff816e9812>] ? system_call_fastpath+0x16/0x1b
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] Code: 00 49 8b 50 
08 4d 8b 28 49 8b 40 10 4d 85 ed 0f 84 e6 00 00 00 48 85 c0 0f 84 dd 00 00 
00 49 63 44 24 20 49 8b 3c 24 48 8d 4a 01 <49> 8b 5c 05 00 4c 89 e8 65 48 0f 
c7 0f 0f 94 c0 84 c0 74 b5 49
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] RIP 
[<ffffffff811923a8>] kmem_cache_alloc+0x68/0x160
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019]  RSP 
<ffff88007aeb3cc0>
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.224019] CR2: 
00007f9e50678000
Aug 13 19:46:01 vc-00-00-1383-dev kernel: [  156.276967] ---[ end trace 
56118c807adeb6de ]---
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.136602] BUG: unable to 
handle kernel paging request at 00007f9e50678000
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.137877] IP: 
[<ffffffff811917ac>] kmem_cache_alloc_trace+0x6c/0x160
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.139042] PGD 79732067 PUD 0
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.139645] Oops: 0000 [#2] SMP
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] Modules linked in: 
xfs(O) libcrc32c dm_linear_custom(O) deflate ctr twofish_generic 
twofish_x86_64_3way glue_helper lrw xts gf128mul twofish_x86_64 
twofish_common camellia_generic serpent_generic blowfish_generic 
blowfish_x86_64 blowfish_common cast5_generic cast_common des_generic cmac 
xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo dm_round_robin nfsd 
nfs_acl ppdev dm_multipath psmouse parport_pc serio_raw i2c_piix4 mac_hid lp 
rpcsec_gss_krb5 parport auth_rpcgss oid_registry nfsv4 nfs fscache lockd 
sunrpc floppy
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] CPU: 1 PID: 1688 
Comm: whoopsie Tainted: G      D    O  3.16.0-999-generic #201408131143
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] Hardware name: 
Bochs Bochs, BIOS Bochs 01/01/2007
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] task: 
ffff88007c261840 ti: ffff8800799a8000 task.ti: ffff8800799a8000
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] RIP: 
0010:[<ffffffff811917ac>]  [<ffffffff811917ac>] 
kmem_cache_alloc_trace+0x6c/0x160
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] RSP: 
0018:ffff8800799abdd8  EFLAGS: 00010286
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] RAX: 
0000000000000000 RBX: ffff88007bd0e080 RCX: 000000000001ff04
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] RDX: 
000000000001ff03 RSI: 00000000000000d0 RDI: 0000000000015d20
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] RBP: 
ffff8800799abe28 R08: ffff88007fc95d20 R09: 0000000000000000
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] R10: 
0000000000000000 R11: 0000000000000246 R12: ffff88007d001b00
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] R13: 
00007f9e50678000 R14: ffffffff815bbbdb R15: 00000000000000d0
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] FS: 
00007fa0248e37c0(0000) GS:ffff88007fc80000(0000) knlGS:0000000000000000
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] CS:  0010 DS: 0000 
ES: 0000 CR0: 0000000080050033
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] CR2: 
00007f9e50678000 CR3: 00000000367c0000 CR4: 00000000000006e0
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] Stack:
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050]  ffff88007c7ee780 
ffffffff815bbbbd 0000000000000040 0000000000000280
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050]  ffff8800799abe08 
ffff88007bd0e080 0000000000000000 0000000000000000
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050]  0000000000000000 
0000000000000000 ffff8800799abe58 ffffffff815bbbdb
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] Call Trace:
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] 
[<ffffffff815bbbbd>] ? sock_alloc_inode+0x2d/0xd0
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] 
[<ffffffff815bbbdb>] sock_alloc_inode+0x4b/0xd0
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] 
[<ffffffff811bb326>] alloc_inode+0x26/0xa0
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] 
[<ffffffff811bcce3>] new_inode_pseudo+0x13/0x60
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] 
[<ffffffff815bbe8e>] sock_alloc+0x1e/0x80
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] 
[<ffffffff815be2d5>] __sock_create+0x95/0x200
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] 
[<ffffffff815be4a0>] sock_create+0x30/0x40
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] 
[<ffffffff815bf5a6>] SyS_socket+0x36/0xb0
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] 
[<ffffffff816e9812>] system_call_fastpath+0x16/0x1b
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] Code: 00 49 8b 50 
08 4d 8b 28 49 8b 40 10 4d 85 ed 0f 84 e2 00 00 00 48 85 c0 0f 84 d9 00 00 
00 49 63 44 24 20 49 8b 3c 24 48 8d 4a 01 <49> 8b 5c 05 00 4c 89 e8 65 48 0f 
c7 0f 0f 94 c0 84 c0 74 b5 49
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] RIP 
[<ffffffff811917ac>] kmem_cache_alloc_trace+0x6c/0x160
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050]  RSP 
<ffff8800799abdd8>
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.140050] CR2: 
00007f9e50678000
Aug 13 19:46:12 vc-00-00-1383-dev kernel: [  167.185653] ---[ end trace 
56118c807adeb6df ]---


[2]
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.566506] BUG: unable to 
handle kernel paging request at 00007f41d65a100c
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.567769] IP: 
[<ffffffff81406a47>] vring_add_indirect+0x87/0x210
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.568859] PGD 7b4a7067 PUD 
7b4a8067 PMD 7b4aa067 PTE 8000000076f5b065
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570055] Oops: 0003 [#1] SMP
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Modules linked in: 
xfs(O) libcrc32c dm_linear_custom(O) deflate ctr twofish_generic 
twofish_x86_64_3way glue_helper lrw xts gf128mul twofish_x86_64 
twofish_common camellia_generic serpent_generic blowfish_generic 
blowfish_x86_64 blowfish_common cast5_generic cast_common des_generic cmac 
xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo nfsd nfs_acl 
dm_round_robin ppdev parport_pc mac_hid dm_multipath i2c_piix4 psmouse 
serio_raw rpcsec_gss_krb5 auth_rpcgss oid_registry lp nfsv4 parport nfs 
fscache lockd sunrpc floppy
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] CPU: 3 PID: 3329 
Comm: mount Tainted: G           O  3.16.0-999-generic #201408131143
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Hardware name: 
Bochs Bochs, BIOS Bochs 01/01/2007
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] task: 
ffff88007b2ac8c0 ti: ffff88007a900000 task.ti: ffff88007a900000
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RIP: 
0010:[<ffffffff81406a47>]  [<ffffffff81406a47>] 
vring_add_indirect+0x87/0x210
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RSP: 
0018:ffff88007a903688  EFLAGS: 00010006
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RAX: 
ffff88007a9037b8 RBX: ffff88007a903788 RCX: 00007f41d65a1000
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RDX: 
000000000001da11 RSI: 0000160000000000 RDI: ffff88007a9037b8
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RBP: 
ffff88007a9036d8 R08: ffff88007fd95d20 R09: ffffffff814069f6
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] R10: 
0000000000000003 R11: ffff88007a903860 R12: ffffffff81406cb0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] R13: 
ffff88007c9ae000 R14: 0000000000000000 R15: 00007f41d65a1000
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] FS: 
00007f41d67b5800(0000) GS:ffff88007fd80000(0000) knlGS:0000000000000000
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] CS:  0010 DS: 0000 
ES: 0000 CR0: 0000000080050033
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] CR2: 
00007f41d65a100c CR3: 000000007a943000 CR4: 00000000000006e0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Stack:
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399]  ffff88007fff8700 
0000000300000202 000000007a9037b8 0000000100000002
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399]  ffff88007a903768 
ffff88007c9ae000 ffff88007c9ae000 ffff88007a903788
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399]  0000000000000001 
0000000000000003 ffff88007a903768 ffffffff814072a2
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Call Trace:
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff814072a2>] virtqueue_add_sgs+0x2f2/0x340
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8147854a>] __virtblk_add_req+0xda/0x1b0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132f307>] ? __bt_get+0xc7/0x1e0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132f47a>] ? bt_get+0x5a/0x180
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132953c>] ? blk_rq_map_sg+0x3c/0x170
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8147871a>] virtio_queue_rq+0xfa/0x250
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132d39f>] __blk_mq_run_hw_queue+0xff/0x260
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132d97d>] blk_mq_run_hw_queue+0x7d/0xb0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132dd71>] blk_sq_make_request+0x171/0x2f0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81320605>] generic_make_request.part.75+0x75/0xb0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff813215a8>] generic_make_request+0x68/0x70
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81321625>] submit_bio+0x75/0x140
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d2773>] _submit_bh+0x113/0x160
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d27d0>] submit_bh+0x10/0x20
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d6135>] block_read_full_page+0x1f5/0x340
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d6d20>] ? I_BDEV+0x10/0x10
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8115c445>] ? __inc_zone_page_state+0x35/0x40
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8113eca4>] ? __add_to_page_cache_locked+0xa4/0x130
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d7798>] blkdev_readpage+0x18/0x20
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8114aee8>] read_pages+0xe8/0x100
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8114b1e3>] __do_page_cache_readahead+0x163/0x170
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8114b555>] force_page_cache_readahead+0x75/0xb0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8114b5d3>] page_cache_sync_readahead+0x43/0x50
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8113f91e>] do_generic_file_read+0x30e/0x490
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81140c44>] generic_file_read_iter+0xf4/0x150
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8116b4b8>] ? handle_mm_fault+0x48/0x80
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8116edc0>] ? find_vma+0x20/0x80
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d6ec7>] blkdev_read_iter+0x37/0x40
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811a10d8>] new_sync_read+0x78/0xb0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811a218b>] vfs_read+0xab/0x180
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811a240f>] SyS_read+0x4f/0xb0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff816e9812>] system_call_fastpath+0x16/0x1b
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Code: 00 00 00 00 
48 63 45 c4 48 8b 04 c3 48 85 c0 74 59 0f 1f 00 49 63 ce 48 be 00 00 00 00 
00 16 00 00 48 89 c7 48 c1 e1 04 4c 01 f9 <66> c7 41 0c 01 00 48 8b 10 48 83 
e2 fc 48 01 f2 8b 70 08 48 c1
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RIP 
[<ffffffff81406a47>] vring_add_indirect+0x87/0x210
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399]  RSP 
<ffff88007a903688>
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] CR2: 
00007f41d65a100c
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] ---[ end trace 
cc83f9989ae9e2af ]---
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] BUG: unable to 
handle kernel paging request at 0000000079a0b008
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] IP: 
[<ffffffff810d18b0>] acct_collect+0x60/0x1b0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] PGD 7b4ac067 PUD 
7b58c067 PMD 7b4a3067 PTE 0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Oops: 0000 [#2] SMP
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Modules linked in: 
xfs(O) libcrc32c dm_linear_custom(O) deflate ctr twofish_generic 
twofish_x86_64_3way glue_helper lrw xts gf128mul twofish_x86_64 
twofish_common camellia_generic serpent_generic blowfish_generic 
blowfish_x86_64 blowfish_common cast5_generic cast_common des_generic cmac 
xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo nfsd nfs_acl 
dm_round_robin ppdev parport_pc mac_hid dm_multipath i2c_piix4 psmouse 
serio_raw rpcsec_gss_krb5 auth_rpcgss oid_registry lp nfsv4 parport nfs 
fscache lockd sunrpc floppy
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] CPU: 3 PID: 3329 
Comm: mount Tainted: G      D    O  3.16.0-999-generic #201408131143
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Hardware name: 
Bochs Bochs, BIOS Bochs 01/01/2007
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] task: 
ffff88007b2ac8c0 ti: ffff88007a900000 task.ti: ffff88007a900000
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RIP: 
0010:[<ffffffff810d18b0>]  [<ffffffff810d18b0>] acct_collect+0x60/0x1b0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RSP: 
0018:ffff88007a903328  EFLAGS: 00010006
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RAX: 
0000000079a0b000 RBX: 0000000000000009 RCX: 0000000000000245
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RDX: 
0000000000000275 RSI: 0000000000000001 RDI: ffff8800362fb860
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RBP: 
ffff88007a903348 R08: 00007ffffffff000 R09: 0000000000000d01
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] R10: 
0000000000000000 R11: 0000000000000000 R12: ffff88007afa4800
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] R13: 
ffff88007b2ac8c0 R14: 0001000101133010 R15: 0000000000000046
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] FS: 
00007f41d67b5800(0000) GS:ffff88007fd80000(0000) knlGS:0000000000000000
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] CS:  0010 DS: 0000 
ES: 0000 CR0: 0000000080050033
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] CR2: 
0000000079a0b008 CR3: 000000007a943000 CR4: 00000000000006e0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Stack:
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399]  ffff88007b2ac8c0 
0000000000000009 ffff88007a9035d8 0000000000000001
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399]  ffff88007a903398 
ffffffff810582f7 0000000000000007 0000000000000006
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399]  000000000000000a 
0000000000000046 0000000000000009 ffff88007a9035d8
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Call Trace:
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff810582f7>] do_exit+0x367/0x470
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81006465>] oops_end+0xa5/0xf0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff816cf708>] no_context+0x1be/0x1cd
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff816cf8e9>] __bad_area_nosemaphore+0x1d2/0x1f1
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff816cf9ae>] bad_area_access_error+0x45/0x4e
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81044dfe>] __do_page_fault+0x2fe/0x550
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81210435>] ? kernfs_path+0x55/0x70
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8134a4e3>] ? cfq_find_alloc_queue+0x293/0x430
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81141635>] ? mempool_alloc_slab+0x15/0x20
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81141635>] ? mempool_alloc_slab+0x15/0x20
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81406cb0>] ? virtqueue_get_buf+0xe0/0xe0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8104516c>] do_page_fault+0xc/0x10
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff816eb222>] page_fault+0x22/0x30
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81406cb0>] ? virtqueue_get_buf+0xe0/0xe0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff814069f6>] ? vring_add_indirect+0x36/0x210
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81406a47>] ? vring_add_indirect+0x87/0x210
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff814069f6>] ? vring_add_indirect+0x36/0x210
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff814072a2>] virtqueue_add_sgs+0x2f2/0x340
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8147854a>] __virtblk_add_req+0xda/0x1b0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132f307>] ? __bt_get+0xc7/0x1e0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132f47a>] ? bt_get+0x5a/0x180
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132953c>] ? blk_rq_map_sg+0x3c/0x170
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8147871a>] virtio_queue_rq+0xfa/0x250
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132d39f>] __blk_mq_run_hw_queue+0xff/0x260
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132d97d>] blk_mq_run_hw_queue+0x7d/0xb0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8132dd71>] blk_sq_make_request+0x171/0x2f0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81320605>] generic_make_request.part.75+0x75/0xb0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff813215a8>] generic_make_request+0x68/0x70
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81321625>] submit_bio+0x75/0x140
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d2773>] _submit_bh+0x113/0x160
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d27d0>] submit_bh+0x10/0x20
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d6135>] block_read_full_page+0x1f5/0x340
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d6d20>] ? I_BDEV+0x10/0x10
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8115c445>] ? __inc_zone_page_state+0x35/0x40
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8113eca4>] ? __add_to_page_cache_locked+0xa4/0x130
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d7798>] blkdev_readpage+0x18/0x20
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8114aee8>] read_pages+0xe8/0x100
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8114b1e3>] __do_page_cache_readahead+0x163/0x170
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8114b555>] force_page_cache_readahead+0x75/0xb0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8114b5d3>] page_cache_sync_readahead+0x43/0x50
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8113f91e>] do_generic_file_read+0x30e/0x490
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff81140c44>] generic_file_read_iter+0xf4/0x150
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8116b4b8>] ? handle_mm_fault+0x48/0x80
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff8116edc0>] ? find_vma+0x20/0x80
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811d6ec7>] blkdev_read_iter+0x37/0x40
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811a10d8>] new_sync_read+0x78/0xb0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811a218b>] vfs_read+0xab/0x180
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff811a240f>] SyS_read+0x4f/0xb0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] 
[<ffffffff816e9812>] system_call_fastpath+0x16/0x1b
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Code: 00 74 55 49 
8b bd a0 03 00 00 48 83 c7 60 e8 a8 65 61 00 49 8b 85 a0 03 00 00 48 8b 00 
48 85 c0 74 1d 66 0f 1f 84 00 00 00 00 00 <4c> 03 70 08 4c 2b 30 48 8b 40 10 
48 85 c0 75 f0 49 c1 ee 0a 65
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] RIP 
[<ffffffff810d18b0>] acct_collect+0x60/0x1b0
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399]  RSP 
<ffff88007a903328>
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] CR2: 
0000000079a0b008
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] ---[ end trace 
cc83f9989ae9e2b0 ]---
Aug 13 19:49:06 vc-00-00-1383-dev kernel: [  118.570399] Fixing recursive 
fault but reboot is needed!

[3]
(qemu) KVM internal error. Suberror: 1
emulation failure
RAX=0000000000000000 RBX=0000000000000000 RCX=0000000000000000 
RDX=0000000000000623
RSI=0000000000000000 RDI=0000000000000000 RBP=0000000000000000 
RSP=0000000000000000
R8 =0000000000000000 R9 =0000000000000000 R10=0000000000000000 
R11=0000000000000000
R12=0000000000000000 R13=0000000000000000 R14=0000000000000000 
R15=0000000000000000
RIP=000000000000fff0 RFL=00010002 [-------] CPL=3 II=0 A20=1 SMM=0 HLT=0
ES =0000 0000000000000000 ffffffff 00000000
CS =0033 0000000000000000 ffffffff 00a0fb00 DPL=3 CS64 [-RA]
SS =002b 0000000000000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
DS =0000 0000000000000000 ffffffff 00000000
FS =0000 00007f0514f7c700 ffffffff 00000000
GS =0000 0000000000000000 ffffffff 00000000
LDT=0000 0000000000000000 ffffffff 00000000
TR =0040 ffff88007fc90380 00002087 00008b00 DPL=0 TSS64-busy
GDT=     ffff88007fc84000 0000007f
IDT=     ffffffffff57c000 00000fff
CR0=80050033 CR2=000000000061cd64 CR3=000000007ae6b000 CR4=000006e0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 
DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000d01

[4]
(qemu) qemu-system-x86_64: virtio: trying to map MMIO memory

-----Original Message----- 
From: Dave Chinner
Sent: 13 August, 2014 2:56 AM
To: Alex Lyakas
Cc: Brian Foster ; xfs@oss.sgi.com
Subject: Re: use-after-free on log replay failure

On Tue, Aug 12, 2014 at 03:39:02PM +0300, Alex Lyakas wrote:
> Hello Dave, Brian,
> I will describe a generic reproduction that you ask for.
>
> It was performed on pristine XFS code from 3.8.13, taken from here:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
....
> I mounted XFS with the following options:
> rw,sync,noatime,wsync,attr2,inode64,noquota 0 0
>
> I started a couple of processes writing files sequentially onto this
> mount point, and after few seconds crashed the VM.
> When the VM came up, I took the metadump file and placed it in:
> https://drive.google.com/file/d/0ByBy89zr3kJNa0ZpdmZFS242RVU/edit?usp=sharing
>
> Then I set up the following Device Mapper target onto /dev/vde:
> dmsetup create VDE --table "0 41943040 linear-custom /dev/vde 0"
> I am attaching the code (and Makefile) of dm-linear-custom target.
> It is exact copy of dm-linear, except that it has a module
> parameter. With the parameter set to 0, this is an identity mapping
> onto /dev/vde. If the parameter is set to non-0, all WRITE bios are
> failed with ENOSPC. There is a workqueue to fail them in a different
> context (not sure if really needed, but that's what our "real"
> custom
> block device does).

Well, they you go. That explains it - an asynchronous dispatch error
happening fast enough to race with the synchronous XFS dispatch
processing.

dispatch thread device workqueue
xfs_buf_hold();
atomic_set(b_io_remaining, 1)
atomic_inc(b_io_remaining)
submit_bio(bio)
queue_work(bio)
xfs_buf_ioend(bp, ....);
  atomic_dec(b_io_remaining)
xfs_buf_rele()
bio error set to ENOSPC
  bio->end_io()
    xfs_buf_bio_endio()
      bp->b_error = ENOSPC
      _xfs_buf_ioend(bp, 1);
        atomic_dec(b_io_remaining)
  xfs_buf_ioend(bp, 1);
    queue_work(bp)
xfs_buf_iowait()
if (bp->b_error) return error;
if (error)
  xfs_buf_relse()
    xfs_buf_rele()
      xfs_buf_free()

And now we have a freed buffer that is queued on the io completion
queue. Basically, it requires the buffer error to be set
asynchronously *between* the dispatch decrementing it's I/O count
after dispatch, but before we wait on the IO.

Not sure what the right fix is yet - removing the bp->b_error check
from xfs_buf_iowait() doesn't solve the problem - it just prevents
this code path from being tripped over by the race condition.

But, just to validate this is the problem, you should be able to
reproduce this on a 3.16 kernel. Can you try that, Alex?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
