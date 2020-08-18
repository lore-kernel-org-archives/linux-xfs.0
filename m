Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0E8C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 21:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 232DB20709
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 21:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgHRVtk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 17:49:40 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:49442 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbgHRVtk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 17:49:40 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id E035ED5BC5A;
        Wed, 19 Aug 2020 07:49:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k89U5-0006Te-78; Wed, 19 Aug 2020 07:49:33 +1000
Date:   Wed, 19 Aug 2020 07:49:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH V2 02/10] xfs: Check for extent overflow when trivally
 adding a new extent
Message-ID: <20200818214933.GB21744@dread.disaster.area>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
 <20200814080833.84760-3-chandanrlinux@gmail.com>
 <20200817065307.GB23516@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817065307.GB23516@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
        a=t0JkLth6AlLFBHcLFfAA:9 a=IhHTf9sAGjgboNod:21 a=O9P3TnGLjZLGWbpE:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 17, 2020 at 07:53:07AM +0100, Christoph Hellwig wrote:
> On Fri, Aug 14, 2020 at 01:38:25PM +0530, Chandan Babu R wrote:
> > When adding a new data extent (without modifying an inode's existing
> > extents) the extent count increases only by 1. This commit checks for
> > extent count overflow in such cases.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c       | 8 ++++++++
> >  fs/xfs/libxfs/xfs_inode_fork.h | 2 ++
> >  fs/xfs/xfs_bmap_util.c         | 5 +++++
> >  fs/xfs/xfs_dquot.c             | 8 +++++++-
> >  fs/xfs/xfs_iomap.c             | 5 +++++
> >  fs/xfs/xfs_rtalloc.c           | 5 +++++
> >  6 files changed, 32 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 9c40d5971035..e64f645415b1 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4527,6 +4527,14 @@ xfs_bmapi_convert_delalloc(
> >  		return error;
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +
> > +	if (whichfork == XFS_DATA_FORK) {
> 
> Should we add COW fork special casing to xfs_iext_count_may_overflow
> instead?
> 
> > +		error = xfs_iext_count_may_overflow(ip, whichfork,
> > +				XFS_IEXT_ADD_CNT);
> 
> I find the XFS_IEXT_ADD_CNT define very confusing.  An explicit 1 passed
> for a counter parameter makes a lot more sense to me.

I explicitly asked Chandan to convert all the magic numbers
sprinkled in the previous patch to defined values. It was impossible
to know whether the intended value was correct when it's just an
open coded number because we don't know what the number actually
stands for. And, in future, if we change the behaviour of a specific
operation, then we only have to change a single value rather than
having to track down and determine if every magic "1" is for an
extent add operation or something different.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
