Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33398 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388479AbfGYLdm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 07:33:42 -0400
Date: Thu, 25 Jul 2019 21:32:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: garbage file data inclusion bug under memory pressure
Message-ID: <20190725113231.GV7689@dread.disaster.area>
References: <f7c3d69e-bbd4-244c-41d7-b03c923c5344@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7c3d69e-bbd4-244c-41d7-b03c923c5344@i-love.sakura.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 07:06:24PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I noticed that a file includes data from deleted files when
> 
>   XFS (sda1): writeback error on sector XXXXX
> 
> messages are printed (due to close to OOM).
> 
> So far I confirmed that this bug exists at least from 4.18 till 5.3-rc1.
> I haven't tried 4.17 and earlier kernels. I haven't tried other filesystems.
> 
> 
> 
> Steps to test:
> 
> (1) Run the disk space filler (source code is shown below).
> 
>   # ./fillspace > file &
>   # unlink file
>   # fg
> 
> (2) Wait until the disk space filler completes.
> 
> (3) Start the reproducer (source code is shown below).
> 
>   # ./oom-torture
> 
> (4) Stop the reproducer using Ctrl-C after "writeback error on sector"
>     message was printed.
> 
>   [ 1410.792467] XFS (sda1): writeback error on sector 159883016
>   [ 1410.822127] XFS (sda1): writeback error on sector 187138128
>   [ 1410.951357] XFS (sda1): writeback error on sector 162195392
>   [ 1410.952527] XFS (sda1): writeback error on sector 95210384
>   [ 1410.953870] XFS (sda1): writeback error on sector 95539264
> 
> (5) Examine files written by the reproducer for file data
>     written by the disk space filler.
> 
>   # grep -F XXXXX /tmp/file.*
>   Binary file /tmp/file.10111 matches
>   Binary file /tmp/file.10122 matches
>   Binary file /tmp/file.10143 matches
>   Binary file /tmp/file.10162 matches
>   Binary file /tmp/file.10179 matches

You've had writeback errors. This is somewhat expected behaviour for
most filesystems when there are write errors - space has been
allocated, but whatever was to be written into that allocated space
failed for some reason so it remains in an uninitialised state....

For XFS and sequential writes, the on-disk file size is not extended
on an IO error, hence it should not expose stale data.  However,
your test code is not checking for errors - that's a bug in your
test code - and that's why writeback errors are resulting in stale
data exposure.  i.e. by ignoring the fsync() error,
the test continues writing at the next offset and the fsync() for
that new data write exposes the region of stale data in the
file where the previous data write failed by extending the on-disk
EOF past it....

So in this case stale data exposure is a side effect of not
handling writeback errors appropriately in the application.

But I have to ask: what is causing the IO to fail? OOM conditions
should not cause writeback errors - XFS will retry memory
allocations until they succeed, and the block layer is supposed to
be resilient against memory shortages, too. Hence I'd be interested
to know what is actually failing here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
