Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DDBC3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 08:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4BEB22CF7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 08:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfIDIP5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:15:57 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52623 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725267AbfIDIP5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 04:15:57 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 486DB43DD0E;
        Wed,  4 Sep 2019 18:15:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5QSH-0002GW-5M; Wed, 04 Sep 2019 18:15:53 +1000
Date:   Wed, 4 Sep 2019 18:15:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_scrub: fix nr_dirs accounting problems
Message-ID: <20190904081553.GD1119@dread.disaster.area>
References: <156685447255.2840069.707517725113377305.stgit@magnolia>
 <156685448524.2840069.582566075645213965.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685448524.2840069.582566075645213965.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=dTh7szeqh260ZumjBXQA:9
        a=_JvzwZqzBF5AZRqQ:21 a=oSjLnm0KwY87VVAn:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:21:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're scanning the directory tree, we bump nr_dirs every time we
> think we're going to queue a new directory to process, and we decrement
> it every time we're finished doing something with a directory
> (successful or not).  We forgot to undo a counter increment when
> workqueue_add fails, so refactor the code into helpers and call them
> as necessary for correct operation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/vfs.c |   38 +++++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/scrub/vfs.c b/scrub/vfs.c
> index ea2866d9..b358ab4a 100644
> --- a/scrub/vfs.c
> +++ b/scrub/vfs.c
> @@ -45,6 +45,32 @@ struct scan_fs_tree_dir {
>  
>  static void scan_fs_dir(struct workqueue *wq, xfs_agnumber_t agno, void *arg);
>  
> +/* Increment the number of directories that are queued for processing. */
> +static void
> +inc_nr_dirs(
> +	struct scan_fs_tree	*sft)
> +{
> +	pthread_mutex_lock(&sft->lock);
> +	sft->nr_dirs++;
> +	pthread_mutex_unlock(&sft->lock);
> +}
> +
> +/*
> + * Decrement the number of directories that are queued for processing and if
> + * we ran out of dirs to process, wake up anyone who was waiting for processing
> + * to finish.
> + */
> +static void
> +dec_nr_dirs(
> +	struct scan_fs_tree	*sft)
> +{
> +	pthread_mutex_lock(&sft->lock);
> +	sft->nr_dirs--;
> +	if (sft->nr_dirs == 0)
> +		pthread_cond_signal(&sft->wakeup);
> +	pthread_mutex_unlock(&sft->lock);
> +}
> +
>  /* Queue a directory for scanning. */
>  static bool
>  queue_subdir(
> @@ -73,11 +99,10 @@ queue_subdir(
>  	new_sftd->sft = sft;
>  	new_sftd->rootdir = is_rootdir;
>  
> -	pthread_mutex_lock(&sft->lock);
> -	sft->nr_dirs++;
> -	pthread_mutex_unlock(&sft->lock);
> +	inc_nr_dirs(sft);
>  	error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
>  	if (error) {
> +		dec_nr_dirs(sft);
>  		str_info(ctx, ctx->mntpoint,
>  _("Could not queue subdirectory scan work."));
>  		return false;

Ok, that's the bug fix for the previous patch. Potentially should be
a separate patch, but right now there is so much outstanding that I
don't think it's worthwhile to respin the series just to fix that.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
