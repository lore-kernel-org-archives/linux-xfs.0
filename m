Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D86C47080
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 23:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C297613C0
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 23:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhFAXQn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234766AbhFAXQn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 19:16:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3008B613AD;
        Tue,  1 Jun 2021 23:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622589301;
        bh=62TgRcJofWSkY4jQ8aG9jwJZK6TUz1p3EWBfVmy+cQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P92KV1f2XTi3SFoWtbCj9uqP5DF4SV+vXly7bGnLa/3g+tRwWI12n/SIEDLynb1yE
         MDaUhk1IEgqWpl7UsFELc7x6BRLkabb6ltxj3PAFfLIU3XV+nHnXX+jpo6QDJcxDh4
         yjvjW7eaTWaoZWHqKPpa8VNbhdntd6AwKdH6tE8zjds6lStjZC7/VuqNsq9MYIUGpK
         m35pz1BNqkRiit2QwBAogTZGuz2J7iGg3UDIrzLG4cObJh9TxbxUkLvfGdWf2a9q7Q
         DJrde43Jg6iS/lGHZdsFQMqIaMWg6GfBchD0chv3JGS+5MU8pnvwCWA+g/0lT4aLKk
         pIF+SrBLo+9GA==
Date:   Tue, 1 Jun 2021 16:15:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/5] xfs: separate the dqrele_all inode grab logic from
 xfs_inode_walk_ag_grab
Message-ID: <20210601231500.GD26380@locust>
References: <162250085103.490412.4291071116538386696.stgit@locust>
 <162250086766.490412.9229536536315438431.stgit@locust>
 <20210601002023.GY664593@dread.disaster.area>
 <20210601195051.GB26380@locust>
 <20210601214027.GD664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601214027.GD664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 07:40:27AM +1000, Dave Chinner wrote:
> On Tue, Jun 01, 2021 at 12:50:51PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 01, 2021 at 10:20:23AM +1000, Dave Chinner wrote:
> > > On Mon, May 31, 2021 at 03:41:07PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Disentangle the dqrele_all inode grab code from the "generic" inode walk
> > > > grabbing code, and and use the opportunity to document why the dqrele
> > > > grab function does what it does.
> > > > 
> > > > Since dqrele_all is the only user of XFS_ICI_NO_TAG, rename it to
> > > > something more specific for what we're doing.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/xfs_icache.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++---
> > > >  fs/xfs/xfs_icache.h |    4 ++-
> > > >  2 files changed, 62 insertions(+), 6 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > index 34b8b5fbd60d..5501318b5db0 100644
> > > > --- a/fs/xfs/xfs_icache.c
> > > > +++ b/fs/xfs/xfs_icache.c
> > > > @@ -26,6 +26,8 @@
> > > >  
> > > >  #include <linux/iversion.h>
> > > >  
> > > > +static bool xfs_dqrele_inode_grab(struct xfs_inode *ip);
> > > > +
> > > 
> > > Just mov the function higher up in the file rather than add forward
> > > declarations....
> > 
> > Ugh, this will cause churn that will ripple through this and the next
> > iwalk refactoring patchsets and deferred inactivation.  Can I please
> > please please defer the churn cleanup until the end of all that?
> 
> Yes, by all means. I don't want to make it harder to get stuff done,
> so moving stuff around at the end of the series is fine...
> 
> ....

In the end it was easy enough to do it (as a separate prep patch) once I
concluded that separate the goal of the inode_walk from the radix tree
tags to eliminate the confusing XFS_ICI_NONTAG cases (i.e. quotaoff).

> > > This is basically just duplication of xfs_inode_walk_ag_grab()
> > > without the XFS_INODE_WALK_INEW_WAIT check in it. At this point I
> > > just don't see a reason for this function or the
> > > XFS_ICI_DQRELE_NONTAG rename just to use this grab function...
> > 
> > Ugh.  I should have sent the /next/ iwalk refactoring series along with
> > this one so that it would become more obvious that the end goal is to
> > seal all the incore inode walk code in xfs_icache.c, since there are
> > only four of them (reclaim, inodegc, blockgc, quotaoff) and the grab
> > functions for all four are just different enough that it's not really
> > worth it to keep them combined in one function full of conditionals.
> > 
> > Once that's done, the only user of xfs_inode_walk_ag_grab is the blockgc
> > code and I can rename it.
> 
> Ok, that context is missing from the patch series. :/

Sorry.

> > Ofc the reason I held back is that the next series adds 8 more iwalk
> > cleanup patches, and the more patches I send all at once the longer it
> > takes for anyone to start looking at it.  I /still/ can't figure out the
> > balance between risking overwhelming everyone with too many patches vs.
> > sending insufficient patches to convey where I'm really going with
> > something.
> 
> Yeah, can be difficult. I prefer to err on the side of "complete
> change" rather than splitting two parts of a larger work
> arbitrarily...

<nod> I'll combine this set and the next one when I resend this patch
pile.

> > <shrug> I might just ping you on irc so that we can have a conversation
> > about this and summarize whatever we come up with for the list.
> 
> You've got a branch with the full series in it somewhere, I'm
> guessing? point me at it so I can see where this ends up....

Yup.

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-walk-cleanups-5.14

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
