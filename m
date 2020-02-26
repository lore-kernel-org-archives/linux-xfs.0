Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB64C4BA12
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1254A24685
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBZPBV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 10:01:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22864 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbgBZPBV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 10:01:21 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QEnRYZ013173
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2020 10:01:20 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydkf98kup-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2020 10:01:20 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 26 Feb 2020 15:01:17 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Feb 2020 15:01:15 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01QF1EYW8650958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 15:01:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DAD0AE045;
        Wed, 26 Feb 2020 15:01:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F40CAE053;
        Wed, 26 Feb 2020 15:01:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.56.226])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Feb 2020 15:01:12 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 2/7] xfs: xfs_attr_calc_size: Use local variables to track individual space components
Date:   Wed, 26 Feb 2020 16:08:30 +0530
Organization: IBM
In-Reply-To: <20200225161122.GB54181@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com> <20200224040044.30923-3-chandanrlinux@gmail.com> <20200225161122.GB54181@bfoster>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022615-0012-0000-0000-0000038A7E8B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022615-0013-0000-0000-000021C724C7
Message-Id: <4100623.evXuih0XHh@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_05:2020-02-26,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 suspectscore=1 malwarescore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 bulkscore=0 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002260108
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, February 25, 2020 9:41 PM Brian Foster wrote: 
> On Mon, Feb 24, 2020 at 09:30:39AM +0530, Chandan Rajendra wrote:
> > The size calculated by xfs_attr_calc_size() is a sum of three components,
> > 1. Number of dabtree blocks
> > 2. Number of Bmbt blocks
> > 3. Number of remote blocks
> > 
> > This commit introduces new local variables to track these numbers explicitly.
> > 
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c | 19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 1875210cc8e40..942ba552e0bdd 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -142,8 +142,10 @@ xfs_attr_calc_size(
> >  	int			*local)
> >  {
> >  	struct xfs_mount	*mp = args->dp->i_mount;
> > +	unsigned int		total_dablks;
> > +	unsigned int		bmbt_blks;
> > +	unsigned int		rmt_blks;
> >  	int			size;
> > -	int			nblks;
> >  
> >  	/*
> >  	 * Determine space new attribute will use, and if it would be
> > @@ -151,23 +153,26 @@ xfs_attr_calc_size(
> >  	 */
> >  	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> >  			args->valuelen, local);
> > -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> > +	total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> > +	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
> >  	if (*local) {
> >  		if (size > (args->geo->blksize / 2)) {
> >  			/* Double split possible */
> > -			nblks *= 2;
> > +			total_dablks *= 2;
> > +			bmbt_blks *= 2;
> >  		}
> > +		rmt_blks = 0;
> 
> I'd just initialize this one to zero above. Otherwise looks fine:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the review. I will fix this up in the next iteration of the
patchset.

-- 
chandan



