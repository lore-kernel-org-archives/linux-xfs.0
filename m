Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E86C35249
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 05:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE96321927
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 05:59:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MiP+AliN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbgBEF7W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 00:59:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgBEF7W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 00:59:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155xISL142977;
        Wed, 5 Feb 2020 05:59:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=zDN+qd4GcN9taJGxXDAm8eJ1KwhkWGdBf8qDegdqzW8=;
 b=MiP+AliNDjIPuLhL+ebGa8Ew550bl+YmrEnSxxLmUEYbFHcTetUpnzkKwIr+hTfHhyzZ
 XEXfe5TtDcF302ZDvEcv9fkfC6tOAZd/rgkOP2wWozVkSYEvSmIMDb4t8vjMd7CGCg1K
 aBwYUNyMpoZ/bPn8ToxMs0ROSd3iG0jGedOnX5ljJHky+B/4Pg0MM8N+cRwzeWypERXW
 oz8W7YMhDMFb2yADupRpBoEIwYuxH4Ya2tFh5PqdNZnTvX6jARluDlIimGiLrLU9dFWQ
 KjgpwOiWf35kOhvToD0dmXR5TQcCxzl1Q+evyKeVrx+vg3m4+PB5G5teikxStz/utBtj Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xykbp0v51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 05:59:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155xGHK147248;
        Wed, 5 Feb 2020 05:59:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xykc1yfby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 05:59:17 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0155xEaM013246;
        Wed, 5 Feb 2020 05:59:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 21:59:14 -0800
Date:   Tue, 4 Feb 2020 21:59:13 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: don't corrupt a attr fork da3 node when
 clearing forw/back
Message-ID: <20200205055913.GD6870@magnolia>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
 <158086359417.2079557.4428155306169446299.stgit@magnolia>
 <7baaea32-91dc-353d-6de2-ccae5bd79a52@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7baaea32-91dc-353d-6de2-ccae5bd79a52@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 10:29:26PM -0700, Allison Collins wrote:
> 
> 
> On 2/4/20 5:46 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In process_longform_attr, we enforce that the root block of the
> > attribute index must have both forw or back pointers set to zero.
> > Unfortunately, the code that nulls out the pointers is not aware that
> > the root block could be in da3 node format.
> > 
> > This leads to corruption of da3 root node blocks because the functions
> > that convert attr3 leaf headers to and from the ondisk structures
> > perform some interpretation of firstused on what they think is an attr1
> > leaf block.
> > 
> > Found by using xfs/402 to fuzz hdr.info.hdr.forw.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >   repair/attr_repair.c |  181 ++++++++++++++++++++++++++++++++------------------
> >   1 file changed, 117 insertions(+), 64 deletions(-)
> > 
> > 
> > diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> > index 7b26df33..535fcfbb 100644
> > --- a/repair/attr_repair.c
> > +++ b/repair/attr_repair.c
> > @@ -952,6 +952,106 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
> >   	return 0;
> >   }
> > +static int
> > +process_longform_leaf_root(
> > +	struct xfs_mount	*mp,
> > +	xfs_ino_t		ino,
> > +	struct xfs_dinode	*dip,
> > +	struct blkmap		*blkmap,
> > +	int			*repair,
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_attr3_icleaf_hdr leafhdr;
> > +	xfs_dahash_t		next_hashval;
> > +	int			badness;
> "badness" pretty much just looks like "error" here?  Or is it different in
> some way?

The return value for process_leaf_attr_block is 1 if the attr block is
bad and 0 for the attr block is ok.  It's not the usual -EFUBAR error
codes that we use in many other parts of xfs.

> > +	int			repairlinks = 0;
> > +
> > +	/*
> > +	 * check sibling pointers in leaf block or root block 0 before
> > +	 * we have to release the btree block
> > +	 */
> > +	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
> > +	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
> > +		if (!no_modify)  {
> > +			do_warn(
> > +_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
> > +				ino);
> > +			repairlinks = 1;
> > +			leafhdr.forw = 0;
> > +			leafhdr.back = 0;
> > +			xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, bp->b_addr,
> > +					&leafhdr);
> > +		} else  {
> > +			do_warn(
> > +_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
> > +		}
> > +	}
> > +
> > +	badness = process_leaf_attr_block(mp, bp->b_addr, 0, ino, blkmap, 0,
> > +			&next_hashval, repair);
> > +	if (badness) {
> > +		*repair = 0;
> > +		/* the block is bad.  lose the attribute fork. */
> > +		libxfs_putbuf(bp);
> > +		return 1;
> > +	}
> > +
> > +	*repair = *repair || repairlinks;
> > +
> > +	if (*repair && !no_modify)
> > +		libxfs_writebuf(bp, 0);
> > +	else
> > +		libxfs_putbuf(bp);
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +process_longform_da_root(
> > +	struct xfs_mount	*mp,
> > +	xfs_ino_t		ino,
> > +	struct xfs_dinode	*dip,
> > +	struct blkmap		*blkmap,
> > +	int			*repair,
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_da3_icnode_hdr	da3_hdr;
> > +	int			repairlinks = 0;
> > +	int			error;
> > +
> > +	libxfs_da3_node_hdr_from_disk(mp, &da3_hdr, bp->b_addr);
> > +	/*
> > +	 * check sibling pointers in leaf block or root block 0 before
> > +	 * we have to release the btree block
> > +	 */
> > +	if (da3_hdr.forw != 0 || da3_hdr.back != 0)  {
> > +		if (!no_modify)  {
> > +			do_warn(
> > +_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
> > +				ino);
> > +
> > +			repairlinks = 1;
> > +			da3_hdr.forw = 0;
> > +			da3_hdr.back = 0;
> > +			xfs_da3_node_hdr_to_disk(mp, bp->b_addr, &da3_hdr);
> > +		} else  {
> > +			do_warn(
> > +_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
> > +		}
> > +	}
> > +
> > +	/* must do this now, to release block 0 before the traversal */
> Did you mean to reference *repair here without setting it?  I guess it was
> like that from the code it was taken from, but it makes it looks like repair
> is both an in and an out.  I wonder if it's really needed in the check
> below?

*repair is passed from a stack variable in process_inode_attr_fork ->
process_attributes -> process_longform_attr.  It's initialized properly,
but the code doesn't make it easy to figure that out since that's three
functions up in the call stack and anyone is allowed to mess with it.

One of the grottier bits of xfs_repair is that the return values for
those functions also have meaning...I think return 1 means "zap this
whole thing" vs. *repair ==1 means "we fixed it".

--D

> 
> Allison
> 
> > +	if ((*repair || repairlinks) && !no_modify) {
> > +		*repair = 1;
> > +		libxfs_writebuf(bp, 0);
> > +	} else
> > +		libxfs_putbuf(bp);
> > +	error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
> > +	if (error)
> > +		*repair = 0;
> > +	return error;
> > +}
> > +
> >   /*
> >    * Start processing for a leaf or fuller btree.
> >    * A leaf directory is one where the attribute fork is too big for
> > @@ -963,19 +1063,15 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
> >    */
> >   static int
> >   process_longform_attr(
> > -	xfs_mount_t	*mp,
> > -	xfs_ino_t	ino,
> > -	xfs_dinode_t	*dip,
> > -	blkmap_t	*blkmap,
> > -	int		*repair)	/* out - 1 if something was fixed */
> > +	struct xfs_mount	*mp,
> > +	xfs_ino_t		ino,
> > +	struct xfs_dinode	*dip,
> > +	struct blkmap		*blkmap,
> > +	int			*repair) /* out - 1 if something was fixed */
> >   {
> > -	xfs_attr_leafblock_t	*leaf;
> > -	xfs_fsblock_t	bno;
> > -	xfs_buf_t	*bp;
> > -	xfs_dahash_t	next_hashval;
> > -	int		repairlinks = 0;
> > -	struct xfs_attr3_icleaf_hdr leafhdr;
> > -	int		error;
> > +	xfs_fsblock_t		bno;
> > +	struct xfs_buf		*bp;
> > +	struct xfs_da_blkinfo	*info;
> >   	*repair = 0;
> > @@ -1015,74 +1111,31 @@ process_longform_attr(
> >   		return 1;
> >   	}
> > -	/* verify leaf block */
> > -	leaf = bp->b_addr;
> > -	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
> > -
> > -	/* check sibling pointers in leaf block or root block 0 before
> > -	* we have to release the btree block
> > -	*/
> > -	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
> > -		if (!no_modify)  {
> > -			do_warn(
> > -	_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
> > -				ino);
> > -			repairlinks = 1;
> > -			leafhdr.forw = 0;
> > -			leafhdr.back = 0;
> > -			xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo,
> > -						   leaf, &leafhdr);
> > -		} else  {
> > -			do_warn(
> > -	_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
> > -		}
> > -	}
> > -
> >   	/*
> >   	 * use magic number to tell us what type of attribute this is.
> >   	 * it's possible to have a node or leaf attribute in either an
> >   	 * extent format or btree format attribute fork.
> >   	 */
> > -	switch (leafhdr.magic) {
> > +	info = bp->b_addr;
> > +	switch (be16_to_cpu(info->magic)) {
> >   	case XFS_ATTR_LEAF_MAGIC:	/* leaf-form attribute */
> >   	case XFS_ATTR3_LEAF_MAGIC:
> > -		if (process_leaf_attr_block(mp, leaf, 0, ino, blkmap,
> > -				0, &next_hashval, repair)) {
> > -			*repair = 0;
> > -			/* the block is bad.  lose the attribute fork. */
> > -			libxfs_putbuf(bp);
> > -			return(1);
> > -		}
> > -		*repair = *repair || repairlinks;
> > -		break;
> > -
> > +		return process_longform_leaf_root(mp, ino, dip, blkmap, repair,
> > +				bp);
> >   	case XFS_DA_NODE_MAGIC:		/* btree-form attribute */
> >   	case XFS_DA3_NODE_MAGIC:
> > -		/* must do this now, to release block 0 before the traversal */
> > -		if ((*repair || repairlinks) && !no_modify) {
> > -			*repair = 1;
> > -			libxfs_writebuf(bp, 0);
> > -		} else
> > -			libxfs_putbuf(bp);
> > -		error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
> > -		if (error)
> > -			*repair = 0;
> > -		return error;
> > +		return process_longform_da_root(mp, ino, dip, blkmap, repair,
> > +				bp);
> >   	default:
> >   		do_warn(
> >   	_("bad attribute leaf magic # %#x for dir ino %" PRIu64 "\n"),
> > -			be16_to_cpu(leaf->hdr.info.magic), ino);
> > +			be16_to_cpu(info->magic), ino);
> >   		libxfs_putbuf(bp);
> >   		*repair = 0;
> > -		return(1);
> > +		return 1;
> >   	}
> > -	if (*repair && !no_modify)
> > -		libxfs_writebuf(bp, 0);
> > -	else
> > -		libxfs_putbuf(bp);
> > -
> > -	return(0);  /* repair may be set */
> > +	return 0; /* should never get here */
> >   }
> > 
