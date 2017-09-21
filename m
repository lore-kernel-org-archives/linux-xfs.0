Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbdIUKJt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 06:09:49 -0400
Date: Thu, 21 Sep 2017 18:09:44 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] test race when checking i_size on direct i/o read
Message-ID: <20170921100944.GX8034@eguan.usersys.redhat.com>
References: <799f63d9-de03-eab3-1e6e-cd747aa04c36@redhat.com>
 <20170919073616.GP8034@eguan.usersys.redhat.com>
 <20170919141351.GB3487@bfoster.bfoster>
 <20170919143406.GA7437@infradead.org>
 <20170920110504.GU8034@eguan.usersys.redhat.com>
 <20170920125529.GA16481@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920125529.GA16481@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, fstests <fstests@vger.kernel.org>, Zheng Liu <wenqing.lz@taobao.com>, linux-xfs@vger.kernel.org

On Wed, Sep 20, 2017 at 08:55:30AM -0400, Brian Foster wrote:
> On Wed, Sep 20, 2017 at 07:05:04PM +0800, Eryu Guan wrote:
> > On Tue, Sep 19, 2017 at 07:34:06AM -0700, Christoph Hellwig wrote:
> > > On Tue, Sep 19, 2017 at 10:13:52AM -0400, Brian Foster wrote:
> > > > Can we pass a boolean or flag to xfs_iomap_write_unwritten() to have it
> > > > update the incore i_size after unwritten extent conversion? Then move
> > > > (or remove) the associated update from xfs_dio_write_end_io().
> > > 
> > > I don't think we even need a flag - all three callers of
> > > xfs_iomap_write_unwritten want to update the file size.
> > 
> > I tried this approach, but seems there's some problem in the buffered
> > aio path, generic/112 (aio fsx) failed quickly. But I haven't digged
> > into the reason (maybe I screwed it up, not the method is wrong..).
> > 
> 
> From the generic/112 results:
> 
> Size error: expected 0x3785b stat 0x38000 seek 0x38000
> 
> I suspect the problem is that the offset+size from buffered I/O
> completion is not based on the inode size. Rather, it is buffer head
> granularity size of the ioend. Given that, it probably does make sense
> to skip the update from this path.

Yeah, you're right.

xfs_io -fc "falloc -k 0 4k" -c "pwrite 0 2k" -c fsync /mnt/xfs/testfile

This results in 4k file size (block size is also 4k).

> 
> > Then I tried Brian's suggestion, pass a boolean to
> > xfs_iomap_write_unwritten() to tell if we want it to update in-core
> > isize after unwritten extent conversion, and skip the in-core isize
> > update in xfs_dio_write_end_io() accordingly. This approach seems to
> > work, it passed the test Eric posted here, and fstests 'aio' group
> > tests, a run of 'quick' group didn't find any new failure as well.
> > 
> > I attached the WIP patch (without proper comments) I was testing, if
> > this looks fine I can format a formal patch and do more testings.
> >
> 
> Thanks. This mostly looks reasonable to me...
>  
> > Thanks,
> > Eryu
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 29172609f2a3..288da47e9ac5 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -343,7 +343,7 @@ xfs_end_io(
> >  		error = xfs_reflink_end_cow(ip, offset, size);
> >  		break;
> >  	case XFS_IO_UNWRITTEN:
> > -		error = xfs_iomap_write_unwritten(ip, offset, size);
> > +		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> 
> Maybe add a single line comment here wrt to the above (why we don't
> update isize).

Will do.

> 
> >  		break;
> >  	default:
> >  		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_append_trans);
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 350b6d43ba23..f3ad024573e7 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -435,6 +435,7 @@ xfs_dio_write_end_io(
> >  	struct xfs_inode	*ip = XFS_I(inode);
> >  	loff_t			offset = iocb->ki_pos;
> >  	bool			update_size = false;
> > +	bool			write_unwritten = (flags & IOMAP_DIO_UNWRITTEN);
> >  	int			error = 0;
> >  
> >  	trace_xfs_end_io_direct_write(ip, offset, size);
> > @@ -458,7 +459,8 @@ xfs_dio_write_end_io(
> >  	 */
> >  	spin_lock(&ip->i_flags_lock);
> >  	if (offset + size > i_size_read(inode)) {
> > -		i_size_write(inode, offset + size);
> > +		if (!write_unwritten)
> > +			i_size_write(inode, offset + size);
> >  		update_size = true;
> 
> I find the logic a little confusing here. For !write_unwritten,
> update_size means to update the on-disk size. Otherwise, it instructs
> iomap_write_unwritten() to also update the in-core size. The latter also
> checks for appends, however, so it might as well always be true from
> here. It seems that for such a small function, we should be able to make
> this a bit easier to follow. ;P

Agreed, it looks confusing when update_size serves as indicators of both
in-core and on-disk size update. And we can pass 'true' unconditionally
to xfs_iomap_write_unwritten() in this case.

> 
> Should we ever see an isize update at all on a IOMAP_DIO_COW completion
> (wouldn't reflinked blocks have to be within eof)? If not, then we can
> presumably rule out isize updates in that case. I think that just leaves
> the case where a dio write occurs on a pre-existing block. Hmm, could we
> just move this whole hunk down to after the iomap_write_unwritten() call
> and eliminate the need for the flag entirely? E.g., something like:
> 
> 	...
> 	if (IOMAP_DIO_COW) {
> 		...
> 	}
> 
> 	/* unwritten conversion updates isize */
> 	if (IOMAP_DIO_UNWRITTEN)
> 		return xfs_iomap_write_unwritten(ip, offset, size, true);
> 
> 	if (offset + size > i_size_read(inode)) {
> 		i_size_write(inode, offset + size);
> 		error = xfs_setfilesize(...);
> 	}
> 
> 	return error;

This seems fine, tests in 'clone' group all passed without new failures,
I'll update patch as you suggested. I thought about something like this
too, but I'm not familiar with the CoW path, so I decided to keep the
original logic as much as possible.

Thanks for your review and suggestions!

Eryu

> 
> >  	}
> >  	spin_unlock(&ip->i_flags_lock);
> > @@ -469,8 +471,8 @@ xfs_dio_write_end_io(
> >  			return error;
> >  	}
> >  
> > -	if (flags & IOMAP_DIO_UNWRITTEN)
> > -		error = xfs_iomap_write_unwritten(ip, offset, size);
> > +	if (write_unwritten)
> > +		error = xfs_iomap_write_unwritten(ip, offset, size, update_size);
> >  	else if (update_size)
> >  		error = xfs_setfilesize(ip, offset, size);
> >  
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index a1909bc064e9..0a088586371e 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -829,7 +829,8 @@ int
> >  xfs_iomap_write_unwritten(
> >  	xfs_inode_t	*ip,
> >  	xfs_off_t	offset,
> > -	xfs_off_t	count)
> > +	xfs_off_t	count,
> > +	bool		update_size)
> >  {
> >  	xfs_mount_t	*mp = ip->i_mount;
> >  	xfs_fileoff_t	offset_fsb;
> > @@ -840,6 +841,7 @@ xfs_iomap_write_unwritten(
> >  	xfs_trans_t	*tp;
> >  	xfs_bmbt_irec_t imap;
> >  	struct xfs_defer_ops dfops;
> > +	struct inode	*inode = VFS_I(ip);
> >  	xfs_fsize_t	i_size;
> >  	uint		resblks;
> >  	int		error;
> > @@ -900,6 +902,13 @@ xfs_iomap_write_unwritten(
> >  		if (i_size > offset + count)
> >  			i_size = offset + count;
> >  
> > +		if (update_size) {
> > +			spin_lock(&ip->i_flags_lock);
> > +			if (i_size > i_size_read(inode))
> > +				i_size_write(inode, i_size);
> > +			spin_unlock(&ip->i_flags_lock);
> 
> We have XFS_ILOCK_EXCL here so I don't think the spinlocks are
> necessary any longer. That means this could probably be condensed to
> something like
> 
> 		if (update_size && i_size > i_size_read(inode))
> 			i_size_write(inode, i_size)
> 
> > +		}
> > +
> >  		i_size = xfs_new_eof(ip, i_size);
> >  		if (i_size) {
> >  			ip->i_d.di_size = i_size;
> > diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> > index 00db3ecea084..ee535065c5d0 100644
> > --- a/fs/xfs/xfs_iomap.h
> > +++ b/fs/xfs/xfs_iomap.h
> > @@ -27,7 +27,7 @@ int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
> >  			struct xfs_bmbt_irec *, int);
> >  int xfs_iomap_write_allocate(struct xfs_inode *, int, xfs_off_t,
> >  			struct xfs_bmbt_irec *);
> > -int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
> > +int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
> >  
> >  void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
> >  		struct xfs_bmbt_irec *);
> > diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> > index 2f2dc3c09ad0..4246876df7b7 100644
> > --- a/fs/xfs/xfs_pnfs.c
> > +++ b/fs/xfs/xfs_pnfs.c
> > @@ -274,7 +274,7 @@ xfs_fs_commit_blocks(
> >  					(end - 1) >> PAGE_SHIFT);
> >  		WARN_ON_ONCE(error);
> >  
> > -		error = xfs_iomap_write_unwritten(ip, start, length);
> > +		error = xfs_iomap_write_unwritten(ip, start, length, false);
> 
> Note that this path does update isize. It runs another transaction to
> get around the fact that write_unwritten() wouldn't log a new on disk
> size. There is some validation thing here though, so we might need to
> check whether it is Ok to run that earlier and whether it should
> continue to return an error on failure. Christoph?
> 
> That said, maybe a follow on patch would be better since this one might
> be stable fodder.
> 
> Brian
> 
> >  		if (error)
> >  			goto out_drop_iolock;
> >  	}
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
