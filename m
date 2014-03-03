Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 032167F69
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 17:15:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E23738F804C
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 15:15:03 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	JZMghnmzGOY9Mz6z for <xfs@oss.sgi.com>;
	Mon, 03 Mar 2014 15:15:02 -0800 (PST)
Date: Tue, 4 Mar 2014 10:10:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: fix array overrun in do_inode_prefetch
Message-ID: <20140303231035.GP13647@dastard>
References: <5314D476.7030503@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5314D476.7030503@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 03, 2014 at 01:13:58PM -0600, Eric Sandeen wrote:
> Coverity spotted this:
> 
> do_inode_prefetch() does a while loop, creating queues:
> 
>         for (i = 0; i < thread_count; i++) {
> 		...
> 		create_work_queue(&queues[i], mp, 1);
> 		...
> 	}
> 
> and then does this to wait for them all to complete:
> 
> 	for (; i >= 0; i--)
>  		destroy_work_queue(&queues[i]);
> 
> But we leave the first for loop with (i == thread_coun)t, and
> the second one will try to index queues[] one past the end.

ugh. My fault. Fix looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
