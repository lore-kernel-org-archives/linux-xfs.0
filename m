Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7CF6A7F51
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 07:49:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F8D6304039
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 05:49:07 -0800 (PST)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id qCuIMKfO65C2N12c (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 21 Feb 2015 05:49:05 -0800 (PST)
Subject: Re: How to handle TIF_MEMDIE stalls?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20150219225217.GY12722@dastard>
	<201502201936.HBH34799.SOLFFFQtHOMOJV@I-love.SAKURA.ne.jp>
	<20150220231511.GH12722@dastard> <20150221032000.GC7922@thunk.org>
	<20150221011907.2d26c979.akpm@linux-foundation.org>
In-Reply-To: <20150221011907.2d26c979.akpm@linux-foundation.org>
Message-Id: <201502212248.DCJ69753.MOJFOtQLFSOVFH@I-love.SAKURA.ne.jp>
Date: Sat, 21 Feb 2015 22:48:49 +0900
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
To: akpm@linux-foundation.org
Cc: tytso@mit.edu, hannes@cmpxchg.org, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, dchinner@redhat.com, rientjes@google.com, linux-ext4@vger.kernel.org, torvalds@linux-foundation.org

Andrew Morton wrote:
> On Fri, 20 Feb 2015 22:20:00 -0500 "Theodore Ts'o" <tytso@mit.edu> wrote:
> 
> > +akpm
> 
> I was hoping not to have to read this thread ;)

Sorry for getting so complicated.

> What I'm not really understanding is why the pre-3.19 implementation
> actually worked.  We've exhausted the free pages, we're not succeeding
> at reclaiming anything, we aren't able to oom-kill anyone.  Yet it
> *does* work - we eventually find that memory and everything proceeds.
> 
> How come?  Where did that memory come from?
> 

Even without __GFP_NOFAIL, GFP_NOFS / GFP_NOIO allocations retried forever
(without invoking the OOM killer) if order <= PAGE_ALLOC_COSTLY_ORDER and
TIF_MEMDIE is not set. Somebody else volunteered that memory while retrying.
This implies silent hang-up forever if nobody volunteers memory.

> And yes, I agree that sites such as xfs's kmem_alloc() should be
> passing __GFP_NOFAIL to tell the page allocator what's going on.  I
> don't think it matters a lot whether kmem_alloc() retains its retry
> loop.  If __GFP_NOFAIL is working correctly then it will never loop
> anyway...

Commit 9879de7373fc ("mm: page_alloc: embed OOM killing naturally into
allocation slowpath") inadvertently changed GFP_NOFS / GFP_NOIO allocations
not to retry unless __GFP_NOFAIL is specified. Therefore, either applying
Johannes's akpm-doesnt-know-why-it-works patch or passing __GFP_NOFAIL
will restore the pre-3.19 behavior (with possibility of silent hang-up).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
