Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbfDQPoO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Apr 2019 11:44:14 -0400
Date: Wed, 17 Apr 2019 11:44:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/9] xfs: Hold inode locks in xfs_ialloc
Message-ID: <20190417154411.GE16377@bfoster>
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412225036.22939-3-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 12, 2019 at 03:50:29PM -0700, Allison Henderson wrote:
> Modify xfs_ialloc to hold locks after return.  Caller
> will be responsible for manual unlock.  We will need
> this later to hold locks across parent pointer operations
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---

Is this needed for this series, or can it be deferred to the parent
pointer stuff? (If it is needed now, it might be a good idea to update
the commit log to explain why.)

Brian

>  fs/xfs/xfs_inode.c   | 6 +++++-
>  fs/xfs/xfs_qm.c      | 1 +
>  fs/xfs/xfs_symlink.c | 3 +++
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f643a92..30a3130 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -744,6 +744,8 @@ xfs_lookup(
>   * to attach to or associate with (i.e. pip == NULL) because they
>   * are not linked into the directory structure - they are attached
>   * directly to the superblock - and so have no parent.
> + *
> + * Caller is responsible for unlocking the inode manually upon return
>   */
>  static int
>  xfs_ialloc(
> @@ -942,7 +944,7 @@ xfs_ialloc(
>  	/*
>  	 * Log the new values stuffed into the inode.
>  	 */
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
>  	xfs_trans_log_inode(tp, ip, flags);
>  
>  	/* now that we have an i_mode we can setup the inode structure */
> @@ -1264,6 +1266,7 @@ xfs_create(
>  	xfs_qm_dqrele(pdqp);
>  
>  	*ipp = ip;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return 0;
>  
>   out_trans_cancel:
> @@ -1359,6 +1362,7 @@ xfs_create_tmpfile(
>  	xfs_qm_dqrele(pdqp);
>  
>  	*ipp = ip;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return 0;
>  
>   out_trans_cancel:
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 52ed790..69006e5 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -820,6 +820,7 @@ xfs_qm_qino_alloc(
>  	}
>  	if (need_alloc)
>  		xfs_finish_inode_setup(*ip);
> +	xfs_iunlock(*ip, XFS_ILOCK_EXCL);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index b2c1177..13d31fe 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -353,6 +353,7 @@ xfs_symlink(
>  	xfs_qm_dqrele(pdqp);
>  
>  	*ipp = ip;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return 0;
>  
>  out_trans_cancel:
> @@ -374,6 +375,8 @@ xfs_symlink(
>  
>  	if (unlock_dp_on_error)
>  		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +	if (ip)
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
>  }
>  
> -- 
> 2.7.4
> 
