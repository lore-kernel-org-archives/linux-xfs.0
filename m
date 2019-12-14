Return-Path: <SRS0=IS9S=2E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BBCC43603
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 06:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 971E62465B
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 06:57:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bu0BOqUo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfLNG5u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Dec 2019 01:57:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58722 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfLNG5t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Dec 2019 01:57:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE6nlkL068698;
        Sat, 14 Dec 2019 06:57:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=wdVRGkN/V3hNJRal9oYfak7NrB/bHyFeiLQdz/yN/7c=;
 b=bu0BOqUoI1e/OCwNJyzEg25JP1HRM0EBmUqK4bxtCOGkDgAwfpM3EtZzD7dkdejce6FI
 432JvagBMmvSMnYs4ehIADuWzOYv/awmJpzxy9KaeTRwA/1b9v4vv7PjDUKm2HLduY9B
 4/v/wmBn7hu+/8P8IQmBmgWqyosXjStzO8xOlcwbZAy508ih5YIQcxF7e0+zIAyj49If
 OnKcni50S0NCDaET88OMNen9Ny4TwL1aUcpiQRxEhJq8wqVQrgKnhuTgvhlboDE7VihD
 OmvTZq5Le3tbCt6sfraKtcld2UIRuVUItIdp4KWOPavrhIbhy/bA/hCIH7GLkOLm0ncs tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wvqpprbb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 06:57:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE6sZkA098927;
        Sat, 14 Dec 2019 06:57:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wvqju99cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 06:57:45 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBE6vjFW004004;
        Sat, 14 Dec 2019 06:57:45 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 22:57:44 -0800
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v5 02/14] xfs: Replace attribute parameters with struct
 xfs_name
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-3-allison.henderson@oracle.com>
 <20191213130714.GB43376@bfoster>
Message-ID: <cd64e8ab-ccc7-fc09-1410-d877d90ac3af@oracle.com>
Date:   Fri, 13 Dec 2019 23:57:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191213130714.GB43376@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912140049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912140049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/13/19 6:07 AM, Brian Foster wrote:
> On Wed, Dec 11, 2019 at 09:15:01PM -0700, Allison Collins wrote:
>> This patch replaces the attribute name and length parameters with a
>> single struct xfs_name parameter.  This helps to clean up the numbers of
>> parameters being passed around and pre-simplifies the code some.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c  | 22 +++++++++-------------
>>   fs/xfs/libxfs/xfs_attr.h  | 12 +++++-------
>>   fs/xfs/libxfs/xfs_types.c | 10 ++++++++++
>>   fs/xfs/libxfs/xfs_types.h |  1 +
>>   fs/xfs/xfs_acl.c          | 27 +++++++++++++--------------
>>   fs/xfs/xfs_ioctl.c        | 23 +++++++++++++----------
>>   fs/xfs/xfs_iops.c         |  6 +++---
>>   fs/xfs/xfs_xattr.c        | 23 +++++++++++++----------
>>   8 files changed, 67 insertions(+), 57 deletions(-)
>>
> ...
>> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
>> index 4f59554..c81a904 100644
>> --- a/fs/xfs/libxfs/xfs_types.c
>> +++ b/fs/xfs/libxfs/xfs_types.c
>> @@ -12,6 +12,16 @@
>>   #include "xfs_bit.h"
>>   #include "xfs_mount.h"
>>   
>> +/* Initialize a struct xfs_name with a null terminated string name */
>> +void
>> +xfs_name_init(
>> +	struct xfs_name *xname,
>> +	const char *name)
>> +{
>> +	xname->name = name;
>> +	xname->len = (strlen(name));
> 
> Are the extra braces necessary here? Also, perhaps we should initialize
> ->type to zero or something so it doesn't carry garbage data.
I may have borrowed the extra braces from somewhere else in the code. 
Will clean out and also add the type init.

> 
>> +}
>> +
>>   /* Find the size of the AG, in blocks. */
>>   xfs_agblock_t
>>   xfs_ag_block_count(
> ...
>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>> index b58e18c..7b0e5b7 100644
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
>> +		name.name = SGI_ACL_FILE;
>>   		break;
>>   	case ACL_TYPE_DEFAULT:
>> -		ea_name = SGI_ACL_DEFAULT;
>> +		name.name = SGI_ACL_DEFAULT;
>>   		break;
>>   	default:
>>   		BUG();
>> @@ -145,9 +145,9 @@ xfs_get_acl(struct inode *inode, int type)
>>   	 * go out to the disk.
>>   	 */
>>   	len = XFS_ACL_MAX_SIZE(ip->i_mount);
>> -	error = xfs_attr_get(ip, ea_name, strlen(ea_name),
>> -				(unsigned char **)&xfs_acl, &len,
>> -				ATTR_ALLOC | ATTR_ROOT);
>> +	xfs_name_init(&name, name.name);
> 
> Could we call xfs_name_init() in the switch branches above to avoid this
> partial init weirdness? Same question applies below, otherwise looks Ok
> to me.
> 
> Brian
Sure, I will scoot that up.  Thx!
Allison

> 
>> +	error = xfs_attr_get(ip, &name, (unsigned char **)&xfs_acl, &len,
>> +			     ATTR_ALLOC | ATTR_ROOT);
>>   	if (error) {
>>   		/*
>>   		 * If the attribute doesn't exist make sure we have a negative
>> @@ -167,17 +167,17 @@ int
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
>> @@ -197,17 +197,16 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>>   		len -= sizeof(struct xfs_acl_entry) *
>>   			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
>>   
>> -		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
>> -				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
>> +		xfs_name_init(&name, name.name);
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
>> index f5a9bf9..4fc8698 100644
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
>> index 1f1601f..5623682 100644
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
>> @@ -78,9 +82,8 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
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
> 
