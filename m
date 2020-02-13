Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBFC7C3B18B
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 14:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B381D2073C
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 14:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgBMOpK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 09:45:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40290 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbgBMOpK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Feb 2020 09:45:10 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01DEiqb8040654
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2020 09:45:09 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y3u52njj4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2020 09:45:09 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 13 Feb 2020 14:45:06 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 13 Feb 2020 14:45:04 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01DEj3fV50331670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 14:45:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43DC852051;
        Thu, 13 Feb 2020 14:45:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.70.133])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7974C5204F;
        Thu, 13 Feb 2020 14:45:01 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com
Subject: Re: [PATCH V3 2/2] xfs: Fix log reservation calculation for xattr insert operation
Date:   Thu, 13 Feb 2020 20:17:48 +0530
Organization: IBM
In-Reply-To: <20200212151327.GB17921@bfoster>
References: <20200129045939.10380-1-chandanrlinux@gmail.com> <20200129045939.10380-2-chandanrlinux@gmail.com> <20200212151327.GB17921@bfoster>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20021314-4275-0000-0000-000003A12665
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021314-4276-0000-0000-000038B527E9
Message-Id: <2276340.61n8Cpd3bG@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-13_05:2020-02-12,2020-02-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 suspectscore=1 phishscore=0 adultscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, February 12, 2020 8:43 PM Brian Foster wrote: 
> On Wed, Jan 29, 2020 at 10:29:39AM +0530, Chandan Rajendra wrote:
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
> > Also, AGF log space reservation isn't accounted for. Hence log reservation
> > calculation for xattr insert operation gives an incorrect value.
> > 
> > Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
> > an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.
> > 
> > To fix these issues, this commit refactors xfs_attr_calc_size() to calculate,
> > 1. The number of dabtree blocks that need to be logged.
> > 2. The number of remote blocks that need to be allocated.
> > 3. The number of dabtree blocks that need to be allocated.
> > 4. The number of bmbt blocks that need to be allocated.
> > 5. The total number of blocks that need to be allocated.
> > 
> > xfs_attr_set() uses this information to compute number of bytes that needs to
> > be reserved in the log.
> > 
> > This commit also modifies xfs_log_calc_max_attrsetm_res() to invoke
> > xfs_attr_calc_size() to obtain the number of blocks to be logged which it uses
> > to figure out the total number of bytes to be logged.
> > 
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > ---
> > Changelog:
> > V1 -> V2:
> > 1. Use convenience variables to reduce indentation of code.
> > 
> > V2 -> V3:
> > 1. Introduce 'struct xfs_attr_set_resv' to be used an as out parameter
> >    holding xattr reservation values.
> > 2. Calculate number of bmbt blocks and total allocation blocks within
> >    xfs_attr_calc_size().
> > 
> >  fs/xfs/libxfs/xfs_attr.c       | 93 +++++++++++++++++++---------------
> >  fs/xfs/libxfs/xfs_attr.h       | 20 +++++++-
> >  fs/xfs/libxfs/xfs_log_rlimit.c | 14 ++---
> >  fs/xfs/libxfs/xfs_trans_resv.c | 52 +++++++++----------
> >  fs/xfs/libxfs/xfs_trans_resv.h |  2 +
> >  5 files changed, 107 insertions(+), 74 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 1eae1db74f6cd..1f3b001a1092e 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
> > @@ -248,6 +211,53 @@ xfs_attr_try_sf_addname(
> >  	return error ? error : error2;
> >  }
> >  
> > +/*
> > + * Calculate how many blocks we need for the new attribute,
> > + */
> > +void
> > +xfs_attr_calc_size(
> > +	struct xfs_mount		*mp,
> > +	struct xfs_attr_set_resv	*resv,
> > +	int				namelen,
> > +	int				valuelen,
> > +	int				*local)
> > +{
> > +	unsigned int		blksize;
> > +	int			size;
> > +
> > +	blksize = mp->m_dir_geo->blksize;
> > +
> > +	/*
> > +	 * Determine space new attribute will use, and if it would be
> > +	 * "local" or "remote" (note: local != inline).
> > +	 */
> > +	size = xfs_attr_leaf_newentsize(mp, namelen, valuelen, local);
> > +
> > +	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> > +	resv->log_dablks = 2 * resv->total_dablks;
> > +
> 
> It looks like this changes the setxattr transaction reservation
> calculation at the same time as refactoring how the reservation is
> calculated, which makes it hard to even identify what is changing. Can
> you split the general refactoring and calculation changes into
> independent patches? E.g., refactor the existing calculation first and
> then subsequently fix up the calculation..?

Sure.

I will also rebase my patches on top of Christoph's "Clean attr
interface" patchset and post the next version.

-- 
chandan



