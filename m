Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57104 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfHLWjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 18:39:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMZ3Ku088571
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:09 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u9nvp2g9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMcdS9062159
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2u9k1vrfr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:08 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CMd7mf020989
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:07 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 12/18] xfs: Factor out xfs_attr_rmtval_remove_value
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-13-allison.henderson@oracle.com>
 <20190812162704.GA7138@magnolia>
Message-ID: <65f3ab90-02c6-b290-a9bf-b40e9c05b982@oracle.com>
Date: Mon, 12 Aug 2019 15:39:04 -0700
MIME-Version: 1.0
In-Reply-To: <20190812162704.GA7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 8/12/19 9:27 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:20PM -0700, Allison Collins wrote:
>> Because new delayed attribute routines cannot roll
>> transactions, we carve off the parts of
>> xfs_attr_rmtval_remove that we can use.  This will help to
>> reduce repetitive code later when we introduce delayed
>> attributes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 25 +++++++++++++++++++------
>>   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>   2 files changed, 20 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index c421412..f030365 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -586,19 +586,14 @@ xfs_attr_rmtval_set_value(
>>   	return 0;
>>   }
>>   
>> -/*
>> - * Remove the value associated with an attribute by deleting the
>> - * out-of-line buffer that it is stored on.
>> - */
>>   int
>> -xfs_attr_rmtval_remove(
>> +xfs_attr_rmtval_remove_value(
> 
> This function invalidates the incore buffers, right?  Since _remove
> below still does the actual bunmapi work to unmap blocks from the attr
> fork?  Would this be better named xfs_attr_rmtval_invalidate()?

Yeah, I struggled with what to call some of these other than "yet one 
more helper function" that doesn't roll or commit something. 
xfs_attr_rmtval_invalidate sounds good, I will add that into v3.

> 
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_mount	*mp = args->dp->i_mount;
>>   	xfs_dablk_t		lblkno;
>>   	int			blkcnt;
>>   	int			error;
>> -	int			done;
>>   
>>   	trace_xfs_attr_rmtval_remove(args);
> 
> Leave this in xfs_attr_rmtval_remove.
> 

Ok, will move.  Thanks!

Allison

> --D
> 
>>   
>> @@ -642,7 +637,25 @@ xfs_attr_rmtval_remove(
>>   		lblkno += map.br_blockcount;
>>   		blkcnt -= map.br_blockcount;
>>   	}
>> +	return 0;
>> +}
>>   
>> +/*
>> + * Remove the value associated with an attribute by deleting the
>> + * out-of-line buffer that it is stored on.
>> + */
>> +int
>> +xfs_attr_rmtval_remove(
>> +	struct xfs_da_args      *args)
>> +{
>> +	xfs_dablk_t		lblkno;
>> +	int			blkcnt;
>> +	int			error = 0;
>> +	int			done = 0;
>> +
>> +	error = xfs_attr_rmtval_remove_value(args);
>> +	if (error)
>> +		return error;
>>   	/*
>>   	 * Keep de-allocating extents until the remote-value region is gone.
>>   	 */
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 2a73cd9..9a58a23 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -11,6 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>>   int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> +int xfs_attr_rmtval_remove_value(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>>   int xfs_attr_rmt_find_hole(struct xfs_da_args *args, int *blkcnt,
>>   			   xfs_fileoff_t *lfileoff);
>> -- 
>> 2.7.4
>>
