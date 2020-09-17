Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC819C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 05:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6781E2078D
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 05:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgIQF6E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 01:58:04 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54573 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgIQF6C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 01:58:02 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1F0543AA6ED;
        Thu, 17 Sep 2020 15:58:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kImvd-0001aE-TN; Thu, 17 Sep 2020 15:57:57 +1000
Date:   Thu, 17 Sep 2020 15:57:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/3] xfs: change the order in which child and parent
 defer ops are finished
Message-ID: <20200917055757.GG12131@dread.disaster.area>
References: <160031338724.3624707.1335084348340671147.stgit@magnolia>
 <160031339354.3624707.1985288778723932783.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160031339354.3624707.1985288778723932783.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=IuRgj43g c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=6eIcgRVxR0gWDYNPFMcA:9 a=3eyV5OuFkhsaRZgu:21
        a=02ERAi5UB9sB4zkP:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 08:29:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The defer ops code has been finishing items in the wrong order -- if a

<snip long explanation>

Yeah, I'd kinda come to the same conclusion while reviewing the
recovery process. The analogy I made in my mind was the difference
in overhead of tracking a breadth-first tree walk vs a depth-first
tree walk...

> As originally written, the code used list_splice_tail_init instead of
> list_splice_init, so change that, and leave a short comment explaining
> our actions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 97523b394932..84a70edd0da1 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -431,8 +431,17 @@ xfs_defer_finish_noroll(
>  
>  	/* Until we run out of pending work to finish... */
>  	while (!list_empty(&dop_pending) || !list_empty(&(*tp)->t_dfops)) {
> +		/*
> +		 * Deferred items that are created in the process of finishing
> +		 * other deferred work items should be queued at the head of
> +		 * the pending list, which puts them ahead of the deferred work
> +		 * that was created by the caller.  This keeps the number of
> +		 * pending work items to a minimum, which decreases the amount
> +		 * of time that any one intent item can stick around in memory,
> +		 * pinning the log tail.
> +		 */
>  		xfs_defer_create_intents(*tp);
> -		list_splice_tail_init(&(*tp)->t_dfops, &dop_pending);
> +		list_splice_init(&(*tp)->t_dfops, &dop_pending);

*nod*.

My favourite sort of fix - a couple of hundred lines of explanation
for a one-liner :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
