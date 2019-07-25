Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36766 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfGYR2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 13:28:38 -0400
Date: Thu, 25 Jul 2019 10:28:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs: garbage file data inclusion bug under memory pressure
Message-ID: <20190725172830.GE1561054@magnolia>
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
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

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

Woot.  That's bad.

By any chance do the duo of patches:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=bd012b434a56d9fac3cbc33062b8e2cd6e1ad0a0
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=adcf7c0c87191fd3616813c8ce9790f89a9a8eba

fix this problem?  I wrote them a while ago but I never got around to
quantifying how much of a performance impact they'd have.

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
> when thinking from security perspective. A bad guy might be trying to
> steal data from inaccessible files.

My thoughts exactly.  I'm not sure what data is supposed to be read()
from a file after a write error <cough> but I'm pretty sure that
"someone else's discarded junk" is /not/ in that set.

> 
> > 
> > But I have to ask: what is causing the IO to fail? OOM conditions
> > should not cause writeback errors - XFS will retry memory
> > allocations until they succeed, and the block layer is supposed to
> > be resilient against memory shortages, too. Hence I'd be interested
> > to know what is actually failing here...
> 
> Yeah. It is strange that this problem occurs when close-to-OOM.
> But no failure messages at all (except OOM killer messages and writeback
> error messages).

That /is/ strange.  I wonder if your scsi driver is trying to allocate
memory, failing, and the block layer squishes that into EIO?

--D
