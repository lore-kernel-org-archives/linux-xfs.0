Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B508BC4338F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 21:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90B4C61040
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 21:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhHDVRa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 17:17:30 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38859 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230105AbhHDVRZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Aug 2021 17:17:25 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 90FCF86679C;
        Thu,  5 Aug 2021 07:17:04 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBOG6-00EYVJ-Td; Thu, 05 Aug 2021 07:17:02 +1000
Date:   Thu, 5 Aug 2021 07:17:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH, pre-03/20 #2] xfs: introduce all-mounts list for cpu
 hotplug notifications
Message-ID: <20210804211702.GR2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
 <20210804115051.GO2757197@dread.disaster.area>
 <20210804160601.GO3601466@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804160601.GO3601466@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=aNr4NHpKHYs3qQlXhhMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 09:06:01AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 04, 2021 at 09:50:51PM +1000, Dave Chinner wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The inode inactivation and CIL tracking percpu structures are
> > per-xfs_mount structures. That means when we get a CPU dead
> > notification, we need to then iterate all the per-cpu structure
> > instances to process them. Rather than keeping linked lists of
> > per-cpu structures in each subsystem, add a list of all xfs_mounts
> > that the generic xfs_cpu_dead() function will iterate and call into
> > each subsystem appropriately.
> > 
> > This allows us to handle both per-mount and global XFS percpu state
> > from xfs_cpu_dead(), and avoids the need to link subsystem
> > structures that can be easily found from the xfs_mount into their
> > own global lists.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> > @@ -2090,6 +2126,11 @@ xfs_cpu_hotplug_destroy(void)
> >  	cpuhp_remove_state_nocalls(CPUHP_XFS_DEAD);
> >  }
> >  
> > +#else /* !CONFIG_HOTPLUG_CPU */
> > +static inline int xfs_cpu_hotplug_init(struct xfs_cil *cil) { return 0; }
> > +static inline void xfs_cpu_hotplug_destroy(struct xfs_cil *cil) {}
> 
> void arguments here, right?

Ah, yeah, most likely.

> > +#endif
> 
> Nit: I think this ifdef stuff belongs in the previous patch.  Will fix
> it when I drag this into my tree.

I didn't have them in the previous patch because when
CONFIG_HOTPLUG_CPU=n the cpuhotplug functions are stubbed out and
the compiler elides it all as they collapse down to functions that are
just "return 0". It's not until the mount list appears that there is
something we need to elide from the source ourselves...

<shrug>

Doesn't worry me either way.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
