Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB54DC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 01:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3DCF60C3E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 01:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbhHRBSu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 21:18:50 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:38723 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237567AbhHRBSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Aug 2021 21:18:45 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 54B791B5D41;
        Wed, 18 Aug 2021 11:18:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGADX-001x3A-UO; Wed, 18 Aug 2021 11:18:07 +1000
Date:   Wed, 18 Aug 2021 11:18:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: rework attr2 feature and mount options
Message-ID: <20210818011807.GN3657114@dread.disaster.area>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-4-david@fromorbit.com>
 <20210811230405.GL3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811230405.GL3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=O6p7oCgSvPx5u9CdYSEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 11, 2021 at 04:04:05PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 10, 2021 at 03:24:38PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The attr2 feature is somewhat unique in that it has both a superblock
> > feature bit to enable it and mount options to enable and disable it.
> > 
> > Back when it was first introduced in 2005, attr2 was disabled unless
> > either the attr2 superblock feature bit was set, or the attr2 mount
> > option was set. If the superblock feature bit was not set but the
> > mount option was set, then when the first attr2 format inode fork
> > was created, it would set the superblock feature bit. This is as it
> > should be - the superblock feature bit indicated the presence of the
> > attr2 on disk format.
......
> 
> I see the following regression on xfs/187 with this patch applied:
> 
> --- /tmp/fstests/tests/xfs/187.out      2021-05-13 11:47:55.849859833 -0700
> +++ /var/tmp/fstests/xfs/187.out.bad    2021-08-11 15:59:15.692618610 -0700
> @@ -9,6 +9,8 @@
>  
>  noattr2 fs
>  
> +MOREBITS
> +ATTR2
>  
>  *** 2. test attr2 mkfs and then noattr2 mount with 1 EA ***
>  
> @@ -23,6 +25,8 @@
>  user.test
>  
>  ATTR
> +MOREBITS
> +ATTR2
>  
>  *** 3. test noattr2 mount and lazy sb ***
>  
> @@ -36,4 +40,5 @@
>  noattr2 fs
>  
>  MOREBITS
> +ATTR2
>  LAZYSBCOUNT
> 
> I am pretty sure this is a direct result of "This will not remove the
> superblock feature bit", correct?  Do you have an adjustment to xfs/187
> to avoid regressing QA?

I've been looking at 187, and the tests that are failing are testing
the specific behaviour of "mkfs w/attr2 enabled; mount noattr2 and
ensure the attr2 version bits are not set".

Basically, the premise of the noattr2 verification tests are not
valid anymore, but adding filters to mask out the addition of
MOREBITS and ATTR2 basically renders the test useless for validating
the old behaviour is still correct.

IOWs, there's no way to detect if a kernel is going to behave like
the old code and remove the bits, or whether it is going to just
leave the attr2 fields set on disk. Hence I've got no idea how we'd
change xfs/187 to validate both the old and new behaviour because we
have no way of knowing which behaviour to expect.

So I'd vote for just throwing away xfs/187 because a) it looks
unfixable to me, and b) it's trying to validate what should be
considered broken behaviour (i.e. on-disk feature bit gets removed
even though the feature is still present on disk)...

Your thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
