Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB7CC43331
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 21:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A55B2076E
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 21:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgCWV7w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 17:59:52 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40022 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725990AbgCWV7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 17:59:52 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D9E8F3A3454;
        Tue, 24 Mar 2020 08:59:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGV6p-0004PS-4z; Tue, 24 Mar 2020 08:59:47 +1100
Date:   Tue, 24 Mar 2020 08:59:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 0/4] xfs: Remove wrappers for some semaphores
Message-ID: <20200323215947.GW10776@dread.disaster.area>
References: <20200320210317.1071747-1-preichl@redhat.com>
 <20200323032809.GA29339@magnolia>
 <CAJc7PzXuRHhYztic9vZsspiHiP-vL_0HANd8x76Y+OdRVw6wwg@mail.gmail.com>
 <20200323163342.GD29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323163342.GD29339@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=FbZfGxazjVlMzVJsfMMA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 23, 2020 at 09:33:42AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 23, 2020 at 10:22:02AM +0100, Pavel Reichl wrote:
> > Oh, thanks for the heads up...I'll try to investigate.
> 
> Ahah, I figured it out.  It took me a while to pin down a solid reproducer,
> but here's a stack trace that I see most often:
....
> lockdep tracks the rwsem's lock state /and/ which process actually
> holds the rwsem.  This ownership doesn't transfer from 28177 to 27081,
> so when the kworker asks lockdep if it holds ILOCK_EXCL, lockdep says
> no, because 27081 doesn't own the lock, 28177 does.  Kaboom.

Yeah, linux has this weird idea that semaphores can only be accessed
from a single process context, like a mutex. We've beaten our head
against this many times, and it's the only reason struct semaphore
still exists and everything isn't a mutex.

rwsems now do crazy stuff like track the owner for spinning
optimisations, despite the fact it's a semaphore and, by definition,
can be released by non-owner contexts....

> The old mrlock_t had that 'int mr_writer' field which didn't care about
> lock ownership and so isilocked would return true and so the assert was
> happy.
> 
> So now comes the fun part -- the old isilocked code had a glaring hole
> in which it would return true if *anyone* held the lock, even if the
> owner is some other unrelated thread.  That's probably good enough for
> most of the fstests because we generally only run one thread at a time,
> and developers will probably notice. :)

No, that's not a bug, that's how semaphores work - semaphores
protect the object, not the process context that took the lock.

i.e. the difference between a mutex and a semaphore is that the
mutex protects a code path from running concurrently with other
processes, while a semaphore protects an object from other accesses,
even when they don't have a process context associated with them
(e.g. while they are under IO).

> However, with your series applied, the isilocked function becomes much
> more powerful when lockdep is active because now we can test that the
> lock is held *by the caller*, which closes that hole.

Not really, it's just another "lockdep behaviour is wrong" issue we
have to work around. When we switch to a worker, we need to release
and acquire the lockdep context so that it thinks the current
process working on the object owns the lock.

> Unfortunately, it also trips over this bmap split case, so if there's a
> way to solve that problem we'd better find it quickly.  Unfortunately, I
> don't know of a way to gift a lock to another thread temporarily...

rwsem_release() when the work is queued, rwsem_acquire() when the
work is run. And vice versa when the work is done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
