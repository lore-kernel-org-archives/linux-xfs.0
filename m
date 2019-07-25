Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:52451 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387824AbfGYMoj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 08:44:39 -0400
Subject: Re: xfs: garbage file data inclusion bug under memory pressure
References: <f7c3d69e-bbd4-244c-41d7-b03c923c5344@i-love.sakura.ne.jp>
 <20190725113231.GV7689@dread.disaster.area>
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <804d24cb-5b7c-4620-5a5f-4ec039472086@i-love.sakura.ne.jp>
Date: Thu, 25 Jul 2019 21:44:35 +0900
MIME-Version: 1.0
In-Reply-To: <20190725113231.GV7689@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 2019/07/25 20:32, Dave Chinner wrote:
> You've had writeback errors. This is somewhat expected behaviour for
> most filesystems when there are write errors - space has been
> allocated, but whatever was to be written into that allocated space
> failed for some reason so it remains in an uninitialised state....

This is bad for security perspective. The data I found are e.g. random
source file, /var/log/secure , SQL database server's access log
containing secret values...

> 
> For XFS and sequential writes, the on-disk file size is not extended
> on an IO error, hence it should not expose stale data.  However,
> your test code is not checking for errors - that's a bug in your
> test code - and that's why writeback errors are resulting in stale
> data exposure.  i.e. by ignoring the fsync() error,
> the test continues writing at the next offset and the fsync() for
> that new data write exposes the region of stale data in the
> file where the previous data write failed by extending the on-disk
> EOF past it....
> 
> So in this case stale data exposure is a side effect of not
> handling writeback errors appropriately in the application.

But blaming users regarding not handling writeback errors is pointless
when thinking from security perspective. A bad guy might be trying to
steal data from inaccessible files.

> 
> But I have to ask: what is causing the IO to fail? OOM conditions
> should not cause writeback errors - XFS will retry memory
> allocations until they succeed, and the block layer is supposed to
> be resilient against memory shortages, too. Hence I'd be interested
> to know what is actually failing here...

Yeah. It is strange that this problem occurs when close-to-OOM.
But no failure messages at all (except OOM killer messages and writeback
error messages).
