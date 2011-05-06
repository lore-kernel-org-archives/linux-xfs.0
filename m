Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p461jjIj170816 for <xfs@oss.sgi.com>; Thu, 5 May 2011 20:45:46 -0500
Date: Fri, 6 May 2011 11:49:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110506014906.GF26837@dastard>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
	<20110504005736.GA2958@cucamonga.audible.transient.net>
	<20110505002126.GA26797@dastard> <20110505022613.GA26837@dastard>
	<20110505122117.GB26837@dastard>
	<20110505123959.GA21098@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110505123959.GA21098@infradead.org>
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
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Bruno Pr?mont <bonbons@linux-vserver.org>, Alex Elder <aelder@sgi.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Thu, May 05, 2011 at 08:39:59AM -0400, Christoph Hellwig wrote:
> > The third problem is that updating the push target is not safe on 32
> > bit machines. We cannot copy a 64 bit LSN without the possibility of
> > corrupting the result when racing with another updating thread. We
> > have function to do this update safely without needing to care about
> > 32/64 bit issues - xfs_trans_ail_copy_lsn() - so use that when
> > updating the AIL push target.
> 
> But reading xa_target without xa_lock isn't safe on 32-bit either, is it?

Not sure - I think it depends on the platform. I don't think we
protect LSN reads in any specific way on 32 bit platforms.

In this case, I don't think it matters so much on read, because if
we get a race with a write that mixes upper/lower words of the
target we will eventually hit the stop condition and we won't get a
match. That will trigger the requeue code and we'll start the push
again.

The problem with getting such a race on the target write is that we
could get a cycle/block pair that is beyond the current head of the
log and we'd never be able to push the AIL again as all push
thresholds are truncated to the current head LSN on disk...

> For the first read it can trivially be moved into the critical
> section a few lines below, and the second one should probably use
> XFS_LSN_CMP.
> 
> > @@ -482,19 +481,24 @@ xfs_ail_worker(
> >  	/* assume we have more work to do in a short while */
> >  	tout = 10;
> >  	if (!count) {
> > +out_done:
> 
> Jumping into conditionals is really ugly.  By initializing count a bit
> earlier you can just jump in front of the if/else clauses.  And while
> you're there maybe moving the tout = 10; into an else clause would
> also make the code more readable.
> an uninitialied used of tout.

Ok, I'll rework that.

> > +		if (ailp->xa_target == target ||
> > +		    (test_and_set_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags)))
> 
> no need for braces around the test_and_set_bit call.

*nod*. Left over from developing the fix...

I'll split all these and post them to the xfs-list for review...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
