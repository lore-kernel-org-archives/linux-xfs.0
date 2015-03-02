Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E3767F63
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 10:58:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 20549304043
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 08:58:28 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id GnEg1AUZYVhiuRDB (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 08:58:25 -0800 (PST)
Date: Mon, 2 Mar 2015 17:58:23 +0100
From: Michal Hocko <mhocko@suse.cz>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150302165823.GH26334@dhcp22.suse.cz>
References: <201502111123.ICD65197.FMLOHSQJFVOtFO@I-love.SAKURA.ne.jp>
	<201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150302151832.GE26334@dhcp22.suse.cz>
	<20150302163913.GL3287@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150302163913.GL3287@thunk.org>
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
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Mon 02-03-15 11:39:13, Theodore Ts'o wrote:
> On Mon, Mar 02, 2015 at 04:18:32PM +0100, Michal Hocko wrote:
> > The idea is sound. But I am pretty sure we will find many corner
> > cases. E.g. what if the mere reservation attempt causes the system
> > to go OOM and trigger the OOM killer?
> 
> Doctor, doctor, it hurts when I do that....
> 
> So don't trigger the OOM killer.  We can let the caller decide whether
> the reservation request should block or return ENOMEM, but the whole
> point of the reservation request idea is that this happens *before*
> we've taken any mutexes, so blocking won't prevent forward progress.

Maybe I wasn't clear. I wasn't concerned about the context which
is doing to reservation. I was more concerned about all the other
allocation requests which might fail now (becasuse they do not have
access to the reserves). So you think that we should simply disable OOM
killer while there is any reservation active? Wouldn't that be even more
fragile when something goes terribly wrong?

> The file system could send down a different flag if we are doing
> writebacks for page cleaning purposes, in which case the reservation
> request would be a "just a heads up, we *will* be needing this much
> memory, but this is not something where we can block or return ENOMEM,
> so please give us the highest priority for using the free reserves".

Sure that thing is clear.
 
> > I think the idea is good! It will just be quite tricky to get there
> > without causing more problems than those being solved. The biggest
> > question mark so far seems to be the reservation size estimation. If
> > it is hard for any caller to know the size beforehand (which would
> > be really close to the actually used size) then the whole complexity
> > in the code sounds like an overkill and asking administrator to tune
> > min_free_kbytes seems a better fit (we would still have to teach the
> > allocator to access reserves when really necessary) because the system
> > would behave more predictably (although some memory would be wasted).
> 
> If we do need to teach the allocator to access reserves when really
> necessary, don't we have that already via GFP_NOIO/GFP_NOFS and
> GFP_NOFAIL?

GFP_NOFAIL doesn't sound like the best fit. Not all NOFAIL callers need
to access reserves - e.g. if they are not blocking anybody from making
progress.

> If the goal is do something more fine-grained,
> unfortunately at least for the short-term we'll need to preserve the
> existing behaviour and issue warnings until the file system starts
> adding GFP_NOFAIL to those memory allocations where previously,
> GFP_NOFS was effectively guaranteeing that failures would almostt
> never happen.

GFP_NOFS not failing is even worse than GFP_KERNEL not failing. Because
the first one has only very limited ways to perform a reclaim. It
basically relies on somebody else to make a progress and that is
definitely a bad model.

> I know at least one place discovered with recent change (and revert)
> where I'll be fixing ext4, but I suspect it won't be the only one,
> especially in the block device drivers.
> 
> 						- Ted

-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
