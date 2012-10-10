Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9AMtgxJ179670 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 17:55:42 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	xF1Hd8nnC24C4hCX for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2012 15:57:12 -0700 (PDT)
Date: Thu, 11 Oct 2012 09:57:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/14] xfs: only update the last_sync_lsn when a
	transaction completes
Message-ID: <20121010225700.GY23644@dastard>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
	<1349693772-8064-15-git-send-email-david@fromorbit.com>
	<20121010142841.GV13214@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121010142841.GV13214@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 10, 2012 at 09:28:41AM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Mon, Oct 08, 2012 at 09:56:12PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The log write code stamps each iclog with the current tail LSN in
> > the iclog header so that recovery knows where to find the tail of
> > thelog once it has found the head. Normally this is taken from the
> > first item on the AIL - the log item that corresponds to the oldest
> > active item in the log.
> > 
> > The problem is that when the AIL is empty, the tail lsn is dervied
> > from the the l_last_sync_lsn, which is the LSN of the last iclog to
> > be written to the log. In most cases this doesn't happen, because
> > the AIL is rarely empty on an active filesystem. However, when it
> > does, it opens up an interesting case when the transaction being
> > committed to the iclog spans multiple iclogs.
> > 
> > That is, the first iclog is stamped with the l_last_sync_lsn, and IO
> > is issued. Then the next iclog is setup, the changes copied into the
> > iclog (takes some time), and then the l_last_sync_lsn is stamped
> > into the header and IO is issued. This is still the same
> > transaction, so the tail lsn of both iclogs must be the same for log
> > recovery to find the entire transaction to be able to replay it.
> > 
> > The problem arises in that the iclog buffer IO completion updates
> > the l_last_sync_lsn with it's own LSN. Therefore, If the first iclog
> > completes it's IO before the second iclog is filled and has the tail
> > lsn stamped in it, it will stamp the LSN of the first iclog into
> > it's tail lsn field. If the system fails at this point, log recovery
> > will not see a complete transaction, so the transaction will no be
> > replayed.
> > 
> > The fix is simple - the l_last_sync_lsn is updated when a iclog
> > buffer IO completes, and this is incorrect. The l_last_sync_lsn
> > shoul dbe updated when a transaction is completed by a iclog buffer
> > IO. That is, only iclog buffers that have transaction commit
> > callbacks attached to them should update the l_last_sync_lsn. This
> > means that the last_sync_lsn will only move forward when a commit
> > record it written, not in the middle of a large transaction that is
> > rolling through multiple iclog buffers.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> 
> I think this one is appropriate for the 3.7 release.  What say you?

Yes, if you want. It's not a common or high risk problem without the
preceeding changes, though, so I'm not concerned if it stays with
this patchset....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
