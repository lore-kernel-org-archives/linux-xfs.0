Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32278 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752055AbdK1CVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Nov 2017 21:21:00 -0500
Date: Mon, 27 Nov 2017 18:20:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: calculate correct offset in xfs_scrub_quota_item
Message-ID: <20171128022056.GE21412@magnolia>
References: <44410519-fd0d-2527-c5cd-e23032eba299@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44410519-fd0d-2527-c5cd-e23032eba299@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 27, 2017 at 06:04:55PM -0600, Eric Sandeen wrote:
> It's only used for tracepoints so it's relatively harmless,
> but the offset is calculated incorrectly in xfs_scrub_quota_item.
> 
> qi_dqperchunk is the nr. of dquots per "chunk" which we have
> conveniently *cough* defined to always be 1 FSB.  Therefore 
> block_offset * qi_dqperchunk == first id in that chunk,
> and so offset = id / qi_dqperchunk
> 
> id * dqperchunk is ... meaningless.
> 
> Fixes-coverity-id: 1423965
> Fixes: c2fc338c ("xfs: scrub quota information")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok, will test
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> compile-tested only
> 
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 8e58ba8..2eac160 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -107,7 +107,7 @@
>  	unsigned long long		rcount;
>  	xfs_ino_t			fs_icount;
>  
> -	offset = id * qi->qi_dqperchunk;
> +	offset = id / qi->qi_dqperchunk;
>  
>  	/*
>  	 * We fed $id and DQNEXT into the xfs_qm_dqget call, which means
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
