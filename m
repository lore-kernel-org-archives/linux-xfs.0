Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC4FC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 16:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiLNQyA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Dec 2022 11:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239154AbiLNQx7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2022 11:53:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7EE1E3E0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 08:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CblvKsdOqcaPyPtzBdLw9GVvANm4CTZcu8wd/MVkOZI=; b=RqC2aT7XFYmnIadTgZM6fd/Dj2
        WfS37cBWgnJ8j8t9Z/l+0UMwu69c7otU2hmDkF5J5kMwWoRMXyVJzgGy1f/dgaLYtdixSwf4Q8Dln
        j0L+Xv4iB1V4hfEC+z3hu+yxstEAF7mVTLCNookrtejThcAZaUTgM27uwkNWfusojUVTgVb+t16Sh
        1uLUVTfd9jY6409bH4yTbceyJBjD1Z8L49faTuFGj3gBjdHUcoRma66aYLsCVEhLs7E/dyEij+XVr
        tTKwH/q35TEOwWBCfUZAb2107o19P+gKd3xyJ1PGIOiqxtQFzn170bV3QrVJza4q3xc8bA3UToN9J
        SpR7ll4w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p5V18-00DQcH-Kn; Wed, 14 Dec 2022 16:54:02 +0000
Date:   Wed, 14 Dec 2022 16:54:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Add const qualifiers
Message-ID: <Y5n/qtvzXJrND6ZN@casper.infradead.org>
References: <20221213205446.2998033-1-willy@infradead.org>
 <20221214005237.GA3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214005237.GA3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 14, 2022 at 11:52:37AM +1100, Dave Chinner wrote:
> On Tue, Dec 13, 2022 at 08:54:45PM +0000, Matthew Wilcox (Oracle) wrote:
> > With a container_of() that preserves const, the compiler warns about
> > all these places which are currently casting away the const.  For
> > the IUL_ITEM() helper, we want to also make it const-preserving,
> > and in every other case, we want to just add a const qualifier.
> 
> ....
> 
> > diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> > index 43005ce8bd48..ff82a93f8a24 100644
> > --- a/fs/xfs/xfs_iunlink_item.c
> > +++ b/fs/xfs/xfs_iunlink_item.c
> > @@ -20,10 +20,7 @@
> >  
> >  struct kmem_cache	*xfs_iunlink_cache;
> >  
> > -static inline struct xfs_iunlink_item *IUL_ITEM(struct xfs_log_item *lip)
> > -{
> > -	return container_of(lip, struct xfs_iunlink_item, item);
> > -}
> > +#define IUL_ITEM(lip) container_of(lip, struct xfs_iunlink_item, item)
> 
> I think this is somewhat of a step backwards. We moved these log
> item type conversions from macros to static inlines to add type
> checking so the compiler would catch the type conversion bugs we
> found that the macros didn't warn about....

But container_of() does warn about bad types.  It doesn't check that
'lip' is an xfs_log_item pointer, of course, but it does check that
either lip has the same type as the member 'item' in
struct xfs_iunlink_item, or lip is a void pointer, which is the
same check that the compiler is going to do with a static inline
function.

> Which makes me ask: why do we even care about const here? What
> actual real world problem are you trying to fix with these changes?

Why do we care about const anywhere?  container_of() is an unintended
way to drop the constness of a pointer, so it's a code hygeine issue.
