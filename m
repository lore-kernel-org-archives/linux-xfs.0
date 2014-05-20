Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 672D37F5E
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 01:03:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 377B78F8049
	for <xfs@oss.sgi.com>; Mon, 19 May 2014 23:03:33 -0700 (PDT)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	mFFTSjdbaUuGhULc for <xfs@oss.sgi.com>;
	Mon, 19 May 2014 23:03:32 -0700 (PDT)
Date: Mon, 19 May 2014 23:03:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
Message-Id: <20140519230311.583f762c.akpm@linux-foundation.org>
In-Reply-To: <20140519225915.3370328d.akpm@linux-foundation.org>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
	<20140520004449.GE18954@dastard>
	<20140519225915.3370328d.akpm@linux-foundation.org>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, 19 May 2014 22:59:15 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

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
> 
> It would be cleaner to create a new PF_ flag to select just that
> behavior.  That's a better model than telling the world "I am magic and
> special".

Or a new __GFP_FLAG.

> But we're awfully close to running out of PF_ space and I don't know if
> this ugly justifies consuming a flag.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
