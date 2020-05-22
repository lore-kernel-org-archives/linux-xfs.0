Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8CCC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3202D206B6
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:14:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o2rKYNPu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbgEVXOk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 19:14:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50840 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731117AbgEVXOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 19:14:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MNBlxG004866;
        Fri, 22 May 2020 23:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hKyHBZxVExLpYgt3qao3x8rfBUoEaEA9fqM1aGyy7lg=;
 b=o2rKYNPuFx6409RVLFLSfsWLCPAzh0iNyqMkFjgJFCx0cuaCAbGkCytddwv4aJlwXs94
 UNCi1kBejN82Kn5cQ0DitQWm5C98bQAfhptKyaBIepv+Pwo2kfWZY7fmMbKrx9Bfylqa
 b1gQwdu8Dvs9SxDRDMy4ERBrYAlXoWh+L7GB+C3lthOW2dSj/ke2O22DeMvGizAEIvvn
 na8+GfgavrDTSaWx4SMas2rVKQvVwrNhIBYmJ6Pp7+kl6faP63wliIwNAh0dYQlczskH
 MujnLLwXG9mmmDFmG25UsVc6hSy9BbUQSuh0+OJdLIs1EOcVGb2GvD+/Y5wUnblUX8RW cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127krr44v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:14:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MNClsx144997;
        Fri, 22 May 2020 23:14:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 313gj8af1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:14:37 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MNEbO4015023;
        Fri, 22 May 2020 23:14:37 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:14:36 -0700
Date:   Fri, 22 May 2020 16:14:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/24] xfs: remove SYNC_TRYLOCK from inode reclaim
Message-ID: <20200522231435.GU8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-18-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-18-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220180
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:22PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> All background reclaim is SYNC_TRYLOCK already, and even blocking
> reclaim (SYNC_WAIT) can use trylock mechanisms as
> xfs_reclaim_inodes_ag() will keep cycling until there are no more
> reclaimable inodes. Hence we can kill SYNC_TRYLOCK from inode
> reclaim and make everything unconditionally non-blocking.

Random question: Does xfs_quiesce_attr need to call xfs_reclaim_inodes
twice now, or does the second SYNC_WAIT call suffice now?

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This patch itself looks fine though.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_icache.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index c020d2379e12e..8b366bc7b53c9 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1049,10 +1049,9 @@ xfs_inode_ag_iterator_tag(
>   * Grab the inode for reclaim exclusively.
>   * Return 0 if we grabbed it, non-zero otherwise.
>   */
> -STATIC int
> +static int
>  xfs_reclaim_inode_grab(
> -	struct xfs_inode	*ip,
> -	int			flags)
> +	struct xfs_inode	*ip)
>  {
>  	ASSERT(rcu_read_lock_held());
>  
> @@ -1061,12 +1060,10 @@ xfs_reclaim_inode_grab(
>  		return 1;
>  
>  	/*
> -	 * If we are asked for non-blocking operation, do unlocked checks to
> -	 * see if the inode already is being flushed or in reclaim to avoid
> -	 * lock traffic.
> +	 * Do unlocked checks to see if the inode already is being flushed or in
> +	 * reclaim to avoid lock traffic.
>  	 */
> -	if ((flags & SYNC_TRYLOCK) &&
> -	    __xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
> +	if (__xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
>  		return 1;
>  
>  	/*
> @@ -1133,8 +1130,7 @@ xfs_reclaim_inode_grab(
>  static bool
>  xfs_reclaim_inode(
>  	struct xfs_inode	*ip,
> -	struct xfs_perag	*pag,
> -	int			sync_mode)
> +	struct xfs_perag	*pag)
>  {
>  	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
>  
> @@ -1224,7 +1220,6 @@ xfs_reclaim_inode(
>  static int
>  xfs_reclaim_inodes_ag(
>  	struct xfs_mount	*mp,
> -	int			flags,
>  	int			*nr_to_scan)
>  {
>  	struct xfs_perag	*pag;
> @@ -1262,7 +1257,7 @@ xfs_reclaim_inodes_ag(
>  			for (i = 0; i < nr_found; i++) {
>  				struct xfs_inode *ip = batch[i];
>  
> -				if (done || xfs_reclaim_inode_grab(ip, flags))
> +				if (done || xfs_reclaim_inode_grab(ip))
>  					batch[i] = NULL;
>  
>  				/*
> @@ -1293,7 +1288,7 @@ xfs_reclaim_inodes_ag(
>  			for (i = 0; i < nr_found; i++) {
>  				if (!batch[i])
>  					continue;
> -				if (!xfs_reclaim_inode(batch[i], pag, flags))
> +				if (!xfs_reclaim_inode(batch[i], pag))
>  					skipped++;
>  			}
>  
> @@ -1319,13 +1314,13 @@ xfs_reclaim_inodes(
>  	int		nr_to_scan = INT_MAX;
>  	int		skipped;
>  
> -	xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
>  	if (!(mode & SYNC_WAIT))
>  		return 0;
>  
>  	do {
>  		xfs_ail_push_all_sync(mp->m_ail);
> -		skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +		skipped = xfs_reclaim_inodes_ag(mp, &nr_to_scan);
>  	} while (skipped > 0);
>  
>  	return 0;
> @@ -1349,7 +1344,7 @@ xfs_reclaim_inodes_nr(
>  	xfs_reclaim_work_queue(mp);
>  	xfs_ail_push_all(mp->m_ail);
>  
> -	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
> +	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
>  	return 0;
>  }
>  
> -- 
> 2.26.2.761.g0e0b3e54be
> 
