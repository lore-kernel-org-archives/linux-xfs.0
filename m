Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B4EC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 01:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiJNB2Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 21:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJNB2Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 21:28:24 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1D6D1911F0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 18:28:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 600EA110176C;
        Fri, 14 Oct 2022 12:28:22 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oj9Up-001hSn-Ko; Fri, 14 Oct 2022 12:28:19 +1100
Date:   Fri, 14 Oct 2022 12:28:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: set the buffer type after holding the AG[IF]
 across trans_roll
Message-ID: <20221014012819.GI3600936@dread.disaster.area>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
 <166473478893.1083155.2555785331844801316.stgit@magnolia>
 <20221013222553.GY3600936@dread.disaster.area>
 <Y0ic81YV1qZNxuJ9@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0ic81YV1qZNxuJ9@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6348bb36
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=AUhvP04ChHDjPdUJj5EA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 13, 2022 at 04:19:15PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 14, 2022 at 09:25:53AM +1100, Dave Chinner wrote:
> > On Sun, Oct 02, 2022 at 11:19:48AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Currently, the only way to lock an allocation group is to hold the AGI
> > > and AGF buffers.  If repair needs to roll the transaction while
> > > repairing some AG metadata, it maintains that lock by holding the two
> > > buffers across the transaction roll and joins them afterwards.
> > > 
> > > However, repair is not the same as the other parts of XFS that employ
> > > this bhold/bjoin sequence, because it's possible that the AGI or AGF
> > > buffers are not actually dirty before the roll.  In this case, the
> > > buffer log item can detach from the buffer, which means that we have to
> > 
> > Doesn't this imply we have a reference counting problem with
> > XFS_BLI_HOLD buffers? i.e. the bli can only get detached when the
> > reference count on it goes to zero. If the buffer is clean and
> > joined to a transaction, then that means the only reference to the
> > BLI is the current transaction. Hence the only way it can get
> > detached is for the transaction commit to release the current
> > transaction's reference to the BLI.
> > 
> > Ah, XFS_BLI_HOLD does not take a reference to the BLI - it just
> > prevents ->iop_release from releasing the -buffer- after it drops
> > the transaction reference to the BLI. That's the problem right there
> > - xfs_buf_item_release() drops the current trans ref to the clean
> > item via xfs_buf_item_release() regardless of whether BLI_HOLD is
> > set or not, hence freeing the BLI on clean buffers.
> > 
> > IOWs, it looks to me like XFS_BLI_HOLD should actually hold a
> > reference to the BLI as well as the buffer so that we don't free the
> > BLI for a held clean buffer in xfs_buf_item_release(). The reference
> > we leave behind will then be picked up by the subsequent call to
> > xfs_trans_bjoin() which finds the clean BLI already attached to the
> > buffer...
> 
> <nod> I think you're saying that _xfs_trans_bjoin should:
> 
> 	if (!(bip->bli_flags & XFS_BLI_HOLD))
> 		atomic_inc(&bip->bli_refcount);
> 
> and xfs_buf_item_release should do:
> 
> 	if (hold)
> 		return;
> 	released = xfs_buf_item_put(bip);
> 	if (stale && !released)
> 		return;

Not exactly. What I was thinking was something like this:

xfs_trans_bhold() should do:

	bip->bli_flags |= XFS_BLI_HOLD;
	atomic_inc(&bip->bli_refcount);

xfs_trans_bhold_release() should do:

	bip->bli_flags &= ~XFS_BLI_HOLD;
	atomic_dec(&bip->bli_refcount);

xfs_trans_brelse() shoudl do:

	if (bip->bli_flags & XFS_BLI_HOLD) {
		bip->bli_flags &= ~XFS_BLI_HOLD;
		atomic_dec(&bip->bli_refcount);
	}

and xfs_buf_item_release() should do:

	if (hold) {
		/* Release the hold ref but not the rolling transaction ref */
		bip->bli_flags &= ~XFS_BLI_HOLD;
		atomic_dec(&bip->bli_refcount);
		return;
	}
	released = xfs_buf_item_put(bip);
	if (stale && !released)
		return;

Then _xfs_trans_bjoin() remains unchanged, as we don't remove the
BLI from the held clean buffer as there is still a reference to it.
The new transaction we rejoin the buffer to will take that
reference.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
