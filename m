Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23155C47080
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 01:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06EEC613D0
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 01:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFBBoj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 21:44:39 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:38372 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230150AbhFBBoi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 21:44:38 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 145331AFD97;
        Wed,  2 Jun 2021 11:42:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loFuG-007vWV-57; Wed, 02 Jun 2021 11:42:52 +1000
Date:   Wed, 2 Jun 2021 11:42:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 04/14] xfs: pass the goal of the incore inode walk to
 xfs_inode_walk()
Message-ID: <20210602014252.GL664593@dread.disaster.area>
References: <162259515220.662681.6750744293005850812.stgit@locust>
 <162259517467.662681.7329146794207007368.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162259517467.662681.7329146794207007368.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=wS6wzhpyqS1Tek1E7EIA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 05:52:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As part of removing the indirect calls and radix tag implementation
> details from the incore inode walk loop, create an enum to represent the
> goal of the inode iteration.  More immediately, this separate removes
> the need for the "ICI_NOTAG" define which makes little sense.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   51 +++++++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_icache.h |    9 ---------
>  2 files changed, 37 insertions(+), 23 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e70ce7868444..018b3f8bdd21 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -26,12 +26,35 @@
>  
>  #include <linux/iversion.h>
>  
> +/* Radix tree tags for incore inode tree. */
> +
> +/* inode is to be reclaimed */
> +#define XFS_ICI_RECLAIM_TAG	0
> +/* Inode has speculative preallocations (posteof or cow) to clean. */
> +#define XFS_ICI_BLOCKGC_TAG	1
> +
> +/*
> + * The goal for walking incore inodes.  These can correspond with incore inode
> + * radix tree tags when convenient.  Avoid existing XFS_IWALK namespace.
> + */
> +enum xfs_icwalk_goal {
> +	XFS_ICWALK_DQRELE	= -1,
> +	XFS_ICWALK_BLOCKGC	= XFS_ICI_BLOCKGC_TAG,
> +};
> +
> +/* Is there a radix tree tag for this goal? */
> +static inline bool
> +xfs_icwalk_tagged(enum xfs_icwalk_goal goal)
> +{
> +	return goal != XFS_ICWALK_DQRELE;
> +}

I think I'd rather the "non tag" types be explicitly defined to be
less than zero, and the tagged types be greater than zero and
(maybe) match the tag to be used for lookup. That way we end up
with:

static inline int
xfs_icwalk_tag(enum xfs_icwalk_goal goal)
{
	if (goal < 0)
		return -1;
	return goal;
}

And we have a mechanism that allows for us to have multiple goals
point at the same tag by replacing the 'return goal' with a switch
statement. THen...

> @@ -1650,7 +1673,7 @@ xfs_inode_walk_ag(
>  
>  		rcu_read_lock();
>  
> -		if (tag == XFS_ICI_NO_TAG)
> +		if (!xfs_icwalk_tagged(goal))
>  			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
>  					(void **)batch, first_index,
>  					XFS_LOOKUP_BATCH);
> @@ -1658,7 +1681,7 @@ xfs_inode_walk_ag(
>  			nr_found = radix_tree_gang_lookup_tag(
>  					&pag->pag_ici_root,
>  					(void **) batch, first_index,
> -					XFS_LOOKUP_BATCH, tag);
> +					XFS_LOOKUP_BATCH, goal);

This becomes:

		tag = xfs_icwalk_tag(goal);
		if (tag < 0)
			/* do untagged lookup */
		else
			/* do tagged lookup w/ tag */
>  
>  		if (!nr_found) {
>  			rcu_read_unlock();
> @@ -1733,11 +1756,11 @@ static inline struct xfs_perag *
>  xfs_inode_walk_get_perag(
>  	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
> -	int			tag)
> +	enum xfs_icwalk_goal	goal)
>  {
> -	if (tag == XFS_ICI_NO_TAG)
> +	if (!xfs_icwalk_tagged(goal))
>  		return xfs_perag_get(mp, agno);
> -	return xfs_perag_get_tag(mp, agno, tag);
> +	return xfs_perag_get_tag(mp, agno, goal);
>  }
>  
>  /*
> @@ -1750,7 +1773,7 @@ xfs_inode_walk(
>  	int			iter_flags,
>  	int			(*execute)(struct xfs_inode *ip, void *args),
>  	void			*args,
> -	int			tag)
> +	enum xfs_icwalk_goal	goal)
>  {
>  	struct xfs_perag	*pag;
>  	int			error = 0;
> @@ -1758,9 +1781,9 @@ xfs_inode_walk(
>  	xfs_agnumber_t		ag;
>  
>  	ag = 0;
> -	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
> +	while ((pag = xfs_inode_walk_get_perag(mp, ag, goal))) {
>  		ag = pag->pag_agno + 1;
> -		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
> +		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, goal);
>  		xfs_perag_put(pag);
>  		if (error) {
>  			last_error = error;

FYI, I'm soon going to be modifying this walk to separate it out
into for_each_perag() and for_each_perag_tagged() for shrink
protection. This becomes cleaner if we have a single xfs_icwalk_tag()
call here rather than hiding it inside xfs_inode_walk_get_perag().

Not something you need to address here, but I thought I'd mention
it so you can think about that while contemplating my suggestion
above...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
