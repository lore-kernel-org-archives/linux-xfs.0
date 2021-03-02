Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C48C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D374961477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245269AbhCCDOZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:14:25 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:52047 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1447312AbhCBPeh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 10:34:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UQ6T3rx_1614699077;
Received: from 30.39.210.67(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UQ6T3rx_1614699077)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Mar 2021 23:31:18 +0800
Subject: Re: code questions about xfs log implementation
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <a732a6ff-4d66-91e5-cd9a-43d156d83362@linux.alibaba.com>
 <20210228233218.GB4662@dread.disaster.area>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <26dedeb7-b73a-3734-65d4-4e2356239961@linux.alibaba.com>
Date:   Tue, 2 Mar 2021 23:28:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210228233218.GB4662@dread.disaster.area>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

hi,

Sorry for late reply, because I took some time to understand your words and read
source codes, your explanation is great and really help me to understand xfs log
codes now. Appreciate your time, thanks.
Currently we use ext4 widely, but xfs has some advanced features, such as reflink,
there're some users who needs to use these features. Once we have a good knowledge
about xfs, we may have a try in product.

Regards,
Xiaoguang Wang


> On Sun, Feb 28, 2021 at 03:46:56PM +0800, Xiaoguang Wang wrote:
>> hi,
>>
>> I'm studying xfs delayed logging codes, and currently have some questions about log
>> reservation, can anyone help to answer below questions, thanks in advance!
>>
>> 1, what's the difference between xlog's l_reserve_head and l_write_head?
>> Seems that l_reserve_head already can been used to do log space reservation, from
>> codes, I really don't get when to use l_reserve_head or l_write_head, so what different
>> cases are they used for?
> 
> The reserve head tracks active transaction reservation space, the
> write head tracks physical log space reservation. Mostly they track
> the same, but there's an important difference when it comes to
> rolling permanent transactions.
> 
>>
>> 2, what's the exact definition about permanent transaction reservation?
>> In xfs_trans_resv_calc(), I see many kinds of transactions have XFS_TRANS_PERM_LOG_RES
>> enabled, so non-permanent transaction does not need to do log reservation
>> at the begin?
> 
> Non-permanent transactions are effectively one-shot transactions.
> They consist of:
> 
> 	tp = xfs_trans_alloc(<space>)
> 	<do modification>
> 	xfs_trans_commit(tp);
> 
> Once the transaction is committed, all resources attached to it are
> released, along with all the unused reservation space (both reserve
> and write space).
> 
> A "permanent" transaction is on that can be "rolled" repeatedly to
> form a long running chain of individual transactions that appears
> atomic to outside runtime observers. You'll see this pattern:
> 
> 	tp = xfs_trans_alloc(<space>)
> 	xfs_ilock(ip, XFS_ILOCK_EXCL)
> 
> 	loop {
> 		xfs_trans_ijoin(tp, 0);
> 		<do modification>
> 		xfs_trans_log_inode(tp, ip);
> 		xfs_trans_roll(&tp);
> 	}
> 
> 	xfs_trans_commit(tp);
> 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 
> This holds the inode locked over a series of rolling transactions,
> and hence while this series of modifications is running, nothing
> else can read from or write to the inode. i.e. the change is atomic
> from an external observer's point of view. The key here is
> xfs_trans_roll(), which does:
> 
> 	ntp = xfs_trans_dup(tp);
> 	xfs_trans_commit(tp);
> 	xfs_log_reserve(ntp);
> 
> This duplicates the current transaction and it's internal state
> (including reservations), commits the original transaction, then
> reserves space for the new transaction if necessary. This can only
> be done with transactions marked as permanent transactions.
> 
> The key here is that a permanent transaction reserves space for
> multiple transactions up front. this is the tr_logcount in the
> reservation. This number of unit reservations is made in the
> original xfs_trans_alloc() call, and each time the transaction
> "rolls" the unit count is decremented by one.
> 
> This is because each commit releases the unused part of the current
> unit reservation back to the log and the new transaction (the dup'd
> transaction) will start with an entire unit reservation that it
> can consume.
> 
> So what happens when the log count reaches zero? Well, that's where
> the differences between the reserve head and the write head come in.
> When the log count reaches zero and the remaining unit reservations
> have been freed, xfs_log_regrant() immediately takes
> a new unit reservation on the reservation head. This
> -overcommits- the reservation grant space, preventing new
> reservations from occurring if the log is full until some ongoing
> transactions commit and release unused reservation space.
> 
> xfs_log_regrant() does not, however, take any new space from the
> write head because this tracks physical space in the log and must
> not be overcommitted. If we overcommit write space, we can
> physically overwrite the tail of the log with the current head, and
> that corrupts the log. We can't wait for write head space in the
> xfs_trans_commit code, because the commit we are about to write to
> log might contain items that pin the tail of the log. Hence  new
> write space won't get released for the current transaction because
> that needs the commit to complete.
> 
> Hence we wait until we call xfs_log_reserve() after
> xfs_trans_commit() completes to regrant write head space. At this
> point, it is safe for us to sleep if the transaction we just
> committed ensured that it relogged all the items in the transaction
> that might pin the tail of the log (e.g. the inode). Because we
> relogged those items, they'll get moved to the head of the log and
> the tail will move forwards, guaranteeing that there will be write
> space available for this permanent transaction. And we are
> guaranteed that there will eventually be write space available
> because we over-committed the reserve head and nobody can take new
> reserve space via xfs_trans_alloc() while we are overcommitted.
> 
> So that's how permanent transactions and reservations work.
> 
> It is important to note that a series of rolling transactions in a
> chain like this do not form an atomic change on disk.  While each
> individual modification is atomic, the chain is *not atomic*. If we
> crash half way through, then recovery will only replay up to the
> last modification the loop made.
> 
> If you want an atomic modification that requires multiple individual
> transactions to perform, then you need to learn about xfs_defer_ops,
> intents, etc and how they are used within a permanent transaction
> chain and recovery to form an atomic all-or-nothing modification to
> the filesystem.
> 
>> 3, struct xfs_trans_res's tr_logcount(/* number of log operations per log ticket */)
>> For exmaple, tr_write.tr_logcount is XFS_WRITE_LOG_COUNT_REFLINK(8), does that mean
>> to complete a write operation, we'll need 8 log operations, such as file block mapping
>> update intent will be counted one?
> 
> It means that we expect the vast majority of reflink modifications
> to take less than 8 individual transactions chained together to
> complete. THis effectively forms a fast path for common operations
> where xfs_trans_roll() does not block having to wait for log space
> to become available. IOWs, for the fast path when there is log space
> available, we do an atomic, lockless transaction reservation for up
> to 8 transaction rolls to complete the operation without need to
> obtain more log space.
> 
>> 4, what's the exact definition about xfs rolling transactions?
> 
> "rolling transaction" == "permanent transaction"
> 
> Same thing, just one refers to the way the log sees the log space
> accounting (a reservation that is permanent until the caller
> releases it) and the other refers to the way the code running
> transactions sees them (you roll from one transaction to the next in
> the chain).
> 
>> 5, finally are there any documents that describe the initial xfs log design before
>> current delayed logging design?
>> Documentation/filesystems/xfs-delayed-logging-design.rst is a very good document, but
>> seems that it assumes that readers has been familiar with initial xfs log design.
> 
> No. I wrote the delayed logging document with that in mind - the
> first section ("Introduction to Re-logging in XFS") describes how
> the original log design worked. That's essentially what I also wrote
> above - none of what I describe above has anything to do with
> delayed logging, nor does it even know (or care) that delayed
> logging exists.
> 
> The above is all about locking, relogging and log space accounting,
> and it's largely unchanged from the original design. While we've
> added delayed logging and deferred transactions, they all still work
> within the rules I outline above. It all really only works because
> of the original design rules placed around the need to relog items
> in permanent transactions...
> 
> Cheers,
> 
> Dave.
> 
