Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1DEE07F58
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 03:27:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9235FAC003
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 01:27:25 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 6HVZCZwn4A92CP2D (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 01:27:23 -0800 (PST)
Date: Fri, 20 Feb 2015 10:27:21 +0100
From: Michal Hocko <mhocko@suse.cz>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150220092721.GE21248@dhcp22.suse.cz>
References: <201502111123.ICD65197.FMLOHSQJFVOtFO@I-love.SAKURA.ne.jp>
	<201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150218082502.GA4478@dhcp22.suse.cz>
	<20150218104859.GM12722@dastard>
	<20150218121602.GC4478@dhcp22.suse.cz>
	<20150218213118.GN12722@dastard>
	<20150219094020.GE28427@dhcp22.suse.cz>
	<20150219220355.GX12722@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150219220355.GX12722@dastard>
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
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Fri 20-02-15 09:03:55, Dave Chinner wrote:
[...]
> Converting the code to use GFP_NOFAIL takes us in exactly the
> opposite direction to our current line of development w.r.t. to
> filesystem error handling.

Fair enough. If there are plans to have a failure policy rather than
GFP_NOFAIL like behavior then I have, of course, no objections. Quite
opposite. This is exactly what I would like to see. GFP_NOFAIL should be
rarely used, really.

The whole point of this discussion, and I am sorry if I didn't make it
clear, is that _if_ there is really a GFP_NOFAIL requirement hidden
from the allocator then it should be changed to use GFP_NOFAIL so that
allocator knows about this requirement.

> > The reason I care about GFP_NOFAIL is that there are apparently code
> > paths which do not tell allocator they are basically GFP_NOFAIL without
> > any fallback. This leads to two main problems 1) we do not have a good
> > overview how many code paths have such a strong requirements and so
> > cannot estimate e.g. how big memory reserves should be and
> 
> Right, when GFP_NOFAIL got deprecated we lost the ability to document
> such behaviour and find it easily. People just put retry loops in
> instead of using GFP_NOFAIL. Good luck finding them all :/

That will be PITA, all right, but I guess the deprecation was a mistake
and we should stop this tendency.

> > 2) allocator
> > cannot help those paths (e.g. by giving them access to reserves to break
> > out of the livelock).
> 
> Allocator should not help. Global reserves are unreliable - make the
> allocation context reserve the amount it needs before it enters the
> context where it can't back out....

Sure pre-allocation is preferable. But once somebody asks for GFP_NOFAIL
then it is too late and the allocator only has memory reclaim and
potentially reserves.

[...]
-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
