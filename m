Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0819C3435E
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3201E246AF
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:37:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="grYsLsE2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfLMNHV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 08:07:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46909 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727220AbfLMNHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 08:07:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576242439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vekp5VCEc6SdyvO4QyO7n2ppI8XC+3DxE9HLndjBnHM=;
        b=grYsLsE2cE6IBLro6+Z4y2aCsVID7//800Ew4BL4U2kzXEW3tkmFIG8hQqYU7sYxJBQW6r
        PzY8M180xAJ13Wd+eB0kjL2jvGN1tZXd4/FSLCBDd5cumO65FJ0454o6T5DT3+nUAZUhlC
        KGnFhZiFDTXAPafDXuY1W41HLUNA/1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-gE6PNWy4N1mwEEJf45N79Q-1; Fri, 13 Dec 2019 08:07:16 -0500
X-MC-Unique: gE6PNWy4N1mwEEJf45N79Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4C0A1005512;
        Fri, 13 Dec 2019 13:07:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6914210013A1;
        Fri, 13 Dec 2019 13:07:15 +0000 (UTC)
Date:   Fri, 13 Dec 2019 08:07:14 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 02/14] xfs: Replace attribute parameters with struct
 xfs_name
Message-ID: <20191213130714.GB43376@bfoster>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-3-allison.henderson@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:15:01PM -0700, Allison Collins wrote:
> This patch replaces the attribute name and length parameters with a
> single struct xfs_name parameter.  This helps to clean up the numbers of
> parameters being passed around and pre-simplifies the code some.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c  | 22 +++++++++-------------
>  fs/xfs/libxfs/xfs_attr.h  | 12 +++++-------
>  fs/xfs/libxfs/xfs_types.c | 10 ++++++++++
>  fs/xfs/libxfs/xfs_types.h |  1 +
>  fs/xfs/xfs_acl.c          | 27 +++++++++++++--------------
>  fs/xfs/xfs_ioctl.c        | 23 +++++++++++++----------
>  fs/xfs/xfs_iops.c         |  6 +++---
>  fs/xfs/xfs_xattr.c        | 23 +++++++++++++----------
>  8 files changed, 67 insertions(+), 57 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index 4f59554..c81a904 100644
> --- a/fs/xfs/libxfs/xfs_types.c
> +++ b/fs/xfs/libxfs/xfs_types.c
> @@ -12,6 +12,16 @@
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
>  
> +/* Initialize a struct xfs_name with a null terminated string name */
> +void
> +xfs_name_init(
> +	struct xfs_name *xname,
> +	const char *name)
> +{
> +	xname->name = name;
> +	xname->len = (strlen(name));

Are the extra braces necessary here? Also, perhaps we should initialize
->type to zero or something so it doesn't carry garbage data.

> +}
> +
>  /* Find the size of the AG, in blocks. */
>  xfs_agblock_t
>  xfs_ag_block_count(
...
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index b58e18c..7b0e5b7 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -123,7 +123,7 @@ xfs_get_acl(struct inode *inode, int type)
>  	struct xfs_inode *ip = XFS_I(inode);
>  	struct posix_acl *acl = NULL;
>  	struct xfs_acl *xfs_acl = NULL;
> -	unsigned char *ea_name;
> +	struct xfs_name name;
>  	int error;
>  	int len;
>  
> @@ -131,10 +131,10 @@ xfs_get_acl(struct inode *inode, int type)
>  
>  	switch (type) {
>  	case ACL_TYPE_ACCESS:
> -		ea_name = SGI_ACL_FILE;
> +		name.name = SGI_ACL_FILE;
>  		break;
>  	case ACL_TYPE_DEFAULT:
> -		ea_name = SGI_ACL_DEFAULT;
> +		name.name = SGI_ACL_DEFAULT;
>  		break;
>  	default:
>  		BUG();
> @@ -145,9 +145,9 @@ xfs_get_acl(struct inode *inode, int type)
>  	 * go out to the disk.
>  	 */
>  	len = XFS_ACL_MAX_SIZE(ip->i_mount);
> -	error = xfs_attr_get(ip, ea_name, strlen(ea_name), 
> -				(unsigned char **)&xfs_acl, &len,
> -				ATTR_ALLOC | ATTR_ROOT);
> +	xfs_name_init(&name, name.name);

Could we call xfs_name_init() in the switch branches above to avoid this
partial init weirdness? Same question applies below, otherwise looks Ok
to me.

Brian

> +	error = xfs_attr_get(ip, &name, (unsigned char **)&xfs_acl, &len,
> +			     ATTR_ALLOC | ATTR_ROOT);
>  	if (error) {
>  		/*
>  		 * If the attribute doesn't exist make sure we have a negative
> @@ -167,17 +167,17 @@ int
>  __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
>  	struct xfs_inode *ip = XFS_I(inode);
> -	unsigned char *ea_name;
> +	struct xfs_name name;
>  	int error;
>  
>  	switch (type) {
>  	case ACL_TYPE_ACCESS:
> -		ea_name = SGI_ACL_FILE;
> +		name.name = SGI_ACL_FILE;
>  		break;
>  	case ACL_TYPE_DEFAULT:
>  		if (!S_ISDIR(inode->i_mode))
>  			return acl ? -EACCES : 0;
> -		ea_name = SGI_ACL_DEFAULT;
> +		name.name = SGI_ACL_DEFAULT;
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -197,17 +197,16 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  		len -= sizeof(struct xfs_acl_entry) *
>  			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
>  
> -		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
> -				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
> +		xfs_name_init(&name, name.name);
> +		error = xfs_attr_set(ip, &name, (unsigned char *)xfs_acl, len,
> +				     ATTR_ROOT);
>  
>  		kmem_free(xfs_acl);
>  	} else {
>  		/*
>  		 * A NULL ACL argument means we want to remove the ACL.
>  		 */
> -		error = xfs_attr_remove(ip, ea_name,
> -					strlen(ea_name),
> -					ATTR_ROOT);
> +		error = xfs_attr_remove(ip, &name, ATTR_ROOT);
>  
>  		/*
>  		 * If the attribute didn't exist to start with that's fine.
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f5a9bf9..4fc8698 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -357,7 +357,9 @@ xfs_attrmulti_attr_get(
>  {
>  	unsigned char		*kbuf;
>  	int			error = -EFAULT;
> -	size_t			namelen;
> +	struct xfs_name		xname;
> +
> +	xfs_name_init(&xname, name);
>  
>  	if (*len > XFS_XATTR_SIZE_MAX)
>  		return -EINVAL;
> @@ -365,9 +367,7 @@ xfs_attrmulti_attr_get(
>  	if (!kbuf)
>  		return -ENOMEM;
>  
> -	namelen = strlen(name);
> -	error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
> -			     flags);
> +	error = xfs_attr_get(XFS_I(inode), &xname, &kbuf, (int *)len, flags);
>  	if (error)
>  		goto out_kfree;
>  
> @@ -389,7 +389,9 @@ xfs_attrmulti_attr_set(
>  {
>  	unsigned char		*kbuf;
>  	int			error;
> -	size_t			namelen;
> +	struct xfs_name		xname;
> +
> +	xfs_name_init(&xname, name);
>  
>  	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  		return -EPERM;
> @@ -400,8 +402,7 @@ xfs_attrmulti_attr_set(
>  	if (IS_ERR(kbuf))
>  		return PTR_ERR(kbuf);
>  
> -	namelen = strlen(name);
> -	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
> +	error = xfs_attr_set(XFS_I(inode), &xname, kbuf, len, flags);
>  	if (!error)
>  		xfs_forget_acl(inode, name, flags);
>  	kfree(kbuf);
> @@ -415,12 +416,14 @@ xfs_attrmulti_attr_remove(
>  	uint32_t		flags)
>  {
>  	int			error;
> -	size_t			namelen;
> +	struct xfs_name		xname;
> +
> +	xfs_name_init(&xname, name);
>  
>  	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>  		return -EPERM;
> -	namelen = strlen(name);
> -	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
> +
> +	error = xfs_attr_remove(XFS_I(inode), &xname, flags);
>  	if (!error)
>  		xfs_forget_acl(inode, name, flags);
>  	return error;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 81f2f93..e85bbf5 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -48,11 +48,11 @@ xfs_initxattrs(
>  	const struct xattr	*xattr;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error = 0;
> +	struct xfs_name		name;
>  
>  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> -		error = xfs_attr_set(ip, xattr->name,
> -				     strlen(xattr->name),
> -				     xattr->value, xattr->value_len,
> +		xfs_name_init(&name, xattr->name);
> +		error = xfs_attr_set(ip, &name, xattr->value, xattr->value_len,
>  				     ATTR_SECURE);
>  		if (error < 0)
>  			break;
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 1f1601f..5623682 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -21,10 +21,12 @@ static int
>  xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  		struct inode *inode, const char *name, void *value, size_t size)
>  {
> -	int xflags = handler->flags;
> -	struct xfs_inode *ip = XFS_I(inode);
> -	int error, asize = size;
> -	size_t namelen = strlen(name);
> +	int			xflags = handler->flags;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	int			error, asize = size;
> +	struct xfs_name		xname;
> +
> +	xfs_name_init(&xname, name);
>  
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (!size) {
> @@ -32,8 +34,8 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  		value = NULL;
>  	}
>  
> -	error = xfs_attr_get(ip, name, namelen, (unsigned char **)&value,
> -			     &asize, xflags);
> +	error = xfs_attr_get(ip, &xname, (unsigned char **)&value, &asize,
> +			     xflags);
>  	if (error)
>  		return error;
>  	return asize;
> @@ -69,7 +71,9 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  	int			xflags = handler->flags;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
> -	size_t			namelen = strlen(name);
> +	struct xfs_name		xname;
> +
> +	xfs_name_init(&xname, name);
>  
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (flags & XATTR_CREATE)
> @@ -78,9 +82,8 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  		xflags |= ATTR_REPLACE;
>  
>  	if (!value)
> -		return xfs_attr_remove(ip, name,
> -				       namelen, xflags);
> -	error = xfs_attr_set(ip, name, namelen, (void *)value, size, xflags);
> +		return xfs_attr_remove(ip, &xname, xflags);
> +	error = xfs_attr_set(ip, &xname, (void *)value, size, xflags);
>  	if (!error)
>  		xfs_forget_acl(inode, name, xflags);
>  
> -- 
> 2.7.4
> 

