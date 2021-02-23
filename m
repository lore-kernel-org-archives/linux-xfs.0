Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBA5C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 04:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5088C64E5C
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 04:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhBWEvt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 23:51:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230434AbhBWEvr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 23:51:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E591564E25;
        Tue, 23 Feb 2021 04:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614055867;
        bh=P5uzsvPV3RnDPEFVpB/g+8PVfSP2k4k3lh3aN9loRyc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QLEsBSFQ1sTgu6TbgGLp76yEV8vPCn3MCeI4G4BvEh1TIenOBVT104w3RFV1LNmlr
         8HszAediFigLKRWr9YddxVVa4/wuRnqyVGNssq1LOpttb+kLmPmvPQgULwl+HQjhGg
         0K6L4uZfYjxwEgklXQyU0gMwdT3PuMqsHqgTo33K3z7j1qNJb3ctOrPARKwIbpWCR4
         NnDKkW1n2k+ttRRs8jAzTbtY/m18dLmbXlORIL7RbLBM0tzyoAB7IZeTjDUJwo6bov
         Q9DVGJYdv0yeQbdSWZXaPMfqZaTIIdONUDbq8E3kSsL+1P9GS4Uf7fuvGfzP/CO/Uw
         47snQtYz9VZ1w==
Date:   Mon, 22 Feb 2021 20:51:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use current->journal_info for detecting transaction
 recursion
Message-ID: <20210223045105.GH7272@magnolia>
References: <20210222233107.3233795-1-david@fromorbit.com>
 <20210223021557.GF7272@magnolia>
 <20210223032837.GS4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223032837.GS4662@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 02:28:37PM +1100, Dave Chinner wrote:
> On Mon, Feb 22, 2021 at 06:15:57PM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 23, 2021 at 10:31:07AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Because the iomap code using PF_MEMALLOC_NOFS to detect transaction
> > > recursion in XFS is just wrong. Remove it from the iomap code and
> > > replace it with XFS specific internal checks using
> > > current->journal_info instead.
> > 
> > It might be worth mentioning that this changes the PF_MEMALLOC_NOFS
> > behavior very slightly -- it's now bound to the allocation and freeing
> > of the transaction, instead of the strange way we used to do this, where
> > we'd set it at reservation time but we don't /clear/ it at unreserve time.
> 
> They are effectively the same thing, so I think you are splitting
> hairs here. The rule is "transaction context is NOFS" so whether it
> is set when the transaction context is entered or a few instructions
> later when we start the reservation is not significant.
> 
> > This doesn't strictly look like a fix patch, but as it is a Dumb
> > Developer Detector(tm) I could try to push it for 5.12 ... or just make
> > it one of the first 5.13 patches.  Any preference?
> 
> Nope. You're going to need to fix the transaction nesting the new gc
> code does before applying this, though, because that is detected as
> transaction recursion by this patch....

Well yes, I was trying to see if I could throw in the fix patch and the
idiot detector, both at the same time... :)

That said, it crashes in xfs/229:

  2822            args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
  2823                                             args->key, args->curp, args->stat);
  2824            complete(args->done);
  2825
> 2826            xfs_trans_clear_context(args->cur->bc_tp);
  2827            current_restore_flags_nested(&pflags, new_pflags);

It's possible for the original wait_for_completion() in
xfs_btree_split() to wake up immediately after complete() drops the
lock.  If it returns (and blows away the stack variable @args) before
the worker resumes, then the worker will be dereferencing freed stack
memory and blows up:

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0 
 Oops: 0000 [#1] PREEMPT SMP
 CPU: 0 PID: 375393 Comm: kworker/0:16 Tainted: G        W         5.11.0-rc4-djw #rc4
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
 Workqueue: xfsalloc xfs_btree_split_worker [xfs]
 RIP: 0010:xfs_btree_split_worker+0xaa/0x120 [xfs]
 Code: 4b d8 48 8b 53 d0 8b 73 c8 48 8b 7b c0 4c 8b 4b e8 4c 8b 43 e0 e8 46 f5 ff ff 48 8b 7b f8 89 43 f0 e8 0a 84 aa e0 48 8b 43 c0 <48> 8b 00 49 3b 84 24 90 08 00 00 74 20 65 48 8b 14 25 80 6d 01 00
 RSP: 0018:ffffc90003123e60 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffffc9000311b8a8 RCX: 0000000000000000
 RDX: 0000000000000001 RSI: 0000000000000286 RDI: 00000000ffffffff
 RBP: 0000000000000000 R08: ffffc9000311b858 R09: ffff88803ec29f80
 R10: ffff8880054a80d0 R11: ffff88803ec2a030 R12: ffff888005235d00
 R13: 0000000004248060 R14: ffff88800cbe5f00 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 000000000200c002 CR4: 00000000001706b0
 Call Trace:
  process_one_work+0x1dd/0x3b0
  worker_thread+0x57/0x3c0
  ? rescuer_thread+0x3b0/0x3b0
  kthread+0x14f/0x170
  ? __kthread_bind_mask+0x60/0x60
  ret_from_fork+0x1f/0x30
 Modules linked in: xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio dm_flakey libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip xt_REDIRECT xt_set xt_tcpudp ip_set_hash_net ip_set_hash_mac ip_set nfnetlink iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6table_filter ip6_tables iptable_filter bfq sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet [last unloaded: xfs]
 Dumping ftrace buffer:
    (ftrace buffer empty)
 CR2: 0000000000000000
 ---[ end trace 1a6aae037bf68618 ]---

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
