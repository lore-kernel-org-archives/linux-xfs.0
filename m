Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D69527F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 00:13:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A9CA6304039
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 22:13:22 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SqYDAi3k7ZVShkui for <xfs@oss.sgi.com>;
	Mon, 21 Sep 2015 22:13:19 -0700 (PDT)
Date: Tue, 22 Sep 2015 15:12:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: Print comm name and pid when open-coded
	__GFP_NOFAIL allocation stucks
Message-ID: <20150922051253.GB3902@dastard>
References: <20150920231858.GY3902@dastard>
	<1442798637-5941-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1442798637-5941-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
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
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, xfs@oss.sgi.com

On Mon, Sep 21, 2015 at 10:23:57AM +0900, Tetsuo Handa wrote:
> This patch adds comm name and pid to warning messages printed by
> kmem_alloc(), kmem_zone_alloc() and xfs_buf_allocate_memory().
> This will help telling which memory allocations (e.g. kernel worker
> threads, OOM victim tasks, neither) are stalling because these functions
> are passing __GFP_NOWARN which suppresses not only backtrace but comm name
> and pid.
> 
>   [  135.568662] Out of memory: Kill process 9593 (a.out) score 998 or sacrifice child
>   [  135.570195] Killed process 9593 (a.out) total-vm:4700kB, anon-rss:488kB, file-rss:0kB
>   [  137.473691] XFS: kworker/u16:29(383) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
>   [  137.497662] XFS: a.out(8944) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
>   [  137.598219] XFS: a.out(9658) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
>   [  139.494529] XFS: kworker/u16:29(383) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
>   [  139.517196] XFS: a.out(8944) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
>   [  139.616396] XFS: a.out(9658) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
>   [  141.512753] XFS: kworker/u16:29(383) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
>   [  141.531421] XFS: a.out(8944) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
>   [  141.633574] XFS: a.out(9658) possible memory allocation deadlock in xfs_buf_allocate_memory (mode:0x1250)
> 
> (Strictly speaking, we want task_lock()/task_unlock() when reading comm name.)
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Michal Hocko <mhocko@suse.com>
> ---
>  fs/xfs/kmem.c    | 10 ++++++----
>  fs/xfs/xfs_buf.c |  3 ++-
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index a7a3a63..735095a 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -55,8 +55,9 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
>  			return ptr;
>  		if (!(++retries % 100))
>  			xfs_err(NULL,
> -		"possible memory allocation deadlock in %s (mode:0x%x)",
> -					__func__, lflags);
> +				"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
> +				current->comm, current->pid,
> +				__func__, lflags);

<=80 columns, please.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
