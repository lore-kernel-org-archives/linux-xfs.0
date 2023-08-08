Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31D3C001DB
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 00:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjHHAkL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 20:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjHHAkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 20:40:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7476F171E
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 17:40:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F339162340
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 00:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A84C433C7;
        Tue,  8 Aug 2023 00:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691455208;
        bh=fllCMKr/M3hk2iDPoEpCfgoRcYfTR1mSdmE1gBBznG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QBft5tdKG8/z6NQTIgEMrBHvEgyddQHOc1VvEdetkmI+Z86EPECwg3h/yW3a+gcii
         oBehhpOmfiW1uDNRq+iZZj0Tyh++0CezdR1Oolv5kn9zV8Da2ZpxeOP8HJHrBUTQzo
         z9jFQPVxS3KPjQle9wFis1oLq8K7qivafg9HW3iXoqjgW1ry2dqoUMbqGWatxj6m8h
         zH16FjDRE/5LcLY6x4lmA5GfGC2oO4HH94TfayY1mgNZUwPX6ftK1CDOsbv3uKf3yh
         z+ILmkniBL+e3UuSafL0NgGzSD6M4wNjYFFYEpPnZHv5mGQWEGigRDbpfHUQSNsGUD
         wouXuy7ZzJXWA==
Date:   Mon, 7 Aug 2023 17:40:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v26.0 0/9] xfs: fix online repair block reaping
Message-ID: <20230808004007.GM11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
 <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
 <ZNCM35YJ/yroXI/n@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNCM35YJ/yroXI/n@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 07, 2023 at 04:19:11PM +1000, Dave Chinner wrote:
> On Thu, Jul 27, 2023 at 03:18:32PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > These patches fix a few problems that I noticed in the code that deals
> > with old btree blocks after a successful repair.
> > 
> > First, I observed that it is possible for repair to incorrectly
> > invalidate and delete old btree blocks if they were crosslinked.  The
> > solution here is to consult the reverse mappings for each block in the
> > extent -- singly owned blocks are invalidated and freed, whereas for
> > crosslinked blocks, we merely drop the incorrect reverse mapping.
> > 
> > A largeish change in this patchset is moving the reaping code to a
> > separate file, because the code are mostly interrelated static
> > functions.  For now this also drops the ability to reap file blocks,
> > which will return when we add the bmbt repair functions.
> > 
> > Second, we convert the reap function to use EFIs so that we can commit
> > to freeing as many blocks in as few transactions as we dare.  We would
> > like to free as many old blocks as we can in the same transaction that
> > commits the new structure to the ondisk filesystem to minimize the
> > number of blocks that leak if the system crashes before the repair fully
> > completes.
> > 
> > The third change made in this series is to avoid tripping buffer cache
> > assertions if we're merely scanning the buffer cache for buffers to
> > invalidate, and find a non-stale buffer of the wrong length.  This is
> > primarily cosmetic, but makes my life easier.
> > 
> > The fourth change restructures the reaping code to try to process as many
> > blocks in one go as possible, to reduce logging traffic.
> > 
> > The last change switches the reaping mechanism to use per-AG bitmaps
> > defined in a previous patchset.  This should reduce type confusion when
> > reading the source code.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> 
> Overall I don't see any red flags, so from that perspective I think
> it's good to merge as is. THe buffer cache interactions are much
> neater this time around.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

> The main thing I noticed is that the deferred freeing mechanism ifo
> rbulk reaping will add up to 128 XEFIs to the transaction. That
> could result in a single EFI with up to 128 extents in it, right?

Welllp... the defer ops code only logs up to 16 extents per EFI log item
due to my, er, butchering of max_items.  So in the end, we log up to 8x
EFI items, each of which has up to 16y EFIs...

> What happens when we try to free that many extents in a single
> transaction loop? The extent free processing doesn't have a "have we
> run out of transaction reservation" check in it like the refcount
> item processing does, so I don't think it can roll to renew the
> transaction reservation if it is needed. DO we need to catch this
> and renew the reservation by returning -EAGAIN from
> xfs_extent_free_finish_item() if there isn't enough of a reservation
> remaining to free an extent?

...and by my estimation, those eight items consume a fraction of the
reservation available with tr_itruncate:

16 x xfs_extent_64_t   = 256 bytes
1 x xfs_efi_log_format = 8 bytes
                       = 272 bytes per EFI

8 x EFI                = 2176 bytes

So far, I haven't seen any overflows with the reaping code -- for the AG
btree rebuilders, we end up logging and relogging the same bnobt/cntbt
buffers over and over again.  tr_itruncate gives us ~320K per transaction,
and I haven't seen any overflows yet.

This might actually become more of a problem if we want to reap an
inode-rooted btree, each block is in a different AG, and there are (say)
more than 128 AGs... but I think the solution to that will be to
xrep_defer_finish between AGs.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
