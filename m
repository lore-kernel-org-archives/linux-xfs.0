Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36E607F3F
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 17:45:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 26931304032
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 15:45:45 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BMvHcqhFDSxE9tnf for <xfs@oss.sgi.com>;
	Sun, 20 Dec 2015 15:45:39 -0800 (PST)
Date: Mon, 21 Dec 2015 10:45:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/4] xfsprogs: fix integer overflow in
	xlog_find_verify_cycle
Message-ID: <20151220234520.GU26718@dastard>
References: <1449832143-26356-1-git-send-email-t.vivek@samsung.com>
	<1449832143-26356-3-git-send-email-t.vivek@samsung.com>
	<20151220153513.GD20135@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151220153513.GD20135@infradead.org>
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
Cc: a.sahrawat@samsung.com, xfs@oss.sgi.com, Vivek Trivedi <t.vivek@samsung.com>, pankaj.m@samsung.com

On Sun, Dec 20, 2015 at 07:35:13AM -0800, Christoph Hellwig wrote:
> On Fri, Dec 11, 2015 at 04:39:01PM +0530, Vivek Trivedi wrote:
> > Fix unintentional integer overflow in xlog_find_verify_cycle.
> > Reported by coverity.
> 
> xfs_daddr_t is a 64-bit integer.  How does replacing it with an int fix
> overlows?

xfs_daddr_t is being abused here as a count rather than a disk
address, whereas all the other counts in the function are ints and
so the value can't be more than 32 bits anyway....

> xlog_find_verify_cycle originates in the kernel code, so any fix
> should probably be done there first.

I'll pull all the libxfs changes made first in userspace back into
the kernel - no point making people jump throw hoops just to get a
fix into the libxfs code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
