Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E53CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 865DD2084D
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:04:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gMBnoRzm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbfKDUEo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:04:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36980 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729091AbfKDUEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:04:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4JxPC1080252;
        Mon, 4 Nov 2019 20:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=mxCUiASWDHcDpQ32gLEHsn9MqMWq9ziX+3ymAlbcINQ=;
 b=gMBnoRzm0FAWLvMTm2A8atjHdaFEMqAeaA+NbC7bG24W4esRavHEBCsnL58zUPP2gc4X
 aX0C3wtH6StlKhGpiIbg95c4b+/5SKrWq+k4O/M0cohVfgJPYl3GXj+C7F6xdxqb7I+5
 AMhZhz6xGiDul5u/tFwQZMvewvdhHXOCIi8VpWLFwGZcKnihHoQbmbhdllfzVkfX4PXv
 L1dS6TtW2lrHTt7anZtkgo5IIljnYGOLeTsLHECZSRSyL9InzthEHhyVb6hMUDu3c+Fr
 trhULJ2StDx5q1pofbnmsVbftG+uUzGuN79E0K6pt+WK022DP15ilrCCpjBc4SiRuST1 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w12er1m0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:04:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4K3LJP076947;
        Mon, 4 Nov 2019 20:04:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w1kac6kyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:04:39 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4K4cwu018532;
        Mon, 4 Nov 2019 20:04:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:04:38 -0800
Date:   Mon, 4 Nov 2019 12:04:37 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/34] xfs: add a entries pointer to struct
 xfs_dir3_icleaf_hdr
Message-ID: <20191104200437.GJ4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-10-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:06:54PM -0700, Christoph Hellwig wrote:
> All callers of the ->node_tree_p dir operation already have a struct
> xfs_dir3_icleaf_hdr from a previous call to xfs_da_leaf_hdr_from_disk at
> hand, or just need slight changes to the calling conventions to do so.
> Add a pointer to the entries to struct xfs_dir3_icleaf_hdr to clean up
> this pattern.  To make this possible the xfs_dir3_leaf_log_ents function
> grow a new argument to pass the xfs_dir3_icleaf_hdr that call callers
> already have, and xfs_dir2_leaf_lookup_int returns the
> xfs_dir3_icleaf_hdr to the callers so that they can later use it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Mostly looks ok...

<snip>

> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index b402a2391f49..07cea5751783 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -18,6 +18,7 @@ struct xfs_dir3_icleaf_hdr {
>  	uint16_t		magic;
>  	uint16_t		count;
>  	uint16_t		stale;
> +	struct xfs_dir2_leaf_entry *ents;

...except for the same suggestion I had a few patches ago about being
more explicit that this is a pointer to an array of raw on-disk
structures which haven't been converted to cpu endianness.

--D

>  };
>  
>  struct xfs_dir3_icfree_hdr {
> @@ -25,7 +26,6 @@ struct xfs_dir3_icfree_hdr {
>  	uint32_t		firstdb;
>  	uint32_t		nvalid;
>  	uint32_t		nused;
> -
>  };
>  
>  /* xfs_dir2.c */
> @@ -86,7 +86,8 @@ extern void xfs_dir3_leaf_compact_x1(struct xfs_dir3_icleaf_hdr *leafhdr,
>  extern int xfs_dir3_leaf_get_buf(struct xfs_da_args *args, xfs_dir2_db_t bno,
>  		struct xfs_buf **bpp, uint16_t magic);
>  extern void xfs_dir3_leaf_log_ents(struct xfs_da_args *args,
> -		struct xfs_buf *bp, int first, int last);
> +		struct xfs_dir3_icleaf_hdr *hdr, struct xfs_buf *bp, int first,
> +		int last);
>  extern void xfs_dir3_leaf_log_header(struct xfs_da_args *args,
>  		struct xfs_buf *bp);
>  extern int xfs_dir2_leaf_lookup(struct xfs_da_args *args);
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 5b004d1f6bef..27fdf8978467 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -195,13 +195,15 @@ xchk_dir_rec(
>  	xfs_dir2_dataptr_t		ptr;
>  	xfs_dahash_t			calc_hash;
>  	xfs_dahash_t			hash;
> +	struct xfs_dir3_icleaf_hdr	hdr;
>  	unsigned int			tag;
>  	int				error;
>  
>  	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
>  	       blk->magic == XFS_DIR2_LEAFN_MAGIC);
>  
> -	ent = (void *)ds->dargs.dp->d_ops->leaf_ents_p(blk->bp->b_addr) +
> +	xfs_dir2_leaf_hdr_from_disk(mp, &hdr, blk->bp->b_addr);
> +	ent = (void *)hdr.ents +
>  		(blk->index * sizeof(struct xfs_dir2_leaf_entry));
>  
>  	/* Check the hash of the entry. */
> @@ -481,7 +483,6 @@ xchk_directory_leaf1_bestfree(
>  	xfs_dablk_t			lblk)
>  {
>  	struct xfs_dir3_icleaf_hdr	leafhdr;
> -	struct xfs_dir2_leaf_entry	*ents;
>  	struct xfs_dir2_leaf_tail	*ltp;
>  	struct xfs_dir2_leaf		*leaf;
>  	struct xfs_buf			*dbp;
> @@ -505,7 +506,6 @@ xchk_directory_leaf1_bestfree(
>  
>  	leaf = bp->b_addr;
>  	xfs_dir2_leaf_hdr_from_disk(sc->ip->i_mount, &leafhdr, leaf);
> -	ents = d_ops->leaf_ents_p(leaf);
>  	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
>  	bestcount = be32_to_cpu(ltp->bestcount);
>  	bestp = xfs_dir2_leaf_bests_p(ltp);
> @@ -533,18 +533,19 @@ xchk_directory_leaf1_bestfree(
>  	}
>  
>  	/* Leaves and bests don't overlap in leaf format. */
> -	if ((char *)&ents[leafhdr.count] > (char *)bestp) {
> +	if ((char *)&leafhdr.ents[leafhdr.count] > (char *)bestp) {
>  		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  		goto out;
>  	}
>  
>  	/* Check hash value order, count stale entries.  */
>  	for (i = 0; i < leafhdr.count; i++) {
> -		hash = be32_to_cpu(ents[i].hashval);
> +		hash = be32_to_cpu(leafhdr.ents[i].hashval);
>  		if (i > 0 && lasthash > hash)
>  			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>  		lasthash = hash;
> -		if (ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
> +		if (leafhdr.ents[i].address ==
> +		    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
>  			stale++;
>  	}
>  	if (leafhdr.stale != stale)
> -- 
> 2.20.1
> 
