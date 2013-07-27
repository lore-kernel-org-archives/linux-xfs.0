Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D0127F4E
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 20:55:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88782304077
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 18:55:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	KWGg29CRnxSDqq4i for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 18:55:24 -0700 (PDT)
Date: Sat, 27 Jul 2013 11:55:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 24/49] xfs: kill xfs_vnodeops.[ch]
Message-ID: <20130727015522.GU13468@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-25-git-send-email-david@fromorbit.com>
	<51F2CB91.3020801@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F2CB91.3020801@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 26, 2013 at 02:18:41PM -0500, Mark Tinguely wrote:
> On 07/19/13 01:24, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >Now we have xfs_inode.c for holding kernel-only XFS inode
> >operations, move all the inode operations from xfs_vnodeops.c to
> >this new file as it holds another set of kernel-only inode
> >operations. The name of this file traces back to the days of Irix
> >and it's vnodes which we don't have anymore.
> >
> >Essentially this move consolidates the inode locking functions
> >and a bunch of XFS inode operations into the one file. Eventually
> >the high level functions will be merged into the VFS interface
> >functions in xfs_iops.c.
> >
> >This leaves only internal preallocation, EOF block manipulation and
> >hole punching functions in vnodeops.c. Move these to xfs_bmap_util.c
> >where we are already consolidating various in-kernel physical extent
> >manipulation and querying functions.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> As already mentioned, xfs_inode_fork.c still has a unwanted include
> of now removed xfs_vnodeops.h.
> 
> A xfs_qm_dqrele(pdqp) does not exist in the copied code:

Yes, already fixed that here. It was causing test failures on
xfs/050.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
