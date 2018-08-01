Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37692 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbeHBBHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 21:07:36 -0400
Date: Wed, 1 Aug 2018 16:19:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: substitute spaces with tabs
Message-ID: <20180801231921.GM30972@magnolia>
References: <1533140611-23467-1-git-send-email-thomas.bianchi8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1533140611-23467-1-git-send-email-thomas.bianchi8@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Bianchi <thomas.bianchi8@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Aug 01, 2018 at 06:22:25PM +0200, Thomas Bianchi wrote:
> Inside xfs_attr_shortform_list removes spaces at the beginnig of the line
> and replaces with tabs.
> Issue found by checkpatch.
> 
> ERROR: code indent should use tabs where possible
> 
> Signed-off-by: Thomas Bianchi <thomas.bianchi8@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_attr_list.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index f9ca801..a580340 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -87,7 +87,7 @@
>  	 */
>  	if (context->bufsize == 0 ||
>  	    (XFS_ISRESET_CURSOR(cursor) &&
> -             (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
> +	     (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
>  		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
>  			context->put_listent(context,
>  					     sfe->flags,
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
