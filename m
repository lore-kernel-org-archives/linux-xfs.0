Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2ACpENH050883 for <xfs@oss.sgi.com>; Wed, 10 Mar 2010 06:51:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC7D31411BE9
	for <xfs@oss.sgi.com>; Wed, 10 Mar 2010 04:52:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	hFVx5xzqxGcs031G for <xfs@oss.sgi.com>;
	Wed, 10 Mar 2010 04:52:44 -0800 (PST)
Date: Wed, 10 Mar 2010 23:52:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: truncate delalloc extents when IO fails in
	writeback
Message-ID: <20100310125219.GA16344@discord.disaster>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
	<1267667185-7736-3-git-send-email-david@fromorbit.com>
	<20100310091237.GA25227@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100310091237.GA25227@infradead.org>
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

On Wed, Mar 10, 2010 at 04:12:37AM -0500, Christoph Hellwig wrote:
> Btw, I can trigger the new warnings from this patch in xfsqa after
> a few full XFSQA runs:
> 
> [39829.737139] Filesystem "vdb6": page discard on page c21d7480, inode
> 0x3f8, offset 0.
> [39829.739488] Filesystem "vdb6": page discard failed delalloc mapping
> lookup.
> [39829.744005] Filesystem "vdb6": page discard on page c206ba80, inode
> 0x3f9, offset 0.
> [39829.746496] Filesystem "vdb6": page discard failed delalloc mapping
> lookup.
> [39829.748655] Filesystem "vdb6": page discard on page c20e02a0, inode
> 0x3fa, offset 0.
> [39829.751000] Filesystem "vdb6": page discard failed delalloc mapping
> lookup.

The "page discard on page ...." are expected, but the failed mapping
warnings are not - that means xfs_bmapi() returned an error while
the inode still has delayed allocation buffers in memory. Did this
happen during a forced shutdown?  What test is running when this
occurs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
