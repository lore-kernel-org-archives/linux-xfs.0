Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C1327F66
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 11:28:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D92E9AC005
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 09:28:07 -0800 (PST)
Received: from gum.cmpxchg.org (gum.cmpxchg.org [85.214.110.215]) by
	cuda.sgi.com with ESMTP id 1xU2awfxvWMF6nu5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 09:28:05 -0800 (PST)
Date: Mon, 2 Mar 2015 12:27:50 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150302172750.GA24379@phnom.home.cmpxchg.org>
References: <201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150302151832.GE26334@dhcp22.suse.cz>
	<20150302160537.GA23072@phnom.home.cmpxchg.org>
	<20150302171058.GI26334@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150302171058.GI26334@dhcp22.suse.cz>
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
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Mon, Mar 02, 2015 at 06:10:58PM +0100, Michal Hocko wrote:
> On Mon 02-03-15 11:05:37, Johannes Weiner wrote:
> > On Mon, Mar 02, 2015 at 04:18:32PM +0100, Michal Hocko wrote:
> [...]
> > > Typical busy system won't be very far away from the high watermark
> > > so there would be a reclaim performed during increased watermaks
> > > (aka reservation) and that might lead to visible performance
> > > degradation. This might be acceptable but it also adds a certain level
> > > of unpredictability when performance characteristics might change
> > > suddenly.
> > 
> > There is usually a good deal of clean cache.  As Dave pointed out
> > before, clean cache can be considered re-allocatable from NOFS
> > contexts, and so we'd only have to maintain this invariant:
> > 
> > 	min_wmark + private_reserves < free_pages + clean_cache
> 
> Do I understand you correctly that we do not have to reclaim clean pages
> as per the above invariant?
> 
> If yes, how do you reflect overcommit on the clean_cache from multiple
> requestor (who are doing reservations)?
> My point was that if we keep clean pages on the LRU rather than forcing
> to reclaim them via increased watermarks then it might happen that
> different callers with access to reserves wouldn't get promissed amount
> of reserved memory because clean_cache is basically a shared resource.

The sum of all private reservations has to be accounted globally, we
obviously can't overcommit the available resources in order to solve
problems stemming from overcommiting the available resources.

The page allocator can't hand out free pages and page reclaim can not
reclaim clean cache unless that invariant is met.  They both have to
consider them consumed.  It's the same as pre-allocation, the only
thing we save is having to actually reclaim the pages and take them
off the freelist at reservation time - which is a good optimization
since the filesystem might not actually need them all.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
