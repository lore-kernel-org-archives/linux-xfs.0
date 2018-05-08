Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55640 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbeEHRBN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 13:01:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w48H1C8U101229
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:01:12 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2hs4k29jp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 17:01:12 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w48H1Bh3017573
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:01:11 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w48H1BGE023865
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 17:01:11 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 06/21] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-7-git-send-email-allison.henderson@oracle.com>
 <20180507225928.GP11261@magnolia>
Message-ID: <21bbd18e-5daf-b2c8-1013-56e2d3c445d0@oracle.com>
Date: Tue, 8 May 2018 10:01:10 -0700
MIME-Version: 1.0
In-Reply-To: <20180507225928.GP11261@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 05/07/2018 03:59 PM, Darrick J. Wong wrote:
> On Sun, May 06, 2018 at 10:24:39AM -0700, Allison Henderson wrote:
>> These routines set up set and start a new deferred attribute
>> operation.  These functions are meant to be called by other
>> code needing to initiate a deferred attribute operation.  We
>> will use these routines later in the parent pointer patches.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr.h |  5 ++++
>>   2 files changed, 74 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 2f295ca..adbcef2 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -468,6 +468,42 @@ xfs_attr_set(
>>   	return error;
>>   }
>>   
>> +/* Sets an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_set_deferred(
>> +	struct xfs_inode	*dp,
>> +	struct xfs_defer_ops    *dfops,
>> +	void			*name,
>> +	unsigned int		namelen,
>> +	void			*value,
>> +	unsigned int		valuelen,
>> +	int			flags)
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +	char			*name_value;
>> +
>> +	if (!namelen || !valuelen) {
>> +		ASSERT(0);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, valuelen),
>> +			 KM_SLEEP|KM_NOFS);
>> +	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
>> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, valuelen));
>> +	new->xattri_ip = dp;
>> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_SET;
>> +	new->xattri_name_len = namelen;
>> +	new->xattri_value_len = valuelen;
>> +	new->xattri_flags = flags;
>> +	memcpy(&name_value[0], name, namelen);
>> +	memcpy(&name_value[namelen], value, valuelen);
> 
> If we're going to keep the inode locked across _defer_finish rolls then
> we need to xfs_defer_ijoin the inode to the dfops so that the inode is
> relogged in each transaction, which prevents the log tail from being
> pinned unnecessarily.  xfs_bmap.c does a similar thing with the deferred
> map/unmap intents.
> 
>> +
>> +	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>>   
>>   /*
>>    * Generic handler routine to remove a name from an attribute list.
>> @@ -560,6 +596,39 @@ xfs_attr_remove(
>>   	return error;
>>   }
>>   
>> +/* Removes an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_remove_deferred(
>> +	struct xfs_inode        *dp,
>> +	struct xfs_defer_ops    *dfops,
>> +	void			*name,
>> +	unsigned int		namelen,
>> +	int                     flags)
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +	char			*name_value;
>> +
>> +	if (!namelen) {
>> +		ASSERT(0);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, 0), KM_SLEEP|KM_NOFS);
>> +	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
>> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, 0));
>> +	new->xattri_ip = dp;
>> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_REMOVE;
>> +	new->xattri_name_len = namelen;
>> +	new->xattri_value_len = 0;
>> +	new->xattri_flags = flags;
>> +	memcpy(name_value, name, namelen);
> 
> Same here.
> 
> --D

Ok, I will add in the xfs_defer_ijoin's.  Thx!

Allison
> 
>> +	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>> +
>>   /*========================================================================
>>    * External routines when attribute list is inside the inode
>>    *========================================================================*/
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 33b33d3..ec26565 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -183,5 +183,10 @@ int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>   int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
>>   		       const unsigned char *name, int flags);
>>   int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>> +int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
>> +			  void *name, unsigned int name_len, void *value,
>> +			  unsigned int valuelen, int flags);
>> +int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
>> +			    void *name, unsigned int namelen, int flags);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
