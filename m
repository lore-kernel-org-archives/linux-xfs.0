Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o348F9ZV121150 for <xfs@oss.sgi.com>; Sun, 4 Apr 2010 03:15:10 -0500
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F30F299773
	for <xfs@oss.sgi.com>; Sun,  4 Apr 2010 01:16:57 -0700 (PDT)
Received: from peace.netnation.com (newpeace.netnation.com [204.174.223.7]) by
	cuda.sgi.com with ESMTP id Rny3fek9N9EVideT for
	<xfs@oss.sgi.com>; Sun, 04 Apr 2010 01:16:57 -0700 (PDT)
Received: from sim by peace.netnation.com with local (Exim 4.63)
	(envelope-from <sim@netnation.com>) id 1NyL0r-0006iG-BT
	for xfs@oss.sgi.com; Sun, 04 Apr 2010 01:16:57 -0700
Date: Sun, 4 Apr 2010 01:16:57 -0700
From: Simon Kirby <sim@hostway.ca>
Subject: Oops in xfs_dir2_block_lookup_int from storage corruption [2.6.33]
Message-ID: <20100404081657.GA24143@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi! :)

We had a fun event of two HA servers crashing back and forth to each
other because of corrupted storage.  xfs_repair eventually corrected the
issue, but in the meantime our HA NFS servers kept breaking shortly after
mounting and serving the file systems (all XFS).  There is an identical
backtrace on the two servers.

This crashed on a kernel with CONFIG_DEBUG_INFO=y, so a useful vmlinux is
available.

Apr  3 04:41:59 nas03 kernel: XFS mounting filesystem dm-13
Apr  3 04:42:00 nas03 kernel: Starting XFS recovery on filesystem: dm-13 (logdev: internal)
Apr  3 04:42:00 nas03 kernel: Ending XFS recovery on filesystem: dm-13 (logdev: internal)
Apr  3 04:42:00 nas03 kernel: NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Apr  3 04:42:00 nas03 kernel: NFSD: starting 90-second grace period
Apr  3 04:42:32 nas03 kernel: BUG: unable to handle kernel paging request at ffff8800f674bf00
Apr  3 04:42:32 nas03 kernel: IP: [<ffffffff8125e481>] xfs_dir2_block_lookup_int+0xb1/0x1d0
Apr  3 04:42:32 nas03 kernel: PGD 182b063 PUD 0 
Apr  3 04:42:32 nas03 kernel: Oops: 0000 [#1] SMP 
Apr  3 04:42:32 nas03 kernel: last sysfs file: /sys/devices/virtual/block/dm-13/removable
Apr  3 04:42:32 nas03 kernel: CPU 6 
Apr  3 04:42:32 nas03 kernel: Pid: 29724, comm: nfsd Not tainted 2.6.33-hw #1 0M788G/PowerEdge 1950
Apr  3 04:42:32 nas03 kernel: RIP: 0010:[<ffffffff8125e481>]  [<ffffffff8125e481>] xfs_dir2_block_lookup_int+0xb1/0x1d0
Apr  3 04:42:32 nas03 kernel: RSP: 0000:ffff8803ca8738a0  EFLAGS: 00010203
Apr  3 04:42:32 nas03 kernel: RAX: 0000000015c6535e RBX: 0000000015c6535e RCX: 0000000000000000
Apr  3 04:42:32 nas03 kernel: RDX: 000000002b8ca6bd RSI: ffff8803137c7cc0 RDI: 000000000000172e
Apr  3 04:42:32 nas03 kernel: RBP: ffff8803ca873910 R08: ffff880048422410 R09: 0000000000000000
Apr  3 04:42:32 nas03 kernel: R10: 0000000000000001 R11: 0000000000000000 R12: 000000003e3c623e
Apr  3 04:42:32 nas03 kernel: R13: 0000000000000000 R14: 0000000000000000 R15: ffff8803ca873960
Apr  3 04:42:32 nas03 kernel: FS:  0000000000000000(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
Apr  3 04:42:32 nas03 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Apr  3 04:42:32 nas03 kernel: CR2: ffff8800f674bf00 CR3: 000000043d1b6000 CR4: 00000000000006e0
Apr  3 04:42:32 nas03 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Apr  3 04:42:32 nas03 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr  3 04:42:32 nas03 kernel: Process nfsd (pid: 29724, threadinfo ffff8803ca872000, task ffff880416f46900)
Apr  3 04:42:32 nas03 kernel: Stack:
Apr  3 04:42:32 nas03 kernel:  ffff8803ca8738e0 ffff8803ca87392c ffff8803ca873920 ffff8803010c8ff8
Apr  3 04:42:32 nas03 kernel: <0> ffff880416309400 0000000000000000 ffff8803010c8000 0000000000000000
Apr  3 04:42:32 nas03 kernel: <0> ffff8803137c7cc0 ffff8803ca8739ec ffff8803ca873960 0000000000000000
Apr  3 04:42:32 nas03 kernel: Call Trace:
Apr  3 04:42:32 nas03 kernel:  [<ffffffff8125ee5c>] xfs_dir2_block_lookup+0x2c/0xf0
Apr  3 04:42:32 nas03 kernel:  [<ffffffff8125dbff>] xfs_dir_lookup+0xdf/0x180
Apr  3 04:42:32 nas03 kernel:  [<ffffffff812883e1>] xfs_lookup+0x81/0x110
Apr  3 04:42:32 nas03 kernel:  [<ffffffff812902d5>] xfs_fs_get_parent+0x25/0x50
Apr  3 04:42:32 nas03 kernel:  [<ffffffff811dfbb0>] reconnect_path+0x150/0x2e0
Apr  3 04:42:32 nas03 kernel:  [<ffffffff811dff72>] exportfs_decode_fh+0xf2/0x260
Apr  3 04:42:32 nas03 kernel:  [<ffffffff811e3f80>] ? nfsd_acceptable+0x0/0x100
Apr  3 04:42:32 nas03 kernel:  [<ffffffff811e8c1d>] ? exp_find_key+0x5d/0xc0
Apr  3 04:42:32 nas03 kernel:  [<ffffffff811e383d>] fh_verify+0x42d/0x670
Apr  3 04:42:32 nas03 kernel:  [<ffffffff8103838d>] ? default_wake_function+0xd/0x10
Apr  3 04:42:32 nas03 kernel:  [<ffffffff8102effa>] ? __wake_up_common+0x5a/0x90
Apr  3 04:42:32 nas03 kernel:  [<ffffffff811e5fe9>] nfsd_lookup_dentry+0x49/0x450
Apr  3 04:42:32 nas03 kernel:  [<ffffffff815c2816>] ? sunrpc_cache_lookup+0x66/0x170
Apr  3 04:42:32 nas03 kernel:  [<ffffffff811e641e>] nfsd_lookup+0x2e/0xd0
Apr  3 04:42:32 nas03 kernel:  [<ffffffff815c1e34>] ? cache_check+0xf4/0x3a0
Apr  3 04:42:32 nas03 kernel:  [<ffffffff811eddf1>] nfsd3_proc_lookup+0xa1/0x120
Apr  3 04:42:32 nas03 kernel:  [<ffffffff811e0455>] nfsd_dispatch+0xb5/0x240
Apr  3 04:42:32 nas03 kernel:  [<ffffffff815b8585>] svc_process+0x475/0x770
Apr  3 04:42:32 nas03 kernel:  [<ffffffff811e08f0>] ? nfsd+0x0/0x130
Apr  3 04:42:32 nas03 kernel:  [<ffffffff811e099f>] nfsd+0xaf/0x130
Apr  3 04:42:32 nas03 kernel:  [<ffffffff8105d23e>] kthread+0x8e/0xa0
Apr  3 04:42:32 nas03 kernel:  [<ffffffff81003a24>] kernel_thread_helper+0x4/0x10
Apr  3 04:42:32 nas03 kernel:  [<ffffffff8105d1b0>] ? kthread+0x0/0xa0
Apr  3 04:42:32 nas03 kernel:  [<ffffffff81003a20>] ? kernel_thread_helper+0x0/0x10
Apr  3 04:42:32 nas03 kernel: Code: f8 48 89 4d a8 8b 50 f8 49 89 c8 0f ca 89 d0 31 c9 ff ca 48 c1 e0 03 49 29 c0 eb 07 8d 4b 01 39 ca 7c 1d 8d 1c 0a d1 fb 48 63 c3 <45> 8b 24 c0 41 0f cc 44 39 e7 74 1d 77 e3 8d 53 ff 39 ca 7d e3 
Apr  3 04:42:32 nas03 kernel: RIP  [<ffffffff8125e481>] xfs_dir2_block_lookup_int+0xb1/0x1d0
Apr  3 04:42:32 nas03 kernel:  RSP <ffff8803ca8738a0>
Apr  3 04:42:32 nas03 kernel: CR2: ffff8800f674bf00
Apr  3 04:42:32 nas03 kernel: ---[ end trace e16c66e592592c64 ]---

0xB1 == 177 decimal:

Dump of assembler code for function xfs_dir2_block_lookup_int:
0xffffffff8125e3d0 <xfs_dir2_block_lookup_int+0>:       push   %rbp
0xffffffff8125e3d1 <xfs_dir2_block_lookup_int+1>:       xor    %r9d,%r9d
0xffffffff8125e3d4 <xfs_dir2_block_lookup_int+4>:       mov    $0xffffffffffffffff,%rcx
0xffffffff8125e3db <xfs_dir2_block_lookup_int+11>:      mov    %rsp,%rbp
0xffffffff8125e3de <xfs_dir2_block_lookup_int+14>:      push   %r15
0xffffffff8125e3e0 <xfs_dir2_block_lookup_int+16>:      mov    %rdi,%r15
0xffffffff8125e3e3 <xfs_dir2_block_lookup_int+19>:      lea    -0x30(%rbp),%r8
0xffffffff8125e3e7 <xfs_dir2_block_lookup_int+23>:      push   %r14
0xffffffff8125e3e9 <xfs_dir2_block_lookup_int+25>:      push   %r13
0xffffffff8125e3eb <xfs_dir2_block_lookup_int+27>:      push   %r12
0xffffffff8125e3ed <xfs_dir2_block_lookup_int+29>:      push   %rbx
0xffffffff8125e3ee <xfs_dir2_block_lookup_int+30>:      sub    $0x48,%rsp
0xffffffff8125e3f2 <xfs_dir2_block_lookup_int+34>:      mov    %rsi,-0x60(%rbp)
0xffffffff8125e3f6 <xfs_dir2_block_lookup_int+38>:      mov    %rdx,-0x68(%rbp)
0xffffffff8125e3fa <xfs_dir2_block_lookup_int+42>:      mov    0x30(%rdi),%rsi
0xffffffff8125e3fe <xfs_dir2_block_lookup_int+46>:      mov    0x48(%rdi),%rax
0xffffffff8125e402 <xfs_dir2_block_lookup_int+50>:      mov    %rax,-0x48(%rbp)
0xffffffff8125e406 <xfs_dir2_block_lookup_int+54>:      mov    (%rsi),%rdx
0xffffffff8125e409 <xfs_dir2_block_lookup_int+57>:      mov    %rax,%rdi
0xffffffff8125e40c <xfs_dir2_block_lookup_int+60>:      mov    %rdx,-0x50(%rbp)
0xffffffff8125e410 <xfs_dir2_block_lookup_int+64>:      mov    0x2f8(%rdx),%edx
0xffffffff8125e416 <xfs_dir2_block_lookup_int+70>:      callq  0xffffffff8125b170 <xfs_da_read_buf>
0xffffffff8125e41b <xfs_dir2_block_lookup_int+75>:      test   %eax,%eax
0xffffffff8125e41d <xfs_dir2_block_lookup_int+77>:      mov    %eax,%r9d
0xffffffff8125e420 <xfs_dir2_block_lookup_int+80>:      je     0xffffffff8125e434 <xfs_dir2_block_lookup_int+100>
0xffffffff8125e422 <xfs_dir2_block_lookup_int+82>:      add    $0x48,%rsp
0xffffffff8125e426 <xfs_dir2_block_lookup_int+86>:      mov    %r9d,%eax
0xffffffff8125e429 <xfs_dir2_block_lookup_int+89>:      pop    %rbx
0xffffffff8125e42a <xfs_dir2_block_lookup_int+90>:      pop    %r12
0xffffffff8125e42c <xfs_dir2_block_lookup_int+92>:      pop    %r13
0xffffffff8125e42e <xfs_dir2_block_lookup_int+94>:      pop    %r14
0xffffffff8125e430 <xfs_dir2_block_lookup_int+96>:      pop    %r15
0xffffffff8125e432 <xfs_dir2_block_lookup_int+98>:      leaveq 
0xffffffff8125e433 <xfs_dir2_block_lookup_int+99>:      retq   
0xffffffff8125e434 <xfs_dir2_block_lookup_int+100>:     mov    -0x30(%rbp),%rsi
0xffffffff8125e438 <xfs_dir2_block_lookup_int+104>:     mov    -0x50(%rbp),%rdx
0xffffffff8125e43c <xfs_dir2_block_lookup_int+108>:     mov    0x20(%r15),%edi
0xffffffff8125e440 <xfs_dir2_block_lookup_int+112>:     mov    0x8(%rsi),%rax
0xffffffff8125e444 <xfs_dir2_block_lookup_int+116>:     mov    %rax,-0x40(%rbp)
0xffffffff8125e448 <xfs_dir2_block_lookup_int+120>:     movslq 0x2f0(%rdx),%rax
0xffffffff8125e44f <xfs_dir2_block_lookup_int+127>:     add    -0x40(%rbp),%rax
0xffffffff8125e453 <xfs_dir2_block_lookup_int+131>:     lea    -0x8(%rax),%rcx
0xffffffff8125e457 <xfs_dir2_block_lookup_int+135>:     mov    %rcx,-0x58(%rbp)
0xffffffff8125e45b <xfs_dir2_block_lookup_int+139>:     mov    -0x8(%rax),%edx
0xffffffff8125e45e <xfs_dir2_block_lookup_int+142>:     mov    %rcx,%r8
0xffffffff8125e461 <xfs_dir2_block_lookup_int+145>:     bswap  %edx
0xffffffff8125e463 <xfs_dir2_block_lookup_int+147>:     mov    %edx,%eax
0xffffffff8125e465 <xfs_dir2_block_lookup_int+149>:     xor    %ecx,%ecx
0xffffffff8125e467 <xfs_dir2_block_lookup_int+151>:     dec    %edx
0xffffffff8125e469 <xfs_dir2_block_lookup_int+153>:     shl    $0x3,%rax
0xffffffff8125e46d <xfs_dir2_block_lookup_int+157>:     sub    %rax,%r8
0xffffffff8125e470 <xfs_dir2_block_lookup_int+160>:     jmp    0xffffffff8125e479 <xfs_dir2_block_lookup_int+169>
0xffffffff8125e472 <xfs_dir2_block_lookup_int+162>:     lea    0x1(%rbx),%ecx
0xffffffff8125e475 <xfs_dir2_block_lookup_int+165>:     cmp    %ecx,%edx
0xffffffff8125e477 <xfs_dir2_block_lookup_int+167>:     jl     0xffffffff8125e496 <xfs_dir2_block_lookup_int+198>
0xffffffff8125e479 <xfs_dir2_block_lookup_int+169>:     lea    (%rdx,%rcx,1),%ebx
0xffffffff8125e47c <xfs_dir2_block_lookup_int+172>:     sar    %ebx
0xffffffff8125e47e <xfs_dir2_block_lookup_int+174>:     movslq %ebx,%rax
0xffffffff8125e481 <xfs_dir2_block_lookup_int+177>:     mov    (%r8,%rax,8),%r12d   <======
0xffffffff8125e485 <xfs_dir2_block_lookup_int+181>:     bswap  %r12d
0xffffffff8125e488 <xfs_dir2_block_lookup_int+184>:     cmp    %r12d,%edi
0xffffffff8125e48b <xfs_dir2_block_lookup_int+187>:     je     0xffffffff8125e4aa <xfs_dir2_block_lookup_int+218>

Recompiling the function with asm("nop") inserted, I think I tracked down that instruction to this line:

        /*
         * Loop doing a binary search for our hash value.
         * Find our entry, ENOENT if it's not there.
         */
        for (low = 0, high = be32_to_cpu(btp->count) - 1; ; ) {
                ASSERT(low <= high);
                mid = (low + high) >> 1;
======>         if ((hash = be32_to_cpu(blp[mid].hashval)) == args->hashval)
                        break;

blp is 8 bytes which matches the multiplication of the array index in the
instruction.  So, this means that blp[mid] pointed to 0xffff8800f674bf00,
and mid was 0x0000000015c6535e.  That sounds kind of high...?

xfs_repair did spit out a number of errors such as this one which may
or may not explain the Oops:

entry ".." at block 0 offset 32 in directory inode 1137203971 references non-existent inode 3255359147
        clearing inode number in entry at offset 32...

Cheers!

Simon-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
