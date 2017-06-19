Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40374 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdFSRci (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2017 13:32:38 -0400
Date: Mon, 19 Jun 2017 10:32:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/7] vfs: Add iomap_seek_hole_data helper
Message-ID: <20170619173232.GA4730@birch.djwong.org>
References: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
 <1497624680-16685-5-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497624680-16685-5-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel@redhat.com

On Fri, Jun 16, 2017 at 04:51:17PM +0200, Andreas Gruenbacher wrote:
> Filesystems can use this for implementing lseek SEEK_HOLE / SEEK_DATA
> support via iomap.
> 
> The __iomap_seek_hole_data helper takes an additional size argument and
> doesn't reposition the file offset; this is for internal use for xfs
> quota files which don't maintain the inode size.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/iomap.c            | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/iomap.h |  6 ++++
>  2 files changed, 87 insertions(+)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 4b10892..cf01694 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -584,6 +584,87 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
>  }
>  EXPORT_SYMBOL_GPL(iomap_fiemap);
>  
> +static loff_t
> +iomap_seek_hole_actor(struct inode *inode, loff_t offset, loff_t length,
> +		      void *data, struct iomap *iomap)
> +{
> +	if (iomap->type == IOMAP_HOLE)

Echoing Dave's comments further on (sorry, I tend to read the patchset but
reply in reverse order, distractions notwithstanding), for SEEK_{HOLE,DATA}
you'd want to test for type == IOMAP_HOLE || type == IOMAP_UNWRITTEN since
unwritten (i.e. fallocated) areas are treated as holes.

--D

> +		return 0;
> +	return iomap->offset + iomap->length - offset;
> +}
> +
> +static loff_t
> +iomap_seek_data_actor(struct inode *inode, loff_t offset, loff_t length,
> +		      void *data, struct iomap *iomap)
> +{
> +	if (iomap->type != IOMAP_HOLE)
> +		return 0;
> +	return iomap->offset + iomap->length - offset;
> +}
> +
> +loff_t
> +__iomap_seek_hole_data(struct inode *inode, loff_t offset, loff_t size,
> +		       int whence, const struct iomap_ops *ops)
> +{
> +	static loff_t (*actor)(struct inode *, loff_t, loff_t, void *,
> +			       struct iomap *);
> +	loff_t len = size - offset;
> +	loff_t ret;
> +
> +	/* Nothing to be found beyond the end of the file. */
> +	if (len <= 0)
> +		return -ENXIO;
> +
> +	switch(whence) {
> +	case SEEK_HOLE:
> +		actor = iomap_seek_hole_actor;
> +		break;
> +
> +	case SEEK_DATA:
> +		actor = iomap_seek_data_actor;
> +		break;
> +	}
> +
> +	while (len > 0) {
> +		ret = iomap_apply(inode, offset, len, IOMAP_REPORT, ops,
> +				  NULL, actor);
> +		if (ret <= 0) {
> +			if (ret < 0)
> +				return ret;
> +			break;
> +		}
> +		offset += ret;
> +		len -= ret;
> +	}
> +
> +	if (len <= 0) {
> +		/* There is an implicit hole at the end of the file. */
> +		if (whence != SEEK_HOLE)
> +			offset = -ENXIO;
> +
> +		/* The last segment can extend beyond the end of the file. */
> +		if (offset > size)
> +			offset = size;
> +	}
> +
> +	return offset;
> +}
> +EXPORT_SYMBOL_GPL(__iomap_seek_hole_data);
> +
> +loff_t
> +iomap_seek_hole_data(struct file *file, loff_t offset, int whence,
> +		     const struct iomap_ops *ops)
> +{
> +	struct inode *inode = file->f_mapping->host;
> +
> +	offset = __iomap_seek_hole_data(inode, offset, i_size_read(inode),
> +					whence, ops);
> +	if (offset <= 0)
> +		return offset;
> +	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
> +}
> +EXPORT_SYMBOL_GPL(iomap_seek_hole_data);
> +
>  /*
>   * Private flags for iomap_dio, must not overlap with the public ones in
>   * iomap.h:
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 9d64933..49b6ec0 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -85,6 +85,12 @@ int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops);
>  int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		loff_t start, loff_t len, const struct iomap_ops *ops);
>  
> +struct file;
> +loff_t __iomap_seek_hole_data(struct inode *inode, loff_t pos, loff_t size,
> +			      int whence, const struct iomap_ops *ops);
> +loff_t iomap_seek_hole_data(struct file *file, loff_t pos,
> +			    int whence, const struct iomap_ops *ops);
> +
>  /*
>   * Flags for direct I/O ->end_io:
>   */
> -- 
> 2.7.5
> 
