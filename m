Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CED5C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 08:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C50F20674
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 08:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfIDIM5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:12:57 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57736 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727787AbfIDIM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 04:12:57 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 442D143DCEB;
        Wed,  4 Sep 2019 18:12:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5QPM-0002G5-Gn; Wed, 04 Sep 2019 18:12:52 +1000
Date:   Wed, 4 Sep 2019 18:12:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_scrub: refactor queueing of subdir scan work item
Message-ID: <20190904081252.GC1119@dread.disaster.area>
References: <156685447255.2840069.707517725113377305.stgit@magnolia>
 <156685447885.2840069.3132139174368034407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685447885.2840069.3132139174368034407.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=uD3VSbrvqoQqrrVSKawA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:21:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the open-coded process of queueing a subdirectory for scanning
> with a single helper function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/vfs.c |   94 +++++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 52 insertions(+), 42 deletions(-)
> 
> 
> diff --git a/scrub/vfs.c b/scrub/vfs.c
> index 7b0b5bcd..ea2866d9 100644
> --- a/scrub/vfs.c
> +++ b/scrub/vfs.c
> @@ -43,6 +43,49 @@ struct scan_fs_tree_dir {
>  	bool			rootdir;
>  };
>  
> +static void scan_fs_dir(struct workqueue *wq, xfs_agnumber_t agno, void *arg);
> +
> +/* Queue a directory for scanning. */
> +static bool
> +queue_subdir(
> +	struct scrub_ctx	*ctx,
> +	struct scan_fs_tree	*sft,
> +	struct workqueue	*wq,
> +	const char		*path,
> +	bool			is_rootdir)
> +{
> +	struct scan_fs_tree_dir	*new_sftd;
> +	int			error;
> +
> +	new_sftd = malloc(sizeof(struct scan_fs_tree_dir));
> +	if (!new_sftd) {
> +		str_errno(ctx, _("creating directory scan context"));
> +		return false;
> +	}
> +
> +	new_sftd->path = strdup(path);
> +	if (!new_sftd->path) {
> +		str_errno(ctx, _("creating directory scan path"));
> +		free(new_sftd);
> +		return false;
> +	}
> +
> +	new_sftd->sft = sft;
> +	new_sftd->rootdir = is_rootdir;
> +
> +	pthread_mutex_lock(&sft->lock);
> +	sft->nr_dirs++;
> +	pthread_mutex_unlock(&sft->lock);
> +	error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
> +	if (error) {
> +		str_info(ctx, ctx->mntpoint,
> +_("Could not queue subdirectory scan work."));
> +		return false;

Need to drop sft->nr_dirs here, probably free the memory, too.

> @@ -177,41 +203,25 @@ scan_fs_tree(
>  	pthread_mutex_init(&sft.lock, NULL);
>  	pthread_cond_init(&sft.wakeup, NULL);
>  
> -	sftd = malloc(sizeof(struct scan_fs_tree_dir));
> -	if (!sftd) {
> -		str_errno(ctx, ctx->mntpoint);
> -		return false;
> -	}
> -	sftd->path = strdup(ctx->mntpoint);
> -	sftd->sft = &sft;
> -	sftd->rootdir = true;
> -
>  	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
>  			scrub_nproc_workqueue(ctx));
>  	if (ret) {
>  		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
> -		goto out_free;
> +		return false;
>  	}
> -	ret = workqueue_add(&wq, scan_fs_dir, 0, sftd);
> -	if (ret) {
> -		str_info(ctx, ctx->mntpoint,
> -_("Could not queue directory scan work."));
> +
> +	sft.moveon = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
> +	if (!sft.moveon)
>  		goto out_wq;
> -	}

sft is a stack varable that is stuffed into the structure passed to
work run on the workqueue. Is that safe to do here?

>  	pthread_mutex_lock(&sft.lock);
>  	pthread_cond_wait(&sft.wakeup, &sft.lock);

maybe it is because of this, but it's not immediately obvious what
condition actually triggers and that all the work is done...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
