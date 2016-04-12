Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEED17CA2
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 18:29:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 719BEAC005
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 16:29:46 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DoOADddo1mTSo9b9 for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 16:29:43 -0700 (PDT)
Date: Wed, 13 Apr 2016 09:29:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: xfs_inode_free() isn't RCU safe
Message-ID: <20160412232925.GN567@dastard>
References: <0A92B65A3BF94F60BB36EA3FA716DF1F@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0A92B65A3BF94F60BB36EA3FA716DF1F@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: bbice@sgi.com, Shyam Kaushik <shyam@zadarastorage.com>, xfs@oss.sgi.com

On Tue, Apr 12, 2016 at 11:56:35AM +0300, Alex Lyakas wrote:
> Hello Dave,
> 
> Looking at the patch, I see that now we call xfs_idestroy_fork() in RCU callback. This can do the following chain:
> 
> xfs_iext_destroy => xfs_iext_irec_remove => xfs_iext_realloc_indirect=> kmem_realloc => kmem_alloc => kmem_alloc => congestion_wait()
> 
> At least according to documentation, the RCU callback cannot block, since it may be called from softirq context. Is this fine?

Right, I forgot about that. Too many forests. I'll reconstruct your
patch from the email you appended it to previously and add that to
the series to test against.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
