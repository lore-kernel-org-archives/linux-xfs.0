Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD790C4167B
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 01:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiK3BGp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 20:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiK3BGn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 20:06:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5685915B
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 17:06:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93F2CB819A7
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 01:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B95C433C1;
        Wed, 30 Nov 2022 01:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669770398;
        bh=fUO+uzsfulIj68THMUH/m45zUj1ROIJKZ2yfO8vy3xk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TIMoXW3dRBhjjvuwfzZ0iAmE6uqTEwmGYZsM8O/i/d4ZmgOSOvRHGFsnl9J6PVY0l
         2X2do7BAEfmoRSjdEDYGnp8KM4j9uGUmEgTDmpJA2nCu21uc1vh4QmINc/NkhJ7/Oh
         CEF78m/oLIaj5IbDMVS6HS+jyDv9NsaguPL0ChbESMCuFOunWv/Tx3Nf/CNZSlX3NP
         I1x74EMmrkGKIlsHvXfvn/o/7mvFA4oz5WDUxKuhYUh+EkZJvfFJTgxzhOnChy1rfm
         WYoazcQUrzFscSbRRWWL5QstoCho9dNGmb2YzaMFIdTb6usReG0DvUjGPtXCQGjmpm
         UNBJ9KJWCthKA==
Date:   Tue, 29 Nov 2022 17:06:37 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Guo Xuenan <guoxuenan@huaweicloud.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Guo Xuenan <guoxuenan@huawei.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, houtao1@huawei.com, jack.qiu@huawei.com,
        fangwei1@huawei.com, yi.zhang@huawei.com, zhengbin13@huawei.com,
        leo.lilong@huawei.com, zengheng4@huawei.com
Subject: Re: [PATCH] xfs: fix incorrect usage of xfs_btree_check_block
Message-ID: <Y4asnaXEobxY0LL5@magnolia>
References: <20221103113709.251669-1-guoxuenan@huawei.com>
 <Y2k5NTjTRdsDAuhN@magnolia>
 <1afe73bb-481c-01b3-8c61-3d208e359f40@huawei.com>
 <6ad3b4b0-f25b-1609-e79b-82204bc5577a@redhat.com>
 <Y3aGas1bc7IMTS/h@magnolia>
 <aea89526-7bd0-2ed8-be8c-0a2ddc7571bd@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aea89526-7bd0-2ed8-be8c-0a2ddc7571bd@huaweicloud.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 11:52:57AM +0800, Guo Xuenan wrote:
> Hi Darrick，
> 
> I asked my colleagues about email-sending problems.
> I am not the only one with the problem :( so,my reply of you question here
> also sent faild. With my colleague's advice, I change a new email address.
> Hope from now on, my email can be received by mailing list :)
> On 2022/11/18 3:07, Darrick J. Wong wrote:
> > On Thu, Nov 17, 2022 at 10:13:46AM -0600, Eric Sandeen wrote:
> > > On 11/7/22 7:50 PM, Guo Xuenan wrote:
> > > > On 2022/11/8 0:58, Darrick J. Wong wrote:
> > > > > On Thu, Nov 03, 2022 at 07:37:09PM +0800, Guo Xuenan wrote:
> > > > > > xfs_btree_check_block contains a tag XFS_ERRTAG_BTREE_CHECK_{L,S}BLOCK,
> > > > > > it is a fault injection tag, better not use it in the macro ASSERT.
> > > > > > 
> > > > > > Since with XFS_DEBUG setting up, we can always trigger assert by `echo 1
> > > > > > > /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
> > > > > > It's confusing and strange.
> > > > > Please be more specific about how this is confusing or strange.
> > > > I meant in current code, the ASSERT will alway happen,when we
> > > > `echo 1 > /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
> > > > xfs_btree_islastblock
> > > >    ->ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
> > > >      ->xfs_btree_check_{l/s}block
> > > >        ->XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_{S,L}BLOCK)
> > > > we can use error injection to trigger this ASSERT.
> > > Hmmm...
> > > 
> > > > I think ASERRT macro and error injection are to find some effective problems,
> > > > not to create some kernel panic.
> > > You can avoid a panic by turning XFS_ASSERT_FATAL off in Kconfig, or
> > > at runtime by setting fs.xfs.bug_on_assert to 0, but ...
> > > 
> > > > So, putting the error injection function in
> > > > ASSERT is a little strange.
> > > Ok, so I think the argument is that in the default config, setting this error
> > > injection tag will immediately result in a system panic, which probably isn't
> > > what we want.  Is my understanding correct?
> Yes, Eric, you are right, that's just what i mean.
> > > But in the bigger picture, isn't this:
> > > 
> > > ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
> > > 
> > > putting a disk corruption check into an ASSERT? That in itself seems a bit
> > > suspect.  However, the ASSERT was all introduced in:
> > > 
> > > commit 27d9ee577dccec94fb0fc1a14728de64db342f86
> > > Author: Darrick J. Wong <darrick.wong@oracle.com>
> > > Date:   Wed Nov 6 08:47:09 2019 -0800
> > > 
> > >      xfs: actually check xfs_btree_check_block return in xfs_btree_islastblock
> > >      Coverity points out that xfs_btree_islastblock doesn't check the return
> > >      value of xfs_btree_check_block.  Since the question "Does the cursor
> > >      point to the last block in this level?" only makes sense if the caller
> > >      previously performed a lookup or seek operation, the block should
> > >      already have been checked.
> > >      Therefore, check the return value in an ASSERT and turn the whole thing
> > >      into a static inline predicate.
> > >      Coverity-id: 114069
> > >      Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > >      Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > which seems to imply that we really should not get here with a corrupt block during
> > > normal operation.
> It did, xfs_alloc_ag_vextent_near->xfs_btree_islastblock, see below for more
> details.
> > > Perhaps the error tag can get set after the block "should already have been checked"
> > > but before this test in the ASSERT?
> > What I want to know here is *how* do we get to the point of tripping
> > this assertion via debugknob?  Won't the lookup or seek operation have
> > already checked the block and failed with EFSCORRUPTED?  And shouldn't
> > that be enough to stop whatever code calls xfs_btree_islastblock?  If
> > not, how do we get there?
> > 
> > Seriously, I don't want to burn more time discussing where and how to
> > fail on debugging knobs when there are all these other **far more
> > serious** corruption and deadlock problems that people are trying to get
> > merged.
> > 
> > Tell me specifically how to make the system fail.  "It's confusing and
> > strange" is not good enough.
> Sorry,It's my fault. I didn't explain it clearly enough,and I don't think
> this is a serious problem either. The background of the matter is we have
> some testcases to test xfs, some of them are fault inject cases,and make
> our testcase failed.
> 
> As Eric pointed out "You can avoid a panic by turning XFS_ASSERT_FATAL off in Kconfig"
> It's just a little strange to me,and always make our testcase failed.
> I just report it and if you are not interested in this patch,I am not strongly request
> this to make it merged.
> 
> Here is the *how*, show you the test code and call trace.
> 
> *This is the test case:*
> function do_test()
> {
> 	echo "--- in do_test ---"
> 	_mount "$mount_options" $disk $mountpoint
> 	_check_fsstress $mountpoint # just do: fsstress -d $testdir -l 0 -n 10000 -p 4 >/dev/null
> 	echo 1 > /sys/fs/xfs/sda/errortag/btree_chk_sblk

Ok, now we're finally getting somewhere.  You kick off fsstress, and
only *then* turn on the debugging knob.  If it happens that the knob
gets turned on after the cntbt lookup succeeds but before the call to
xfs_btree_islastblock, then we *can* end up in the situation where a
previously checked btree block suddenly starts returning EFSCORRUPTED
from xfs_btree_check_block.  Kaboom.

Looking back at commit 27d9ee577dcce, I think the point of all this was
to make sure that the cursor has actually performed a lookup, and that
the btree block at whatever level we're asking about is ok.

If the caller hasn't ever done a lookup, the bc_levels array will be
empty, so cur->bc_levels[level].bp pointer will be NULL.  The call to
xfs_btree_get_block will crash anyway, so the "ASSERT(block);" part is
pointless.

If the caller did a lookup but the lookup failed due to block
corruption, the corresponding cur->bc_levels[level].bp pointer will also
be NULL, and we'll still crash.  The "ASSERT(xfs_btree_check_block);"
logic is also unnecessary.

If the cursor level points to an inode root, the block buffer will be
incore, so it had better always be consistent.

If the caller ignores a failed lookup after a successful one and calls
this function, the cursor state is garbage and the assert wouldn't have
tripped anyway.

So get rid of the assert, and please edit the commit message to include
all these details.

--D

> 	sleep $ERROR_TEST_RUN_TIME
> }
> 
> round=0
> do_pre
> while [ $round -lt $round_max ]
> do
> 	echo "******* round $round ********"
> 	do_test
> 	round=$(($round+1))
> done
> 
> *This is the call trace:*
> XFS (sda): fsstress should use fallocate; XFS_IOC_{ALLOC,FREE}SP ioctl
> unsupported
> XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, line
> 243, on filesystem "sda"
> XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, line
> 243, on filesystem "sda"
> XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, line
> 243, on filesystem "sda"
> XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, line
> 243, on filesystem "sda"
> XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, line
> 243, on filesystem "sda"
> XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, line
> 243, on filesystem "sda"
> XFS (sda): Corruption of in-memory data (0x8) detected at
> xfs_defer_finish_noroll+0x100c/0x19e0 (fs/xfs/libxfs/xfs_defer.c:573). 
> Shutting down filesystem.
> XFS (sda): Please unmount the filesystem and rectify the problem(s)
> xfs filesystem being mounted at /mnt/test supports timestamps until 2038
> (0x7fffffff)
> xfs filesystem being mounted at /mnt/test supports timestamps until 2038
> (0x7fffffff)
> XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, line
> 243, on filesystem "sda"
> XFS: Assertion failed: block && xfs_btree_check_block(cur, block, level, bp)
> == 0, file: fs/xfs/libxfs/xfs_btree.h, line: 559
> ------------[ cut here ]------------
> kernel BUG at fs/xfs/xfs_message.c:102!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, line
> 243, on filesystem "sda"
> CPU: 0 PID: 30 Comm: kworker/u4:2 Not tainted 6.1.0-rc4-01347-geab06d36b0ac
> #510
> XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, line
> 243, on filesystem "sda"
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34
> 04/01/2014
> Workqueue: writeback wb_workfn (flush-8:0)
> RIP: 0010:assfail+0x7a/0x8a
> Code: 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 0c 48 c7 c7 b0 72 03 8c
> e8 3d 45 d5 fd 80 3d f6 ab 4e 08 00 74 07 e8 df e4 91 fd <0f> 0b e8 d8 e4 91
> fd 0f 0b 5b 5d 41 5c 41 5d c3 e8 ca e4 91 fd 48
> RSP: 0018:ffff888010ab6ab8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffffff84427ce0 RCX: 0000000000000000
> RDX: ffff888010aa8040 RSI: ffffffff83b4c6c1 RDI: ffffed1002156d46
> RBP: 0000000000000000 R08: 000000000000007d R09: ffff888010ab6777
> XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, line
> 243, on filesystem "sda"
> R10: ffffed1002156cee R11: 0000000000000001 R12: ffffffff84427d20
> R13: 000000000000022f R14: ffff888010ab6b88 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88805a400000(0000) knlGS:0000000000000000
> XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_btree.c, line
> 243, on filesystem "sda"
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> XFS (sda): xfs_inactive_ifree: xfs_ifree returned error -117
> CR2: 0000000001d192b8 CR3: 0000000017d0e000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  xfs_alloc_ag_vextent_near.constprop.0+0x945/0x13b0
>  xfs_alloc_ag_vextent+0x7a6/0xdd0
>  xfs_alloc_vextent+0x13d2/0x1cd0
>  xfs_bmap_btalloc+0x778/0x1450
>  xfs_bmapi_allocate+0x348/0x1260
>  xfs_bmapi_convert_delalloc+0x669/0xd50
>  xfs_map_blocks+0x4f7/0xc50
>  iomap_do_writepage+0x785/0x1ed0
>  write_cache_pages+0x39e/0xd60
>  iomap_writepages+0x50/0xb0
>  xfs_vm_writepages+0x128/0x1b0
>  do_writepages+0x196/0x640
>  __writeback_single_inode+0xae/0x8d0
>  writeback_sb_inodes+0x4b8/0xc00
>  __writeback_inodes_wb+0xc1/0x220
>  wb_writeback+0x590/0x730
>  wb_workfn+0x7a4/0xca0
>  process_one_work+0x6d1/0xf40
>  worker_thread+0x5b9/0xf60
>  kthread+0x287/0x330
>  ret_from_fork+0x1f/0x30
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:assfail+0x7a/0x8a
> Code: 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 0c 48 c7 c7 b0 72 03 8c
> e8 3d 45 d5 fd 80 3d f6 ab 4e 08 00 74 07 e8 df e4 91 fd <0f> 0b e8 d8 e4 91
> fd 0f 0b 5b 5d 41 5c 41 5d c3 e8 ca e4 91 fd 48
> RSP: 0018:ffff888010ab6ab8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffffff84427ce0 RCX: 0000000000000000
> RDX: ffff888010aa8040 RSI: ffffffff83b4c6c1 RDI: ffffed1002156d46
> RBP: 0000000000000000 R08: 000000000000007d R09: ffff888010ab6777
> R10: ffffed1002156cee R11: 0000000000000001 R12: ffffffff84427d20
> R13: 000000000000022f R14: ffff888010ab6b88 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88805a400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000001d192b8 CR3: 0000000017d0e000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Kernel panic - not syncing: Fatal exception
> Kernel Offset: disabled
> 
> ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> Best wishes,
> Xuenan
> > --D
> > 
> > > -Eric
> > > 
> 
