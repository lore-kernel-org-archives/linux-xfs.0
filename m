Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA1BC47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 20:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B057613DE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 20:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhFCUn2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 16:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhFCUn2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 16:43:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D88C6610CB;
        Thu,  3 Jun 2021 20:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622752902;
        bh=CNGOX7Qtjbj220jpTBVi4b+pDrbjOMtk7JNUOMQj9yE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UkT6Qoq89/yLFhgHaqpm+IVLZFbkqwVxIBrjsFt7MvTjhQmYFpHHTt66Xr1WJ7JRT
         7Qsqvf8MmmSmuZioMmI/pvlm6j/eox/k72/9Y3PuJU/hlFegmWqGz9hY9c0qF07iS9
         Sm8/lSNykqe4BHvf4h9N+G/4YgmXrS0Ba7hn7Q2HZ1uvRKVPcuibnt/9k9hZmV8mix
         SwlD4x72ySZbxedIXQzTOTGTOGRd3fD9jcgKDRfyNqy2tirzY7biIX5lmobXzSFLeh
         jR11GN7EgRC0qu1X4VEr2YsodAmG4wffTFKj+gWNDZXveYJl3ZWfwiq3gPu5vybF/W
         e3g+hSKnzaNzg==
Date:   Thu, 3 Jun 2021 13:41:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/3] xfs: only reset incore inode health state flags when
 reclaiming an inode
Message-ID: <20210603204142.GY26380@locust>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
 <162268996135.2724138.14276025100886638786.stgit@locust>
 <20210603042107.GO664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603042107.GO664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 02:21:07PM +1000, Dave Chinner wrote:
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
> >  fs/xfs/xfs_icache.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> Looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Though I do wonder how long such state will hang around, because
> once the inode is IRECLAIMABLE and clean it is only a matter of
> seconds before the background inode reclaimer will free it...

A future patchset will add the ability to make the per-AG health status
remember that we were forced to reclaim a sick inode:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting

This series used to be the "fixes first" part of that code, but since it
directly intersects with the deferred inactivation changes, I moved it
up to try to fix the problem sooner than later.

Anyway, thanks for the review.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
