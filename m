Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41942 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfHLT1f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:27:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJEY7H126477
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:27:34 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u9nvp1r4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:27:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJDLrA148085
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:27:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u9n9h87g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:27:32 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CJRW6J029260
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:27:32 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 02/18] xfs: Replace attribute parameters with struct
 xfs_name
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-3-allison.henderson@oracle.com>
 <20190812151316.GR7138@magnolia>
Message-ID: <5e3edde9-7127-ed91-41aa-5b4bc2683ef1@oracle.com>
Date: Mon, 12 Aug 2019 12:27:31 -0700
MIME-Version: 1.0
In-Reply-To: <20190812151316.GR7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 8/12/19 8:13 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:10PM -0700, Allison Collins wrote:
>> This patch replaces the attribute name, length and flags parameters with a
>> single struct xfs_name parameter.  This helps to clean up the numbers of
>> parameters being passed around and pre-simplifies the code some.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 40 ++++++++++++++++------------------------
>>   fs/xfs/libxfs/xfs_attr.h | 12 +++++-------
>>   fs/xfs/xfs_acl.c         | 26 +++++++++++++-------------
>>   fs/xfs/xfs_ioctl.c       | 26 ++++++++++++++++----------
>>   fs/xfs/xfs_iops.c        | 10 ++++++----
>>   fs/xfs/xfs_xattr.c       | 21 +++++++++------------
>>   6 files changed, 65 insertions(+), 70 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 7761925..0c91116 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -61,9 +61,7 @@ STATIC int
>>   xfs_attr_args_init(
>>   	struct xfs_da_args	*args,
>>   	struct xfs_inode	*dp,
>> -	const unsigned char	*name,
>> -	size_t			namelen,
>> -	int			flags)
>> +	struct xfs_name		*name)
>>   {
>>   
>>   	if (!name)
>> @@ -73,9 +71,9 @@ xfs_attr_args_init(
>>   	args->geo = dp->i_mount->m_attr_geo;
>>   	args->whichfork = XFS_ATTR_FORK;
>>   	args->dp = dp;
>> -	args->flags = flags;
>> -	args->name = name;
>> -	args->namelen = namelen;
>> +	args->flags = name->type;
>> +	args->name = name->name;
>> +	args->namelen = name->len;
> 
> /me wonders if you ought to just have an xfs_name embedded in the
> xfs_da_args struct, seeing as the directory code uses it too.
> 
Sure, that seems reasonable

>>   	if (args->namelen >= MAXNAMELEN)
>>   		return -EFAULT;		/* match IRIX behaviour */
>>   
> 
> <skipping a bunch of changes that look fine to me>
> 
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index b1b7b1b..bdf925c 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -46,13 +46,15 @@ xfs_initxattrs(
>>   {
>>   	const struct xattr	*xattr;
>>   	struct xfs_inode	*ip = XFS_I(inode);
>> +	struct xfs_name		name;
>>   	int			error = 0;
>>   
>>   	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
>> -		error = xfs_attr_set(ip, xattr->name,
>> -				     strlen(xattr->name),
>> -				     xattr->value, xattr->value_len,
>> -				     ATTR_SECURE);
>> +		name.name = xattr->name;
>> +		name.len = strlen(xattr->name);
>> +		name.type = ATTR_SECURE;
> 
> You might as well declare and initialize name in the loop body.
Ok, I will pull that down in the loop.

> 
>> +		error = xfs_attr_set(ip, &name,
>> +				     xattr->value, xattr->value_len);
> 
> Does the attr value need a similar structure encapsulation too?

We can add one, though it's not particularly needed.  I had raised a 
similar question in the last review when this was proposed, but value 
isnt a const like name is, and I think people thought the abstraction 
was getting to be a little too much.  I think Dave had suggested using 
the struct xfs_name because it was already here and sort of documents 
what we're passing around, so it was an easy way of cleaning up some of 
the arguments.

> 
>>   		if (error < 0)
>>   			break;
>>   	}
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index fe12d11..3c63930 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -20,18 +20,17 @@ static int
>>   xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>>   		struct inode *inode, const char *name, void *value, size_t size)
>>   {
>> -	int xflags = handler->flags;
>>   	struct xfs_inode *ip = XFS_I(inode);
>>   	int error, asize = size;
>> -	size_t namelen = strlen(name);
>> +	struct xfs_name xname = {name, strlen(name), handler->flags};
> 
> I think the preferred format for this is to use the structure field
> names explicity during assignment...
> 
> 	struct xfs_name		xname = {
> 		.name		= name,
> 		.namelen	= strlen(name),
> 		.type		= handler->flags,
> 	};
> 
> Also, please fix the variable/argument declaration indentation style of
> this function to match the rest of xfs. :)
> 
Sure, will do.

Allison

> --D
> 
>>   
>>   	/* Convert Linux syscall to XFS internal ATTR flags */
>>   	if (!size) {
>> -		xflags |= ATTR_KERNOVAL;
>> +		xname.type |= ATTR_KERNOVAL;
>>   		value = NULL;
>>   	}
>>   
>> -	error = xfs_attr_get(ip, name, namelen, value, &asize, xflags);
>> +	error = xfs_attr_get(ip, &xname, value, &asize);
>>   	if (error)
>>   		return error;
>>   	return asize;
>> @@ -64,23 +63,21 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>>   		struct inode *inode, const char *name, const void *value,
>>   		size_t size, int flags)
>>   {
>> -	int			xflags = handler->flags;
>>   	struct xfs_inode	*ip = XFS_I(inode);
>>   	int			error;
>> -	size_t			namelen = strlen(name);
>> +	struct xfs_name		xname = {name, strlen(name), handler->flags};
>>   
>>   	/* Convert Linux syscall to XFS internal ATTR flags */
>>   	if (flags & XATTR_CREATE)
>> -		xflags |= ATTR_CREATE;
>> +		xname.type |= ATTR_CREATE;
>>   	if (flags & XATTR_REPLACE)
>> -		xflags |= ATTR_REPLACE;
>> +		xname.type |= ATTR_REPLACE;
>>   
>>   	if (!value)
>> -		return xfs_attr_remove(ip, name,
>> -				       namelen, xflags);
>> -	error = xfs_attr_set(ip, name, namelen, (void *)value, size, xflags);
>> +		return xfs_attr_remove(ip, &xname);
>> +	error = xfs_attr_set(ip, &xname, (void *)value, size);
>>   	if (!error)
>> -		xfs_forget_acl(inode, name, xflags);
>> +		xfs_forget_acl(inode, name, xname.type);
>>   
>>   	return error;
>>   }
>> -- 
>> 2.7.4
>>
