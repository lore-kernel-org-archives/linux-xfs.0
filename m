Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933648AbeAXOSb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jan 2018 09:18:31 -0500
Date: Wed, 24 Jan 2018 09:18:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/11] xfs: call xfs_qm_dqattach before performing
 reflink operations
Message-ID: <20180124141829.GC37554@bfoster.bfoster>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676029707.12349.10129452204983633139.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151676029707.12349.10129452204983633139.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 06:18:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Ensure that we've attached all the necessary dquots before performing
> reflink operations so that quota accounting is accurate.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index f5a43b2..82abff6 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1345,6 +1345,11 @@ xfs_reflink_remap_range(
>  	if (ret <= 0)
>  		goto out_unlock;
>  
> +	/* Attach dquots to dest inode before changing block map */
> +	ret = xfs_qm_dqattach(dest, 0);
> +	if (ret)
> +		goto out_unlock;
> +
>  	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
>  
>  	/*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
