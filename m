Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86657EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jul 2023 22:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjGFWNc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 18:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGFWNc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2023 18:13:32 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA52910B
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2023 15:13:30 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1b059dd7c0cso1216599fac.0
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jul 2023 15:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688681609; x=1691273609;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jExeW7+e7DUArbO0XmmNbQ9XmipeDlYKtgFw3KXI4AY=;
        b=2tdk8UvSN9JKc3P7puEnyACYONAzuNwEgbzKHkLL3n/zRUR+wEC6fhOOWEci5ThSLC
         zA94BFtgOWPFTYj0yKOkhOutxeoLo9dGiLT8qpfr0d5TqbprnE6E2N3hD4E6K2V741AI
         sNUDG85xpugMtiARiwed48aNBNIAgD2r9h2+N6RaEoTTRS2B36EbGja5luwEDOwU9apI
         KLTf4aWNz3gSOr4BBmawCtEJdJoZj7Nj0okLt2YoSvK0YIj4Ub7W8K0OhoiQRNMztPD4
         EsbNSo3yIIZWZ6qfu7WDi4W80w0t5P0gLuCBQkfwy06wQZZEijRUCMmt7WJB0NEapnj0
         D74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688681609; x=1691273609;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jExeW7+e7DUArbO0XmmNbQ9XmipeDlYKtgFw3KXI4AY=;
        b=bkBa1JSWXnpauNW29pY/GIMH9wkxBfzGJehRiDoAVW6IM23y6GfQbksmtqjpskZvXS
         Vcn/A+5cvXKu//AY5F2PAv9VPNX2Umzvlp3IPoQ4S3h9yXfxLhdvTC+jBWiFotfZL7Ad
         HH62UwZJg1zWsAsbtlS4b3GrDV6Sa7G0LauiabeoRIPrmdAA93ajPGBjLHnNZMFmCZBf
         QeQy9+j3Moaq80PlJY+VENgEvvkkNTRi6+PCH5P/yzP2gngLiEg9fFD0HF3bqc34Ja/n
         0JzIPzhxAJ7dl0MXndIFoak/q8Haya+ZEH9ZaIcZ/OH8aWD9up09nb7ZC2mTdHkzKXGa
         Ubxg==
X-Gm-Message-State: ABy/qLbozAkoELMYCmJ+fWcGa8VeIEuZ2seMiu/ngEqQmztE5zdwpbBG
        iLfT0rvsLOIoOstgnqlAM34AbKsR68Pjpt53mqU=
X-Google-Smtp-Source: APBJJlFnDT9mO1Onag+94JMpuJX6O4KLvc+Wc4U0d7O76NhXP6Nq6EFz+i9GeWpKSuDHSyOFtKTONQ==
X-Received: by 2002:a05:6870:e2ce:b0:1b0:21ca:eb62 with SMTP id w14-20020a056870e2ce00b001b021caeb62mr4353368oad.33.1688681609241;
        Thu, 06 Jul 2023 15:13:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-214-123.pa.vic.optusnet.com.au. [49.186.214.123])
        by smtp.gmail.com with ESMTPSA id m12-20020aa78a0c000000b0067f2f7eccdcsm1696202pfa.193.2023.07.06.15.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 15:13:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qHXE5-002yBz-0v;
        Fri, 07 Jul 2023 08:13:25 +1000
Date:   Fri, 7 Jul 2023 08:13:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [bug report][5.10] deadlock between xfs_create() and
 xfs_inactive()
Message-ID: <ZKc8hfIfKw0L052X@dread.disaster.area>
References: <6fcbbb5a-6247-bab1-0515-359e663c587f@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6fcbbb5a-6247-bab1-0515-359e663c587f@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 06, 2023 at 11:36:26AM +0800, Gao Xiang wrote:
> Hi folks,
> 
> This is a report from our cloud online workloads, it could
> randomly happen about ~20days, and currently we have no idea
> how to reproduce with some artificial testcase reliably:

So much of this code has changed in current upstream kernels....

> The detail is as below:
> 
> 
> (Thread 1)
> already take AGF lock
> loop due to inode I_FREEING
> 
> PID: 1894063 TASK: ffff954f494dc500 CPU: 5 COMMAND: postgres*
> #O [ffffa141ca34f920] schedule at ffffffff9ca58505
> #1 [ffffa141ca34f9b0] schedule at ffffffff9ca5899€
> #2 [ffffa141ca34f9c0] schedule timeout at ffffffff9ca5c027
> #3 [ffffa141ca34fa48] xfs_iget at ffffffffe1137b4f [xfs]	xfs_iget_cache_hit->	-> igrab(inode)
> #4 [ffffa141ca34fb00] xfs_ialloc at ffffffffc1140ab5 [xfs]
> #5 [ffffa141ca34fb80] xfs_dir_ialloc at ffffffffc1142bfc [xfs]
> #6 [ffffa141ca34fc10] xfs_create at ffffffffe1142fc8 [xfs]
> #7 [ffffa141ca34fca0] xfs_generic_create at ffffffffc1140229 [xfs]

So how are we holding the AGF here?

I haven't looked at the 5.10 code yet, but the upstream code is
different; xfs_iget() is not called until xfs_dialloc() has
returned. In that case, if we just allocated an inode from the
inobt, then no blocks have been allocated and the AGF should not be
locked. If we had to allocate a new inode chunk, the transaction has
been rolled and the AGF gets unlocked - we only hold the AGI at that
point.

IIRC the locking is the same for the older kernels (i.e. the
two-phase allocation that holds the AGI locked), so it's not
entirely clear to me how the AGF is getting held locked here.

Ah.

I suspect free inode btree updates using the last free inode
in a chunk, so the chunk is being removed from the finobt and that
is freeing a finobt block (e.g. due to a leaf merge), hence
resulting in the AGF getting locked for the block free and not
needing the transaction to be rolled.

Hmmmmm. Didn't I just fix this problem? This just went into the
current 6.5-rc0 tree:

commit b742d7b4f0e03df25c2a772adcded35044b625ca
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 28 11:04:32 2023 -0700

    xfs: use deferred frees for btree block freeing
    
    Btrees that aren't freespace management trees use the normal extent
    allocation and freeing routines for their blocks. Hence when a btree
    block is freed, a direct call to xfs_free_extent() is made and the
    extent is immediately freed. This puts the entire free space
    management btrees under this path, so we are stacking btrees on
    btrees in the call stack. The inobt, finobt and refcount btrees
    all do this.
    
    However, the bmap btree does not do this - it calls
    xfs_free_extent_later() to defer the extent free operation via an
    XEFI and hence it gets processed in deferred operation processing
    during the commit of the primary transaction (i.e. via intent
    chaining).
    
    We need to change xfs_free_extent() to behave in a non-blocking
    manner so that we can avoid deadlocks with busy extents near ENOSPC
    in transactions that free multiple extents. Inserting or removing a
    record from a btree can cause a multi-level tree merge operation and
    that will free multiple blocks from the btree in a single
    transaction. i.e. we can call xfs_free_extent() multiple times, and
    hence the btree manipulation transaction is vulnerable to this busy
    extent deadlock vector.
    
    To fix this, convert all the remaining callers of xfs_free_extent()
    to use xfs_free_extent_later() to queue XEFIs and hence defer
    processing of the extent frees to a context that can be safely
    restarted if a deadlock condition is detected.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

So this is probably not be a problem on a current ToT....

> ...
> 
> (Thread 2)
> already have inode I_FREEING
> want to take AGF lock
> PID: 202276 TASK: ffff954d142/0000 CPU:2 COMMAND: postgres*
> #0  [ffffa141c12638d0] schedule at ffffffff9ca58505
> #1  [ffffa141c1263960] schedule at ffffffff9ca5899c
> #2  [ffffa141c1263970] schedule timeout at ffffffff9caSc0a9
> #3  [ffffa141c1263988]
> down at ffffffff9caSaba5
> 44  [ffffa141c1263a58] down at ffffffff9c146d6b
> #5  [ffffa141c1263a70] xfs_buf_lock at ffffffffc112c3dc [xfs]
> #6  [ffffa141c1263a80] xfs_buf_find at ffffffffc112c83d [xfs]
> #7  [ffffa141c1263b18] xfs_buf_get_map at ffffffffe112cb3c [xfs]
> #8  [ffffa141c1263b70] xfs_buf_read_map at ffffffffc112d175 [xfs]
> #9  [ffffa141c1263bc8] xfs_trans_read_buf map at ffffffffc116404a [xfs]
> #10 [ffffa141c1263c28] xfs_read_agf at ffffffffc10e1c44 [xfs]
> #11 [ffffa141c1263c80] xfs_alloc_read_agf at ffffffffc10e1d0a [xfs]
> #12 [ffffa141c1263cb0] xfs_agfl_free_finish item at ffffffffc115a45a [xfs]
> #13 [ffffa141c1263d00] xfs_defer_finish_noroll at ffffffffe110257e [xfs]
> #14 [ffffa141c1263d68] xfs_trans_commit at ffffffffe1150581 [xfs]
> #15 [ffffa141c1263da8] xfs_inactive_free at ffffffffc1144084 [xfs]
> #16 [ffffa141c1263dd8] xfs_inactive at ffffffffc11441f2 [xfs)
> #17 [ffffa141c1263dfO] xfs_fs_destroy_inode at ffffffffc114d489 [xfs]
> #18 [ffffa141€1263e10] destroy_inode at ffffffff9c3838a8
> #19 [ffffa141c1263e28] dentry_kill at ffffffff9c37f5d5
> #20 [ffffa141c1263e48] dput at ffffffff9c3800ab
> #21 [ffffa141c1263e70] do_renameat2 at ffffffff9c376a8b
> #22 [ffffa141c1263f38] sys_rename at ffffffff9c376cdc
> #23 [ffffa141c1263f40] do_syscall_64 at ffffffff9ca4a4c0
> #24 [ffffa141c1263f50] entry_SYSCALL_64 after hwframe at ffffffff9cc00099

Ok, so rolling the transaction requires gaining the AGF lock again,
so we are effectively doing:

lock AGI
free inode
lock AGF 
fixup freelist -> defers freeing because AGFL too big
free finobt block/inode chunk
remove inode from unlinked list
xfs_trans_commit()
  logs EFI for AGFL blocks
  rolls transaction
    commits items to CIL
    unlocks AGI	-> allows allocation of inode again
    unlocks AGF
  finishes EFI
    locks AGF
      <blocks>

I think drop/relock AGF after dropping the AGI is fine - the AGI
should be able to free/reallocate inodes in a chunk immediately,
and the reuse is only dependent on icache state (as is happening
here).

> I'm not sure if the mainline kernel still has the issue, but after some
> code review, I guess even after defer inactivation, such inodes pending
> for recycling still keep I_FREEING.

The inode will be (XFS_NEED_INACTIVE | XFS_INACTIVATING), so the
xfs_iget() code won't even be getting as far as calling igrab().
i.e. the VFS inode state is irrelevant with background inodegc...

> IOWs, there are still some
> dependencies between inode i_state and AGF lock with different order so
> it might be racy.  Since it's online workloads, it's hard to switch the
> production environment to the latest kernel.

We should not have any dependencies between inode state and the AGF
lock - the AGI lock should be all that inode allocation/freeing
depends on, and the AGI/AGF ordering dependencies should take care
of everything else.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
