Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651D6C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 23:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJMXTS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 19:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJMXTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 19:19:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06EB181C9D
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 16:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AB7C6198A
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 23:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2C5C433B5;
        Thu, 13 Oct 2022 23:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665703155;
        bh=d1gpRKFTtoMIntddzYywmDM2RMSIK97MHjkboYUiUBA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=imnSKm12rvUMYHmjA2WDajeGOrznVA86nL2aHuJmTKVtmTD+Wzctwd7QezppkGAVm
         0rHvcLtNvhoCrQF3HwrtBqzJhnFR1gpENu43Sigr/QvBdDOjlc50gCPhIQipyjRt9N
         YeBsWsOjera7TYb+NiH8L3W9qoQSWkW51QzTMFkqOWdH63zl0dJpCTHUWY2FfMPKXW
         TR4yWYuEfigcgtQJ5BDhvMSLsII43OkR6HoWufgSMSocE7GRMvm62xUl4rdfqhdqze
         gL/G4RV9w+NDxKR7takMvbfgp2MqpJFaNRnzOFRQo8DjzHgAj/rhCd+yFOPMXlu/P7
         Mlxtzdm++V2/g==
Date:   Thu, 13 Oct 2022 16:19:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: set the buffer type after holding the AG[IF]
 across trans_roll
Message-ID: <Y0ic81YV1qZNxuJ9@magnolia>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
 <166473478893.1083155.2555785331844801316.stgit@magnolia>
 <20221013222553.GY3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013222553.GY3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 14, 2022 at 09:25:53AM +1100, Dave Chinner wrote:
> On Sun, Oct 02, 2022 at 11:19:48AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Currently, the only way to lock an allocation group is to hold the AGI
> > and AGF buffers.  If repair needs to roll the transaction while
> > repairing some AG metadata, it maintains that lock by holding the two
> > buffers across the transaction roll and joins them afterwards.
> > 
> > However, repair is not the same as the other parts of XFS that employ
> > this bhold/bjoin sequence, because it's possible that the AGI or AGF
> > buffers are not actually dirty before the roll.  In this case, the
> > buffer log item can detach from the buffer, which means that we have to
> 
> Doesn't this imply we have a reference counting problem with
> XFS_BLI_HOLD buffers? i.e. the bli can only get detached when the
> reference count on it goes to zero. If the buffer is clean and
> joined to a transaction, then that means the only reference to the
> BLI is the current transaction. Hence the only way it can get
> detached is for the transaction commit to release the current
> transaction's reference to the BLI.
> 
> Ah, XFS_BLI_HOLD does not take a reference to the BLI - it just
> prevents ->iop_release from releasing the -buffer- after it drops
> the transaction reference to the BLI. That's the problem right there
> - xfs_buf_item_release() drops the current trans ref to the clean
> item via xfs_buf_item_release() regardless of whether BLI_HOLD is
> set or not, hence freeing the BLI on clean buffers.
> 
> IOWs, it looks to me like XFS_BLI_HOLD should actually hold a
> reference to the BLI as well as the buffer so that we don't free the
> BLI for a held clean buffer in xfs_buf_item_release(). The reference
> we leave behind will then be picked up by the subsequent call to
> xfs_trans_bjoin() which finds the clean BLI already attached to the
> buffer...

<nod> I think you're saying that _xfs_trans_bjoin should:

	if (!(bip->bli_flags & XFS_BLI_HOLD))
		atomic_inc(&bip->bli_refcount);

and xfs_buf_item_release should do:

	if (hold)
		return;
	released = xfs_buf_item_put(bip);
	if (stale && !released)
		return;

I'll have to remember how I induced this error in the first place.  I
think it was when I was running repair tests with mem=600M.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
