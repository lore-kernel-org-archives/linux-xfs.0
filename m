Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA61C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 00:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiK3ATh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 19:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiK3ATg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 19:19:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208946D49E
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 16:19:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B317D61975
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 00:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1784AC433D6;
        Wed, 30 Nov 2022 00:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669767575;
        bh=TSudb8YJx4VbsF9B3vz3xUimRADMV24Pw9u2naMloxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nf1FJCY/LO7fqXV29vgW/yby6SMaUA7/EpZvyAkPMNko1NYHZPm31Bu7bM0DflsSS
         xtnECd0XfxJge8UULOTOReRdqDQlf+5290RZDOhnjXUZDTCPTQiGL4wRFLrt5OT4Cg
         rQbRxNXDVR2MAsFrrh2FadNeE0jHQtAMYQhVpeb2dHi1K4GlLjzOreYTQ+YE+6zlWt
         4BgXzzIvHk3qM18LXyh42etegOwOY6y7T5aMS0EWXAChBGpXnSWkjLexIYl0STrxXQ
         /sZWjUX+gte/ueWVP8iNhWbkJ21I784+fcrSx6emgtu+Rnp/bPZu4W8TrQbOCEbech
         uGzJsatK+ZOcA==
Date:   Tue, 29 Nov 2022 16:19:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs/179: modify test to trigger refcount update bugs
Message-ID: <Y4ahljwYmgHQZuna@magnolia>
References: <166975928548.3768925.15141817742859398250.stgit@magnolia>
 <Y4aCb+y2ej1TBE/R@magnolia>
 <20221129224227.GL3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129224227.GL3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 30, 2022 at 09:42:27AM +1100, Dave Chinner wrote:
> On Tue, Nov 29, 2022 at 02:06:39PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Upon enabling fsdax + reflink for XFS, this test began to report
> > refcount metadata corruptions after being run.  Specifically, xfs_repair
> > noticed single-block refcount records that could be combined but had not
> > been.
> > 
> > The root cause of this is improper MAXREFCOUNT edge case handling in
> > xfs_refcount_merge_extents.  When we're trying to find candidates for a
> > record merge, we compute the refcount of the merged record, but without
> > accounting for the fact that once a record hits rc_refcount ==
> > MAXREFCOUNT, it is pinned that way forever.
> > 
> > Adjust this test to use a sub-filesize write for one of the COW writes,
> > because this is how we force the extent merge code to run.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Seems like a reasonable modification to the test....
> 
> > ---
> >  tests/xfs/179 |   28 +++++++++++++++++++++++++---
> >  1 file changed, 25 insertions(+), 3 deletions(-)
> > 
> > diff --git a/tests/xfs/179 b/tests/xfs/179
> > index ec0cb7e5b4..214558f694 100755
> > --- a/tests/xfs/179
> > +++ b/tests/xfs/179
> > @@ -21,17 +21,28 @@ _require_scratch_nocheck
> >  _require_cp_reflink
> >  _require_test_program "punch-alternating"
> >  
> > +_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: estimate post-merge refcounts correctly"
> 
> Though I really don't like these annotation because when the test
> fails in future as I'm developing new code it's going to tell me I
> need a fix I already have in the kernel. This is just extra noise
> that I have to filter out of the results output. IMO a comment for
> this information or a line in the commit message is fine - it
> just doesn't belong in the test output....

I'll turn that into a comment, since this originally was a functional
test, not a regression test.

> Other than that:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Ok thanks!

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
