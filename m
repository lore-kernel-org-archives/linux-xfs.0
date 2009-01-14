Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0E1vQme027002 for <xfs@oss.sgi.com>; Tue, 13 Jan 2009 19:57:27 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 166F117F05AC
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2009 17:57:24 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	ygqPURqQVeQ9hQkD for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2009 17:57:24 -0800 (PST)
Date: Wed, 14 Jan 2009 12:57:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: fix dentry aliasing issues in open_by_handle
Message-ID: <20090114015716.GP8071@disturbed>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090109221259.292773000@bombadil.infradead.org>
	<20090111233306.GH8071@disturbed>
	<20090112153934.GA28382@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090112153934.GA28382@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Mon, Jan 12, 2009 at 10:39:34AM -0500, Christoph Hellwig wrote:
> On Mon, Jan 12, 2009 at 10:33:06AM +1100, Dave Chinner wrote:
> > That should probably be namespaced correctly because it won't be
> > static on debug builds. i.e.  xfs_handle_acceptable()
> 
> Ok.
> 
> > The args in this function are back to front compared to all the
> > other functions - the others are (filp, arg), this one is the
> > opposite.
> 
> Yeah, I first had all this way and then changed it around to match
> the non-handle ioctls more closely but forgot this one.
> 
> Updated patch below:
> 
> ---
> 
> Subject: xfs: fix dentry aliasing issues in open_by_handle
> From: Christoph Hellwig <hch@lst.de>
> 
> Open by handle just grabs an inode by handle and then creates itself
> a dentry for it.  While this works for regular files it is horribly
> broken for directories, where the VFS locking relies on the fact that
> there is only just one single dentry for a given inode, and that
> these are always connected to the root of the filesystem so that
> it's locking algorithms work (see Documentations/filesystems/Locking)
> 
> Remove all the existing open by handle code and replace it with a small
> wrapper around the exportfs code which deals with all these issues.
> At the same time we also make the checks for a valid handle strict
> enough to reject all not perfectly well formed handles - given that
> we never hand out others that's okay and simplifies the code.
> 
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
