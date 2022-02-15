Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A4FC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Feb 2022 09:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbiBOJ0d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 04:26:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235723AbiBOJ0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 04:26:32 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 915FC26112
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 01:26:22 -0800 (PST)
Received: from dread.disaster.area (pa49-186-85-251.pa.vic.optusnet.com.au [49.186.85.251])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6B91E52DB3A;
        Tue, 15 Feb 2022 20:26:21 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nJu6F-00CGLE-BO; Tue, 15 Feb 2022 20:26:19 +1100
Date:   Tue, 15 Feb 2022 20:26:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20220215092619.GY59715@dread.disaster.area>
References: <20220114213043.GB90423@magnolia>
 <YeVxCXE6hXa1S/ic@bfoster>
 <20220118185647.GB13563@magnolia>
 <Yehvc4g+WakcG1mP@bfoster>
 <20220120003636.GF13563@magnolia>
 <Ye7aaIUvHFV18yNn@bfoster>
 <20220202022240.GY59729@dread.disaster.area>
 <YgVhe/mAQvzPIK7M@bfoster>
 <20220210230806.GO59729@dread.disaster.area>
 <20220215015416.GG8338@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215015416.GG8338@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=620b71bd
        a=2CV4XU02g+4RbH+qqUnf+g==:117 a=2CV4XU02g+4RbH+qqUnf+g==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=6ExyE3aB8h5R-d3jOfIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 14, 2022 at 05:54:16PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 11, 2022 at 10:08:06AM +1100, Dave Chinner wrote:
> > On Thu, Feb 10, 2022 at 02:03:23PM -0500, Brian Foster wrote:
> > > On Wed, Feb 02, 2022 at 01:22:40PM +1100, Dave Chinner wrote:
> > > > On Mon, Jan 24, 2022 at 11:57:12AM -0500, Brian Foster wrote:
> > > That said, why not conditionally tag and divert to a background worker
> > > when the inodegc is disabled? That could allow NEEDS_INACTIVE inodes to
> > > be claimed/recycled from other contexts in scenarios like when the fs is
> > > frozen, since they won't be stuck in inaccessible and inactive percpu
> > > queues, but otherwise preserves current behavior in normal runtime
> > > conditions. Darrick mentioned online repair wanting to do something
> > > similar earlier, but it's not clear to me if scrub could or would want
> > > to disable the percpu inodegc workers in favor of a temporary/background
> > > mode while repair is running. I'm just guessing that performance is
> > > probably small enough of a concern in that situation that it wouldn't be
> > > a mitigating factor. Hm?
> > 
> > WE probably could do this, but I'm not sure the complexity is
> > justified by the rarity of the problem it is trying to avoid.
> > Freezes are not long term, nor are they particularly common for
> > performance sensitive workloads. Hence I'm just not this corner case
> > is important enough to justify doing the work given that we've had
> > similar freeze-will-delay-some-stuff-indefinitely behaviour for a
> > long time...
> 
> We /do/ have a few complaints lodged about hangcheck warnings when the
> filesystem has to be frozen for a very long time.  It'd be nice to
> unblock the callers that want to grab a still-reachable inode, though.

I suspect this problem largely goes away with moving inactivation
up to the VFS level - we'll still block the background EOF block
trimming work on a freeze, but it won't prevent lookups on those
inodes from taking new references to the inode...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
