Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C5EC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 01:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A88320829
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 01:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgHSBBe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 21:01:34 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:48020 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726367AbgHSBBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 21:01:34 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 27D8C10A337;
        Wed, 19 Aug 2020 11:01:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k8CTn-0007mx-5N; Wed, 19 Aug 2020 11:01:27 +1000
Date:   Wed, 19 Aug 2020 11:01:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs: re-order AGI updates in unlink list updates
Message-ID: <20200819010127.GI21744@dread.disaster.area>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-11-david@fromorbit.com>
 <20200819002948.GX6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819002948.GX6096@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=wT3MtI5oxVCXOZgvfScA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 05:29:48PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 12, 2020 at 07:25:53PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We always access and check the AGI bucket entry for the unlinked
> > list even if we are not going to need it either for lookup or remove
> > purposes. Move the code that accesses the AGI to the code that
> > modifes the AGI, hence keeping the AGI accesses local to the code
> > that needs to modify it.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c | 84 ++++++++++++++++------------------------------
> >  1 file changed, 28 insertions(+), 56 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index b098e5df07e7..4f616e1b64dc 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1918,44 +1918,53 @@ xfs_inactive(
> >   */
> >  
> >  /*
> > - * Point the AGI unlinked bucket at an inode and log the results.  The caller
> > - * is responsible for validating the old value.
> > + * Point the AGI unlinked bucket at an inode and log the results. The caller
> > + * passes in the expected current agino the bucket points at via @cur_agino so
> > + * we can validate that we are about to remove the inode we expect to be
> > + * removing from the AGI bucket.
> >   */
> > -STATIC int
> > +static int
> >  xfs_iunlink_update_bucket(
> >  	struct xfs_trans	*tp,
> >  	xfs_agnumber_t		agno,
> >  	struct xfs_buf		*agibp,
> > -	xfs_agino_t		old_agino,
> > +	xfs_agino_t		cur_agino,
> 
> Hm.  So I think I understand the new role of this function better now
> that this patch moves into this function the checking of the bucket
> pointer and whatnot.  Would it be difficult to merge this patch with
> patch 4?

I really didn't want to remove the code that used the "head_agino"
for verification until I had moved all the list traversal
functionality to use the in memory unlinked list and had verified
that was correct....

I think merging them it could be done, but it will most likely
result in having to rebase and retest every subsequent patch...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
