Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 05F797CA1
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2016 12:09:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F922AC004
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2016 10:08:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QrvDNHTOvI1eZJCD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Sep 2016 10:08:54 -0700 (PDT)
Date: Fri, 23 Sep 2016 13:08:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs: rework log recovery to submit buffers on LSN
	boundaries
Message-ID: <20160923170851.GA18135@bfoster.bfoster>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
	<1470935467-52772-2-git-send-email-bfoster@redhat.com>
	<20160829011631.GK19025@dastard>
	<20160829181721.GA54904@bfoster.bfoster>
	<20160920001330.GF340@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160920001330.GF340@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 20, 2016 at 10:13:30AM +1000, Dave Chinner wrote:
> [ sorry to take so long to get back to this, Brian, I missed your
> reply and only yesterday when I was sorting out for-next updates
> that I still had this on my "for-review" patch stack. ]
> 

No problem. I've been away anyways..

> On Mon, Aug 29, 2016 at 02:17:22PM -0400, Brian Foster wrote:
> > On Mon, Aug 29, 2016 at 11:16:31AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 11, 2016 at 01:11:03PM -0400, Brian Foster wrote:
> > > i.e. We are very careful to write commit records in the correct
> > > order because that is what determines recovery order, but we don't
> > > care what order we write the actual contents of the checkpoints or
> > > whether they interleave with other checkpoints.  As such, ophdrs
> > > change transactions and LSNs without having actually completed
> > > recovery of a checkpoint. 
> > > 
> > > I think writeback should occur when all the transactions with a
> > > given lsn have been committed. I'm not sure there's a simple way to
> > > track and detect this, but using the ophdrs to detect a change of
> > > lsn to trigger buffer writeback does not look correct to me at this
> > > point in time.
> > > 
> > 
> > That is precisely the intent of this patch. What I think could be a
> > problem is something like the following, if possible:
> > 
> >                     CA         CB                  CC CD
> > +---------+--------+--+-------+--+--------+-------+--+--+
> >   trans A   trans B    trans C    trans C  trans D
> 
> Yes, that's possible.
> 

Ok.

> > Assume that trans A and trans B are within the same record and trans C
> > is in a separate record. In that case, we commit trans A which populates
> > buffer_list. We lookup trans C, note a new LSN and drain buffer_list.
> > Then we ultimately commit trans B, which has the same metadata LSN as
> > trans A and thus is a path to the original problem if trans B happened
> > to modify any of the same blocks as trans A.
> 
> Yes, that's right, we still are exposed to the same problem, and
> there's much more convoluted versions of it possible.
> 
> > Do note however that this is just an occurrence of the problem with log
> > recovery as implemented today (once we update metadata LSNs, and is
> > likely rare as I haven't been able to reproduce corruption in many
> > tries).
> 
> Yeah, it's damn hard to intentionally cause interleaving of
> checkpoint and commit records these days because of the delayed
> logging does aggregation in memory rather than in the log buffers
> themselves.
> 

Makes sense.

> > If that analysis is correct, I think a straightforward solution
> > might be to defer submission to the lookup of a transaction with a new
> > LSN that _also_ corresponds with processing of a commit record based on
> > where we are in the on-disk log. E.g.:
> > 
> > 	if (log->l_recovery_lsn != trans->r_lsn &&
> > 	    oh_flags & XLOG_COMMIT_TRANS) {
> > 		error = xfs_buf_delwri_submit(buffer_list);
> > 		...
> > 	}
> > 
> > So in the above, we'd submit buffers for A and B once we visit the
> > commit record for trans C. Thoughts?
> 
> Sounds plausible - let me just check I understood by repeating it
> back. Given the above case, we start with log->l_recovery_lsn set to
> the lsn before trans A and an empty buffer list.
> 
> 1. We now recover trans A and trans B into their respective structures,
> but we don't don't add their dirty buffers to the delwri list yet -
> they are kept internal to the trans.
> 
> 2. We then see commit A, and because the buffer list is empty we
> simply add them to the buffer list and update log->l_recovery_lsn to
> point at the transaction LSN.
> 

Right...

> 3. We now see trans C, and start recovering it into an internal buffer
> list.
> 
> 4. Then we process commit B, see that there are already queued buffers
> and so check the transaction LSN against log->l_recovery_lsn. They
> are the same, so we simply add the transactions dirty buffers to
> the buffer list.
> 

Maybe just weird wording here, but to be precise (and pedantic), the
top-level check is for the current LSN change, not necessarily whether
the buffer_list is empty or not. The behavior is the same either way.

> 5. We continue processing transaction C, and start on transaction D.
> We then see commit C. Buffer list is populated, so we check
> transaction lsn against log->l_recovery_lsn. They are different.
> At this point we know we have fully processed all the transactions
> that are associated with log->l_recovery_lsn, hence we can submit
> the buffer_list and mark it empty again.
> 
> 6. At this point we jump back to step 2, this time processing commit
> C onwards....
> 
> 7. At the end of log recovery, we commit the remaining buffer list
> from the last transaction we recovered from the log.
> 
> Did I understand it right? If so, I think this will work just fine.
> 

Yep, I think so. I'll send an updated version.

Brian

> Thanks, Brian!
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
