Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2F2C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 21:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38923208DB
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 21:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgINVyv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 17:54:51 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42835 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726031AbgINVyt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 17:54:49 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8B44E3ABAB3;
        Tue, 15 Sep 2020 07:54:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kHwQs-0001q6-BL; Tue, 15 Sep 2020 07:54:42 +1000
Date:   Tue, 15 Sep 2020 07:54:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] xfs: deprecate the V4 format
Message-ID: <20200914215442.GV12131@dread.disaster.area>
References: <20200911164311.GU7955@magnolia>
 <20200914072909.GC29046@infradead.org>
 <20200914211241.GA7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914211241.GA7955@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=KcmsTjQD c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=VM6WFpw-gFojB0hXiHEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 02:12:41PM -0700, Darrick J. Wong wrote:
> On Mon, Sep 14, 2020 at 08:29:09AM +0100, Christoph Hellwig wrote:
> > On Fri, Sep 11, 2020 at 09:43:11AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > The V4 filesystem format contains known weaknesses in the on-disk format
> > > that make metadata verification diffiult.  In addition, the format will
> > > does not support dates past 2038 and will not be upgraded to do so.
> > > Therefore, we should start the process of retiring the old format to
> > > close off attack surfaces and to encourage users to migrate onto V5.
> > > 
> > > Therefore, make XFS V4 support a configurable option.  For the first
> > > period it will be default Y in case some distributors want to withdraw
> > > support early; for the second period it will be default N so that anyone
> > > who wishes to continue support can do so; and after that, support will
> > > be removed from the kernel.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v3: be a little more helpful about old xfsprogs and warn more loudly
> > > about deprecation
> > > v2: define what is a V4 filesystem, update the administrator guide
> > 
> > Whie this patch itself looks good, I think the ifdef as is is rather
> > silly as it just prevents mounting v4 file systems without reaping any
> > benefits from that.
> > 
> > So at very least we should add a little helper like this:
> > 
> > static inline bool xfs_sb_is_v4(truct xfs_sb *sbp)
> > {
> > 	if (IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
> > 		return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4;
> > 	return false;
> > }
> > 
> > and use it in all the feature test macros to let the compile eliminate
> > all the dead code.
> 
> Oh, wait, you meant as a means for future patches to make various bits
> of code disappear, not just as a weird one-off thing for this particular
> patch?
> 
> I mean... maybe we should just stuff that into the hascrc predicate,
> like Eric sort of implied on irc.  Hmm, I'll look into that.

Killing dead code is not the goal of this patch, getting the policy
in place and documenting it sufficiently is the goal of this patch.

Optimise the implementation in follow-on patches, don't obfuscate
this one by commingling it with wide-spread code changes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
