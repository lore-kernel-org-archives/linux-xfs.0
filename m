Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27080 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbdBUBoE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Feb 2017 20:44:04 -0500
Date: Mon, 20 Feb 2017 17:43:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: transaction reservations for deleting of shared extents
Message-ID: <20170221014356.GA5844@birch.djwong.org>
References: <20170220072945.GA17608@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170220072945.GA17608@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 20, 2017 at 08:29:45AM +0100, Christoph Hellwig wrote:
> Hi Darrick,
> 
> I got a bug report about running out of log reservations when deleting
> heavily reflinked files.
> 
> We're hitting the ASSERT(tp->t_ticket->t_curr_res >= len) in
> xlog_cil_insert_items and it seems we are way above the reservation.
> 
> I started auditing the issue and it seems like we don't account for
> the refcountbt adjustments at all in tr_itruncate.  Do you have any
> back of the napking math around for what amount of log reservations
> we should need for them?  Otherwise I'll need to wade through the
> code and recreate that math.

Hmmmm.  refcountbt updates should all be processed as deferred ops,
which means that each logical update ("increase refcount of blocks
3-300") should be getting its own transaction.

The function xfs_refcount_still_have_space tries to guess when we're
getting close to using up all the log reservation by assuming that each
refcount update will eventually use 32 bytes of the transaction
reservation, though it's hard to know precisely what the results of
formatting the log items will be.

When it thinks we're out of transaction space it'll signal a partial
completion, which (should) cause the defer_ops mechanism to log an RUD
and a new RUI, then roll the transaction and start again.  I speculate
that my guess of 32 bytes per refcountbt update is not correct. :(

Can you reproduce it easily?  IIRC xfs/140 should exercise some of this
mechanism.

--D
