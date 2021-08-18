Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 861CFC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 02:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65E1F60FE6
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 02:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbhHRC0B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 22:26:01 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:45935 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236471AbhHRC0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Aug 2021 22:26:00 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 28C1A106040;
        Wed, 18 Aug 2021 12:25:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGBGZ-001yCg-9J; Wed, 18 Aug 2021 12:25:19 +1000
Date:   Wed, 18 Aug 2021 12:25:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/16] xfs: convert mount flags to features
Message-ID: <20210818022519.GQ3657114@dread.disaster.area>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-8-david@fromorbit.com>
 <20210811003800.GW3601443@magnolia>
 <20210811232856.GM3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811232856.GM3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=lsTls220AJqLQ3KEhqYA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 11, 2021 at 04:28:56PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 10, 2021 at 05:38:00PM -0700, Darrick J. Wong wrote:
> > On Tue, Aug 10, 2021 at 03:24:42PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Replace m_flags feature checks with xfs_has_<feature>() calls and
> > > rework the setup code to set flags in m_features.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > AFAICT the only change since last time is in xfs_inode.c, right?
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> I'm having some second thoughts about the attr2 handling in this patch.
> xfs/186 regresses like so:
> 
> --- /tmp/fstests/tests/xfs/186.out      2021-05-13 11:47:55.849859833 -0700
> +++ /var/tmp/fstests/xfs/186.out.bad    2021-08-11 15:36:38.892735511 -0700
> @@ -195,6 +195,7 @@
>  
>  =================================
>  ATTR
> +ATTR2
>  forkoff = 47
>  u.sfdir2.hdr.count = 25
>  u.sfdir2.hdr.i8count = 0
>
> AFAICT, prior to this patch, if a V4 fs did not have attr2 set in the
> ondisk superblock and the user did not mount with -oattr2, the fs would
> continue to use attr1 format.  Indeed, xfs_sbversion_add_attr2 did:
> 
> 	if ((mp->m_flags & XFS_MOUNT_ATTR2) &&
> 	    !(xfs_sb_version_hasattr2(&mp->m_sb))) {
> 		/* try to add feature to ondisk super */
> 	}
> 
> Now, however, we mix the two together -- if the ondisk super has attr2
> set, XFS_FEAT_ATTR2 will be set, and if the mount options include
> -oattr2, XFS_FEAT_ATTR2 will also be set.  Now that function does:
> 
> 	if (xfs_has_attr2(mp))
> 		return;
> 	if (xfs_has_noattr2(mp))
> 		return;
> 
> 	/* try to add feature to ondisk super */
> 
> The behavior is not the same here -- if neither the ondisk sb nor the
> mount options have attr2, we upgrade an attr1 fs to attr2.  I think this
> is why xfs/186 has this regression.

Hmmm - I think I changed it to do that explicitly at one point, then
didn't remove it when splitting out attr2 specific stuff. e.g. the
comment now says:

/*
 * Switch on the ATTR2 superblock bit (implies also FEATURES2) by default unless
 * we've explicitly been told not to use attr2 (i.e. noattr2 mount option).
 */

Which is how it's behaving.  I'll just revert then "upgrade by
default" behaviour and go back to the way it used to work. That'll
also fix the other problem you mention, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
