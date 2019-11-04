Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CF5CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 18:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD9D62089C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 18:36:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kN3IMrGU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfKDSgZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 13:36:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52882 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbfKDSgZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 13:36:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4IZ3gP008339;
        Mon, 4 Nov 2019 18:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=u+ELlW7nl5c4PWOWQRspED+m6b0V/fLpc2fwQgnkXZ4=;
 b=kN3IMrGUW7Esta6hyhuZZ7wEsz3CwA+eiMn8VypPtfHZatFMezbxczAvHzf1SxyUheZw
 BhHiH7nOz0oy21QKSxpN96n9QkONnN1xCX4cuI80sQezthWeyPtgPExF7Dwa4EedZsS9
 u/bpOtDM6n5RK5BtrOy+xOvRD41dVOJBrtu3wZCS/X2KN0AEuacl5OWjlOhD3Qf5Hdmn
 Bw+95M0hpXqLLm0bLioxiy1+swQjXJjG4/ZiIGao1iOdDKTTKHtcqMmhjPrhWmEZibkj
 YbqPK9oVWBRpsvZPmFxwLcGlLyvAGNej+415tm8E6ZVAJr/WuMwNoqFM3hZSMnw58EFF FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w12er14m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 18:36:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4IJWNR107013;
        Mon, 4 Nov 2019 18:36:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w1k8v9eta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 18:36:20 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4IaJXN026016;
        Mon, 4 Nov 2019 18:36:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 10:36:18 -0800
Date:   Mon, 4 Nov 2019 10:36:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/34] xfs: refactor btree node scrubbing
Message-ID: <20191104183617.GC4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040180
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:06:47PM -0700, Christoph Hellwig wrote:
> Break up xchk_da_btree_entry and handle looking up leaf node entries
> in the attr / dir callbacks, so that only the generic node handling
> is left in the common core code.  Note that the checks for the crc
> enabled blocks are removed, as the scrubbing code already remaps the
> magic numbers earlier.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/attr.c    | 12 ++++++-----
>  fs/xfs/scrub/dabtree.c | 48 ++++++++++--------------------------------
>  fs/xfs/scrub/dabtree.h |  3 +--
>  fs/xfs/scrub/dir.c     | 12 ++++++++---
>  4 files changed, 28 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 0edc7f8eb96e..035d5734e0af 100644
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
> @@ -414,7 +413,10 @@ xchk_xattr_rec(
>  	unsigned int			badflags;
>  	int				error;
>  
> -	blk = &ds->state->path.blk[level];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +
> +	ent = (void *)xfs_attr3_leaf_entryp(blk->bp->b_addr) +
> +		(blk->index * sizeof(struct xfs_attr_leaf_entry));

Seeing as this function returns a pointer to struct xfs_attr_leaf_entry,
why not clean this up to:

ent = xfs_attr3_leaf_entryp(...)[blk->index]; ?

Though looking at that, I wonder if a better option would be to
incorporate the index as an argument to xfs_attr3_leaf_entryp?

(And yes, that's material for a separate patch...)

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

gcc complained that blks is no longer necessary.

--D

> -	entry = xchk_da_btree_entry(ds, level - 1, blks[level - 1].index);
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
