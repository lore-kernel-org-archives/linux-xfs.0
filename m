Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C402BC3F68F
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 05:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90D7D2085B
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 05:29:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MY7rR/7a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgBEF3c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 00:29:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58436 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgBEF3c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 00:29:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155SlT6101112;
        Wed, 5 Feb 2020 05:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=uPYTjU0DkSElkbH2Py5aVQOipO6PoNzvHZsK5fyauAM=;
 b=MY7rR/7avrfe749UM8tY62Uldc0dNLLQRCtkJzyJx13w2otLO2UQo1ZQlA8LrrGasTca
 tpRVPfE8ADKSK1IOFZCcNyxw7sYRHwVeotMfW1xUe1LRXR8KfLSd6QFbt/if71fedOGS
 KprehYXHIn4E4ojDSxMPpfmPSoZ/l3bZDp6VKrj1jAAELPVby8kSryFmAmy7Qak/DWNk
 TKWHAiQXEyJFmKMQYO2eX88Z72MW8+1fSXaE6rX0KbRO8xKqkTSAPZRiEcV9HtCXy8Ln
 Lr7fYEdnhi3OS6XlpcOpzsHCsvFtTPqObMjzNUbcIdS6GpGp15Kg2emJs7n/ajqlwynE WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xykbp0s2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 05:29:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155SXfN110184;
        Wed, 5 Feb 2020 05:29:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xymursrva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 05:29:28 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0155TRvv031467;
        Wed, 5 Feb 2020 05:29:27 GMT
Received: from [192.168.1.9] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 21:29:27 -0800
Subject: Re: [PATCH 4/4] xfs_repair: don't corrupt a attr fork da3 node when
 clearing forw/back
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
 <158086359417.2079557.4428155306169446299.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7baaea32-91dc-353d-6de2-ccae5bd79a52@oracle.com>
Date:   Tue, 4 Feb 2020 22:29:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158086359417.2079557.4428155306169446299.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/4/20 5:46 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In process_longform_attr, we enforce that the root block of the
> attribute index must have both forw or back pointers set to zero.
> Unfortunately, the code that nulls out the pointers is not aware that
> the root block could be in da3 node format.
> 
> This leads to corruption of da3 root node blocks because the functions
> that convert attr3 leaf headers to and from the ondisk structures
> perform some interpretation of firstused on what they think is an attr1
> leaf block.
> 
> Found by using xfs/402 to fuzz hdr.info.hdr.forw.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   repair/attr_repair.c |  181 ++++++++++++++++++++++++++++++++------------------
>   1 file changed, 117 insertions(+), 64 deletions(-)
> 
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 7b26df33..535fcfbb 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -952,6 +952,106 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
>   	return 0;
>   }
>   
> +static int
> +process_longform_leaf_root(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	struct xfs_dinode	*dip,
> +	struct blkmap		*blkmap,
> +	int			*repair,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_attr3_icleaf_hdr leafhdr;
> +	xfs_dahash_t		next_hashval;
> +	int			badness;
"badness" pretty much just looks like "error" here?  Or is it different 
in some way?

> +	int			repairlinks = 0;
> +
> +	/*
> +	 * check sibling pointers in leaf block or root block 0 before
> +	 * we have to release the btree block
> +	 */
> +	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
> +	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
> +		if (!no_modify)  {
> +			do_warn(
> +_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
> +				ino);
> +			repairlinks = 1;
> +			leafhdr.forw = 0;
> +			leafhdr.back = 0;
> +			xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, bp->b_addr,
> +					&leafhdr);
> +		} else  {
> +			do_warn(
> +_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
> +		}
> +	}
> +
> +	badness = process_leaf_attr_block(mp, bp->b_addr, 0, ino, blkmap, 0,
> +			&next_hashval, repair);
> +	if (badness) {
> +		*repair = 0;
> +		/* the block is bad.  lose the attribute fork. */
> +		libxfs_putbuf(bp);
> +		return 1;
> +	}
> +
> +	*repair = *repair || repairlinks;
> +
> +	if (*repair && !no_modify)
> +		libxfs_writebuf(bp, 0);
> +	else
> +		libxfs_putbuf(bp);
> +
> +	return 0;
> +}
> +
> +static int
> +process_longform_da_root(
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
> +	libxfs_da3_node_hdr_from_disk(mp, &da3_hdr, bp->b_addr);
> +	/*
> +	 * check sibling pointers in leaf block or root block 0 before
> +	 * we have to release the btree block
> +	 */
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
Did you mean to reference *repair here without setting it?  I guess it 
was like that from the code it was taken from, but it makes it looks 
like repair is both an in and an out.  I wonder if it's really needed in 
the check below?

Allison

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
>   /*
>    * Start processing for a leaf or fuller btree.
>    * A leaf directory is one where the attribute fork is too big for
> @@ -963,19 +1063,15 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
>    */
>   static int
>   process_longform_attr(
> -	xfs_mount_t	*mp,
> -	xfs_ino_t	ino,
> -	xfs_dinode_t	*dip,
> -	blkmap_t	*blkmap,
> -	int		*repair)	/* out - 1 if something was fixed */
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	struct xfs_dinode	*dip,
> +	struct blkmap		*blkmap,
> +	int			*repair) /* out - 1 if something was fixed */
>   {
> -	xfs_attr_leafblock_t	*leaf;
> -	xfs_fsblock_t	bno;
> -	xfs_buf_t	*bp;
> -	xfs_dahash_t	next_hashval;
> -	int		repairlinks = 0;
> -	struct xfs_attr3_icleaf_hdr leafhdr;
> -	int		error;
> +	xfs_fsblock_t		bno;
> +	struct xfs_buf		*bp;
> +	struct xfs_da_blkinfo	*info;
>   
>   	*repair = 0;
>   
> @@ -1015,74 +1111,31 @@ process_longform_attr(
>   		return 1;
>   	}
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
>   	/*
>   	 * use magic number to tell us what type of attribute this is.
>   	 * it's possible to have a node or leaf attribute in either an
>   	 * extent format or btree format attribute fork.
>   	 */
> -	switch (leafhdr.magic) {
> +	info = bp->b_addr;
> +	switch (be16_to_cpu(info->magic)) {
>   	case XFS_ATTR_LEAF_MAGIC:	/* leaf-form attribute */
>   	case XFS_ATTR3_LEAF_MAGIC:
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
> +		return process_longform_leaf_root(mp, ino, dip, blkmap, repair,
> +				bp);
>   	case XFS_DA_NODE_MAGIC:		/* btree-form attribute */
>   	case XFS_DA3_NODE_MAGIC:
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
> +		return process_longform_da_root(mp, ino, dip, blkmap, repair,
> +				bp);
>   	default:
>   		do_warn(
>   	_("bad attribute leaf magic # %#x for dir ino %" PRIu64 "\n"),
> -			be16_to_cpu(leaf->hdr.info.magic), ino);
> +			be16_to_cpu(info->magic), ino);
>   		libxfs_putbuf(bp);
>   		*repair = 0;
> -		return(1);
> +		return 1;
>   	}
>   
> -	if (*repair && !no_modify)
> -		libxfs_writebuf(bp, 0);
> -	else
> -		libxfs_putbuf(bp);
> -
> -	return(0);  /* repair may be set */
> +	return 0; /* should never get here */
>   }
>   
>   
> 
