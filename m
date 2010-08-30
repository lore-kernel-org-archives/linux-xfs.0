Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7UNUHSH028846 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 18:30:17 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 449CB12368CD
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 16:41:21 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 0oEzM18FrKLxJhix for
	<xfs@oss.sgi.com>; Mon, 30 Aug 2010 16:41:21 -0700 (PDT)
Message-ID: <4C7C3F2E.6070102@sandeen.net>
Date: Mon, 30 Aug 2010 18:30:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: What should to do with ASSERT failed
References: <AANLkTin-zf0chkk68pGfwDRt03QaKmNdsP3=goDEUS+p@mail.gmail.com>	<4C7C26E8.9070308@sandeen.net>
	<AANLkTinXDQoo7ZU+w2V7N7zBrxdS=Tc71MNZ7M4R5A9w@mail.gmail.com>
In-Reply-To: <AANLkTinXDQoo7ZU+w2V7N7zBrxdS=Tc71MNZ7M4R5A9w@mail.gmail.com>
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
To: Mike Gao <ygao.linux@gmail.com>
Cc: xfs@oss.sgi.com

Mike Gao wrote:
> Thanks very much for help. The kernel is pretty old, 2.6.19 but the xfs
> is pretty new.
> the block size is 512 and use mmap for test with write and read compare.
> (xfstest 074).

Ok so just xfstests 074 with a 512-byte block?  I will test that when
I get a chance....

> If I ignored this ASSERT(comment out), the test will failed. I guess
> because some pages never written to disk.

*nod* I'm afraid that makes sense, it's ignoring this because it
thinks it's a hole:

                /*
                 * A hole may still be marked uptodate because discard_buffer
                 * leaves the flag set.
                 */
                if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
                        ASSERT(!buffer_dirty(bh));
                        imap_valid = 0;
                        continue;
                }

It appears that in your case it should not be a hole...

-Eric
 
> Assertion failed: !buffer_dirty(bh), file: fs/xfs/linux-2.6/xfs_aops.c,
> line: 1399
> BUG: failure at fs/xfs/support/debug.c:108/assfail()!
> Kernel panic - not syncing: BUG!
>  
> EIP: 0073:[<b76f5424>] CPU: 0 Not tainted ESP: 007b:b75a6fa8 EFLAGS:
> 00000246
>     Not tainted
> EAX: 00000000 EBX: 00000e97 ECX: 00000013 EDX: 00000e97
> ESI: 00000e93 EDI: 00000011 EBP: b75a6fc4 DS: 007b ES: 007b
> 0a7d7c94:  [<0806bd41>] show_regs+0xc5/0xca
> 0a7d7cc0:  [<0805a920>] panic_exit+0x25/0x3f
> 0a7d7cd4:  [<0807b5d5>] atomic_notifier_call_chain+0x1d/0x33
> 0a7d7cf4:  [<0807048f>] panic+0x4c/0xcf
> 0a7d7d10:  [<081724cd>] xfs_hex_dump+0x0/0x7
> 0a7d7d1c:  [<08168e26>] xfs_vm_writepage+0x226/0x656
> 0a7d7dbc:  [<0809092f>] generic_writepages+0x164/0x27b
> 0a7d7e4c:  [<0816926c>] xfs_vm_writepages+0x16/0x18
> 0a7d7e5c:  [<08090a6a>] do_writepages+0x24/0x38
> 0a7d7e70:  [<080bbe8b>] __writeback_single_inode+0x16d/0x2de
> 0a7d7ebc:  [<080bc1ba>] sync_sb_inodes+0x1be/0x25c
> 0a7d7ef4:  [<080bc299>] writeback_inodes+0x41/0x6c
> 0a7d7f08:  [<080905b5>] background_writeout+0x66/0x93
> 0a7d7f54:  [<0809106a>] pdflush+0xca/0x154
> 0a7d7f88:  [<08080a83>] kthread+0xb6/0xe6
> 0a7d7fb4:  [<080663ee>] run_kernel_thread+0x37/0x41
> 0a7d7fe0:  [<0805acee>] new_thread_handler+0x64/0x8b
> 0a7d7ffc:  [<a55a5a5a>] 0xa55a5a5a

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
