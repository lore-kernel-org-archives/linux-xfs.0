Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18272 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754703AbdJPSgH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 14:36:07 -0400
Date: Mon, 16 Oct 2017 11:36:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: add xfs_spaceman to .gitignore
Message-ID: <20171016183601.GA4703@magnolia>
References: <20171015032546.4503-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171015032546.4503-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 15, 2017 at 11:25:46AM +0800, Zorro Lang wrote:
> The new binary xfs_spaceman isn't in .gitignore, so ignore it in
> this patch.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> Hi,
> 
> If you don't think it's worth fixing it in a single patch, feel free
> to fix it in next xfs_spaceman related patchset :)
> 
> Thanks,
> Zorro
> 
>  .gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/.gitignore b/.gitignore
> index 913b371f..e839e2a1 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -67,6 +67,7 @@ cscope.*
>  /quota/xfs_quota
>  /repair/xfs_repair
>  /rtcp/xfs_rtcp
> +/spaceman/xfs_spaceman
>  
>  # generated crc files
>  /libxfs/crc32selftest
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
