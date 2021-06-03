Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89493C47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 20:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AFBB613BF
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 20:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhFCUuv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 16:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCUuv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 16:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BCE6613BF;
        Thu,  3 Jun 2021 20:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622753345;
        bh=kVU2mI5H/6V1j53jItKVkYnYDvji7XLGE77rgj/tqXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ciNTmExQtjPZHIla+bk2K6oUOhzg5Fsc8AQqmkj9zmsI1EzYg0t6yZS/l2jY5nREv
         HMnpdPZSoGxhGTUsacoUE7kNqhNIkiZZNkdJ/oYOzaxUDjcmJlpYYfjMu2ImtkvRyR
         ML/j+qDIX53hmbTJ7PDjTA56cB4PhKwUgaWtxlObEum39dXajuFoEOAUZ7uhYEf+nB
         tx3UxEPV1eSvp5DeANt77906dNi6UYBlKRO34Ds+GeqzWIr68WYQFxJdizJ3IY48vK
         yxUljKTQJnxNJwM0AH/JajtzGQOvPppTYHc9t4imjJAYhYfZMR5GC5iLEJCS+rjqpX
         Fs9ScdVGarBSw==
Date:   Thu, 3 Jun 2021 13:49:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/3] xfs: drop IDONTCACHE on inodes when we mark them sick
Message-ID: <20210603204904.GB26380@locust>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
 <162268996687.2724138.9307511745121153042.stgit@locust>
 <20210603043446.GP664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603043446.GP664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 02:34:46PM +1000, Dave Chinner wrote:
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
> >  }
> 
> Dentries will still be reclaimed, but the VFS will at least hold on
> to the inode in this case.

Right.

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
> 
> Hmmmm. xfs_inode_is_healthy() is kind of heavyweight for just
> checking that ip->i_sick == 0. At this point, nobody else can be
> accessing the inode, so we don't need masks nor a spinlock for
> checking the sick field.
> 
> So why not:
> 
> 	if ((flags & XFS_IGET_DONTCACHE) && !READ_ONCE(ip->i_sick))
> 
> Or maybe still use xfs_inode_is_healthy() but convert it to the
> simpler, lockless sick check?

As Brian points out, it's totally unnecessary.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
