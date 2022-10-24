Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5E6C38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJXEQK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiJXEQI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:16:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0AF5302D
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:16:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60054B80DC4
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 04:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21C1C4347C;
        Mon, 24 Oct 2022 04:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666584962;
        bh=nhvuF06BoRVafEyDi9WfBIb6G3vIT1pAnhl5jEXeiH8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZCAw2fSmneJ89nP3lWYh9CFWYQTR/nT30XrFWGgB/IZyV/Iw5/QX3pTm5unM1IOxr
         gvly7If2yqGUqSIvi4gajiQAhHYtNyNxkHujWryY5cRcDsFDRP6bdKhJlQBf6fu92/
         Tyg5Z9TkPL/3KuZ+ym0TU4BY3M9bf6g1kOFa3bYxJluF7C8WdWuWZ/sRz+Z5zTncuI
         IhGTi+Ege+woMKUzDeANYmrx8MSMv67g4O3FVz0rBZN9VTfS70i9DpoaWW4MD2du+e
         E6nnGyZvFDHB/aaDYzovxM6bQqmdKsRlW0OZh3xwRmppyPEo+BuzDrPcqYdkleMF7v
         bmwBBu0/F24YQ==
Date:   Sun, 23 Oct 2022 21:16:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: set the buffer type after holding the AG[IF]
 across trans_roll
Message-ID: <Y1YRgQGaxOFg7Vk3@magnolia>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
 <166473478893.1083155.2555785331844801316.stgit@magnolia>
 <20221013222553.GY3600936@dread.disaster.area>
 <Y0ic81YV1qZNxuJ9@magnolia>
 <20221014012819.GI3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014012819.GI3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 14, 2022 at 12:28:19PM +1100, Dave Chinner wrote:
> On Thu, Oct 13, 2022 at 04:19:15PM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 14, 2022 at 09:25:53AM +1100, Dave Chinner wrote:
> > > On Sun, Oct 02, 2022 at 11:19:48AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Currently, the only way to lock an allocation group is to hold the AGI
> > > > and AGF buffers.  If repair needs to roll the transaction while
> > > > repairing some AG metadata, it maintains that lock by holding the two
> > > > buffers across the transaction roll and joins them afterwards.
> > > > 
> > > > However, repair is not the same as the other parts of XFS that employ
> > > > this bhold/bjoin sequence, because it's possible that the AGI or AGF
> > > > buffers are not actually dirty before the roll.  In this case, the
> > > > buffer log item can detach from the buffer, which means that we have to
> > > 
> > > Doesn't this imply we have a reference counting problem with
> > > XFS_BLI_HOLD buffers? i.e. the bli can only get detached when the
> > > reference count on it goes to zero. If the buffer is clean and
> > > joined to a transaction, then that means the only reference to the
> > > BLI is the current transaction. Hence the only way it can get
> > > detached is for the transaction commit to release the current
> > > transaction's reference to the BLI.
> > > 
> > > Ah, XFS_BLI_HOLD does not take a reference to the BLI - it just
> > > prevents ->iop_release from releasing the -buffer- after it drops
> > > the transaction reference to the BLI. That's the problem right there
> > > - xfs_buf_item_release() drops the current trans ref to the clean
> > > item via xfs_buf_item_release() regardless of whether BLI_HOLD is
> > > set or not, hence freeing the BLI on clean buffers.
> > > 
> > > IOWs, it looks to me like XFS_BLI_HOLD should actually hold a
> > > reference to the BLI as well as the buffer so that we don't free the
> > > BLI for a held clean buffer in xfs_buf_item_release(). The reference
> > > we leave behind will then be picked up by the subsequent call to
> > > xfs_trans_bjoin() which finds the clean BLI already attached to the
> > > buffer...
> > 
> > <nod> I think you're saying that _xfs_trans_bjoin should:
> > 
> > 	if (!(bip->bli_flags & XFS_BLI_HOLD))
> > 		atomic_inc(&bip->bli_refcount);
> > 
> > and xfs_buf_item_release should do:
> > 
> > 	if (hold)
> > 		return;
> > 	released = xfs_buf_item_put(bip);
> > 	if (stale && !released)
> > 		return;
> 
> Not exactly. What I was thinking was something like this:
> 
> xfs_trans_bhold() should do:
> 
> 	bip->bli_flags |= XFS_BLI_HOLD;
> 	atomic_inc(&bip->bli_refcount);
> 
> xfs_trans_bhold_release() should do:
> 
> 	bip->bli_flags &= ~XFS_BLI_HOLD;
> 	atomic_dec(&bip->bli_refcount);
> 
> xfs_trans_brelse() shoudl do:
> 
> 	if (bip->bli_flags & XFS_BLI_HOLD) {
> 		bip->bli_flags &= ~XFS_BLI_HOLD;
> 		atomic_dec(&bip->bli_refcount);
> 	}
> 
> and xfs_buf_item_release() should do:
> 
> 	if (hold) {
> 		/* Release the hold ref but not the rolling transaction ref */
> 		bip->bli_flags &= ~XFS_BLI_HOLD;
> 		atomic_dec(&bip->bli_refcount);
> 		return;
> 	}
> 	released = xfs_buf_item_put(bip);
> 	if (stale && !released)
> 		return;
> 
> Then _xfs_trans_bjoin() remains unchanged, as we don't remove the
> BLI from the held clean buffer as there is still a reference to it.
> The new transaction we rejoin the buffer to will take that
> reference.

Hnmmmm.  I tried this, but it lead to massive memory corruption
problems, slab leak warnings, and a hang.  If I get around to it I'll
try to see if KASAN will help me figure out what went wrong.

It occurred to me that it might be easier to log the first byte of the
AGI and AGF buffers before the transaction roll, which prevents the bli
from falling off the buffer during the transaction rolling.

Yes that isn't fixing the problem that the unusual use of bhold on a
clean buffer doesn't work right, but <shrug> I don't want to increase
the risks of this patchset by reworking buffer/bli lifetimes when I can
do something simpler. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
