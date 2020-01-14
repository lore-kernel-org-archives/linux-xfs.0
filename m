Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF2EC33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 10:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4735324672
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 10:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgANKhZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:37:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbgANKhZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 05:37:25 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00EARZsZ041510
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2020 05:37:25 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xfavyv4dq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2020 05:37:24 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Tue, 14 Jan 2020 10:37:21 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 14 Jan 2020 10:37:18 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00EAbHGe37683700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jan 2020 10:37:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98BDAAE057;
        Tue, 14 Jan 2020 10:37:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69252AE053;
        Tue, 14 Jan 2020 10:37:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.51.219])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jan 2020 10:37:16 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Pass xattr name and value length explicitly to xfs_attr_leaf_newentsize
Date:   Tue, 14 Jan 2020 16:09:52 +0530
Organization: IBM
In-Reply-To: <20200113200843.GK8247@magnolia>
References: <20200110042953.18557-1-chandanrlinux@gmail.com> <20200113200843.GK8247@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20011410-0016-0000-0000-000002DD2E7B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011410-0017-0000-0000-0000333FBCE4
Message-Id: <2377606.TiqrJJHKO2@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_03:2020-01-13,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=1 adultscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001140093
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, January 14, 2020 1:38 AM Darrick J. Wong wrote: 
> On Fri, Jan 10, 2020 at 09:59:52AM +0530, Chandan Rajendra wrote:
> > This commit changes xfs_attr_leaf_newentsize() to explicitly accept name and
> > value length instead of a pointer to struct xfs_da_args. The next commit will
> > need to invoke xfs_attr_leaf_newentsize() from functions that do not have
> > a struct xfs_da_args to pass in.
> > 
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> 
> Mechanically this looks reasonable, but does this intersect in any way
> with Allison's delayed attrs patchset?

I don't think so since the patch is only open coding the arguments and the
next one fixes an incorrect log reservation calculation.

> 
> > ---
> >  fs/xfs/libxfs/xfs_attr.c      |  3 ++-
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 33 +++++++++++++++++++++++----------
> >  fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
> >  3 files changed, 27 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 0d7fcc983b3d..1eae1db74f6c 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -199,7 +199,8 @@ xfs_attr_calc_size(
> >  	 * Determine space new attribute will use, and if it would be
> >  	 * "local" or "remote" (note: local != inline).
> >  	 */
> > -	size = xfs_attr_leaf_newentsize(args, local);
> > +	size = xfs_attr_leaf_newentsize(mp, args->namelen, args->valuelen,
> > +					local);
> >  	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> >  	if (*local) {
> >  		if (size > (args->geo->blksize / 2)) {
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index 08d4b10ae2d5..71024d4aa562 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -1338,7 +1338,8 @@ xfs_attr3_leaf_add(
> >  	leaf = bp->b_addr;
> >  	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
> >  	ASSERT(args->index >= 0 && args->index <= ichdr.count);
> > -	entsize = xfs_attr_leaf_newentsize(args, NULL);
> > +	entsize = xfs_attr_leaf_newentsize(args->dp->i_mount, args->namelen,
> > +					args->valuelen, NULL);
> >  
> >  	/*
> >  	 * Search through freemap for first-fit on new name length.
> > @@ -1440,11 +1441,14 @@ xfs_attr3_leaf_add_work(
> >  	ASSERT(ichdr->freemap[mapindex].base < args->geo->blksize);
> >  	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
> >  	ASSERT(ichdr->freemap[mapindex].size >=
> > -		xfs_attr_leaf_newentsize(args, NULL));
> > +		xfs_attr_leaf_newentsize(mp, args->namelen,
> > +					args->valuelen, NULL));
> >  	ASSERT(ichdr->freemap[mapindex].size < args->geo->blksize);
> >  	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
> >  
> > -	ichdr->freemap[mapindex].size -= xfs_attr_leaf_newentsize(args, &tmp);
> > +	ichdr->freemap[mapindex].size -=
> > +		xfs_attr_leaf_newentsize(mp, args->namelen, args->valuelen,
> > +					&tmp);
> 
> Also these lines (long_lvalue op evenlonger_rvalue) are getting pretty
> gross and hard to read, can we please use some convenience variables?
> 
> 	entsize = xfs_attr_leaf_newentsize(mp, args->namelen, args->valuelen,
> 			&tmp);
> 	ichdr->freemap[mapindex].size -= entsize;
> 
> is a little easier to read than parsing through three levels of
> indentation for one statement.

Sure, I will make the relevant changes.

> 
> Also vaguely wondering about the necessity of opencoding the args, but
> let's go argue about that in the next patch.
> 
> --D
> 
> >  
> >  	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
> >  				     ichdr->freemap[mapindex].size);
> > @@ -1831,6 +1835,7 @@ xfs_attr3_leaf_figure_balance(
> >  	struct xfs_attr_leafblock	*leaf1 = blk1->bp->b_addr;
> >  	struct xfs_attr_leafblock	*leaf2 = blk2->bp->b_addr;
> >  	struct xfs_attr_leaf_entry	*entry;
> > +	struct xfs_da_args		*args;
> >  	int				count;
> >  	int				max;
> >  	int				index;
> > @@ -1840,6 +1845,7 @@ xfs_attr3_leaf_figure_balance(
> >  	int				foundit = 0;
> >  	int				tmp;
> >  
> > +	args = state->args;
> >  	/*
> >  	 * Examine entries until we reduce the absolute difference in
> >  	 * byte usage between the two blocks to a minimum.
> > @@ -1847,7 +1853,8 @@ xfs_attr3_leaf_figure_balance(
> >  	max = ichdr1->count + ichdr2->count;
> >  	half = (max + 1) * sizeof(*entry);
> >  	half += ichdr1->usedbytes + ichdr2->usedbytes +
> > -			xfs_attr_leaf_newentsize(state->args, NULL);
> > +		xfs_attr_leaf_newentsize(state->mp, args->namelen,
> > +					args->valuelen, NULL);
> >  	half /= 2;
> >  	lastdelta = state->args->geo->blksize;
> >  	entry = xfs_attr3_leaf_entryp(leaf1);
> > @@ -1859,7 +1866,10 @@ xfs_attr3_leaf_figure_balance(
> >  		 */
> >  		if (count == blk1->index) {
> >  			tmp = totallen + sizeof(*entry) +
> > -				xfs_attr_leaf_newentsize(state->args, NULL);
> > +				xfs_attr_leaf_newentsize(state->mp,
> > +							args->namelen,
> > +							args->valuelen,
> > +							NULL);
> >  			if (XFS_ATTR_ABS(half - tmp) > lastdelta)
> >  				break;
> >  			lastdelta = XFS_ATTR_ABS(half - tmp);
> > @@ -1895,7 +1905,8 @@ xfs_attr3_leaf_figure_balance(
> >  	totallen -= count * sizeof(*entry);
> >  	if (foundit) {
> >  		totallen -= sizeof(*entry) +
> > -				xfs_attr_leaf_newentsize(state->args, NULL);
> > +			xfs_attr_leaf_newentsize(state->mp, args->namelen,
> > +						args->valuelen, NULL);
> >  	}
> >  
> >  	*countarg = count;
> > @@ -2687,20 +2698,22 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index)
> >   */
> >  int
> >  xfs_attr_leaf_newentsize(
> > -	struct xfs_da_args	*args,
> > +	struct xfs_mount	*mp,
> > +	int			namelen,
> > +	int			valuelen,
> >  	int			*local)
> >  {
> >  	int			size;
> >  
> > -	size = xfs_attr_leaf_entsize_local(args->namelen, args->valuelen);
> > -	if (size < xfs_attr_leaf_entsize_local_max(args->geo->blksize)) {
> > +	size = xfs_attr_leaf_entsize_local(namelen, valuelen);
> > +	if (size < xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize)) {
> >  		if (local)
> >  			*local = 1;
> >  		return size;
> >  	}
> >  	if (local)
> >  		*local = 0;
> > -	return xfs_attr_leaf_entsize_remote(args->namelen);
> > +	return xfs_attr_leaf_entsize_remote(namelen);
> >  }
> >  
> >  
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> > index f4a188e28b7b..0ce1f9301157 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> > @@ -106,7 +106,8 @@ void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
> >  xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_buf *bp, int *count);
> >  int	xfs_attr_leaf_order(struct xfs_buf *leaf1_bp,
> >  				   struct xfs_buf *leaf2_bp);
> > -int	xfs_attr_leaf_newentsize(struct xfs_da_args *args, int *local);
> > +int	xfs_attr_leaf_newentsize(struct xfs_mount *mp, int namelen,
> > +			int valuelen, int *local);
> >  int	xfs_attr3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
> >  			xfs_dablk_t bno, struct xfs_buf **bpp);
> >  void	xfs_attr3_leaf_hdr_from_disk(struct xfs_da_geometry *geo,
> 

-- 
chandan



