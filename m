Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB52rMZg105024 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 20:53:23 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF9A7299B81
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 18:53:19 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BbNAGiLj9r7MXaya for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 18:53:19 -0800 (PST)
Date: Mon, 5 Dec 2011 13:53:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: fix the logspace waiting algorithm
Message-ID: <20111205025316.GD7046@dastard>
References: <20111128081732.350228200@bombadil.infradead.org>
	<20111128081925.981681380@bombadil.infradead.org>
	<20111130235641.GX29840@sgi.com>
	<20111201072149.GA1319@infradead.org>
	<20111201195128.GZ29840@sgi.com>
	<20111202115141.GA21643@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111202115141.GA21643@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Fri, Dec 02, 2011 at 06:51:41AM -0500, Christoph Hellwig wrote:
> On Thu, Dec 01, 2011 at 01:51:28PM -0600, Ben Myers wrote:
> > Process A reads from the grant reserve head at 2641 (and there currently is enough space)
> > Process B wakes at either 2646 or 2650, in xlog_reserveq_wait, locks, and reads from the grant reserve head (and currently there is enough space)
> > Process B removes itself from the list 
> > Process A reads from the reservq list and finds it to be empty
> > Process A finds that there was enough space at 2646
> > Process B returns from xlog_reserveq_wait, unlocks, grants space at 2656, returns
> > Process A grants log space at 2656, and returns
> > 
> > AFAICS there is nothing that prevents these guys from granting the same
> > space when you approach free_bytes >= need_bytes concurrently. 
> > 
> > This lockless stuff is always a mind job for me.  I'll take another look at
> > some of the other aspects of the patch.  Even if it doesn't resolve my
> > question about the lockless issue, it seems to resolve Chandra's race.
> 
> Indeed, I think we have this race.  Then again I I think we had
> exactly the same one before, too. 

What the current code does is this (ignoring this patch):

again:
	check free space
	if (no free space) {
		add to list;
		sleep;
					space becomes available
					wake up
		goto again;
	}

	remove from list
	grant space
		do {
			grant calc
		} while (head does not move)

The problem being talked about, as I understand it, is that free
space can change between the check and the grant, resulting in
process B also seeing free space because the space process A thinks
it has but has not yet accounted for it.

It seems to me that this can happen regardless of whether we have a
queue of waiters or not, so the change to how the waiters are woken
in Christoph's patch is irrelevant.

> The only way to fix it would be
> to do a sort of double cmpxchg that only moves the grant head forward
> if it's still in available space vs the tails lsn.

Actually, it's quite simple to fix simply by having the free space
check return the grant head value at the time of the check and then
using that as the old value in the cmpxchg loop for updating the
grant head. That is:

again:
	free = xlog_space_left(..... &old_head);
	......

	if (xlog_grant_add_space(log, l_grant_reserve_head, need_bytes, old_head)
		goto again;

and xlog_grant_log_space() returns 1 if the old_head does not match
the current head so we go araound again.

I don't think we don't need to do this for the write head update in
xlog_grant_log_space() because once we have been granted reserve
head space we are guarantee to have write head space.

We do, however, need to make the same change for the write head in
xlog_regrant_write_log_space() as that has potential for the same
race when two permanent transactions commit and race to re-reserve
the write space that was just consumed by the committed transaction.

And to retain existing behaviour for other callers, perhaps an
old_head value of -1 (NULL LSN value) can be passed to indicate that
current head value should be used and to loop until the change is
made....

Does that make sense? It retains the same lockless behaviour, but
closes the race condition of the grant head changing from the time
of read to the time of actual modification....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
