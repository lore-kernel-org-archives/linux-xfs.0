Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 713277F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 15:33:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 007AFAC002
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 13:33:55 -0800 (PST)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com
	[209.85.213.182]) by cuda.sgi.com with ESMTP id
	DGIx1aczBsUSRkas (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 13:33:54 -0800 (PST)
Received: by mail-ig0-f182.google.com with SMTP id h15so21946059igd.3
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 13:33:54 -0800 (PST)
Date: Mon, 23 Feb 2015 13:33:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
Subject: Re: How to handle TIF_MEMDIE stalls?
In-Reply-To: <20150222002058.GB25079@phnom.home.cmpxchg.org>
Message-ID: <alpine.DEB.2.10.1502231332550.21127@chino.kir.corp.google.com>
References: <201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<201502201936.HBH34799.SOLFFFQtHOMOJV@I-love.SAKURA.ne.jp>
	<20150220231511.GH12722@dastard> <20150221032000.GC7922@thunk.org>
	<20150221011907.2d26c979.akpm@linux-foundation.org>
	<20150222002058.GB25079@phnom.home.cmpxchg.org>
MIME-Version: 1.0
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
Cc: Theodore Ts'o <tytso@mit.edu>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, dchinner@redhat.com, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, torvalds@linux-foundation.org

On Sat, 21 Feb 2015, Johannes Weiner wrote:

> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> mm: page_alloc: revert inadvertent !__GFP_FS retry behavior change
> 
> Historically, !__GFP_FS allocations were not allowed to invoke the OOM
> killer once reclaim had failed, but nevertheless kept looping in the
> allocator.  9879de7373fc ("mm: page_alloc: embed OOM killing naturally
> into allocation slowpath"), which should have been a simple cleanup
> patch, accidentally changed the behavior to aborting the allocation at
> that point.  This creates problems with filesystem callers (?) that
> currently rely on the allocator waiting for other tasks to intervene.
> 
> Revert the behavior as it shouldn't have been changed as part of a
> cleanup patch.
> 
> Fixes: 9879de7373fc ("mm: page_alloc: embed OOM killing naturally into allocation slowpath")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Cc: stable@vger.kernel.org [3.19]
Acked-by: David Rientjes <rientjes@google.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
