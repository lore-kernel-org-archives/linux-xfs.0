Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17AEC3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 06:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC12422CE3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 06:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfH3GRj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 02:17:39 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41959 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbfH3GRi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 02:17:38 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1608C43EC48;
        Fri, 30 Aug 2019 16:17:36 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3aE2-00043N-Ja; Fri, 30 Aug 2019 16:17:34 +1000
Date:   Fri, 30 Aug 2019 16:17:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs_repair: use precomputed inode geometry values
Message-ID: <20190830061734.GM1119@dread.disaster.area>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633314305.1215978.18190917724979571824.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156633314305.1215978.18190917724979571824.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=msCg-w-GopRYya74yvUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 01:32:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the precomputed inode geometry values instead of open-coding them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/dino_chunks.c |   22 +++++++++++-----------
>  repair/dinode.c      |   13 ++++---------
>  repair/globals.c     |    1 -
>  repair/globals.h     |    1 -
>  repair/prefetch.c    |   21 ++++++++-------------
>  repair/xfs_repair.c  |    2 --
>  6 files changed, 23 insertions(+), 37 deletions(-)

two minor nits:

> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 2fecfd68..5a725a51 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -710,17 +710,12 @@ pf_queuing_worker(
>  	int			num_inos;
>  	ino_tree_node_t		*irec;
>  	ino_tree_node_t		*cur_irec;
> -	int			blks_per_cluster;
>  	xfs_agblock_t		bno;
>  	int			i;
>  	int			err;
>  	uint64_t		sparse;
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
>  
> -	blks_per_cluster = igeo->inode_cluster_size >> mp->m_sb.sb_blocklog;
> -	if (blks_per_cluster == 0)
> -		blks_per_cluster = 1;
> -
>  	for (i = 0; i < PF_THREAD_COUNT; i++) {
>  		err = pthread_create(&args->io_threads[i], NULL,
>  				pf_io_worker, args);
> @@ -786,21 +781,22 @@ pf_queuing_worker(
>  			struct xfs_buf_map	map;
>  
>  			map.bm_bn = XFS_AGB_TO_DADDR(mp, args->agno, bno);
> -			map.bm_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
> +			map.bm_len = XFS_FSB_TO_BB(mp,
> +					M_IGEO(mp)->blocks_per_cluster);

	igeo->blocks_per_cluster

>  
>  			/*
>  			 * Queue I/O for each non-sparse cluster. We can check
>  			 * sparse state in cluster sized chunks as cluster size
>  			 * is the min. granularity of sparse irec regions.
>  			 */
> -			if ((sparse & ((1ULL << inodes_per_cluster) - 1)) == 0)
> +			if ((sparse & ((1ULL << M_IGEO(mp)->inodes_per_cluster) - 1)) == 0)

	igeo->inodes_per_cluster and 80 columns....

Otherwise,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
