Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D62C07E95
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 03:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 290B3613AA
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 03:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbhGNDSb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 23:18:31 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:44831 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237368AbhGNDSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 23:18:31 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 726C91B128A;
        Wed, 14 Jul 2021 13:15:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3VMq-006IG9-NF; Wed, 14 Jul 2021 13:15:24 +1000
Date:   Wed, 14 Jul 2021 13:15:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: make forced shutdown processing atomic
Message-ID: <20210714031524.GV664593@dread.disaster.area>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-6-david@fromorbit.com>
 <20210709044020.GX11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709044020.GX11588@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=bLZPg2y2iUBQkvzs1M8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 08, 2021 at 09:40:20PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 30, 2021 at 04:38:09PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The running of a forced shutdown is a bit of a mess. It does racy
> > checks for XFS_MOUNT_SHUTDOWN in xfs_do_force_shutdown(), then
> > does more racy checks in xfs_log_force_unmount() before finally
> > setting XFS_MOUNT_SHUTDOWN and XLOG_IO_ERROR under the
> > log->icloglock.
> > 
> > Move the checking and setting of XFS_MOUNT_SHUTDOWN into
> > xfs_do_force_shutdown() so we only process a shutdown once and once
> > only. Serialise this with the mp->m_sb_lock spinlock so that the
> > state change is atomic and won't race. Move all the mount specific
> 
> Assuming you're working on cleaning /that/ up too, I'll let that go...

Yes, a forward ported patch set that does this will be posted soon.

> > +	xfs_alert_tag(mp, tag,
> > +"%s (0x%x) detected at %pS (%s:%d).  Shutting down filesystem.",
> > +			why, flags, __return_address, fname, lnnum);
> >  	xfs_alert(mp,
> >  		"Please unmount the filesystem and rectify the problem(s)");
> > +	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> > +		xfs_stack_trace();
> 
> Doesn't xfs_alert already drop a stack trace for xfs_error_level >=
> XFS_ERRLEVEL_HIGH ?

It does? I've never seen it do that, and the existing code implies
it doesn't do this, either, and that's the logic was looking at
here:

        if (flags & SHUTDOWN_CORRUPT_INCORE) {
                xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
"Corruption of in-memory data (0x%x) detected at %pS (%s:%d).  Shutting down filesystem",
                                flags, __return_address, fname, lnnum);
                if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
                        xfs_stack_trace();
	} else if (....)

Yes, xfs_alert_tag() does not trigger a stack trace at all, but
there's an unconditional xfs_alert() call after this so if that
issues stack traces then we'd get a double stack trace on all
SHUTDOWN_CORRUPT_INCORE incidents. AFAICT, that doesn't actually
happen....

This pattern is repeated in several places - look at
xfs_inode_verifier_error(), xfs_buf_verifier_error(), and
xfs_buf_corruption_error(). They all have xfs_alert() calls, then
follow it up with a specific error level check for a stack dump.

Hmmm, it looks like xfs_alert() was intended to dump stacks, but I
don't think it works:

        if (!kstrtoint(kern_level, 0, &level) &&                \
            level <= LOGLEVEL_ERR &&                            \
            xfs_error_level >= XFS_ERRLEVEL_HIGH)               \
                xfs_stack_trace();                              \

And kern_level is KERN_ALERT, which is:

#define KERN_SOH        "\001"
....
#define KERN_ALERT      KERN_SOH "1"

And:

#define LOGLEVEL_ERR            3       /* error conditions */

So what does kstrtoint() return when passed the string "\0011"? It's
not actually an integer string...

Hmmm, I think it returns -EINVAL, which means it then uses level
uninitialised, and the result is .... unpredictable it is likely
no stack trace is emitted....

Fixing this mess is out of scope for this patchset.  The changes in
this patchset don't change the existing pattern of the function of
unconditionally calling xfs_alert() and conditionally and explicitly
dumping stack traces manually. I'll add it to my ever growing list
of cleanups that need to be done...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
