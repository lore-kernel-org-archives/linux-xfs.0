Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20166 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751217AbdJSToH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 15:44:07 -0400
Date: Thu, 19 Oct 2017 12:43:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/17] xfs_bmap_add_attrfork(): re-add error handling
 from set_attrforkoff() call
Message-ID: <20171019194357.GJ4755@magnolia>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <1508367333-3237-16-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508367333-3237-16-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Wed, Oct 18, 2017 at 03:55:31PM -0700, Allison Henderson wrote:
> From: Brian Foster <bfoster@redhat.com>
> 
> - fix for "xfs: parent pointer attribute creation"
> 
> [achender: rebased]

Please fold this into that patch.

--D

> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7ee98be..a631fe1 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1149,7 +1149,9 @@ xfs_bmap_add_attrfork(
>  	xfs_trans_ijoin(tp, ip, 0);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> -	xfs_bmap_set_attrforkoff(ip, size, &version);
> +	error = xfs_bmap_set_attrforkoff(ip, size, &version);
> +	if (error)
> +		goto trans_cancel;
>  
>  	ASSERT(ip->i_afp == NULL);
>  	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
