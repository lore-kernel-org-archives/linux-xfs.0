Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0933DC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 02:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiCQCXh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 22:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348793AbiCQCXh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 22:23:37 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD7611BEAA
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 19:22:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DF13C10E4935;
        Thu, 17 Mar 2022 13:22:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUfmN-006NNa-EF; Thu, 17 Mar 2022 13:22:19 +1100
Date:   Thu, 17 Mar 2022 13:22:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: make quota default to no warning limit at all
Message-ID: <20220317022219.GX3927073@dread.disaster.area>
References: <20220314180914.GN8224@magnolia>
 <fe974dac-bd1d-f3e7-6bd7-bc3f3cb56dd1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe974dac-bd1d-f3e7-6bd7-bc3f3cb56dd1@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62329b5d
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=5xOlfOR4AAAA:8
        a=7-415B0cAAAA:8 a=q-MXYPEFc9MjIKl_fUMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=SGlsW6VomvECssOqsvzv:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 12:41:08PM -0500, Eric Sandeen wrote:
> On 3/14/22 1:09 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Historically, the quota warning counter was never incremented on a
> > softlimit violation, and hence was never enforced.  Now that the counter
> > works, the default of 5 warnings is getting enforced, which is a
> > breakage that people aren't used to.  In the interest of not introducing
> > new fail to things that used to work, make the default warning limit of
> > zero, and make zero mean there is no limit.
> > 
> > Sorta-fixes: 4b8628d57b72 ("xfs: actually bump warning counts when we send warnings")
> > Reported-by: Eric Sandeen <sandeen@sandeen.net>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Darrick and I talked about this offline a bit yesterday, and I think
> we reached an understanding/agreement on this .... 
> 
> While this patch will solve the problem of low warning thresholds
> rendering timer thresholds useless, I'm still of the opinion that
> this is not a feature to fix, but an inadvertent/broken behavior to
> remove.
> 
> The concept of a warning limit in xfs quota has been documented as
> unimplemented for about 20+ years. Digging through ancient IRIX docs,
> the intent may have been to warn once per login session
> (which would make more sense with the current limit of 5.) However,
> nothing can be found in code archives to indicate that the warning
> counter was ever bumped by anything (until the semi-recent change in
> Linux.)
> 
> This feature is still documented as unimplemented in the xfs_quota
> man page.
> 
> And although there are skeletal functions to manipulate warning limits
> in xfs_quota, they cannot be disabled, and the interface differs from
> timer limits, so is barely usable.
> 
> There is no concept of a "warning limit" in non-xfs quota tools, either.
> 
> There is no documentation on what constitutes a warning event, or when
> it should be incremented.
> 
> tl;dr: While the warning counter bump has been upstream for some time
> now, I think we can argue that that does not constitute a feature that
> needs fixing or careful deprecation; TBH it looks more like a bug that
> should be fixed by removing the increment altogether.
> 
> And then I think we can agree that if warning limits hae been documented
> as unimplemented for 20+ years, we can also just remove any other code
> that is related to this unimplemented feature.

Sounds fine to me. THe less untested, undefined legacy code with
custom user APIs we have to carry around the better. Remove it all
before someone starts poking at it with a sharp stick and finds a
zany zero-day....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
