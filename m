Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54738C47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 20:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F10C613DE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 20:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhFCUnm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 16:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCUnm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 16:43:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6906F610CB;
        Thu,  3 Jun 2021 20:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622752917;
        bh=mWMJ1tDLgZevBOKs3hPjVheP5tCllSbGr0Jxbad3lk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nHysc0yAbtBoPDVMHqJqkaq/mwyXa2juDbE+OfQMUZ+HbkGskGVJnz4AHf9f6iIhu
         dsqIpdCknI9o5sI8jPbVbAzPf/ZNq2R2Flgy92t5VATrMb0KV7Fa+pGYH4LIuKwl2a
         sLAPpPlAjogYNF+IZoD4WnmUsLblPRHO7+KLZelrRbCHZAkPX1I6l3YciLhB0CPnMP
         5boz42OWo68f/Hy1B0yVHshvpF81mK82nESYrK1/OuWs6aknQUvfr5ZXhXmUQAcsiz
         mWHKrj4Pxv5tiRFR3ImFrXSFjwbkRYifAQ2O/qJ4w5JVR1qWDc4D7tJj30xtXaF4vD
         3SamuglyXWe1Q==
Date:   Thu, 3 Jun 2021 13:41:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: only reset incore inode health state flags when
 reclaiming an inode
Message-ID: <20210603204157.GZ26380@locust>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
 <162268996135.2724138.14276025100886638786.stgit@locust>
 <YLjJcro1vhPTfGrv@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLjJcro1vhPTfGrv@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 08:22:10AM -0400, Brian Foster wrote:
> On Wed, Jun 02, 2021 at 08:12:41PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While running some fuzz tests on inode metadata, I noticed that the
> > filesystem health report (as provided by xfs_spaceman) failed to report
> > the file corruption even when spaceman was run immediately after running
> > xfs_scrub to detect the corruption.  That isn't the intended behavior;
> > one ought to be able to run scrub to detect errors in the ondisk
> > metadata and be able to access to those reports for some time after the
> > scrub.
> > 
> > After running the same sequence through an instrumented kernel, I
> > discovered the reason why -- scrub igets the file, scans it, marks it
> > sick, and ireleases the inode.  When the VFS lets go of the incore
> > inode, it moves to RECLAIMABLE state.  If spaceman igets the incore
> > inode before it moves to RECLAIM state, iget reinitializes the VFS
> > state, clears the sick and checked masks, and hands back the inode.  At
> > this point, the caller has the exact same incore inode, but with all the
> > health state erased.
> > 
> > In other words, we're erasing the incore inode's health state flags when
> > we've decided NOT to sever the link between the incore inode and the
> > ondisk inode.  This is wrong, so we need to remove the lines that zero
> > the fields from xfs_iget_cache_hit.
> > 
> > As a precaution, we add the same lines into xfs_reclaim_inode just after
> > we sever the link between incore and ondisk inode.  Strictly speaking
> > this isn't necessary because once an inode has gone through reclaim it
> > must go through xfs_inode_alloc (which also zeroes the state) and
> > xfs_iget is careful to check for mismatches between the inode it pulls
> > out of the radix tree and the one it wants.
> > 
> > Fixes: 6772c1f11206 ("xfs: track metadata health status")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> I think I reviewed this the last time around..

Oops, yes, my bad. :(

--D

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  fs/xfs/xfs_icache.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 396cc54ca03f..c3f912a9231b 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -523,9 +523,6 @@ xfs_iget_cache_hit(
> >  				XFS_INO_TO_AGINO(pag->pag_mount, ino),
> >  				XFS_ICI_RECLAIM_TAG);
> >  		inode->i_state = I_NEW;
> > -		ip->i_sick = 0;
> > -		ip->i_checked = 0;
> > -
> >  		spin_unlock(&ip->i_flags_lock);
> >  		spin_unlock(&pag->pag_ici_lock);
> >  	} else {
> > @@ -979,6 +976,8 @@ xfs_reclaim_inode(
> >  	spin_lock(&ip->i_flags_lock);
> >  	ip->i_flags = XFS_IRECLAIM;
> >  	ip->i_ino = 0;
> > +	ip->i_sick = 0;
> > +	ip->i_checked = 0;
> >  	spin_unlock(&ip->i_flags_lock);
> >  
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > 
> 
