Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9BBC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 21:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3FD20709
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 21:58:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NHZ0Uywk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgHRV6C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 17:58:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51534 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgHRV6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 17:58:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07ILvh0T004685;
        Tue, 18 Aug 2020 21:57:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dYkpWG3Yy0KJ9wcF1FEk5N+YVD+5dePbxajZUUIs16Q=;
 b=NHZ0UywkjmODEWA5cab5h/MUyU38lE3NhavTEhuAASdSQlHfATl4dLd1xBHptt6uhYz7
 FukjKK2YIt9vSKSQdcFYAYkiFiSd0oEHfpQ9oJCj+EEqKwfWwg75gHRyIi5qc065KaKw
 1IelIvSOXKjDKcGuh2LyItT+LCIAmTiNknAywizupB37o7B1GuqGKLiESGc7NgcbkTUY
 6mLXxk34HlbvADz09rcQyhdXbvl6UZBA1y4nPX3OE3143xwJlUkyr7Ed3ur8GdvvbiXn
 jHppyiraBMFC8EYGsjyYfDghWjfHDthAf8pEzOHcRd7s7mBCasPRbVJukWPfLIuicFMl 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32x7nmffx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 21:57:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07ILsGNB140752;
        Tue, 18 Aug 2020 21:57:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32xsfsdakn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 21:57:55 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07ILvmEI028066;
        Tue, 18 Aug 2020 21:57:48 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 14:57:48 -0700
Date:   Tue, 18 Aug 2020 14:57:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 02/10] xfs: Check for extent overflow when trivally
 adding a new extent
Message-ID: <20200818215746.GZ6096@magnolia>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
 <20200814080833.84760-3-chandanrlinux@gmail.com>
 <20200817065307.GB23516@infradead.org>
 <20200818214933.GB21744@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818214933.GB21744@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 19, 2020 at 07:49:33AM +1000, Dave Chinner wrote:
> On Mon, Aug 17, 2020 at 07:53:07AM +0100, Christoph Hellwig wrote:
> > On Fri, Aug 14, 2020 at 01:38:25PM +0530, Chandan Babu R wrote:
> > > When adding a new data extent (without modifying an inode's existing
> > > extents) the extent count increases only by 1. This commit checks for
> > > extent count overflow in such cases.
> > > 
> > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_bmap.c       | 8 ++++++++
> > >  fs/xfs/libxfs/xfs_inode_fork.h | 2 ++
> > >  fs/xfs/xfs_bmap_util.c         | 5 +++++
> > >  fs/xfs/xfs_dquot.c             | 8 +++++++-
> > >  fs/xfs/xfs_iomap.c             | 5 +++++
> > >  fs/xfs/xfs_rtalloc.c           | 5 +++++
> > >  6 files changed, 32 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index 9c40d5971035..e64f645415b1 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -4527,6 +4527,14 @@ xfs_bmapi_convert_delalloc(
> > >  		return error;
> > >  
> > >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > +
> > > +	if (whichfork == XFS_DATA_FORK) {
> > 
> > Should we add COW fork special casing to xfs_iext_count_may_overflow
> > instead?

That seems like a reasonable idea.

> > 
> > > +		error = xfs_iext_count_may_overflow(ip, whichfork,
> > > +				XFS_IEXT_ADD_CNT);
> > 
> > I find the XFS_IEXT_ADD_CNT define very confusing.  An explicit 1 passed
> > for a counter parameter makes a lot more sense to me.
> 
> I explicitly asked Chandan to convert all the magic numbers
> sprinkled in the previous patch to defined values. It was impossible
> to know whether the intended value was correct when it's just an
> open coded number because we don't know what the number actually
> stands for. And, in future, if we change the behaviour of a specific
> operation, then we only have to change a single value rather than
> having to track down and determine if every magic "1" is for an
> extent add operation or something different.

I prefer named flags over magic numbers too, though this named constant
doesn't have a comment describing what it does, and "ADD_CNT" doesn't
really tell me much.  The subsequent patches have comments, so maybe
this should just become:

/*
 * Worst-case increase in the fork extent count when we're adding a
 * single extent to a fork and there's no possibility of splitting an
 * existing mapping.
 */
#define XFS_IEXT_ADD_NOSPLIT	(1)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
