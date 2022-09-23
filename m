Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6116BC04A95
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 19:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiIWTEw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 15:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiIWTEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 15:04:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA54C15FFA
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 12:04:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A43E461251
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 19:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F77C433D6;
        Fri, 23 Sep 2022 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663959877;
        bh=6WoaECrHgc2b/R2BytfUofXFIXHWj8oysvtmP726YyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gWc/BywJvmXifQ7DR/e0HJpOSFsQq9VRdJp0wdgj2Yu1mui3iXqWrputBrNxAQHv+
         lsbur4de8bvAWIKp7IusnTLUfgG2fZPc7QkTKoibhuAuh2XA35DKWtjolGgkbkWASA
         EB4FiwpWP+iZF3646u5P4IUzvKwKkklvA9Ewd888gxCXsPLINesSml4EQpIgWHu5yj
         YBcQLuMQvt2QCsFKgnsXYyIPzQE8oWVhQlRzW6FbeflS1dzx0CR1XyRlQwK2bHPEnb
         MP6tG6EWFW4qEFfBDdcZrBq8tDRZFPqujPvOAWyz/IYFiLnpfAvdvX3T7A+Bg43Y7j
         N1IX0T2q/1OWw==
Date:   Fri, 23 Sep 2022 12:04:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 04/26] xfs: Hold inode locks in xfs_trans_alloc_dir
Message-ID: <Yy4DRQ8MDJBmuntO@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-5-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:36PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
> responsible for manual unlock.  We will need this later to hold locks
> across parent pointer operations
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 14 ++++++++++++--
>  fs/xfs/xfs_trans.c |  6 ++++--
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f21f625b428e..9a3174a8f895 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1277,10 +1277,15 @@ xfs_link(
>  	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
>  		xfs_trans_set_sync(tp);
>  
> -	return xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp);
> +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> +	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> +	return error;
>  
>   error_return:
>  	xfs_trans_cancel(tp);
> +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> +	xfs_iunlock(sip, XFS_ILOCK_EXCL);
>   std_return:
>  	if (error == -ENOSPC && nospace_error)
>  		error = nospace_error;
> @@ -2516,15 +2521,20 @@ xfs_remove(
>  
>  	error = xfs_trans_commit(tp);
>  	if (error)
> -		goto std_return;
> +		goto out_unlock;
>  
>  	if (is_dir && xfs_inode_is_filestream(ip))
>  		xfs_filestream_deassociate(ip);
>  
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  	return 0;
>  
>   out_trans_cancel:
>  	xfs_trans_cancel(tp);
> + out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>   std_return:
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 7bd16fbff534..ac98ff416e54 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1356,6 +1356,8 @@ xfs_trans_alloc_ichange(
>   * The caller must ensure that the on-disk dquots attached to this inode have
>   * already been allocated and initialized.  The ILOCKs will be dropped when the
>   * transaction is committed or cancelled.
> + *
> + * Caller is responsible for unlocking the inodes manually upon return
>   */
>  int
>  xfs_trans_alloc_dir(
> @@ -1386,8 +1388,8 @@ xfs_trans_alloc_dir(
>  
>  	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
>  
> -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, dp, 0);
> +	xfs_trans_ijoin(tp, ip, 0);
>  
>  	error = xfs_qm_dqattach_locked(dp, false);
>  	if (error) {
> -- 
> 2.25.1
> 
