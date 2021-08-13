Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF09BC4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 16:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B61BB60EB2
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 16:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbhHMQ1E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 12:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234309AbhHMQ1D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Aug 2021 12:27:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B03F5610A4;
        Fri, 13 Aug 2021 16:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628871996;
        bh=f6CeVft/lEe9k+7VQRrspkKiwwAdf8DMs+X0a23/Pew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AjJvCJjZlooVpvlwmKBumF2PNo8m84epIV4txrBF+AUJ+uIToFGUfAgDMXABs6Oux
         4JIkOrPEju9z+ynMmbqj7dHlmzS1dyyBxZ9Xl4CJ4M5Mawm7cWo4jM6tGEG54La5YZ
         imHyCiiPqSIeQNSAuGG9cY3f67izx5q6xNbL2HNzXq50KzPJ0TCY5fsqSjgAKfhwbJ
         oT4rdlrB92pURS7yG6f7ejOH8108xlMjN3LHiP/tUQieUC9uhTthyv3Dv8T29DFerQ
         ojNsNlT11teizGZTnmEpAKVhNmcH1qijUcUmGlUkqKUkKPXoK7Z9M0sE1PFI93xgnL
         l77yHhroyiFEw==
Date:   Fri, 13 Aug 2021 09:26:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] xfs: remove support for untagged lookups in xfs_icwalk*
Message-ID: <20210813162636.GX3601443@magnolia>
References: <20210813081623.83323-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813081623.83323-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 13, 2021 at 10:16:23AM +0200, Christoph Hellwig wrote:
> With quotaoff not allowing disabling of accounting there is no need
> for untagged lookups in this code, so remove the dead leftovers.
> 
> Repoted-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_icache.c | 39 ++++-----------------------------------
>  1 file changed, 4 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e7e69e55b7680a..f5a52ec084842d 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -43,15 +43,6 @@ enum xfs_icwalk_goal {

The patch itself looks fine, so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

But you might as well convert the ag walk to use the foreach macros
like everywhere else:

--D

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f5a52ec08484..b7ffdc03e0f7 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1762,16 +1762,16 @@ xfs_icwalk(
 	struct xfs_perag	*pag;
 	int			error = 0;
 	int			last_error = 0;
-	xfs_agnumber_t		agno = 0;
+	xfs_agnumber_t		agno;
 
-	while ((pag = xfs_perag_get_tag(mp, agno, goal))) {
-		agno = pag->pag_agno + 1;
+	for_each_perag_tag(mp, agno, pag, goal) {
 		error = xfs_icwalk_ag(pag, goal, icw);
-		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
-			if (error == -EFSCORRUPTED)
+			if (error == -EFSCORRUPTED) {
+				xfs_perag_put(pag);
 				break;
+			}
 		}
 	}
 	return last_error;
>  	XFS_ICWALK_RECLAIM	= XFS_ICI_RECLAIM_TAG,
>  };
>  
> -#define XFS_ICWALK_NULL_TAG	(-1U)
> -
> -/* Compute the inode radix tree tag for this goal. */
> -static inline unsigned int
> -xfs_icwalk_tag(enum xfs_icwalk_goal goal)
> -{
> -	return goal < 0 ? XFS_ICWALK_NULL_TAG : goal;
> -}
> -
>  static int xfs_icwalk(struct xfs_mount *mp,
>  		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
>  static int xfs_icwalk_ag(struct xfs_perag *pag,
> @@ -1676,22 +1667,14 @@ xfs_icwalk_ag(
>  	nr_found = 0;
>  	do {
>  		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
> -		unsigned int	tag = xfs_icwalk_tag(goal);
>  		int		error = 0;
>  		int		i;
>  
>  		rcu_read_lock();
>  
> -		if (tag == XFS_ICWALK_NULL_TAG)
> -			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
> -					(void **)batch, first_index,
> -					XFS_LOOKUP_BATCH);
> -		else
> -			nr_found = radix_tree_gang_lookup_tag(
> -					&pag->pag_ici_root,
> -					(void **) batch, first_index,
> -					XFS_LOOKUP_BATCH, tag);
> -
> +		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
> +				(void **) batch, first_index,
> +				XFS_LOOKUP_BATCH, goal);
>  		if (!nr_found) {
>  			done = true;
>  			rcu_read_unlock();
> @@ -1769,20 +1752,6 @@ xfs_icwalk_ag(
>  	return last_error;
>  }
>  
> -/* Fetch the next (possibly tagged) per-AG structure. */
> -static inline struct xfs_perag *
> -xfs_icwalk_get_perag(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		agno,
> -	enum xfs_icwalk_goal	goal)
> -{
> -	unsigned int		tag = xfs_icwalk_tag(goal);
> -
> -	if (tag == XFS_ICWALK_NULL_TAG)
> -		return xfs_perag_get(mp, agno);
> -	return xfs_perag_get_tag(mp, agno, tag);
> -}
> -
>  /* Walk all incore inodes to achieve a given goal. */
>  static int
>  xfs_icwalk(
> @@ -1795,7 +1764,7 @@ xfs_icwalk(
>  	int			last_error = 0;
>  	xfs_agnumber_t		agno = 0;
>  
> -	while ((pag = xfs_icwalk_get_perag(mp, agno, goal))) {
> +	while ((pag = xfs_perag_get_tag(mp, agno, goal))) {
>  		agno = pag->pag_agno + 1;
>  		error = xfs_icwalk_ag(pag, goal, icw);
>  		xfs_perag_put(pag);
> -- 
> 2.30.2
> 
