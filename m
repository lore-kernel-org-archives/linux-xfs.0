Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9594B7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 13:28:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7DC748F8049
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 11:28:28 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xGA2G7EtB0x2Haaa for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 11:28:26 -0800 (PST)
Date: Tue, 9 Feb 2016 06:28:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/9] xfs: introduce inode log format object
Message-ID: <20160208192823.GE27429@dastard>
References: <1454905461-2773-1-git-send-email-david@fromorbit.com>
	<1454905461-2773-2-git-send-email-david@fromorbit.com>
	<20160208092318.GA28146@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208092318.GA28146@infradead.org>
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

On Mon, Feb 08, 2016 at 01:23:18AM -0800, Christoph Hellwig wrote:
> This looks fine in general:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But: this now introduce struct inode to libxfs code, what's your plan
> to deal with that in xfsprogs?

The struct xfs_inode is already unique between user and kernel
space, so I was simply going to define all the new fields directly
inside the struct xfs_inode and:

#define VFS_I(ip)	(ip)

Or If I can't get that to work without somehow defining a struct
inode, then put all the fields in a struct inode private to the
struct xfs_inode and just do the same conversion as the kernel.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
