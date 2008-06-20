Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 22:41:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5K5f1Km015250
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 22:41:03 -0700
Message-ID: <485B431F.2070905@sgi.com>
Date: Fri, 20 Jun 2008 15:41:51 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] check for invalid flags in xfs_attrlist_by_handle
References: <20080531075829.GA5424@lst.de>
In-Reply-To: <20080531075829.GA5424@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Fair enough.
Actually, I think we only use ATTR_ROOT and ATTR_SECURE for the
namespace flags.
So you could probably use: XFS_ATTR_NSP_ARGS
xfs_attr_leaf.h:#define XFS_ATTR_NSP_ARGS_MASK	 (ATTR_ROOT | ATTR_SECURE)
xfs_attr_leaf.h:#define XFS_ATTR_NSP_ARGS(flags) ((flags) & XFS_ATTR_NSP_ARGS_MASK)
and something like:

if (!XFS_ATTR_NSP_ARGS(al_hreq.flags))
         return -XFS_ERROR(EINVAL);

Though would probably then need to include the right header (xfs_attr_leaf.h) for it...

--Tim

Christoph Hellwig wrote:
> xfs_attrlist_by_handle should only take the ATTR_ flags for the root
> namespaces.  The ATTR_KERN* flags may change at anytime and expect special
> preconditions that can't be guaranteed for userspace-originating
> requests.  For example passing down ATTR_KERNNOVAL through
> xfs_attrlist_by_handle will hit an assert in debug builds currently.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-05-28 17:37:02.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-05-28 17:42:18.000000000 +0200
> @@ -470,6 +470,12 @@ xfs_attrlist_by_handle(
>  	if (al_hreq.buflen > XATTR_LIST_MAX)
>  		return -XFS_ERROR(EINVAL);
>  
> +	/*
> +	 * Reject flags, only allow namespaces.
> +	 */
> +	if (al_hreq.flags & ~(ATTR_ROOT|ATTR_TRUST|ATTR_SECURE))
> +		return -XFS_ERROR(EINVAL);
> +
>  	error = xfs_vget_fsop_handlereq(mp, parinode, &al_hreq.hreq, &inode);
>  	if (error)
>  		goto out;
> 
