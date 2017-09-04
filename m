Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23607 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753912AbdIDRes (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 13:34:48 -0400
Date: Mon, 4 Sep 2017 10:34:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs: Uninitialized memory read at xlog_write
Message-ID: <20170904173440.GH4671@magnolia>
References: <201709042119.CDE26519.MtQJHFOSOFOLVF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201709042119.CDE26519.MtQJHFOSOFOLVF@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: sandeen@redhat.com, dchinner@redhat.com, linux-xfs@vger.kernel.org

On Mon, Sep 04, 2017 at 09:19:41PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I hit kmemcheck splat using linux-next-20170901.

What was running at the time?

Would be nice to know what log vector that was...

--D

> [ 1360.354052] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffffa17673526960)
> [ 1360.354053] 00000000000000006a1004080000000000000000000000000000000000000000
> [ 1360.354059]  u u u u u u u u i i i i i i i i u u u u u u u u u u u u u u u u
> [ 1360.354063]  ^
> [ 1360.354080] RIP: 0010:xlog_write+0x378/0x890 [xfs]
> [ 1360.354080] RSP: 0018:ffffafeac12b7cf0 EFLAGS: 00010202
> [ 1360.354081] RAX: ffffafeac1808234 RBX: 0000000000000038 RCX: 000000000000000c
> [ 1360.354082] RDX: 000000000000000e RSI: ffffa17673526960 RDI: ffffafeac180823c
> [ 1360.354082] RBP: ffffafeac12b7d98 R08: 0000000000000000 R09: 0000000000000000
> [ 1360.354083] R10: ffffa176737f8000 R11: 0000000000000000 R12: 0000000000000038
> [ 1360.354083] R13: 0000000000000002 R14: 0000000000000000 R15: ffffa17673526900
> [ 1360.354084] FS:  0000000000000000(0000) GS:ffffffffb0c30000(0000) knlGS:0000000000000000
> [ 1360.354085] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1360.354085] CR2: ffffa17674a66320 CR3: 0000000135c77003 CR4: 00000000000606f0
> [ 1360.354133]  xlog_write+0x378/0x890 [xfs]
> [ 1360.354142]  xlog_cil_push+0x1f4/0x370 [xfs]
> [ 1360.354151]  xlog_cil_push_work+0xd/0x10 [xfs]
> [ 1360.354207]  process_one_work+0x1cd/0x330
> [ 1360.354208]  worker_thread+0x222/0x3e0
> [ 1360.354209]  kthread+0xfe/0x130
> [ 1360.354212]  ret_from_fork+0x25/0x30
> [ 1360.354213]  0xffffffffffffffff
> 
> # ./scripts/faddr2line fs/xfs/xfs.ko xlog_write+0x378/0x890
> xlog_write+0x378/0x890:
> __inline_memcpy at /data/linux-next/./arch/x86/include/asm/string_64.h:13
>  (inlined by) xlog_write at /data/linux-next/fs/xfs/xfs_log.c:2479
> 
>                         ASSERT(copy_len >= 0);
>     3136:       0f 88 77 01 00 00       js     32b3 <xlog_write+0x4d3>
>                         if (copy_len > 0) {
>     313c:       0f 84 d6 02 00 00       je     3418 <xlog_write+0x638>
>                                 memcpy(ptr, reg->i_addr + copy_off, copy_len);
>     3142:       48 63 da                movslq %edx,%rbx
>     3145:       49 63 f6                movslq %r14d,%rsi
>     3148:       48 89 c7                mov    %rax,%rdi
>                      "1:\ttestb $1,%b4\n\t"
>                      "je 2f\n\t"
>                      "movsb\n"
>                      "2:"
>                      : "=&c" (d0), "=&D" (d1), "=&S" (d2)
>                      : "0" (n / 4), "q" (n), "1" ((long)to), "2" ((long)from)
>     314b:       48 89 da                mov    %rbx,%rdx
>     314e:       48 03 31                add    (%rcx),%rsi
>     3151:       48 c1 ea 02             shr    $0x2,%rdx
>         asm volatile("rep ; movsl\n\t"
>     3155:       48 89 d1                mov    %rdx,%rcx
>     3158:       f3 a5                   rep movsl %ds:(%rsi),%es:(%rdi)    // <= xlog_write+0x378/0x890
>     315a:       f6 c3 02                test   $0x2,%bl
>     315d:       74 02                   je     3161 <xlog_write+0x381>
>     315f:       66 a5                   movsw  %ds:(%rsi),%es:(%rdi)
>     3161:       f6 c3 01                test   $0x1,%bl
>     3164:       74 01                   je     3167 <xlog_write+0x387>
>     3166:       a4                      movsb  %ds:(%rsi),%es:(%rdi)
>     3167:       8b 55 c4                mov    -0x3c(%rbp),%edx
>         *len -= bytes;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
