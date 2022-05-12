Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F123CC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 12 May 2022 00:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245328AbiELA5T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 May 2022 20:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245021AbiELA5S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 May 2022 20:57:18 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68D376928D
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 17:57:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3DE11534683;
        Thu, 12 May 2022 10:57:14 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nox8i-00AteZ-Hu; Thu, 12 May 2022 10:57:12 +1000
Date:   Thu, 12 May 2022 10:57:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/18] xfs: separate out initial attr_set states
Message-ID: <20220512005712.GL1098723@dread.disaster.area>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-6-david@fromorbit.com>
 <20220510231234.GI27195@magnolia>
 <20220511010651.GZ1098723@dread.disaster.area>
 <20220511010848.GB27195@magnolia>
 <20220511013851.GD1098723@dread.disaster.area>
 <20220511083513.GJ1098723@dread.disaster.area>
 <20220511153952.GF27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511153952.GF27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=627c5b6b
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=PyqHtWom7uurtRGdfgcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 08:39:52AM -0700, Darrick J. Wong wrote:
> On Wed, May 11, 2022 at 06:35:13PM +1000, Dave Chinner wrote:
> > On Wed, May 11, 2022 at 11:38:51AM +1000, Dave Chinner wrote:
> > > On Tue, May 10, 2022 at 06:08:48PM -0700, Darrick J. Wong wrote:
> > > > On Wed, May 11, 2022 at 11:06:51AM +1000, Dave Chinner wrote:
> > > > > I'm going to leave this for the moment (cleanup note made) because I
> > > > > don't want to have to find out that I missed a corner case somewhere
> > > > > they hard way right now. It's basically there to stop log recovery
> > > > > crashing hard, which only occurs when the experimental larp code is
> > > > > running, so I think this is safe to leave for a later cleanup.
> > > > 
> > > > Hmm, in that case, can this become:
> > > > 
> > > > 	if (!args->dp->i_afp) {
> > > > 		ASSERT(0);
> > > > 		return XFS_DAS_DONE;
> > > > 	}
> > > 
> > > OK.
> > 
> > Ok, now generic/051 has reminded me exactly what this was for.
> > 
> > Shortform attr remove will remove the attr and the attr fork from
> > this code:
> > 
> >         case XFS_DAS_SF_REMOVE:                                                  
> >                 error = xfs_attr_sf_removename(args);                            
> >                 attr->xattri_dela_state = xfs_attr_complete_op(attr,             
> >                                                 xfs_attr_init_add_state(args));  
> >                 break;                                                           
> > 
> > But if we are doing this as part of a REPLACE operation and we
> > still need to add the new attr, it calls xfs_attr_init_add_state()
> > to get the add state we should start with. That then hits the
> > null args->dp->i_afp case because the fork got removed.
> > 
> > This can't happen if we are doing a replace op, so we'd then check
> > if it's a shortform attr fork and return XFS_DAS_SF_ADD for the
> > replace to then execute. But it's not a replace op, so we can
> > have a null attr fork.
> > 
> > I'm going to restore the old code with a comment so that I don't
> > forget this again.
> > 
> > /*
> >  * If called from the completion of a attr remove to determine
> >  * the next state, the attribute fork may be null. This can occur on
> >  * a pure remove, but we grab the next state before we check if a
> >  * replace operation is being performed. Hence if the attr fork is
> >  * null, it's a pure remove operation and we are done.
> >  */
> 
> Ahh, I see -- sf_removename will /never/ kill i_afp if we're doing a
> DA_OP_REPLACE or ADDNAME, and leaf_removename also won't do that if
> we're doing DA_OP_REPLACE.  IOWs, only a removexattr operation can
> result in i_afp being freed.
> 
> And the XATTR_CREATE operation always guarantee that i_afp is non-null
> before we start, so xfs_attr_defer_add should never be called with
> args->dp->i_afp == NULL, hence it'll never hit that state.
> 
> Would you mind adding a sentence to the comment?
> 
> "A pure create ensures the existence of i_afp and never encounters this
> state."

Sure.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
