Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37463 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751596AbdK2Vht (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 16:37:49 -0500
Date: Thu, 30 Nov 2017 08:37:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 17/17] Add parent pointer ioctl
Message-ID: <20171129213746.GK5858@dastard>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-18-git-send-email-allison.henderson@oracle.com>
 <20171128203537.GZ21412@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128203537.GZ21412@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 12:35:37PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 17, 2017 at 11:21:45AM -0700, Allison Henderson wrote:
> > This patch adds a new file ioctl to retrieve the parent
> > pointer of a given inode
> 
> (Yes, it's time to start talking about actual use cases...)
> 
> At a bare minimum, this is what I pictured for the "return parents of
> the open file" ioctl:
> 
> #define XFS_PPTR_MAXNAMELEN		255
> 
> struct xfs_pptr {
> 	u64				pp_ino;
> 	u32				pp_gen;
> 	u8				pp_namelen;
> 	u8				pp_name[XFS_PPTR_MAXNAMELEN];
> };

That's going to be a different size on 32bit and 64 bit platforms
as the structure size is a multiple of 4 bytes, not 8 bytes.
That will cause problems and need complex comapt ioctl translation.
Better to make pp_namelen a u32 and that will make the structure
64 bit aligned and sized on all platforms.

I'd allow more than u8 for the namelen. Yes, while we currently
allow on 255 bytes for a name, it would make more sense to
use a u32 here so that the structure size is a multiple of it's
alignment rather than having a 4 byte hole in the array we don't
fill out....

> 
> /* return parents of the handle, instead of the open fd */
> #define XFS_PPTR_FLAG_HANDLE		(1u << 0)
> 
> struct xfs_pptr_info {
> 	struct xfs_fsop_handlereq	pi_handle;
> 	struct xfs_attrlist_cursor	pi_cursor;
> 	u32				pi_flags;
> 	u32				pi_reserved;
> 	u32				pi_ptrs_size;
> 	u32				pi_ptrs_used;
> 	u64				pi_reserved2[6];
> 	struct xfs_pptr			pi_ptrs[0];
> };

I thought gcc had started doing weird things with variable size
array declarations like this (i.e. pi_ptrs[0]) because the exact
behaviour is not defined in the C standard. i.e. we need to avoid
adding new declarations that do this...


> #define XFS_PPTR_INFO_SIZEOF(ptrs)	(sizeof(struct xfs_pptr_info) + \
> 					((ptrs) * sizeof(struct xfs_pptr)));
> static inline struct xfs_pptr_info *
> xfs_pptr_alloc(
> 	size_t			nr_ptrs)
> {
> 	struct xfs_pptr_info	*ppi;
> 
> 	ppi = malloc(XFS_PPTR_INFO_SIZEOF(nr_ptrs));
> 	if (!ppi)
> 		return NULL;
> 	memset(ppi, 0, XFS_PPTR_INFO_SIZEOF(nr_ptrs));
> 	ppi->pi_ptrs_size = nr_ptrs;
> 	return ppi;
> }
> 
> With the following example userspace program (that does no checking
> whatsoever):
> 
> int main(int argc, char *argv[])
> {
> 	struct xfs_pptr_info	*ppi;
> 	struct xfs_pptr		*pp;
> 	int			fd;
> 
> 	fd = open(argv[1], O_RDONLY);
> 	ppi = xfs_pptr_alloc(32);
> 
> 	while (ioctl(fd, XFS_IOC_GETPPOINTER, ppi) == 0 && ppi->pi_ptrs_used) {
> 		for (i = 0; i < ppi->pi_ptrs_used; i++) {
> 			printf("%llu:%u -> %s\n",
> 					ppi->pi_ptrs[i].pp_ino,
> 					ppi->pi_ptrs[i].pp_gen,
> 					ppi->pi_ptrs[i].pp_name);
> 		}
> 	}
> }

Seems like a reasonable model to me.

> I /also/ wonder if there's any interest in having a fallback for
> non-pptr filesystems that walks the dentry->d_parent links (like
> d_paths() does) back to the root.  Such a fallback will only work on an
> opened dir or a file opened by path (i.e. not a handle), however, which
> limits its appeal.

I wouldn't bother complicating anything by trying to support
filesytems that don't have parent pointer info. Just have
non-parent-ptr filesystems return EOPNOTSUPP for the ioctl and be
done with it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
