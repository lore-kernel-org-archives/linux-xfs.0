Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578C4C4BA13
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A15F24685
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgBZPBR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 10:01:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4378 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727000AbgBZPBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 10:01:17 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QEobQo123538
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2020 10:01:16 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yden17nm6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2020 10:01:16 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 26 Feb 2020 15:01:14 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Feb 2020 15:01:10 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01QF193T37618138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 15:01:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 616BBAE045;
        Wed, 26 Feb 2020 15:01:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B0F7AE058;
        Wed, 26 Feb 2020 15:01:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.56.226])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Feb 2020 15:01:07 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 4/7] xfs: Introduce struct xfs_attr_set_resv
Date:   Wed, 26 Feb 2020 16:10:11 +0530
Organization: IBM
In-Reply-To: <20200225162740.GD54181@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com> <20200224040044.30923-5-chandanrlinux@gmail.com> <20200225162740.GD54181@bfoster>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022615-4275-0000-0000-000003A5AFA8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022615-4276-0000-0000-000038B9C848
Message-Id: <7885122.svJq01I0Yp@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_05:2020-02-26,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=2 priorityscore=1501
 impostorscore=0 phishscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002260108
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, February 25, 2020 9:57 PM Brian Foster wrote: 
> On Mon, Feb 24, 2020 at 09:30:41AM +0530, Chandan Rajendra wrote:
> > The intermediate numbers calculated by xfs_attr_calc_size() will be needed by
> > a future commit to correctly calculate log reservation for xattr set
> > operation. Towards this goal, this commit introduces 'struct
> > xfs_attr_set_resv' to collect,
> > 1. Number of dabtree blocks.
> > 2. Number of remote blocks.
> > 3. Number of Bmbt blocks.
> > 4. Total number of blocks we need to reserve.
> > 
> > This will be returned as an out argument by xfs_attr_calc_size().
> > 
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c | 50 ++++++++++++++++++++++------------------
> >  fs/xfs/libxfs/xfs_attr.h | 13 +++++++++++
> >  2 files changed, 40 insertions(+), 23 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index a708b142f69b6..921acac71e5d9 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -136,16 +136,14 @@ xfs_attr_get(
> >  /*
> >   * Calculate how many blocks we need for the new attribute,
> >   */
> > -STATIC int
> > +STATIC void
> >  xfs_attr_calc_size(
> > -	struct xfs_da_args	*args,
> > -	int			*local)
> > +	struct xfs_da_args		*args,
> > +	struct xfs_attr_set_resv	*resv,
> > +	int				*local)
> >  {
> > -	struct xfs_mount	*mp = args->dp->i_mount;
> > -	unsigned int		total_dablks;
> > -	unsigned int		bmbt_blks;
> > -	unsigned int		rmt_blks;
> > -	int			size;
> > +	struct xfs_mount		*mp = args->dp->i_mount;
> > +	int				size;
> >  
> >  	/*
> >  	 * Determine space new attribute will use, and if it would be
> > @@ -153,25 +151,27 @@ xfs_attr_calc_size(
> >  	 */
> >  	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> >  			args->valuelen, local);
> > -	total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> > +	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> >  	if (*local) {
> >  		if (size > (args->geo->blksize / 2)) {
> >  			/* Double split possible */
> > -			total_dablks *= 2;
> > +			resv->total_dablks *= 2;
> >  		}
> > -		rmt_blks = 0;
> > +		resv->rmt_blks = 0;
> >  	} else {
> >  		/*
> >  		 * Out of line attribute, cannot double split, but
> >  		 * make room for the attribute value itself.
> >  		 */
> > -		rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> > +		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> >  	}
> >  
> > -	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp, total_dablks + rmt_blks,
> > -			XFS_ATTR_FORK);
> > +	resv->bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp,
> > +				resv->total_dablks + resv->rmt_blks,
> > +				XFS_ATTR_FORK);
> >  
> > -	return total_dablks + rmt_blks + bmbt_blks;
> > +	resv->alloc_blks = resv->total_dablks + resv->rmt_blks +
> > +		resv->bmbt_blks;
> 
> Do we really need a field to track the total of three other fields in
> the same structure? I'd rather just let the caller add them up for
> args.total if that's the only usage.
> 

You are right. The caller can derive total blocks from the other components. I
will fix this up in the next iteration of the patchset.

-- 
chandan



