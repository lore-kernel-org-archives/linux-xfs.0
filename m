Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD1B3C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 20:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 998D120820
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 20:52:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PLwYR/7m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfH3Uwz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 16:52:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48598 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbfH3Uwy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 16:52:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UKo2DQ029740;
        Fri, 30 Aug 2019 20:52:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=xKN42u5/K88J6ycooimruTkeMEC8+h8kDQoOWEKO5kQ=;
 b=PLwYR/7mKFEWV56BUFB1ZTYmaak1vL3svJNIfOgLzddYkB8ejIF50SRS4p2wsx+s4Myd
 Hn3paFyGFchjTIq7gXahSHm63aXhqujAMhVsniiWtjuhvZBkMTpr2LNewGo4bgkxvqLU
 HwyRPlasEIIRRYnxYDe5p79HyOgA0W6JbkvIrRi5u10MIYgune10w9etbGGSN9xW/jlJ
 ohpib98XuvUeYLRU1rkVSLddvVG4gfee4GSLANeuflgqw21S3XUYLZDjV1XvvX15y9yX
 8G/FUuCPmf9Pl/pXK3Ad8UqHgmnR2IKyseTbh0M58zAJgcHmBu2AtWf0GJY6A1KrLXAI Ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uqb6a80bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 20:52:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UKmMXT105888;
        Fri, 30 Aug 2019 20:52:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2upkrgujud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 20:52:51 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7UKqoAq009739;
        Fri, 30 Aug 2019 20:52:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 13:52:49 -0700
Date:   Fri, 30 Aug 2019 13:52:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs_repair: use precomputed inode geometry values
Message-ID: <20190830205248.GI5354@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633314305.1215978.18190917724979571824.stgit@magnolia>
 <20190830061734.GM1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830061734.GM1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300199
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 04:17:34PM +1000, Dave Chinner wrote:
> On Tue, Aug 20, 2019 at 01:32:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use the precomputed inode geometry values instead of open-coding them.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/dino_chunks.c |   22 +++++++++++-----------
> >  repair/dinode.c      |   13 ++++---------
> >  repair/globals.c     |    1 -
> >  repair/globals.h     |    1 -
> >  repair/prefetch.c    |   21 ++++++++-------------
> >  repair/xfs_repair.c  |    2 --
> >  6 files changed, 23 insertions(+), 37 deletions(-)
> 
> two minor nits:
> 
> > diff --git a/repair/prefetch.c b/repair/prefetch.c
> > index 2fecfd68..5a725a51 100644
> > --- a/repair/prefetch.c
> > +++ b/repair/prefetch.c
> > @@ -710,17 +710,12 @@ pf_queuing_worker(
> >  	int			num_inos;
> >  	ino_tree_node_t		*irec;
> >  	ino_tree_node_t		*cur_irec;
> > -	int			blks_per_cluster;
> >  	xfs_agblock_t		bno;
> >  	int			i;
> >  	int			err;
> >  	uint64_t		sparse;
> >  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> >  
> > -	blks_per_cluster = igeo->inode_cluster_size >> mp->m_sb.sb_blocklog;
> > -	if (blks_per_cluster == 0)
> > -		blks_per_cluster = 1;
> > -
> >  	for (i = 0; i < PF_THREAD_COUNT; i++) {
> >  		err = pthread_create(&args->io_threads[i], NULL,
> >  				pf_io_worker, args);
> > @@ -786,21 +781,22 @@ pf_queuing_worker(
> >  			struct xfs_buf_map	map;
> >  
> >  			map.bm_bn = XFS_AGB_TO_DADDR(mp, args->agno, bno);
> > -			map.bm_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
> > +			map.bm_len = XFS_FSB_TO_BB(mp,
> > +					M_IGEO(mp)->blocks_per_cluster);
> 
> 	igeo->blocks_per_cluster
> 
> >  
> >  			/*
> >  			 * Queue I/O for each non-sparse cluster. We can check
> >  			 * sparse state in cluster sized chunks as cluster size
> >  			 * is the min. granularity of sparse irec regions.
> >  			 */
> > -			if ((sparse & ((1ULL << inodes_per_cluster) - 1)) == 0)
> > +			if ((sparse & ((1ULL << M_IGEO(mp)->inodes_per_cluster) - 1)) == 0)
> 
> 	igeo->inodes_per_cluster and 80 columns....

Will fix.

--D

> Otherwise,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
