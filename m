Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932129AbeB0Nzn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Feb 2018 08:55:43 -0500
Date: Tue, 27 Feb 2018 08:55:42 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs: don't iunlock the quota ip when quota block
 allocation fails
Message-ID: <20180227135541.GB3479@bfoster.bfoster>
References: <151935118240.21654.10146641674018880885.stgit@magnolia>
 <151935118851.21654.14051188649580444275.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151935118851.21654.14051188649580444275.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 22, 2018 at 05:59:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_qm_dqalloc, we join the locked quota inode to the transaction we
> use to allocate blocks.  If the allocation or mapping fails, we're not
> allowed to unlock the inode because the transaction code is in charge of
> unlocking it for us.  Therefore, remove the iunlock call to avoid
> blowing asserts about unbalanced locking + mount hang.
> 
> Found by corrupting the AGF and allocating space in the filesystem
> (quotacheck) immediately after mount.  The upcoming agfl wrapping fixup
> test will trigger this scenario.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_dquot.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 43572f8..2410acc 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -394,8 +394,6 @@ xfs_qm_dqalloc(
>  error1:
>  	xfs_defer_cancel(&dfops);
>  error0:
> -	xfs_iunlock(quotip, XFS_ILOCK_EXCL);
> -
>  	return error;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
