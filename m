Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A41F77F37
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 16:53:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4F52AAC001
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 14:53:20 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	yqWxvy17o3xBBVxE for <xfs@oss.sgi.com>;
	Mon, 21 Sep 2015 14:53:17 -0700 (PDT)
Date: Tue, 22 Sep 2015 07:52:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm, vmscan: Warn about possible deadlock at
	shirink_inactive_list
Message-ID: <20150921215241.GA19114@dastard>
References: <1442833794-23117-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1442833794-23117-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
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
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-mm@kvack.org, xfs@oss.sgi.com

On Mon, Sep 21, 2015 at 08:09:54PM +0900, Tetsuo Handa wrote:
> This is a difficult-to-trigger silent hang up bug.
> 
> The kswapd is allowed to bypass too_many_isolated() check in
> shrink_inactive_list(). But the kswapd can be blocked by locks in
> shrink_page_list() in shrink_inactive_list(). If the task which is
> blocking the kswapd is trying to allocate memory with the locks held,
> it forms memory reclaim deadlock.

It's a known problem in XFS and I'm currently working on patches to
fix it by hoisting the memory allocations outside of the CIL context
lock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
