Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76BB17F37
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 17:18:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1217BAC006
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 15:18:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rKzjirDAYG9Fy5SJ for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 15:18:42 -0700 (PDT)
Date: Thu, 27 Jun 2013 08:18:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 59/60] xfs: Add xfs_log_rlimit.c
Message-ID: <20130626221837.GA28426@dastard>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-60-git-send-email-david@fromorbit.com>
	<51C8B984.3090400@sgi.com> <20130624222708.GV29338@dastard>
	<51C9A3EF.70005@sgi.com> <20130626040518.GG29376@dastard>
	<51CAF11F.4050905@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51CAF11F.4050905@sgi.com>
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

On Wed, Jun 26, 2013 at 08:48:15AM -0500, Mark Tinguely wrote:
> On 06/25/13 23:05, Dave Chinner wrote:
> >On Tue, Jun 25, 2013 at 09:06:39AM -0500, Mark Tinguely wrote:
> >>On 06/24/13 17:27, Dave Chinner wrote:
> >>>On Mon, Jun 24, 2013 at 04:26:28PM -0500, Mark Tinguely wrote:
> >>>>On 06/18/13 23:51, Dave Chinner wrote:
> >>>>>+	 * 2) If the lsunit option is specified, a transaction requires 2 LSU
> >>>>>+	 *    for the reservation because there are two log writes that can
> >>>>>+	 *    require padding - the transaction data and the commit record which
> >>>>>+	 *    are written separately and both can require padding to the LSU.
> >>>>>+	 *    Consider that we can have an active CIL reservation holding 2*LSU,
> >>>>>+	 *    but the CIL is not over a push threshold, in this case, if we
> >>>>>+	 *    don't have enough log space for at one new transaction, which
> >>>>>+	 *    includes another 2*LSU in the reservation, we will run into dead
> >>>>>+	 *    loop situation in log space grant procedure. i.e.
> >>>>>+	 *    xlog_grant_head_wait().
> >>>>>+	 *
> >>>>>+	 *    Hence the log size needs to be able to contain two maximally sized
> >>>>>+	 *    and padded transactions, which is (2 * (2 * LSU + maxlres)).
> >>>>>+	 *
> >>>>
> >>>>Any thoughts on how we can separate the 2 * log stripe unit from the
> >>>>reservation.
> >>>
> >>>You can't. The reservation, by definition, is the worse case log
> >>>space usage for the transaction. Therefore, it has to take into
> >>>account the LSU padding that may be necessary if this transaction is
> >>>committed by itself to the log (e.g. wsync operation)
> >>
> >>I am thinking we should separate the extra 2*LSU allocated space
> >>from the individual pieces of the transaction
> >
> >Why? How are you going to prevent log space deadlocks if we don't
> >reserve that space for each individual transaction in a permanent
> >transaction reservation?
> 
> Allocate 2 per transaction, not one per segment of a transaction.
> It may be a wash for 2 or 3 segments per transaction, but would help
> if there are 10 segments per transaction.

I'll repeat: The unit reservation used for every commit in a
permanent transaction *requires* LSU padding because we don't know
ahead of time when it will be required.  We can't avoid that worst
case behaviour - violating design constraints of the log subsystem
because the worst case reservations get large is simply not an
option....

> >>>IOWs, rather than building new, large "aggregation" transactions, we
> >>>should be adding infrastructure to the CIL to allow atomic
> >>>transaction aggregation techniques to be used and then just using
> >>>the existing transaction infrastructure to implement operations such
> >>>as "create with ACL"....
> >>
> >>I will have to think on this. I don't see how the allocation of log
> >>space for a new transaction while holding locks is a good thing.
> >
> >Who said anything about requiring new locks? :)
> 
> I meant we have to hold the inode locks between the directory code
> the the attribute code. If we do not, then the attributes quickly
> become out of line with the directory status.

But why would we need to hold locks atomically across all operations
there?  The inodes are already locked at that VFS level via i_mutex,
so nobody is going to see the newly created/modified inodes in the
namespace until we complete the whole create/rename operation, so
the only thing we realy need to be concerned about is whether the
operations can be recovered in whole or in part.....

> >>Even if you are creative, the multipliers add up quickly.
> >>xfs_rename will do the directory ops. possibly a attibset and up to
> >>2 attrrm and we have to hold the src and target inodes locks over
> >>all the operations.
> >
> >We don't have to hold them locked across the entire operation
> >because the VFS is holding them locked so nothing else can do a
> >namespace operation which we are modifying them.
> 
> I find without holding the lock over both dir and attrib routines
> that remove occasionally can't find parent pointer attribute entry.
> I suspect remove racing in rename.

Racing with what? The VFS prevents create/link/unlink/rename races
via the i_mutex locking on the parent directories and the
vfs_rename_lock....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
