Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3D4CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8B462084D
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:08:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RG7uJsWo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfKDUIQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:08:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40504 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbfKDUIQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:08:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4JxSvL080275;
        Mon, 4 Nov 2019 20:08:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=IQ71z2+0Szw06df7vERLE/fLeuvn4kt5RnJuPq63+34=;
 b=RG7uJsWoVUUknEXX5JLlL7HuN6uBAlBzR0HUJQZt3wxEvF/C/LiGe9S0qbQ46rW2ATcr
 AydxbkwU/kII0hVpJlsLJjFYV9UD0EbIJa+68F/ZvFJBez8L+5misSXp2K3/81MbwqkV
 g8SKqpOWHIJWNGVRSwxs+uaxDiz4Lah12mX1Nyja/qGC+8Ufw1qc1JR2g3P+YQEZwUVb
 NDI7sLqshGMDn3JhLMl8z+prD+1xw5vAetmR5XdYab9tSiPP7j07CTZvmNG2bY/Jr4ui
 CQB+tsfXc79vspJhtgmBb/WiJURFQPj086KJ460ZmjNrMo2YdZEPatdarICtErVTwbc5 PQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w12er1me6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:08:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4K8AHC013070;
        Mon, 4 Nov 2019 20:08:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w1k8ve2mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:08:11 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4K7k08021361;
        Mon, 4 Nov 2019 20:07:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:07:45 -0800
Date:   Mon, 4 Nov 2019 12:07:44 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/34] xfs: move the max dir2 leaf entries count to
 struct xfs_da_geometry
Message-ID: <20191104200744.GL4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-12-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040193
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:06:56PM -0700, Christoph Hellwig wrote:
> Move the max leaf entries count towards our structure for dir/attr
> geometry parameters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_da_btree.h  |  1 +
>  fs/xfs/libxfs/xfs_da_format.c | 23 -----------------------
>  fs/xfs/libxfs/xfs_dir2.c      |  2 ++
>  fs/xfs/libxfs/xfs_dir2.h      |  2 --
>  fs/xfs/libxfs/xfs_dir2_leaf.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_node.c |  2 +-
>  fs/xfs/scrub/dir.c            |  3 +--
>  7 files changed, 6 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 5e3e954fee77..c8b137685ca7 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -27,6 +27,7 @@ struct xfs_da_geometry {
>  	int		magicpct;	/* 37% of block size in bytes */
>  	xfs_dablk_t	datablk;	/* blockno of dir data v2 */
>  	int		leaf_hdr_size;	/* dir2 leaf header size */
> +	unsigned int	leaf_max_ents;	/* # of entries in dir2 leaf */

Why does this one get 'unsigned' but the header size fields don't?
Or maybe I should rephase that: Why aren't the header sizes unsigned
too?

Looks good to me otherwise,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
>  	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
>  };
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index a3e87f4788e0..fe9e20698719 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -401,23 +401,6 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
>  }
>  
>  
> -/*
> - * Directory Leaf block operations
> - */
> -static int
> -xfs_dir2_max_leaf_ents(struct xfs_da_geometry *geo)
> -{
> -	return (geo->blksize - sizeof(struct xfs_dir2_leaf_hdr)) /
> -		(uint)sizeof(struct xfs_dir2_leaf_entry);
> -}
> -
> -static int
> -xfs_dir3_max_leaf_ents(struct xfs_da_geometry *geo)
> -{
> -	return (geo->blksize - sizeof(struct xfs_dir3_leaf_hdr)) /
> -		(uint)sizeof(struct xfs_dir2_leaf_entry);
> -}
> -
>  /*
>   * Directory free space block operations
>   */
> @@ -570,8 +553,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
> -	.leaf_max_ents = xfs_dir2_max_leaf_ents,
> -
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
>  	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
> @@ -611,8 +592,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
> -	.leaf_max_ents = xfs_dir2_max_leaf_ents,
> -
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
>  	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
> @@ -652,8 +631,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_entry_p = xfs_dir3_data_entry_p,
>  	.data_unused_p = xfs_dir3_data_unused_p,
>  
> -	.leaf_max_ents = xfs_dir3_max_leaf_ents,
> -
>  	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
>  	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
>  	.free_hdr_from_disk = xfs_dir3_free_hdr_from_disk,
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 94badb28fd1a..9f88b9885747 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -129,6 +129,8 @@ xfs_da_mount(
>  		dageo->node_hdr_size = sizeof(struct xfs_da_node_hdr);
>  		dageo->leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr);
>  	}
> +	dageo->leaf_max_ents = (dageo->blksize - dageo->leaf_hdr_size) /
> +			sizeof(struct xfs_dir2_leaf_entry);
>  
>  	/*
>  	 * Now we've set up the block conversion variables, we can calculate the
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 544adee5dd12..ee18fc56a6a1 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -72,8 +72,6 @@ struct xfs_dir_ops {
>  	struct xfs_dir2_data_unused *
>  		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
>  
> -	int	(*leaf_max_ents)(struct xfs_da_geometry *geo);
> -
>  	int	free_hdr_size;
>  	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
>  				    struct xfs_dir3_icfree_hdr *from);
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index f72fd8182223..38d42fe1aa02 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -167,7 +167,7 @@ xfs_dir3_leaf_check_int(
>  	 * Should factor in the size of the bests table as well.
>  	 * We can deduce a value for that from di_size.
>  	 */
> -	if (hdr->count > ops->leaf_max_ents(geo))
> +	if (hdr->count > geo->leaf_max_ents)
>  		return __this_address;
>  
>  	/* Leaves and bests don't overlap in leaf format. */
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 76f31909376e..3b9ed6ac72b6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -455,7 +455,7 @@ xfs_dir2_leafn_add(
>  	 * a compact.
>  	 */
>  
> -	if (leafhdr.count == dp->d_ops->leaf_max_ents(args->geo)) {
> +	if (leafhdr.count == args->geo->leaf_max_ents) {
>  		if (!leafhdr.stale)
>  			return -ENOSPC;
>  		compact = leafhdr.stale > 1;
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 27fdf8978467..e4e189d3c1c0 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -487,7 +487,6 @@ xchk_directory_leaf1_bestfree(
>  	struct xfs_dir2_leaf		*leaf;
>  	struct xfs_buf			*dbp;
>  	struct xfs_buf			*bp;
> -	const struct xfs_dir_ops	*d_ops = sc->ip->d_ops;
>  	struct xfs_da_geometry		*geo = sc->mp->m_dir_geo;
>  	__be16				*bestp;
>  	__u16				best;
> @@ -527,7 +526,7 @@ xchk_directory_leaf1_bestfree(
>  	}
>  
>  	/* Is the leaf count even remotely sane? */
> -	if (leafhdr.count > d_ops->leaf_max_ents(geo)) {
> +	if (leafhdr.count > geo->leaf_max_ents) {
>  		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  		goto out;
>  	}
> -- 
> 2.20.1
> 
