Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751456AbdK3NrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 08:47:12 -0500
Date: Thu, 30 Nov 2017 08:47:11 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: scrub inode mode properly
Message-ID: <20171130134710.GC3516@bfoster.bfoster>
References: <151189079681.14861.10709810493861130558.stgit@magnolia>
 <151189080917.14861.14134834648175888048.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151189080917.14861.14134834648175888048.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 09:40:09AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since we've used up all the bits in i_mode, the existing mode check
> doesn't actually do anything useful.  However, we've not used all the
> bit values in the format portion of i_mode, so we /do/ need to test
> that for bad values.
> 
> Fixes: 80e4e1268 ("xfs: scrub inodes")
> Fixes-coverity-id: 1423992
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/inode.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 637b7a8..f120fb2 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -318,8 +318,20 @@ xfs_scrub_dinode(
>  
>  	/* di_mode */
>  	mode = be16_to_cpu(dip->di_mode);
> -	if (mode & ~(S_IALLUGO | S_IFMT))
> +	switch (mode & S_IFMT) {
> +	case S_IFLNK:
> +	case S_IFREG:
> +	case S_IFDIR:
> +	case S_IFCHR:
> +	case S_IFBLK:
> +	case S_IFIFO:
> +	case S_IFSOCK:
> +		/* mode is recognized */
> +		break;
> +	default:
>  		xfs_scrub_ino_set_corrupt(sc, ino, bp);
> +		break;
> +	}
>  
>  	/* v1/v2 fields */
>  	switch (dip->di_version) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
