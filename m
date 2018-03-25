Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:2135 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752112AbeCYV7H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Mar 2018 17:59:07 -0400
Date: Mon, 26 Mar 2018 08:59:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20180325215904.GH18129@dastard>
References: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
 <CAJDdQW29Vjs9=PqREJZa_xHyA33Qdjf6NN95yGyan3ENwDfGZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJDdQW29Vjs9=PqREJZa_xHyA33Qdjf6NN95yGyan3ENwDfGZw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, linux-xfs@vger.kernel.org

On Fri, Mar 23, 2018 at 10:24:03PM +0800, 张本龙 wrote:
> Hi Shaohua and XFS,
> 
> May I ask how are we gonna handle REQ_META issued from XFS? As you
> mentioned about charging to root cgroup (also in an earlier email
> discussion), and seems the 4.16.0-rc6 code is not handling it
> separately.
> 
> In our case to support XFS cgroup writeback control, which was ported
> and slightly adapted to 3.10.0, ignoring xfs log bios resulted in
> trouble. Threads from throttled docker might submit_bio in following
> path by its own identity, this docker blkcg accumulated large amounts
> of data (e.g., 20GB), thus such log gets blocked.

And thus displaying the reason why I originally refused to merge
this code until regression tests were added to fstests to exercise
these sorts of issues. This stuff adds new internal filesystem IO
ordering constraints, so we need tests that exercise it and ensure
we don't accidentally break it in future.


> Not familiar with XFS, but seems log bios are partially stuck in
> throttled cgroups, leaving other innocent groups waiting for
> completion. To cope with this we bypassed REQ_META log bios in
> blk_throtl_bio().

Yup, the log is global and should not be throttled. Metadata is less
obvious as to what the correct thing to do is, because writes are
always done from internal kernel threads but reads are done from a
mix of kernel threads, user cgroup contexts and user data IO
completions. Hence there are situations where metadata reads may
need to be throttled because they are cgroup context only (e.g.
filesystem directory traversal) but others where reads should not
be throttled because they have global context (e.g. inside a
transaction when other buffers are already locked).

Getting this right and keeping it working requires regression tests
that get run on every release, whether it be upstream or distro
kernels, and that means we need tests in fstests to cover cgroup IO
control....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
