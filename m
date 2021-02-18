Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B5DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 19:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A515364E6F
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 19:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhBRTaa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 14:30:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233019AbhBRSuP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 13:50:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97AFE61606;
        Thu, 18 Feb 2021 18:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613674167;
        bh=isKAoIqsB7udiaqXYSNGFdtv8IvmH4VyL/Fd4tUo2pc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TUmx2IvllqhB2tt5O52aU5TWHga4ttSNCFXj9l/hErnjVcDbOEbH7euaF4gw7IJ7O
         KSHX8BbXvZxgwsUnkOCZ4CBbeT1YB6H2t5+T7Y3OyQRo2p9RMKwyP/Odx7H8ZpmdCO
         m1kk9hewXVBfQeyHUW8Fi2iUEGavXtSMl3hoyKaUpYpYxmMyExkttIoFZ5UfWFvNhp
         4z03K6l4LkSZtsCshIKZO348Mr4qVLJX/eGLNe+5KwMeYnHfYUu7q+IMG8W1ud5XQV
         fcd69MGdQPOWU0EyQu/VrSqxeO6vzbVhY2wielcg9fKQXClkl3c7ro+q8VcSyuLJAb
         u8btV0t5zbVBA==
Date:   Thu, 18 Feb 2021 10:49:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: lockdep recursive locking warning on for-next
Message-ID: <20210218184926.GN7190@magnolia>
References: <20210218181450.GA705507@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218181450.GA705507@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 01:14:50PM -0500, Brian Foster wrote:
> Hi Darrick,
> 
> I'm seeing the warning below via xfs/167 on a test machine. It looks
> like it's just complaining about nested freeze protection between the
> scan invocation and an underlying transaction allocation for an inode
> eofblocks trim. I suppose we could either refactor xfs_trans_alloc() to
> drop and reacquire freeze protection around the scan, or alternatively
> call __sb_writers_release() and __sb_writers_acquire() around the scan
> to retain freeze protection and quiet lockdep. Hm?

Erk, isn't that a potential log grant livelock too?

Fill up the filesystem with real data and cow blocks until it's full,
then spawn exactly enough file writer threads to eat up all the log
reservation, then each _reserve() fails, so every thread starts a scan
and tries to allocate /another/ transaction ... but there's no space
left in the log, so those scans just block indefinitely.

So... I think the solution here is to go back to a previous version of
what that patchset did, where we'd drop the whole transaction, run the
scan, and jump back to the top of the function to get a fresh
transaction.

> BTW, the stack report also had me wondering whether we had or need any
> nesting protection in these new scan invocations. For example, if we
> have an fs with a bunch of tagged inodes and concurrent allocation
> activity, would anything prevent an in-scan transaction allocation from
> jumping back into the scan code to complete outstanding work? It looks
> like that might not be possible right now because neither scan reserves
> blocks, but they do both use transactions and that's quite a subtle
> balance..

Yes, that's a subtlety that screams for better documentation.

--D

> 
> Brian
> 
> [  316.631387] ============================================
> [  316.636697] WARNING: possible recursive locking detected
> [  316.642010] 5.11.0-rc4 #35 Tainted: G        W I      
> [  316.647148] --------------------------------------------
> [  316.652462] fsstress/17733 is trying to acquire lock:
> [  316.657515] ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_free_eofblocks+0x104/0x1d0 [xfs]
> [  316.666405] 
>                but task is already holding lock:
> [  316.672239] ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_trans_alloc_inode+0x5f/0x160 [xfs]
> [  316.681269] 
> ...
>                stack backtrace:
> [  316.774735] CPU: 38 PID: 17733 Comm: fsstress Tainted: G        W I       5.11.0-rc4 #35
> [  316.782819] Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
> [  316.790386] Call Trace:
> [  316.792844]  dump_stack+0x8b/0xb0
> [  316.796168]  __lock_acquire.cold+0x159/0x2ab
> [  316.800441]  lock_acquire+0x116/0x370
> [  316.804106]  ? xfs_free_eofblocks+0x104/0x1d0 [xfs]
> [  316.809045]  ? rcu_read_lock_sched_held+0x3f/0x80
> [  316.813750]  ? kmem_cache_alloc+0x287/0x2b0
> [  316.817937]  xfs_trans_alloc+0x1ad/0x310 [xfs]
> [  316.822445]  ? xfs_free_eofblocks+0x104/0x1d0 [xfs]
> [  316.827376]  xfs_free_eofblocks+0x104/0x1d0 [xfs]
> [  316.832134]  xfs_blockgc_scan_inode+0x24/0x60 [xfs]
> [  316.837074]  xfs_inode_walk_ag+0x202/0x4b0 [xfs]
> [  316.841754]  ? xfs_inode_free_cowblocks+0xf0/0xf0 [xfs]
> [  316.847040]  ? __lock_acquire+0x382/0x1e10
> [  316.851142]  ? xfs_inode_free_cowblocks+0xf0/0xf0 [xfs]
> [  316.856425]  xfs_inode_walk+0x66/0xc0 [xfs]
> [  316.860670]  xfs_trans_alloc+0x160/0x310 [xfs]
> [  316.865179]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
> [  316.870119]  xfs_alloc_file_space+0x105/0x300 [xfs]
> [  316.875048]  ? down_write_nested+0x30/0x70
> [  316.879148]  xfs_file_fallocate+0x270/0x460 [xfs]
> [  316.883913]  ? lock_acquire+0x116/0x370
> [  316.887752]  ? __x64_sys_fallocate+0x3e/0x70
> [  316.892026]  ? selinux_file_permission+0x105/0x140
> [  316.896820]  vfs_fallocate+0x14d/0x3d0
> [  316.900572]  __x64_sys_fallocate+0x3e/0x70
> [  316.904669]  do_syscall_64+0x33/0x40
> [  316.908250]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> ...
> 
