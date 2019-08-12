Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57190 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfHLWjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 18:39:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMYFhg088096
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:13 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u9nvp2gae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMcuPR038237
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u9nrebsa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:12 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CMdCFe022370
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:12 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 13/18] xfs: Factor up trans roll in
 xfs_attr3_leaf_clearflag
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-14-allison.henderson@oracle.com>
 <20190812162842.GB7138@magnolia>
Message-ID: <722156a2-8e36-30a3-78c3-26f41c81cc82@oracle.com>
Date: Mon, 12 Aug 2019 15:39:10 -0700
MIME-Version: 1.0
In-Reply-To: <20190812162842.GB7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 8/12/19 9:28 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:21PM -0700, Allison Collins wrote:
>> New delayed allocation routines cannot be handling
>> transactions so factor them up into the calling functions
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 12 ++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  5 +----
>>   2 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 7648ceb..ca57202 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -823,6 +823,12 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
>>   		 * Added a "remote" value, just clear the incomplete flag.
>>   		 */
>>   		error = xfs_attr3_leaf_clearflag(args);
>> +
>> +		/*
>> +		 * Commit the flag value change and start the next trans in
>> +		 * series.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>   	}
>>   	return error;
>>   }
>> @@ -1180,6 +1186,12 @@ xfs_attr_node_addname(
>>   		error = xfs_attr3_leaf_clearflag(args);
>>   		if (error)
>>   			goto out;
>> +
>> +		 /*
>> +		  * Commit the flag value change and start the next trans in
>> +		  * series.
>> +		  */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>   	}
>>   	retval = error = 0;
> 
> Doesn't this cause us to lose the error code from the roll_inode above?
> 
> --D

Yes, I overlooked weird assignment in this case.  I will add a extra 
handler.  THx!

Allison

> 
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index b2d5f62..e3604b9 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2722,10 +2722,7 @@ xfs_attr3_leaf_clearflag(
>>   			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>>   	}
>>   
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series.
>> -	 */
>> -	return xfs_trans_roll_inode(&args->trans, args->dp);
>> +	return error;
>>   }
>>   
>>   /*
>> -- 
>> 2.7.4
>>
