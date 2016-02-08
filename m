Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB79A7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 13:44:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C24108F8035
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 11:44:23 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	RJIG5Mqu53jhwSUt for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 11:44:20 -0800 (PST)
Date: Tue, 9 Feb 2016 06:44:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/9] xfs: move v1 inode conversion to xfs_inode_from_disk
Message-ID: <20160208194418.GF27429@dastard>
References: <1454905461-2773-1-git-send-email-david@fromorbit.com>
	<1454905461-2773-5-git-send-email-david@fromorbit.com>
	<20160208093150.GD28146@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208093150.GD28146@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 01:31:50AM -0800, Christoph Hellwig wrote:
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Shouldn't we be able to kill off di_version as well?  version 3 inodes
> only happen on crc enabled file systems, and version 2 only on
> version 4 file systems.

In theory, yes, though there is a lot of code that checks the
di_version field and the superblock version checks are more
heavyweight.

I think it's also a cleaner design to base general inode
formatting decisions on the inode version number and it's internal
flags, because then we don't have to rely on external code to
determine exactly what to do. e.g. in userspace there is no
guarantee we have a superblock context we can access, even if we
have a struct xfs_inode or a struct xfs_icdinode...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
