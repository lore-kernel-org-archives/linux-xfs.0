Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1G37cUc113955 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 21:07:40 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A439121CC9
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 19:07:03 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	h7oVA61pFiLVmUsh for <xfs@oss.sgi.com>;
	Sun, 15 Feb 2009 19:07:03 -0800 (PST)
Date: Mon, 16 Feb 2009 14:06:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/17] xfs: merge xfs_inode_flush into xfs_fs_write_inode
Message-ID: <20090216030657.GB8830@disturbed>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073202.588218000@bombadil.infradead.org>
	<20090215064225.GA8830@disturbed>
	<20090215201321.GA16048@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090215201321.GA16048@infradead.org>
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

On Sun, Feb 15, 2009 at 03:13:21PM -0500, Christoph Hellwig wrote:
> On Sun, Feb 15, 2009 at 05:42:25PM +1100, Dave Chinner wrote:
> > On Mon, Jan 26, 2009 at 02:31:47AM -0500, Christoph Hellwig wrote:
> > > Spliting the task for a VFS-induced inode flush into two functions doesn't
> > > make any sense, so merge the two functions dealing with it.
> > 
> > I just realised that we should really be calling xfs_inode_flush() from
> > xfs_sync_inodes_ag() - it open codes xfs_inode_flush() and doesn't
> > have any of the non-blocking flush code for async flushes...
> 
> Given that we'll hopefully do batched flushes driven directly from
> the sync code re-introducing the helper now just to rip it out again
> a little later doesn't seem to useful to me.  And the calling
> conventions for xfs_inode_flush were rather odd to start with anyway.

Well, ok. I'll just duplicate xfs_fs_write_inode() for the sync code
right now, then.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
