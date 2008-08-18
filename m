Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Aug 2008 01:13:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7I8Cmlq013411
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2008 01:12:49 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 127303A99A5
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2008 01:14:08 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id KHAb3IQT5gJ9VO5d for <xfs@oss.sgi.com>; Mon, 18 Aug 2008 01:14:08 -0700 (PDT)
Date: Mon, 18 Aug 2008 18:14:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Allocate inode tracing buffers before locking inode
	cluster
Message-ID: <20080818081403.GJ19760@disturbed>
References: <48A92BC6.5020105@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A92BC6.5020105@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Aug 18, 2008 at 05:59:02PM +1000, Lachlan McIlroy wrote:
> Trying to allocate memory while holding the inode cluster locked can cause
> deadlocks; a thread creating an inode will have the inode cluster locked
> and is stuck allocating memory, pdflush/kswapd are both trying to push out
> dirty pages and convert delayed allocations which need space in the log and
> xfsaild is trying to push on the tail of the log but is stuck trying to
> acquire the inode cluster lock.
>
> I tried fixing this with KM_NOFS but turned a two-way deadlock into a
> three-way deadlock.  This patch moves the allocation of the inode tracing
> buffers before we lock the inode cluster.  We can also leak memory because
> we don't free these allocations if we return from this function early so
> use xfs_idestroy() to fully clean up the inode first.

Seems sane, but I think it should be wrapped up in the
xfs_inode_alloc() code added as part of the 'Make use of the
init-once slab optimisation' patch I posted recently. This
moves the initialisation of all things inode related into a
separate function - xfs_inode_alloc() - instead of doing all
these intialisations around the place....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
