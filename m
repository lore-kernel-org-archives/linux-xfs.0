Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA70C4BA12
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C18F324689
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgBZPA4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 10:00:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727289AbgBZPAz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 10:00:55 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QEpFJT106191
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2020 10:00:54 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ydqbsqt6p-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2020 10:00:54 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 26 Feb 2020 15:00:51 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 26 Feb 2020 15:00:48 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01QF0lNQ37945372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 15:00:47 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DDEFAE05F;
        Wed, 26 Feb 2020 15:00:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D249AE057;
        Wed, 26 Feb 2020 15:00:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.56.226])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Feb 2020 15:00:44 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 3/7] xfs: xfs_attr_calc_size: Calculate Bmbt blks only once
Date:   Wed, 26 Feb 2020 20:33:12 +0530
Organization: IBM
In-Reply-To: <20200225161152.GC54181@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com> <20200224040044.30923-4-chandanrlinux@gmail.com> <20200225161152.GC54181@bfoster>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20022615-0020-0000-0000-000003ADCEFB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022615-0021-0000-0000-00002205EA3A
Message-Id: <9720921.4HTaHYPh1W@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_05:2020-02-26,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0
 impostorscore=0 suspectscore=1 adultscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002260108
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, February 25, 2020 9:41 PM Brian Foster wrote: 
> On Mon, Feb 24, 2020 at 09:30:40AM +0530, Chandan Rajendra wrote:
> > The number of Bmbt blocks that is required can be calculated only once by
> > passing the sum of total number of dabtree blocks and remote blocks to
> > XFS_NEXTENTADD_SPACE_RES() macro.
> > 
> > Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> > ---
> 
> According to the cover letter this is fixing a reservation calculation
> issue, though the commit log kind of gives the impression it's a
> refactor. Can you elaborate on what this fixes in the commit log?
> 

XFS_NEXTENTADD_SPACE_RES() first figures out the number of Bmbt leaf blocks
needed for mapping the 'block count' passed to it as the second argument.
When calculating the number of leaf blocks, it accommodates the 'block count'
argument in groups of XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp). For each such
group it decides that a bmbt leaf block is required. For each of the leaf
blocks that needs to be allocated, it assumes that there will be a split of
the bmbt tree from root to leaf. Hence it multiplies the number of leaf blocks
with the maximum height of the tree.

With two individual calls to XFS_NEXTENTADD_SPACE_RES() (one is indirectly
through the call to XFS_DAENTER_BMAPS() => XFS_DAENTER_BMAP1B() and the other
is for remote attr blocks) we miss out on the opportunity to group the bmbt
leaf blocks and hence overcompensate on the bmbt blocks calculation.

Please let me know if my understanding is incorrect.

> 
> >  fs/xfs/libxfs/xfs_attr.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 942ba552e0bdd..a708b142f69b6 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -154,12 +154,10 @@ xfs_attr_calc_size(
> >  	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> >  			args->valuelen, local);
> >  	total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> > -	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
> >  	if (*local) {
> >  		if (size > (args->geo->blksize / 2)) {
> >  			/* Double split possible */
> >  			total_dablks *= 2;
> > -			bmbt_blks *= 2;
> >  		}
> >  		rmt_blks = 0;
> >  	} else {
> > @@ -168,10 +166,11 @@ xfs_attr_calc_size(
> >  		 * make room for the attribute value itself.
> >  		 */
> >  		rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> > -		bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, rmt_blks,
> > -				XFS_ATTR_FORK);
> >  	}
> >  
> > +	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp, total_dablks + rmt_blks,
> > +			XFS_ATTR_FORK);
> > +
> >  	return total_dablks + rmt_blks + bmbt_blks;
> >  }
> >  
> 
> 

-- 
chandan



