Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALHxKsV024051 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 11:59:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9BE4155FEEE
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 09:59:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UciF6b3S2COk22Kv for
	<xfs@oss.sgi.com>; Fri, 21 Nov 2008 09:59:17 -0800 (PST)
Date: Fri, 21 Nov 2008 12:58:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] dmapi: use ->put_listen callback directly
Message-ID: <20081121175846.GA15526@infradead.org>
References: <20080603114848.GC2703@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080603114848.GC2703@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Any chance to get this in after almost six month?

On Tue, Jun 03, 2008 at 01:48:48PM +0200, Christoph Hellwig wrote:
> Rewrite xfs_dm_getall_dmattr to directly call xfs_list_attr_int in
> fill the userspace buffer directly from the listent. Doing the direct
> put means the need for the large kernel space buffer is gone, there
> is only one btree traversal needed and thus the list vs get race
> is fixed.  By doing the proper put_user/copy_to_user the direct
> userspace memory derference is fixed, too and the code is a lot
> simpler and easier to understand.
> 
> This patch passes xfsqa but I don't really trust it much vs dmapi,
> so please review carefully.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-06-01 14:45:20.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-06-03 12:00:22.000000000 +0200
> @@ -2092,149 +2092,136 @@ xfs_dm_get_region(
>  }
>  
>  
> +#define DM_GETALL_DMATTR_ALIGN	(sizeof(int) - 1)
> +
>  STATIC int
> -xfs_dm_getall_dmattr(
> -	struct inode	*inode,
> -	dm_right_t	right,
> -	size_t		buflen,
> -	void		__user *bufp,
> -	size_t		__user *rlenp)
> +xfs_dm_put_listent(
> +	xfs_attr_list_context_t	*context,
> +	int			flags,
> +	char			*name,
> +	int			namelen,
> +	int			valuelen,
> +	char			*value)
>  {
> -	attrlist_cursor_kern_t cursor;
> -	attrlist_t	*attrlist;
> -	dm_attrlist_t	__user *ulist;
> -	int		*last_link;
> -	int		alignment;
> -	int		total_size;
> -	int		list_size = 8192;	/* should be big enough */
> -	int		error;
> +	dm_attrlist_t __user	*ulist;
> +	int			size_needed;
>  
> -	/* Returns negative errors to DMAPI */
> +	ASSERT(context->count >= 0);
>  
> -	if (right < DM_RIGHT_SHARED)
> -		return(-EACCES);
> +	/*
> +	 * Skip over all non-DMAPI attributes.	If the attribute name is too
> +	 * long, we assume it is non-DMAPI even if it starts with the correct
> +	 * prefix.
> +	 */
> +	if (!(flags & XFS_ATTR_ROOT))
> +		return 0;
> +	if (namelen > DM_ATTR_NAME_SIZE)
> +		return 0;
> +	if (strncmp(name, dmattr_prefix, DMATTR_PREFIXLEN))
> +		return 0;
>  
> -	/* Verify that the user gave us a buffer that is 4-byte aligned, lock
> -	   it down, and work directly within that buffer.  As a side-effect,
> -	   values of buflen < sizeof(int) return EINVAL.
> -	*/
> +	size_needed = sizeof(dm_attrlist_t) + valuelen;
> +	size_needed = (size_needed + DM_GETALL_DMATTR_ALIGN) &
> +			~DM_GETALL_DMATTR_ALIGN;
>  
> -	alignment = sizeof(int) - 1;
> -	if ((((__psint_t)bufp & alignment) != 0) ||
> -               !access_ok(VERIFY_WRITE, bufp, buflen)) {
> -		return(-EFAULT);
> +	/*
> +	 * We have a valid DMAPI attribute to return.  If it won't fit in the
> +	 * user's buffer, we still need to keep track of the number of bytes
> +	 * for the user's next call.
> +	 */
> +	context->count += size_needed;
> +	if (context->count > context->bufsize) {
> +		context->seen_enough = 1;
> +		return 1;
> +	}
> +
> +	ulist = (dm_attrlist_t __user __force *)
> +		 (context->alist + context->count);
> +
> +	if (copy_to_user(ulist->al_name.an_chars, name, namelen) ||
> +	    clear_user(ulist->al_name.an_chars + namelen,
> +			DM_ATTR_NAME_SIZE - namelen) ||
> +	    put_user(sizeof(dm_attrlist_t), &ulist->al_data.vd_offset) ||
> +	    put_user(valuelen, &ulist->al_data.vd_length) ||
> +	    put_user(size_needed, &ulist->_link) ||
> +	    copy_to_user(ulist + 1, value, valuelen)) {
> +		context->count = -1;
> +		return 1;
>  	}
> -	buflen &= ~alignment;		/* round down the alignment */
>  
> -	/* Initialize all the structures and variables for the main loop. */
> +	context->last_link = &ulist->_link;
> +	return 0;
> +}
>  
> -	memset(&cursor, 0, sizeof(cursor));
> -	attrlist = (attrlist_t *)kmem_alloc(list_size, KM_SLEEP);
> -	total_size = 0;
> -	ulist = (dm_attrlist_t *)bufp;
> -	last_link = NULL;
> -
> -	/* Use vop_attr_list to get the names of DMAPI attributes, and use
> -	   vop_attr_get to get their values.  There is a risk here that the
> -	   DMAPI attributes could change between the vop_attr_list and
> -	   vop_attr_get calls.	If we can detect it, we return EIO to notify
> -	   the user.
> -	*/
> +STATIC int
> +xfs_dm_getall_dmattr(
> +	struct inode		*inode,
> +	dm_right_t		right,
> +	size_t			buflen,
> +	void			__user *bufp,
> +	size_t			__user *rlenp)
> +{
> +	xfs_attr_list_context_t	context;
> +	attrlist_cursor_kern_t	cursor = { 0, };
> +	int			error;
>  
> -	do {
> -		int	i;
> +	if (right < DM_RIGHT_SHARED)
> +		return -EACCES;
>  
> -		/* Get a buffer full of attribute names.  If there aren't any
> -		   more or if we encounter an error, then finish up.
> -		*/
> +	/* verify that the user gave us a buffer that is 4-byte aligned */
> +	if ((unsigned long)bufp & DM_GETALL_DMATTR_ALIGN)
> +		return -EFAULT;
>  
> -		error = xfs_attr_list(XFS_I(inode), (char *)attrlist, list_size,
> -						ATTR_ROOT, &cursor);
> -		DM_EA_XLATE_ERR(error);
> +	/* round down the alignment */
> +	buflen &= ~DM_GETALL_DMATTR_ALIGN;
>  
> -		if (error || attrlist->al_count == 0)
> -			break;
> +	memset(&context, 0, sizeof(context));
> +	context.dp = XFS_I(inode);
> +	context.cursor = &cursor;
> +	context.resynch = 1;
> +	context.flags = ATTR_ROOT;
> +	/* alist is just a cookie */
> +	context.alist = (char * __force)bufp;
> +	context.bufsize = buflen;
> +	context.put_value = 1;
> +	context.put_listent = xfs_dm_put_listent;
>  
> -		for (i = 0; i < attrlist->al_count; i++) {
> -			attrlist_ent_t	*entry;
> -			char		*user_name;
> -			int		size_needed;
> -			int		value_len;
> -
> -			/* Skip over all non-DMAPI attributes.	If the
> -			   attribute name is too long, we assume it is
> -			   non-DMAPI even if it starts with the correct
> -			   prefix.
> -			*/
> -
> -			entry = ATTR_ENTRY(attrlist, i);
> -			if (strncmp(entry->a_name, dmattr_prefix, DMATTR_PREFIXLEN))
> -				continue;
> -			user_name = &entry->a_name[DMATTR_PREFIXLEN];
> -			if (strlen(user_name) > DM_ATTR_NAME_SIZE)
> -				continue;
> -
> -			/* We have a valid DMAPI attribute to return.  If it
> -			   won't fit in the user's buffer, we still need to
> -			   keep track of the number of bytes for the user's
> -			   next call.
> -			*/
> -
> -
> -			size_needed = sizeof(*ulist) + entry->a_valuelen;
> -			size_needed = (size_needed + alignment) & ~alignment;
> -
> -			total_size += size_needed;
> -			if (total_size > buflen)
> -				continue;
> -
> -			/* Start by filling in all the fields in the
> -			   dm_attrlist_t structure.
> -			*/
> -
> -			strncpy((char *)ulist->al_name.an_chars, user_name,
> -				DM_ATTR_NAME_SIZE);
> -			ulist->al_data.vd_offset = sizeof(*ulist);
> -			ulist->al_data.vd_length = entry->a_valuelen;
> -			ulist->_link =	size_needed;
> -			last_link = &ulist->_link;
> -
> -			/* Next read the attribute's value into its correct
> -			   location after the dm_attrlist structure.  Any sort
> -			   of error indicates that the data is moving under us,
> -			   so we return EIO to let the user know.
> -			*/
> -
> -			value_len = entry->a_valuelen;
> -
> -			error = xfs_attr_get(XFS_I(inode), entry->a_name,
> -						(void *)(ulist + 1), &value_len,
> -						ATTR_ROOT);
> -			DM_EA_XLATE_ERR(error);
> -
> -			if (error || value_len != entry->a_valuelen) {
> -				error = EIO;
> -				break;
> -			}
> +	error = -xfs_attr_list_int(&context);
> +	ASSERT(error <= 0);
>  
> -			ulist = (dm_attrlist_t *)((char *)ulist + ulist->_link);
> -		}
> -	} while (!error && attrlist->al_more);
> -	if (last_link)
> -		*last_link = 0;
> -
> -	if (!error && total_size > buflen)
> -		error = E2BIG;
> -	if (!error || error == E2BIG) {
> -		if (put_user(total_size, rlenp))
> -			error = EFAULT;
> +	/*
> +	 * Count smaller zero means the iterator got an EFAULT.
> +	 *
> +	 * XXX(hch): we badly need a better way to deal with this, including
> +	 *	     passing and actual errno value back from the iterator.
> +	 */
> +	if (context.count < 0)
> +		return -EFAULT;
> +
> +	/*
> +	 * Terminate the list if we were successfull.
> +	 */
> +	if (context.last_link && put_user(0, context.last_link))
> +		return -EFAULT;
> +
> +	if (!error) {
> +		/*
> +		 * We still need to copy the count member to userspace in the
> +		 * case where there was not enough buffer space for the request.
> +		 *
> +		 * The ABI defines a count bigger as the passed in buffer length
> +		 * as indicator for requiring to call again with a bigger buffer.
> +		 */
> +		if (context.count > buflen)
> +			error = -E2BIG;
> +
> +		if (put_user(context.count, rlenp))
> +			error = -EFAULT;
>  	}
>  
> -	kmem_free(attrlist);
> -	return(-error); /* Return negative error to DMAPI */
> +	return error;
>  }
>  
> -
>  /* ARGSUSED */
>  STATIC int
>  xfs_dm_getall_inherit(
> Index: linux-2.6-xfs/fs/xfs/xfs_attr.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_attr.h	2008-06-03 09:56:25.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_attr.h	2008-06-03 11:45:11.000000000 +0200
> @@ -119,6 +119,7 @@ typedef struct xfs_attr_list_context {
>  	int				put_value;	/* T/F: need value for listent */
>  	put_listent_func_t		put_listent;	/* list output fmt function */
>  	int				index;		/* index into output buffer */
> +	int __user			*last_link;	/* list terminator */
>  } xfs_attr_list_context_t;
>  
>  
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-06-03 12:01:08.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-06-03 12:01:13.000000000 +0200
> @@ -262,7 +262,7 @@ EXPORT_SYMBOL(xfs_attr_get);
>  EXPORT_SYMBOL(xfs_attr_set);
>  EXPORT_SYMBOL(xfs_fsync);
>  EXPORT_SYMBOL(xfs_attr_remove);
> -EXPORT_SYMBOL(xfs_attr_list);
> +EXPORT_SYMBOL(xfs_attr_list_int);
>  EXPORT_SYMBOL(xfs_readdir);
>  EXPORT_SYMBOL(xfs_setsize_buftarg);
>  EXPORT_SYMBOL(xfs_syncsub);
> 
> 
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
