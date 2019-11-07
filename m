Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595FDC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 22:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D1282187F
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 22:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yj6aanFT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfKGWoB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 17:44:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47480 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfKGWoB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 17:44:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7Mhv3q088357;
        Thu, 7 Nov 2019 22:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=EvoHIHTBO8noy+TE/Povufr7GA86MaEf1BdYjUAUm1U=;
 b=Yj6aanFTnLFzQ8Q5SHs385/LAB2A+NwGIolt32hqE4vFh0oG6reqW0LbgH5KHjqLaqcj
 9aniS1MPL6EW2X4BHfELbFX/UaN3H39aWq2cMMb09eXVuurqHSrjA99C96MmKmKO9j+r
 d61y8LJKLhDe2IVX/ZCZ+xdAoeFh81PdcpIkkSEyAd8VszusMUvvr+1UbNShU55sHOZf
 yJA53JssDAHuqoVlN9ePXKtgpBuAKxRgXMH1oi6RzET8UprXW7j3TBJ49g7WZ4rvKDhv
 8FEIcZe3pIF3RQV3Gz0e5fDPiRZCz7ZJol+W0wOBfQd29j1AldUg6zabZLelExdRspyR Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w41w19gr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 22:43:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7Mhjlq116227;
        Thu, 7 Nov 2019 22:43:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w41wayvx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 22:43:52 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA7MhpAC021657;
        Thu, 7 Nov 2019 22:43:51 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 14:43:51 -0800
Date:   Thu, 7 Nov 2019 14:43:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/46] xfs: refactor btree node scrubbing
Message-ID: <20191107224350.GM6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:23:27PM +0100, Christoph Hellwig wrote:
> Break up xchk_da_btree_entry and handle looking up leaf node entries
> in the attr / dir callbacks, so that only the generic node handling
> is left in the common core code.  Note that the checks for the crc
> enabled blocks are removed, as the scrubbing code already remaps the
> magic numbers earlier.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/attr.c    | 11 +++++-----
>  fs/xfs/scrub/dabtree.c | 48 ++++++++++--------------------------------
>  fs/xfs/scrub/dabtree.h |  3 +--
>  fs/xfs/scrub/dir.c     | 12 ++++++++---
>  4 files changed, 27 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 0edc7f8eb96e..d9f0dd444b80 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -398,15 +398,14 @@ xchk_xattr_block(
>  STATIC int
>  xchk_xattr_rec(
>  	struct xchk_da_btree		*ds,
> -	int				level,
> -	void				*rec)
> +	int				level)
>  {
>  	struct xfs_mount		*mp = ds->state->mp;
> -	struct xfs_attr_leaf_entry	*ent = rec;
> -	struct xfs_da_state_blk		*blk;
> +	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
>  	struct xfs_attr_leaf_name_local	*lentry;
>  	struct xfs_attr_leaf_name_remote	*rentry;
>  	struct xfs_buf			*bp;
> +	struct xfs_attr_leaf_entry	*ent;
>  	xfs_dahash_t			calc_hash;
>  	xfs_dahash_t			hash;
>  	int				nameidx;
> @@ -414,7 +413,9 @@ xchk_xattr_rec(
>  	unsigned int			badflags;
>  	int				error;
>  
> -	blk = &ds->state->path.blk[level];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +
> +	ent = xfs_attr3_leaf_entryp(blk->bp->b_addr) + blk->index;
>  
>  	/* Check the whole block, if necessary. */
>  	error = xchk_xattr_block(ds, level);
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 77ff9f97bcda..d1248c223c7f 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -77,40 +77,17 @@ xchk_da_set_corrupt(
>  			__return_address);
>  }
>  
> -/* Find an entry at a certain level in a da btree. */
> -STATIC void *
> -xchk_da_btree_entry(
> -	struct xchk_da_btree	*ds,
> -	int			level,
> -	int			rec)
> +static struct xfs_da_node_entry *
> +xchk_da_btree_node_entry(
> +	struct xchk_da_btree		*ds,
> +	int				level)
>  {
> -	char			*ents;
> -	struct xfs_da_state_blk	*blk;
> -	void			*baddr;
> +	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
>  
> -	/* Dispatch the entry finding function. */
> -	blk = &ds->state->path.blk[level];
> -	baddr = blk->bp->b_addr;
> -	switch (blk->magic) {
> -	case XFS_ATTR_LEAF_MAGIC:
> -	case XFS_ATTR3_LEAF_MAGIC:
> -		ents = (char *)xfs_attr3_leaf_entryp(baddr);
> -		return ents + (rec * sizeof(struct xfs_attr_leaf_entry));
> -	case XFS_DIR2_LEAFN_MAGIC:
> -	case XFS_DIR3_LEAFN_MAGIC:
> -		ents = (char *)ds->dargs.dp->d_ops->leaf_ents_p(baddr);
> -		return ents + (rec * sizeof(struct xfs_dir2_leaf_entry));
> -	case XFS_DIR2_LEAF1_MAGIC:
> -	case XFS_DIR3_LEAF1_MAGIC:
> -		ents = (char *)ds->dargs.dp->d_ops->leaf_ents_p(baddr);
> -		return ents + (rec * sizeof(struct xfs_dir2_leaf_entry));
> -	case XFS_DA_NODE_MAGIC:
> -	case XFS_DA3_NODE_MAGIC:
> -		ents = (char *)ds->dargs.dp->d_ops->node_tree_p(baddr);
> -		return ents + (rec * sizeof(struct xfs_da_node_entry));
> -	}
> +	ASSERT(blk->magic == XFS_DA_NODE_MAGIC);
>  
> -	return NULL;
> +	return (void *)ds->dargs.dp->d_ops->node_tree_p(blk->bp->b_addr) +
> +		(blk->index * sizeof(struct xfs_da_node_entry));
>  }
>  
>  /* Scrub a da btree hash (key). */
> @@ -136,7 +113,7 @@ xchk_da_btree_hash(
>  
>  	/* Is this hash no larger than the parent hash? */
>  	blks = ds->state->path.blk;
> -	entry = xchk_da_btree_entry(ds, level - 1, blks[level - 1].index);

This eliminates the only user of blks, which means the variable can be
removed.  The rest looks fine though.

--D

> +	entry = xchk_da_btree_node_entry(ds, level - 1);
>  	parent_hash = be32_to_cpu(entry->hashval);
>  	if (parent_hash < hash)
>  		xchk_da_set_corrupt(ds, level);
> @@ -479,7 +456,6 @@ xchk_da_btree(
>  	struct xfs_mount		*mp = sc->mp;
>  	struct xfs_da_state_blk		*blks;
>  	struct xfs_da_node_entry	*key;
> -	void				*rec;
>  	xfs_dablk_t			blkno;
>  	int				level;
>  	int				error;
> @@ -538,9 +514,7 @@ xchk_da_btree(
>  			}
>  
>  			/* Dispatch record scrubbing. */
> -			rec = xchk_da_btree_entry(&ds, level,
> -					blks[level].index);
> -			error = scrub_fn(&ds, level, rec);
> +			error = scrub_fn(&ds, level);
>  			if (error)
>  				break;
>  			if (xchk_should_terminate(sc, &error) ||
> @@ -562,7 +536,7 @@ xchk_da_btree(
>  		}
>  
>  		/* Hashes in order for scrub? */
> -		key = xchk_da_btree_entry(&ds, level, blks[level].index);
> +		key = xchk_da_btree_node_entry(&ds, level);
>  		error = xchk_da_btree_hash(&ds, level, &key->hashval);
>  		if (error)
>  			goto out;
> diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
> index cb3f0003245b..1f3515c6d5a8 100644
> --- a/fs/xfs/scrub/dabtree.h
> +++ b/fs/xfs/scrub/dabtree.h
> @@ -28,8 +28,7 @@ struct xchk_da_btree {
>  	int			tree_level;
>  };
>  
> -typedef int (*xchk_da_btree_rec_fn)(struct xchk_da_btree *ds,
> -		int level, void *rec);
> +typedef int (*xchk_da_btree_rec_fn)(struct xchk_da_btree *ds, int level);
>  
>  /* Check for da btree operation errors. */
>  bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 1e2e11721eb9..97f274f7cd38 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -179,14 +179,14 @@ xchk_dir_actor(
>  STATIC int
>  xchk_dir_rec(
>  	struct xchk_da_btree		*ds,
> -	int				level,
> -	void				*rec)
> +	int				level)
>  {
> +	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
>  	struct xfs_mount		*mp = ds->state->mp;
> -	struct xfs_dir2_leaf_entry	*ent = rec;
>  	struct xfs_inode		*dp = ds->dargs.dp;
>  	struct xfs_dir2_data_entry	*dent;
>  	struct xfs_buf			*bp;
> +	struct xfs_dir2_leaf_entry	*ent;
>  	char				*p, *endp;
>  	xfs_ino_t			ino;
>  	xfs_dablk_t			rec_bno;
> @@ -198,6 +198,12 @@ xchk_dir_rec(
>  	unsigned int			tag;
>  	int				error;
>  
> +	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
> +	       blk->magic == XFS_DIR2_LEAFN_MAGIC);
> +
> +	ent = (void *)ds->dargs.dp->d_ops->leaf_ents_p(blk->bp->b_addr) +
> +		(blk->index * sizeof(struct xfs_dir2_leaf_entry));
> +
>  	/* Check the hash of the entry. */
>  	error = xchk_da_btree_hash(ds, level, &ent->hashval);
>  	if (error)
> -- 
> 2.20.1
> 
