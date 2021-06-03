Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4FEC47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 20:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D78FA613F1
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 20:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhFCUub (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 16:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCUua (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 16:50:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6F3C613BF;
        Thu,  3 Jun 2021 20:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622753325;
        bh=1b3Mg/YtV3dZlzDGHxTsQ4dsHinrU9t77stgRC3bUD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F0UuAu3LGCsr6oCe2bXQhqjaA2sp2p6OL0w7ZMWdoBEDYvZQ5OKEZre+gP0V17BdP
         TZwajGnJzMaf+k+vnnV8Oobw5lMr+UpJHwKWTvBeZ9Ez2E8D2WcSSGmd2kkHsM3oKG
         MayyB/4MkFGeRWt1lSS51VPlEddD4awAOIe4I4IKsvNcmCnxFMCjucdVRYs5kSpcFC
         t7IY4ii/Supvatm4e4keG7x7gSoerwZshZJOZp6KaSPo2kkh9qj0QITpcUsjeOHlnw
         ge6WGTix2T+zESk7Qiz4viwQ7qrOUE0e71R94XgR0/vXoMa22dZT4QtJM9lN8xnDLx
         u3QQsAxaitFDw==
Date:   Thu, 3 Jun 2021 13:48:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: drop IDONTCACHE on inodes when we mark them sick
Message-ID: <20210603204845.GA26380@locust>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
 <162268996687.2724138.9307511745121153042.stgit@locust>
 <YLjJuZQ0xVk17Dcg@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLjJuZQ0xVk17Dcg@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 08:23:21AM -0400, Brian Foster wrote:
> On Wed, Jun 02, 2021 at 08:12:46PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When we decide to mark an inode sick, clear the DONTCACHE flag so that
> > the incore inode will be kept around until memory pressure forces it out
> > of memory.  This increases the chances that the sick status will be
> > caught by someone compiling a health report later on.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_health.c |    5 +++++
> >  fs/xfs/xfs_icache.c |    3 ++-
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > index 8e0cb05a7142..824e0b781290 100644
> > --- a/fs/xfs/xfs_health.c
> > +++ b/fs/xfs/xfs_health.c
> > @@ -231,6 +231,11 @@ xfs_inode_mark_sick(
> >  	ip->i_sick |= mask;
> >  	ip->i_checked |= mask;
> >  	spin_unlock(&ip->i_flags_lock);
> > +
> > +	/* Keep this inode around so we don't lose the sickness report. */
> > +	spin_lock(&VFS_I(ip)->i_lock);
> > +	VFS_I(ip)->i_state &= ~I_DONTCACHE;
> > +	spin_unlock(&VFS_I(ip)->i_lock);
> 
> If I follow the scrub code correctly, it will grab a dontcache reference
> on the inode, so presumably the intent here is to clear that status once
> we've identified some problem to keep the inode around. Seems
> reasonable.

<nod> I'll expand the comment:

	/*
	 * Keep this inode around so we don't lose the sickness report.
	 * Scrub grabs inodes with DONTCACHE assuming that most inode
	 * are ok, which is not the case here.
	 */

> 
> >  }
> >  
> >  /* Mark parts of an inode healed. */
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index c3f912a9231b..0e2b6c05e604 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -23,6 +23,7 @@
> >  #include "xfs_dquot.h"
> >  #include "xfs_reflink.h"
> >  #include "xfs_ialloc.h"
> > +#include "xfs_health.h"
> >  
> >  #include <linux/iversion.h>
> >  
> > @@ -648,7 +649,7 @@ xfs_iget_cache_miss(
> >  	 * time.
> >  	 */
> >  	iflags = XFS_INEW;
> > -	if (flags & XFS_IGET_DONTCACHE)
> > +	if ((flags & XFS_IGET_DONTCACHE) && xfs_inode_is_healthy(ip))
> >  		d_mark_dontcache(VFS_I(ip));
> 
> This one I'm less clear on.. we've just allocated ip above and haven't
> made it accessible yet. What's the use case for finding an unhealthy
> inode here?

Hm.  I think I went overboard looking for DONTCACHE here, and it doesn't
make any sense to make this change.  Ok, dropped.

--D

> 
> Brian
> 
> >  	ip->i_udquot = NULL;
> >  	ip->i_gdquot = NULL;
> > 
> 
