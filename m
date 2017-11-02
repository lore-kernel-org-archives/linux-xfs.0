Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932497AbdKBT5l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 15:57:41 -0400
Date: Thu, 2 Nov 2017 15:57:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: scrub: avoid uninitialized return code
Message-ID: <20171102195739.GK16645@bfoster.bfoster>
References: <20171102195306.GA4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102195306.GA4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org

On Thu, Nov 02, 2017 at 12:53:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The newly added xfs_scrub_da_btree_block() function has one code path
> that returns the 'error' variable without initializing it first, as
> shown by this compiler warning:
> 
> fs/xfs/scrub/dabtree.c: In function 'xfs_scrub_da_btree_block':
> fs/xfs/scrub/dabtree.c:462:9: error: 'error' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> Return zero since the caller will exit the scrub code if we don't produce a
> buffer pointer.
> 
> Fixes: 7c4a07a424c1 ("xfs: scrub directory/attribute btrees")
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/dabtree.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index c21c528..4c9839c 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -336,7 +336,7 @@ xfs_scrub_da_btree_block(
>  	xfs_ino_t			owner;
>  	int				*pmaxrecs;
>  	struct xfs_da3_icnode_hdr	nodehdr;
> -	int				error;
> +	int				error = 0;
>  
>  	blk = &ds->state->path.blk[level];
>  	ds->state->path.active = level + 1;
