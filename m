Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35806C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 23:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D267610C7
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 23:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhHYXKh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Aug 2021 19:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhHYXKh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Aug 2021 19:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9565860F44;
        Wed, 25 Aug 2021 23:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629932990;
        bh=IEl7vVX59Z8HM5R8VxLDlkmI+G6SO9NmgOFat20J5EU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F2cNGtPrkWCcv9BXypJPus8p1/MIfANjRmKtFai6KScYYMXZBPfwts4AnifDjK1NI
         0R4DMoc5lESZAXo7BnwLO1PjYnvjPOZx2X2zxqDZC97qBM+vmzttGlVixOvlliejwV
         vVlnSH7dJbjZG4SiAdqe0U4HC0ivhr1i0oIJ2MmPhI3MSYMkfjdhDAvS8FiUYP+08d
         6txPUJws22RoiaM40TCnWwWnLBevW+Pi8CMBB4cJMRv4ivYh9/UMqmkVYwXPsyo2qk
         ziZOXuQhw+cO112zErIuwC9vfY7LGpBLUX/xIv2twmIaUEe04K9BVNLplfbba/2y5q
         tp55qvPdiIVXw==
Date:   Wed, 25 Aug 2021 16:09:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix I_DONTCACHE
Message-ID: <20210825230950.GI12640@magnolia>
References: <20210824023208.392670-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824023208.392670-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 24, 2021 at 12:32:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Yup, the VFS hoist broke it, and nobody noticed. Bulkstat workloads
> make it clear that it doesn't work as it should.
> 
> Fixes: dae2f8ed7992 ("fs: Lift XFS_IDONTCACHE to the VFS layer")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Assuming the RFC test that I just sent out looks reasonable to you, I
think I have a sufficient understanding of what DONTCACHE is supposed to
do to say:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 3 ++-
>  fs/xfs/xfs_iops.c   | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a3fe4c5307d3..f2210d927481 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -84,8 +84,9 @@ xfs_inode_alloc(
>  		return NULL;
>  	}
>  
> -	/* VFS doesn't initialise i_mode! */
> +	/* VFS doesn't initialise i_mode or i_state! */
>  	VFS_I(ip)->i_mode = 0;
> +	VFS_I(ip)->i_state = 0;
>  
>  	XFS_STATS_INC(mp, vn_active);
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0ff0cca94092..a607d6aca5c4 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1344,7 +1344,7 @@ xfs_setup_inode(
>  	gfp_t			gfp_mask;
>  
>  	inode->i_ino = ip->i_ino;
> -	inode->i_state = I_NEW;
> +	inode->i_state |= I_NEW;
>  
>  	inode_sb_list_add(inode);
>  	/* make the inode look hashed for the writeback code */
> -- 
> 2.31.1
> 
