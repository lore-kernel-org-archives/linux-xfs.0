Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5762 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726919AbeJFJy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 05:54:56 -0400
Date: Sat, 6 Oct 2018 12:53:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 05/28] xfs: Hold inode locks in xfs_ialloc
Message-ID: <20181006025320.GC17046@dastard>
References: <1537956907-10244-1-git-send-email-allison.henderson@oracle.com>
 <1537956907-10244-6-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537956907-10244-6-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 26, 2018 at 03:14:44AM -0700, Allison Henderson wrote:
> Modify xfs_ialloc to hold locks after return.  Caller
> will be responsible for manual unlock.  We will need
> this later to hold locks across parent pointer operations
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c   | 6 +++++-
>  fs/xfs/xfs_qm.c      | 1 +
>  fs/xfs/xfs_symlink.c | 3 +++
>  3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d957a46..1ef9d03 100644
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

It looks like the error paths that get run after a successful call
to xfs_dir_ialloc() don't unlock the inode correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
