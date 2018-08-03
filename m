Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbeHCQxP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Aug 2018 12:53:15 -0400
Date: Fri, 3 Aug 2018 09:56:32 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs: substitute spaces with tabs
Message-ID: <20180803145632.GB20657@redhat.com>
References: <1533140611-23467-1-git-send-email-thomas.bianchi8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1533140611-23467-1-git-send-email-thomas.bianchi8@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thomas Bianchi <thomas.bianchi8@gmail.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-kernel@vger.kernel.org

On Wed, Aug 01, 2018 at 06:22:25PM +0200, Thomas Bianchi wrote:
> Inside xfs_attr_shortform_list removes spaces at the beginnig of the line
> and replaces with tabs.
> Issue found by checkpatch.
> 
> ERROR: code indent should use tabs where possible
> 
> Signed-off-by: Thomas Bianchi <thomas.bianchi8@gmail.com>
> ---
looks fine.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

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
