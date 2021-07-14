Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 338AEC12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1374B613C9
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhGNXKZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:10:25 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:60546 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229928AbhGNXKZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 19:10:25 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 1C77F6A5F8;
        Thu, 15 Jul 2021 09:07:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3nyV-006bwL-Ip; Thu, 15 Jul 2021 09:07:31 +1000
Date:   Thu, 15 Jul 2021 09:07:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/16] xfs: reflect sb features in xfs_mount
Message-ID: <20210714230731.GB664593@dread.disaster.area>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-5-david@fromorbit.com>
 <20210714225603.GW22402@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714225603.GW22402@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=avMXpYPKzFtravpd0AoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 03:56:03PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 14, 2021 at 02:19:00PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently on-disk feature checks require decoding the superblock
> > fileds and so can be non-trivial. We have almost 400 hundred
> > individual feature checks in the XFS code, so this is a significant
> > amount of code. To reduce runtime check overhead, pre-process all
> > the version flags into a features field in the xfs_mount at mount
> > time so we can convert all the feature checks to a simple flag
> > check.
> > 
> > There is also a need to convert the dynamic feature flags to update
> > the m_features field. This is required for attr, attr2 and quota
> > features. New xfs_mount based wrappers are added for this.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 5db3fb184fbe..488f472cedba 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -3315,6 +3315,7 @@ xlog_do_recover(
> >  	xfs_buf_relse(bp);
> >  
> >  	/* re-initialise in-core superblock and geometry structures */
> > +	mp->m_features |= xfs_sb_version_to_features(sbp);
> 
> '|=' instead of '=' ?

Yes, that is intended.

> I would have expected assignment, but I guess the assumption here is
> that log recovery can process a sb update that adds a feature?  And that
> log recovery won't be turning off features?

Right, we can add but we should never remove on-disk feature bits at
runtime. Getting rid of the noattr2 shenanigans dropped the only
case where we remove feature bits at runtime. Also, see below....

> >  	xfs_reinit_percpu_counters(mp);
> >  	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
> >  	if (error) {
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 6be2a1c5b0f4..0ec463d91cce 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -225,6 +225,7 @@ xfs_readsb(
> >  		goto reread;
> >  	}
> >  
> > +	mp->m_features |= xfs_sb_version_to_features(sbp);
> 
> Also, can't this be a plain assignment?

Nope, because a couple of patches further down the series,
mp->m_features will already contain all the mount features that have
been set and we do not want to overwrite them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
