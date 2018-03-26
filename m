Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752131AbeCZQ2c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Mar 2018 12:28:32 -0400
Date: Mon, 26 Mar 2018 12:28:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20180326162830.GF34912@bfoster.bfoster>
References: <f13839700d372a4663a08a11883e9c89b13056ca.1521752282.git.shli@fb.com>
 <CAJDdQW29Vjs9=PqREJZa_xHyA33Qdjf6NN95yGyan3ENwDfGZw@mail.gmail.com>
 <20180325215904.GH18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180325215904.GH18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: =?utf-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>, Shaohua Li <shli@kernel.org>, linux-xfs@vger.kernel.org

On Mon, Mar 26, 2018 at 08:59:04AM +1100, Dave Chinner wrote:
> On Fri, Mar 23, 2018 at 10:24:03PM +0800, 张本龙 wrote:
> > Hi Shaohua and XFS,
> > 
> > May I ask how are we gonna handle REQ_META issued from XFS? As you
> > mentioned about charging to root cgroup (also in an earlier email
> > discussion), and seems the 4.16.0-rc6 code is not handling it
> > separately.
> > 
> > In our case to support XFS cgroup writeback control, which was ported
> > and slightly adapted to 3.10.0, ignoring xfs log bios resulted in
> > trouble. Threads from throttled docker might submit_bio in following
> > path by its own identity, this docker blkcg accumulated large amounts
> > of data (e.g., 20GB), thus such log gets blocked.
> 
> And thus displaying the reason why I originally refused to merge
> this code until regression tests were added to fstests to exercise
> these sorts of issues. This stuff adds new internal filesystem IO
> ordering constraints, so we need tests that exercise it and ensure
> we don't accidentally break it in future.
> 

Hmm, but if the user issues fsync from the throttled cgroup then won't
that throttling occur today, regardless of cgroup aware writeback? My
understanding is that cgawb just accurately accounts writeback I/Os to
the owner of the cached pages. IOW, if the buffered writer and fsync
call are in the same throttled cgroup, then the throttling works just as
it would with cgawb and the writer being in a throttled cgroup.

So ISTM that this is an independent problem. What am I missing?

Shaohua,

Do you have a reference to the older metadata related patch mentioned in
the commit log that presumably addressed this?

Brian

> 
> > Not familiar with XFS, but seems log bios are partially stuck in
> > throttled cgroups, leaving other innocent groups waiting for
> > completion. To cope with this we bypassed REQ_META log bios in
> > blk_throtl_bio().
> 
> Yup, the log is global and should not be throttled. Metadata is less
> obvious as to what the correct thing to do is, because writes are
> always done from internal kernel threads but reads are done from a
> mix of kernel threads, user cgroup contexts and user data IO
> completions. Hence there are situations where metadata reads may
> need to be throttled because they are cgroup context only (e.g.
> filesystem directory traversal) but others where reads should not
> be throttled because they have global context (e.g. inside a
> transaction when other buffers are already locked).
> 
> Getting this right and keeping it working requires regression tests
> that get run on every release, whether it be upstream or distro
> kernels, and that means we need tests in fstests to cover cgroup IO
> control....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
