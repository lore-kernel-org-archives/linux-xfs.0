Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 394777F57
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 09:16:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF806304066
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 07:16:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4AAZUkOU2yQ0uvBy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Aug 2014 07:16:13 -0700 (PDT)
Date: Mon, 18 Aug 2014 10:16:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/9] xfs: introduce xfs_buf_submit[_wait]
Message-ID: <20140818141608.GC30093@bfoster.bfoster>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-9-git-send-email-david@fromorbit.com>
	<20140815143558.GE4096@laptop.bfoster>
	<20140815233935.GY26465@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815233935.GY26465@dastard>
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
Cc: xfs@oss.sgi.com

On Sat, Aug 16, 2014 at 09:39:35AM +1000, Dave Chinner wrote:
> On Fri, Aug 15, 2014 at 10:35:58AM -0400, Brian Foster wrote:
> > On Fri, Aug 15, 2014 at 04:39:06PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > There is a lot of cookie-cutter code that looks like:
> > > 
> > > 	if (shutdown)
> > > 		handle buffer error
> > > 	xfs_buf_iorequest(bp)
> > > 	error = xfs_buf_iowait(bp)
> > > 	if (error)
> > > 		handle buffer error
> > > 
> > > spread through XFS. There's significant complexity now in
> > > xfs_buf_iorequest() to specifically handle this sort of synchronous
> > > IO pattern, but there's all sorts of nasty surprises in different
> > > error handling code dependent on who owns the buffer references and
> > > the locks.
> > > 
> > > Pull this pattern into a single helper, where we can hide all the
> > > synchronous IO warts and hence make the error handling for all the
> > > callers much saner. This removes the need for a special extra
> > > reference to protect IO completion processing, as we can now hold a
> > > single reference across dispatch and waiting, simplifying the sync
> > > IO smeantics and error handling.
> > > 
> > > In doing this, also rename xfs_buf_iorequest to xfs_buf_submit and
> > > make it explicitly handle on asynchronous IO. This forces all users
> > > to be switched specifically to one interface or the other and
> > > removes any ambiguity between how the interfaces are to be used. It
> > > also means that xfs_buf_iowait() goes away.
> > > 
> > > For the special case of delwri buffer submission and waiting, we
> > > don't need to issue IO synchronously at all. The second pass to cal
> > > xfs_buf_iowait() can now just block on xfs_buf_lock() - the buffer
> > > will be unlocked when the async IO is complete. This formalises a
> > > sane the method of waiting for async IO - take an extra reference,
> > > submit the IO, call xfs_buf_lock() when you want to wait for IO
> > > completion. i.e.:
> > > 
> > > 	bp = xfs_buf_find();
> > > 	xfs_buf_hold(bp);
> > > 	bp->b_flags |= XBF_ASYNC;
> > > 	xfs_buf_iosubmit(bp);
> > > 	xfs_buf_lock(bp)
> > > 	error = bp->b_error;
> > > 	....
> > > 	xfs_buf_relse(bp);
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > On a quick look at submit_wait this looks pretty good. It actually
> > implements the general model I've been looking for for sync I/O. E.g.,
> > send the I/O, wait on synchronization, then check for errors. In other
> > words, a pure synchronous mechanism. The refactoring and new helpers and
> > whatnot are additional bonus and abstract it nicely.
> > 
> > I still have to take a closer look to review the actual code, but since
> > we go and remove the additional sync I/O reference counting business,
> > why do we even add that stuff early on? Can't we get from where the
> > current code is to here in a more direct manner?
> 
> Simply because we need a fix that we can backport, and that fix is a
> simple addition that does not significantly affect the rest of the
> patchset...
> 

Ok, it wasn't clear that multiple fixes was the intent. I guess it's
unforunate this won't see much tot testing, but we can find other ways
to make sure it's tested. ;)

Brian

> Cheers,
> 
> Dave.
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
