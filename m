Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F7DC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 11:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349795AbiDLLlc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 07:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356417AbiDLLkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 07:40:14 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1132950476
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 03:21:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D65465344A8;
        Tue, 12 Apr 2022 20:21:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1neDe9-00Gmz1-Db; Tue, 12 Apr 2022 20:21:17 +1000
Date:   Tue, 12 Apr 2022 20:21:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: don't commit the first deferred transaction
 without intents
Message-ID: <20220412102117.GH1544202@dread.disaster.area>
References: <20220314220631.3093283-1-david@fromorbit.com>
 <20220314220631.3093283-3-david@fromorbit.com>
 <c703d920e920dc18b0125fdb488ab22f7ff8219f.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c703d920e920dc18b0125fdb488ab22f7ff8219f.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6255529f
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=agY3Z-LXmacOvU5QsGMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 10, 2022 at 10:22:48PM -0700, Alli wrote:
> On Tue, 2022-03-15 at 09:06 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If the first operation in a string of defer ops has no intents,
> > then there is no reason to commit it before running the first call
> > to xfs_defer_finish_one(). This allows the defer ops to be used
> > effectively for non-intent based operations without requiring an
> > unnecessary extra transaction commit when first called.
> > 
> > This fixes a regression in per-attribute modification transaction
> > count when delayed attributes are not being used.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> I recall some time ago, you had given me this patch, and I added it to
> the delayed attribute series series.  The reviews created a slightly
> more simplified version of this, so if you are ok with how that one
> turned out, you can just omit this patch from the white out series.  Or
> if you prefer to keep it with this set, you can just adopt the second
> patch of the larp series, and I can omit it from there.  Either was
> should be fine I think?

The version in this patch set is quite different in implementation
scope - the original was just a scatter-gun that checked if the
transaction was not dirty. This one checks if there are intents
being logged, so the conditions under which it skips the commit are
much more refined.

Hence I don't the reviews carry over, and I think the version in the
whiteout patchset is the version we want...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
