Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3439C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiF2S2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiF2S2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:28:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54131AD96
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E5C9B825FD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D384C34114;
        Wed, 29 Jun 2022 18:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656527327;
        bh=tyfYyPKRCwH0f6LmbQUs/SzInb9KXM8rU9j8AC3EnYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FMB1NiiVBWe+iE0reQ4ShRxINOAx0EjewZFQiG9olwhr+o++eD3yAUD4VBOx2Et/e
         Nsl/jxNvrXU1uv3WJXwIcZl7oQusxjYy5riIHWvqId9/+/SB8B//EKQEBwPcUA5yQx
         TJ58yVgnh/40zSK78cws9i6UuESEdcYsfMsAmczYpVEb0bA55lnH7CmOktSJ+PIOsI
         Xke1xWwv+ixM6p//CyqjPbWPvsmoN9/ROmQSS50117yphqcztouwTHbtiFZgDaEa5O
         +Wpws6MW6xrRwxDbEyYrpXmqA3yKi70aCIO+VBZrTVQHRREplrVVvY/1bwXBdTacIf
         zAsO1M2p4/xYQ==
Date:   Wed, 29 Jun 2022 11:28:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 02/17] xfs: Hold inode locks in xfs_ialloc
Message-ID: <YryZ3o8HbuZvjR6P@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-3-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:45AM -0700, Allison Henderson wrote:
> Modify xfs_ialloc to hold locks after return.  Caller will be
> responsible for manual unlock.  We will need this later to hold locks
> across parent pointer operations
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks pretty straightforward,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c   | 6 +++++-
>  fs/xfs/xfs_qm.c      | 4 +++-
>  fs/xfs/xfs_symlink.c | 3 +++
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 52d6f2c7d58b..23b93403a330 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -787,6 +787,8 @@ xfs_inode_inherit_flags2(
>  /*
>   * Initialise a newly allocated inode and return the in-core inode to the
>   * caller locked exclusively.
> + *
> + * Caller is responsible for unlocking the inode manually upon return
>   */
>  int
>  xfs_init_new_inode(
> @@ -913,7 +915,7 @@ xfs_init_new_inode(
>  	/*
>  	 * Log the new values stuffed into the inode.
>  	 */
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
>  	xfs_trans_log_inode(tp, ip, flags);
>  
>  	/* now that we have an i_mode we can setup the inode structure */
> @@ -1090,6 +1092,7 @@ xfs_create(
>  	xfs_qm_dqrele(pdqp);
>  
>  	*ipp = ip;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return 0;
>  
>   out_trans_cancel:
> @@ -1186,6 +1189,7 @@ xfs_create_tmpfile(
>  	xfs_qm_dqrele(pdqp);
>  
>  	*ipp = ip;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return 0;
>  
>   out_trans_cancel:
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index abf08bbf34a9..fa8321f74c13 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -817,8 +817,10 @@ xfs_qm_qino_alloc(
>  		ASSERT(xfs_is_shutdown(mp));
>  		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
>  	}
> -	if (need_alloc)
> +	if (need_alloc) {
>  		xfs_finish_inode_setup(*ipp);
> +		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
> +	}
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 4145ba872547..18f71fc90dd0 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -337,6 +337,7 @@ xfs_symlink(
>  	xfs_qm_dqrele(pdqp);
>  
>  	*ipp = ip;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return 0;
>  
>  out_trans_cancel:
> @@ -358,6 +359,8 @@ xfs_symlink(
>  
>  	if (unlock_dp_on_error)
>  		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +	if (ip)
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  }
>  
> -- 
> 2.25.1
> 
