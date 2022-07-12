Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29686C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 06:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiGLGZX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 02:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGLGZW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 02:25:22 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABB5022BD1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 23:25:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 41C2D10E7DF7;
        Tue, 12 Jul 2022 16:25:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oB9Ke-00HUyw-N3; Tue, 12 Jul 2022 16:25:16 +1000
Date:   Tue, 12 Jul 2022 16:25:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 1/5] xfs: convert XFS_IFORK_PTR to a static inline helper
Message-ID: <20220712062516.GK3861211@dread.disaster.area>
References: <165740691606.73293.12753862498202082021.stgit@magnolia>
 <165740692193.73293.17607871779448850064.stgit@magnolia>
 <Ysu0iYgkaGdg6oVJ@infradead.org>
 <YszMaH4fLe0S6Jp7@magnolia>
 <Ysz+SbVRh5yTWzXS@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ysz+SbVRh5yTWzXS@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62cd13cf
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=7-415B0cAAAA:8
        a=v13OQp2Gx_EhoxNxJmgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 11, 2022 at 09:53:29PM -0700, Christoph Hellwig wrote:
> On Mon, Jul 11, 2022 at 06:20:40PM -0700, Darrick J. Wong wrote:
> > I personally am not that bothered by shouty function names, but Dave
> > has asked for shout-reduction in the past, so every time I convert
> > something I also change the case.
> > 
> > AFAIK it /is/ sort of a C custom that macros get loud names and
> > functions do not so that you ALWAYS KNOW, erm, when you're dealing with
> > a macro that could rain bad coding conventions down on your head.
> 
> It is a bit of a historic custom, but not really followed strictly.
> I tend to think of trivial container_of and similar addressing inline
> functions just as macros with a saner implementation, and so does a
> big part of the kernel community.  Where exactly that border is is not
> clear, though.  And in doubt I think avoiding too much churn in changing
> things unless there is a clear benefit is a good idea.  So maybe we
> would have picked a lower case name for XFS_IFORK_PTR when adding it
> new, but i don't really see any benefit in changing it now.

/me shrugs

All I really want is the macros converted to static inlines so that
we get proper type checking. I'm not concerned by upper/lower case
that much, and for stuff like XFS_I/VFS_I I agree that it makes
sense because they are really short and it makes the type
conversions of related embedded objects stand out in the code
nicely.

But for longer stuff like xfs_ifork_ptr(), I think it makes more
sense to follow the "UPPER == macro, lower == static inline"
conventions, especially in the dense forest of similar macro
definitions surrounding XFS_IFORK_... and XFS_DFORK...

Yes, it does mean there's a little bit of eye retraining to be done
for long term developers, but I think the end result is much more
easier to understand especially for people new to the XFS code....

> The same is true for some of the other patches later in the series,
> except for maybe XFS_IFORK_Q, which has been really grossly and
> confusingly misnamed.

One of many. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
