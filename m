Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 294E0C4BA3B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 09:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF3302467B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 09:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgB0JYq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 04:24:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728614AbgB0JYq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 04:24:46 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01R9KnTm145660
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 04:24:44 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydq6x7apq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 04:24:44 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 27 Feb 2020 09:24:42 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 09:24:39 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01R9OcpZ55443588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 09:24:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B34AA407B;
        Thu, 27 Feb 2020 09:24:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B2C6A4055;
        Thu, 27 Feb 2020 09:24:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.71.82])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 09:24:35 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 7/7] xfs: Fix log reservation calculation for xattr insert operation
Date:   Thu, 27 Feb 2020 14:44:11 +0530
Organization: IBM
In-Reply-To: <20200226185050.GD19695@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com> <2457163.KJ604EA27E@localhost.localdomain> <20200226185050.GD19695@bfoster>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022709-4275-0000-0000-000003A5EB9E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022709-4276-0000-0000-000038BA2962
Message-Id: <1915611.aRCDV9Np7A@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_02:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0
 phishscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002270075
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday, February 27, 2020 12:20 AM Brian Foster wrote: 
> On Wed, Feb 26, 2020 at 04:51:13PM +0530, Chandan Rajendra wrote:
> > On Tuesday, February 25, 2020 10:49 PM Brian Foster wrote: 
> > > On Mon, Feb 24, 2020 at 09:30:44AM +0530, Chandan Rajendra wrote:
> > > > Log space reservation for xattr insert operation can be divided into two
> > > > parts,
> > > > 1. Mount time
> > > >    - Inode
> > > >    - Superblock for accounting space allocations
> > > >    - AGF for accounting space used by count, block number, rmap and refcnt
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
> > > > Also, AGF log space reservation isn't accounted for.
> > > > 
> > > > Due to the reasons mentioned above, log reservation calculation for xattr
> > > > insert operation gives an incorrect value.
> > > > 
> > > > Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
> > > > an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.
> > > > 
> > > > To fix these issues, this commit changes xfs_attr_calc_size() to also
> > > > calculate the number of dabtree blocks that need to be logged.
> > > > 
> > > > xfs_attr_set() uses the following values computed by xfs_attr_calc_size()
> > > > 1. The number of dabtree blocks that need to be logged.
> > > > 2. The number of remote blocks that need to be allocated.
> > > > 3. The number of dabtree blocks that need to be allocated.
> > > > 4. The number of bmbt blocks that need to be allocated.
> > > > 5. The total number of blocks that need to be allocated.
> > > > 
> > > > ... to compute number of bytes that need to be reserved in the log.
> > > > 
> > > > This commit also modifies xfs_log_calc_max_attrsetm_res() to invoke
> > > > xfs_attr_calc_size() to obtain the number of blocks to be logged which it uses
> > > > to figure out the total number of bytes to be logged.
> > > > 
> > > > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_attr.c       |  7 +++--
> > > >  fs/xfs/libxfs/xfs_attr.h       |  3 ++
> > > >  fs/xfs/libxfs/xfs_log_rlimit.c | 16 +++++------
> > > >  fs/xfs/libxfs/xfs_trans_resv.c | 50 ++++++++++++++++------------------
> > > >  fs/xfs/libxfs/xfs_trans_resv.h |  2 ++
> > > >  5 files changed, 41 insertions(+), 37 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > index 1d62ce80d7949..f056f8597ee03 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > @@ -182,9 +182,12 @@ xfs_attr_calc_size(
> > > >  	size = xfs_attr_leaf_newentsize(mp->m_attr_geo, namelen, valuelen,
> > > >  			local);
> > > >  	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> > > > +	resv->log_dablks = 2 * resv->total_dablks;
> > > > +
> > > >  	if (*local) {
> > > >  		if (size > (blksize / 2)) {
> > > >  			/* Double split possible */
> > > > +			resv->log_dablks += resv->total_dablks;
> > > 
> > > I'm not quite clear on why log is double the total above, then we add an
> > > increment of total here. Can you elaborate on this?
> > 
> > - resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK); 
> > 
> >   This gives the number of dabtree blocks that we might need to allocate. If
> >   we do indeed allocate resv->total_dablks worth of blocks then it would mean
> >   that we would have split blocks from the root node to the leaf node of the
> >   dabtree. We would then need to log the following blocks,
> >   - Blocks belonging to the original path from root node to the leaf node.
> >   - The new set of blocks from the root node to the leaf node which resulted
> >     from splitting the corresponding blocks in the original path.
> >   Thus the number of blocks to be logged is 2 * resv->total_dablks.
> > 
> 
> Got it.
> 
> > - Double split
> >   If the size of the xattr is large enough to cause another split, then we
> >   would need yet another set of new blocks for representing the path from root
> >   to the leaf.  This is taken into consideration by 'resv->total_dablks *= 2'.
> >   These new blocks might also need to logged. So resv->log_dablks should be
> >   incremented by number of blocks b/w root node and the leaf. I now feel that
> >   the statement could be rewritten in the following manner, 'resv->log_dablks
> >   += XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK)' if that makes it easier to
> >   understand.
> > 
> 
> Yeah, it might be clearer overall to not intertwine the fields.
> 
> > > 
> > > >  			resv->total_dablks *= 2;
> > > >  		}
> > > >  		resv->rmt_blks = 0;
> > > > @@ -349,9 +352,7 @@ xfs_attr_set(
> > > >  				return error;
> > > >  		}
> > > >  
> > > > -		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> > > > -				 M_RES(mp)->tr_attrsetrt.tr_logres *
> > > > -					args->total;
> > > > +		tres.tr_logres = xfs_calc_attr_res(mp, &resv);
> > > 
> > > So instead of using the runtime reservation calculation, we call this
> > > new function that uses the block res structure and calculates log
> > > reservation for us. Seems like a decent cleanup, but I'm still having
> > > some trouble determining what is cleanup vs. what is fixing the res
> > > calculation.
> > 
> > Log reservation calculation for xattr set operation in XFS is
> > incorrect because,
> > 
> > - xfs_attr_set() computes the total log space reservation as the
> >   sum of 
> >   1. Mount time log reservation (M_RES(mp)->tr_attrsetm.tr_logres)
> >      Here, XFS incorrectly includes the number of blocks from root
> >      node to the leaf of a dabtree. This is incorrect because the
> >      number of such paths (from root node to leaf) depends on the
> >      size of the xattr. If the xattr is local but large enough to
> >      cause a double split then we would need three times the
> >      number of blocks in a path from root node to leaf. Hence the
> >      number of dabtree blocks that need to be logged is something
> >      that cannot be calculated at mount time.
> > 
> 
> Ok, so the dabtree portion doesn't properly account for dabtree splits
> and cannot do so as part of a mount time calculation.
> 
> >      Also, the mount log reservation calcuation does not account
> >      for log space required for logging the AGF.
> >  
> 
> Ok.
>     
> >   2. Run time log reservatation
> >      This is calculated by multiplying two components,
> >      - The first component consists of sum of the following
> >        - Superblock
> >        - The number of bytes for logging a single path from root
> >          to leaf of a bmbt tree.
> >      - The second component consists of,
> >        - The number of dabtree blocks
> >        - The number of bmbt blocks required for mapping new
> >          dabtree blocks.
> >      Here Bmbt blocks gets accounted twice. Also it does not make sense to
> >      multiply these two components.
> > 
> 
> Hm, Ok. I think I follow, though I'm still curious if this was a
> reproducible problem or not.
> 
> > The other bug is related to calcuation performed in
> > xfs_log_calc_max_attrsetm_res(),
> > 1. The call to XFS_DAENTER_SPACE_RES() macro returns the number of
> >    blocks required for a single split of dabtree and the
> >    corresponding number of bmbt blocks required for mapping the new
> >    dabtree blocks.
> > 2. The space occupied by the attribute value is treated as if it
> >    were a remote attribute and the space for it along with the
> >    corresponding bmbt blocks required is added to the number of
> >    blocks obtained in step 1.
> > 3. This sum is then multiplied with the runtime reservation. Here
> >    again Bmbt blocks gets accounted twice, once from the 'run time
> >    reservation' and the other from the call to
> >    XFS_DAENTER_SPACE_RES().
> > 4. The result from step 3 is added to 'mount time log
> >    reservation'. This means that the log space reservation is
> >    accounted twice for dabtree blocks.
> > 
> > To solve these problems, the fix consists of,
> > 1. Mounting time log reservation now includes only
> >    - Inode
> >    - Superblock
> >    - AGF
> >    i.e. we don't consider the dabtree logging space requirement
> >    when calculating mount time log reservation.
> > 
> > 2. Run time log reservation
> >    To calculate run time log reservation we change xfs_attr_calc_size()
> >    to return, 
> >    1. Number of Dabtree blocks required.
> >    2. Number of Dabtree blocks that might need to be logged.
> >    3. Number of remote blocks.
> >    4. Number of Bmbt blocks that might be required.
> > 
> 
> Can we further break down some of these changes into smaller patches
> that either fix one issue or do some refactoring? For example, one patch
> could move the existing rt reservation out of ->tr_attrsetrt (removing
> it) and establish the new xfs_calc_attr_res() function without changing
> the reservation. Another patch could move the dabtree component from the
> mount time to the runtime calculation. It's not clear to me if the
> individual components of the new rt calculation can be further broken
> down from there without risk of transient regression, but it seems we
> should at least be able to rework the reservation calculation in a
> single patch that does so from first principles with the necessary
> refactoring work to accommodate the proper mount/run time components
> already done..
> 

Sure, I will try to break it down into as many logical patches as possible.

-- 
chandan



