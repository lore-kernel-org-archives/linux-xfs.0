Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5635CC5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 17:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13DC720869
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 17:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W2sTH8E+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfKHRQ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 12:16:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41822 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfKHRQ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 12:16:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8HE5F4004447
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 17:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gk5OujNoloLVeglDAD+r5CWNJ+Fw6yRYPJdepG6FrpU=;
 b=W2sTH8E+/z/dnmj4yQcPm+I6HurtjhZB8iyLwHIMrP+IptidqRn8VaHbk0If8KM2eNs4
 hAUmLHozivWhJ3FYLrR2Fd5CKb60MmQrU0d5/GRuIDt9Dch5it9BeG9NICoSjS838cbY
 2s67CgAx85sS7zAPySQy8yR6K5HtuWKaDH0ZDVny0VMoXgIzsI+Z9IUtt+cLCRjYd9rq
 Koacls50fDEwuQSd7Or8KRJVlWz9eKfYtRVaSgOhjusNAJyl9xQ8EnpMoqtrFLyIeP6f
 +Gv/CvOkXULN+AgppjP81qEiH/cO/WjykjujRbhgK0Gp6YtMYqwiaVXzu8eQhowE3xts NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w41w1epd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 17:16:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8HDiMx173672
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 17:16:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w4k33asa8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 17:16:24 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA8HGN0Q014097
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 17:16:23 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 09:16:23 -0800
Subject: Re: [PATCH v4 02/17] xfs: Replace attribute parameters with struct
 xfs_name
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-3-allison.henderson@oracle.com>
 <20191108011358.GK6219@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2fed8720-290e-86ac-e300-081e0830f61e@oracle.com>
Date:   Fri, 8 Nov 2019 10:16:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108011358.GK6219@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/7/19 6:13 PM, Darrick J. Wong wrote:
> On Wed, Nov 06, 2019 at 06:27:46PM -0700, Allison Collins wrote:
>> This patch replaces the attribute name and length parameters with a
>> single struct xfs_name parameter.  This helps to clean up the numbers of
>> parameters being passed around and pre-simplifies the code some.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 22 +++++++++-------------
>>   fs/xfs/libxfs/xfs_attr.h | 12 +++++-------
>>   fs/xfs/xfs_acl.c         | 27 +++++++++++++--------------
>>   fs/xfs/xfs_ioctl.c       | 25 +++++++++++++++----------
>>   fs/xfs/xfs_iops.c        |  9 ++++++---
>>   fs/xfs/xfs_xattr.c       | 25 +++++++++++++++----------
>>   6 files changed, 63 insertions(+), 57 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 7589cb7..5a9624a 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -61,8 +61,7 @@ STATIC int
>>   xfs_attr_args_init(
>>   	struct xfs_da_args	*args,
>>   	struct xfs_inode	*dp,
>> -	const unsigned char	*name,
>> -	size_t			namelen,
>> +	struct xfs_name		*name,
>>   	int			flags)
>>   {
>>   
>> @@ -74,8 +73,8 @@ xfs_attr_args_init(
>>   	args->whichfork = XFS_ATTR_FORK;
>>   	args->dp = dp;
>>   	args->flags = flags;
>> -	args->name = name;
>> -	args->namelen = namelen;
>> +	args->name = name->name;
>> +	args->namelen = name->len;
>>   	if (args->namelen >= MAXNAMELEN)
>>   		return -EFAULT;		/* match IRIX behaviour */
>>   
>> @@ -139,8 +138,7 @@ xfs_attr_get_ilocked(
>>   int
>>   xfs_attr_get(
>>   	struct xfs_inode	*ip,
>> -	const unsigned char	*name,
>> -	size_t			namelen,
>> +	struct xfs_name		*name,
>>   	unsigned char		**value,
>>   	int			*valuelenp,
>>   	int			flags)
>> @@ -156,7 +154,7 @@ xfs_attr_get(
>>   	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>>   		return -EIO;
>>   
>> -	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
>> +	error = xfs_attr_args_init(&args, ip, name, flags);
>>   	if (error)
>>   		return error;
>>   
>> @@ -339,8 +337,7 @@ xfs_attr_remove_args(
>>   int
>>   xfs_attr_set(
>>   	struct xfs_inode	*dp,
>> -	const unsigned char	*name,
>> -	size_t			namelen,
>> +	struct xfs_name		*name,
>>   	unsigned char		*value,
>>   	int			valuelen,
>>   	int			flags)
>> @@ -356,7 +353,7 @@ xfs_attr_set(
>>   	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>>   		return -EIO;
>>   
>> -	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
>> +	error = xfs_attr_args_init(&args, dp, name, flags);
>>   	if (error)
>>   		return error;
>>   
>> @@ -444,8 +441,7 @@ xfs_attr_set(
>>   int
>>   xfs_attr_remove(
>>   	struct xfs_inode	*dp,
>> -	const unsigned char	*name,
>> -	size_t			namelen,
>> +	struct xfs_name		*name,
>>   	int			flags)
>>   {
>>   	struct xfs_mount	*mp = dp->i_mount;
>> @@ -457,7 +453,7 @@ xfs_attr_remove(
>>   	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>>   		return -EIO;
>>   
>> -	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
>> +	error = xfs_attr_args_init(&args, dp, name, flags);
>>   	if (error)
>>   		return error;
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 106a2f2..44dd07a 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -144,14 +144,12 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
>>   int xfs_attr_list_int(struct xfs_attr_list_context *);
>>   int xfs_inode_hasattr(struct xfs_inode *ip);
>>   int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
>> -int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
>> -		 size_t namelen, unsigned char **value, int *valuelenp,
>> -		 int flags);
>> -int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
>> -		 size_t namelen, unsigned char *value, int valuelen, int flags);
>> +int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
>> +		 unsigned char **value, int *valuelenp, int flags);
>> +int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
>> +		 unsigned char *value, int valuelen, int flags);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>> -int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
>> -		    size_t namelen, int flags);
>> +int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>   		  int flags, struct attrlist_cursor_kern *cursor);
>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>> index 12be708..e868755 100644
>> --- a/fs/xfs/xfs_acl.c
>> +++ b/fs/xfs/xfs_acl.c
>> @@ -113,7 +113,7 @@ xfs_get_acl(struct inode *inode, int type)
>>   	struct xfs_inode *ip = XFS_I(inode);
>>   	struct posix_acl *acl = NULL;
>>   	struct xfs_acl *xfs_acl = NULL;
>> -	unsigned char *ea_name;
>> +	struct xfs_name name;
>>   	int error;
>>   	int len;
>>   
>> @@ -121,10 +121,10 @@ xfs_get_acl(struct inode *inode, int type)
>>   
>>   	switch (type) {
>>   	case ACL_TYPE_ACCESS:
>> -		ea_name = SGI_ACL_FILE;
>> +		name.name = SGI_ACL_FILE;
>>   		break;
>>   	case ACL_TYPE_DEFAULT:
>> -		ea_name = SGI_ACL_DEFAULT;
>> +		name.name = SGI_ACL_DEFAULT;
>>   		break;
>>   	default:
>>   		BUG();
>> @@ -135,9 +135,9 @@ xfs_get_acl(struct inode *inode, int type)
>>   	 * go out to the disk.
>>   	 */
>>   	len = XFS_ACL_MAX_SIZE(ip->i_mount);
>> -	error = xfs_attr_get(ip, ea_name, strlen(ea_name),
>> -				(unsigned char **)&xfs_acl, &len,
>> -				ATTR_ALLOC | ATTR_ROOT);
>> +	name.len = strlen(name.name);
>> +	error = xfs_attr_get(ip, &name, (unsigned char **)&xfs_acl, &len,
>> +			     ATTR_ALLOC | ATTR_ROOT);
>>   	if (error) {
>>   		/*
>>   		 * If the attribute doesn't exist make sure we have a negative
>> @@ -157,17 +157,17 @@ int
>>   __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>>   {
>>   	struct xfs_inode *ip = XFS_I(inode);
>> -	unsigned char *ea_name;
>> +	struct xfs_name name;
>>   	int error;
>>   
>>   	switch (type) {
>>   	case ACL_TYPE_ACCESS:
>> -		ea_name = SGI_ACL_FILE;
>> +		name.name = SGI_ACL_FILE;
>>   		break;
>>   	case ACL_TYPE_DEFAULT:
>>   		if (!S_ISDIR(inode->i_mode))
>>   			return acl ? -EACCES : 0;
>> -		ea_name = SGI_ACL_DEFAULT;
>> +		name.name = SGI_ACL_DEFAULT;
>>   		break;
>>   	default:
>>   		return -EINVAL;
>> @@ -187,17 +187,16 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>>   		len -= sizeof(struct xfs_acl_entry) *
>>   			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
>>   
>> -		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
>> -				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
>> +		name.len = strlen(name.name);
> 
> /me wonders if you ought to write a helper function to initialize an
> xfs_name and calculate name->len instead of open coding it here
> because...
Ok, I think in one of the previous reviews we decided on an explicit 
struct initialization.  It works in most cases, but just couldn't be 
applied here because of the case handling.  I'm not sure how opinionated 
people really are about though?

> 
>> +		error = xfs_attr_set(ip, &name, (unsigned char *)xfs_acl, len,
>> +				     ATTR_ROOT);
>>   
>>   		kmem_free(xfs_acl);
>>   	} else {
>>   		/*
>>   		 * A NULL ACL argument means we want to remove the ACL.
>>   		 */
>> -		error = xfs_attr_remove(ip, ea_name,
>> -					strlen(ea_name),
>> -					ATTR_ROOT);
>> +		error = xfs_attr_remove(ip, &name, ATTR_ROOT);
> 
Ok, will fix.  Thanks for catch!

Allison

> ..I think name.len is uninitialized here?
> 
> --D
> 
>>   
>>   		/*
>>   		 * If the attribute didn't exist to start with that's fine.
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 269c321..ae0ed88 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -432,7 +432,10 @@ xfs_attrmulti_attr_get(
>>   {
>>   	unsigned char		*kbuf;
>>   	int			error = -EFAULT;
>> -	size_t			namelen;
>> +	struct xfs_name		xname = {
>> +		.name		= name,
>> +		.len		= strlen(name),
>> +	};
>>   
>>   	if (*len > XFS_XATTR_SIZE_MAX)
>>   		return -EINVAL;
>> @@ -440,9 +443,7 @@ xfs_attrmulti_attr_get(
>>   	if (!kbuf)
>>   		return -ENOMEM;
>>   
>> -	namelen = strlen(name);
>> -	error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
>> -			     flags);
>> +	error = xfs_attr_get(XFS_I(inode), &xname, &kbuf, (int *)len, flags);
>>   	if (error)
>>   		goto out_kfree;
>>   
>> @@ -464,7 +465,7 @@ xfs_attrmulti_attr_set(
>>   {
>>   	unsigned char		*kbuf;
>>   	int			error;
>> -	size_t			namelen;
>> +	struct xfs_name		xname;
>>   
>>   	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>>   		return -EPERM;
>> @@ -475,8 +476,9 @@ xfs_attrmulti_attr_set(
>>   	if (IS_ERR(kbuf))
>>   		return PTR_ERR(kbuf);
>>   
>> -	namelen = strlen(name);
>> -	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
>> +	xname.name = name;
>> +	xname.len = strlen(name);
>> +	error = xfs_attr_set(XFS_I(inode), &xname, kbuf, len, flags);
>>   	if (!error)
>>   		xfs_forget_acl(inode, name, flags);
>>   	kfree(kbuf);
>> @@ -490,12 +492,15 @@ xfs_attrmulti_attr_remove(
>>   	uint32_t		flags)
>>   {
>>   	int			error;
>> -	size_t			namelen;
>> +	struct xfs_name		xname = {
>> +		.name		= name,
>> +		.len		= strlen(name),
>> +	};
>>   
>>   	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>>   		return -EPERM;
>> -	namelen = strlen(name);
>> -	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
>> +
>> +	error = xfs_attr_remove(XFS_I(inode), &xname, flags);
>>   	if (!error)
>>   		xfs_forget_acl(inode, name, flags);
>>   	return error;
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index 7f47f87..aef346e 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -49,9 +49,12 @@ xfs_initxattrs(
>>   	int			error = 0;
>>   
>>   	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
>> -		error = xfs_attr_set(ip, xattr->name,
>> -				     strlen(xattr->name),
>> -				     xattr->value, xattr->value_len,
>> +		struct xfs_name	name = {
>> +			.name	= xattr->name,
>> +			.len	= strlen(xattr->name),
>> +		};
>> +
>> +		error = xfs_attr_set(ip, &name, xattr->value, xattr->value_len,
>>   				     ATTR_SECURE);
>>   		if (error < 0)
>>   			break;
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index 59ffe6c..6c5321d 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -20,10 +20,13 @@ static int
>>   xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>>   		struct inode *inode, const char *name, void *value, size_t size)
>>   {
>> -	int xflags = handler->flags;
>> -	struct xfs_inode *ip = XFS_I(inode);
>> -	int error, asize = size;
>> -	size_t namelen = strlen(name);
>> +	int			xflags = handler->flags;
>> +	struct xfs_inode	*ip = XFS_I(inode);
>> +	int			error, asize = size;
>> +	struct xfs_name		xname = {
>> +		.name		= name,
>> +		.len		= strlen(name),
>> +	};
>>   
>>   	/* Convert Linux syscall to XFS internal ATTR flags */
>>   	if (!size) {
>> @@ -31,8 +34,8 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>>   		value = NULL;
>>   	}
>>   
>> -	error = xfs_attr_get(ip, name, namelen, (unsigned char **)&value,
>> -			     &asize, xflags);
>> +	error = xfs_attr_get(ip, &xname, (unsigned char **)&value, &asize,
>> +			     xflags);
>>   	if (error)
>>   		return error;
>>   	return asize;
>> @@ -68,7 +71,10 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>>   	int			xflags = handler->flags;
>>   	struct xfs_inode	*ip = XFS_I(inode);
>>   	int			error;
>> -	size_t			namelen = strlen(name);
>> +	struct xfs_name		xname = {
>> +		.name		= name,
>> +		.len		= strlen(name),
>> +	};
>>   
>>   	/* Convert Linux syscall to XFS internal ATTR flags */
>>   	if (flags & XATTR_CREATE)
>> @@ -77,9 +83,8 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>>   		xflags |= ATTR_REPLACE;
>>   
>>   	if (!value)
>> -		return xfs_attr_remove(ip, name,
>> -				       namelen, xflags);
>> -	error = xfs_attr_set(ip, name, namelen, (void *)value, size, xflags);
>> +		return xfs_attr_remove(ip, &xname, xflags);
>> +	error = xfs_attr_set(ip, &xname, (void *)value, size, xflags);
>>   	if (!error)
>>   		xfs_forget_acl(inode, name, xflags);
>>   
>> -- 
>> 2.7.4
>>
