Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915A6C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 18:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59BED61981
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 18:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhCSSUn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 14:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhCSSUM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Mar 2021 14:20:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B2E6198B;
        Fri, 19 Mar 2021 18:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616178012;
        bh=BEgkkrkE7YlU7KG0ibhreMalk/2c6O7xbkbqD+7/ic8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EmhwMN1RHYI4Bz2BrBGY9Hi6FbYBXupNp6q59/njbaAJ3bfqG33l7m/WHcH7i+u6r
         GpMNKu31VkFTgg/Xu9DPYQhC4z8ASCBIIViafvkx2SVWBKEfZd+C34km/VffxVKx/j
         ZkusiWvbjXd1KMtTXMNf9CSwmM/miQTCQV9jf1UyzpUrcrsMJdbFOT5F8K/0akhoYv
         Vb3QIrxxJLDX6lw6qropd8l1ihAYk9Q8QqwmGrKPjlM4VB7bZsghEBmEik+k/hc8xD
         luOjd1EFXh5vHfgeFZJMbVxUOqLOfR9VuR1supD3nX6ppACZk7MLACFHhQ8Xg+BPBP
         FUVal3HTNtAIw==
Date:   Fri, 19 Mar 2021 11:20:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hsiangkao@redhat.com
Subject: Re: [PATCH 2/7] repair: Protect bad inode list with mutex
Message-ID: <20210319182011.GT22100@magnolia>
References: <20210319013355.776008-1-david@fromorbit.com>
 <20210319013355.776008-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319013355.776008-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 12:33:50PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To enable phase 6 parallelisation, we need to protect the bad inode
> list from concurrent modification and/or access. Wrap it with a
> mutex and clean up the nasty typedefs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

FWIW, if you (Gao at this point, I surmise) want to dig deeper into the
comment that Christoph made during the last review of this patchset,
repair already /does/ have a resizing array structure in repair/slab.c.

That /would/ decrease the memory overhead of the bad inode list by 50%,
though I would hope that bad inodes are a rare enough occurrence that it
doesn't matter much...

--D

> ---
>  repair/dir2.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index eabdb4f2d497..23333e59a382 100644
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
> 2.30.1
> 
