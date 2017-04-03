Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18457 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751812AbdDCTnE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 15:43:04 -0400
Date: Mon, 3 Apr 2017 12:42:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: fix kernel memory exposure problems
Message-ID: <20170403194233.GR4864@birch.djwong.org>
References: <20170403173430.GL4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403173430.GL4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Mon, Apr 03, 2017 at 10:34:30AM -0700, Darrick J. Wong wrote:
> Fix a memory exposure problems in inumbers where we allocate an array of
> structures with holes, fail to zero the holes, then blindly copy the
> kernel memory contents (junk and all) into userspace.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

BTW, I intend to send this patch (though not the getbmap patch) for 4.11
since kernel memory exposure is usually treated as a security problem.

--D

> ---
> v2: split patches
> ---
>  fs/xfs/xfs_itable.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 2a6d9b1..26d67ce 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -583,7 +583,7 @@ xfs_inumbers(
>  		return error;
>  
>  	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
> -	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
> +	buffer = kmem_zalloc(bcount * sizeof(*buffer), KM_SLEEP);
>  	do {
>  		struct xfs_inobt_rec_incore	r;
>  		int				stat;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
