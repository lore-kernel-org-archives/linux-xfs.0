Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3108BC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 23:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiDVXGW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 19:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234132AbiDVXGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 19:06:07 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C06132287F3
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 15:36:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6D45010E5EA0;
        Sat, 23 Apr 2022 08:36:37 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ni1tD-003LMS-AE; Sat, 23 Apr 2022 08:36:35 +1000
Date:   Sat, 23 Apr 2022 08:36:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: create shadow transaction reservations for
 computing minimum log size
Message-ID: <20220422223635.GC1544202@dread.disaster.area>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
 <164997688275.383881.1038640482191339784.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164997688275.383881.1038640482191339784.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62632df5
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=RBfJqf3T0bQlxbNG_tUA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 03:54:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every time someone changes the transaction reservation sizes, they
> introduce potential compatibility problems if the changes affect the
> minimum log size that we validate at mount time.  If the minimum log
> size gets larger (which should be avoided because doing so presents a
> serious risk of log livelock), filesystems created with old mkfs will
> not mount on a newer kernel; if the minimum size shrinks, filesystems
> created with newer mkfs will not mount on older kernels.
> 
> Therefore, enable the creation of a shadow log reservation structure
> where we can "undo" the effects of tweaks when computing minimum log
> sizes.  These shadow reservations should never be used in practice, but
> they insulate us from perturbations in minimum log size.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_log_rlimit.c |   17 +++++++++++++----
>  fs/xfs/libxfs/xfs_trans_resv.c |   12 ++++++++++++
>  fs/xfs/libxfs/xfs_trans_resv.h |    2 ++
>  fs/xfs/xfs_trace.h             |   12 ++++++++++--
>  4 files changed, 37 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index 67798ff5e14e..2bafc69cac15 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -14,6 +14,7 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_trace.h"
>  
>  /*
>   * Calculate the maximum length in bytes that would be required for a local
> @@ -47,18 +48,25 @@ xfs_log_get_max_trans_res(
>  	struct xfs_trans_res	*max_resp)
>  {
>  	struct xfs_trans_res	*resp;
> +	struct xfs_trans_res	*start_resp;
>  	struct xfs_trans_res	*end_resp;
> +	struct xfs_trans_resv	*resv;
>  	int			log_space = 0;
>  	int			attr_space;
>  
>  	attr_space = xfs_log_calc_max_attrsetm_res(mp);
>  
> -	resp = (struct xfs_trans_res *)M_RES(mp);
> -	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
> -	for (; resp < end_resp; resp++) {
> +	resv = kmem_zalloc(sizeof(struct xfs_trans_resv), 0);
> +	xfs_trans_resv_calc_logsize(mp, resv);
> +
> +	start_resp = (struct xfs_trans_res *)resv;
> +	end_resp = (struct xfs_trans_res *)(resv + 1);
> +	for (resp = start_resp; resp < end_resp; resp++) {
>  		int		tmp = resp->tr_logcount > 1 ?
>  				      resp->tr_logres * resp->tr_logcount :
>  				      resp->tr_logres;
> +
> +		trace_xfs_trans_resv_calc_logsize(mp, resp - start_resp, resp);
>  		if (log_space < tmp) {
>  			log_space = tmp;
>  			*max_resp = *resp;		/* struct copy */

This took me a while to get my head around. The minimum logsize
calculation stuff is all a bit of a mess.

Essentially, we call xfs_log_get_max_trans_res() from two places.
One is to calculate the minimum log size, the other is the
transaction reservation tracing code done when M_RES(mp) is set up
via xfs_trans_trace_reservations().  We don't need the call from
xfs_trans_trace_reservations() - it's trivial to scan the list of
tracepoints emitted by this function at mount time to find the
maximum reservation.

Hence I think we should start by removing that call to this
function, and making this a static function called only from
xfs_log_calc_minimum_size().

At this point, we can use an on-stack struct xfs_trans_resv for the
calculated values - no need for memory allocation here as we will
never be short of stack space in this path.

The tracing in the loop also wants an integer index into the struct
xfs_trans_resv structure, so it should be changed to match what
xfs_trans_trace_reservations() does:

	struct xfs_trans_resv	resv;
	struct xfs_trans_res	*resp;
	struct xfs_trans_res	*end_resp;

	....

	xfs_trans_resv_calc(mp, &resv)

	resp = (struct xfs_trans_res *)&resv;
	end_resp = (struct xfs_trans_res *)(&resv + 1);
	for (i = 0; resp < end_resp; resp++) {
		.....
		trace_xfs_trans_resv_calc_logsize(mp, i, resp);
		....
	}

> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 6f83d9b306ee..12d4e451e70e 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -933,3 +933,15 @@ xfs_trans_resv_calc(
>  	/* Put everything back the way it was.  This goes at the end. */
>  	mp->m_rmap_maxlevels = rmap_maxlevels;
>  }
> +
> +/*
> + * Compute an alternate set of log reservation sizes for use exclusively with
> + * minimum log size calculations.
> + */
> +void
> +xfs_trans_resv_calc_logsize(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_resv	*resp)
> +{
> +	xfs_trans_resv_calc(mp, resp);
> +}

This function and it's name was waht confused me for a while - I
don't think it belongs in this patch, and I don't think it belongs
in this file when it's filled out in the next patch. It's basically
handling things specific to minimum log size calculations, so with
the above mods I think it should also end up being static to
libxfs/xfs_log_rlimit.c.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
