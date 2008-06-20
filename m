Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 22:44:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5K5inhN015958
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 22:44:50 -0700
Message-ID: <485B4406.6060906@sgi.com>
Date: Fri, 20 Jun 2008 15:45:42 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] attrmulti cleanup
References: <20080531080121.GB5424@lst.de>
In-Reply-To: <20080531080121.GB5424@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Cool.
I'll run thru qa and check it in.
Funny how we had two versions.

--Tim

Christoph Hellwig wrote:
> xfs_attrmulti_by_handle currently request the size based on
> sizeof(attr_multiop_t) but should be using sizeof(xfs_attr_multiop_t)
> because that is what it is dealing with.  Despite beeing wrong this
> actually harmless in practice because both structures are the same size
> on all platforms.
> 
> But this sizeof was the only user of struct attr_multiop so we can just
> kill it.  Also move the ATTR_OP_* defines xfs_attr.h into the
> struct xfs_attr_multiop defintion in xfs_fs.h because they are only used
> with that structure, and are part of the user ABI for the
> XFS_IOC_ATTRMULTI_BY_HANDLE ioctl.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2008-05-28 17:42:18.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2008-05-28 17:42:36.000000000 +0200
> @@ -598,7 +598,7 @@ xfs_attrmulti_by_handle(
>  		goto out;
>  
>  	error = E2BIG;
> -	size = am_hreq.opcount * sizeof(attr_multiop_t);
> +	size = am_hreq.opcount * sizeof(xfs_attr_multiop_t);
>  	if (!size || size > 16 * PAGE_SIZE)
>  		goto out_vn_rele;
>  
> Index: linux-2.6-xfs/fs/xfs/xfs_attr.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_attr.h	2008-05-28 17:41:06.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_attr.h	2008-05-28 17:42:36.000000000 +0200
> @@ -100,22 +100,6 @@ typedef struct attrlist_ent {	/* data fr
>  	 &((char *)buffer)[ ((attrlist_t *)(buffer))->al_offset[index] ])
>  
>  /*
> - * Multi-attribute operation vector.
> - */
> -typedef struct attr_multiop {
> -	int	am_opcode;	/* operation to perform (ATTR_OP_GET, etc.) */
> -	int	am_error;	/* [out arg] result of this sub-op (an errno) */
> -	char	*am_attrname;	/* attribute name to work with */
> -	char	*am_attrvalue;	/* [in/out arg] attribute value (raw bytes) */
> -	int	am_length;	/* [in/out arg] length of value */
> -	int	am_flags;	/* bitwise OR of attr API flags defined above */
> -} attr_multiop_t;
> -
> -#define ATTR_OP_GET	1	/* return the indicated attr's value */
> -#define ATTR_OP_SET	2	/* set/create the indicated attr/value pair */
> -#define ATTR_OP_REMOVE	3	/* remove the indicated attr */
> -
> -/*
>   * Kernel-internal version of the attrlist cursor.
>   */
>  typedef struct attrlist_cursor_kern {
> Index: linux-2.6-xfs/fs/xfs/xfs_fs.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_fs.h	2008-05-28 17:41:06.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_fs.h	2008-05-28 17:42:36.000000000 +0200
> @@ -372,6 +372,9 @@ typedef struct xfs_fsop_attrlist_handler
>  
>  typedef struct xfs_attr_multiop {
>  	__u32		am_opcode;
> +#define ATTR_OP_GET	1	/* return the indicated attr's value */
> +#define ATTR_OP_SET	2	/* set/create the indicated attr/value pair */
> +#define ATTR_OP_REMOVE	3	/* remove the indicated attr */
>  	__s32		am_error;
>  	void		__user *am_attrname;
>  	void		__user *am_attrvalue;
> 
