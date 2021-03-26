Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A5CC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 17:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7131561A43
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 17:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhCZRdO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 13:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230315AbhCZRct (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Mar 2021 13:32:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FBFD61999;
        Fri, 26 Mar 2021 17:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616779968;
        bh=jw6qgT6rnokdNfST9s8hgmNp6kMOMQRt6ZemD/h0a8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Llv7fpT+SXf/ezOqfnvFhYdX1k52nMCREZwP3lCcgxPgtTWDiqTJ5isBxYhawXcQT
         swPYbuqAz2WbU/I185UGm0aHoPQ45SVzkOTg3BkmUVq5wZ5uuND/iAkpW6IOgL+eP3
         GvwPK4DNJbwMrXBXdoUtyuyaMTEsKvRDCzmd6YaXwOzhWc8OJP+cyVx9bVVNPBumrx
         rD8DZm1Qz375BgaXQwTQQ41hO6p+TrRABv1UmGmYtajJs2ffv/MrHvr841HpqvEECy
         WRDj0xEq81G1pkUL3g2j5pw6nLoByrkKnge2bmKxDARWcH8sHkfNtfuevODl7mFIvH
         qoFfpSvnfAiIQ==
Date:   Fri, 26 Mar 2021 10:32:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: xfs ioend batching log reservation deadlock
Message-ID: <20210326173244.GY4090233@magnolia>
References: <YF4AOto30pC/0FYW@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YF4AOto30pC/0FYW@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 26, 2021 at 11:39:38AM -0400, Brian Foster wrote:
> Hi all,
> 
> We have a report of a workload that deadlocks on log reservation via
> iomap_ioend completion batching. To start, the fs format is somewhat
> unique in that the log is on the smaller side (35MB) and the log stripe
> unit is 256k, but this is actually a default mkfs for the underlying
> storage. I don't have much more information wrt to the workload or
> anything that contributes to the completion processing characteristics.
> 
> The overall scenario is that a workqueue task is executing in
> xfs_end_io() and blocked on transaction reservation for an unwritten
> extent conversion. Since this task began executing and pulled pending
> items from ->i_ioend_list, the latter was repopulated with 90 ioends, 67
> of which have append transactions. These append transactions account for
> ~520k of log reservation each due to the log stripe unit. All together
> this consumes nearly all of available log space, prevents allocation of
> the aforementioned unwritten extent conversion transaction and thus
> leaves the fs in a deadlocked state.
> 
> I can think of different ways we could probably optimize this problem
> away. One example is to transfer the append transaction to the inode at
> bio completion time such that we retain only one per pending batch of
> ioends. The workqueue task would then pull this append transaction from
> the inode along with the ioend list and transfer it back to the last
> non-unwritten/shared ioend in the sorted list.
> 
> That said, I'm not totally convinced this addresses the fundamental
> problem of acquiring transaction reservation from a context that
> essentially already owns outstanding reservation vs. just making it hard
> to reproduce. I'm wondering if/why we need the append transaction at
> all. AFAICT it goes back to commit 281627df3eb5 ("xfs: log file size
> updates at I/O completion time") in v3.4 which changed the completion
> on-disk size update from being an unlogged update. If we continue to
> send these potential append ioends to the workqueue for completion
> processing, is there any reason we can't let the workqueue allocate the
> transaction as it already does for unwritten conversion?

Frankly I've never understood what benefit we get from preallocating a
transaction and letting it twist in the wind consuming log space while
writeback pushes data to the disk.  It's perfectly fine to delay ioend
processing while we wait for unwritten conversions and cow remapping to
take effect, so what's the harm in a slight delay for this?

I guess it's an optimization to reduce wait times?  It's a pity that
nobody left a comment justifying why it was done in that particular way,
what with the freeze protection lockdep weirdness too.

> If that is reasonable, I'm thinking of a couple patches:
> 
> 1. Optimize current append transaction processing with an inode field as
> noted above.
> 
> 2. Replace the submission side append transaction entirely with a flag
> or some such on the ioend that allocates the transaction at completion
> time, but otherwise preserves batching behavior instituted in patch 1.

What happens if you replace the call to xfs_setfilesize_ioend in
xfs_end_ioend with xfs_setfilesize, and skip the transaction
preallocation altogether?

--D

> Thoughts?
> 
> Brian
> 
