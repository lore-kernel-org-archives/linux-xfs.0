Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43530 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfHLT3V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:29:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJE8lk113015
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:29:20 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u9pjq9n5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:29:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJDEJS092612
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:29:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u9m0agktq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:29:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CJTHuS030111
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:29:18 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 06/18] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-7-allison.henderson@oracle.com>
 <20190812160156.GU7138@magnolia>
Message-ID: <7959fdf2-f927-bb19-533f-fe9e98926959@oracle.com>
Date: Mon, 12 Aug 2019 12:29:16 -0700
MIME-Version: 1.0
In-Reply-To: <20190812160156.GU7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 8/12/19 9:01 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:14PM -0700, Allison Collins wrote:
>> Break xfs_attr_rmtval_set into two helper functions
>> xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
>> xfs_attr_rmtval_set rolls the transaction between the
>> helpers, but delayed operations cannot.  We will use
>> the helpers later when constructing new delayed
>> attribute routines.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 73 +++++++++++++++++++++++++++++++----------
>>   fs/xfs/libxfs/xfs_attr_remote.h |  4 ++-
>>   2 files changed, 58 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 4eb30d3..c421412 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -21,6 +21,7 @@
>>   #include "xfs_attr.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_error.h"
>> +#include "xfs_attr_remote.h"
>>   
>>   #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
>>   
>> @@ -430,34 +431,18 @@ xfs_attr_rmtval_set(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_mount	*mp = dp->i_mount;
>>   	struct xfs_bmbt_irec	map;
>>   	xfs_dablk_t		lblkno;
>>   	xfs_fileoff_t		lfileoff = 0;
>> -	uint8_t			*src = args->value;
>>   	int			blkcnt;
>> -	int			valuelen;
>>   	int			nmap;
>>   	int			error;
>> -	int			offset = 0;
>>   
>> -	trace_xfs_attr_rmtval_set(args);
>> -
>> -	/*
>> -	 * Find a "hole" in the attribute address space large enough for
>> -	 * us to drop the new attribute's value into. Because CRC enable
>> -	 * attributes have headers, we can't just do a straight byte to FSB
>> -	 * conversion and have to take the header space into account.
>> -	 */
>> -	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
>> -	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
>> -						   XFS_ATTR_FORK);
>> +	error = xfs_attr_rmt_find_hole(args, &blkcnt, &lfileoff);
>>   	if (error)
>>   		return error;
>>   
>> -	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
>> -	args->rmtblkcnt = blkcnt;
>> -
>> +	lblkno = (xfs_dablk_t)lfileoff;
>>   	/*
>>   	 * Roll through the "value", allocating blocks on disk as required.
>>   	 */
>> @@ -498,6 +483,58 @@ xfs_attr_rmtval_set(
>>   			return error;
>>   	}
>>   
>> +	error = xfs_attr_rmtval_set_value(args);
>> +	return error;
>> +}
>> +
>> +
>> +
> 
> Only need one blank line between functions.
Ok, will trim out

> 
>> +int
>> +xfs_attr_rmt_find_hole(
>> +	struct xfs_da_args	*args,
>> +	int			*blkcnt,
>> +	xfs_fileoff_t		*lfileoff)
>> +{
>> +	struct xfs_inode        *dp = args->dp;
>> +	struct xfs_mount	*mp = dp->i_mount;
>> +	int			error;
>> +
>> +	trace_xfs_attr_rmtval_set(args);
> 
> Shouldn't this be in the xfs_attr_rmtval_set_value function?
> We're not actually setting anything here, we're just looking for holes.
Yes, that would probably make more sense there.  :-)

> 
>> +
>> +	/*
>> +	 * Find a "hole" in the attribute address space large enough for
>> +	 * us to drop the new attribute's value into. Because CRC enable
> 
> This first sentence would make a lovely comment above this function
> telling us what it does.
Ok, that sounds good, I will move that up

> 
>> +	 * attributes have headers, we can't just do a straight byte to FSB
>> +	 * conversion and have to take the header space into account.
>> +	 */
>> +	*blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
> 
> Can the callers be refactored to use args->rmtblkcnt to eliminate the
> @blkcnt parameter?

Sure, I think that would be ok.  I'll see if I can clean that out.
Thanks!

Allison

> 
> --D
> 
>> +	error = xfs_bmap_first_unused(args->trans, args->dp, *blkcnt, lfileoff,
>> +						   XFS_ATTR_FORK);
>> +	if (error)
>> +		return error;
>> +
>> +	args->rmtblkno = (xfs_dablk_t)*lfileoff;
>> +	args->rmtblkcnt = *blkcnt;
>> +
>> +	return 0;
>> +}
>> +
>> +int
>> +xfs_attr_rmtval_set_value(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_mount	*mp = dp->i_mount;
>> +	struct xfs_bmbt_irec	map;
>> +	xfs_dablk_t		lblkno;
>> +	uint8_t			*src = args->value;
>> +	int			blkcnt;
>> +	int			valuelen;
>> +	int			nmap;
>> +	int			error;
>> +	int			offset = 0;
>> +
>> +
>>   	/*
>>   	 * Roll through the "value", copying the attribute value to the
>>   	 * already-allocated blocks.  Blocks are written synchronously
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 9d20b66..2a73cd9 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -11,5 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>>   int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> -
>> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args, int *blkcnt,
>> +			   xfs_fileoff_t *lfileoff);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> -- 
>> 2.7.4
>>
