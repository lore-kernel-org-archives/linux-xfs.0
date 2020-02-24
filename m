Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E67C11D2F
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 16:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAA532080D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 16:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pF2vgVDw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgBXQ0B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:26:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58308 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgBXQ0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 11:26:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OG7gfM114459;
        Mon, 24 Feb 2020 16:25:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qTe7KTmJrKNIQgMZR0CSsImS07MRnvSXH7gx+pqVzd4=;
 b=pF2vgVDwhgDFR397yCEY1yXrhsTx+X1ut8q9FbcQnkeSRuFu+xpjpgx2PEd0UkNhGFMv
 2UFbRNmDdKDKfq67Ou4EFXXvPCxk9wwnqI45GnOGHVc0qHg2OnHQiX4PWHT/pJbluNLQ
 Agr4nBdMR83m7ZiE4+51Dr7EZSEdMlOafzLeg/UN3Gt5ON8huWflzVuK+QlwVDey2oXa
 2+5Fbx9TaoH4+a2o6xZF6oBOmmOYzWR8FCMduMOXLX2yQkTHZKRuVfjg17hSV+XbR3RA
 HaDnNiwcqW8KPM+Ev/f8UiJC3yjLQMWEI/SKYyMfaPVpnKd+Ns4iTRE33yfcBvJBQPIS sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ybvr4mqf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 16:25:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OG86gA193169;
        Mon, 24 Feb 2020 16:25:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yby5cnndh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 16:25:56 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01OGPu0D000834;
        Mon, 24 Feb 2020 16:25:56 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 08:25:55 -0800
Subject: Re: [PATCH v7 01/19] xfs: Replace attribute parameters with struct
 xfs_name
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-2-allison.henderson@oracle.com>
 <20200224130632.GA15761@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <5ff5aa57-d1ef-6be2-8e87-1e6ef1c479da@oracle.com>
Date:   Mon, 24 Feb 2020 09:25:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200224130632.GA15761@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=2 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1011 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=2 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/20 6:06 AM, Brian Foster wrote:
> On Sat, Feb 22, 2020 at 07:05:53PM -0700, Allison Collins wrote:
>> This patch replaces the attribute name and length parameters with a single struct
>> xfs_name parameter.  This helps to clean up the numbers of parameters being passed
>> around and pre-simplifies the code some.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> Looks fine to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Great!  Thanks for the reviews!

Allison

> 
>>   fs/xfs/libxfs/xfs_attr.c  | 22 +++++++++-------------
>>   fs/xfs/libxfs/xfs_attr.h  | 12 +++++-------
>>   fs/xfs/libxfs/xfs_types.c | 11 +++++++++++
>>   fs/xfs/libxfs/xfs_types.h |  1 +
>>   fs/xfs/xfs_acl.c          | 25 +++++++++++--------------
>>   fs/xfs/xfs_ioctl.c        | 23 +++++++++++++----------
>>   fs/xfs/xfs_iops.c         |  6 +++---
>>   fs/xfs/xfs_xattr.c        | 28 ++++++++++++++++------------
>>   8 files changed, 69 insertions(+), 59 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index e614972..6717f47 100644
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
>> index 4243b22..35043db 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -147,14 +147,12 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
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
>> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
>> index 4f59554..781a5a9 100644
>> --- a/fs/xfs/libxfs/xfs_types.c
>> +++ b/fs/xfs/libxfs/xfs_types.c
>> @@ -12,6 +12,17 @@
>>   #include "xfs_bit.h"
>>   #include "xfs_mount.h"
>>   
>> +/* Initialize a struct xfs_name with a null terminated string name */
>> +void
>> +xfs_name_init(
>> +	struct xfs_name *xname,
>> +	const char *name)
>> +{
>> +	xname->name = (unsigned char *)name;
>> +	xname->len = strlen(name);
>> +	xname->type = 0;
>> +}
>> +
>>   /* Find the size of the AG, in blocks. */
>>   xfs_agblock_t
>>   xfs_ag_block_count(
>> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
>> index 397d947..b94acb5 100644
>> --- a/fs/xfs/libxfs/xfs_types.h
>> +++ b/fs/xfs/libxfs/xfs_types.h
>> @@ -180,6 +180,7 @@ enum xfs_ag_resv_type {
>>    */
>>   struct xfs_mount;
>>   
>> +void xfs_name_init(struct xfs_name *xname, const char *name);
>>   xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
>>   bool xfs_verify_agbno(struct xfs_mount *mp, xfs_agnumber_t agno,
>>   		xfs_agblock_t agbno);
>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>> index cd743fad..42ac847 100644
>> --- a/fs/xfs/xfs_acl.c
>> +++ b/fs/xfs/xfs_acl.c
>> @@ -123,7 +123,7 @@ xfs_get_acl(struct inode *inode, int type)
>>   	struct xfs_inode *ip = XFS_I(inode);
>>   	struct posix_acl *acl = NULL;
>>   	struct xfs_acl *xfs_acl = NULL;
>> -	unsigned char *ea_name;
>> +	struct xfs_name name;
>>   	int error;
>>   	int len;
>>   
>> @@ -131,10 +131,10 @@ xfs_get_acl(struct inode *inode, int type)
>>   
>>   	switch (type) {
>>   	case ACL_TYPE_ACCESS:
>> -		ea_name = SGI_ACL_FILE;
>> +		xfs_name_init(&name, SGI_ACL_FILE);
>>   		break;
>>   	case ACL_TYPE_DEFAULT:
>> -		ea_name = SGI_ACL_DEFAULT;
>> +		xfs_name_init(&name, SGI_ACL_DEFAULT);
>>   		break;
>>   	default:
>>   		BUG();
>> @@ -145,9 +145,8 @@ xfs_get_acl(struct inode *inode, int type)
>>   	 * go out to the disk.
>>   	 */
>>   	len = XFS_ACL_MAX_SIZE(ip->i_mount);
>> -	error = xfs_attr_get(ip, ea_name, strlen(ea_name),
>> -				(unsigned char **)&xfs_acl, &len,
>> -				ATTR_ALLOC | ATTR_ROOT);
>> +	error = xfs_attr_get(ip, &name, (unsigned char **)&xfs_acl, &len,
>> +			     ATTR_ALLOC | ATTR_ROOT);
>>   	if (error) {
>>   		/*
>>   		 * If the attribute doesn't exist make sure we have a negative
>> @@ -167,17 +166,17 @@ int
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
>> +		xfs_name_init(&name, SGI_ACL_FILE);
>>   		break;
>>   	case ACL_TYPE_DEFAULT:
>>   		if (!S_ISDIR(inode->i_mode))
>>   			return acl ? -EACCES : 0;
>> -		ea_name = SGI_ACL_DEFAULT;
>> +		xfs_name_init(&name, SGI_ACL_DEFAULT);
>>   		break;
>>   	default:
>>   		return -EINVAL;
>> @@ -197,17 +196,15 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>>   		len -= sizeof(struct xfs_acl_entry) *
>>   			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
>>   
>> -		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
>> -				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
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
>>   
>>   		/*
>>   		 * If the attribute didn't exist to start with that's fine.
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index d42de92..28c07c9 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -357,7 +357,9 @@ xfs_attrmulti_attr_get(
>>   {
>>   	unsigned char		*kbuf;
>>   	int			error = -EFAULT;
>> -	size_t			namelen;
>> +	struct xfs_name		xname;
>> +
>> +	xfs_name_init(&xname, name);
>>   
>>   	if (*len > XFS_XATTR_SIZE_MAX)
>>   		return -EINVAL;
>> @@ -365,9 +367,7 @@ xfs_attrmulti_attr_get(
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
>> @@ -389,7 +389,9 @@ xfs_attrmulti_attr_set(
>>   {
>>   	unsigned char		*kbuf;
>>   	int			error;
>> -	size_t			namelen;
>> +	struct xfs_name		xname;
>> +
>> +	xfs_name_init(&xname, name);
>>   
>>   	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
>>   		return -EPERM;
>> @@ -400,8 +402,7 @@ xfs_attrmulti_attr_set(
>>   	if (IS_ERR(kbuf))
>>   		return PTR_ERR(kbuf);
>>   
>> -	namelen = strlen(name);
>> -	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
>> +	error = xfs_attr_set(XFS_I(inode), &xname, kbuf, len, flags);
>>   	if (!error)
>>   		xfs_forget_acl(inode, name, flags);
>>   	kfree(kbuf);
>> @@ -415,12 +416,14 @@ xfs_attrmulti_attr_remove(
>>   	uint32_t		flags)
>>   {
>>   	int			error;
>> -	size_t			namelen;
>> +	struct xfs_name		xname;
>> +
>> +	xfs_name_init(&xname, name);
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
>> index 81f2f93..e85bbf5 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -48,11 +48,11 @@ xfs_initxattrs(
>>   	const struct xattr	*xattr;
>>   	struct xfs_inode	*ip = XFS_I(inode);
>>   	int			error = 0;
>> +	struct xfs_name		name;
>>   
>>   	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
>> -		error = xfs_attr_set(ip, xattr->name,
>> -				     strlen(xattr->name),
>> -				     xattr->value, xattr->value_len,
>> +		xfs_name_init(&name, xattr->name);
>> +		error = xfs_attr_set(ip, &name, xattr->value, xattr->value_len,
>>   				     ATTR_SECURE);
>>   		if (error < 0)
>>   			break;
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index b0fedb5..74133a5 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -21,10 +21,12 @@ static int
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
>> +	struct xfs_name		xname;
>> +
>> +	xfs_name_init(&xname, name);
>>   
>>   	/* Convert Linux syscall to XFS internal ATTR flags */
>>   	if (!size) {
>> @@ -32,8 +34,8 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
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
>> @@ -69,7 +71,9 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>>   	int			xflags = handler->flags;
>>   	struct xfs_inode	*ip = XFS_I(inode);
>>   	int			error;
>> -	size_t			namelen = strlen(name);
>> +	struct xfs_name		xname;
>> +
>> +	xfs_name_init(&xname, name);
>>   
>>   	/* Convert Linux syscall to XFS internal ATTR flags */
>>   	if (flags & XATTR_CREATE)
>> @@ -77,11 +81,11 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>>   	if (flags & XATTR_REPLACE)
>>   		xflags |= ATTR_REPLACE;
>>   
>> -	if (value)
>> -		error = xfs_attr_set(ip, name, namelen, (void *)value, size,
>> -				xflags);
>> -	else
>> -		error = xfs_attr_remove(ip, name, namelen, xflags);
>> +        if (value)
>> +               error = xfs_attr_set(ip, &xname, (void *)value, size, xflags);
>> +        else
>> +               error = xfs_attr_remove(ip, &xname, xflags);
>> +
>>   	if (!error)
>>   		xfs_forget_acl(inode, name, xflags);
>>   
>> -- 
>> 2.7.4
>>
> 
