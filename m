Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07E5C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C67BE207FB
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgHSAph (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:45:37 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:35871 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726794AbgHSApg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:45:36 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 11B426ACBEC;
        Wed, 19 Aug 2020 10:45:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k8CEN-0007ck-4A; Wed, 19 Aug 2020 10:45:31 +1000
Date:   Wed, 19 Aug 2020 10:45:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: arrange all unlinked inodes into one list
Message-ID: <20200819004531.GF21744@dread.disaster.area>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-5-david@fromorbit.com>
 <20200818235959.GR6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818235959.GR6096@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ZkATD6QEjSD8yBUozakA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 04:59:59PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 12, 2020 at 07:25:47PM +1000, Dave Chinner wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > We currently keep unlinked lists short on disk by hashing the inodes
> > across multiple buckets. We don't need to ikeep them short anymore
> > as we no longer need to traverse the entire to remove an inode from
> > it. The in-memory back reference index provides the previous inode
> > in the list for us instead.
> > 
> > Log recovery still has to handle existing filesystems that use all
> > 64 on-disk buckets so we detect and handle this case specially so
> > that so inode eviction can still work properly in recovery.
> > 
> > [dchinner: imported into parent patch series early on and modified
> > to fit cleanly. ]
> > 
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c | 49 +++++++++++++++++++++++++++-------------------
> >  1 file changed, 29 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index f2f502b65691..fa92bdf6e0da 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -33,6 +33,7 @@
> >  #include "xfs_symlink.h"
> >  #include "xfs_trans_priv.h"
> >  #include "xfs_log.h"
> > +#include "xfs_log_priv.h"
> >  #include "xfs_bmap_btree.h"
> >  #include "xfs_reflink.h"
> >  
> > @@ -2092,25 +2093,32 @@ xfs_iunlink_update_bucket(
> >  	struct xfs_trans	*tp,
> >  	xfs_agnumber_t		agno,
> >  	struct xfs_buf		*agibp,
> > -	unsigned int		bucket_index,
> > +	xfs_agino_t		old_agino,
> >  	xfs_agino_t		new_agino)
> >  {
> > +	struct xlog		*log = tp->t_mountp->m_log;
> >  	struct xfs_agi		*agi = agibp->b_addr;
> >  	xfs_agino_t		old_value;
> > -	int			offset;
> > +	unsigned int		bucket_index;
> > +	int                     offset;
> >  
> >  	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, agno, new_agino));
> >  
> > +	bucket_index = 0;
> > +	/* During recovery, the old multiple bucket index can be applied */
> > +	if (!log || log->l_flags & XLOG_RECOVERY_NEEDED) {
> 
> Does the flag test need parentheses?

Yes, will fix.

> It feels a little funny that we pass in old_agino (having gotten it from
> agi_unlinked) and then compare it with agi_unlinked, but as the commit
> log points out, I guess this is a wart of having to support the old
> unlinked list behavior.  It makes sense to me that if we're going to
> change the unlinked list behavior we could be a little more careful
> about double-checking things.
> 
> Question: if a newer kernel crashes with a super-long unlinked list and
> the fs gets recovered on an old kernel, will this lead to insanely high
> recovery times?  I think the answer is no, because recovery is single
> threaded and the hash only existed to reduce AGI contention during
> normal unlinking operations?

Right, the answer is no because log recovery even on old kernels
always recovers the inode at the head of the list. It does no
traversal, so it doesn't matter if it's recovering one list or 64
lists, the recovery time is the same.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
