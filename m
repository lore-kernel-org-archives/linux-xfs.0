Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37634 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbfDOULD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 16:11:03 -0400
Subject: Re: [PATCH 1/9] xfs: Remove all strlen in all xfs_attr_* functions
 for attr names.
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-2-allison.henderson@oracle.com>
 <20190414230259.GE29573@dread.disaster.area>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c2ef788f-223c-a31d-566b-f3c185ff0a06@oracle.com>
Date: Mon, 15 Apr 2019 13:08:50 -0700
MIME-Version: 1.0
In-Reply-To: <20190414230259.GE29573@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 4/14/19 4:02 PM, Dave Chinner wrote:
> On Fri, Apr 12, 2019 at 03:50:28PM -0700, Allison Henderson wrote:
>> This helps to pre-simplify the extra handling of the null terminator in
>> delayed operations which use memcpy rather than strlen.  Later
>> when we introduce parent pointers, attribute names will become binary,
>> so strlen will not work at all.  Removing uses of strlen now will
>> help reduce complexities later
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hmmm. If we are going to pass name/namelen pairs around everywhere,
> can we convert these to a struct xfs_name?
> 
> I also wonder where we should convert the name/namelen pairs in the
> attr args struct to an xfs_name, too, then we can just do:
> 
> 	args->name = *name;
> 
> to copy in the string pointer and the name length in one go.
> 
> And we might even be able to put the attribute flags (e.g.
> ATTR_ROOT) in the name.type field, and get rid of that parameter
> being passed around, too...
> 
> Cheers,
> 
> Dave.

I think a new struct xfs_name is reasonable.  Or maybe a general purpose 
xfs_array?  The value/valuelen parameters have a similar relation that 
could make use of that too.  How would people feel about something like 
this:

struct xfs_array {
	unsigned char *bytes;
	size_t		len;
}

struct xfs_attribute {
	struct xfs_array	name;
	int			flags;
}

We could add the value member in here too.  It tends to get passed 
around just as much with the exception of attr remove operations which 
only need the name.  I think changing the actual members of xfs_da_args 
should be another patch though, since that's a bigger change that 
affects a wider scope of code.  I can look into it though.

Also, do I still keep the old reviewed-by on the patch if the patch is 
still going through changes?  I have a few signed-off patches in the 
parent pointer set that have changed quite a bit since we've started too.

Thanks!
Allison

> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 12 ++++++++----
>>   fs/xfs/libxfs/xfs_attr.h |  9 ++++++---
>>   fs/xfs/xfs_acl.c         | 12 +++++++-----
>>   fs/xfs/xfs_ioctl.c       | 13 ++++++++++---
>>   fs/xfs/xfs_iops.c        |  6 ++++--
>>   fs/xfs/xfs_xattr.c       | 10 ++++++----
>>   6 files changed, 41 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 2dd9ee2..3da6b0d 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -67,6 +67,7 @@ xfs_attr_args_init(
>>   	struct xfs_da_args	*args,
>>   	struct xfs_inode	*dp,
>>   	const unsigned char	*name,
>> +	size_t			namelen,
>>   	int			flags)
>>   {
>>   
>> @@ -79,7 +80,7 @@ xfs_attr_args_init(
>>   	args->dp = dp;
>>   	args->flags = flags;
>>   	args->name = name;
>> -	args->namelen = strlen((const char *)name);
>> +	args->namelen = namelen;
>>   	if (args->namelen >= MAXNAMELEN)
>>   		return -EFAULT;		/* match IRIX behaviour */
>>   
>> @@ -125,6 +126,7 @@ int
>>   xfs_attr_get(
>>   	struct xfs_inode	*ip,
>>   	const unsigned char	*name,
>> +	size_t			namelen,
>>   	unsigned char		*value,
>>   	int			*valuelenp,
>>   	int			flags)
>> @@ -138,7 +140,7 @@ xfs_attr_get(
>>   	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>>   		return -EIO;
>>   
>> -	error = xfs_attr_args_init(&args, ip, name, flags);
>> +	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
>>   	if (error)
>>   		return error;
>>   
>> @@ -317,6 +319,7 @@ int
>>   xfs_attr_set(
>>   	struct xfs_inode	*dp,
>>   	const unsigned char	*name,
>> +	size_t			namelen,
>>   	unsigned char		*value,
>>   	int			valuelen,
>>   	int			flags)
>> @@ -333,7 +336,7 @@ xfs_attr_set(
>>   	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>>   		return -EIO;
>>   
>> -	error = xfs_attr_args_init(&args, dp, name, flags);
>> +	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
>>   	if (error)
>>   		return error;
>>   
>> @@ -425,6 +428,7 @@ int
>>   xfs_attr_remove(
>>   	struct xfs_inode	*dp,
>>   	const unsigned char	*name,
>> +	size_t			namelen,
>>   	int			flags)
>>   {
>>   	struct xfs_mount	*mp = dp->i_mount;
>> @@ -436,7 +440,7 @@ xfs_attr_remove(
>>   	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>>   		return -EIO;
>>   
>> -	error = xfs_attr_args_init(&args, dp, name, flags);
>> +	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
>>   	if (error)
>>   		return error;
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 2297d84..52f63dc 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -137,11 +137,14 @@ int xfs_attr_list_int(struct xfs_attr_list_context *);
>>   int xfs_inode_hasattr(struct xfs_inode *ip);
>>   int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
>>   int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
>> -		 unsigned char *value, int *valuelenp, int flags);
>> +		 size_t namelen, unsigned char *value, int *valuelenp,
>> +		 int flags);
>>   int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
>> -		 unsigned char *value, int valuelen, int flags);
>> +		 size_t namelen, unsigned char *value, int valuelen,
>> +		 int flags);
>>   int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
>> -int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
>> +int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
>> +		    size_t namelen, int flags);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>   		  int flags, struct attrlist_cursor_kern *cursor);
>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>> index 8039e35..142de8d 100644
>> --- a/fs/xfs/xfs_acl.c
>> +++ b/fs/xfs/xfs_acl.c
>> @@ -141,8 +141,8 @@ xfs_get_acl(struct inode *inode, int type)
>>   	if (!xfs_acl)
>>   		return ERR_PTR(-ENOMEM);
>>   
>> -	error = xfs_attr_get(ip, ea_name, (unsigned char *)xfs_acl,
>> -							&len, ATTR_ROOT);
>> +	error = xfs_attr_get(ip, ea_name, strlen(ea_name),
>> +			     (unsigned char *)xfs_acl, &len, ATTR_ROOT);
>>   	if (error) {
>>   		/*
>>   		 * If the attribute doesn't exist make sure we have a negative
>> @@ -192,15 +192,17 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>>   		len -= sizeof(struct xfs_acl_entry) *
>>   			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
>>   
>> -		error = xfs_attr_set(ip, ea_name, (unsigned char *)xfs_acl,
>> -				len, ATTR_ROOT);
>> +		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
>> +				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
>>   
>>   		kmem_free(xfs_acl);
>>   	} else {
>>   		/*
>>   		 * A NULL ACL argument means we want to remove the ACL.
>>   		 */
>> -		error = xfs_attr_remove(ip, ea_name, ATTR_ROOT);
>> +		error = xfs_attr_remove(ip, ea_name,
>> +					strlen(ea_name),
>> +					ATTR_ROOT);
>>   
>>   		/*
>>   		 * If the attribute didn't exist to start with that's fine.
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 6ecdbb3..ab341d6 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -437,6 +437,7 @@ xfs_attrmulti_attr_get(
>>   {
>>   	unsigned char		*kbuf;
>>   	int			error = -EFAULT;
>> +	size_t			namelen;
>>   
>>   	if (*len > XFS_XATTR_SIZE_MAX)
>>   		return -EINVAL;
>> @@ -444,7 +445,9 @@ xfs_attrmulti_attr_get(
>>   	if (!kbuf)
>>   		return -ENOMEM;
>>   
>> -	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
>> +	namelen = strlen(name);
>> +	error = xfs_attr_get(XFS_I(inode), name, namelen,
>> +			     kbuf, (int *)len, flags);
>>   	if (error)
>>   		goto out_kfree;
>>   
>> @@ -466,6 +469,7 @@ xfs_attrmulti_attr_set(
>>   {
>>   	unsigned char		*kbuf;
>>   	int			error;
>> +	size_t			namelen;
>>   
>>   	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>>   		return -EPERM;
>> @@ -476,7 +480,8 @@ xfs_attrmulti_attr_set(
>>   	if (IS_ERR(kbuf))
>>   		return PTR_ERR(kbuf);
>>   
>> -	error = xfs_attr_set(XFS_I(inode), name, kbuf, len, flags);
>> +	namelen = strlen(name);
>> +	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
>>   	if (!error)
>>   		xfs_forget_acl(inode, name, flags);
>>   	kfree(kbuf);
>> @@ -490,10 +495,12 @@ xfs_attrmulti_attr_remove(
>>   	uint32_t		flags)
>>   {
>>   	int			error;
>> +	size_t			namelen;
>>   
>>   	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>>   		return -EPERM;
>> -	error = xfs_attr_remove(XFS_I(inode), name, flags);
>> +	namelen = strlen(name);
>> +	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
>>   	if (!error)
>>   		xfs_forget_acl(inode, name, flags);
>>   	return error;
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index 74047bd..e73c21a 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -59,8 +59,10 @@ xfs_initxattrs(
>>   	int			error = 0;
>>   
>>   	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
>> -		error = xfs_attr_set(ip, xattr->name, xattr->value,
>> -				      xattr->value_len, ATTR_SECURE);
>> +		error = xfs_attr_set(ip, xattr->name,
>> +				     strlen(xattr->name),
>> +				     xattr->value, xattr->value_len,
>> +				     ATTR_SECURE);
>>   		if (error < 0)
>>   			break;
>>   	}
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index 9a63016..3013746 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -26,6 +26,7 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>>   	int xflags = handler->flags;
>>   	struct xfs_inode *ip = XFS_I(inode);
>>   	int error, asize = size;
>> +	size_t namelen = strlen(name);
>>   
>>   	/* Convert Linux syscall to XFS internal ATTR flags */
>>   	if (!size) {
>> @@ -33,7 +34,7 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>>   		value = NULL;
>>   	}
>>   
>> -	error = xfs_attr_get(ip, (unsigned char *)name, value, &asize, xflags);
>> +	error = xfs_attr_get(ip, name, namelen, value, &asize, xflags);
>>   	if (error)
>>   		return error;
>>   	return asize;
>> @@ -69,6 +70,7 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>>   	int			xflags = handler->flags;
>>   	struct xfs_inode	*ip = XFS_I(inode);
>>   	int			error;
>> +	size_t			namelen = strlen(name);
>>   
>>   	/* Convert Linux syscall to XFS internal ATTR flags */
>>   	if (flags & XATTR_CREATE)
>> @@ -77,9 +79,9 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>>   		xflags |= ATTR_REPLACE;
>>   
>>   	if (!value)
>> -		return xfs_attr_remove(ip, (unsigned char *)name, xflags);
>> -	error = xfs_attr_set(ip, (unsigned char *)name,
>> -				(void *)value, size, xflags);
>> +		return xfs_attr_remove(ip, name,
>> +				       namelen, xflags);
>> +	error = xfs_attr_set(ip, name, namelen, (void *)value, size, xflags);
>>   	if (!error)
>>   		xfs_forget_acl(inode, name, xflags);
>>   
>> -- 
>> 2.7.4
>>
>>
> 
