Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 148CE7F62
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 10:39:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87E50AC002
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 08:39:24 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 4EZCtpJmWAtiDwbC (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 08:39:21 -0800 (PST)
Date: Mon, 2 Mar 2015 11:39:13 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150302163913.GL3287@thunk.org>
References: <20150210151934.GA11212@phnom.home.cmpxchg.org>
	<201502111123.ICD65197.FMLOHSQJFVOtFO@I-love.SAKURA.ne.jp>
	<201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150302151832.GE26334@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150302151832.GE26334@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Mon, Mar 02, 2015 at 04:18:32PM +0100, Michal Hocko wrote:
> The idea is sound. But I am pretty sure we will find many corner
> cases. E.g. what if the mere reservation attempt causes the system
> to go OOM and trigger the OOM killer?

Doctor, doctor, it hurts when I do that....

So don't trigger the OOM killer.  We can let the caller decide
whether the reservation request should block or return ENOMEM, but the
whole point of the reservation request idea is that this happens
*before* we've taken any mutexes, so blocking won't prevent forward
progress.

The file system could send down a different flag if we are doing
writebacks for page cleaning purposes, in which case the reservation
request would be a "just a heads up, we *will* be needing this much
memory, but this is not something where we can block or return ENOMEM,
so please give us the highest priority for using the free reserves".

> I think the idea is good! It will just be quite tricky to get there
> without causing more problems than those being solved. The biggest
> question mark so far seems to be the reservation size estimation. If
> it is hard for any caller to know the size beforehand (which would
> be really close to the actually used size) then the whole complexity
> in the code sounds like an overkill and asking administrator to tune
> min_free_kbytes seems a better fit (we would still have to teach the
> allocator to access reserves when really necessary) because the system
> would behave more predictably (although some memory would be wasted).

If we do need to teach the allocator to access reserves when really
necessary, don't we have that already via GFP_NOIO/GFP_NOFS and
GFP_NOFAIL?  If the goal is do something more fine-grained,
unfortunately at least for the short-term we'll need to preserve the
existing behaviour and issue warnings until the file system starts
adding GFP_NOFAIL to those memory allocations where previously,
GFP_NOFS was effectively guaranteeing that failures would almostt
never happen.

I know at least one place discovered with recent change (and revert)
where I'll be fixing ext4, but I suspect it won't be the only one,
especially in the block device drivers.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
