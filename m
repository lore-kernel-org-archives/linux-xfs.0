Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B56C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 01:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241615AbiC3B2M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 21:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241610AbiC3B2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 21:28:12 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56474985A4
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 18:26:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 53B6A533EF8;
        Wed, 30 Mar 2022 12:26:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nZN6O-00BVl4-4q; Wed, 30 Mar 2022 12:26:24 +1100
Date:   Wed, 30 Mar 2022 12:26:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>, Jonathan Lassoff <jof@thejof.com>,
        linux-xfs@vger.kernel.org, Chris Down <chris@chrisdown.name>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH v3 2/2] Add XFS messages to printk index
Message-ID: <20220330012624.GC1544202@dread.disaster.area>
References: <3e1f6011b22ca87ea3c0fad701286369daa2187f.1648228733.git.jof@thejof.com>
 <3c3ae424913cb921a9f8abddfcb1b418e7cfa601.1648228733.git.jof@thejof.com>
 <YkMKyN9w0S8VFJRk@alley>
 <20220330003457.GB1544202@dread.disaster.area>
 <20220330004649.GG27713@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330004649.GG27713@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6243b1c3
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=bs8r4XP8z4bD3WZdm4oA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 29, 2022 at 05:46:49PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 30, 2022 at 11:34:57AM +1100, Dave Chinner wrote:
> > I see no statement anywhere about what this printk index ABI
> > requires in terms of code stablility, format string maintenance and
> > modification, etc. I've seen it referred to as "semi-stable" but
> > there is no clear, easily accessible definition as to what that
> > means for either kernel developers or userspace app developers that
> > might want to use this information. There's zero information
> > available about how userspace will use this information, too, so at
> > this point I can't even guess what the policy for this new ABI
> > actually is.
> > 
> > If this was discussed and a policy was created, then great. But it
> > *hasn't been documented* for the rest of the world to be able to
> > read and understand so they know how to deal safely with the
> > information this ABI now provides. So, can you please explain what
> > the rules are, and then please write some documentation for the
> > kernel admin guide defining the user ABI for application writers and
> > what guarantees the kernel provides them with about the contents of
> > this ABI.
> 
> FWIW if you /did/ accept this for 5.19, I would suggest adding:
> 
> printk_index_subsys_emit("XFS log messages shall not be considered a stable kernel ABI as they can change at any time");
> 
> I base that largely on the evidence -- there's nothing saying that
> catalogued strings are or are not a stable ABI.  That means it's up to
> the subsystem or the maintainers or whoever to make a decision, and I

Yup, that's largely what I want clarified before we make a
decision one way or another. There must have been some discussion
and decisions on what the policy is before it was merged, but it's
not easily findable.

And, IMO, instead of every single subsystem having to go through the
same question and answer process as we are currently doing, I want
that policy to be documented such that a simple "git grep
printk_index_subsys_emit" search returns the file in the
Documentation/ directory that explains all this. That makes
everyone's lives a whole lot easier.

> would decide that while some people somewhere might benefit from having
> the message catalogue over not having it (e.g. i18n), someone would have
> to show a /very/ strong case for letting XFS get powertop'd.

Yeah, I'd push back very hard against that, too, but in the absence
of any documentation defining the contract to either the kernel or
userspace application developers, it's impossible to know where we
stand to begin with. I much prefer to be able to quote letter and
verse of the documentation than to have to repeatedly justify why
we consider the (un)documented policy to be broken....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
