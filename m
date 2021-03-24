Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6245C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 03:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4997619A9
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 03:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhCXDxV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 23:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235168AbhCXDwu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 23:52:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 103BA619E8;
        Wed, 24 Mar 2021 03:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616557970;
        bh=ywmqMqm+5dAfI10Ganfwve6sKNuJXvNMb3pF9bxlPfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TM01BMuK2T8bBzA63T1mLxsiBVgADF8gEfniqzGFaDMwXFfgYZ6UGNENvLcI78k9i
         ztr4g5X0DaErGAwzDte2M5hnS1E/5RQBfNd4vyJEv8S1TxqzjRKuM4+3d7CUFuFeAV
         8bTZhuYvMkG24pGKKpTCMvclc8M7cFqnKmPWr6DVSvW5Vv5LrwsfOoF+6bbFvH8ICG
         SMtuxuelo/MKrpxa35j3qA/Q6LOzKWKbuVbtT6WA6BkVzrss+MYcCIYurzAAtGQqAZ
         18B+/mMhQT/43UcdSV2qutZydkO0OmvMzN4nQjJ0iy61myMLkF6yfrN/zo+9MmM1VK
         KypR2Hnf+ylDA==
Date:   Tue, 23 Mar 2021 20:52:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: parallelize inode inactivation
Message-ID: <20210324035249.GS22100@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543199635.1947934.2885924822578773349.stgit@magnolia>
 <20210323222152.GH63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323222152.GH63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 09:21:52AM +1100, Dave Chinner wrote:
> On Wed, Mar 10, 2021 at 07:06:36PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Split the inode inactivation work into per-AG work items so that we can
> > take advantage of parallelization.
> 
> How does this scale out when we have thousands of AGs?

Welllll... :)

> I'm guessing that the gc_workqueue has the default "unbound"
> parallelism that means it will run up to 4 kworkers per CPU at a
> time? Which means we could have hundreds of ags trying to hammer on
> inactivations at the same time? And so bash hard on the log and
> completely starve the syscall front end of log space?

Yep.  This is a blunt instrument to throttle the frontend when the
backend has too much queued.

> It seems to me that this needs to bound the amount of concurrent
> work to quite low numbers - even though it is per-ag, we do not want
> this to swamp the system in kworkers blocked on log reservations
> when such concurrency it not necessary.

Two months ago, I /did/ propose limiting the parallelism of those
unbound workqueues to an estimate of what the data device could
handle[1], and you said on IRC[2]:

[1] https://lore.kernel.org/linux-xfs/161040739544.1582286.11068012972712089066.stgit@magnolia/T/#ma0cd1bf1447ccfb66d615cab624c8df67d17f9b0

[2] (14:01:26) dchinner: "Assume parallelism is equal to number of disks"?

(14:02:22) dchinner: For spinning disks we want more parallelism than
that to hide seek latency - we want multiple IOs per disk so that the
elevator can re-order them and minimise seek distances across a set of
IOs

(14:02:37) dchinner: that can't be done if we are only issuing a single
IO per disk at a time

(14:03:30) djwong: 2 per spinning disk?

(14:03:32) dchinner: The more IO you can throw at spinning disks, the
lower the average seek penalty for any given IO....

(14:04:01) dchinner: ANd then there is hardware raid with caches and NVRAM....

(14:04:25) dchinner: This is why I find this sort of knob "misguided"

(14:05:01) dchinner: the "best value" is going to change according to
workload, storage stack config and hardware

(14:05:48) dchinner: Even for SSDs, a thread per CPU is not enough
parallelism if we are doing blocking IO in each thread

(14:07:07) dchinner: The device concurrency is actually the CTQ depth of
the underlying hardware, because that's how many IOs we can keep in
flight at once...

(14:08:06) dchinner: so, yeah, I'm not a fan of having knobs to "tune"
concurrency

(14:09:55) dchinner: As long as we have "enough" for decent performance
on a majority of setups, even if it is "too much" for some cases, that
is better than trying to find some magic optimal number for everyone....

(14:10:16) djwong: so do we simply let the workqueues spawn however many
threads and keep the bottleneck at the storage?

(14:10:39) djwong: (or log grant)

(14:11:08) dchinner: That's the idea - the concurrency backs up at the
serialisation point in the stack

(14:11:23) djwong: for blockgc and inactivation i don't think that's a
huge deal since we're probably going to run out of AGs or log space
anyway

(14:11:25) dchinner: that's actually valuable information if you are
doing perofrmance evaluation

(14:11:51) dchinner: we know immediately where the concurrency
bottleneck is....

(14:13:15) dchinner: backing up in xfs-conv indicates that we're either
running out of log space, the IO completion is contending on inode locks
with concurrent IO submission, etc

(14:14:13) dchinner: and if it's teh xfs-buf kworkers that are going
crazy, we know it's metadata IO rather than user data IO that is having
problems....

(14:15:27) dchinner: seeing multiple active xfs-cil worker threads
indicates pipelined concurrent pushes being active, implying either the
CIL is filling faster than it can be pushed or there are lots of
fsync()s being issued

(14:16:57) dchinner: so, yeah, actually being able to see excessive
concurrency at the kworker level just from teh process listing tells us
a lot from an analysis POV....

---

Now we have unrestricted unbound workqueues, and I'm definitely
getting to collect data on contention bottlenecks -- when there are a
lot of small files, AFAICT we mostly end up contending on the grant
heads, and when we have heavily fragmented images to kill off then it
tends to shift to the AG buffer locks.

So how do we estimate a reasonable upper bound on the number of workers?
Given that most of the gc workers will be probably be contending on
AG[FI] buffer locks I guess we could say min(agcount, nrcpus)?

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
