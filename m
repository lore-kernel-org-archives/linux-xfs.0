Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbfADSjM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Jan 2019 13:39:12 -0500
Date: Fri, 4 Jan 2019 13:39:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/8] xfs: abort xattr scrub if fatal signals are pending
Message-ID: <20190104183909.GI16751@bfoster>
References: <154630850739.14372.14000129432637481206.stgit@magnolia>
 <154630855701.14372.16042422623260751227.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154630855701.14372.16042422623260751227.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 31, 2018 at 06:09:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The extended attribute scrubber should abort the "read all attrs" loop
> if there's a fatal signal pending on the process.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/attr.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 81d5e90547a1..9960bc5b5d76 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -82,6 +82,11 @@ xchk_xattr_listent(
>  
>  	sx = container_of(context, struct xchk_xattr, context);
>  
> +	if (xchk_should_terminate(sx->sc, &error)) {
> +		context->seen_enough = 1;
> +		return;
> +	}
> +
>  	if (flags & XFS_ATTR_INCOMPLETE) {
>  		/* Incomplete attr key, just mark the inode for preening. */
>  		xchk_ino_set_preen(sx->sc, context->dp->i_ino);
> 
