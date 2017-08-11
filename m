Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41813 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752728AbdHKLTo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 07:19:44 -0400
Date: Fri, 11 Aug 2017 04:19:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: don't leak quotacheck dquots when cow recovery
 fails
Message-ID: <20170811111943.GB27964@infradead.org>
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

The unmount path calls this much later, e.g. the xfs_rtunmount_inodes
call follows ifirst, then we release the root inode, etc.

I'd suggest we try to follow that order as much as possible.
