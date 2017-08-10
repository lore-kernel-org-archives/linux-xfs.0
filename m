Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38748 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752466AbdHJMJW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 08:09:22 -0400
Received: by mail-wm0-f54.google.com with SMTP id f15so20632222wmg.1
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 05:09:22 -0700 (PDT)
Message-ID: <63920C3663124B75BC0983A17533395A@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com> <20170809213307.GJ21024@dastard> <185A1C4516684B439A3711999ABACA79@alyakaslap> <20170810113322.GM21024@dastard>
In-Reply-To: <20170810113322.GM21024@dastard>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf conversion and the addition of an attribute
Date: Thu, 10 Aug 2017 15:09:09 +0300
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="iso-8859-1";
        reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, darrick.wong@oracle.com, libor.klepac@bcom.cz

Hi Dave,

Thanks for the explanation. So it seems we cannot move forward with this 
fix.

Will somebody else in XFS community be working on fixing this issue? As you 
pointed out, it exists for over two decades. Our production systems hit this 
every couple of days, and shutting down the filesystem causes outage.

Thanks,
Alex.




-----Original Message----- 
From: Dave Chinner
Sent: Thursday, August 10, 2017 2:33 PM
To: Alex Lyakas
Cc: linux-xfs@vger.kernel.org ; bfoster@redhat.com ; darrick.wong@oracle.com 
; libor.klepac@bcom.cz
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf 
conversion and the addition of an attribute

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

