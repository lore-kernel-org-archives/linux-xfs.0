Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD8FC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 05:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9AFC64F95
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 05:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhCKFnM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 00:43:12 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56929 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229480AbhCKFmw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 00:42:52 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 081DE1041501;
        Thu, 11 Mar 2021 16:42:51 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKE5y-001AcF-AU; Thu, 11 Mar 2021 16:42:50 +1100
Date:   Thu, 11 Mar 2021 16:42:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/45] xfs: lift init CIL reservation out of xc_cil_lock
Message-ID: <20210311054250.GQ74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-34-david@fromorbit.com>
 <20210310232541.GG3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310232541.GG3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=_ZonnDCAnb5RZYq9FvEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 03:25:41PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:31PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The xc_cil_lock is the most highly contended lock in XFS now. To
> > start the process of getting rid of it, lift the initial reservation
> > of the CIL log space out from under the xc_cil_lock.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c | 27 ++++++++++++---------------
> >  1 file changed, 12 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index e6e36488f0c7..50101336a7f4 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -430,23 +430,19 @@ xlog_cil_insert_items(
> >  	 */
> >  	xlog_cil_insert_format_items(log, tp, &len);
> >  
> > -	spin_lock(&cil->xc_cil_lock);
> 
> Hm, so looking ahead, the next few patches keep kicking this spin_lock
> call further and further down in the file, and the commit messages give
> me the impression that this might even go away entirely?
> 
> Let me see, the CIL locks are:
> 
> xc_ctx_lock, which prevents transactions from committing (into the cil)
> any time the CIL itself is preparing a new commited item context so that
> it can xlog_write (to disk) the log vectors associated with the current
> context.

Yes.

> xc_cil_lock, which serializes transactions adding their items to the CIL
> in the first place, hence the motivation to reduce this hot lock?

Right - it protects manipulations to the CIL log item tracking and
tracking state.  This spin lock is the first global serialisation
point in the transaction commit path, so it effectively sees unbound
concurrency (reservations allow hundreds of transactions can be
committing simultaneously).

> xc_push_lock, which I think is used to coordinate the CIL push worker
> with all the upper level callers that want to force log items to disk?

Yes, this one protects the current push state.

> And the locking order of these three locks is...
> 
> xc_ctx_lock --> xc_push_lock
>     |
>     \---------> xc_cil_lock
> 
> Assuming I grokked all that, then I guess moving the spin_lock call
> works out because the test_and_clear_bit is atomic.  The rest of the
> accounting stuff here is just getting moved further down in the file and
> is still protected by xc_cil_lock.

Yes.

> If I understood all that,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
