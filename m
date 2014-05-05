Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C263D29DFD
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 16:28:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9CA2D8F8035
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 14:28:07 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Em4gQdlb9AArRaLL for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 14:28:00 -0700 (PDT)
Date: Tue, 6 May 2014 07:27:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] xfsprogs: sync kernel inode cluster size refactor code
Message-ID: <20140505212759.GA26353@dastard>
References: <536784B2.7090002@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536784B2.7090002@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, May 05, 2014 at 08:31:46PM +0800, Jeff Liu wrote:
> Hi Folks,
> 
> This patch series sync up the code differences between kernel and user space
> for xfs_icluster_size_fsb() relevant changes, i.e,
> http://oss.sgi.com/archives/xfs/2013-12/msg00499.html
> 
> Most patches are similar to the kernel part except we have xfs_bulkstat() and
> xfs_ifree_cluster() at kernel space but they are not presented at user space.   

Given that we need to do a wholesale resync of libxfs to the kernel
code, I'm not sure it makes sense to do little bits out of order.
it just makes syncing all the other prior changes harder because it
causes patch conflicts...

I'm planning that this is the first thing that we need to do
after the 3.2.0 release before anything else....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
