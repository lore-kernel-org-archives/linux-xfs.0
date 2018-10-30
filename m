Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727732AbeJaCjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 22:39:09 -0400
Date: Tue, 30 Oct 2018 10:44:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/7] repair: Protect bad inode list with mutex
Message-ID: <20181030174434.GJ4135@magnolia>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030112043.6034-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 30, 2018 at 10:20:41PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To enable phase 6 parallelisation, we need to protect the bad inode
> list from concurrent modification and/or access. Wrap it with a
> mutex and clean up the nasty typedefs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/dir2.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index ba5763ed3d26..a73a675b97c8 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -20,40 +20,50 @@
>   * Known bad inode list.  These are seen when the leaf and node
>   * block linkages are incorrect.
>   */
> -typedef struct dir2_bad {
> +struct dir2_bad {
>  	xfs_ino_t	ino;
>  	struct dir2_bad	*next;
> -} dir2_bad_t;
> +};

Just out of curiosity, how fast does this linked list grow?  In theory
we could hoist scrub/bitmap.c to libfrog and turn this into a bitmap,
but that probably depends on how often we find inodes with bad link
counts...?  And admittedly, avlnodes aren't cheap either...

Anyway, this patch itself looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
> -static dir2_bad_t *dir2_bad_list;
> +static struct dir2_bad	*dir2_bad_list;
> +pthread_mutex_t		dir2_bad_list_lock = PTHREAD_MUTEX_INITIALIZER;
>  
>  static void
>  dir2_add_badlist(
>  	xfs_ino_t	ino)
>  {
> -	dir2_bad_t	*l;
> +	struct dir2_bad	*l;
>  
> -	if ((l = malloc(sizeof(dir2_bad_t))) == NULL) {
> +	l = malloc(sizeof(*l));
> +	if (!l) {
>  		do_error(
>  _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
> -			sizeof(dir2_bad_t), ino);
> +			sizeof(*l), ino);
>  		exit(1);
>  	}
> +	pthread_mutex_lock(&dir2_bad_list_lock);
>  	l->next = dir2_bad_list;
>  	dir2_bad_list = l;
>  	l->ino = ino;
> +	pthread_mutex_unlock(&dir2_bad_list_lock);
>  }
>  
>  int
>  dir2_is_badino(
>  	xfs_ino_t	ino)
>  {
> -	dir2_bad_t	*l;
> +	struct dir2_bad	*l;
> +	int		ret = 0;
>  
> -	for (l = dir2_bad_list; l; l = l->next)
> -		if (l->ino == ino)
> -			return 1;
> -	return 0;
> +	pthread_mutex_lock(&dir2_bad_list_lock);
> +	for (l = dir2_bad_list; l; l = l->next) {
> +		if (l->ino == ino) {
> +			ret = 1;
> +			break;
> +		}
> +	}
> +	pthread_mutex_unlock(&dir2_bad_list_lock);
> +	return ret;
>  }
>  
>  /*
> -- 
> 2.19.1
> 
