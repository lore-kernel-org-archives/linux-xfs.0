Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1232D7F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 17:27:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D515B8F8033
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 15:27:23 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	6RsiGrT9ga27VDhk for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 15:27:21 -0700 (PDT)
Date: Tue, 25 Jun 2013 08:27:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 59/60] xfs: Add xfs_log_rlimit.c
Message-ID: <20130624222708.GV29338@dastard>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-60-git-send-email-david@fromorbit.com>
	<51C8B984.3090400@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51C8B984.3090400@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 24, 2013 at 04:26:28PM -0500, Mark Tinguely wrote:
> On 06/18/13 23:51, Dave Chinner wrote:
> >+	 * 2) If the lsunit option is specified, a transaction requires 2 LSU
> >+	 *    for the reservation because there are two log writes that can
> >+	 *    require padding - the transaction data and the commit record which
> >+	 *    are written separately and both can require padding to the LSU.
> >+	 *    Consider that we can have an active CIL reservation holding 2*LSU,
> >+	 *    but the CIL is not over a push threshold, in this case, if we
> >+	 *    don't have enough log space for at one new transaction, which
> >+	 *    includes another 2*LSU in the reservation, we will run into dead
> >+	 *    loop situation in log space grant procedure. i.e.
> >+	 *    xlog_grant_head_wait().
> >+	 *
> >+	 *    Hence the log size needs to be able to contain two maximally sized
> >+	 *    and padded transactions, which is (2 * (2 * LSU + maxlres)).
> >+	 *
> 
> Any thoughts on how we can separate the 2 * log stripe unit from the
> reservation.

You can't. The reservation, by definition, is the worse case log
space usage for the transaction. Therefore, it has to take into
account the LSU padding that may be necessary if this transaction is
committed by itself to the log (e.g. wsync operation)

> The added extended attribute calls for parent inode pointers
> (especially xfs_rename() where it could add up to one and remove up
> to two attributes) is causing a huge multiplication cnt for
> reservation.

So you are adding a attribute reservations to
create/mkdir/rename/link transaction reservations? That doesn't seem
like a good idea, and it's contrary to the direction we want to head
with the transaction subsystem.  Can you post your patches so we
some some context to the question you are asking?

FWIW, the intended method of linking multiple independent
transactions together for parent pointers into an atomic commit is
this:

http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Atomic_Multi-Transaction_Operations

While the text is somewhat out of date (talks about rolling
transactions and being able to replace them), it predated the
delayed logging implementation and hence doesn't take into account
the obvious, simple extension that can be made to the CIL to
implement this. i.e.  being able to hold the current CIL context
open for a number of transactions to take place before releasing it
again.

The point of doing this is still relevant, however:

"This may also allow us to split some of the large compound
transactions into smaller, more self contained transactions. This
would reduce reservation pressure on log space in the common case
where all the corner cases in the transactions are not taken."

IOWs, rather than building new, large "aggregation" transactions, we
should be adding infrastructure to the CIL to allow atomic
transaction aggregation techniques to be used and then just using
the existing transaction infrastructure to implement operations such
as "create with ACL"....

FYI, we need this for all the operations that add attributes at
create time, such as default ACLs and DMAPI/DMF attributes....

> Those multiplications would be killers on 256KiB log
> stripe units.

Numbers, please?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
