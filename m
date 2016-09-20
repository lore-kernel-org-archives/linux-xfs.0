Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:38137 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752737AbcITAUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Sep 2016 20:20:22 -0400
Date: Tue, 20 Sep 2016 10:13:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: rework log recovery to submit buffers on LSN
 boundaries
Message-ID: <20160920001330.GF340@dastard>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
 <1470935467-52772-2-git-send-email-bfoster@redhat.com>
 <20160829011631.GK19025@dastard>
 <20160829181721.GA54904@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160829181721.GA54904@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com, linux-xfs@vger.kernel.org

[ sorry to take so long to get back to this, Brian, I missed your
reply and only yesterday when I was sorting out for-next updates
that I still had this on my "for-review" patch stack. ]

On Mon, Aug 29, 2016 at 02:17:22PM -0400, Brian Foster wrote:
> On Mon, Aug 29, 2016 at 11:16:31AM +1000, Dave Chinner wrote:
> > On Thu, Aug 11, 2016 at 01:11:03PM -0400, Brian Foster wrote:
> > i.e. We are very careful to write commit records in the correct
> > order because that is what determines recovery order, but we don't
> > care what order we write the actual contents of the checkpoints or
> > whether they interleave with other checkpoints.  As such, ophdrs
> > change transactions and LSNs without having actually completed
> > recovery of a checkpoint. 
> > 
> > I think writeback should occur when all the transactions with a
> > given lsn have been committed. I'm not sure there's a simple way to
> > track and detect this, but using the ophdrs to detect a change of
> > lsn to trigger buffer writeback does not look correct to me at this
> > point in time.
> > 
> 
> That is precisely the intent of this patch. What I think could be a
> problem is something like the following, if possible:
> 
>                     CA         CB                  CC CD
> +---------+--------+--+-------+--+--------+-------+--+--+
>   trans A   trans B    trans C    trans C  trans D

Yes, that's possible.

> Assume that trans A and trans B are within the same record and trans C
> is in a separate record. In that case, we commit trans A which populates
> buffer_list. We lookup trans C, note a new LSN and drain buffer_list.
> Then we ultimately commit trans B, which has the same metadata LSN as
> trans A and thus is a path to the original problem if trans B happened
> to modify any of the same blocks as trans A.

Yes, that's right, we still are exposed to the same problem, and
there's much more convoluted versions of it possible.

> Do note however that this is just an occurrence of the problem with log
> recovery as implemented today (once we update metadata LSNs, and is
> likely rare as I haven't been able to reproduce corruption in many
> tries).

Yeah, it's damn hard to intentionally cause interleaving of
checkpoint and commit records these days because of the delayed
logging does aggregation in memory rather than in the log buffers
themselves.

> If that analysis is correct, I think a straightforward solution
> might be to defer submission to the lookup of a transaction with a new
> LSN that _also_ corresponds with processing of a commit record based on
> where we are in the on-disk log. E.g.:
> 
> 	if (log->l_recovery_lsn != trans->r_lsn &&
> 	    oh_flags & XLOG_COMMIT_TRANS) {
> 		error = xfs_buf_delwri_submit(buffer_list);
> 		...
> 	}
> 
> So in the above, we'd submit buffers for A and B once we visit the
> commit record for trans C. Thoughts?

Sounds plausible - let me just check I understood by repeating it
back. Given the above case, we start with log->l_recovery_lsn set to
the lsn before trans A and an empty buffer list.

1. We now recover trans A and trans B into their respective structures,
but we don't don't add their dirty buffers to the delwri list yet -
they are kept internal to the trans.

2. We then see commit A, and because the buffer list is empty we
simply add them to the buffer list and update log->l_recovery_lsn to
point at the transaction LSN.

3. We now see trans C, and start recovering it into an internal buffer
list.

4. Then we process commit B, see that there are already queued buffers
and so check the transaction LSN against log->l_recovery_lsn. They
are the same, so we simply add the transactions dirty buffers to
the buffer list.

5. We continue processing transaction C, and start on transaction D.
We then see commit C. Buffer list is populated, so we check
transaction lsn against log->l_recovery_lsn. They are different.
At this point we know we have fully processed all the transactions
that are associated with log->l_recovery_lsn, hence we can submit
the buffer_list and mark it empty again.

6. At this point we jump back to step 2, this time processing commit
C onwards....

7. At the end of log recovery, we commit the remaining buffer list
from the last transaction we recovered from the log.

Did I understand it right? If so, I think this will work just fine.

Thanks, Brian!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
