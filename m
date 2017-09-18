Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49289 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752898AbdIRSho (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 14:37:44 -0400
Date: Mon, 18 Sep 2017 11:37:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/14] fs/xfs: Use %pS printk format for direct addresses
Message-ID: <20170918183732.GJ6540@magnolia>
References: <1504729681-3504-1-git-send-email-deller@gmx.de>
 <1504729681-3504-11-git-send-email-deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504729681-3504-11-git-send-email-deller@gmx.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org

On Wed, Sep 06, 2017 at 10:27:57PM +0200, Helge Deller wrote:
> Use the %pS instead of the %pF printk format specifier for printing symbols
> from direct addresses. This is needed for the ia64, ppc64 and parisc64
> architectures.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_error.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 2f4feb9..028e50a 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -344,7 +344,7 @@ xfs_verifier_error(
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  
> -	xfs_alert(mp, "Metadata %s detected at %pF, %s block 0x%llx",
> +	xfs_alert(mp, "Metadata %s detected at %pS, %s block 0x%llx",
>  		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
>  		  __return_address, bp->b_ops->name, bp->b_bn);
>  
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
