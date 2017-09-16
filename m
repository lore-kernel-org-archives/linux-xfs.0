Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:16131 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751211AbdIPLaA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Sep 2017 07:30:00 -0400
Date: Sat, 16 Sep 2017 21:29:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Message-ID: <20170916112956.GB10621@dastard>
References: <20170829235052.21050-1-david@fromorbit.com>
 <CACj3i73fYBdBNJPn+VNR90ERW+sdMUmNbEGt-Q9Q6z95=hi0qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i73fYBdBNJPn+VNR90ERW+sdMUmNbEGt-Q9Q6z95=hi0qQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Sep 15, 2017 at 11:42:44AM +0200, Jan Tulak wrote:
> On Wed, Aug 30, 2017 at 1:50 AM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Future work will be to split the xfs_mkfs.c file into a file per
> > module (i.e. seperate files for CLI parsing, mkfs formating,
> > validation+calculation and, finally, one for config file support),
> > but otherwise the majority of the factoring work is now complete.
> >
> > Comments, flames, etc all welcome.
> >
> 
> In my review, I didn't saw any issues. It works, it certainly looks
> way better than what I was trying to do, and I didn't notice any
> regression, although my testing was not as thorough as Chandan's. It
> seems that everybody likes these changes, so is there anything that
> prevents it to be merged once xfstests are updated as well?

Yeah, the bugs I found last week to do with log sizingi and log
stripe units. I'll fix them and send out the xfstests mods next
week. Then I'll wait for Eric to release 4.13.0 and send him a
pull request....

> And thinking about the future, I wonder if there is any point in
> making the suboption tables into one hierarchical like I wanted
> before. The main reason for my attempt was to allow cross-option
> conflicts and the mentioned changes also added conditional
> conflicts.  But now with validate_sb_features() containing almost
> all these conflicts, I'm not sure if it would help or if it would
> rather make it more complex and obscure.

Don't know. But let's focus on getting the features in that people
want first, then worry about further cleanups...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
