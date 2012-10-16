Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9GEl65f150352 for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 09:47:06 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8IXvXZxXfXkDMvEG for
	<xfs@oss.sgi.com>; Tue, 16 Oct 2012 07:48:43 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9GEmgIJ031817
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 10:48:42 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-111.phx2.redhat.com
	[10.3.113.111])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q9GEmUj9031749
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 10:48:33 -0400
Date: Tue, 16 Oct 2012 11:48:30 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC PATCH] xfs: enables file data inlining in inodes
Message-ID: <20121016144829.GA8752@andromeda.usersys.redhat.com>
References: <1349985158-9952-1-git-send-email-cmaiolino@redhat.com>
	<507837E6.4040807@redhat.com>
	<20121015171904.GB8376@andromeda.usersys.redhat.com>
	<507C5648.3020306@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <507C5648.3020306@redhat.com>
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
To: xfs@oss.sgi.com

On Mon, Oct 15, 2012 at 02:30:32PM -0400, Brian Foster wrote:
> On 10/15/2012 01:19 PM, Carlos Maiolino wrote:
> > On Fri, Oct 12, 2012 at 11:31:50AM -0400, Brian Foster wrote:
> >> On 10/11/2012 03:52 PM, Carlos Maiolino wrote:
> >>> Hi,
> >>>
> >>> this is a first RFC patch of my work on data inlining, i.e. use the xfs inode's
> >>> literal area to store user's data.
> >>>
> >>> This first patch just cares about write and read new files into inode's literal
> >>> area, it does not make any conversion from inline to extent or vice-versa.
> >>>
> >>> The idea to send this patch to list is just to get comments about this first
> >>> work and see if anybody has some ideas/suggestions about it, mainly related
> >>> with page cache and journal handling, since it's the first time I deal with
> >>> journal and page cache handling, I'm not pretty sure if I did things right
> >>> or not.
> >>>
> >>> Every comment is very appreciated.
> >>>
> >>> Thanks
> >>> ---
> >>>  fs/xfs/xfs_aops.c  | 134 ++++++++++++++++++++++++++++++++++++++++++++++++++---
> >>>  fs/xfs/xfs_inode.c |  15 +-----
> >>>  2 files changed, 130 insertions(+), 19 deletions(-)
> >>>
> >>> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> >>> index e562dd4..3d30528 100644
> >>> --- a/fs/xfs/xfs_aops.c
> >>> +++ b/fs/xfs/xfs_aops.c
> >>> @@ -31,6 +31,7 @@
> >>>  #include "xfs_vnodeops.h"
> >>>  #include "xfs_trace.h"
> >>>  #include "xfs_bmap.h"
> >>> +#include "xfs_inode_item.h"
> >>>  #include <linux/gfp.h>
> >>>  #include <linux/mpage.h>
> >>>  #include <linux/pagevec.h>
> >>> @@ -460,6 +461,95 @@ xfs_start_page_writeback(
> >>>  		end_page_writeback(page);
> >>>  }
> >>>  
> >>> +/* Write data inlined in inode */
> >>> +
> >>> +STATIC int
> >>> +xfs_inline_write(
> >>> +	struct xfs_inode	*ip,
> >>> +	struct page		*page,
> >>> +	struct buffer_head	*bh,
> >>> +	__uint64_t		end_offset)
> >>> +{
> >>> +	char		*data;
> >>> +	int		err = 0;
> >>> +	xfs_trans_t	*tp;
> >>> +	xfs_mount_t	*mp = ip->i_mount;
> >>> +
> >>> +	printk("%s: INLINING INODE %llu\n", __func__, ip->i_ino);
> >>> +	xfs_start_page_writeback(page, 1, 1);
> >>> +
> >>> +	tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE);
> >>> +	err = xfs_trans_reserve(tp, 0, XFS_SWRITE_LOG_RES(mp), 0, 0, 0); /* Is this the right logspace? */
> >>> +
> >>> +	if (err) {
> >>> +		xfs_trans_cancel(tp, 0);
> >>
> >> Do you need to undo xfs_start_page_writeback() here?
> >>
> > 
> > Not sure if I got what you meant
> 
> i.e., you call xfs_start_page_writeback() at the beginning of the
> function (which calls set_page_writeback()), then at the end of the
> function you call end_page_writeback(). If you return early here due to
> error, should you call end_page_writeback() as well?
> 
I'm not sure but you're probably right. I'm going to study how another code
paths deal with it, and make se same here.

> >>> +		return -1;
> >>> +	}
> >>> +
> >>> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >>> +
> >>> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> >>> +
> >>> +	if (!(ip->i_d.di_format & XFS_DINODE_FMT_LOCAL)) {
> >>> +		ip->i_df.if_flags &= ~XFS_IFEXTENTS;
> >>> +		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
> >>> +		ip->i_df.if_flags |= XFS_IFINLINE;
> >>> +	}
> >>> +
> >>> +	ASSERT(ip->i_df.if_flags & XFS_IFINLINE);
> >>> +
> >>> +	if (end_offset > ip->i_df.if_bytes)
> >>> +		xfs_idata_realloc(ip, end_offset - ip->i_df.if_bytes,
> >>> +				  XFS_DATA_FORK);
> >>> +
> >>> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE | XFS_ILOG_DDATA);
> >>> +	data = kmap(page);
> >>> +	memcpy(ip->i_df.if_u1.if_data, data, end_offset);
> >>> +	kunmap(page);
> >>> +
> >>> +	ip->i_d.di_size = end_offset;
> >>> +
> >>> +	err = xfs_trans_commit(tp, 0);
> >>> +
> >>> +	set_buffer_uptodate(bh);
> >>> +	clear_buffer_dirty(bh);
> >>> +	clear_buffer_delay(bh);
> >>> +	SetPageUptodate(page);
> >>> +
> >>> +	end_page_writeback(page);
> >>> +	return err;
> >>> +}
> >>> +
> >>> +STATIC int
> >>> +xfs_inline_read(
> >>> +	struct xfs_inode	*ip,
> >>> +	struct page		*page,
> >>> +	struct address_space	*mapping)
> >>> +{
> >>> +	char *data;
> >>> +	unsigned long bsize = 1 << ip->i_vnode.i_blkbits;
> >>> +
> >>> +	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
> >>> +	ASSERT(ip->i_df.if_flags & XFS_IFINLINE);
> >>> +
> >>> +	if (!page_has_buffers(page))
> >>> +		create_empty_buffers(page, bsize, 0);
> >>> +
> >>> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> >>> +
> >>> +	data = kmap(page);
> >>> +	memcpy(data, ip->i_df.if_u1.if_data, (int)ip->i_d.di_size);
> >>> +	kunmap(page);
> >>> +
> >>> +	/* We should not leave garbage after user data into the page */
> >>> +	memset(data + (int)ip->i_d.di_size, 0, PAGE_SIZE - ip->i_d.di_size);
> >>> +
> >>> +	SetPageUptodate(page);
> >>> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >>> +	unlock_page(page);
> >>> +	return 0;
> >>> +}
> >>> +
> >>>  static inline int bio_add_buffer(struct bio *bio, struct buffer_head *bh)
> >>>  {
> >>>  	return bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
> >>> @@ -900,6 +990,7 @@ xfs_vm_writepage(
> >>>  	struct writeback_control *wbc)
> >>>  {
> >>>  	struct inode		*inode = page->mapping->host;
> >>> +	xfs_inode_t		*ip = XFS_I(inode);
> >>>  	struct buffer_head	*bh, *head;
> >>>  	struct xfs_bmbt_irec	imap;
> >>>  	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
> >>> @@ -908,7 +999,7 @@ xfs_vm_writepage(
> >>>  	__uint64_t              end_offset;
> >>>  	pgoff_t                 end_index, last_index;
> >>>  	ssize_t			len;
> >>> -	int			err, imap_valid = 0, uptodate = 1;
> >>> +	int			err = 0, imap_valid = 0, uptodate = 1;
> >>>  	int			count = 0;
> >>>  	int			nonblocking = 0;
> >>>  
> >>> @@ -968,8 +1059,16 @@ xfs_vm_writepage(
> >>>  			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
> >>>  			offset);
> >>>  	len = 1 << inode->i_blkbits;
> >>> -
> >>>  	bh = head = page_buffers(page);
> >>> +
> >>> +	if (end_offset + i_size_read(inode) <= XFS_IFORK_DSIZE(ip)) {
> >>
> >> So end_offset looks like it is the size of the file if this page
> >> contains EOF, or the next page-aligned offset of the file otherwise. If
> >> I understand correctly, shouldn't we just check if end_offset falls
> >> within the data fork size here? IOW, I don't understand why you add
> >> end_offset and i_size_read(inode) here.
> >>
> > 
> > Check by end_offset is not the right thing to do here, but it needs an inode
> > size check. What I tried to do was catch any file changes that occurs before the
> > asignment of end_offset and this check condition. Not sure if I'm right though
> > and should leave only:
> > 
> > if (i_size_read(inode) <= XFS_IFORK_DSIZE(ip)) {
> 
> Err.. right. You want to store the data in the inode if the file fits
> completely within the space available in the inode (not just if the
> current write is within that region). The check above makes sense to me.
> 
> The adding logic seems strange to me in that if (for the sake of a
> simple example) a file is 256 bytes, you have 256 bytes of space in the
> inode and you write to any offset, this condition now fails.
> 
> I'm not quite sure I follow what you mean by catching file changes, so I
> certainly could be missing something... 

An example: If you extend a file, you need to check if the file still fits in
the inode. I'm not sure that only i_size_read(inode) will check for this, that's
why I added end_offset + i_size_read(), but, I believe it's wrong (end_offset +
i_size_read).

>but it seems like the code
> earlier in xfs_vm_writepage() already handles the truncate case. If the
> file size increased in that time, would this code really care? Wouldn't
> that mean you'd have to convert the file at that point, presumably when
> you get a writepage on one of the pages that falls outside the available
> space?
> 
> Perhaps this gets more into detection of the current inode format when
> you have to convert back and forth and this logic naturally becomes more
> complicated (and thus I'm just reading too far ahead :P).
> 
Yes, as the patch description says, it doesn't care about file conversion yet :)
this only cares about write/read new files into inodes, I want to make sure I'm
doing this part properly, before move on the the next step, which is take care
of these conversions, if I take care of everything at the same time I'll get
crazy and have nothing done at the same time :-)

> Brian
> 
> > 
> >> Brian
> >>
> >>> +		err = xfs_inline_write(ip, page, bh, end_offset);
> >>> +
> >>> +		if (err)
> >>> +			goto error;
> >>> +		return 0;
> >>> +	}
> >>> +
> >>>  	offset = page_offset(page);
> >>>  	type = XFS_IO_OVERWRITE;
> >>>  
> >>> @@ -1624,20 +1723,43 @@ xfs_vm_bmap(
> >>>  
> >>>  STATIC int
> >>>  xfs_vm_readpage(
> >>> -	struct file		*unused,
> >>> +	struct file		*filp,
> >>>  	struct page		*page)
> >>>  {
> >>> -	return mpage_readpage(page, xfs_get_blocks);
> >>> +	struct inode		*inode = filp->f_mapping->host;
> >>> +	struct xfs_inode	*ip = XFS_I(inode);
> >>> +
> >>> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL)
> >>> +		return xfs_inline_read(ip, page, page->mapping);
> >>> +	else
> >>> +		return mpage_readpage(page, xfs_get_blocks);
> >>>  }
> >>>  
> >>>  STATIC int
> >>>  xfs_vm_readpages(
> >>> -	struct file		*unused,
> >>> +	struct file		*filp,
> >>>  	struct address_space	*mapping,
> >>>  	struct list_head	*pages,
> >>>  	unsigned		nr_pages)
> >>>  {
> >>> -	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
> >>> +	struct inode		*inode = filp->f_mapping->host;
> >>> +	struct xfs_inode	*ip = XFS_I(inode);
> >>> +
> >>> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> >>> +		struct page	*page = list_first_entry(pages, struct page, lru);
> >>> +
> >>> +		ASSERT(i_size_read(VFS_I(ip) <= PAGE_CACHE_SIZE));
> >>> +
> >>> +		list_del(&page->lru);
> >>> +		if(!(add_to_page_cache_lru(page, mapping,
> >>> +					    page->index, GFP_KERNEL)))
> >>> +			return xfs_inline_read(ip, page, page->mapping);
> >>> +
> >>> +		page_cache_release(page);
> >>> +		return 0;
> >>> +	} else {
> >>> +		return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
> >>> +	}
> >>>  }
> >>>  
> >>>  const struct address_space_operations xfs_address_space_operations = {
> >>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >>> index 2778258..5e56e5c 100644
> >>> --- a/fs/xfs/xfs_inode.c
> >>> +++ b/fs/xfs/xfs_inode.c
> >>> @@ -287,18 +287,6 @@ xfs_iformat(
> >>>  	case S_IFDIR:
> >>>  		switch (dip->di_format) {
> >>>  		case XFS_DINODE_FMT_LOCAL:
> >>> -			/*
> >>> -			 * no local regular files yet
> >>> -			 */
> >>> -			if (unlikely(S_ISREG(be16_to_cpu(dip->di_mode)))) {
> >>> -				xfs_warn(ip->i_mount,
> >>> -			"corrupt inode %Lu (local format for regular file).",
> >>> -					(unsigned long long) ip->i_ino);
> >>> -				XFS_CORRUPTION_ERROR("xfs_iformat(4)",
> >>> -						     XFS_ERRLEVEL_LOW,
> >>> -						     ip->i_mount, dip);
> >>> -				return XFS_ERROR(EFSCORRUPTED);
> >>> -			}
> >>>  
> >>>  			di_size = be64_to_cpu(dip->di_size);
> >>>  			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
> >>> @@ -2471,7 +2459,8 @@ xfs_iflush_int(
> >>>  	if (S_ISREG(ip->i_d.di_mode)) {
> >>>  		if (XFS_TEST_ERROR(
> >>>  		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
> >>> -		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
> >>> +		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
> >>> +		    (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL),
> >>>  		    mp, XFS_ERRTAG_IFLUSH_3, XFS_RANDOM_IFLUSH_3)) {
> >>>  			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
> >>>  				"%s: Bad regular inode %Lu, ptr 0x%p",
> >>>
> >>
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
