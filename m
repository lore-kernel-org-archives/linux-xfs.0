Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76388C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 20:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiAUU2Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 15:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbiAUU2Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 15:28:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C767C06173B
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jan 2022 12:28:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2625661770
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jan 2022 20:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753D6C340E1;
        Fri, 21 Jan 2022 20:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642796903;
        bh=e/foO2kl05naoVxU145l4XJ3bmTHvOfmpRYgznny3WQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QltqDiN2FTykNhkdsNr3AbnEjjDnz+N7drq8TRfcawCUEd6vYp6cneQKFO2/0CQxz
         QZviPgsrgQ7hmDaiXnI6KvCOQA1tZNFU9cTHNiN7TIBjQ7m1tJyCr2cnamNY+UuROv
         mxh8T7IM99O86Fv2zoJlAxr8DRvYZO3Q4b/KD0XWo9hI/mXjo3Y9MNncFutqdXMUUr
         GxWAUaUoZs5ym58Lydgjy9gOtiBg/2OkAGz5mJgRF2HN5Gel32e+SUbJPLzQIQiJgW
         OqiSv3zpL9r6SO1qHIIwt7W0Y+1kX8yhNFCunmAfvsirhZjoUhwY03uJCiPbGWjh/x
         RfnOjQ+YDccKQ==
Date:   Fri, 21 Jan 2022 12:28:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     hongnanli <hongnan.li@linux.alibaba.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs/xfs: fix comments mentioning i_mutex
Message-ID: <20220121202822.GS13540@magnolia>
References: <20220121071505.31930-1-hongnan.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121071505.31930-1-hongnan.li@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 03:15:05PM +0800, hongnanli wrote:
> inode->i_mutex has been replaced with inode->i_rwsem long ago. Fix
> comments still mentioning i_mutex.
> 
> Signed-off-by: hongnanli <hongnan.li@linux.alibaba.com>
> ---
>  fs/xfs/xfs_acl.c   | 2 +-
>  fs/xfs/xfs_iomap.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 5c52ee869272..b02c83f8b8c4 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -22,7 +22,7 @@
>  
>  /*
>   * Locking scheme:
> - *  - all ACL updates are protected by inode->i_mutex, which is taken before
> + *  - all ACL updates are protected by inode->i_rwsem, which is taken before

This should use more general terminology here, such as "VFS inode lock"
or "IOLOCK" (XFS-specific shorthand), since the implementation may
change again in the future.

--D

>   *    calling into this file.
>   */
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e552ce541ec2..288a5cdcaa61 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1126,7 +1126,7 @@ xfs_buffered_write_iomap_end(
>  	 * Trim delalloc blocks if they were allocated by this write and we
>  	 * didn't manage to write the whole range.
>  	 *
> -	 * We don't need to care about racing delalloc as we hold i_mutex
> +	 * We don't need to care about racing delalloc as we hold i_rwsem
>  	 * across the reserve/allocate/unreserve calls. If there are delalloc
>  	 * blocks in the range, they are ours.
>  	 */
> -- 
> 2.19.1.6.gb485710b
> 
