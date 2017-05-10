Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751593AbdEJLot (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 07:44:49 -0400
Date: Wed, 10 May 2017 07:44:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: make fatal assert failures conditional in debug
 mode
Message-ID: <20170510114445.GA2867@bfoster.bfoster>
References: <1493991086-18817-1-git-send-email-bfoster@redhat.com>
 <20170505230943.GG17542@dastard>
 <20170508125530.GA29840@bfoster.bfoster>
 <20170508231448.GH17542@dastard>
 <20170509131129.GA3241@bfoster.bfoster>
 <20170509153704.GN5973@birch.djwong.org>
 <20170509170047.GC3241@bfoster.bfoster>
 <20170510105431.GK17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170510105431.GK17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, May 10, 2017 at 08:54:32PM +1000, Dave Chinner wrote:
> On Tue, May 09, 2017 at 01:00:50PM -0400, Brian Foster wrote:
> > I rarely, if ever, have a need for assert failures to bug the kernel.
> 
> I absolutely rely on it to debug problems with the system in the
> state that the problem was detected.
> 
> IOWs, what works for one person does not work for everyone.
> 

That's been the premise from the start. The current default assert
behavior does not change.

> > I'd like to be able to just turn it off in my default configs (without
> > disrupting the cases where it is useful).
> 
> So, as Darrick suggested, make the sysctl value kconfig selectable.
> you get what you want and it's runtime selectable...
> 

v3 will probably do something like define a
/sys/fs/xfs/debug/bug_on_assert flag that is used to toggle assert
behavior from a combined variant of ass[warn|fail](). The FATAL_ASSERT
config option basically just controls the default value of the flag.

Brian

> > > > As mentioned previously, we can be more granular than the current binary
> > > > toggle for debug mode. E.g., we could separate diagnostic mechanisms
> > > > from test coverage mechanisms and enable the latter at a higher debug
> > > > level or with a separate option entirely, if desired. IOW, I don't think
> > > > that's a difficult problem to solve.
> > > 
> > > Agreed.
> 
> Please don't. It took us years to get rid of all the stale special
> snowflake conditional debug code we inherited from Irix that
> bitrotted and broke because nobody ever set, say, XFS_TRANS_DEBUG in
> their build, let alone tried to run a kernel with it.  We took what
> was useful and put it under XFS_DEBUG so that it was always run, and
> the XFS code has been so much better for it....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
