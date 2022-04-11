Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1ABC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 01:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243358AbiDKBxl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 21:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244316AbiDKBxj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 21:53:39 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D31C92BC8
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:51:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0E52310CD5F0;
        Mon, 11 Apr 2022 11:51:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndjDB-00GFk9-9a; Mon, 11 Apr 2022 11:51:25 +1000
Date:   Mon, 11 Apr 2022 11:51:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [5.19 cycle] Planning and goals
Message-ID: <20220411015125.GW1544202@dread.disaster.area>
References: <20220405020312.GU1544202@dread.disaster.area>
 <20220407031106.GB27690@magnolia>
 <20220407054939.GJ1544202@dread.disaster.area>
 <20220410182112.GA14125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410182112.GA14125@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6253899f
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=qaloK82zGlSXuARPxHQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 10, 2022 at 11:21:12AM -0700, Darrick J. Wong wrote:
> On Thu, Apr 07, 2022 at 03:49:39PM +1000, Dave Chinner wrote:
> > On Wed, Apr 06, 2022 at 08:11:06PM -0700, Darrick J. Wong wrote:
> > > On Tue, Apr 05, 2022 at 12:03:12PM +1000, Dave Chinner wrote:
> > > > Have I missed any of the major outstanding things that are nearly
> > > > ready to go?
> > > 
> > > At this point my rmap/reflink performance speedups series are ready for
> > > review,
> > 
> > OK, what's the timeframe for you getting them out for review? Today,
> > next week, -rc4?
> 
> I'll send them as soon as the frextents bugfix series clears review.

Thanks!

> > Speaking as the "merge shepherd" for this release, what I want from
> > this discussion is feedback that points out things I've missed, for
> > the authors of patchsets that I've flagged as merge candidates to
> > tell me if they are able to do the work needed in the next 4-6 weeks
> > to get their work merged, for people to voice their concerns about
> > aspects of the plan, etc.
> 
> <nod> I hope you've gotten enough info to proceed, then?

Yes, so far, so good :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
