Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1C8C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 06:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A49D564FBB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 06:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhCKGm5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 01:42:57 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35886 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229932AbhCKGmj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 01:42:39 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8CDA61041483;
        Thu, 11 Mar 2021 17:42:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKF1q-001Bal-2I; Thu, 11 Mar 2021 17:42:38 +1100
Date:   Thu, 11 Mar 2021 17:42:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/45] xfs: introduce per-cpu CIL tracking sructure
Message-ID: <20210311064238.GT74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-36-david@fromorbit.com>
 <20210311001143.GI3419940@magnolia>
 <20210311063338.GS74031@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311063338.GS74031@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=jH2WOuPQwjF-vwMG4RsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 11, 2021 at 05:33:38PM +1100, Dave Chinner wrote:
> On Wed, Mar 10, 2021 at 04:11:43PM -0800, Darrick J. Wong wrote:
> > On Fri, Mar 05, 2021 at 04:11:33PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The CIL push lock is highly contended on larger machines, becoming a
> > > hard bottleneck that about 700,000 transaction commits/s on >16p
> > > machines. To address this, start moving the CIL tracking
> > > infrastructure to utilise per-CPU structures.
> > > 
> > > We need to track the space used, the amount of log reservation space
> > > reserved to write the CIL, the log items in the CIL and the busy
> > > extents that need to be completed by the CIL commit.  This requires
> > > a couple of per-cpu counters, an unordered per-cpu list and a
> > > globally ordered per-cpu list.
> > > 
> > > Create a per-cpu structure to hold these and all the management
> > > interfaces needed, as well as the hooks to handle hotplug CPUs.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log_cil.c       | 94 ++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_log_priv.h      | 15 ++++++
> > >  include/linux/cpuhotplug.h |  1 +
> > >  3 files changed, 110 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > index f8fb2f59e24c..1bcf0d423d30 100644
> > > --- a/fs/xfs/xfs_log_cil.c
> > > +++ b/fs/xfs/xfs_log_cil.c
> > > @@ -1365,6 +1365,93 @@ xfs_log_item_in_current_chkpt(
> > >  	return true;
> > >  }
> > >  
> > > +#ifdef CONFIG_HOTPLUG_CPU
> > > +static LIST_HEAD(xlog_cil_pcp_list);
> > > +static DEFINE_SPINLOCK(xlog_cil_pcp_lock);
> > > +static bool xlog_cil_pcp_init;
> > > +
> > > +static int
> > > +xlog_cil_pcp_dead(
> > > +	unsigned int		cpu)
> > > +{
> > > +	struct xfs_cil		*cil;
> > > +
> > > +        spin_lock(&xlog_cil_pcp_lock);
> > > +        list_for_each_entry(cil, &xlog_cil_pcp_list, xc_pcp_list) {
> > 
> > Weird indentation.
> > 
> > > +		/* move stuff on dead CPU to context */
> > 
> > Should this have some actual code?  I don't think any of the remaining
> > patches add anything here.
> 
> They should be moving stuff to the current CIL ctx so it is captured
> when the CPU goes down.

Yup, looks like I missed updating this. Will add it in the patches
that need it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
