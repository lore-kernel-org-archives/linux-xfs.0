Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A0FA47F3F
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 03:29:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 816DA8F8073
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 01:29:30 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8qJvs5a9CMYHWSs2 for <xfs@oss.sgi.com>;
	Thu, 16 Apr 2015 01:29:24 -0700 (PDT)
Date: Thu, 16 Apr 2015 18:29:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: add DAX file operations support
Message-ID: <20150416082909.GA21261@dastard>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-6-git-send-email-david@fromorbit.com>
	<20150406174900.GC58965@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150406174900.GC58965@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Mon, Apr 06, 2015 at 01:49:00PM -0400, Brian Foster wrote:
> On Tue, Mar 24, 2015 at 09:51:03PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add the initial support for DAX file operations to XFS. This
> > includes the necessary block allocation and mmap page fault hooks
> > for DAX to function.
> > 
> > Note: we specifically have to disable splice_read/write from
> > occurring because they are dependent on usingthe page cache for
> > correct operation. We have no page cache for DAX, so we need to
> > disable them completely on DAX inodes.
> > 
> 
> Looks like Boaz already pointed out this required an update wrt to
> splice...
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c |  73 ++++++++++++++++++++++++++++++++--
> >  fs/xfs/xfs_aops.h |   7 +++-
> >  fs/xfs/xfs_file.c | 116 ++++++++++++++++++++++++++++++++----------------------
> >  3 files changed, 143 insertions(+), 53 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 3a9b7a1..3fc5052 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -1233,13 +1233,64 @@ xfs_vm_releasepage(
> >  	return try_to_free_buffers(page);
> >  }
> >  
> > +/*
> > + * For DAX we need a mapping buffer callback for unwritten extent conversion
> > + * when page faults allocation blocks and then zero them.
> 
> s/allocation/allocate/
> 
> > + */
> > +#ifdef CONFIG_FS_DAX
> > +static struct xfs_ioend *
> > +xfs_dax_alloc_ioend(
> > +	struct inode	*inode,
> > +	xfs_off_t	offset,
> > +	ssize_t		size)
> > +{
> > +	struct xfs_ioend *ioend;
> > +
> > +	ASSERT(IS_DAX(inode));
> > +	ioend = xfs_alloc_ioend(inode, XFS_IO_UNWRITTEN);
> > +	ioend->io_offset = offset;
> > +	ioend->io_size = size;
> > +	return ioend;
> > +}
> > +
> > +void
> > +xfs_get_blocks_dax_complete(
> > +	struct buffer_head	*bh,
> > +	int			uptodate)
> > +{
> > +	struct xfs_ioend	*ioend = bh->b_private;
> > +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> > +	int			error;
> > +
> > +	ASSERT(IS_DAX(ioend->io_inode));
> > +
> > +	/* if there was an error zeroing, then don't convert it */
> > +	if (!uptodate)
> > +		goto out_free;
> > +
> 
> Hmm, the error handling seems a bit off here. I'm new to the mmap paths
> so I could easily be missing something. Anyways, this uptodate val is
> hardcoded to 1 down in __dax_mkwrite(). This function is only called on
> !error, however, which seems to make this error handling superfluous. If
> I am following that correctly, who is going to free the ioend if an
> error does occur?

Right, the dax code needs fixing to unconditionally call the end IO
callback. I'll add that patch into the start of the series.

As it is, this patch needs significant rework after the DIO
write completion path rework. It greatly simplifies this because we
now have an ioend being allocated in __xfs_get_blocks....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
