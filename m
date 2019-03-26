Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54424 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfCZRNa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Mar 2019 13:13:30 -0400
Date: Tue, 26 Mar 2019 13:13:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: generic/475 deadlock?
Message-ID: <20190326171324.GA58320@bfoster>
References: <20190320050408.GA24923@magnolia>
 <20190320170305.GA29010@bfoster>
 <20190320174551.GA1186@magnolia>
 <20190320175922.GB29010@bfoster>
 <20190320214938.GU23020@dastard>
 <20190321121152.GA33001@bfoster>
 <20190321211051.GV23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321211051.GV23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 22, 2019 at 08:10:51AM +1100, Dave Chinner wrote:
...
> 
> So given that inode reclaim already waits for inodes to be unpinned
> and there is a xfs_buf_unpin_wait() call in
> xfs_bwrite()->xfs_buf_submit() path that will issue a log force on
> the buffer from the inode reclaim path, we don't actually need the
> log force in xfs_iflush() at all. i.e.  the AIL will capture the
> buffer state and unpin inode and dquot buffers automatically, and so
> we can simply remove the pinned-buffer log forces from the
> inode/dquot flush code....
> 

Hmm, where is the log force you reference above in the inode reclaim (->
xfs_bwrite()) path if the buffer happens to be pinned? I see the
xfs_buf_wait_unpin() in the submit path, but that just waits on the pin
count (which I think is safe). It actually looks to me that reclaim
could be susceptible to the write delay problem you referenced earlier
in this thread without the log force from xfs_iflush()..

It also occurs to me that the xfs_iflush() log force isn't blocking
because it's a a sync force, but rather because there is already a CIL
push in progress. The flush_work() call basically means that a non-sync
force can either queue a workqueue job and return or turn somewhat
synchronous by waiting for whatever push happens to be in progress. That
implies another potential workaround could be to find a way around this
sync behavior (assuming that would be fundamentally more simple than
just avoiding log forces entirely while holding non-transactional buffer
locks).

Of course that assumes there aren't other variants of this. I still need
to poke around more to get a better idea of the scope. One that looks
like a possibility to me right now is the xfs_iflush_cluster() ->
xfs_force_shutdown() -> xfs_log_force() sequence (in the event of a
corrupt in-core inode on the same pinned buffer) down in the same iflush
path. Another could be in xfs_trans_read_buf_map() where if we somehow
grab a dirty+pinned buffer with b_error set, we can issue a shutdown if
the transaction is dirty before we release the failed buffer. That
combination of events should probably never happen (and the vector is
probably closed by just releasing the buffer before the shutdown), but
it kind of illustrates the potential for whack-a-mole with log forces
and shutdown calls scattered around in so many places.. :/

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
