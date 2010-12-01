Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1CSpQm206746 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 06:28:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B34621BA206
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 04:30:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id l8bysXQsBmqld5ap for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 04:30:34 -0800 (PST)
Date: Wed, 1 Dec 2010 07:30:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/14] xfs: clean up log space grant functions
Message-ID: <20101201123032.GA20378@infradead.org>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290994712-21376-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 29, 2010 at 12:38:20PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xlog_grant_log_space and xlog_regrant_log_write_space both have very
> similar structure. Both have a "wait on non-empty queue" section at
> the start, followed by a "wait for space" loop of which the contents
> are almost identical to the initial non-empty queue section.
> 
> In both cases, the non-empty queue wait can be folded into the wait
> for space loop, simply by entering the loop if the queue is not
> empty and the current ticket is not on the queue. If we trigger the
> non-empty queue case, we always add ourselves to the queue, and
> hence the second and subsequent loops are always driven by the "wait
> for space" test.
> 
> IOWs, both wait conditions can be folded into the one loop, removing
> a bunch of duplicated code and making it simpler to modify in
> future patches.

I don't really like this patch.  The new conditions are overly
complicated because of the desire to only go through the loop once
for the queue not empty case.  In addition there's some behaviour
changes:

 - in xlog_grant_log_space we previously didn't call xlog_grant_push_ail
   for the queue not empty case, and now we do.
 - in xlog_regrant_write_log_space the old version of the queue not
   empty case would loop over all waiting tickets, and if we could
   wake up all of them we'll skip the first wait, and given enough
   free space also the second wait, while the new code always adds it
   to the writeq, although it will still skip the actualy wait later.

My recommendation would be to skip this patch for now and revisit the
area later.  For example the superflous xlog_grant_push_ail actually
is rather harmless these days with the xfsaild threshold, so not
skipping it for the first case probably is fine in the end.  Then again
the whole add to the queue just in case if it's non-empty doesn't make
much sense to me to start with.  As soon as xfs_log_move_tail makes
space in the log it wakes up all tickets waiting for it anyway, so
adding us to the queue just in case seems rather inefficient, and not
overl helpful.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
