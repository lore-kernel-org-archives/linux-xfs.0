Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF41C35247
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 23:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 429A42087E
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 23:15:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dVQ3M2UC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgBDXPx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 18:15:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35242 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbgBDXPx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 18:15:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014NEBrq066816;
        Tue, 4 Feb 2020 23:14:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=hFrekGjJCQPPD/ycmhpFS48G3WlS5enZvj/4V+ln+dA=;
 b=dVQ3M2UCmhd+TPb2kYOsmHp54Qv4ky1uvrpZ0uLF2Q+FHXLS8VND76gCl/FaCrniiqmx
 UpHQ5OHvYIzs3IZP+1lI1XWi4dZ0GSS4Ev8t/NpQqbJ3Y/dCX6lqnOcg2MxaLKVfNOM8
 +j+34uaKV6q7YvUrRnMlzuAAn8dQ0BdEas4cfrTkFB54OxepLIyyNE581NZiw3ZROwFC
 Y9z72ZY3phMrd6XyKaDsswW7i/ZpCgl3TXLcoRX0QnOWMYpf98z2PiLC2gNsL+/Y+Vly
 iVV4rHm6s9+L6mECdHIHlirefnQpDhXQUAp8yoa66vGMY5x6YFpCcYah2kQ+MsbAc+Ps aA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xyhkfg3v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 23:14:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014ND9YZ160297;
        Tue, 4 Feb 2020 23:14:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xyhmesp3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 23:14:44 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 014NEhhr032466;
        Tue, 4 Feb 2020 23:14:43 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 15:14:43 -0800
Date:   Tue, 4 Feb 2020 15:14:42 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 11/8] xfs_repair: don't corrupt a attr fork da3 node
 when clearing forw/back
Message-ID: <20200204231442.GE6874@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <20200130181512.GZ3447196@magnolia>
 <20200130184606.GC3447196@magnolia>
 <20200131060315.GA26786@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131060315.GA26786@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2001150001 definitions=main-2002040158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-2001150001
 definitions=main-2002040158
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 10:03:15PM -0800, Christoph Hellwig wrote:
> Looks sensible, but I think we want the helpers for both the node and
> leaf case, something like this untested patch:

Ok, I was about to repost with more or less the same code.

--D

> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 9a44f610..0c26f0e6 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -952,6 +952,98 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
>  	return 0;
>  }
>  
> +static int
> +process_leaf_da_root(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	struct xfs_dinode	*dip,
> +	struct blkmap		*blkmap,
> +	int			*repair,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_attr3_icleaf_hdr leafhdr;
> +	xfs_dahash_t		next_hashval;
> +	int			repairlinks = 0;
> +
> +	/*
> +	 * Check sibling pointers in block 0 before we have to release the btree
> +	 * block.
> +	 */
> +	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
> +	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
> +		if (!no_modify)  {
> +			do_warn(
> +	_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
> +				ino);
> +			repairlinks = 1;
> +			leafhdr.forw = 0;
> +			leafhdr.back = 0;
> +			xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, bp->b_addr,
> +					&leafhdr);
> +		} else  {
> +			do_warn(
> +	_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
> +		}
> +	}
> +
> +	if (process_leaf_attr_block(mp, bp->b_addr, 0, ino, blkmap, 0,
> +			&next_hashval, repair)) {
> +		*repair = 0;
> +		/* the block is bad.  lose the attribute fork. */
> +		libxfs_putbuf(bp);
> +		return 1;
> +	}
> +
> +	*repair = *repair || repairlinks;
> +	return 0;
> +}
> +
> +static int
> +process_node_da_root(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	struct xfs_dinode	*dip,
> +	struct blkmap		*blkmap,
> +	int			*repair,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_da3_icnode_hdr	da3_hdr;
> +	int			repairlinks = 0;
> +	int			error;
> +
> +	/*
> +	 * Check sibling pointers in block 0 before we have to release the btree
> +	 * block.
> +	 */
> +	xfs_da3_node_hdr_from_disk(mp, &da3_hdr, bp->b_addr);
> +	if (da3_hdr.forw != 0 || da3_hdr.back != 0)  {
> +		if (!no_modify)  {
> +			do_warn(
> +_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
> +				ino);
> +
> +			repairlinks = 1;
> +			da3_hdr.forw = 0;
> +			da3_hdr.back = 0;
> +			xfs_da3_node_hdr_to_disk(mp, bp->b_addr, &da3_hdr);
> +		} else  {
> +			do_warn(
> +_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
> +		}
> +	}
> +
> +	/* must do this now, to release block 0 before the traversal */
> +	if ((*repair || repairlinks) && !no_modify) {
> +		*repair = 1;
> +		libxfs_writebuf(bp, 0);
> +	} else
> +		libxfs_putbuf(bp);
> +	error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
> +	if (error)
> +		*repair = 0;
> +	return error;
> +}
> +
>  /*
>   * Start processing for a leaf or fuller btree.
>   * A leaf directory is one where the attribute fork is too big for
> @@ -963,19 +1055,15 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
>   */
>  static int
>  process_longform_attr(
> -	xfs_mount_t	*mp,
> -	xfs_ino_t	ino,
> -	xfs_dinode_t	*dip,
> -	blkmap_t	*blkmap,
> -	int		*repair)	/* out - 1 if something was fixed */
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	struct xfs_dinode	*dip,
> +	blkmap_t		*blkmap,
> +	int			*repair) /* out - 1 if something was fixed */
>  {
> -	xfs_attr_leafblock_t	*leaf;
> -	xfs_fsblock_t	bno;
> -	xfs_buf_t	*bp;
> -	xfs_dahash_t	next_hashval;
> -	int		repairlinks = 0;
> -	struct xfs_attr3_icleaf_hdr leafhdr;
> -	int		error;
> +	xfs_fsblock_t		bno;
> +	struct xfs_buf		*bp;
> +	struct xfs_da_blkinfo   *info;
>  
>  	*repair = 0;
>  
> @@ -1015,77 +1103,35 @@ process_longform_attr(
>  		return 1;
>  	}
>  
> -	/* verify leaf block */
> -	leaf = bp->b_addr;
> -	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
> -
> -	/* check sibling pointers in leaf block or root block 0 before
> -	* we have to release the btree block
> -	*/
> -	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
> -		if (!no_modify)  {
> -			do_warn(
> -	_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
> -				ino);
> -			repairlinks = 1;
> -			leafhdr.forw = 0;
> -			leafhdr.back = 0;
> -			xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo,
> -						   leaf, &leafhdr);
> -		} else  {
> -			do_warn(
> -	_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
> -		}
> -	}
> -
>  	/*
>  	 * use magic number to tell us what type of attribute this is.
>  	 * it's possible to have a node or leaf attribute in either an
>  	 * extent format or btree format attribute fork.
>  	 */
> -	switch (leafhdr.magic) {
> +	info = bp->b_addr;
> +	switch (be16_to_cpu(info->magic)) {
>  	case XFS_ATTR_LEAF_MAGIC:	/* leaf-form attribute */
>  	case XFS_ATTR3_LEAF_MAGIC:
> -		if (process_leaf_attr_block(mp, leaf, 0, ino, blkmap,
> -				0, &next_hashval, repair)) {
> -			*repair = 0;
> -			/* the block is bad.  lose the attribute fork. */
> -			libxfs_putbuf(bp);
> -			return(1);
> -		}
> -		*repair = *repair || repairlinks;
> -		break;
> -
> +		return process_leaf_da_root(mp, ino, dip, blkmap, repair, bp);
>  	case XFS_DA_NODE_MAGIC:		/* btree-form attribute */
>  	case XFS_DA3_NODE_MAGIC:
> -		/* must do this now, to release block 0 before the traversal */
> -		if ((*repair || repairlinks) && !no_modify) {
> -			*repair = 1;
> -			libxfs_writebuf(bp, 0);
> -		} else
> -			libxfs_putbuf(bp);
> -		error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
> -		if (error)
> -			*repair = 0;
> -		return error;
> +		return process_node_da_root(mp, ino, dip, blkmap, repair, bp);
>  	default:
>  		do_warn(
>  	_("bad attribute leaf magic # %#x for dir ino %" PRIu64 "\n"),
> -			be16_to_cpu(leaf->hdr.info.magic), ino);
> +			be16_to_cpu(info->magic), ino);
>  		libxfs_putbuf(bp);
>  		*repair = 0;
> -		return(1);
> +		return 1;
>  	}
>  
>  	if (*repair && !no_modify)
>  		libxfs_writebuf(bp, 0);
>  	else
>  		libxfs_putbuf(bp);
> -
> -	return(0);  /* repair may be set */
> +	return 0;  /* repair may be set */
>  }
>  
> -
>  static int
>  xfs_acl_from_disk(
>  	struct xfs_mount	*mp,
