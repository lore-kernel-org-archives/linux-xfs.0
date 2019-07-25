Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34056 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfGYSRA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jul 2019 14:17:00 -0400
Subject: Re: [PATCH v2] xfs: fix stack contents leakage in the v1 inumber
 ioctls
References: <20190725175346.GF1561054@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <49a64f95-7bf1-7434-8fdb-a5463b995149@sandeen.net>
Date: Thu, 25 Jul 2019 13:16:58 -0500
MIME-Version: 1.0
In-Reply-To: <20190725175346.GF1561054@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Eric Sandeen <sandeen@redhat.com>

On 7/25/19 12:53 PM, Darrick J. Wong wrote:
> Explicitly initialize the onstack structures to zero so we don't leak
> kernel memory into userspace when converting the in-core inumbers
> structure to the v1 inogrp ioctl structure.  Add a comment about why we
> have to use memset to ensure that the padding holes in the structures
> are set to zero.
> 
> Fixes: 5f19c7fc6873351 ("xfs: introduce v5 inode group structure")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> v2: add comments, use memset this time
> ---
>  fs/xfs/xfs_itable.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 30fe17d25518..39374c680c49 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -283,6 +283,7 @@ xfs_bulkstat_to_bstat(
>  	struct xfs_bstat		*bs1,
>  	const struct xfs_bulkstat	*bstat)
>  {
> +	/* memset is needed here because of padding holes in the structure. */
>  	memset(bs1, 0, sizeof(struct xfs_bstat));
>  	bs1->bs_ino = bstat->bs_ino;
>  	bs1->bs_mode = bstat->bs_mode;
> @@ -399,6 +400,8 @@ xfs_inumbers_to_inogrp(
>  	struct xfs_inogrp		*ig1,
>  	const struct xfs_inumbers	*ig)
>  {
> +	/* memset is needed here because of padding holes in the structure. */
> +	memset(ig1, 0, sizeof(struct xfs_inogrp));
>  	ig1->xi_startino = ig->xi_startino;
>  	ig1->xi_alloccount = ig->xi_alloccount;
>  	ig1->xi_allocmask = ig->xi_allocmask;
> 
