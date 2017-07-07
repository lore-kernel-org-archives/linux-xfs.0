Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26169 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752490AbdGGMCL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jul 2017 08:02:11 -0400
Date: Fri, 7 Jul 2017 08:01:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] mkfs: set agblklog when we're verifying minimum log size
Message-ID: <20170707120139.GC61756@bfoster.bfoster>
References: <20170707033138.GC4103@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170707033138.GC4103@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Jul 06, 2017 at 08:31:38PM -0700, Darrick J. Wong wrote:
> In e5cc9d560a ("mkfs: set agsize prior to calculating minimum log
> size"), we set the ag size in the superblock structure so that we can
> calculate the maximum btree height correctly.  The btree heights are
> used to calculate transaction reservation sizes; these sizes are used to
> compute the minimum log length; and the minimum log length is checked by
> the kernel.
> 
> Unfortunately, I didn't realize that some of the btree sizing functions
> also depend on the agblklog (log2 of the ag size), so we've been
> underestimating the minimum log length allowable, which results in mkfs
> formatting filesystems that the kernel refuses to mount.
> 
> This can be trivially reproduced by formatting a small (~800M) volume
> with rmap and reflink turned on.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  mkfs/maxtrres.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
> index fba7818..69ec67a 100644
> --- a/mkfs/maxtrres.c
> +++ b/mkfs/maxtrres.c
> @@ -54,6 +54,7 @@ max_trans_res(
>  	sbp->sb_blocklog = blocklog;
>  	sbp->sb_blocksize = 1 << blocklog;
>  	sbp->sb_agblocks = agsize;
> +	sbp->sb_agblklog = (uint8_t)libxfs_log2_roundup((unsigned int)agsize);
>  	sbp->sb_inodelog = inodelog;
>  	sbp->sb_inopblog = blocklog - inodelog;
>  	sbp->sb_inodesize = 1 << inodelog;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
