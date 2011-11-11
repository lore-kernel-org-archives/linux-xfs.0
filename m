Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAB6VsNt179958
	for <linux-xfs@oss.sgi.com>; Fri, 11 Nov 2011 00:31:54 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 251A91050B47
	for <linux-xfs@oss.sgi.com>; Thu, 10 Nov 2011 22:31:51 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 8vZW5YNYZ2T3zqvH for
	<linux-xfs@oss.sgi.com>; Thu, 10 Nov 2011 22:31:51 -0800 (PST)
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id 818C71700BD
	for <linux-xfs@oss.sgi.com>; Fri, 11 Nov 2011 14:31:48 +0800 (CST)
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id pAB6VkC6011455
	for <linux-xfs@oss.sgi.com>; Fri, 11 Nov 2011 14:31:47 +0800
Message-ID: <4EBCC112.3020108@cn.fujitsu.com>
Date: Fri, 11 Nov 2011 14:30:42 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Subject: xfstests/071 FAIL with XFS Assertion
Reply-To: gaowanlong@cn.fujitsu.com
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
To: linux-xfs@oss.sgi.com

v3.1.0-10325-g3155521

[   39.315513] XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 799
[   39.316613] ------------[ cut here ]------------
[   39.317099] kernel BUG at fs/xfs/xfs_message.c:101!
[   39.317554] invalid opcode: 0000 [#1] SMP 
[   39.317554] CPU 1 
[   39.317554] Modules linked in: xfs exportfs deflate zlib_deflate ctr camellia cast5 rmd160 crypto_null ccm serpent blowfish_generic blowfish_common twofish_x86_64 twofish_common ecb xcbc cbc sha256_generic sha512_generic des_generic cryptd aes_x86_64 aes_generic ah6 ah4 esp6 esp4 xfrm4_mode_beet xfrm4_tunnel tunnel4 xfrm4_mode_tunnel xfrm4_mode_transport xfrm6_mode_transport xfrm6_mode_ro xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6 xfrm_ipcomp xfrm6_tunnel tunnel6 af_key sunrpc ipv6 snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore microcode i2c_piix4 snd_page_alloc virtio_net virtio_balloon i2c_core pcspkr joydev virtio_blk floppy virtio_pci virtio_ring virtio [last unloaded: speedstep_lib]
[   39.317554] 
[   39.317554] Pid: 2572, comm: umount Not tainted 3.1.0-10325-g3155521 #1 Red Hat KVM
[   39.317554] RIP: 0010:[<ffffffffa02f52ea>]  [<ffffffffa02f52ea>] assfail+0x22/0x24 [xfs]
[   39.317554] RSP: 0018:ffff88001d369d48  EFLAGS: 00010296
[   39.317554] RAX: 000000000000008d RBX: ffff88001d658d90 RCX: 000000000000aaf7
[   39.317554] RDX: 0000000000000000 RSI: 0000000000000092 RDI: 0000000000000246
[   39.317554] RBP: ffff88001d369d48 R08: 0000000000000000 R09: ffff88001f00c000
[   39.317554] R10: ffff88009d369be7 R11: 0000000000000000 R12: ffff88001d658c00
[   39.317554] R13: ffffffffa0358c70 R14: ffff88001bc5d7c8 R15: 0000000000000000
[   39.317554] FS:  00007f2c4f785760(0000) GS:ffff88001f680000(0000) knlGS:0000000000000000
[   39.317554] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   39.317554] CR2: 00000037e48d7250 CR3: 000000001c0a1000 CR4: 00000000000006e0
[   39.317554] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   39.317554] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   39.317554] Process umount (pid: 2572, threadinfo ffff88001d368000, task ffff88001bf89720)
[   39.317554] Stack:
[   39.317554]  ffff88001d369d78 ffffffffa02f5f59 ffff88001d369d78 ffff88001d658d90
[   39.317554]  ffff88001d658e88 ffffffffa0358c70 ffff88001d369d98 ffffffff81137d46
[   39.317554]  ffff88001d658d90 ffff88001d658d90 ffff88001d369dc8 ffffffff81138230
[   39.317554] Call Trace:
[   39.317554]  [<ffffffffa02f5f59>] xfs_fs_destroy_inode+0xa6/0x122 [xfs]
[   39.317554]  [<ffffffff81137d46>] destroy_inode+0x3e/0x58
[   39.317554]  [<ffffffff81138230>] evict+0x144/0x14c
[   39.317554]  [<ffffffff811383fe>] dispose_list+0x3e/0x4f
[   39.317554]  [<ffffffff81138d24>] evict_inodes+0xdb/0xe8
[   39.317554]  [<ffffffff81125af0>] generic_shutdown_super+0x4c/0xbb
[   39.317554]  [<ffffffff81125b86>] kill_block_super+0x27/0x6a
[   39.317554]  [<ffffffff81125eaa>] deactivate_locked_super+0x26/0x57
[   39.317554]  [<ffffffff811266f4>] deactivate_super+0x3a/0x3f
[   39.317554]  [<ffffffff8113bc88>] mntput_no_expire+0xd0/0xd5
[   39.317554]  [<ffffffff8113c90a>] sys_umount+0x2dc/0x30a
[   39.317554]  [<ffffffff8112cbb3>] ? path_put+0x22/0x26
[   39.317554]  [<ffffffff814a3342>] system_call_fastpath+0x16/0x1b
[   39.317554] Code: c4 68 5b 41 5c 41 5d c9 c3 55 48 89 e5 66 66 66 66 90 31 c0 48 89 f1 41 89 d0 48 c7 c6 9c e2 35 a0 48 89 fa 31 ff e8 a8 fc ff ff <0f> 0b 55 48 89 e5 48 83 ec 10 66 66 66 66 90 41 b8 01 00 00 00 
[   39.317554] RIP  [<ffffffffa02f52ea>] assfail+0x22/0x24 [xfs]
[   39.317554]  RSP <ffff88001d369d48>
[   39.388697] ---[ end trace a372bd1f2ffe0ef4 ]---


Thanks
-Wanlong Gao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
