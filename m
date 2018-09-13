Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hermes.casalogic.dk ([91.216.14.29]:55532 "EHLO
        hermes.casalogic.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbeIMK3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Sep 2018 06:29:53 -0400
Date: Thu, 13 Sep 2018 07:21:59 +0200 (CEST)
From: Troels Hansen <th@casalogic.dk>
Message-ID: <1406319049.4700361.1536816119283.JavaMail.zimbra@casalogic.dk>
In-Reply-To: <20180913041944.GA27618@dastard>
References: <1063031109.4602643.1536739675362.JavaMail.zimbra@casalogic.dk> <20180913041944.GA27618@dastard>
Subject: Re: Strange XFS problem
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>


> 
> What happens on your network every 14 days or so? Is there a rogue
> client side backup or admin task running somewhere?
> 

Well, we run nightly backups, but thats read ops.
When I look at the load, its not particular more loaded at that time, than normal work.


> 
> Does this repeat every 120s?

No, what I sent is the full trace. It happened around 23:23, but no more XFS errors in the log (which is on the ext4 OS disk).
It was working when I came in the following morning aroung 6:45, and worked for some time,  but initially failed, and we had to reboot the server to get NFS exports to work.
But, as I said, even though the fs was inaccessible from NFS I could `ls` the filesystem locally, but we really have no indication of it being an NFS problem, as we only see the XFS problem.

It could also boil down to a NFS problem, I just wasn't sure how to read the XFS trace.

> These hung task warnings can happen if your workload has overloaded
> your raid array and everything doing IO hangs while it catches up.
> e.g. you have 6GB of random 4k writes in the controller NV cache and
> it takes minutes for it to flush (because random 4k writes are slow)
> and make room for new incoming IO....
> 
> If the warnings don't repeat, then it means it was a temporary
> overload. If the warnings repeat, but change processes and stack
> traces then it's a sustained overload condition. If exactly the same
> warnings repeat and/or has stalled and doesn't restart, then we've
> got some kind of hang occurring and we'll need to look into it
> further.
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
