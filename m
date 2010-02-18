Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1ILIpJu077400 for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 15:18:52 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 610E21CDF6FE
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 13:20:08 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	zk2qumP0dHzH0EGd for <xfs@oss.sgi.com>;
	Thu, 18 Feb 2010 13:20:08 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	14233037-1927428
	for <xfs@oss.sgi.com>; Fri, 19 Feb 2010 07:50:06 +1030 (CDT)
Date: Fri, 19 Feb 2010 08:04:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: remove xfs_ipin/xfs_iunpin
Message-ID: <20100218210426.GA28392@discord.disaster>
References: <20100217194407.GB28758@infradead.org>
	<20100217230033.GW28392@discord.disaster>
	<20100218124322.GB6016@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100218124322.GB6016@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Feb 18, 2010 at 07:43:22AM -0500, Christoph Hellwig wrote:
> On Thu, Feb 18, 2010 at 10:00:33AM +1100, Dave Chinner wrote:
> > > +	ASSERT(atomic_read(&->i_pincount) > 0);
> > 
> > I don't think that compiles. ;)
> 
> It does in fact compile for non-debug builds, but here's an updated

Very true...

> version that also compiles in a debug build:
> 
> ---
> 
> From: Christoph Hellwig <hch@lst.de>
> Subject: [PATCH 2/2] xfs: remove xfs_ipin/xfs_iunpin
> 
> Inodes are only pinned/unpinned via the inode item methods, and lots of
> code relies on that fact.  So remove the separate xfs_ipin/xfs_iunpin
> helpers and merge them into their only callers.  This also fixes up
> various duplicate and/or incorrect comments.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
