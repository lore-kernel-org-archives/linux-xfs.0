Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF3FC4BA12
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA28E24687
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgBZPBO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 10:01:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727000AbgBZPBO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 10:01:14 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QEnStQ013282
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2020 10:01:13 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydkf98knm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2020 10:01:12 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 26 Feb 2020 15:01:10 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Feb 2020 15:01:06 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01QF15gb54919268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 15:01:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45A44AE05F;
        Wed, 26 Feb 2020 15:01:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1CDCAE057;
        Wed, 26 Feb 2020 15:01:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.56.226])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Feb 2020 15:01:02 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 7/7] xfs: Fix log reservation calculation for xattr insert operation
Date:   Wed, 26 Feb 2020 16:51:13 +0530
Organization: IBM
In-Reply-To: <20200225171954.GF54181@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com> <20200224040044.30923-8-chandanrlinux@gmail.com> <20200225171954.GF54181@bfoster>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022615-0028-0000-0000-000003DE344A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022615-0029-0000-0000-000024A35075
Message-Id: <2457163.KJ604EA27E@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_05:2020-02-26,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 suspectscore=5 malwarescore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 bulkscore=0 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002260108
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, February 25, 2020 10:49 PM Brian Foster wrote: 
> On Mon, Feb 24, 2020 at 09:30:44AM +0530, Chandan Rajendra wrote:
> > Log space reservation for xattr insert operation can be divided into two
> > parts,
> > 1. Mount time
> >    - Inode
> >    - Superblock for accounting space allocations
> >    - AGF for accounting space used by count, block number, rmap and refcnt
> >      btrees.
> > 
> > 2. The remaining log space can only be calculated at run time because,
> >    - A local xattr can be large enough to cause a double split of the dabtree.
> >    - The value of the xattr can be large enough to be stored in remote
> >      blocks. The contents of the remote blocks are not logged.
> > 
> >    The log space reservation could be,
> >    - 2 * XFS_DA_NODE_MAXDEPTH number of blocks. Additional XFS_DA_NODE_MAXDEPTH
> >      number of blocks are required if xattr is large enough to cause another
> >      split of the dabtree path from root to leaf block.
> >    - BMBT blocks for storing (2 * XFS_DA_NODE_MAXDEPTH) record
> >      entries. Additional XFS_DA_NODE_MAXDEPTH number of blocks are required in
> >      case of a double split of the dabtree path from root to leaf blocks.
> >    - Space for logging blocks of count, block number, rmap and refcnt btrees.
> > 
> > Presently, mount time log reservation includes block count required for a
> > single split of the dabtree. The dabtree block count is also taken into
> > account by xfs_attr_calc_size().
> > 
> > Also, AGF log space reservation isn't accounted for.
> > 
> > Due to the reasons mentioned above, log reservation calculation for xattr
> > insert operation gives an incorrect value.
> > 
> > Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
> > an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.
> > 
> > To fix these issues, this commit changes xfs_attr_calc_size() to also
> > calculate the number of dabtree blocks that need to be logged.
> > 
> > xfs_attr_set() uses the following values computed by xfs_attr_calc_size()
> > 1. The number of dabtree blocks that need to be logged.
> > 2. The number of remote blocks that need to be allocated.
> > 3. The number of dabtree blocks that need to be allocated.
> > 4. The number of bmbt blocks that need to be allocated.
> > 5. The total number of blocks that need to be allocated.
> > 
> > ... to compute number of bytes that need to be reserved in the log.
> > 
> > This commit also modifies xfs_log_calc_max_attrsetm_res() to invoke
> > xfs_attr_calc_size() to obtain the number of blocks to be logged which it uses
> > to figure out the total number of bytes to be logged.
> > 
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       |  7 +++--
> >  fs/xfs/libxfs/xfs_attr.h       |  3 ++
> >  fs/xfs/libxfs/xfs_log_rlimit.c | 16 +++++------
> >  fs/xfs/libxfs/xfs_trans_resv.c | 50 ++++++++++++++++------------------
> >  fs/xfs/libxfs/xfs_trans_resv.h |  2 ++
> >  5 files changed, 41 insertions(+), 37 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 1d62ce80d7949..f056f8597ee03 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -182,9 +182,12 @@ xfs_attr_calc_size(
> >  	size = xfs_attr_leaf_newentsize(mp->m_attr_geo, namelen, valuelen,
> >  			local);
> >  	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> > +	resv->log_dablks = 2 * resv->total_dablks;
> > +
> >  	if (*local) {
> >  		if (size > (blksize / 2)) {
> >  			/* Double split possible */
> > +			resv->log_dablks += resv->total_dablks;
> 
> I'm not quite clear on why log is double the total above, then we add an
> increment of total here. Can you elaborate on this?

- resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK); 

  This gives the number of dabtree blocks that we might need to allocate. If
  we do indeed allocate resv->total_dablks worth of blocks then it would mean
  that we would have split blocks from the root node to the leaf node of the
  dabtree. We would then need to log the following blocks,
  - Blocks belonging to the original path from root node to the leaf node.
  - The new set of blocks from the root node to the leaf node which resulted
    from splitting the corresponding blocks in the original path.
  Thus the number of blocks to be logged is 2 * resv->total_dablks.

- Double split
  If the size of the xattr is large enough to cause another split, then we
  would need yet another set of new blocks for representing the path from root
  to the leaf.  This is taken into consideration by 'resv->total_dablks *= 2'.
  These new blocks might also need to logged. So resv->log_dablks should be
  incremented by number of blocks b/w root node and the leaf. I now feel that
  the statement could be rewritten in the following manner, 'resv->log_dablks
  += XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK)' if that makes it easier to
  understand.

> 
> >  			resv->total_dablks *= 2;
> >  		}
> >  		resv->rmt_blks = 0;
> > @@ -349,9 +352,7 @@ xfs_attr_set(
> >  				return error;
> >  		}
> >  
> > -		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> > -				 M_RES(mp)->tr_attrsetrt.tr_logres *
> > -					args->total;
> > +		tres.tr_logres = xfs_calc_attr_res(mp, &resv);
> 
> So instead of using the runtime reservation calculation, we call this
> new function that uses the block res structure and calculates log
> reservation for us. Seems like a decent cleanup, but I'm still having
> some trouble determining what is cleanup vs. what is fixing the res
> calculation.

Log reservation calculation for xattr set operation in XFS is
incorrect because,

- xfs_attr_set() computes the total log space reservation as the
  sum of 
  1. Mount time log reservation (M_RES(mp)->tr_attrsetm.tr_logres)
     Here, XFS incorrectly includes the number of blocks from root
     node to the leaf of a dabtree. This is incorrect because the
     number of such paths (from root node to leaf) depends on the
     size of the xattr. If the xattr is local but large enough to
     cause a double split then we would need three times the
     number of blocks in a path from root node to leaf. Hence the
     number of dabtree blocks that need to be logged is something
     that cannot be calculated at mount time.

     Also, the mount log reservation calcuation does not account
     for log space required for logging the AGF.
     
  2. Run time log reservatation
     This is calculated by multiplying two components,
     - The first component consists of sum of the following
       - Superblock
       - The number of bytes for logging a single path from root
         to leaf of a bmbt tree.
     - The second component consists of,
       - The number of dabtree blocks
       - The number of bmbt blocks required for mapping new
         dabtree blocks.
     Here Bmbt blocks gets accounted twice. Also it does not make sense to
     multiply these two components.

The other bug is related to calcuation performed in
xfs_log_calc_max_attrsetm_res(),
1. The call to XFS_DAENTER_SPACE_RES() macro returns the number of
   blocks required for a single split of dabtree and the
   corresponding number of bmbt blocks required for mapping the new
   dabtree blocks.
2. The space occupied by the attribute value is treated as if it
   were a remote attribute and the space for it along with the
   corresponding bmbt blocks required is added to the number of
   blocks obtained in step 1.
3. This sum is then multiplied with the runtime reservation. Here
   again Bmbt blocks gets accounted twice, once from the 'run time
   reservation' and the other from the call to
   XFS_DAENTER_SPACE_RES().
4. The result from step 3 is added to 'mount time log
   reservation'. This means that the log space reservation is
   accounted twice for dabtree blocks.

To solve these problems, the fix consists of,
1. Mounting time log reservation now includes only
   - Inode
   - Superblock
   - AGF
   i.e. we don't consider the dabtree logging space requirement
   when calculating mount time log reservation.

2. Run time log reservation
   To calculate run time log reservation we change xfs_attr_calc_size()
   to return, 
   1. Number of Dabtree blocks required.
   2. Number of Dabtree blocks that might need to be logged.
   3. Number of remote blocks.
   4. Number of Bmbt blocks that might be required.

   The values returned by xfs_attr_calc_size() is used by 
   - xfs_attr_set()
     - To compute total number of blocks required for attr set operation.
     - To compute the total log reservation (via a call to
       xfs_calc_attr_res()).
       - This uses dabtree blocks and bmbt blocks as input to calculate
         log space reservation for free space trees.
       - The total log space reservation is then computed by
         adding up 
         - Mount time log reservation space.
	 - dabtree blocks that need to logged and 
	 - free space tree blocks required.
   - xfs_log_calc_max_attrsetm_res()
     - To compute the log reservation space for a maximum sized local xattr.
       It uses the helper function xfs_calc_attr_res() accomplish this.
	  
   i.e. xfs_attr_calc_size() is now a helper function which
   returns various sizes (dabtree blocks, dabtree blocks that
   need to be logged, bmbt blocks, and remote blocks) that could be used by
   other functions (xfs_attr_set() and xfs_log_calc_max_attrsetm_res()) to
   obtain various block reservation values associated with xattrs.

One of the cleanups included in this patch was the addition of
xfs_calc_attr_res() function so that the reservation code is limited to
xfs_trans_resv.c.

Please let me know if the above explaination does not answer your question
satisfactorily.

> 
> >  		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> >  		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> >  		total = args->total;
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index 0e387230744c3..83508148bbd12 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -74,6 +74,9 @@ struct xfs_attr_list_context {
> >  };
> >  
> >  struct xfs_attr_set_resv {
> > +	/* Number of blocks in the da btree that we might need to log. */
> > +	unsigned int		log_dablks;
> > +
> >  	/* Number of unlogged blocks needed to store the remote attr value. */
> >  	unsigned int		rmt_blks;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> > index 7f55eb3f36536..a132ffa7adf32 100644
> > --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> > +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> > @@ -10,6 +10,7 @@
> >  #include "xfs_log_format.h"
> >  #include "xfs_trans_resv.h"
> >  #include "xfs_mount.h"
> > +#include "xfs_attr.h"
> >  #include "xfs_da_format.h"
> >  #include "xfs_trans_space.h"
> >  #include "xfs_da_btree.h"
> > @@ -21,19 +22,18 @@
> >   */
> >  STATIC int
> >  xfs_log_calc_max_attrsetm_res(
> > -	struct xfs_mount	*mp)
> > +	struct xfs_mount		*mp)
> >  {
> > -	int			size;
> > -	int			nblks;
> > +	struct xfs_attr_set_resv	resv;
> > +	int				size;
> > +	int				local;
> >  
> >  	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
> >  	       MAXNAMELEN - 1;
> > -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> > -	nblks += XFS_B_TO_FSB(mp, size);
> > -	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
> > +	xfs_attr_calc_size(mp, &resv, size, 0, &local);
> > +	ASSERT(local == 1);
> >  
> > -	return  M_RES(mp)->tr_attrsetm.tr_logres +
> > -		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
> > +	return xfs_calc_attr_res(mp, &resv);
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> > index 7a9c04920505a..c6b8cd56df2d7 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -19,6 +19,7 @@
> >  #include "xfs_trans.h"
> >  #include "xfs_qm.h"
> >  #include "xfs_trans_space.h"
> > +#include "xfs_attr.h"
> >  
> >  #define _ALLOC	true
> >  #define _FREE	false
> > @@ -701,12 +702,10 @@ xfs_calc_attrinval_reservation(
> >   * Setting an attribute at mount time.
> >   *	the inode getting the attribute
> >   *	the superblock for allocations
> > - *	the agfs extents are allocated from
> > - *	the attribute btree * max depth
> > - *	the inode allocation btree
> > + *	the agf extents are allocated from
> >   * Since attribute transaction space is dependent on the size of the attribute,
> >   * the calculation is done partially at mount time and partially at runtime(see
> > - * below).
> > + * xfs_attr_calc_size()).
> >   */
> >  STATIC uint
> >  xfs_calc_attrsetm_reservation(
> > @@ -714,27 +713,7 @@ xfs_calc_attrsetm_reservation(
> >  {
> >  	return XFS_DQUOT_LOGRES(mp) +
> >  		xfs_calc_inode_res(mp, 1) +
> > -		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> > -		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
> > -}
> > -
> > -/*
> > - * Setting an attribute at runtime, transaction space unit per block.
> > - * 	the superblock for allocations: sector size
> > - *	the inode bmap btree could join or split: max depth * block size
> > - * Since the runtime attribute transaction space is dependent on the total
> > - * blocks needed for the 1st bmap, here we calculate out the space unit for
> > - * one block so that the caller could figure out the total space according
> > - * to the attibute extent length in blocks by:
> > - *	ext * M_RES(mp)->tr_attrsetrt.tr_logres
> > - */
> > -STATIC uint
> > -xfs_calc_attrsetrt_reservation(
> > -	struct xfs_mount	*mp)
> > -{
> > -	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> > -		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
> > -				 XFS_FSB_TO_B(mp, 1));
> > +		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
> >  }
> >  
> >  /*
> > @@ -832,6 +811,25 @@ xfs_calc_sb_reservation(
> >  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
> >  }
> >  
> > +uint
> > +xfs_calc_attr_res(
> > +	struct xfs_mount		*mp,
> > +	struct xfs_attr_set_resv	*resv)
> > +{
> > +	unsigned int			space_blks;
> > +	unsigned int			attr_res;
> > +
> > +	space_blks = xfs_allocfree_log_count(mp,
> > +		resv->total_dablks + resv->bmbt_blks);
> > +
> > +	attr_res = M_RES(mp)->tr_attrsetm.tr_logres +
> > +		xfs_calc_buf_res(resv->log_dablks, mp->m_attr_geo->blksize) +
> > +		xfs_calc_buf_res(resv->bmbt_blks, mp->m_sb.sb_blocksize) +
> > +		xfs_calc_buf_res(space_blks, mp->m_sb.sb_blocksize);
> > +
> > +	return attr_res;
> > +}
> 
> This function could use a header comment to explain what the reservation
> covers.
>

Sure, I will do that.

> > +
> >  void
> >  xfs_trans_resv_calc(
> >  	struct xfs_mount	*mp,
> > @@ -942,7 +940,7 @@ xfs_trans_resv_calc(
> >  	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
> >  	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
> >  	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
> > -	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
> > +	resp->tr_attrsetrt.tr_logres = 0;
> 
> Should this go away if it's going to end up as zero?

Yes, you are right about this. I will remove this before posting the next
iteration of the patchset.

> >  	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
> >  	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
> >  	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> > index 7241ab28cf84f..3a6a0bf21e9b1 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.h
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> > @@ -7,6 +7,7 @@
> >  #define	__XFS_TRANS_RESV_H__
> >  
> >  struct xfs_mount;
> > +struct xfs_attr_set_resv;
> >  
> >  /*
> >   * structure for maintaining pre-calculated transaction reservations.
> > @@ -91,6 +92,7 @@ struct xfs_trans_resv {
> >  #define	XFS_ATTRSET_LOG_COUNT		3
> >  #define	XFS_ATTRRM_LOG_COUNT		3
> >  
> > +uint xfs_calc_attr_res(struct xfs_mount *mp, struct xfs_attr_set_resv *resv);
> >  void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
> >  uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
> >  
> 
> 

-- 
chandan



