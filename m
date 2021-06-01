Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2E4C4708F
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 21:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E51960FF3
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 21:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhFAVmO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 17:42:14 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:45683 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234513AbhFAVmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 17:42:12 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 0CFB080B0A1;
        Wed,  2 Jun 2021 07:40:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loC7f-007rZ3-Qt; Wed, 02 Jun 2021 07:40:27 +1000
Date:   Wed, 2 Jun 2021 07:40:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/5] xfs: separate the dqrele_all inode grab logic from
 xfs_inode_walk_ag_grab
Message-ID: <20210601214027.GD664593@dread.disaster.area>
References: <162250085103.490412.4291071116538386696.stgit@locust>
 <162250086766.490412.9229536536315438431.stgit@locust>
 <20210601002023.GY664593@dread.disaster.area>
 <20210601195051.GB26380@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601195051.GB26380@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ZXq8Lt_eA9W1qzQrdYIA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 12:50:51PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 01, 2021 at 10:20:23AM +1000, Dave Chinner wrote:
> > On Mon, May 31, 2021 at 03:41:07PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Disentangle the dqrele_all inode grab code from the "generic" inode walk
> > > grabbing code, and and use the opportunity to document why the dqrele
> > > grab function does what it does.
> > > 
> > > Since dqrele_all is the only user of XFS_ICI_NO_TAG, rename it to
> > > something more specific for what we're doing.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_icache.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++---
> > >  fs/xfs/xfs_icache.h |    4 ++-
> > >  2 files changed, 62 insertions(+), 6 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index 34b8b5fbd60d..5501318b5db0 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -26,6 +26,8 @@
> > >  
> > >  #include <linux/iversion.h>
> > >  
> > > +static bool xfs_dqrele_inode_grab(struct xfs_inode *ip);
> > > +
> > 
> > Just mov the function higher up in the file rather than add forward
> > declarations....
> 
> Ugh, this will cause churn that will ripple through this and the next
> iwalk refactoring patchsets and deferred inactivation.  Can I please
> please please defer the churn cleanup until the end of all that?

Yes, by all means. I don't want to make it harder to get stuff done,
so moving stuff around at the end of the series is fine...

....

> > This is basically just duplication of xfs_inode_walk_ag_grab()
> > without the XFS_INODE_WALK_INEW_WAIT check in it. At this point I
> > just don't see a reason for this function or the
> > XFS_ICI_DQRELE_NONTAG rename just to use this grab function...
> 
> Ugh.  I should have sent the /next/ iwalk refactoring series along with
> this one so that it would become more obvious that the end goal is to
> seal all the incore inode walk code in xfs_icache.c, since there are
> only four of them (reclaim, inodegc, blockgc, quotaoff) and the grab
> functions for all four are just different enough that it's not really
> worth it to keep them combined in one function full of conditionals.
> 
> Once that's done, the only user of xfs_inode_walk_ag_grab is the blockgc
> code and I can rename it.

Ok, that context is missing from the patch series. :/

> Ofc the reason I held back is that the next series adds 8 more iwalk
> cleanup patches, and the more patches I send all at once the longer it
> takes for anyone to start looking at it.  I /still/ can't figure out the
> balance between risking overwhelming everyone with too many patches vs.
> sending insufficient patches to convey where I'm really going with
> something.

Yeah, can be difficult. I prefer to err on the side of "complete
change" rather than splitting two parts of a larger work
arbitrarily...

> <shrug> I might just ping you on irc so that we can have a conversation
> about this and summarize whatever we come up with for the list.

You've got a branch with the full series in it somewhere, I'm
guessing? point me at it so I can see where this ends up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
