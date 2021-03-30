Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE88C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 22:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5857619CD
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 22:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhC3WT3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 18:19:29 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:45279 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232793AbhC3WTB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 18:19:01 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 44C4863D3C;
        Wed, 31 Mar 2021 09:18:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lRMhO-008dX6-D5; Wed, 31 Mar 2021 09:18:58 +1100
Date:   Wed, 31 Mar 2021 09:18:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH v3 1/8] repair: turn bad inode list into array
Message-ID: <20210330221858.GV63242@dread.disaster.area>
References: <20210330142531.19809-1-hsiangkao@aol.com>
 <20210330142531.19809-2-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330142531.19809-2-hsiangkao@aol.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ejuB0FwlYCa-TBw7ud0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 10:25:24PM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Just use array and reallocate one-by-one here (not sure if bulk
> allocation is more effective or not.)

Did you profile repairing a filesystem with lots of broken
directories? Optimisations like this really need to be profile
guided and the impact docuemnted. That way reviewers can actually
see the benefit the change brings to the table....

> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  repair/dir2.c | 34 +++++++++++++++++-----------------
>  repair/dir2.h |  2 +-
>  2 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index eabdb4f2d497..b6a8a5c40ae4 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -20,40 +20,40 @@
>   * Known bad inode list.  These are seen when the leaf and node
>   * block linkages are incorrect.
>   */
> -typedef struct dir2_bad {
> -	xfs_ino_t	ino;
> -	struct dir2_bad	*next;
> -} dir2_bad_t;
> +struct dir2_bad {
> +	unsigned int	nr;
> +	xfs_ino_t	*itab;
> +};
>  
> -static dir2_bad_t *dir2_bad_list;
> +static struct dir2_bad	dir2_bad;
>  
>  static void
>  dir2_add_badlist(
>  	xfs_ino_t	ino)
>  {
> -	dir2_bad_t	*l;
> +	xfs_ino_t	*itab;
>  
> -	if ((l = malloc(sizeof(dir2_bad_t))) == NULL) {
> +	itab = realloc(dir2_bad.itab, (dir2_bad.nr + 1) * sizeof(xfs_ino_t));
> +	if (!itab) {
>  		do_error(
>  _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
> -			sizeof(dir2_bad_t), ino);
> +			sizeof(xfs_ino_t), ino);
>  		exit(1);
>  	}
> -	l->next = dir2_bad_list;
> -	dir2_bad_list = l;
> -	l->ino = ino;
> +	itab[dir2_bad.nr++] = ino;
> +	dir2_bad.itab = itab;
>  }
>  
> -int
> +bool
>  dir2_is_badino(
>  	xfs_ino_t	ino)
>  {
> -	dir2_bad_t	*l;
> +	unsigned int i;
>  
> -	for (l = dir2_bad_list; l; l = l->next)
> -		if (l->ino == ino)
> -			return 1;
> -	return 0;
> +	for (i = 0; i < dir2_bad.nr; ++i)
> +		if (dir2_bad.itab[i] == ino)
> +			return true;
> +	return false;

This ignores the problem with this code: it is a O(n * N) search
that gets done under an exclusive lock. Changing this to an array
doesn't improve the efficiency of the algorithm at all. It might
slighty reduce the magnitude of N, but modern CPU prefetchers detect
link list walks like this so are almost as fast sequentail array
walks. Hence this change will gain us relatively little when we have
millions of bad inodes to search.

IOWs, the scalability problem that needs to be solved here is not
"replace a linked list", it is "replace an O(n * N) search
algorithm". We should address the algorithmic problem, not the code
implementation issue.

That means we need to replace the linear search with a different
algorithm, not rework the data structure used to do a linear search.
We want this search to be reduced to O(n * log N) or O(n). We really
don't care about memory usage or even the overhead of per-object
memory allocation - we already do that and it isn't a performance
limitation, so optimising for memory allocation reductions is
optimising the wrong thing.

Replacing the linked list with an AVL tree or radix tree will make
the search O(log N), giving us the desired reduction in search
overhead to O(n * log N) and, more importantly, a significant
reduction in lock hold times.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
