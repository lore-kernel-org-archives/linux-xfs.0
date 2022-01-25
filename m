Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED16DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 21:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbiAYVhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 16:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiAYVhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jan 2022 16:37:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB55EC06173B;
        Tue, 25 Jan 2022 13:37:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3694A617B7;
        Tue, 25 Jan 2022 21:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBAEC340E0;
        Tue, 25 Jan 2022 21:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643146630;
        bh=h81BZXvPIOlmJJsgYNlhiu/ww3iwFWXAH+fepaPHzx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XDNv0B/BAm+p6XCB3ULkVvDn2Bo5l/TBuw0gfOc5YwfbJwrX09VDKtJGCJnQwyZTX
         nJTV5XbRBubiILxIbjPKDbw1rbpogHChKAlfw9E9QJs48jJhkf1aNWe39by8GWAbw9
         Yj2R7xw7pyitv4KubiGDTPCxrPoNXAleKZNnUzO+PluHFc/LOgQMtSbKk2ZIa+unmm
         XU1MdZIjtvMe50CBdNc1Cc7050uc+/fRwjAt4gCFI/x0wJLw6qPw+bv7SDOPwPwiPN
         1nRSJofaypJgjC+VM7eEhcyHlM+Jbb91EBnH4OQXvyKzp5UFIIHOLqcJgHkWGU8Tdw
         dd/hj1ihIvxzQ==
Date:   Tue, 25 Jan 2022 13:37:09 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] task_work: export task_work_add()
Message-ID: <20220125213709.GA2404843@magnolia>
References: <20220121114006.3633-1-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121114006.3633-1-penguin-kernel@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 08:40:02PM +0900, Tetsuo Handa wrote:
> Commit 322c4293ecc58110 ("loop: make autoclear operation asynchronous")
> silenced a circular locking dependency warning by moving autoclear
> operation to WQ context.
> 
> Then, it was reported that WQ context is too late to run autoclear
> operation; some userspace programs (e.g. xfstest) assume that the autoclear
> operation already completed by the moment close() returns to user mode
> so that they can immediately call umount() of a partition containing a
> backing file which the autoclear operation should have closed.
> 
> Then, Jan Kara found that fundamental problem is that waiting for I/O
> completion (from blk_mq_freeze_queue() or flush_workqueue()) with
> disk->open_mutex held has possibility of deadlock.
> 
> Then, I found that since disk->open_mutex => lo->lo_mutex dependency is
> recorded by lo_open() and lo_release(), and blk_mq_freeze_queue() by e.g.
> loop_set_status() waits for I/O completion with lo->lo_mutex held, from
> locking dependency chain perspective we need to avoid holding lo->lo_mutex
>  from lo_open() and lo_release(). And we can avoid holding lo->lo_mutex
>  from lo_open(), for we can instead use a spinlock dedicated for
> Lo_deleting check.
> 
> But we cannot avoid holding lo->lo_mutex from lo_release(), for WQ context
> was too late to run autoclear operation. We need to make whole lo_release()
> operation start without disk->open_mutex and complete before returning to
> user mode. One of approaches that can meet such requirement is to use the
> task_work context. Thus, export task_work_add() for the loop driver.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

5.17-rc1 came out and I saw regressions across the board when xfs/049
and xfs/073 ran.

xfs/049 formats XFS on a block device, mounts it, creates a sparse file
inside the XFS fs, formats the sparse file, mounts that (via automatic
loop device), does some work, and then unmounts both the sparse file
filesystem and the outer XFS filesystem.

The first unmount no longer waited for the loop device to release
asynchronously so the unmount of the outer fs fails because it's still
in use.

So this series fixes xfs/049, but xfs/073 is still broken.  xfs/073
creates a sparse file containing an XFS filesystem and then does this in
rapid succession:

mount -o loop <mount options that guarantee mount failure>
mount -o loop <mount options that should work>

Whereas with 5.16 this worked fine,

 [U] try mount 1
 loop0: detected capacity change from 0 to 83968
 XFS (loop0): Filesystem has duplicate UUID 924e8033-a130-4f9c-a11f-52f892c268e9 - can't mount
 [U] try mount 2
 loop0: detected capacity change from 0 to 83968
 XFS (loop0): Mounting V5 Filesystem
 XFS (loop0): resetting quota flags
 XFS (loop0): Ending clean mount

in 5.17-rc1 it fails like this:

 [U] try mount 1
 loop0: detected capacity change from 0 to 83968
 XFS (loop0): Filesystem has duplicate UUID 0b0afdac-5c9c-4d94-9b8d-fe85a2eb1143 - can't mount
 [U] try mount 2
 I/O error, dev loop0, sector 0 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 0
 XFS (loop0): SB validate failed with error -5.
 [U] fail mount 2

I guess this means that mount can grab the loop device after the backing
file has been released but before a new one has been plumbed in?  Or,
seeing the lack of "detected capacity change" for mount 2, maybe the
backing file never gets added?

--D

> ---
>  kernel/task_work.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index 1698fbe6f0e1..2a1644189182 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -60,6 +60,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(task_work_add);
>  
>  /**
>   * task_work_cancel_match - cancel a pending work added by task_work_add()
> -- 
> 2.32.0
> 
