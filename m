Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33813C47080
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 01:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19A2760FF1
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 01:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhFBBxb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 21:53:31 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36195 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229471AbhFBBxb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 21:53:31 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AF7131043815;
        Wed,  2 Jun 2021 11:51:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loG2t-007vcs-4j; Wed, 02 Jun 2021 11:51:47 +1000
Date:   Wed, 2 Jun 2021 11:51:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 05/14] xfs: separate the dqrele_all inode grab logic from
 xfs_inode_walk_ag_grab
Message-ID: <20210602015147.GM664593@dread.disaster.area>
References: <162259515220.662681.6750744293005850812.stgit@locust>
 <162259518016.662681.13322964506776234493.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162259518016.662681.13322964506776234493.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=1tuNzZoT3k-UgqOnbXMA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 05:53:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Disentangle the dqrele_all inode grab code from the "generic" inode walk
> grabbing code, and and use the opportunity to document why the dqrele
> grab function does what it does.  Since xfs_inode_walk_ag_grab is now
> only used for blockgc, rename it to reflect that.
> 
> Ultimately, there will be four reasons to perform a walk of incore
> inodes: quotaoff dquote releasing (dqrele), garbage collection of
> speculative preallocations (blockgc), reclamation of incore inodes
> (reclaim), and deferred inactivation (inodegc).  Each of these four have
> their own slightly different criteria for deciding if they want to
> handle an inode, so it makes more sense to have four cohesive igrab
> functions than one confusing parameteric grab function like we do now.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 61 insertions(+), 5 deletions(-)

Looks ok - one minor nit:

> @@ -1642,6 +1682,22 @@ xfs_blockgc_free_quota(
>  
>  /* XFS Incore Inode Walking Code */
>  
> +static inline bool
> +xfs_grabbed_for_walk(
> +	enum xfs_icwalk_goal	goal,
> +	struct xfs_inode	*ip,
> +	int			iter_flags)
> +{
> +	switch (goal) {
> +	case XFS_ICWALK_BLOCKGC:
> +		return xfs_blockgc_igrab(ip, iter_flags);
> +	case XFS_ICWALK_DQRELE:
> +		return xfs_dqrele_igrab(ip);
> +	default:
> +		return false;
> +	}
> +}

xfs_icwalk_grab() seems to make more sense here.

/me is wondering if all this should eventually end up under a
xfs_icwalk namespace?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
