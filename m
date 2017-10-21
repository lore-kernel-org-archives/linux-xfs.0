Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41482 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753166AbdJUBJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 21:09:04 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9L1938i000837
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:09:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9L193QU023024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:09:03 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9L192iZ001655
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:09:02 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/17] Add xfs_attr_set_defered and
 xfs_attr_remove_defered
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <1508367333-3237-4-git-send-email-allison.henderson@oracle.com>
 <20171019191301.GD4755@magnolia>
Message-ID: <7380ab25-7a08-9e97-d75c-202e2f712bba@oracle.com>
Date: Fri, 20 Oct 2017 18:08:58 -0700
MIME-Version: 1.0
In-Reply-To: <20171019191301.GD4755@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org

On 10/19/2017 12:13 PM, Darrick J. Wong wrote:
> On Wed, Oct 18, 2017 at 03:55:19PM -0700, Allison Henderson wrote:
>> These routines set up set and start a new deferred attribute
>> operation.  These functions are meant to be called by other
>> code needing to initiate a deferred attribute operation.  We
>> will use these routines later in the parent pointer patches.
>>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_attr.h        |  7 ++++++
>>   2 files changed, 65 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 5325ec2..59f3502 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -458,6 +458,37 @@ xfs_attr_set(
>>   	return error;
>>   }
>>   
>> +int
>> +xfs_attr_set_deferred(
>> +	struct xfs_inode	*dp,
>> +	struct xfs_defer_ops    *dfops,
>> +	const unsigned char	*name,
>> +	unsigned int		namelen,
>> +	unsigned char		*value,
>> +	unsigned int		valuelen,
>> +	int			flags)
>> +{
>> +
>> +	struct xfs_attr_item     *new;
>> +
>> +	ASSERT(namelen != 0);
>> +	ASSERT(valuelen != 0);
>> +
>> +	new = kmem_alloc(sizeof(struct xfs_attr_item), KM_SLEEP|KM_NOFS);
> Yikes, this is a 66,000 byte allocation.  I wouldn't take it for granted
> that we can ask for more than a page's worth of memory.
>
> Seeing as we already know namelen and valuelen, let's go for the
> zero length array at the end of the struct approach:
>
> struct xfs_attr_item {
> 	...
> 	uint16_t		xattri_namelen;
> 	uint8_t			xattri_namevalue[0];
> };
>
> #define XFS_ATTR_ITEM_SIZEOF(namelen, valuelen)	\
> 	(sizeof(struct xfs_attr_item) + (namelen) + (valuelen))
>
> new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, valuelen), KM...);
> if (!new)
> 	return -ENOMEM;
> memcpy(new->xattri_namevalue, name, namelen);
> new->xattri_namelen = namelen;
> memcpy(&new->xattri_namevalue[namelen], value, valuelen);
> ...
Ok, yeah that makes sense.  Will do.
> Assuming there isn't a way to attach the caller's buffers to the attr
> item without copying anything(?)  (It would be nice if we could, but
> between the defer_add and the defer_finish a lot can happen w.r.t.
> variable scope so that might be a bad idea.)
>
>> +	memset(new, 0, sizeof(struct xfs_attr_item));
>> +	new->xattri_ino = dp->i_ino;
>> +	new->xattri_op_flags = ATTR_OP_FLAGS_SET;
>> +	new->xattri_name_len = namelen;
>> +	new->xattri_value_len = valuelen;
>> +	new->xattri_flags = flags;
>> +	memcpy(new->xattri_name, name, namelen);
>> +	memcpy(&new->xattri_value, value, valuelen);
>> +
>> +	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Generic handler routine to remove a name from an attribute list.
>>    * Transitions attribute list from Btree to shortform as necessary.
>> @@ -531,6 +562,33 @@ xfs_attr_remove(
>>   	return error;
>>   }
>>   
>> +int
>> +xfs_attr_remove_deferred(
>> +	struct xfs_inode        *dp,
>> +	struct xfs_defer_ops    *dfops,
>> +	const unsigned char     *name,
>> +	unsigned int		namelen,
>> +	int                     flags)
>> +{
>> +
>> +	struct xfs_attr_item     *new;
>> +
>> +	ASSERT(namelen != 0);
>> +
>> +	new = kmem_alloc(sizeof(struct xfs_attr_item), KM_SLEEP|KM_NOFS);
>> +	memset(new, 0, sizeof(struct xfs_attr_item));
>> +	new->xattri_ino = dp->i_ino;
>> +	new->xattri_op_flags = ATTR_OP_FLAGS_REMOVE;
>> +	new->xattri_name_len = namelen;
>> +	new->xattri_value_len = 0;
>> +	new->xattri_flags = flags;
>> +	memcpy(new->xattri_name, name, namelen);
>> +
>> +	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>> +
>>   /*========================================================================
>>    * External routines when attribute list is inside the inode
>>    *========================================================================*/
>> diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
>> index 34bb4cb..f4a53fd 100644
>> --- a/fs/xfs/xfs_attr.h
>> +++ b/fs/xfs/xfs_attr.h
>> @@ -173,5 +173,12 @@ int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>   int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
>>   		       const unsigned char *name, int flags);
>>   int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>> +int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
>> +			  const unsigned char *name, unsigned int name_len,
>> +			  unsigned char *value, unsigned int valuelen,
>> +			  int flags);
>> +int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
>> +			    const unsigned char *name, unsigned int namelen,
>> +			    int flags);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html

