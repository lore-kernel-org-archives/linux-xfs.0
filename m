Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33007 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbfGYWIh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 18:08:37 -0400
Date: Fri, 26 Jul 2019 08:07:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: garbage file data inclusion bug under memory pressure
Message-ID: <20190725220726.GW7689@dread.disaster.area>
References: <f7c3d69e-bbd4-244c-41d7-b03c923c5344@i-love.sakura.ne.jp>
 <20190725113231.GV7689@dread.disaster.area>
 <804d24cb-5b7c-4620-5a5f-4ec039472086@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804d24cb-5b7c-4620-5a5f-4ec039472086@i-love.sakura.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 09:44:35PM +0900, Tetsuo Handa wrote:
> On 2019/07/25 20:32, Dave Chinner wrote:
> > You've had writeback errors. This is somewhat expected behaviour for
> > most filesystems when there are write errors - space has been
> > allocated, but whatever was to be written into that allocated space
> > failed for some reason so it remains in an uninitialised state....
> 
> This is bad for security perspective. The data I found are e.g. random
> source file, /var/log/secure , SQL database server's access log
> containing secret values...

The results of a read after a write error are undefined. In this
case, the test is doing enough IO to evict the cached pages that
failed the write so the followup read is pulling them from disk, not
from the page cache. i.e. if the test read back immediately after
the failure, it would get whatever the write put into the page cache
but writeback failed to write to disk....

Perhaps we need the write retry mechanisms we use for metadata in
the data IO path, too, so that a single writeback failure doesn't
cause this sort of thing to occur.

> > For XFS and sequential writes, the on-disk file size is not extended
> > on an IO error, hence it should not expose stale data.  However,
> > your test code is not checking for errors - that's a bug in your
> > test code - and that's why writeback errors are resulting in stale
> > data exposure.  i.e. by ignoring the fsync() error,
> > the test continues writing at the next offset and the fsync() for
> > that new data write exposes the region of stale data in the
> > file where the previous data write failed by extending the on-disk
> > EOF past it....
> > 
> > So in this case stale data exposure is a side effect of not
> > handling writeback errors appropriately in the application.
> 
> But blaming users regarding not handling writeback errors is pointless
> when thinking from security perspective.

I'm not blaming anyone. I'm just explaining how the problem was
exposed and pointing out that the responsibility for writing data
correctly falls on *both* the filesystem and userspace applications.
i.e. when the kernel fails it is userspace's responsibility to clean
up the mess to ensure the /application's data/ is correctly on
stable storage and not corrupt, missing, stale, etc.

So forget security - fsync is a data integrity operation. Not
checking that that it failed is extremely poor behaviour from a data
integrity point of view. Fix the data integrity problems in the
application and the security issues that data integrity failures
/may/ expose are very effectively mitigated.

> A bad guy might be trying to
> steal data from inaccessible files.

Which won't happen if user-triggered OOM does not cause writeback
failures. i.e. the bug we need to find and fix is whatever is
causing writeback to error out under OOM conditions.
Writeback is a key component of memory reclaim, and it it fails
under memory pressure we have much bigger problems...

> > But I have to ask: what is causing the IO to fail? OOM conditions
> > should not cause writeback errors - XFS will retry memory
> > allocations until they succeed, and the block layer is supposed to
> > be resilient against memory shortages, too. Hence I'd be interested
> > to know what is actually failing here...
> 
> Yeah. It is strange that this problem occurs when close-to-OOM.
> But no failure messages at all (except OOM killer messages and writeback
> error messages).

Perhaps using things like trace_kmalloc and friends to isolate the
location of memory allocation failures would help....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
