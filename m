Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D4AC33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 16:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 600BB2072B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 16:20:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bnqeJTDT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgAQQUp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 11:20:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47072 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgAQQUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 11:20:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HGDRca083338;
        Fri, 17 Jan 2020 16:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=EGnVn6+K6CuiH+SqIueBas3uD9JyZxrVjM7KiidGhTg=;
 b=bnqeJTDTuD8x74Hpqy/TFvg8cycI+T8qondYG0ACKWGSP4urOeW5A/ZhRL1Pr0xPUbyw
 cLef/e+icoLHTr00Vhmsi2kUqYj0gO0+YfPV8xMEKoZONCDrrM5dVz9JMUUEmxMmdAH+
 Bh8w+wXPykHIsyw1GbGqlm5yDupI5Qm3qYeEvqWgxRhjNJ6U8jvmKddMmb+IW14mDhaM
 JcXevsBhZ7M/fKUW+XfbYupNAHZa1ht70m/YD8renoDH8pEcl9VDaL2ysBac+5nDWI+8
 +rkJF5vunt1W6XVIAK9zYwJSegEId/+EGqgi7RcAiS4StBglZXWPgZW2Eiv4FHIQMkd5 aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xf74ssm7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 16:20:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HGEFpT103331;
        Fri, 17 Jan 2020 16:20:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xjxm960qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 16:20:37 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00HGKaOC022496;
        Fri, 17 Jan 2020 16:20:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jan 2020 08:20:36 -0800
Date:   Fri, 17 Jan 2020 08:20:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     david@fromorbit.com, Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 2/2] xfs: Fix log reservation calculation for xattr
 insert operation
Message-ID: <20200117162035.GS8247@magnolia>
References: <20200115125421.22719-1-chandanrlinux@gmail.com>
 <20200117004618.GO8247@magnolia>
 <2258200.WESrQN0qAt@localhost.localdomain>
 <3798161.AAjsAJd4dB@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3798161.AAjsAJd4dB@localhost.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170125
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 17, 2020 at 08:17:55PM +0530, Chandan Rajendra wrote:
> On Friday, January 17, 2020 10:16 AM Chandan Rajendra wrote: 
> > On Friday, January 17, 2020 6:16 AM Darrick J. Wong wrote: 
> > > On Wed, Jan 15, 2020 at 06:24:21PM +0530, Chandan Rajendra wrote:
> > > > Log space reservation for xattr insert operation can be divided into two
> > > > parts,
> > > > 1. Mount time
> > > >    - Inode
> > > >    - Superblock for accounting space allocations
> > > >    - AGF for accounting space used be count, block number, rmapbt and refcnt
> > > >      btrees.
> > > > 
> > > > 2. The remaining log space can only be calculated at run time because,
> > > >    - A local xattr can be large enough to cause a double split of the dabtree.
> > > >    - The value of the xattr can be large enough to be stored in remote
> > > >      blocks. The contents of the remote blocks are not logged.
> > > > 
> > > >    The log space reservation could be,
> > > >    - 2 * XFS_DA_NODE_MAXDEPTH number of blocks. Additional XFS_DA_NODE_MAXDEPTH
> > > >      number of blocks are required if xattr is large enough to cause another
> > > >      split of the dabtree path from root to leaf block.
> > > >    - BMBT blocks for storing (2 * XFS_DA_NODE_MAXDEPTH) record
> > > >      entries. Additional XFS_DA_NODE_MAXDEPTH number of blocks are required in
> > > >      case of a double split of the dabtree path from root to leaf blocks.
> > > >    - Space for logging blocks of count, block number, rmap and refcnt btrees.
> > > > 
> > > > Presently, mount time log reservation includes block count required for a
> > > > single split of the dabtree. The dabtree block count is also taken into
> > > > account by xfs_attr_calc_size().
> > > > 
> > > > Also, AGF log space reservation isn't accounted for. Hence log reservation
> > > > calculation for xattr insert operation gives incorrect value.
> > > > 
> > > > Apart from the above, xfs_log_calc_max_attrsetm_res() passes a byte count as
> > > > an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.
> > > > 
> > > > To fix these issues, this commit refactors xfs_attr_calc_size() to calculate,
> > > > 1. The number of dabtree blocks that need to be logged.
> > > > 2. The number of remote blocks that need to allocated.
> > > > 3. The number of dabtree blocks that need to allocated.
> > > > 
> > > > xfs_attr_set() uses this information to compute
> > > > 1. Number of blocks that needs to allocated during the transaction.
> > > > 2. Number of bytes that needs to be reserved in the log.
> > > > 
> > > > This commit also modifies xfs_log_calc_max_attrsetm_res() to invoke
> > > > xfs_attr_calc_size() to obtain the number of dabtree blocks to be
> > > > logged which it uses to figure out the total number of blocks to be logged.
> > > > 
> > > > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > > > ---
> > > > Changelog:
> > > > V1 -> V2:
> > > > 1. xfs_attr_calc_size() computes
> > > >    - Number of blocks required to log dabtree blocks.
> > > >    - Number of remote blocks.
> > > >    - Total dabtree blocks to be allocated.
> > > > 2. Add new function xfs_calc_attr_blocks() to compute the total number of
> > > >    blocks to be allocated during xattr insert operation.
> > > > 3. Add new function xfs_calc_attr_res() to compute the log space to be
> > > >    reserved during xattr insert operation.
> > > > 
> > > >  fs/xfs/libxfs/xfs_attr.c       | 108 +++++++++++++++++++++------------
> > > >  fs/xfs/libxfs/xfs_attr.h       |   3 +
> > > >  fs/xfs/libxfs/xfs_log_rlimit.c |  17 +++---
> > > >  fs/xfs/libxfs/xfs_trans_resv.c |  56 +++++++++--------
> > > >  fs/xfs/libxfs/xfs_trans_resv.h |   2 +
> > > >  5 files changed, 113 insertions(+), 73 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > index 1eae1db74f6c..363b4c47b134 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > @@ -183,43 +183,6 @@ xfs_attr_get(
> > > >  	return 0;
> > > >  }
> > > >  
> > > > -/*
> > > > - * Calculate how many blocks we need for the new attribute,
> > > > - */
> > > > -STATIC int
> > > > -xfs_attr_calc_size(
> > > > -	struct xfs_da_args	*args,
> > > > -	int			*local)
> > > > -{
> > > > -	struct xfs_mount	*mp = args->dp->i_mount;
> > > > -	int			size;
> > > > -	int			nblks;
> > > > -
> > > > -	/*
> > > > -	 * Determine space new attribute will use, and if it would be
> > > > -	 * "local" or "remote" (note: local != inline).
> > > > -	 */
> > > > -	size = xfs_attr_leaf_newentsize(mp, args->namelen, args->valuelen,
> > > > -					local);
> > > > -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> > > > -	if (*local) {
> > > > -		if (size > (args->geo->blksize / 2)) {
> > > > -			/* Double split possible */
> > > > -			nblks *= 2;
> > > > -		}
> > > > -	} else {
> > > > -		/*
> > > > -		 * Out of line attribute, cannot double split, but
> > > > -		 * make room for the attribute value itself.
> > > > -		 */
> > > > -		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> > > > -		nblks += dblocks;
> > > > -		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
> > > > -	}
> > > > -
> > > > -	return nblks;
> > > > -}
> > > > -
> > > >  STATIC int
> > > >  xfs_attr_try_sf_addname(
> > > >  	struct xfs_inode	*dp,
> > > > @@ -248,6 +211,64 @@ xfs_attr_try_sf_addname(
> > > >  	return error ? error : error2;
> > > >  }
> > > >  
> > > > +STATIC uint
> > > > +xfs_calc_attr_blocks(
> > > > +	struct xfs_mount	*mp,
> > > > +	unsigned int		total_dablks,
> > > > +	unsigned int		rmt_blks)
> > > > +{
> > > > +	unsigned int bmbt_blks;
> > > > +
> > > > +	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp, total_dablks + rmt_blks,
> > > > +					XFS_ATTR_FORK);
> > > > +	return total_dablks + rmt_blks + bmbt_blks;
> > > 
> > > I think this calculation could be added to xfs_attr_calc_size and passed
> > > back to the caller as another outparam.
> > > 
> > > At this point we have five different block counts I'm wondering if we
> > > should create a struct and pass it around...
> > > 
> > > > +}
> > > > +
> > > > +/*
> > > > + * Calculate how many blocks we need for the new attribute,
> > > > + */
> > > > +void
> > > > +xfs_attr_calc_size(
> > > > +	struct xfs_mount	*mp,
> > > > +	int			namelen,
> > > > +	int			valuelen,
> > > > +	int			*local,
> > > > +	unsigned int		*log_dablks,
> > > > +	unsigned int		*rmt_blks,
> > > > +	unsigned int		*total_dablks)
> > > 
> > > ...something like this?  It'll be much easier to remember what each of
> > > those parameters actually do with a full sentence comment:
> > > 
> > > struct xfs_attr_set_resv {
> > > 	/* Number of blocks in the da btree that we might need to log. */
> > > 	unsigned int		log_dablks;
> > > 
> > > 	/* Number of unlogged blocks needed to store the remote attr value. */
> > > 	unsigned int		rmt_blks;
> > > 
> > > 	/* Blocks we might need to map into the attribute fork. */
> > > 	unsigned int		total_dablks;
> > > 
> > > 	/* Blocks we might need to allocate. */
> > > 	unsigned int		alloc_blks;
> > > 
> > > 	/* Blocks we might need to create all the new attr fork mappings. */
> > > 	unsigned int		bmbt_blks;
> > > };
> > > 
> > > > +{
> > > > +	unsigned int		blksize;
> > > > +	int			size;
> > > > +
> > > > +	blksize = mp->m_dir_geo->blksize;
> > > > +	*log_dablks = 0;
> > > > +	*rmt_blks = 0;
> > > > +	*total_dablks = 0;
> > > 
> > > No need to zero out variables that we're going to set two lines later.
> > > 
> > > > +
> > > > +	/*
> > > > +	 * Determine space new attribute will use, and if it would be
> > > > +	 * "local" or "remote" (note: local != inline).
> > > > +	 */
> > > > +	size = xfs_attr_leaf_newentsize(mp, namelen, valuelen, local);
> > > > +
> > > > +	*total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> > > > +	*log_dablks = 2 * *total_dablks;
> > > > +
> > > > +	if (*local) {
> > > > +		if (size > (blksize / 2)) {
> > > > +			/* Double split possible */
> > > > +			*log_dablks += *total_dablks;
> > > > +			*total_dablks *= 2;
> > > > +		}
> > > > +	} else {
> > > > +		/*
> > > > +		 * Out of line attribute, cannot double split, but
> > > > +		 * make room for the attribute value itself.
> > > > +		 */
> > > > +		*rmt_blks = xfs_attr3_rmt_blocks(mp, valuelen);
> > > > +	}
> > > > +}
> > > > +
> > > >  /*
> > > >   * Set the attribute specified in @args.
> > > >   */
> > > > @@ -346,6 +367,9 @@ xfs_attr_set(
> > > >  	struct xfs_mount	*mp = dp->i_mount;
> > > >  	struct xfs_da_args	args;
> > > >  	struct xfs_trans_res	tres;
> > > > +	unsigned int		log_dablks;
> > > > +	unsigned int		rmt_blks;
> > > > +	unsigned int		total_dablks;
> > > >  	int			rsvd = (flags & ATTR_ROOT) != 0;
> > > >  	int			error, local;
> > > >  
> > > > @@ -361,7 +385,11 @@ xfs_attr_set(
> > > >  	args.value = value;
> > > >  	args.valuelen = valuelen;
> > > >  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> > > > -	args.total = xfs_attr_calc_size(&args, &local);
> > > > +
> > > > +	xfs_attr_calc_size(mp, args.namelen, args.valuelen, &local,
> > > > +			&log_dablks, &rmt_blks, &total_dablks);
> > > > +
> > > > +	args.total = xfs_calc_attr_blocks(mp, total_dablks, rmt_blks);
> > > >  
> > > >  	error = xfs_qm_dqattach(dp);
> > > >  	if (error)
> > > > @@ -380,8 +408,8 @@ xfs_attr_set(
> > > >  			return error;
> > > >  	}
> > > >  
> > > > -	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> > > > -			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
> > > > +	tres.tr_logres = xfs_calc_attr_res(mp, log_dablks, rmt_blks,
> > > > +					total_dablks);
> > > >  	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> > > >  	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> > > >  
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > > index 94badfa1743e..a1c77618802b 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > > @@ -154,5 +154,8 @@ int xfs_attr_remove_args(struct xfs_da_args *args);
> > > >  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
> > > >  		  int flags, struct attrlist_cursor_kern *cursor);
> > > >  bool xfs_attr_namecheck(const void *name, size_t length);
> > > > +void xfs_attr_calc_size(struct xfs_mount *mp, int namelen, int valuelen,
> > > > +			int *local, unsigned int *log_dablks,
> > > > +			unsigned int *rmt_blks, unsigned int *total_dablks);
> > > >  
> > > >  #endif	/* __XFS_ATTR_H__ */
> > > > diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> > > > index 7f55eb3f3653..33b805411f72 100644
> > > > --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> > > > +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> > > > @@ -10,6 +10,7 @@
> > > >  #include "xfs_log_format.h"
> > > >  #include "xfs_trans_resv.h"
> > > >  #include "xfs_mount.h"
> > > > +#include "xfs_attr.h"
> > > >  #include "xfs_da_format.h"
> > > >  #include "xfs_trans_space.h"
> > > >  #include "xfs_da_btree.h"
> > > > @@ -23,17 +24,19 @@ STATIC int
> > > >  xfs_log_calc_max_attrsetm_res(
> > > >  	struct xfs_mount	*mp)
> > > >  {
> > > > -	int			size;
> > > > -	int			nblks;
> > > > +	int		size;
> > > > +	int		local;
> > > > +	unsigned int	total_dablks;
> > > > +	unsigned int	rmt_blks;
> > > > +	unsigned int	log_dablks;
> > > >  
> > > >  	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
> > > >  	       MAXNAMELEN - 1;
> > > > -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> > > > -	nblks += XFS_B_TO_FSB(mp, size);
> > > > -	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
> > > > +	xfs_attr_calc_size(mp, size, 0, &local, &log_dablks, &rmt_blks,
> > > > +			&total_dablks);
> > > > +	ASSERT(local == 1);
> > > >  
> > > > -	return  M_RES(mp)->tr_attrsetm.tr_logres +
> > > > -		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
> > > > +	return xfs_calc_attr_res(mp, log_dablks, rmt_blks, total_dablks);
> > > >  }
> > > >  
> > > >  /*
> > > > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > > > index 824073a839ac..8a0fea655358 100644
> > > > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > > > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > > > @@ -701,12 +701,10 @@ xfs_calc_attrinval_reservation(
> > > >   * Setting an attribute at mount time.
> > > >   *	the inode getting the attribute
> > > >   *	the superblock for allocations
> > > > - *	the agfs extents are allocated from
> > > > - *	the attribute btree * max depth
> > > > - *	the inode allocation btree
> > > > + *	the agf extents are allocated from
> > > >   * Since attribute transaction space is dependent on the size of the attribute,
> > > >   * the calculation is done partially at mount time and partially at runtime(see
> > > > - * below).
> > > > + * xfs_attr_calc_size()).
> > > >   */
> > > >  STATIC uint
> > > >  xfs_calc_attrsetm_reservation(
> > > > @@ -714,27 +712,7 @@ xfs_calc_attrsetm_reservation(
> > > >  {
> > > >  	return XFS_DQUOT_LOGRES(mp) +
> > > >  		xfs_calc_inode_res(mp, 1) +
> > > > -		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> > > > -		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
> > > > -}
> > > > -
> > > > -/*
> > > > - * Setting an attribute at runtime, transaction space unit per block.
> > > > - * 	the superblock for allocations: sector size
> > > > - *	the inode bmap btree could join or split: max depth * block size
> > > > - * Since the runtime attribute transaction space is dependent on the total
> > > > - * blocks needed for the 1st bmap, here we calculate out the space unit for
> > > > - * one block so that the caller could figure out the total space according
> > > > - * to the attibute extent length in blocks by:
> > > > - *	ext * M_RES(mp)->tr_attrsetrt.tr_logres
> > > > - */
> > > > -STATIC uint
> > > > -xfs_calc_attrsetrt_reservation(
> > > > -	struct xfs_mount	*mp)
> > > > -{
> > > > -	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> > > > -		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
> > > > -				 XFS_FSB_TO_B(mp, 1));
> > > > +		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
> > > 
> > > What effect does changing these reservation calculations have on the
> > > computed minimum log size?
> > > 
> > > >  }
> > > >  
> > > >  /*
> > > > @@ -832,6 +810,32 @@ xfs_calc_sb_reservation(
> > > >  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
> > > >  }
> > > >  
> > > > +uint
> > > > +xfs_calc_attr_res(
> > > > +	struct xfs_mount	*mp,
> > > > +	unsigned int		log_dablks,
> > > > +	unsigned int		rmt_blks,
> > > > +	unsigned int		total_dablks)
> > > > +{
> > > > +	unsigned int		da_blksize;
> > > > +	unsigned int		fs_blksize;
> > > > +	unsigned int		bmbt_blks;
> > > > +	unsigned int		space_blks;
> > > > +
> > > > +	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp, total_dablks + rmt_blks,
> > > > +					XFS_ATTR_FORK);
> > > 
> > > Pass in the resv structure above and you won't need to calculate this
> > > again.
> > > 
> > > > +	space_blks = xfs_allocfree_log_count(mp,
> > > > +					total_dablks + rmt_blks + bmbt_blks);
> > > 
> > > Only two levels of indent needed here:
> > > 
> > > 	space_blks = xfs_allocfree_log_count(mp,
> > > 			total_dablks + rmt_blks + bmbt_blks);
> > > 
> > > > +
> > > > +	da_blksize = mp->m_attr_geo->blksize;
> > > > +	fs_blksize = mp->m_sb.sb_blocksize;
> > > 
> > > You could probably pass these to xfs_calc_buf_res directly.
> > > 
> > > I'll give this a spin and see how it does.
> > > 
> > > --D
> > > 
> > > > +
> > > > +	return M_RES(mp)->tr_attrsetm.tr_logres +
> > > > +		xfs_calc_buf_res(log_dablks, da_blksize) +
> > > > +		xfs_calc_buf_res(bmbt_blks, fs_blksize) +
> > > > +		xfs_calc_buf_res(space_blks, fs_blksize);
> > > > +}
> > > > +
> > > >  void
> > > >  xfs_trans_resv_calc(
> > > >  	struct xfs_mount	*mp,
> > > > @@ -942,7 +946,7 @@ xfs_trans_resv_calc(
> > > >  	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
> > > >  	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
> > > >  	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
> > > > -	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
> > > > +	resp->tr_attrsetrt.tr_logres = 0;
> > > >  	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
> > > >  	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
> > > >  	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
> > > > diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> > > > index 7241ab28cf84..48ceba72fb12 100644
> > > > --- a/fs/xfs/libxfs/xfs_trans_resv.h
> > > > +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> > > > @@ -91,6 +91,8 @@ struct xfs_trans_resv {
> > > >  #define	XFS_ATTRSET_LOG_COUNT		3
> > > >  #define	XFS_ATTRRM_LOG_COUNT		3
> > > >  
> > > > +uint xfs_calc_attr_res(struct xfs_mount *mp, unsigned int log_dablks,
> > > > +		unsigned int rmt_blks, unsigned int total_dablks);
> > > >  void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
> > > >  uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
> > > >  
> > > 
> > 
> > Hi Darrick,
> > 
> > I agree to the changes you have suggested. I will apply them and post the next
> > version soon.
> > 
> > I will also figure out the effect of this patch on minimum log size.
> > 
> 
> Darrick, The log space reservation numbers mentioned in response to one of the 
> of earlier mails were not correct. I had misinterpreted tr_logres to be in units
> of blocks when doing calculations.
> 
> Here are the correct numbers,
> 
> Without patch
> -------------
> xattr log reservation space = 555768
> 
> With patch
> ----------
> xattr log reservation space = 834936
> 
> The changes in xattr log space reservation numbers do not have any effect on
> minimum log size calculation. This is because log reservation for truncate
> operation is much larger; i.e
> 
> tr_logres = 259968, tr_logcount = 8, tr_logflags = 4
> 
> ... which would be 259968 * 8 = 2079744 bytes
> 
> Since 2079744 > 834936, the rest of the calculation for minimum log
> reservation does not change.

How about for V4 filesystems and V5 filesystems that don't have rmap or
reflink enabled?  The problem with increasing space reservation
requirements increasing is that old filesystems stop mounting on new
kernels...

(Just FYI, trace_xfs_trans_resv_calc is your friend here for the kernel
side; and the xfs_db logres command in userspace.)

The patch seemed ok on an overnight fstests run....

--D

> -- 
> chandan
> 
> 
> 
