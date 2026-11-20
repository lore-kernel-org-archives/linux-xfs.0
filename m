Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199214;
	b=Hv7fldF4o8AgAcpVnLUOpSPFTc3TTzeWflP0UgYnHOhcjyIPS+z4iCUCH3UzXvnpa5/t
	 midSbHk3GRgYgAxTLmzSRap23s3u10Tq3C1I3GP8jtpVYqlau/EK29uJ/1PCPkIm0tXeB
	 H9+tv7RSnDrsYQjo4Mop692B/9fkkzGBkv75vwz9Mv1+U8/JZPzc7p3GpVerdtcn6xHkL
	 Hh6T5DD6qm0NWlBbcrZzST5hN0pvsFWzkDgzVwivSewz6dcrQBhza47aUzXI4r/15CZzs
	 vUzwkyiMrQWYMtNOeS2+lWk2eNv/qGw7wPOQ9wPqYWOBuD7kXcw2NV62TCLOnyQqRXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199214;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=19/rJLdqgzkfioz5z77MWazyV2zGFDrwOkdLp6n6ci4=;
	b=1mzwkrPc8nhr1V2CDGXjo6l3e+F7fQtcrsVR9IVqU7lmgEY3/Rv5gJhBvz4nCQPAE9Y8
	 960XUqfEvI6KnmCCWaT+AQJG1leisgoIyX/SZij/Ex2aYzSCWK1JfN2wjZEYxtF9MrU1T
	 I+v9B3SoX9kyrYIwTcph/MNdvWsm0BPNGqAei5iQTR/z5jxqrDjZxDxRKh+p5lSsjgigw
	 KWwEuOhMUq3+DHEP0/eTwI8LiCDTr3TR9NU6iuGVTZLtQn0aylh6tZspwcWcpwdOdjLmX
	 Wgs0q5oO6d/phQUpuRxLf5QGyxUBdEnI1Tb4ELhP+cYAfridx2d8xKdAfnrZgDObLPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55748606A32A;
	Fri, 20 Nov 2026 18:26:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55748606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EF17E6732A; Fri, 20 Nov 2026 19:26:48 +0100 (CET)
Date: Fri, 20 Nov 2026 19:26:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: glaubitz@physik.fu-berlin.de, frank.li@vivo.com, hch@lst.de,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	vdubeyko@coreweave.com, brauner@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 5/5] hfsplus: convert regular file I/O to iomap
Message-ID: <20261120182648.GE2183@lst.de>
References: <20261118004844.3849979-1-slava@dubeyko.com> <20261118004844.3849979-6-slava@dubeyko.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118004844.3849979-6-slava@dubeyko.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 17, 2026 at 04:48:44PM -0800, Viacheslav Dubeyko wrote:
> Switch the HFS+ regular file data path from buffer heads and
> blockdev_direct_IO() to iomap.
> 
> Add iomap.h and iomap.c with hfsplus_iomap_ops,
> hfsplus_write_iomap_ops, hfsplus_writeback_ops and
> hfsplus_write_dio_ops. iomap.c implements __hfsplus_iomap_begin(),
> hfsplus_write_iomap_end(), hfsplus_iomap_cont_expand() and
> hfsplus_writeback_range(), which are the basis of the HFS+ iomap
> operations. Direct write completion uses the generic
> iomap_dio_end_io() helper.
> 
> Implement iomap-based hfsplus_file_llseek(), hfsplus_file_read_iter()
> and hfsplus_file_write_iter(). The volume capacity limit for writes is
> enforced by generic_write_checks(), since s_maxbytes is already set
> from the volume capacity.
> 
> Redefine hfsplus_aops as iomap-based operations for regular files.
> As a result, hfsplus_direct_IO() is removed as a user of
> blockdev_direct_IO(), and the LEGACY_DIRECT_IO dependency is dropped
> from Kconfig. hfsplus_file_truncate() extends regular files by means
> of hfsplus_iomap_cont_expand(), while other inodes still use the
> write_begin/write_end path.
> 
> HFS+ does not support holes, so a write or truncate that extends a
> file first zero-fills the range between the old end-of-file and the
> new one by means of hfsplus_iomap_cont_expand(). Introduce
> hfsplus_iomap_extend_size() that grows i_size, zero-fills the gap and
> rolls back on failure, and use it in hfsplus_file_write_iter() and
> hfsplus_setattr(). Introduce hfsplus_iomap_size_rollback() that waits
> for in-flight direct I/O, sets i_size, truncates the page cache beyond
> it and calls hfsplus_file_truncate() to release the blocks allocated
> past it. It is not called when phys_size is below the new size, since
> hfsplus_file_truncate() would zero-fill again in that case.
> 
> In hfsplus_file_write_iter(), roll back after the data write if fewer
> bytes than requested were written: to the original size if nothing
> was written, or to the current i_size after a short write. Queued
> asynchronous direct I/O is skipped, because direct I/O beyond
> phys_size is forced to be synchronous, so a queued request never
> extends the file.
> 
> cc: Christoph Hellwig <hch@lst.de>
> cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> cc: Yangtao Li <frank.li@vivo.com>
> cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
> ---
>  fs/hfsplus/Kconfig      |   2 +-
>  fs/hfsplus/Makefile     |   6 +-
>  fs/hfsplus/extents.c    |  40 +++++--
>  fs/hfsplus/file.c       | 187 ++++++++++++++++++++++++++++-
>  fs/hfsplus/hfsplus_fs.h |  17 +++
>  fs/hfsplus/inode.c      | 155 ++++++++++++------------
>  fs/hfsplus/iomap.c      | 254 ++++++++++++++++++++++++++++++++++++++++
>  fs/hfsplus/iomap.h      |  17 +++
>  8 files changed, 583 insertions(+), 95 deletions(-)
>  create mode 100644 fs/hfsplus/iomap.c
>  create mode 100644 fs/hfsplus/iomap.h
> 
> diff --git a/fs/hfsplus/Kconfig b/fs/hfsplus/Kconfig
> index ca8401cb6954..b4432c64db3b 100644
> --- a/fs/hfsplus/Kconfig
> +++ b/fs/hfsplus/Kconfig
> @@ -5,7 +5,7 @@ config HFSPLUS_FS
>  	select BUFFER_HEAD
>  	select NLS
>  	select NLS_UTF8
> -	select LEGACY_DIRECT_IO
> +	select FS_IOMAP
>  	help
>  	  If you say Y here, you will be able to mount extended format
>  	  Macintosh-formatted hard drive partitions with full read-write access.
> diff --git a/fs/hfsplus/Makefile b/fs/hfsplus/Makefile
> index 82738ce7ca4d..3ddea69a9c69 100644
> --- a/fs/hfsplus/Makefile
> +++ b/fs/hfsplus/Makefile
> @@ -5,9 +5,9 @@
>  
>  obj-$(CONFIG_HFSPLUS_FS) += hfsplus.o
>  
> -hfsplus-objs := super.o options.o inode.o file.o ioctl.o extents.o catalog.o dir.o \
> -		btree.o bnode.o brec.o bfind.o tables.o unicode.o wrapper.o bitmap.o \
> -		part_tbl.o \
> +hfsplus-objs := super.o options.o inode.o file.o iomap.o ioctl.o extents.o \
> +		catalog.o dir.o btree.o bnode.o brec.o bfind.o tables.o \
> +		unicode.o wrapper.o bitmap.o part_tbl.o \
>  		attributes.o xattr.o xattr_user.o xattr_security.o xattr_trusted.o
>  
>  # KUnit tests
> diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
> index bb5a1508498d..0928d64684aa 100644
> --- a/fs/hfsplus/extents.c
> +++ b/fs/hfsplus/extents.c
> @@ -15,6 +15,7 @@
>  
>  #include "hfsplus_fs.h"
>  #include "hfsplus_raw.h"
> +#include "iomap.h"
>  
>  /* Compare two extents keys, returns 0 on same, pos/neg for difference */
>  int hfsplus_ext_cmp_key(const hfsplus_btree_key *k1,
> @@ -610,20 +611,33 @@ void hfsplus_file_truncate(struct inode *inode)
>  		inode->i_ino, (long long)hip->phys_size, inode->i_size);
>  
>  	if (inode->i_size > hip->phys_size) {
> -		struct address_space *mapping = inode->i_mapping;
> -		struct folio *folio;
> -		void *fsdata = NULL;
> -		loff_t size = inode->i_size;
> +		if (S_ISREG(inode->i_mode)) {
> +			res = hfsplus_iomap_cont_expand(inode, hip->phys_size,
> +							inode->i_size);
> +			if (res)
> +				return;
> +
> +			mark_inode_dirty(inode);
> +		} else {
> +			struct address_space *mapping = inode->i_mapping;
> +			struct folio *folio;
> +			void *fsdata = NULL;
> +
> +			res = hfsplus_write_begin(NULL, mapping,
> +						  inode->i_size, 0,
> +						  &folio, &fsdata);
> +			if (res)
> +				return;
> +
> +			res = generic_write_end(NULL, mapping,
> +						inode->i_size, 0, 0,
> +						folio, fsdata);
> +			if (res < 0)
> +				return;
> +
> +			mark_inode_dirty(inode);
> +		}
>  
> -		res = hfsplus_write_begin(NULL, mapping, size, 0,
> -					  &folio, &fsdata);
> -		if (res)
> -			return;
> -		res = generic_write_end(NULL, mapping, size, 0, 0,
> -					folio, fsdata);
> -		if (res < 0)
> -			return;
> -		mark_inode_dirty(inode);
>  		return;
>  	}
>  
> diff --git a/fs/hfsplus/file.c b/fs/hfsplus/file.c
> index 6b14095b2aa6..f34cd80351e5 100644
> --- a/fs/hfsplus/file.c
> +++ b/fs/hfsplus/file.c
> @@ -3,9 +3,11 @@
>  #include <linux/fs.h>
>  #include <linux/uio.h>
>  #include <linux/mount.h>
> +#include <linux/iomap.h>
>  
>  #include "hfsplus_fs.h"
>  #include "hfsplus_raw.h"
> +#include "iomap.h"
>  
>  static int hfsplus_file_open(struct inode *inode, struct file *file)
>  {
> @@ -14,6 +16,7 @@ static int hfsplus_file_open(struct inode *inode, struct file *file)
>  	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
>  		return -EOVERFLOW;
>  	atomic_inc(&HFSPLUS_I(inode)->opencnt);
> +	file->f_mode |= FMODE_CAN_ODIRECT;
>  	return 0;
>  }
>  
> @@ -113,10 +116,188 @@ int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
>  	return error;
>  }
>  
> +/*
> + * Fall back to buffered I/O for the tail of a write that
> + * iomap_dio_rw() could not perform directly (unaligned tail,
> + * or no blocks could be mapped without allocation
> + * outside the direct path).
> + */

Here you can use up the entire 80 characters as well.

> +static ssize_t hfsplus_fallback_buffered_write(struct kiocb *iocb,
> +						struct iov_iter *from)
> +{
> +	loff_t offset = iocb->ki_pos, end;
> +	ssize_t written;
> +	int ret;
> +
> +	iocb->ki_flags &= ~IOCB_DIRECT;

Does this need to wait for a zero i_dio_count just as it has been fixed
in various files recently?

It would be kinda nice to factor all this fallback logic into a helper
so that we have one maintained set of this logic instead of a copy in
various file systems.

> +	ret = iomap_dio_rw(iocb, from,
> +			   &hfsplus_write_iomap_ops,
> +			   &hfsplus_write_dio_ops,
> +			   dio_flags, NULL, 0);

You can use up the space available:

	ret = iomap_dio_rw(iocb, from, &hfsplus_write_iomap_ops,
			&hfsplus_write_dio_ops, dio_flags, NULL, 0);

> +		if (iocb->ki_pos + iov_iter_count(iter) >
> +		    HFSPLUS_I(inode)->phys_size)
> +			dio_flags |= IOMAP_DIO_FORCE_WAIT;

Add a comment on why the wait is forced?

