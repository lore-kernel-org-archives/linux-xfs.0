Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587B5C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24762206B6
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MzDvK/wC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731140AbgEVXKM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 19:10:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47882 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731117AbgEVXKM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 19:10:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMvOkC177095;
        Fri, 22 May 2020 23:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YvD9pR88o28u9CXOSy9Ds3uSW52OUVZp5UCxwHvpvWM=;
 b=MzDvK/wCo0C57E63OCvEbgGvoHiHraHEzWI81fXVNmWj/cE36bgQfePSnnaZiXexSSHQ
 Atz1FgXku9UaG9RWGFtDpYfPpXgFHt5C3RikpG1PGmu9RVoIooEo8zk9GkcD3TywGgAC
 a5oF5U/cLO8oIKUUPpqgiiZWEFam/0ViplBIy/LlCoNGYsKFCVRVn1/+35gvJK71kmVb
 ovyCGV08zTV9PnD873bACt+/oLngugeLipzl+IYBGgr4F1vcG2BDKSUpCCkcFgoZ43NO
 oN+C1GCtWBH9w31o/Uige6lqMDC8NRD9//8qlljC4cr/yQeJMs73U2hpfUm0Dlcv2Unw GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127krr3q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:10:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMwadt032259;
        Fri, 22 May 2020 23:10:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gmby4tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:10:09 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MNA890030654;
        Fri, 22 May 2020 23:10:09 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:10:08 -0700
Date:   Fri, 22 May 2020 16:10:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/24] xfs: allow multiple reclaimers per AG
Message-ID: <20200522231007.GS8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-16-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-16-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=5
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=5 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:20PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inode reclaim will still throttle direct reclaim on the per-ag
> reclaim locks. This is no longer necessary as reclaim can run
> non-blocking now. Hence we can remove these locks so that we don't
> arbitrarily block reclaimers just because there are more direct
> reclaimers than there are AGs.
> 
> This can result in multiple reclaimers working on the same range of
> an AG, but this doesn't cause any apparent issues. Optimising the
> spread of concurrent reclaimers for best efficiency can be done in a
> future patchset.

"Future patchset" as in "not in the 9 patches that I have left to read"?

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 28 +++++++---------------------
>  fs/xfs/xfs_mount.c  |  4 ----
>  fs/xfs/xfs_mount.h  |  1 -
>  3 files changed, 7 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index ee9bc82a0dfbe..f44493b2eae77 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1226,12 +1226,9 @@ xfs_reclaim_inodes_ag(
>  	int			*nr_to_scan)
>  {
>  	struct xfs_perag	*pag;
> -	xfs_agnumber_t		ag;
> -	int			trylock = flags & SYNC_TRYLOCK;
> -	int			skipped;
> +	xfs_agnumber_t		ag = 0;
> +	int			skipped = 0;
>  
> -	ag = 0;
> -	skipped = 0;
>  	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
>  		unsigned long	first_index = 0;
>  		int		done = 0;
> @@ -1239,16 +1236,7 @@ xfs_reclaim_inodes_ag(
>  
>  		ag = pag->pag_agno + 1;
>  
> -		if (trylock) {
> -			if (!mutex_trylock(&pag->pag_ici_reclaim_lock)) {
> -				skipped++;
> -				xfs_perag_put(pag);
> -				continue;
> -			}
> -			first_index = pag->pag_ici_reclaim_cursor;
> -		} else
> -			mutex_lock(&pag->pag_ici_reclaim_lock);
> -
> +		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);
>  		do {
>  			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
>  			int	i;
> @@ -1313,11 +1301,9 @@ xfs_reclaim_inodes_ag(
>  
>  		} while (nr_found && !done && *nr_to_scan > 0);
>  
> -		if (trylock && !done)
> -			pag->pag_ici_reclaim_cursor = first_index;
> -		else
> -			pag->pag_ici_reclaim_cursor = 0;
> -		mutex_unlock(&pag->pag_ici_reclaim_lock);
> +		if (done)
> +			first_index = 0;
> +		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
>  		xfs_perag_put(pag);
>  	}
>  	return skipped;
> @@ -1331,7 +1317,7 @@ xfs_reclaim_inodes(
>  	int		nr_to_scan = INT_MAX;
>  	int		skipped;
>  
> -	skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> +	xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);

This could go in the previous patch, right?

The rest of this patch looks reasonable, so with that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	if (!(mode & SYNC_WAIT))
>  		return 0;
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index d5dcf98698600..03158b42a1943 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -148,7 +148,6 @@ xfs_free_perag(
>  		ASSERT(atomic_read(&pag->pag_ref) == 0);
>  		xfs_iunlink_destroy(pag);
>  		xfs_buf_hash_destroy(pag);
> -		mutex_destroy(&pag->pag_ici_reclaim_lock);
>  		call_rcu(&pag->rcu_head, __xfs_free_perag);
>  	}
>  }
> @@ -200,7 +199,6 @@ xfs_initialize_perag(
>  		pag->pag_agno = index;
>  		pag->pag_mount = mp;
>  		spin_lock_init(&pag->pag_ici_lock);
> -		mutex_init(&pag->pag_ici_reclaim_lock);
>  		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
>  		if (xfs_buf_hash_init(pag))
>  			goto out_free_pag;
> @@ -242,7 +240,6 @@ xfs_initialize_perag(
>  out_hash_destroy:
>  	xfs_buf_hash_destroy(pag);
>  out_free_pag:
> -	mutex_destroy(&pag->pag_ici_reclaim_lock);
>  	kmem_free(pag);
>  out_unwind_new_pags:
>  	/* unwind any prior newly initialized pags */
> @@ -252,7 +249,6 @@ xfs_initialize_perag(
>  			break;
>  		xfs_buf_hash_destroy(pag);
>  		xfs_iunlink_destroy(pag);
> -		mutex_destroy(&pag->pag_ici_reclaim_lock);
>  		kmem_free(pag);
>  	}
>  	return error;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 3725d25ad97e8..a72cfcaa4ad12 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -354,7 +354,6 @@ typedef struct xfs_perag {
>  	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
>  	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
>  	int		pag_ici_reclaimable;	/* reclaimable inodes */
> -	struct mutex	pag_ici_reclaim_lock;	/* serialisation point */
>  	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
>  
>  	/* buffer cache index */
> -- 
> 2.26.2.761.g0e0b3e54be
> 
