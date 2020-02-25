Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50ABFC35DF5
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 06:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3288021744
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 06:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbgBYGmK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 01:42:10 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44776 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbgBYGmK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 01:42:10 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5A2EB3A2A76;
        Tue, 25 Feb 2020 17:42:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6Tux-000747-KE; Tue, 25 Feb 2020 17:42:07 +1100
Date:   Tue, 25 Feb 2020 17:42:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 07/19] xfs: Factor out xfs_attr_leaf_addname helper
Message-ID: <20200225064207.GG10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-8-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223020611.1802-8-allison.henderson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=sMvcqou3oK8yu4rMDcgA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 07:05:59PM -0700, Allison Collins wrote:
> Factor out new helper function xfs_attr_leaf_try_add. Because new delayed attribute
> routines cannot roll transactions, we carve off the parts of xfs_attr_leaf_addname
> that we can use, and move the commit into the calling function.

68-72 columns :P

> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 88 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 57 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index cf0cba7..b2f0780 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -305,10 +305,30 @@ xfs_attr_set_args(
>  		}
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>  		error = xfs_attr_leaf_addname(args);
> -	else
> -		error = xfs_attr_node_addname(args);
> +		if (error != -ENOSPC)
> +			return error;
> +
> +		/*
> +		 * Commit that transaction so that the node_addname()
> +		 * call can manage its own transactions.
> +		 */
> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Commit the current trans (including the inode) and
> +		 * start a new one.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			return error;
> +
> +	}
> +
> +	error = xfs_attr_node_addname(args);
>  	return error;

	return xfs_attr_node_addname(args);

better yet:

	if (!xfs_bmap_one_block(dp, XFS_ATTR_FORK))
		return xfs_attr_node_addname(args);

	error = xfs_attr_leaf_addname(args);
	if (error != -ENOSPC)
		return error;
	.....

BTW, I think I see the pattern now - isolate all the metadata
changes from the mechanism of rolling the transactions, which means
it can be converted to a set of operations connected by a generic
transaction rolling mechanism. It's all starting to make more sense
now :P

> @@ -679,31 +700,36 @@ xfs_attr_leaf_addname(
>  	retval = xfs_attr3_leaf_add(bp, args);
>  	if (retval == -ENOSPC) {
>  		/*
> -		 * Promote the attribute list to the Btree format, then
> -		 * Commit that transaction so that the node_addname() call
> -		 * can manage its own transactions.
> +		 * Promote the attribute list to the Btree format.
> +		 * Unless an error occurs, retain the -ENOSPC retval
>  		 */

Comments should use all 80 columns...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
