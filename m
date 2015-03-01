Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7AF077F67
	for <xfs@oss.sgi.com>; Sun,  1 Mar 2015 07:43:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EF296AC001
	for <xfs@oss.sgi.com>; Sun,  1 Mar 2015 05:43:34 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id IleT6Swo9YnUCzeZ (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Mar 2015 05:43:32 -0800 (PST)
Date: Sun, 1 Mar 2015 08:43:22 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150301134322.GA3287@thunk.org>
References: <201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150228162943.GA17989@phnom.home.cmpxchg.org>
	<20150228164158.GE5404@thunk.org>
	<20150228221558.GA23028@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150228221558.GA23028@phnom.home.cmpxchg.org>
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
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Sat, Feb 28, 2015 at 05:15:58PM -0500, Johannes Weiner wrote:
> Overestimating should be fine, the result would a bit of false memory
> pressure.  But underestimating and looping can't be an option or the
> original lockups will still be there.  We need to guarantee forward
> progress or the problem is somewhat mitigated at best - only now with
> quite a bit more complexity in the allocator and the filesystems.

We've lived with looping as it is and in practice it's actually worked
well.  I can only speak for ext4, but I do a lot of testing under very
high memory pressure situations, and it is used in *production* under
very high stress situations --- and the only time we'e run into
trouble is when the looping behaviour somehow got accidentally
*removed*.

There have been MM experts who have been worrying about this situation
for a very long time, but honestly, it seems to be much more of a
theoretical than actual concern.  So if you don't want to get
hints/estimates about how much memory the file system is about to use,
when the file system is willing to wait or even potentially return
ENOMEM (although I suspect starting to return ENOMEM where most user
space application don't expect it will cause more problems), I'm
personally happy to just use GFP_NOFAIL everywhere --- or to hard code
my own infinite loops if the MM developers want to take GFP_NOFAIL
away.  Because in my experience, looping simply hasn't been as awful
as some folks on this thread have made it out to be.

So if you don't like the complexity because the perfect is the enemy
of the good, we can just drop this and the file systems can simply
continue to loop around their memory allocation calls...  or if that
fails we can start adding subsystem specific mempools, which would be
even more wasteful of memory and probably at least as complicated.

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
