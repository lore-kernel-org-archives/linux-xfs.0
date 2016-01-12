Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C631029DF5
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 09:30:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5FFD304053
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 07:30:13 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id mki5ujrDqqqO8fzP (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 07:30:10 -0800 (PST)
Date: Tue, 12 Jan 2016 07:30:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/8] xfs: shrink the struct xfs_icdinode
Message-ID: <20160112153010.GA29662@infradead.org>
References: <1452589280-30167-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452589280-30167-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Nice!

I had started on some of this a while ago but never finished it..

> 72 bytes. This means it takes 104 bytes off the size of the struct
> xfs_inode, which a 12% reduction in size. This will be a massive win
> for systems that cache lots of inodes!

How many more inodes can we fit into a slab cache now?  Back when I
started I noticed it doesn't help us to actually fit more inodes into
a 4k page due to the bloated VFS inode.  But these days slub actually
uses a high order allocations if I remember correctly so it might be
more useful.

> With this change made, the xfs_icdinode is no long an "in core disk
> inode" so I'm wondering whether I should rename it or simply make it
> go away altogether and pull the remaining fields straight into the
> struct xfs_inode. Any thoughts on new names and/or getting rid of it
> woul dbe appreciated.

I think it should be merged into the xfs_inode structure soner or
later.  Another thign I planned but never got to is to move fields
into the inode fork that were specific to the attr or data fork.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
