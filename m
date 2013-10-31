Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A92F77F54
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 16:59:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 444478F8039
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 14:59:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	R1UCOMJEzXZFQuiT for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 14:59:53 -0700 (PDT)
Date: Fri, 1 Nov 2013 08:59:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/30] db: rewrite IO engine to use libxfs
Message-ID: <20131031215950.GO4446@dastard>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-18-git-send-email-david@fromorbit.com>
	<20131031151046.GB7457@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131031151046.GB7457@infradead.org>
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

On Thu, Oct 31, 2013 at 08:10:46AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 30, 2013 at 03:31:08PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we have buffers and xfs_buf_maps, it is relatively easy to
> > convert the IO engine to use libxfs routines. This gets rid of the
> > most of the differences between mapped and straight buffer reads,
> > and tracks xfs_bufs directly in the IO context that is being used.
> > 
> > This is not yet a perfect solution, as xfs_db does different sized
> > IOs for the same block range which will throw warnings like:
> > 
> > xfs_db> inode 64
> > 7ffff7fde740: Badness in key lookup (length)
> > bp=(bno 0x40, len 8192 bytes) key=(bno 0x40, len 4096 bytes)
> > xfs_db>
> 
> Maybe we should use uncached buffer I/O in xfs_db, similar to what we do
> in the mount path in the kernel?

Possibly. I have thought about it, but we'd need a new interface and
a rework of the libxfs read/write code to do that, and that has
wider impact than just xfs_db. I also found lots of interesting
issues as a result of the re-read behaviour which I wouldn't have
easily found otherwise. i.e. the output is an early warning that
something isn't quite right in xfs_db, so it does have some use
right now.

> >  	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
> > +	if (flags & LIBXFS_MOUNT_ROOTINOS)
> > +		mp->m_flags |= LIBXFS_MOUNT_ROOTINOS;
> > +
> >  	mp->m_sb = *sb;
> >  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
> >  	sbp = &(mp->m_sb);
> > @@ -866,6 +869,8 @@ libxfs_umount(xfs_mount_t *mp)
> >  	int			agno;
> >  
> >  	libxfs_rtmount_destroy(mp);
> > +	if ((mp->m_flags & LIBXFS_MOUNT_ROOTINOS) && mp->m_rootip)
> > +		libxfs_iput(mp->m_rootip, 0);
> 
> Seems like the patch to remove m_rootip should go before this one?

Yeah, good idea.

> > -struct xfs_buf *
> > -libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
> > -		int flags, const struct xfs_buf_ops *ops)
> > +int
> > +libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp,
> > +		    struct xfs_buf_map *map, int nmaps, int flags)
> 
> Shouldn't these sort of changes go into a separate patch?

I can do that.

Thanks for looking at these patches, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
