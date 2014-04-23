Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 73D357F5F
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 17:22:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E67DFAC015
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 15:22:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	N2fq8Uzw0WGAYDKT for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 15:22:22 -0700 (PDT)
Date: Thu, 24 Apr 2014 08:22:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] libxfs: adding attribute fork frees xfs_inode ptr
Message-ID: <20140423222215.GT18672@dastard>
References: <20140423210034.892939354@sgi.com>
	<20140423210445.700477624@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140423210445.700477624@sgi.com>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Wed, Apr 23, 2014 at 04:04:35PM -0500, Mark Tinguely wrote:
> User space does not currently perform any attribute adding/deleting,
> but if we do want to fix attributes or use them for parent inode
> pointers, user space should support attributes.
> 
> The adding an attribute fork is done in an embedded transaction
> inside xfs_attr_set_int(). The xfs_trans_commit in xfs_bmap_add_attrfork()
> will free the xfs_inode pointer causing xfs_attr_calc_size() in
> xfs_attr_set_int() to fail.

It shouldn't. xfs_bmap_add_attrfork() does:

	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);

which in the kernel code sets:

	iip->ili_lock_flags = lock_flags;


The libxfs code doesn't do that, so when xfs_trans_commit() gets
to inode_item_unlock():


        if (!iip->ili_lock_flags)
                libxfs_iput(ip, 0);
        else
                iip->ili_lock_flags = 0;

It frees the inode rather than just returning it with the lock
flags cleared.

Note that libxfs still has libxfs_trans_ijoin_ref() which sets the
lock flags, but this has been removed from the kernel code. IOWs,
this is a libxfs/trans.c::xfs_trans_ijoin() bug, not something that
needs fixing in the shared kernel/user libxfs code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
