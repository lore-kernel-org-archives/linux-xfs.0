Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from prvmx02.microfocus.com ([130.57.1.217]:12106 "EHLO
        prvmx02.microfocus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390790AbfDRSWD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Apr 2019 14:22:03 -0400
Message-ID: <1555611694.18313.12.camel@suse.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
From: Davidlohr Bueso <dbueso@suse.com>
Date: Thu, 18 Apr 2019 11:21:34 -0700
In-Reply-To: <20190418031013.GX29573@dread.disaster.area>
References: <20190404165737.30889-1-amir73il@gmail.com>
         <20190404211730.GD26298@dastard> <20190408103303.GA18239@quack2.suse.cz>
         <1554741429.3326.43.camel@suse.com>
         <20190411011117.GC29573@dread.disaster.area>
         <20190416122240.GN29573@dread.disaster.area>
         <20190418031013.GX29573@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, 2019-04-18 at 13:10 +1000, Dave Chinner wrote:
> Now the stuff I've been working on has the same interface as
> Davidlohr's patch, so I can swap and change them without thinking
> about it. It's still completely unoptimised, but:
> 
> 			IOPS read/write (direct IO)
> processes	rwsem		DB rangelock	XFS
> rangelock
>  1		78k / 78k	75k / 75k	72k / 72k
>  2		131k / 131k	123k / 123k	133k / 133k
>  4		267k / 267k	183k / 183k	237k / 237k
>  8		372k / 372k	177k / 177k	265k / 265k
>  16		315k / 315k	135k / 135k	228k / 228k
> 
> It's still substantially faster than the interval tree code.

In general another big difference between both rangelock vs rwsems
(when comparing them with full ranges) is that the latter will do
writer optimistic spinning, so saving a context switch under the right
scenarios provides mayor wins for rwsems -- I'm not sure if this
applies to your fio tests, though. And pretty soon readers will also do
this, hence rwsem will become a try-hard-not-to-sleep lock.

One of the reasons why I was hesitant with Btrees was the fact that
insertion requires memory allocation, something I wanted to avoid...
per your numbers, sacrificing tree depth was the wrong choice. Thanks
for sharing these numbers.

> 
> BTW, if I take away the rwsem serialisation altogether, this
> test tops out at just under 500k/500k at 8 threads, and at 16
> threads has started dropping off (~440k/440k). So the rwsem is
> a scalability limitation at just 8 threads....
> 
> /me goes off and thinks more about adding optimistic lock coupling
> to the XFS iext btree to get rid of the need for tree-wide
> locking altogether

I was not aware of this code.

Thanks,
Davidlohr
