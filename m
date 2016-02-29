Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6FB2D7CA0
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 03:48:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8118AC001
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 01:48:00 -0800 (PST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id NkjzBzlJvIlUY3Ox
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Feb 2016 01:47:56 -0800 (PST)
Received: by mail-wm0-f53.google.com with SMTP id p65so60339530wmp.1
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 01:47:56 -0800 (PST)
Message-ID: <BC0CC25E00CE4CEDA1FFDFC0A2F38742@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <3685DFAD20214109878873CF81232704@alyakaslap>
	<20160222212019.GI25832@dastard>
	<CAOcd+r1XY2kcp+qJ=mPOAQSmb90QUnLfmT3-FkMjQN_+Ejmt8A@mail.gmail.com>
	<20160222235628.GK25832@dastard>
	<D5578D3E98EE48B88EA9A1126B671155@alyakaslap>
	<20160223225926.GN25832@dastard>
In-Reply-To: <20160223225926.GN25832@dastard>
Subject: Re: xfs resize: primary superblock is not updated immediately
Date: Mon, 29 Feb 2016 11:47:54 +0200
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
Cc: Christoph Hellwig <hch@infradead.org>, Danny Shavit <danny@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>, xfs@oss.sgi.com

Hello Dave,
I have tried the same scenario with the 4.5 kernel from about a week ago, 
latest commit being [1].
The same crash is happening, stack trace being [2].

I am not proficient with xfstests, unfortunately. I tried running them 
several times, but I am not sure I was doing that properly.

As for your question why the "block beyond end of the filesystem fails". I 
tried to debug it further and added a print into _xfs_buf_find. What happens 
is that at some point, the sb_dblocks value is updated to the new value, but 
the in-memory pag object is not created. So the test:

eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
if (blkno < 0 || blkno >= eofs) {
...

still holds, but the needed pag does not exist.

Here are the results of the prints that I added:
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.546542] SGI XFS with ACLs, 
security attributes, realtime, no debug enabled
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.551243] XFS (dm-0): Mounting 
V4 Filesystem
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.576677] XFS (dm-0): Starting 
recovery (logdev: internal)
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.577866] _xfs_buf_find: 
blkno=0 eofs=200704 >m_sb.sb_dblocks=25088
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.577872] _xfs_buf_find: 
blkno=0 eofs=200704 >m_sb.sb_dblocks=25088
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.577882] _xfs_buf_find: 
blkno=0 eofs=200704 >m_sb.sb_dblocks=25088
===> Here we start seeing the new value of "sb_dblocks" and hence the new 
value of "eofs":
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.606796] _xfs_buf_find: 
blkno=1 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.606804] _xfs_buf_find: 
blkno=1 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.606988] _xfs_buf_find: 
blkno=2 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.606991] _xfs_buf_find: 
blkno=2 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607205] _xfs_buf_find: 
blkno=50177 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607210] _xfs_buf_find: 
blkno=50177 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607375] _xfs_buf_find: 
blkno=50178 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607378] _xfs_buf_find: 
blkno=50178 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607512] _xfs_buf_find: 
blkno=100353 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607515] _xfs_buf_find: 
blkno=100353 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607652] _xfs_buf_find: 
blkno=100354 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607655] _xfs_buf_find: 
blkno=100354 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607829] _xfs_buf_find: 
blkno=150529 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607832] _xfs_buf_find: 
blkno=150529 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607980] _xfs_buf_find: 
blkno=150530 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.607982] _xfs_buf_find: 
blkno=150530 eofs=204800 >m_sb.sb_dblocks=25600
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.608073] _xfs_buf_find: 
blkno=200705 eofs=204800 >m_sb.sb_dblocks=25600
===> and here we crash, but as you see, blkno is valid WRT eofs value.
Feb 29 11:47:09 vc-00-00-350-dev kernel: [   91.608120] BUG: unable to 
handle kernel NULL pointer dereference at 0000000000000098

Just for reference, immediately after the resize, the relevant superblock 
values are:

root@vc-00-00-350-dev:~# xfs_db -r -c "sb 0" -c "p"   /dev/mapper/xfs_base 
| egrep "agc|blocks"
blocksize = 4096
dblocks = 25088
rblocks = 0
agblocks = 6272
agcount = 4
rbmblocks = 0
logblocks = 2560
fdblocks = 22508

These values are identical to the values before the resize.

Thanks,
Alex.



[1]
commit 84e54c46b2f440a365a5224f1e5f173a462b7cca
Merge: 0ecdcd3 4328daa
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Feb 23 19:03:43 2016 -0800

    Merge tag 'dm-4.5-fix' of 
git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm

    Pull device mapper fix from Mike Snitzer:
     "Fix a 112 byte leak for each IO request that is requeued while DM
      multipath is handling faults due to path failures.

      This leak does not happen if blk-mq DM multipath is used.  It only
      occurs if .request_fn DM multipath is stacked ontop of blk-mq paths
      (e.g. scsi-mq devices)"

    * tag 'dm-4.5-fix' of 
git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm:
      dm: fix dm_rq_target_io leak on faults with .request_fn DM w/ blk-mq 
paths

[2]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.333515] SGI XFS with ACLs, 
security attributes, realtime, no debug enabled
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.339593] XFS (dm-0): Mounting 
V4 Filesystem
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.355170] XFS (dm-0): Starting 
recovery (logdev: internal)
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.356997] BUG: unable to 
handle kernel NULL pointer dereference at 0000000000000098
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.357761] IP: 
[<ffffffff816f705c>] _raw_spin_lock+0xc/0x30
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.358289] PGD 36675067 PUD 
7a47a067 PMD 0
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.358721] Oops: 0002 [#1] SMP
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.359050] Modules linked in: 
xfs libcrc32c nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
ipt_REJECT nf_reject_ipv4 xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp 
llc ip6table_filter ip6_tables iptable_filter ip_tables x_tables deflate ctr 
twofish_generic twofish_x86_64_3way xts twofish_x86_64 twofish_common 
camellia_generic serpent_generic blowfish_generic blowfish_x86_64 
blowfish_common cast5_generic cast_common des_generic nfsd cmac auth_rpcgss 
oid_registry nfs_acl nfs xcbc lockd grace sunrpc fscache rmd160 
sha512_generic af_key xfrm_algo ppdev dm_multipath kvm irqbypass 
ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper cryptd lrw gf128mul 
glue_helper mac_hid i2c_piix4 parport_pc serio_raw tpm_tis i6300esb lp 
parport psmouse floppy
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] CPU: 0 PID: 3067 
Comm: mount Not tainted 4.5.0-555-generic #1456324867
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] Hardware name: Bochs 
Bochs, BIOS Bochs 01/01/2007
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] task: 
ffff88007bc9d580 ti: ffff880079530000 task.ti: ffff880079530000
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] RIP: 
0010:[<ffffffff816f705c>]  [<ffffffff816f705c>] _raw_spin_lock+0xc/0x30
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] RSP: 
0018:ffff880079533ac0  EFLAGS: 00010246
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] RAX: 
0000000000000000 RBX: ffff880079533bf0 RCX: 0000000000000000
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] RDX: 
0000000000000001 RSI: 0000000000000004 RDI: 0000000000000098
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] RBP: 
ffff880079533b00 R08: 0000000000000001 R09: ffff880079fa56d0
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] R10: 
ffff880079fa5718 R11: 0000000000000000 R12: 0000000000000001
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] R13: 
ffff8800365d93c0 R14: 0000000000000001 R15: 0000000000031001
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] FS: 
00007fc7b2fd2880(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] CS:  0010 DS: 0000 
ES: 0000 CR0: 0000000080050033
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] CR2: 
0000000000000098 CR3: 00000000360ed000 CR4: 00000000000406f0
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] Stack:
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932]  ffffffffa03e2656 
0000000000000000 0000000000000000 ffff880079533bf0
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932]  ffff88007a6a6000 
0000000000000001 ffff8800365d93c0 0000000000000001
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932]  ffff880079533b40 
ffffffffa03e291a ffff880079533bf8 0000000000000001
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] Call Trace:
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa03e2656>] ? _xfs_buf_find+0x96/0x330 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa03e291a>] xfs_buf_get_map+0x2a/0x270 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa03e353d>] xfs_buf_read_map+0x2d/0x180 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa040f3c1>] xfs_trans_read_buf_map+0xf1/0x300 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa03a5697>] xfs_read_agf+0x87/0x100 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa03a575b>] xfs_alloc_read_agf+0x4b/0x130 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa03a5c1a>] xfs_alloc_pagf_init+0x1a/0x40 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa03d7eb9>] xfs_initialize_perag_data+0x99/0x110 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa03f9408>] xfs_mountfs+0x608/0x820 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa03fc1fe>] xfs_fs_fill_super+0x3be/0x4d0 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffff811c1a77>] mount_bdev+0x187/0x1c0
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa03fbe40>] ? xfs_parseargs+0xa70/0xa70 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffffa03fa885>] xfs_fs_mount+0x15/0x20 [xfs]
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffff811c2739>] mount_fs+0x39/0x160
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffff81172d55>] ? __alloc_percpu+0x15/0x20
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffff811dc817>] vfs_kern_mount+0x67/0x110
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffff811df345>] do_mount+0x225/0xdb0
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffff811c06fd>] ? __fput+0x17d/0x1e0
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffff811aaea4>] ? __kmalloc_track_caller+0x54/0x190
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffff8116e341>] ? strndup_user+0x41/0xa0
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffff8116e262>] ? memdup_user+0x42/0x70
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffff811e01b3>] SyS_mount+0x83/0xd0
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] 
[<ffffffff816f7397>] entry_SYSCALL_64_fastpath+0x12/0x6a
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] Code: 5d c3 ba 01 00 
00 00 f0 0f b1 17 85 c0 75 ef b0 01 5d c3 66 66 66 2e 0f 1f 84 00 00 00 00 
00 66 66 66 66 90 31 c0 ba 01 00 00 00 <f0> 0f b1 17 85 c0 75 01 c3 55 89 c6 
48 89 e5 e8 10 f7 9a ff 5d
Feb 29 11:26:05 vc-00-00-350-dev kernel: [  100.360932] RIP 
[<ffffffff816f705c>] _raw_spin_lock+0xc/0x30


-----Original Message----- 
From: Dave Chinner
Sent: 24 February, 2016 12:59 AM
To: Alex Lyakas
Cc: xfs@oss.sgi.com ; Christoph Hellwig ; Danny Shavit ; Yair Hershko ; 
Shyam Kaushik
Subject: Re: xfs resize: primary superblock is not updated immediately

On Tue, Feb 23, 2016 at 02:25:38PM +0200, Alex Lyakas wrote:
> Hi Dave,
>
> Below is a detailed reproduction scenario of the problem.

Can you package this for xfstests and send to
fstests@vger.kernel.org, please?

> No
> snapshots involved, only XFS. The scenario is performed on a VM,
> running kernel 3.18.19.

And a current kernel (e.g. 4.5-rc5) behaves how?

> 9) mount
> # mount -o sync /dev/mapper/xfs_base /mnt/xfs/
>
> Kernel panics with [2].

It tried to read a buffer beyond the current end of filesystem that
log recoery knows about. Given the on-disk superblock had not been
updated by the growfs operation, this should have been detected
by _xfs_buf_find() and errored out, not tried to look up a per-ag
structure that is beyond the current end of filesystem.

i.e. the code I pointed out in my previous email failed to detect
the situation is it supposed to be protecting against.  Why did that
"block beyond the end of the filesystem" detection fail?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
