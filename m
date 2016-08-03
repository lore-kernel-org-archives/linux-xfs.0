Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 821EE7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 09:45:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 51821304048
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 07:44:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rQDdqimlWdsA4SSJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 07:44:57 -0700 (PDT)
Date: Wed, 3 Aug 2016 10:44:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [current tot] XFS: Assertion failed: bp->b_flags & XBF_ASYNC,
	file: fs/xfs/xfs_buf.c, line: 118
Message-ID: <20160803144454.GA17518@bfoster.bfoster>
References: <20160803061430.GS16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803061430.GS16044@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 04:14:30PM +1000, Dave Chinner wrote:
> Hi Brian,
> 
> It seems I can hit this fairly often on a single CPU, 1GB ram VM
> in generic/306:
> 

I ended up reproducing on a similarly configured vm via xfs/305
(generic/306 appears unrelated to quota..?).

> [12279.804308] XFS: Assertion failed: bp->b_flags & XBF_ASYNC, file: fs/xfs/xfs_buf.c, line: 118
> [12279.806499] ------------[ cut here ]------------
> [12279.807560] kernel BUG at fs/xfs/xfs_message.c:113!
> [12279.808717] invalid opcode: 0000 [#1] PREEMPT SMP
> [12279.809790] Modules linked in:
> [12279.810526] CPU: 0 PID: 8181 Comm: xfs_quota Tainted: G        W       4.7.0-dgc+ #864
> [12279.812362] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Debian-1.8.2-1 04/01/2014
> [12279.814372] task: ffff880028ae0000 task.stack: ffff88000ec98000
> [12279.815707] RIP: 0010:[<ffffffff81529452>]  [<ffffffff81529452>] assfail+0x22/0x30
> [12279.817477] RSP: 0018:ffff88000ec9bc28  EFLAGS: 00010282
> [12279.818689] RAX: 00000000ffffffea RBX: ffff880008b51930 RCX: 0000000000000021
> [12279.820318] RDX: ffff88000ec9bb50 RSI: 000000000000000a RDI: ffffffff823b0e6c
> [12279.822036] RBP: ffff88000ec9bc28 R08: 0000000000000000 R09: 0000000000000000
> [12279.823643] R10: 000000000000000a R11: f000000000000000 R12: ffff880008b518c0
> [12279.825277] R13: ffff88003d51c6e0 R14: ffff88003d51c600 R15: 0000000000000000
> [12279.826892] FS:  00007f67553c8700(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
> [12279.828734] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [12279.830013] CR2: 00007f6207369008 CR3: 000000001445f000 CR4: 00000000000006f0
> [12279.831621] Stack:
> [12279.832074]  ffff88000ec9bc60 ffffffff8150f498 ffff880039c37920 ffff880034681200
> [12279.833823]  ffff88003d439000 ffff880039c37a98 ffff880039c37ad8 ffff88000ec9bca8
> [12279.835528]  ffffffff8154d705 ffff880008b518c0 ffff880008b518c0 0000000000000000
> [12279.837257] Call Trace:
> [12279.837834]  [<ffffffff8150f498>] xfs_buf_rele+0x2b8/0x3b0
> [12279.839078]  [<ffffffff8154d705>] xfs_qm_dqpurge+0x1d5/0x220
> [12279.840367]  [<ffffffff8154d530>] ? xfs_qm_shrink_count+0x20/0x20
> [12279.841765]  [<ffffffff8154dd40>] xfs_qm_dquot_walk+0x100/0x170
> [12279.843122]  [<ffffffff8154de02>] xfs_qm_dqpurge_all+0x52/0x70
> [12279.844458]  [<ffffffff8154cdd9>] xfs_qm_scall_quotaoff+0x129/0x3f0
> [12279.845887]  [<ffffffff815514dd>] xfs_quota_disable+0x3d/0x50
> [12279.847197]  [<ffffffff8126c602>] SyS_quotactl+0x3c2/0x870
> [12279.848435]  [<ffffffff8120352f>] ? SYSC_newstat+0x2f/0x40
> [12279.849703]  [<ffffffff81e63672>] entry_SYSCALL_64_fastpath+0x1a/0xa4
> [12279.851157] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 c7 c6 a8 03 40 82 48 89 e5 48 89 fa 31 c0 31 ff e8 4e fa ff ff <0f> 0b 66 90 66
> [12279.856516] RIP  [<ffffffff81529452>] assfail+0x22/0x30
> [12279.857739]  RSP <ffff88000ec9bc28>
> [12279.859248] ---[ end trace 496ea0918ba4a5b4 ]---
> 
> 
> I've seen it once also from inode reclaim, and AFAICT, the reason is the
> same both times: they call xfs_bwrite(). It looks to me like we get
> an XBF_INFLIGHT buffer, the reclaim code then tries to flush another
> object on the buffer, takes a reference to it and so prevents the
> XBF_INFLIGHT IO accounting from being decremented when the IO
> completes and releases. It then flushes the object to the buffer and
> calls xfs_bwrite() which clears XBF_ASYNC and it writes the buffer
> again. Once this completes, it calls xfs_buf_rele(), which drops the
> last reference and we try to release the XBF_INFLIGHT accounting.
> That then assert fails because XBF_ASYNC is not set.
> 

Yeah, I collected some buffer tracepoints from a reproducer run (a few
custom ioacct tps added):

    xfsaild/dm-3-13580 [000]  3231.470825: xfs_buf_trylock:      dev 253:3 bno 0x50 nblks 0x8 hold 2 pincount 0 lock 0 flags ASYNC|DONE|PAGES caller 0xffffffffc0575c6bs
    xfsaild/dm-3-13580 [000]  3231.470826: xfs_buf_find:         dev 253:3 bno 0x50 len 0x1000 hold 2 pincount 0 lock 0 flags READ caller 0xffffffffc05760eas
    xfsaild/dm-3-13580 [000]  3231.470826: xfs_buf_get:          dev 253:3 bno 0x50 len 0x1000 hold 2 pincount 0 lock 0 flags READ caller 0xffffffffc057709ds
    xfsaild/dm-3-13580 [000]  3231.470826: xfs_buf_read:         dev 253:3 bno 0x50 len 0x1000 hold 2 pincount 0 lock 0 flags READ caller 0xffffffffc05ab822s
    xfsaild/dm-3-13580 [000]  3231.470827: xfs_buf_delwri_queue: dev 253:3 bno 0x50 nblks 0x8 hold 2 pincount 0 lock 0 flags ASYNC|DONE|PAGES caller 0xffffffffc05af52as
    xfsaild/dm-3-13580 [000]  3231.470827: xfs_buf_unlock:       dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 1 flags ASYNC|DONE|PAGES|DELWRI_Q caller 0xffffffffc05af53ds
    xfsaild/dm-3-13580 [000]  3231.470828: xfs_buf_rele:         dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 1 flags ASYNC|DONE|PAGES|DELWRI_Q caller 0xffffffffc05af545s
    xfsaild/dm-3-13580 [000]  3231.471477: xfs_buf_trylock:      dev 253:3 bno 0x50 nblks 0x8 hold 2 pincount 0 lock 0 flags ASYNC|DONE|PAGES|DELWRI_Q caller 0xffffffffc0576de2s
    xfsaild/dm-3-13580 [000]  3231.471477: xfs_buf_delwri_split: dev 253:3 bno 0x50 nblks 0x8 hold 2 pincount 0 lock 0 flags ASYNC|DONE|PAGES|DELWRI_Q caller 0xffffffffc0577d50s
    xfsaild/dm-3-13580 [000]  3231.471478: xfs_buf_submit:       dev 253:3 bno 0x50 nblks 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES caller 0xffffffffc0576ccfs
    xfsaild/dm-3-13580 [000]  3231.471478: xfs_buf_hold:         dev 253:3 bno 0x50 nblks 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES caller 0xffffffffc05769ccs
    xfsaild/dm-3-13580 [000]  3231.471478: xfs_buf_ioacct_inc:   dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES caller 0xffffffffc0576ccfs
    xfsaild/dm-3-13580 [000]  3231.471483: xfs_buf_rele:         dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES|IN_FLIGHT caller 0xffffffffc05769fds
       xfs_quota-13687 [000]  3231.478357: xfs_buf_trylock_fail: dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES|IN_FLIGHT caller 0xffffffffc0575c6bs
       xfs_quota-13687 [000]  3231.478358: xfs_buf_lock:         dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES|IN_FLIGHT caller 0xffffffffc0575c84s
     kworker/0:1-9420  [000]  3231.637774: xfs_buf_iodone:       dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES|IN_FLIGHT caller 0xffffffffc05764b5s
     kworker/0:1-9420  [000]  3231.637775: xfs_buf_iodone:       dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags ASYNC|DONE|PAGES|IN_FLIGHT caller 0xffffffffc05a01aas
     kworker/0:1-9420  [000]  3231.637779: xfs_buf_unlock:       dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags ASYNC|DONE|PAGES|IN_FLIGHT caller 0xffffffffc05a01aas
     kworker/0:1-9420  [000]  3231.637779: xfs_buf_rele:         dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags ASYNC|DONE|PAGES|IN_FLIGHT caller 0xffffffffc0576455s
       xfs_quota-13687 [000]  3231.637827: xfs_buf_lock_done:    dev 253:3 bno 0x50 nblks 0x8 hold 2 pincount 0 lock 0 flags ASYNC|DONE|PAGES|IN_FLIGHT caller 0xffffffffc0575c84s
       xfs_quota-13687 [000]  3231.637828: xfs_buf_find:         dev 253:3 bno 0x50 len 0x1000 hold 2 pincount 0 lock 0 flags READ caller 0xffffffffc05760eas
       xfs_quota-13687 [000]  3231.637828: xfs_buf_get:          dev 253:3 bno 0x50 len 0x1000 hold 2 pincount 0 lock 0 flags READ caller 0xffffffffc057709ds
       xfs_quota-13687 [000]  3231.637829: xfs_buf_read:         dev 253:3 bno 0x50 len 0x1000 hold 2 pincount 0 lock 0 flags READ caller 0xffffffffc05ab822s
       xfs_quota-13687 [000]  3231.637832: xfs_buf_submit_wait:  dev 253:3 bno 0x50 nblks 0x8 hold 2 pincount 0 lock 0 flags WRITE|PAGES|IN_FLIGHT caller 0xffffffffc05773d6s
       xfs_quota-13687 [000]  3231.637833: xfs_buf_hold:         dev 253:3 bno 0x50 nblks 0x8 hold 2 pincount 0 lock 0 flags WRITE|PAGES|IN_FLIGHT caller 0xffffffffc0576e6cs
       xfs_quota-13687 [000]  3231.637850: xfs_buf_iowait:       dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags WRITE|PAGES|IN_FLIGHT caller 0xffffffffc05773d6s
     kworker/0:1-9420  [000]  3232.565081: xfs_buf_iodone:       dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags WRITE|PAGES|IN_FLIGHT caller 0xffffffffc05764b5s
     kworker/0:1-9420  [000]  3232.565082: xfs_buf_iodone:       dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES|IN_FLIGHT caller 0xffffffffc05a01aas
       xfs_quota-13687 [000]  3232.565092: xfs_buf_iowait_done:  dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES|IN_FLIGHT caller 0xffffffffc05773d6s
       xfs_quota-13687 [000]  3232.565093: xfs_buf_rele:         dev 253:3 bno 0x50 nblks 0x8 hold 3 pincount 0 lock 0 flags DONE|PAGES|IN_FLIGHT caller 0xffffffffc0576eb8s
       xfs_quota-13687 [000]  3232.565094: xfs_buf_unlock:       dev 253:3 bno 0x50 nblks 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES|IN_FLIGHT caller 0xffffffffc05b27f2s
       xfs_quota-13687 [000]  3232.565094: xfs_buf_rele:         dev 253:3 bno 0x50 nblks 0x8 hold 2 pincount 0 lock 1 flags DONE|PAGES|IN_FLIGHT caller 0xffffffffc05b27fes
       xfs_quota-13687 [000]  3232.565094: xfs_buf_ioacct_dec:   dev 253:3 bno 0x50 nblks 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES|IN_FLIGHT caller 0xffffffffc05b27fes
       xfs_quota-13687 [000]  3232.565095: xfs_buf_ioacct_dec_assert: dev 253:3 bno 0x50 nblks 0x8 hold 1 pincount 0 lock 1 flags DONE|PAGES|IN_FLIGHT caller 0xffffffffc05b27fes

I don't have the surrounding context, but this clearly shows a buffer
going through an async I/O and sync I/O within a single non-zero hold
count cycle.

> It looks to me like we should just remove the assert - I forgot
> about this particular corner case. Can you have a quick look and
> check whether my analysis above is correct or whether I've missed
> something else here?
> 

Agreed. I'll fire off a patch. Thanks for catching this.

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
