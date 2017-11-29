Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41432 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751709AbdK2SvC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Nov 2017 13:51:02 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vATIp1iY029834
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:51:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vATIp057019487
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:51:01 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vATIp04h003593
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 18:51:00 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v3 03/17] Add xfs_attr_set_defered and
 xfs_attr_remove_defered
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
 <1510942905-12897-4-git-send-email-allison.henderson@oracle.com>
 <20171128191932.GW21412@magnolia>
Message-ID: <48ed1f4c-b989-6308-dd3a-3f0639ac1ede@oracle.com>
Date: Wed, 29 Nov 2017 11:50:59 -0700
MIME-Version: 1.0
In-Reply-To: <20171128191932.GW21412@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 11/28/2017 12:19 PM, Darrick J. Wong wrote:

>> Subject: [PATCH v3 03/17] Add xfs_attr_set_defered and xfs_attr_remove_defered
> "deferred"
>
> On Fri, Nov 17, 2017 at 11:21:31AM -0700, Allison Henderson wrote:
>> These routines set up set and start a new deferred attribute
>> operation.  These functions are meant to be called by other
>> code needing to initiate a deferred attribute operation.  We
>> will use these routines later in the parent pointer patches.
>>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_attr.h        |  5 ++++
>>   2 files changed, 67 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 716df0f..68dc7e04 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -469,6 +469,40 @@ xfs_attr_set(
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
>> +	struct xfs_attr_item     *new;
>> +
>> +	ASSERT(namelen != 0);
>> +	ASSERT(valuelen != 0);
> We should stop the fs dead in its tracks here...
>
> if (!namelen || !valuelen) {
> 	ASSERT(0);
> 	return -EFSCORRUPTED;
> }
Sure.  I didnt think we continued to execute after a failed assert. Is 
the return statement reachable code?
>> +
>> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, valuelen),
>> +			 KM_SLEEP|KM_NOFS);
>> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, valuelen));
>> +	new->xattri_ip = dp;
>> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_SET;
>> +	new->xattri_name_len = namelen;
>> +	new->xattri_value_len = valuelen;
>> +	new->xattri_flags = flags;
>> +	memcpy(&new->xattri_name_value[0], name, namelen);
>> +	memcpy(&new->xattri_name_value[namelen],
>> +		value, valuelen);
>> +
>> +	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Generic handler routine to remove a name from an attribute list.
>>    * Transitions attribute list from Btree to shortform as necessary.
>> @@ -545,6 +579,34 @@ xfs_attr_remove(
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
>> +	struct xfs_attr_item     *new;
>> +
>> +	ASSERT(namelen != 0);
> Same here.
>
>> +
>> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, 0), KM_SLEEP|KM_NOFS);
>> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, 0));
>> +	new->xattri_ip = dp;
>> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_REMOVE;
>> +	new->xattri_name_len = namelen;
>> +	new->xattri_value_len = 0;
>> +	new->xattri_flags = flags;
>> +	memcpy(new->xattri_name_value, name, namelen);
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
>> index 3ef3c77..8d4762a 100644
>> --- a/fs/xfs/xfs_attr.h
>> +++ b/fs/xfs/xfs_attr.h
>> @@ -175,5 +175,10 @@ int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>   int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
>>   		       const unsigned char *name, int flags);
>>   int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>> +int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
>> +			  void *name, unsigned int name_len, void *value,
>> +			  unsigned int valuelen, int flags);
>> +int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_defer_ops *dfops,
>> +			    void *name, unsigned int namelen, int flags);
> All of these libxfs functions shouldn't be declared in a non-libxfs header.
>
> --D
Ok, will move
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=Fpc-kg8nx9R7V_S5rLB6cTd7Q1hPGawg1Rion2qvk80&s=5zlzFr8rSR1c82zQ0g7vWVkvwHPG0JH4nii6W8HUe9M&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttps://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=Fpc-kg8nx9R7V_S5rLB6cTd7Q1hPGawg1Rion2qvk80&s=5zlzFr8rSR1c82zQ0g7vWVkvwHPG0JH4nii6W8HUe9M&e=

