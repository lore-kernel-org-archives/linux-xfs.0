Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16054C4BA3B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 09:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7C3E24688
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 09:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgB0JYY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 04:24:24 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728614AbgB0JYY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 04:24:24 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01R9Jp6I115398
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 04:24:23 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ydqf8ejfj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 04:24:22 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 27 Feb 2020 09:24:20 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Feb 2020 09:24:17 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01R9OGdU58523770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 09:24:16 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F84CA405D;
        Thu, 27 Feb 2020 09:24:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E6F5A4055;
        Thu, 27 Feb 2020 09:24:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.71.82])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 09:24:13 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 1/7] xfs: Pass xattr name and value length explicitly to xfs_attr_leaf_newentsize
Date:   Thu, 27 Feb 2020 14:57:07 +0530
Organization: IBM
In-Reply-To: <20200226165852.GA10529@infradead.org>
References: <20200224040044.30923-1-chandanrlinux@gmail.com> <20200224040044.30923-2-chandanrlinux@gmail.com> <20200226165852.GA10529@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022709-0012-0000-0000-0000038AB9E3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022709-0013-0000-0000-000021C76271
Message-Id: <3674803.ahhNVcWJD3@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_02:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 mlxlogscore=999 bulkscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 malwarescore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270075
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday, February 26, 2020 10:28 PM Christoph Hellwig wrote: 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index fae322105457a..65a3bf40c4f9d 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -1403,6 +1404,7 @@ xfs_attr3_leaf_add_work(
> >  	struct xfs_attr_leaf_name_local *name_loc;
> >  	struct xfs_attr_leaf_name_remote *name_rmt;
> >  	struct xfs_mount	*mp;
> > +	int			entsize;
> >  	int			tmp;
> >  	int			i;
> >  
> > @@ -1432,11 +1434,14 @@ xfs_attr3_leaf_add_work(
> >  	ASSERT(ichdr->freemap[mapindex].base < args->geo->blksize);
> >  	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
> >  	ASSERT(ichdr->freemap[mapindex].size >=
> > -		xfs_attr_leaf_newentsize(args, NULL));
> > +		xfs_attr_leaf_newentsize(args->geo, args->namelen,
> > +				args->valuelen, NULL));
> >  	ASSERT(ichdr->freemap[mapindex].size < args->geo->blksize);
> >  	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
> >  
> > -	ichdr->freemap[mapindex].size -= xfs_attr_leaf_newentsize(args, &tmp);
> > +	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> > +			args->valuelen, &tmp);
> > +	ichdr->freemap[mapindex].size -= entsize;
> 
> As-is this entsize variable is a little pointless.  Please move the
> assignment to it up and reuse it in the assert.
> 
> > @@ -1824,6 +1829,8 @@ xfs_attr3_leaf_figure_balance(
> >  	struct xfs_attr_leafblock	*leaf1 = blk1->bp->b_addr;
> >  	struct xfs_attr_leafblock	*leaf2 = blk2->bp->b_addr;
> >  	struct xfs_attr_leaf_entry	*entry;
> > +	struct xfs_da_args		*args;
> > +	int				entsize;
> >  	int				count;
> >  	int				max;
> >  	int				index;
> > @@ -1833,14 +1840,16 @@ xfs_attr3_leaf_figure_balance(
> >  	int				foundit = 0;
> >  	int				tmp;
> >  
> > +	args = state->args;
> 
> Please assign the value to the variable at the time of declaration.
> 
> >  	/*
> >  	 * Examine entries until we reduce the absolute difference in
> >  	 * byte usage between the two blocks to a minimum.
> >  	 */
> >  	max = ichdr1->count + ichdr2->count;
> >  	half = (max + 1) * sizeof(*entry);
> > -	half += ichdr1->usedbytes + ichdr2->usedbytes +
> > -			xfs_attr_leaf_newentsize(state->args, NULL);
> > +	entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> > +			args->valuelen, NULL);
> > +	half += ichdr1->usedbytes + ichdr2->usedbytes + entsize;
> >  	half /= 2;
> >  	lastdelta = state->args->geo->blksize;
> >  	entry = xfs_attr3_leaf_entryp(leaf1);
> > @@ -1851,8 +1860,9 @@ xfs_attr3_leaf_figure_balance(
> >  		 * The new entry is in the first block, account for it.
> >  		 */
> >  		if (count == blk1->index) {
> > -			tmp = totallen + sizeof(*entry) +
> > -				xfs_attr_leaf_newentsize(state->args, NULL);
> > +			entsize = xfs_attr_leaf_newentsize(args->geo,
> > +					args->namelen, args->valuelen, NULL);
> > +			tmp = totallen + sizeof(*entry) + entsize;
> >  			if (XFS_ATTR_ABS(half - tmp) > lastdelta)
> >  				break;
> >  			lastdelta = XFS_ATTR_ABS(half - tmp);
> > @@ -1887,8 +1897,9 @@ xfs_attr3_leaf_figure_balance(
> >  	 */
> >  	totallen -= count * sizeof(*entry);
> >  	if (foundit) {
> > -		totallen -= sizeof(*entry) +
> > -				xfs_attr_leaf_newentsize(state->args, NULL);
> > +		entsize = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> > +				args->valuelen, NULL);
> > +		totallen -= sizeof(*entry) + entsize;
> 
> AFAICS there is no need to assign the same value to entsize again and
> again in this function.  It should be enough to assign to it once and
> then reuse the value.
> 

Sorry about those redundant function calls. I will include the changes
suggested in the next version of the patchset.

-- 
chandan



