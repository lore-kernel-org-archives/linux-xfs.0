Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9F5EB64D9
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Jul 2023 02:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjGGC5y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 22:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjGGC5x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2023 22:57:53 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7597A1990
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2023 19:57:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Vmml-0d_1688698666;
Received: from 30.97.49.2(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vmml-0d_1688698666)
          by smtp.aliyun-inc.com;
          Fri, 07 Jul 2023 10:57:48 +0800
Message-ID: <174115e7-fffa-393b-0310-2694370721d7@linux.alibaba.com>
Date:   Fri, 7 Jul 2023 10:57:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [bug report][5.10] deadlock between xfs_create() and
 xfs_inactive()
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <6fcbbb5a-6247-bab1-0515-359e663c587f@linux.alibaba.com>
 <ZKc8hfIfKw0L052X@dread.disaster.area>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ZKc8hfIfKw0L052X@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On 2023/7/7 06:13, Dave Chinner wrote:
> On Thu, Jul 06, 2023 at 11:36:26AM +0800, Gao Xiang wrote:
>> Hi folks,
>>
>> This is a report from our cloud online workloads, it could
>> randomly happen about ~20days, and currently we have no idea
>> how to reproduce with some artificial testcase reliably:
> 
> So much of this code has changed in current upstream kernels....
> 
>> The detail is as below:
>>
>>
>> (Thread 1)
>> already take AGF lock
>> loop due to inode I_FREEING
>>
>> PID: 1894063 TASK: ffff954f494dc500 CPU: 5 COMMAND: postgres*
>> #O [ffffa141ca34f920] schedule at ffffffff9ca58505
>> #1 [ffffa141ca34f9b0] schedule at ffffffff9ca5899€
>> #2 [ffffa141ca34f9c0] schedule timeout at ffffffff9ca5c027
>> #3 [ffffa141ca34fa48] xfs_iget at ffffffffe1137b4f [xfs]	xfs_iget_cache_hit->	-> igrab(inode)
>> #4 [ffffa141ca34fb00] xfs_ialloc at ffffffffc1140ab5 [xfs]
>> #5 [ffffa141ca34fb80] xfs_dir_ialloc at ffffffffc1142bfc [xfs]
>> #6 [ffffa141ca34fc10] xfs_create at ffffffffe1142fc8 [xfs]
>> #7 [ffffa141ca34fca0] xfs_generic_create at ffffffffc1140229 [xfs]
> 
> So how are we holding the AGF here?
> 
> I haven't looked at the 5.10 code yet, but the upstream code is
> different; xfs_iget() is not called until xfs_dialloc() has
> returned. In that case, if we just allocated an inode from the
> inobt, then no blocks have been allocated and the AGF should not be
> locked. If we had to allocate a new inode chunk, the transaction has
> been rolled and the AGF gets unlocked - we only hold the AGI at that
> point.
> 
> IIRC the locking is the same for the older kernels (i.e. the
> two-phase allocation that holds the AGI locked), so it's not
> entirely clear to me how the AGF is getting held locked here.
> 
> Ah.
> 
> I suspect free inode btree updates using the last free inode
> in a chunk, so the chunk is being removed from the finobt and that
> is freeing a finobt block (e.g. due to a leaf merge), hence
> resulting in the AGF getting locked for the block free and not
> needing the transaction to be rolled.
> 
> Hmmmmm. Didn't I just fix this problem? This just went into the
> current 6.5-rc0 tree:
> 
> commit b742d7b4f0e03df25c2a772adcded35044b625ca
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Jun 28 11:04:32 2023 -0700
> 
>      xfs: use deferred frees for btree block freeing
>      
>      Btrees that aren't freespace management trees use the normal extent
>      allocation and freeing routines for their blocks. Hence when a btree
>      block is freed, a direct call to xfs_free_extent() is made and the
>      extent is immediately freed. This puts the entire free space
>      management btrees under this path, so we are stacking btrees on
>      btrees in the call stack. The inobt, finobt and refcount btrees
>      all do this.
>      
>      However, the bmap btree does not do this - it calls
>      xfs_free_extent_later() to defer the extent free operation via an
>      XEFI and hence it gets processed in deferred operation processing
>      during the commit of the primary transaction (i.e. via intent
>      chaining).
>      
>      We need to change xfs_free_extent() to behave in a non-blocking
>      manner so that we can avoid deadlocks with busy extents near ENOSPC
>      in transactions that free multiple extents. Inserting or removing a
>      record from a btree can cause a multi-level tree merge operation and
>      that will free multiple blocks from the btree in a single
>      transaction. i.e. we can call xfs_free_extent() multiple times, and
>      hence the btree manipulation transaction is vulnerable to this busy
>      extent deadlock vector.
>      
>      To fix this, convert all the remaining callers of xfs_free_extent()
>      to use xfs_free_extent_later() to queue XEFIs and hence defer
>      processing of the extent frees to a context that can be safely
>      restarted if a deadlock condition is detected.
>      
>      Signed-off-by: Dave Chinner <dchinner@redhat.com>
>      Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>      Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>      Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
> 
> So this is probably not be a problem on a current ToT....


Thanks for your reply and time on this issue.

Yes, if the transaction is rolled (due to new inode chunk), we
only hold AGI and roll this, so AGF won't be take even on Linux
5.10 too, finobt might be the stuff I think it would be
problematic (our consumer confirmed that `finobt is enabled`
as well):

  - xfs_dialloc (5.10)
      - pag->pagi_freecount != 0     goto out_alloc;
      - xfs_dialloc_ag
         ...
         /*
          * Modify or remove the finobt record.
          */
         rec.ir_free &= ~XFS_INOBT_MASK(offset);
         rec.ir_freecount--;
         if (rec.ir_freecount)
                 error = xfs_inobt_update(cur, &rec);
         else
                 error = xfs_btree_delete(cur, &i);
         if (error)
                 goto error_cur;

    finobt deletion might trigger that.

I think we will finally find a way and more time to look
into backport these, ... finally.. (manpower is limited now.)

> 
>> ...
>>
>> (Thread 2)
>> already have inode I_FREEING
>> want to take AGF lock
>> PID: 202276 TASK: ffff954d142/0000 CPU:2 COMMAND: postgres*
>> #0  [ffffa141c12638d0] schedule at ffffffff9ca58505
>> #1  [ffffa141c1263960] schedule at ffffffff9ca5899c
>> #2  [ffffa141c1263970] schedule timeout at ffffffff9caSc0a9
>> #3  [ffffa141c1263988]
>> down at ffffffff9caSaba5
>> 44  [ffffa141c1263a58] down at ffffffff9c146d6b
>> #5  [ffffa141c1263a70] xfs_buf_lock at ffffffffc112c3dc [xfs]
>> #6  [ffffa141c1263a80] xfs_buf_find at ffffffffc112c83d [xfs]
>> #7  [ffffa141c1263b18] xfs_buf_get_map at ffffffffe112cb3c [xfs]
>> #8  [ffffa141c1263b70] xfs_buf_read_map at ffffffffc112d175 [xfs]
>> #9  [ffffa141c1263bc8] xfs_trans_read_buf map at ffffffffc116404a [xfs]
>> #10 [ffffa141c1263c28] xfs_read_agf at ffffffffc10e1c44 [xfs]
>> #11 [ffffa141c1263c80] xfs_alloc_read_agf at ffffffffc10e1d0a [xfs]
>> #12 [ffffa141c1263cb0] xfs_agfl_free_finish item at ffffffffc115a45a [xfs]
>> #13 [ffffa141c1263d00] xfs_defer_finish_noroll at ffffffffe110257e [xfs]
>> #14 [ffffa141c1263d68] xfs_trans_commit at ffffffffe1150581 [xfs]
>> #15 [ffffa141c1263da8] xfs_inactive_free at ffffffffc1144084 [xfs]
>> #16 [ffffa141c1263dd8] xfs_inactive at ffffffffc11441f2 [xfs)
>> #17 [ffffa141c1263dfO] xfs_fs_destroy_inode at ffffffffc114d489 [xfs]
>> #18 [ffffa141€1263e10] destroy_inode at ffffffff9c3838a8
>> #19 [ffffa141c1263e28] dentry_kill at ffffffff9c37f5d5
>> #20 [ffffa141c1263e48] dput at ffffffff9c3800ab
>> #21 [ffffa141c1263e70] do_renameat2 at ffffffff9c376a8b
>> #22 [ffffa141c1263f38] sys_rename at ffffffff9c376cdc
>> #23 [ffffa141c1263f40] do_syscall_64 at ffffffff9ca4a4c0
>> #24 [ffffa141c1263f50] entry_SYSCALL_64 after hwframe at ffffffff9cc00099
> 

..

>> IOWs, there are still some
>> dependencies between inode i_state and AGF lock with different order so
>> it might be racy.  Since it's online workloads, it's hard to switch the
>> production environment to the latest kernel.
> 
> We should not have any dependencies between inode state and the AGF
> lock - the AGI lock should be all that inode allocation/freeing
> depends on, and the AGI/AGF ordering dependencies should take care
> of everything else.

Agreed, I just meant inode eviction just hard-coded

    inode state  ----->   AGF    dependency

due to vfs internals (since we are in inode eviction context) so we
need to avoid any potential opposite order (like AGF -----> inode
state or likewise).

Thanks again for the help!

Thanks,
Gao Xiang

> 
> Cheers,
> 
> Dave.
