Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751629AbdIUPk3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 11:40:29 -0400
Date: Thu, 21 Sep 2017 23:40:27 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: update i_size after unwritten conversion in dio
 completion
Message-ID: <20170921154027.GZ8034@eguan.usersys.redhat.com>
References: <20170921103828.18690-1-eguan@redhat.com>
 <20170921143308.GA18945@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921143308.GA18945@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Thu, Sep 21, 2017 at 07:33:08AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 21, 2017 at 06:38:28PM +0800, Eryu Guan wrote:
> > Since commit d531d91d6990 ("xfs: always use unwritten extents for
> > direct I/O writes"), we start allocating unwritten extents for all
> > direct writes to allow appending aio in XFS.
> > 
> > But for dio writes that could extend file size we update the in-core
> > inode size first, then convert the unwritten extents to real
> > allocations at dio completion time in xfs_dio_write_end_io(). Thus a
> > racing direct read could see the new i_size and find the unwritten
> > extents first and read zeros instead of actual data, if the direct
> > writer also takes a shared iolock.
> > 
> > Fix it by updating the in-core inode size after the unwritten extent
> > conversion. To do this, introduce a new boolean argument to
> > xfs_iomap_write_unwritten() to tell if we want to update in-core
> > i_size or not.
> > 
> > Suggested-by: Brian Foster <bfoster@redhat.com>
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> > 
> > Patch passed the test posted by Eric[1] and a locally modified aio
> > version of the test.
> > 
> > I also ran fstests with config xfs_4k_crc, xfs_2k_reflink, xfs_1k_rmap
> > and xfs_512, and aio-dio tests from ltp, I don't see any new failures
> > introduced.
> > 
> > [1] http://www.spinics.net/lists/fstests/msg06978.html
> > 
> >  fs/xfs/xfs_aops.c  |  9 ++++++++-
> >  fs/xfs/xfs_file.c  | 34 ++++++++++++++++++++--------------
> >  fs/xfs/xfs_iomap.c |  7 ++++++-
> >  fs/xfs/xfs_iomap.h |  2 +-
> >  fs/xfs/xfs_pnfs.c  |  2 +-
> >  5 files changed, 36 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 29172609f2a3..f937968e9515 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -343,7 +343,14 @@ xfs_end_io(
> >  		error = xfs_reflink_end_cow(ip, offset, size);
> >  		break;
> >  	case XFS_IO_UNWRITTEN:
> > -		error = xfs_iomap_write_unwritten(ip, offset, size);
> > +		/*
> > +		 * The correct in-core inode size should have been updated by
> > +		 * generic_write_end, and the 'size' here is buffer head
> > +		 * granularity size of the ioend, which could be larger than
> > +		 * the actual bytes written. So skip in-core i_size update in
> > +		 * xfs_iomap_write_unwritten()
> > +		 */
> > +		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> >  		break;
> >  	default:
> >  		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_append_trans);
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 350b6d43ba23..d4796c5a88fe 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -434,7 +434,6 @@ xfs_dio_write_end_io(
> >  	struct inode		*inode = file_inode(iocb->ki_filp);
> >  	struct xfs_inode	*ip = XFS_I(inode);
> >  	loff_t			offset = iocb->ki_pos;
> > -	bool			update_size = false;
> >  	int			error = 0;
> >  
> >  	trace_xfs_end_io_direct_write(ip, offset, size);
> > @@ -445,6 +444,22 @@ xfs_dio_write_end_io(
> >  	if (size <= 0)
> >  		return size;
> >  
> > +	if (flags & IOMAP_DIO_COW) {
> > +		error = xfs_reflink_end_cow(ip, offset, size);
> > +		if (error)
> > +			return error;
> > +	}
> 
> So this should be ok, but without digging in the details I wonder
> if we have proper tests for COWing the last block.
> 
> e.g. something like
> 
> write data from bytes 0 to 4000 to file a
> clone file a to file b
> write bytes 4000 to 4008 on file b

I took a rough look at generic tests in 'clone' group, it seems that
generic/134 and generic/20[23] could cover this scenario.

> 
> > @@ -900,6 +902,9 @@ xfs_iomap_write_unwritten(
> >  		if (i_size > offset + count)
> >  			i_size = offset + count;
> >  
> > +		if (update_isize && (i_size > i_size_read(inode)))
> 
> no need for the inner braces here.

OK, will fix in v2.

Thanks for reviewing!

Eryu
