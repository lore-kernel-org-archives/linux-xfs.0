Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8393CC77B7E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 14:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbjFAOyy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 10:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbjFAOyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 10:54:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7310B123
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 07:54:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C4B36462C
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 14:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5BFC433EF;
        Thu,  1 Jun 2023 14:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685631287;
        bh=97goLPjPaI2F40S4OZHEywmBHBPohZlZ/j0TiCaEwrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jcge2uN1oMivrwcGfQSzO3wDowDmdoxQVn5RpLv4Y0WnntLX6c7VwZAWYIj9hgBWN
         1HmdeLxGpP9APuxXp9WhSD6ezbuU9zd5RezK8Yk2K13/MVjvOvNb3oiAFzpUZ69MG3
         zt3mCWroAa4oYkaG9EThVCwbXMcdn96gyY313l2dWCmlGLnxzOlF+dPWIq7cIaBU+T
         HwzMN2TTAduZUUdWySN961BtfsKUW19qi+YVBgoyw+QP6DmaGzNF4miMgrEHGVCjUr
         7zDg8a8V0UbCd4DJFKpO/Rg7vgaYys/tCVPxCF5hY9w0R/VQba6TgDe7UkHfFWAFCw
         7CCiYKCtSJNfg==
Date:   Thu, 1 Jun 2023 07:54:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix double xfs_perag_rele() in
 xfs_filestream_pick_ag()
Message-ID: <20230601145446.GF16865@frogsfrogsfrogs>
References: <20230529025950.2972685-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529025950.2972685-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 29, 2023 at 12:59:50PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_bmap_longest_free_extent() can return an error when accessing
> the AGF fails. In this case, the behaviour of
> xfs_filestream_pick_ag() is conditional on the error. We may
> continue the loop, or break out of it. The error handling after the
> loop cleans up the perag reference held when the break occurs. If we
> continue, the next loop iteration handles cleaning up the perag
> reference.
> 
> EIther way, we don't need to release the active perag reference when
> xfs_bmap_longest_free_extent() fails. Doing so means we do a double
> decrement on the active reference count, and this causes tha active
> reference count to fall to zero. At this point, new active
> references will fail.
> 
> This leads to unmount hanging because it tries to grab active
> references to that perag, only for it to fail. This happens inside a
> loop that retries until a inode tree radix tree tag is cleared,
> which cannot happen because we can't get an active reference to the
> perag.

Wouldn't it be nice if C had^W^Wthe kernel coding rules allowed
iterators that managed these active refs for us...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> The unmount livelocks in this path:
> 
>   xfs_reclaim_inodes+0x80/0xc0
>   xfs_unmount_flush_inodes+0x5b/0x70
>   xfs_unmountfs+0x5b/0x1a0
>   xfs_fs_put_super+0x49/0x110
>   generic_shutdown_super+0x7c/0x1a0
>   kill_block_super+0x27/0x50
>   deactivate_locked_super+0x30/0x90
>   deactivate_super+0x3c/0x50
>   cleanup_mnt+0xc2/0x160
>   __cleanup_mnt+0x12/0x20
>   task_work_run+0x5e/0xa0
>   exit_to_user_mode_prepare+0x1bc/0x1c0
>   syscall_exit_to_user_mode+0x16/0x40
>   do_syscall_64+0x40/0x80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> Fixes: eb70aa2d8ed9 ("xfs: use for_each_perag_wrap in xfs_filestream_pick_ag")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_filestream.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 22c13933c8f8..2fc98d313708 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -78,7 +78,6 @@ xfs_filestream_pick_ag(
>  		*longest = 0;
>  		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
>  		if (err) {
> -			xfs_perag_rele(pag);
>  			if (err != -EAGAIN)
>  				break;
>  			/* Couldn't lock the AGF, skip this AG. */
> -- 
> 2.40.1
> 
