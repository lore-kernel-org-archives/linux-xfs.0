Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0296EC2D0EA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 08:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB1EF206A1
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 08:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgDHIoi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 04:44:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3818 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgDHIoi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 04:44:38 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0388YjDh116357
        for <linux-xfs@vger.kernel.org>; Wed, 8 Apr 2020 04:44:37 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3091ykd0ke-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2020 04:44:36 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 8 Apr 2020 09:44:06 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Apr 2020 09:44:04 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0388iVaP30474398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Apr 2020 08:44:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BADBA4055;
        Wed,  8 Apr 2020 08:44:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F21BCA4051;
        Wed,  8 Apr 2020 08:44:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.71.18])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Apr 2020 08:44:29 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        bfoster@redhat.com
Subject: Re: [PATCH 1/2] xfs: Fix log reservation calculation for xattr insert operation
Date:   Wed, 08 Apr 2020 14:17:34 +0530
Organization: IBM
In-Reply-To: <20200407004955.GE21885@dread.disaster.area>
References: <20200404085203.1908-1-chandanrlinux@gmail.com> <20200404085203.1908-2-chandanrlinux@gmail.com> <20200407004955.GE21885@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20040808-0020-0000-0000-000003C3DBF4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040808-0021-0000-0000-0000221C9E99
Message-Id: <2566441.lnnSxWHcxk@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 mlxscore=0 suspectscore=1 bulkscore=0 adultscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080070
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, April 7, 2020 6:19 AM Dave Chinner wrote: 
> [chopped bits out of the diff to get the whole reservation in one
>  obvious piece of code.]
> 
> On Sat, Apr 04, 2020 at 02:22:02PM +0530, Chandan Rajendra wrote:
> > @@ -698,42 +699,36 @@ xfs_calc_attrinval_reservation(
> >  }
> >  
> >  /*
> > + * Setting an attribute.
> >   *	the inode getting the attribute
> >   *	the superblock for allocations
> > + *	the agf extents are allocated from
> >   *	the attribute btree * max depth
> > + *	the bmbt entries for da btree blocks
> > + *	the bmbt entries for remote blocks (if any)
> > + *	the allocation btrees.
> >   */
> >  STATIC uint
> > -xfs_calc_attrsetm_reservation(
> > +xfs_calc_attrset_reservation(
> >  	struct xfs_mount	*mp)
> >  {
> > +	int			max_rmt_blks;
> > +	int			da_blks;
> > +	int			bmbt_blks;
> > +
> > +	da_blks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> 
> #define XFS_DAENTER_BLOCKS(mp,w)        \
>         (XFS_DAENTER_1B(mp,w) * XFS_DAENTER_DBS(mp,w))
> #define XFS_DAENTER_1B(mp,w)    \
>         ((w) == XFS_DATA_FORK ? (mp)->m_dir_geo->fsbcount : 1)
> #define XFS_DAENTER_DBS(mp,w)   \
> 	(XFS_DA_NODE_MAXDEPTH + (((w) == XFS_DATA_FORK) ? 2 : 0))
> 
> So, da_blks contains the full da btree split depth * 1 block. i.e.
> 
> 	da_blks = XFS_DA_NODE_MAXDEPTH;
> 
> > +	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
> 
> #define XFS_DAENTER_BMAPS(mp,w)         \
>         (XFS_DAENTER_DBS(mp,w) * XFS_DAENTER_BMAP1B(mp,w))
> 
> #define XFS_DAENTER_BMAP1B(mp,w)        \
>         XFS_NEXTENTADD_SPACE_RES(mp, XFS_DAENTER_1B(mp, w), w)
> 
> So, bmbt_blks contains the full da btree split depth * the BMBT
> overhead for a single block allocation:
> 
> #define XFS_EXTENTADD_SPACE_RES(mp,w)   (XFS_BM_MAXLEVELS(mp,w) - 1)
> #define XFS_NEXTENTADD_SPACE_RES(mp,b,w)\
>         (((b + XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp) - 1) / \
> 	          XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * \
> 		            XFS_EXTENTADD_SPACE_RES(mp,w))
> 
> XFS_NEXTENTADD_SPACE_RES(1) = ((1 + N - 1) / N) * (XFS_BM_MAXLEVELS - 1)
> 		= (XFS_BM_MAXLEVELS - 1)
> 
> So, bmbt_blks = XFS_DA_NODE_MAXDEPTH * (XFS_BM_MAXLEVELS - 1)
> 
> IOWs, this bmbt reservation is assuming a full height BMBT
> modification on *every* dabtree node allocation. IOWs, we're
> reserving multiple times the log space for potential bmbt
> modifications than we are for the entire dabtree modification.
> That's why the individual dabtree reservations are so big....
> 
> > +	max_rmt_blks = xfs_attr3_rmt_blocks(mp, XATTR_SIZE_MAX);
> > +	bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, max_rmt_blks, XFS_ATTR_FORK);
> 
> And this assumes we are going to log at least another full bmbt
> modification.
> 
> IT seems to me that the worst case here is one full split and then
> every other allocation inserts at the start of an existing block and
> so updates pointers all the way up to the root. The impact is
> limited, though, because XFS_DA_NODE_MAXDEPTH = 5 and so the attr
> fork BMBT tree is not likely to reach anywhere near it's max depth
> on large filesystems.....
> 
> >  	return XFS_DQUOT_LOGRES(mp) +
> >  		xfs_calc_inode_res(mp, 1) +
> >  		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> > +		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> > +		xfs_calc_buf_res(da_blks, XFS_FSB_TO_B(mp, 1)) +
> > +		xfs_calc_buf_res(bmbt_blks, XFS_FSB_TO_B(mp, 1)) +
> > +		xfs_calc_buf_res(xfs_allocfree_log_count(mp, da_blks),
> >  				 XFS_FSB_TO_B(mp, 1));
> 
> Given the above, this looks OK. Worst case BMBT usage looks
> excessive, but there is a chance it could be required...
> 
> > diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> > index 88221c7a04ccf..6a22ad11b3825 100644
> > --- a/fs/xfs/libxfs/xfs_trans_space.h
> > +++ b/fs/xfs/libxfs/xfs_trans_space.h
> > @@ -38,8 +38,14 @@
> >  
> >  #define	XFS_DAENTER_1B(mp,w)	\
> >  	((w) == XFS_DATA_FORK ? (mp)->m_dir_geo->fsbcount : 1)
> > +/*
> > + * xattr set operation can cause the da btree to split twice in the
> > + * worst case. The double split is actually an extra leaf node rather
> > + * than a complete split of blocks in the path from root to a
> > + * leaf. The '1' in the macro below accounts for the extra leaf node.
> 
> It's not a double tree split, so don't describe it that way and then
> have to explain that it's not a double tree split!
> 
> /*
>  * When inserting a large local record into the dabtree leaf, we may
>  * need to split the leaf twice to make room to fit the new record
>  * into the new leaf. This double leaf split still only requires a
>  * single datree path update as the inserted leaves are at adjacent
>  * indexes. Hence we only need to account for an the extra leaf
>  * block in the attribute fork here.
>  */

Sure. I will change the comment. Thanks for the review.

-- 
chandan



