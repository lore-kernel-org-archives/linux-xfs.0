Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Jun 2008 21:40:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m564eZ8V017276
	for <xfs@oss.sgi.com>; Thu, 5 Jun 2008 21:40:38 -0700
Message-ID: <4848BFE8.6000205@sgi.com>
Date: Fri, 06 Jun 2008 14:41:12 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] simplify xfs_vn_listxattr
References: <20080603114837.GB2703@lst.de>
In-Reply-To: <20080603114837.GB2703@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

>  
>  	/*
>  	 * Then add the two synthetic ACL attributes.
> @@ -265,7 +316,7 @@ xfs_vn_listxattr(struct dentry *dentry, 
>  	if (xfs_acl_vhasacl_access(inode)) {
>  		error = list_one_attr(POSIX_ACL_XATTR_ACCESS,
>  				strlen(POSIX_ACL_XATTR_ACCESS) + 1,
> -				data, size, &result);
> +				data, size, &context.count);
>  		if (error)
>  			return error;
>  	}
> @@ -273,10 +324,10 @@ xfs_vn_listxattr(struct dentry *dentry, 
>  	if (xfs_acl_vhasacl_default(inode)) {
>  		error = list_one_attr(POSIX_ACL_XATTR_DEFAULT,
>  				strlen(POSIX_ACL_XATTR_DEFAULT) + 1,
> -				data, size, &result);
> +				data, size, &context.count);
>  		if (error)

Need to fix param type.

re:

static int
list_one_attr(const char *name, const size_t len, void *data,
                size_t size, ssize_t *result)

typedef struct xfs_attr_list_context {
        struct xfs_inode                *dp;            /* inode */
        struct attrlist_cursor_kern     *cursor;        /* position in list */
        char                            *alist;         /* output buffer */
        int                             seen_enough;    /* T/F: seen enough of list? */
        int                             count;          /* num used entries */

=> mismatch type on &context.count (int) and list_one_attr's result
param (ssize_t => long)

--Tim
