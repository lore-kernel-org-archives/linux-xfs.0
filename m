Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:9379 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751387AbdHJLdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 07:33:25 -0400
Date: Thu, 10 Aug 2017 21:33:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170810113322.GM21024@dastard>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
 <20170809213307.GJ21024@dastard>
 <185A1C4516684B439A3711999ABACA79@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <185A1C4516684B439A3711999ABACA79@alyakaslap>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, darrick.wong@oracle.com, libor.klepac@bcom.cz

On Thu, Aug 10, 2017 at 11:02:12AM +0300, Alex Lyakas wrote:
> Hi Dave,
> 
> Let's sayf that xfs_defer_finish() commits the current transaction
> and the buffer has been held. Then xfs_defer_finish() opens the next
> transaction. The buffer that has been held is not joined to the
> second transaction, i.e., the second transaction knows nothing about
> this buffer, is that correct?

Yes.

> If so, the caller now holds the buffer
> exclusively, and he has one of two options:
> - release the buffer explicitly
> - join the buffer to some transaction

That's correct, but that's not the problem I see. :/

The problem is that the locked buffer is not joined and logged in
the rolling transactions run in xfs_defer_ops. Hence it can pin the
tail of the AIL, and this can prevent the transaction roll from
regranting the log space necessary to continue rolling the
transaction for the required number of transactions to complete the
deferred ops. If this happens, we end up with a log space deadlock.

Hence if we are holding an item that we logged in a transaction
locked and we roll the transaction, we have to join, hold and log it
in each subsequent transaction until we have finished with the item
and can unlock and release it.

This is documented in xfs_trans_roll():

        /*
         * Reserve space in the log for th next transaction.
         * This also pushes items in the "AIL", the list of logged items,
         * out to disk if they are taking up space at the tail of the log
         * that we want to use.  This requires that either nothing be locked
         * across this call, or that anything that is locked be logged in
         * the prior and the next transactions.
         */


Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
