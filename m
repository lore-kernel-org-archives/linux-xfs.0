Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Aug 2007 00:11:54 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7V7Bn4p032118
	for <xfs@oss.sgi.com>; Fri, 31 Aug 2007 00:11:51 -0700
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <46D79C62.1010304@sandeen.net>
References: <46D79C62.1010304@sandeen.net>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 08:39:49 +0200
Message-Id: <1188542389.6112.44.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, Dave Chinner <dgc@sgi.com>, Ingo Molnar <mingo@elte.hu>

On Thu, 2007-08-30 at 23:43 -0500, Eric Sandeen wrote:
> The xfs filesystem can exceed the current lockdep 
> MAX_LOCK_DEPTH, because when deleting an entire cluster of inodes,
> they all get locked in xfs_ifree_cluster().  The normal cluster
> size is 8192 bytes, and with the default (and minimum) inode size 
> of 256 bytes, that's up to 32 inodes that get locked.  Throw in a 
> few other locks along the way, and 40 seems enough to get me through
> all the tests in the xfsqa suite on 4k blocks.  (block sizes
> above 8K will still exceed this though, I think)

As 40 will still not be enough for people with larger block sizes, this
does not seems like a solid solution. Could XFS possibly batch in
smaller (fixed sized) chunks, or does that have significant down sides?

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Index: linux-2.6.23-rc3/include/linux/sched.h
> ===================================================================
> --- linux-2.6.23-rc3.orig/include/linux/sched.h
> +++ linux-2.6.23-rc3/include/linux/sched.h
> @@ -1125,7 +1125,7 @@ struct task_struct {
>  	int softirq_context;
>  #endif
>  #ifdef CONFIG_LOCKDEP
> -# define MAX_LOCK_DEPTH 30UL
> +# define MAX_LOCK_DEPTH 40UL
>  	u64 curr_chain_key;
>  	int lockdep_depth;
>  	struct held_lock held_locks[MAX_LOCK_DEPTH];
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
