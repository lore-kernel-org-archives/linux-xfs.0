Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A57737F63
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 01:30:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C5AC30407F
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 23:30:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	w4FHGUXSSyuUZDKF for <xfs@oss.sgi.com>;
	Mon, 19 May 2014 23:30:39 -0700 (PDT)
Date: Tue, 20 May 2014 16:30:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
Message-ID: <20140520063024.GH18954@dastard>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
	<20140520004449.GE18954@dastard>
	<20140519225915.3370328d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140519225915.3370328d.akpm@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: riel@redhat.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com

On Mon, May 19, 2014 at 10:59:15PM -0700, Andrew Morton wrote:
> On Tue, 20 May 2014 10:44:49 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > @@ -258,14 +258,23 @@ xfs_bmapi_allocate_worker(
> >  	struct xfs_bmalloca	*args = container_of(work,
> >  						struct xfs_bmalloca, work);
> >  	unsigned long		pflags;
> > +	unsigned long		new_pflags = PF_FSTRANS;
> >  
> > -	/* we are in a transaction context here */
> > -	current_set_flags_nested(&pflags, PF_FSTRANS);
> > +	/*
> > +	 * we are in a transaction context here, but may also be doing work
> > +	 * in kswapd context, and hence we may need to inherit that state
> > +	 * temporarily to ensure that we don't block waiting for memory reclaim
> > +	 * in any way.
> > +	 */
> > +	if (args->kswapd)
> > +		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
> 
> So current_is_kswapd() returns true for a thread which is not kswapd. 
> That's a bit smelly.
> 
> Should this thread really be incrementing KSWAPD_INODESTEAL instead of
> PGINODESTEAL, for example?  current_is_kswapd() does a range of things,
> only one(?) of which you actually want.

It's doing work on behalf of kswapd under kswapd constraints, so it
should both behave and be accounted as if kswapd was executing the
work directly.

> It would be cleaner to create a new PF_ flag to select just that
> behavior.  That's a better model than telling the world "I am magic and
> special".

However, it is magic and special because of who the work needs to be
done for.

> But we're awfully close to running out of PF_ space and I don't know if
> this ugly justifies consuming a flag.

I don't really care enough argue over what mechanism should be used.
I'll push this patch through the XFS tree, and when a new flag or
generic mechanism for pushing task contexts to kworker threads
is provided, I'll change the XFS code to use that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
