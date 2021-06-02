Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEBCC4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 02:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E09E6101C
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 02:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhFBCCd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:02:33 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35280 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229586AbhFBCCc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 22:02:32 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AFC2C86175A;
        Wed,  2 Jun 2021 12:00:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loGBb-007vsi-PE; Wed, 02 Jun 2021 12:00:47 +1000
Date:   Wed, 2 Jun 2021 12:00:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 08/14] xfs: remove indirect calls from
 xfs_inode_walk{,_ag}
Message-ID: <20210602020047.GP664593@dread.disaster.area>
References: <162259515220.662681.6750744293005850812.stgit@locust>
 <162259519664.662681.8440195387091934320.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162259519664.662681.8440195387091934320.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=5gZEeFiZ9AMnHw-ouNMA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 05:53:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It turns out that there is a 1:1 mapping between the execute and goal
> parameters that are passed to xfs_inode_walk_ag:
> 
> 	xfs_blockgc_scan_inode <=> XFS_ICWALK_BLOCKGC
> 	xfs_dqrele_inode <=> XFS_ICWALK_DQRELE
> 
> Because of this exact correspondence, we don't need the execute function
> pointer and can replace it with a direct call.
> 
> For the price of a forward static declaration, we can eliminate the
> indirect function call.  This likely has a negligible impact on
> performance (since the execute function runs transactions), but it also
> simplifies the function signature.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   46 ++++++++++++++++++++++------------------------
>  1 file changed, 22 insertions(+), 24 deletions(-)

Overall looks good.

> @@ -1777,7 +1772,14 @@ xfs_inode_walk_ag(
>  		for (i = 0; i < nr_found; i++) {
>  			if (!batch[i])
>  				continue;
> -			error = execute(batch[i], args);
> +			switch (goal) {
> +			case XFS_ICWALK_DQRELE:
> +				error = xfs_dqrele_inode(batch[i], args);
> +				break;
> +			case XFS_ICWALK_BLOCKGC:
> +				error = xfs_blockgc_scan_inode(batch[i], args);
> +				break;
> +			}
>  			xfs_irele(batch[i]);

I can't help but think that this should be wrapped up in a function
like xfs_icwalk_grab(), especially as we add the reclaim case to
this later on. Perhaps:

static int
xfs_icwalk_process_inode(
	struct xfs_inode	*ip,
	enum xfs_icwalk_goal	goal,
	void			*args)
{
	int			error = -EINVAL;

	switch (goal) {
	case XFS_ICWALK_DQRELE:
		error = xfs_dqrele_inode(ip, args);
		break;
	case XFS_ICWALK_BLOCKGC:
		error = xfs_blockgc_scan_inode(ip, args);
		break;
	}
	xfs_irele(ip);
	return error;
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
