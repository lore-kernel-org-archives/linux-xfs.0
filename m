Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13D3C7F4E
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 00:49:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF85F8F8049
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 22:49:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	oortFk9al9iZPpM2 for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 22:49:48 -0700 (PDT)
Date: Wed, 16 Apr 2014 15:49:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/19] MM: set PF_FSTRANS while allocating per-cpu memory
	to avoid deadlock.
Message-ID: <20140416054942.GD15995@dastard>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040336.10604.67456.stgit@notabene.brown>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416040336.10604.67456.stgit@notabene.brown>
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
To: NeilBrown <neilb@suse.de>
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 02:03:36PM +1000, NeilBrown wrote:
> lockdep reports a locking chain
> 
>   sk_lock-AF_INET --> rtnl_mutex --> pcpu_alloc_mutex
> 
> As sk_lock may be needed to reclaim memory, allowing that
> reclaim while pcu_alloc_mutex is held can lead to deadlock.
> So set PF_FSTRANS while it is help to avoid the FS reclaim.
> 
> pcpu_alloc_mutex can be taken when rtnl_mutex is held:
> 
>     [<ffffffff8117f979>] pcpu_alloc+0x49/0x960
>     [<ffffffff8118029b>] __alloc_percpu+0xb/0x10
>     [<ffffffff8193b9f7>] loopback_dev_init+0x17/0x60
>     [<ffffffff81aaf30c>] register_netdevice+0xec/0x550
>     [<ffffffff81aaf785>] register_netdev+0x15/0x30
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

This looks like a workaround to avoid passing a gfp mask around to
describe the context in which the allocation is taking place.
Whether or not that's the right solution, I can't say, but spreading
this "we can turn off all reclaim of filesystem objects" mechanism
all around the kernel doesn't sit well with me...

And, again, PF_FSTRANS looks plainly wrong in this code - it sure
isn't a fs transaction context we are worried about here...


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
