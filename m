Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4T9ltmQ021026 for <xfs@oss.sgi.com>; Sat, 29 May 2010 04:47:56 -0500
Date: Sat, 29 May 2010 05:50:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: improve xfs_isilocked
Message-ID: <20100529095019.GA18859@infradead.org>
References: <20100527190533.GB16102@infradead.org>
	<1275075653.2302.38.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1275075653.2302.38.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, May 28, 2010 at 02:40:53PM -0500, Alex Elder wrote:
> On Thu, 2010-05-27 at 15:05 -0400, Christoph Hellwig wrote:
> > Use rwsem_is_locked to make the assertations for shared locks work.
> 
> So you're changing it so it answers "yes it's locked"
> even it it's only a read lock now, right?

If XFS_ILOCK_SHARED/XFS_IOLOCK_SHARED are in the flags we'll answer yes
it's locked for a read lock now, indeed.

> Previously it was basically (once each for ilock and
> iolock):  "If the exclusive flag is set, but there is no
> writer, then it is not locked; otherwise it is."

Yes.

> Now it's "If the exclusive flag is set, but no writer,
> it's not locked.  Otherwise if the shared flag is
> set it's locked if rwsem_is_locked() says we are.
> Otherwise (ASSERT(0) and) it is not locked."

Not exactly.  Now it's:

 - if excl is set but shared isn't return true if mr_writer is
   set, else false
 - if shared is set either alone or together with excl return
   if it is locked in any way (rwsem_is_locked).

Note that xfs_isilocked can be called like:

	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));

which means that either excl or shared is fine.

 - if either one or both of excl and shared are set and it's 

> That last part is wrong I think.  It should be OK to
> call xfs_isilocked() with neither flag set, in which
> case the result should be 0.

We can argue about removing the assert, but we currently don't
and should't call xfs_isilocked wit ha 0 argument - it's rather
pointless to do so.

> And if the exclusive
> flag is set, and there *is* a writer, it *is* locked,
> so it should return 1.

We do that right now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
