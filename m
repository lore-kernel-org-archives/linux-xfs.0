Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:23505 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751393AbdIMHOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 03:14:44 -0400
Subject: Re: xfs: Uninitialized memory read at xlog_write
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201709042119.CDE26519.MtQJHFOSOFOLVF@I-love.SAKURA.ne.jp>
        <20170911150157.GA13400@bfoster.bfoster>
In-Reply-To: <20170911150157.GA13400@bfoster.bfoster>
Message-Id: <201709131614.FAG69217.MSHFFVOFLJtQOO@I-love.SAKURA.ne.jp>
Date: Wed, 13 Sep 2017 16:14:37 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bfoster@redhat.com
Cc: sandeen@redhat.com, dchinner@redhat.com, linux-xfs@vger.kernel.org

Brian Foster wrote:
> I threw a kmemcheck enabled kernel on a couple boxes out of curiosity.
> I didn't reproduce anything related to XFS with the "allow partially
> uninit." option enabled, even after running a quick group run in
> xfstests. Without that option, I did see an xlog_write() splat on a
> rhel7 boot but it was preceded by a constant stream of other reports
> (__d_lookup(), link_path_walk(), etc.) and ultimately resulted in a
> failed/hung bootup (after quite some time). I'm in the process of seeing
> a similar result on a Fedora vm running for-next. This isn't really
> debuggable in the current form due to the volume of preceding errors,
> the required boot time and the fact that my machines ultimately fall
> over.
> 
> Do you see different behavior? Do you have the "allow partially
> uninitialized memory" option enabled or disabled? I wonder if there are
> fixes for these other errors I'm seeing in linux-next that XFS for-next
> hasn't picked up yet..?

When I tested using linux-next-20170901, xlog_write() was the first splat
(after I workarounded take_dentry_name_snapshot() splat).
Today I retested using linux.git with a different VM and got a different result.

Here are console log and kernel config as of 6d8ef53e8b2fed8b ("Merge tag 'f2fs-for-4.14'
of git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs") on linux.git .

http://I-love.SAKURA.ne.jp/tmp/serial-20170913.txt.xz
http://I-love.SAKURA.ne.jp/tmp/config-4.13-20170913


CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_KMEMCHECK=y
# CONFIG_KMEMCHECK_DISABLED_BY_DEFAULT is not set
CONFIG_KMEMCHECK_ENABLED_BY_DEFAULT=y
# CONFIG_KMEMCHECK_ONESHOT_BY_DEFAULT is not set
CONFIG_KMEMCHECK_QUEUE_SIZE=64
CONFIG_KMEMCHECK_SHADOW_COPY_SHIFT=5
CONFIG_KMEMCHECK_PARTIAL_OK=y
# CONFIG_KMEMCHECK_BITOPS_OK is not set

----------
         Mounting Huge Pages File System...

[  OK  ] Stopped target Switch Root.

[  OK  ] Stopped target Initrd File Systems.[ 1054.691505] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff880135396660)
[ 1054.691506] 000000000000000093050a200000000000000000000000000000000000000000
[ 1054.691511]  u u u u u u u u i i i i i i i i u u u u u u u u u u u u u u u u
[ 1054.691515]  ^
[ 1054.691519] RIP: 0010:xlog_write+0x344/0x6b0
[ 1054.691519] RSP: 0018:ffff8801356d7cd8 EFLAGS: 00010202
[ 1054.691520] RAX: 0000000000000038 RBX: 0000000000000002 RCX: 000000000000000c
[ 1054.691520] RDX: 0000000000000038 RSI: ffff880135396660 RDI: ffffc9000180823c
[ 1054.691521] RBP: ffff8801356d7d70 R08: ffffc90001808234 R09: 0000000000000000
[ 1054.691521] R10: 0000000000000038 R11: 0000000000000000 R12: 0000000000000000
[ 1054.691521] R13: ffff880135396600 R14: 00000000000002b4 R15: ffff8801323f2000
[ 1054.691522] FS:  0000000000000000(0000) GS:ffff88013f400000(0000) knlGS:0000000000000000
[ 1054.691523] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1054.691524] CR2: ffff8801351a3c18 CR3: 000000013d5e4005 CR4: 00000000001606f0
[ 1054.691525]  xlog_write+0x344/0x6b0
[ 1054.691526]  xlog_cil_push+0x240/0x460
[ 1054.691527]  xlog_cil_push_work+0x10/0x20
[ 1054.691529]  process_one_work+0x121/0x2a0
[ 1054.691529]  worker_thread+0x1b7/0x390
[ 1054.691531]  kthread+0xff/0x140
[ 1054.691532]  ret_from_fork+0x22/0x30
[ 1054.691534]  0xffffffffffffffff


[  OK  ] Stopped target Initrd Root File System.
----------
