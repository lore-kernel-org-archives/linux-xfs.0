Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16838 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726994AbeH1BbM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Aug 2018 21:31:12 -0400
Date: Tue, 28 Aug 2018 07:42:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/3] xfs: Prevent multiple wakeups of the same log
 space waiter
Message-ID: <20180827214242.GH2234@dastard>
References: <1535316795-21560-1-git-send-email-longman@redhat.com>
 <1535316795-21560-3-git-send-email-longman@redhat.com>
 <20180827002134.GE2234@dastard>
 <20180827073906.GA24831@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180827073906.GA24831@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Waiman Long <longman@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 27, 2018 at 12:39:06AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 27, 2018 at 10:21:34AM +1000, Dave Chinner wrote:
> > tl; dr: Once you pass a certain point, ramdisks can be *much* slower
> > than SSDs on journal intensive workloads like AIM7. Hence it would be
> > useful to see if you have the same problems on, say, high
> > performance nvme SSDs.
> 
> Note that all these ramdisk issues you mentioned below will also apply
> to using the pmem driver on nvdimms, which might be a more realistic
> version.  Even worse at least for cases where the nvdimms aren't
> actually powerfail dram of some sort with write through caching and
> ADR the latency is going to be much higher than the ramdisk as well.

Yes, I realise that.

I am expecting that when it comes to optimising for pmem, we'll
actually rewrite the journal to map pmem and memcpy() directly
rather than go through the buffering and IO layers we currently do
so we can minimise write latency and control concurrency ourselves.
Hence I'm not really concerned by performance issues with pmem at
this point - most of our still users have traditional storage and
will for a long time to come....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
