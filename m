Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6E3C33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 10:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D881424672
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 10:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgANKht (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:37:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64548 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbgANKht (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 05:37:49 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00EARl2O038372
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2020 05:37:46 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xfvt0j0ws-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2020 05:37:46 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Tue, 14 Jan 2020 10:37:44 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 14 Jan 2020 10:37:42 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00EAbf1x44761328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 10:37:41 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49A5FAE04D;
        Tue, 14 Jan 2020 10:37:41 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1496BAE056;
        Tue, 14 Jan 2020 10:37:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.51.219])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jan 2020 10:37:39 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Fix log reservation calculation for xattr insert operation
Date:   Tue, 14 Jan 2020 16:10:15 +0530
Organization: IBM
In-Reply-To: <20200113212639.GL8247@magnolia>
References: <20200110042953.18557-1-chandanrlinux@gmail.com> <20200110042953.18557-2-chandanrlinux@gmail.com> <20200113212639.GL8247@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20011410-0012-0000-0000-0000037D307C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011410-0013-0000-0000-000021B95D52
Message-Id: <8039625.Kcc1UTBUzu@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_03:2020-01-13,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=2 bulkscore=0 phishscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001140093
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, January 14, 2020 2:56 AM Darrick J. Wong wrote: 
> On Fri, Jan 10, 2020 at 09:59:53AM +0530, Chandan Rajendra wrote:
> > Log space reservation for xattr insert operation can be divided into two
> > parts,
> > 1. Mount time
> >    - Inode
> >    - Superblock for accounting space allocations
> >    - AGF for accounting space used be count, block number, rmapbt and refcnt
> >      btrees.
> > 
> > 2. The remaining log space can only be calculated at run time because,
> >    - A local xattr can be large enough to cause a double split of the dabtree.
> >    - The value of the xattr can be large enough to be stored in remote
> >      blocks. The contents of the remote blocks are not logged.
> > 
> >    The log space reservation would be,
> >    - 2 * XFS_DA_NODE_MAXDEPTH number of blocks. Additional XFS_DA_NODE_MAXDEPTH
> >      number of blocks are required if xattr is large enough to cause another
> >      split of the dabtree path from root to leaf block.
> >    - BMBT blocks for storing (2 * XFS_DA_NODE_MAXDEPTH) record
> >      entries. Additional XFS_DA_NODE_MAXDEPTH number of blocks are required in
> >      case of a double split of the dabtree path from root to leaf blocks.
> >    - Space for logging blocks of count, block number, rmap and refcnt btrees.
> > 
> > This commit refactors xfs_attr_calc_size() to calculate the log reservation
> > space and also the FS reservation space. It then replaces the erroneous
> > calculation inside xfs_log_calc_max_attrsetm_res() with an invocation of
> > xfs_attr_calc_size().
> 
> Uh, what was the error that you saw?

In xfs_log_calc_max_attrsetm_res(), we have,

1. XFS_DAENTER_SPACE_RES() calculates the number of blocks required to add
   an xattr. It comprises of,
   - XFS_DA_NODE_MAXDEPTH
     Number of blocks required for a single split of the dabtree from the root
     to leaf.
   - XFS_DA_NODE_MAXDEPTH * XFS_BM_MAXLEVELS
     For each dabtree block allocated, the above statement assumes that we
     would need to allocate (in the worst case) blocks from the root to
     the leaf of a bmbt tree.
   This does not take into consideration the double-split that is
   possible for large sized local xattrs.
2. XFS_NEXTENTADD_SPACE_RES() once again calculates the number of bmbt blocks
   that needs to be reserved. This is already taken into consideration by
   XFS_DAENTER_SPACE_RES() macro.

   Also, the second argument to XFS_NEXTENTADD_SPACE_RES() is in units
   of bytes. This should have been specified in units of blocks.

   This is what led me to start looking into this function more thoroughly
   i.e. there was no workload that failed with the existing logic.

3. We then multiply the summation of the above numbers with the runtime
   reservation i.e. superblock + nr blocks from root to leaf of a bmbt. 
   - Superblock log space reservation is required only once per transaction.
     However, Here we end up reserving superblock log space
     for each of the blocks that we had calculated.
   - Number of blocks from root to leaf of a bmbt.
     XFS_DAENTER_SPACE_RES() already computed the number of bmbt blocks
     that needs to be allocated.
     The number of log blocks required to be reserved in the worst case should
     be (XFS_BM_MAXLEVELS + number of bmbt blocks computed by
     XFS_DAENTER_SPACE_RES()).
> 
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       | 107 +++++++++++++++++++++------------
> >  fs/xfs/libxfs/xfs_attr.h       |   4 +-
> >  fs/xfs/libxfs/xfs_log_rlimit.c |  15 ++---
> >  fs/xfs/libxfs/xfs_trans_resv.c |  34 ++---------
> >  fs/xfs/libxfs/xfs_trans_resv.h |   2 +
> >  5 files changed, 86 insertions(+), 76 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 1eae1db74f6c..067661e61286 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -183,43 +183,6 @@ xfs_attr_get(
> >  	return 0;
> >  }
> >  
> > -/*
> > - * Calculate how many blocks we need for the new attribute,
> > - */
> > -STATIC int
> > -xfs_attr_calc_size(
> > -	struct xfs_da_args	*args,
> > -	int			*local)
> > -{
> > -	struct xfs_mount	*mp = args->dp->i_mount;
> > -	int			size;
> > -	int			nblks;
> > -
> > -	/*
> > -	 * Determine space new attribute will use, and if it would be
> > -	 * "local" or "remote" (note: local != inline).
> > -	 */
> > -	size = xfs_attr_leaf_newentsize(mp, args->namelen, args->valuelen,
> > -					local);
> > -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> > -	if (*local) {
> > -		if (size > (args->geo->blksize / 2)) {
> > -			/* Double split possible */
> > -			nblks *= 2;
> > -		}
> > -	} else {
> > -		/*
> > -		 * Out of line attribute, cannot double split, but
> > -		 * make room for the attribute value itself.
> > -		 */
> > -		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> > -		nblks += dblocks;
> > -		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
> > -	}
> > -
> > -	return nblks;
> > -}
> > -
> >  STATIC int
> >  xfs_attr_try_sf_addname(
> >  	struct xfs_inode	*dp,
> > @@ -248,6 +211,69 @@ xfs_attr_try_sf_addname(
> >  	return error ? error : error2;
> >  }
> >  
> > +/*
> > + * Calculate how many blocks we need for the new attribute,
> > + */
> > +void
> > +xfs_attr_calc_size(
> > +	struct xfs_mount	*mp,
> > +	int			namelen,
> > +	int			valuelen,
> > +	int			*local,
> > +	unsigned int		*log_blks,
> 
> I see the xfs_calc_buf_res() calls below, which means this value ends up
> with the number of *log bytes* needed to log all the blocks we think
> we're going to need for the new attr.

Sorry, My bad. I will fix this up.

> 
> > +	unsigned int		*total_blks)
> > +{
> > +	unsigned int		blksize;
> > +	int			dabtree_blks;
> > +	int			bmbt_blks;
> > +	int			size;
> > +	int			dblks;
> > +
> > +	blksize = mp->m_dir_geo->blksize;
> > +	dblks = 0;
> > +	*log_blks = 0;
> > +	*total_blks = 0;
> > +
> > +	/*
> > +	 * Determine space new attribute will use, and if it would be
> > +	 * "local" or "remote" (note: local != inline).
> > +	 */
> > +	size = xfs_attr_leaf_newentsize(mp, namelen, valuelen, local);
> > +
> > +	dabtree_blks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> > +	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
> 
> Ok, so this calculates the number of blocks we need to add one attr
> block to the dabtree + whatever dabtree split we might need to insert
> the leaf block + whatever bmbt splits we might need to insert each of
> the new dabtree blocks into the attr fork.
> 
> I guess this calculation handles the case where we have to add an attr
> leaf block to the dabtree...?

Yes, That is correct.

> 
> > +
> > +	*log_blks = xfs_calc_buf_res(2 * dabtree_blks, blksize);
> > +	*log_blks += xfs_calc_buf_res(2 * bmbt_blks, XFS_FSB_TO_B(mp, 1));
> 
> Why reserve log space for twice as many blocks as we just calculated?

Lets say that a leaf block is split. This would mean that the contents of two
blocks would have changed. Hence we would need to log both the blocks. In the
worst case we would need to log changes for all the splits from root block to
the leaf block.

> 
> > +	if (*local) {
> > +		if (size > (blksize / 2)) {
> > +			/* Double split possible */
> > +			*log_blks += xfs_calc_buf_res(dabtree_blks, blksize);
> > +			*log_blks += xfs_calc_buf_res(bmbt_blks,
> > +						XFS_FSB_TO_B(mp, 1));
> > +
> > +			dabtree_blks *= 2;
> > +			bmbt_blks *= 2;
> 
> This appears to be the new version of the old code "nblks *= 2", which
> doubled the resource counts if it anticipates a possible second dabtree
> split (i.e. the attr entry size is more than half a block), right?

Yes, that is correct.

> 
> You really ought to use the proper macro to update bmbt_blocks instead
> of assuming that doubling it will be fine.

XFS_NEXTENTADD_SPACE_RES() seems to be right macro to invoke.

> 
> > +		}
> > +	} else {
> > +		/*
> > +		 * Out of line attribute, cannot double split, but
> > +		 * make room for the attribute value itself.
> > +		 */
> > +		dblks = xfs_attr3_rmt_blocks(mp, valuelen);
> > +		bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, dblks, XFS_ATTR_FORK);
> > +		*log_blks += xfs_calc_buf_res(bmbt_blks, XFS_FSB_TO_B(mp, 1));
> 
> This adds enough log bytes reservation to handle bmbt splits to add all
> the (unlogged) remote attr value blocks to the attr fork...
> 
> > +	}
> > +
> > +	*log_blks += xfs_calc_buf_res(xfs_allocfree_log_count(mp, dabtree_blks),
> > +				XFS_FSB_TO_B(mp, 1));
> 
> ...this adds log bytes reservation for all the AG space btree updates
> that might be necessary to all all those blocks to the dabtree...
> 
> > +	*log_blks += xfs_calc_buf_res(xfs_allocfree_log_count(mp, dblks),
> > +				XFS_FSB_TO_B(mp, 1));
> 
> ...and this one does the same for all the bmbt blocks needed to map in
> the new dabtree blocks.
> 
> > +	*total_blks = dabtree_blks + bmbt_blks + dblks;
> 
> This calculation is the worst case number of blocks we think we'll need,
> which gets fed to _trans_alloc as well as args.total.  This is the same
> behavior as before this patchset.

Yes, The behaviour is same for filesystem space reservation
calculation. However, The idea behind this patch is to make
xfs_attr_calc_size() to also calculate the log space reservation.

Without this patch, xfs_log_calc_max_attrsetm_res() would return 555768 blocks
as the log space reservation. After fixing the second argument of
XFS_NEXTENTADD_SPACE_RES() to be a "block count" instead of "byte count",
xfs_log_calc_max_attrsetm_res() would return 262904 blocks as the log space
reservation.

With this patch applied (along with converting the return value of
xfs_calc_buf_res() to blocks), xfs_log_calc_max_attrsetm_res() returns 3187
blocks as the log space reservation.

> 
> Before this series, we compute the number of bytes of log space needed
> to record all the new metadata:
> 
> 	tr_attrsetm.tr_logres + (args.total * tr_attrsetrt.tr_logres)
> 
> tr_attrsetm.tr_logres is large enough to log the first of the dabtree
> splits, but ... doesn't seem to do so for the double split case?  Hmm.
> 
> tr_attrsetrt.tr_logres is set to the number of log bytes needed
> to log the AGF and BMBT updates needed to add one block to the tree, but
> that doesn't factor in all of the log bytes needed to record the changes
> to the bnobt, cntbt, and rmapbt.
> 
> So my guess is that the problem you saw was that you're running some
> workload that exercises the attribute setting routines heavily, and at
> some point the dabtree gets full enough and/or the fs fragments enough
> that we exceed the log bytes reservation and the log goes offline?

Actually, I found the flaw in xfs_log_calc_max_attrsetm_res() when debugging
an xfstests failure after extending the per-inode attribute extent counter to
32-bits.

> 
> Assuming I've gotten all that correct, I think I see a better way to
> structure this.  For one thing, I think we should keep the log space
> reservation calculations functions in xfs_trans_resv.c and not spread
> them into xfs_attr.c.
> 
> xfs_attr_calc_size should return both the (max) number of *dabtree*
> blocks that we're going to log and the (max) number of *dabtree* blocks
> that we could be allocating.  Next, add a pair of functions to
> xfs_trans_resv.c to compute the actual log space and log blocks
> reservations given the above two outputs.
> 
> xfs_calc_attr_res(log_dablocks, total_dablocks)
> {
> 	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(total_dablocks)
> 	space_blks = xfs_allocfree_log_count(total_dablocks + bmbt_blks)
> 
> 	return tr_attrsetm.tr_logres +
> 	       xfs_calc_buf_res(log_dablocks, blksize) +
> 	       xfs_calc_buf_res(bmbt_blks, blksize) +
> 	       xfs_calc_buf_res(space_blks, blksize) +
> }
> 
> xfs_calc_attr_blocks(total_dablocks)
> {
> 	return total_dablocks + XFS_NEXTENTADD_SPACE_RES(total_dablocks)
> }
> 
> and fix the atttrsetm.tr_logres calculation not to include the dablocks
> reservation.

Yes, the above looks correct. I will make the required changes and post the
report the patches. Thanks for the review comments.

-- 
chandan



