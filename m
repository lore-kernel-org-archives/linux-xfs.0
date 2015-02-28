Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4A7B27F4E
	for <xfs@oss.sgi.com>; Sat, 28 Feb 2015 16:16:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 395A2304032
	for <xfs@oss.sgi.com>; Sat, 28 Feb 2015 14:16:12 -0800 (PST)
Received: from gum.cmpxchg.org (gum.cmpxchg.org [85.214.110.215]) by
	cuda.sgi.com with ESMTP id bdfCzsFBfMDc0P6t (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Feb 2015 14:16:11 -0800 (PST)
Date: Sat, 28 Feb 2015 17:15:58 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150228221558.GA23028@phnom.home.cmpxchg.org>
References: <201502111123.ICD65197.FMLOHSQJFVOtFO@I-love.SAKURA.ne.jp>
	<201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150228162943.GA17989@phnom.home.cmpxchg.org>
	<20150228164158.GE5404@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150228164158.GE5404@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Sat, Feb 28, 2015 at 11:41:58AM -0500, Theodore Ts'o wrote:
> On Sat, Feb 28, 2015 at 11:29:43AM -0500, Johannes Weiner wrote:
> > 
> > I'm trying to figure out if the current nofail allocators can get
> > their memory needs figured out beforehand.  And reliably so - what
> > good are estimates that are right 90% of the time, when failing the
> > allocation means corrupting user data?  What is the contingency plan?
> 
> In the ideal world, we can figure out the exact memory needs
> beforehand.  But we live in an imperfect world, and given that block
> devices *also* need memory, the answer is "of course not".  We can't
> be perfect.  But we can least give some kind of hint, and we can offer
> to wait before we get into a situation where we need to loop in
> GFP_NOWAIT --- which is the contingency/fallback plan.

Overestimating should be fine, the result would a bit of false memory
pressure.  But underestimating and looping can't be an option or the
original lockups will still be there.  We need to guarantee forward
progress or the problem is somewhat mitigated at best - only now with
quite a bit more complexity in the allocator and the filesystems.

The block code would have to be looked at separately, but doesn't it
already use mempools etc. to guarantee progress?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
