Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752389AbdHJOvf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Aug 2017 10:51:35 -0400
Date: Thu, 10 Aug 2017 10:51:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: don't leak quotacheck dquots when cow recovery
 fails
Message-ID: <20170810145134.GD3777@bfoster.bfoster>
References: <150234262066.13754.6534116056866237943.stgit@magnolia>
 <150234263808.13754.11636194057966589953.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150234263808.13754.11636194057966589953.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 09, 2017 at 10:23:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we fail a mount on account of cow recovery errors, it's possible that
> a previous quotacheck left some dquots in memory.  The bailout clause of
> xfs_mountfs forgets to purge these, and so we leak them.  Fix that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: unmount quotas, then free all the quota information
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_mount.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 8da5155..d50f4a7 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1057,6 +1057,8 @@ xfs_mountfs(
>  	xfs_fs_unreserve_ag_blocks(mp);
>   out_quota:
>  	xfs_qm_unmount_quotas(mp);
> +	/* Clean out dquots that might be in memory after quotacheck. */
> +	xfs_qm_unmount(mp);
>   out_rtunmount:
>  	xfs_rtunmount_inodes(mp);
>   out_rele_rip:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
