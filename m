Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60938 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfHLWjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 18:39:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMYxGu075678
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:06 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjqadax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMd3YJ070525
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u9n9hdq62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:03 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CMclGA007640
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:38:47 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 09/18] xfs: Factor up commit from
 xfs_attr_try_sf_addname
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-10-allison.henderson@oracle.com>
 <20190812161420.GX7138@magnolia>
Message-ID: <c2a83a34-dc03-f0de-5f98-fa398c66a436@oracle.com>
Date: Mon, 12 Aug 2019 15:38:45 -0700
MIME-Version: 1.0
In-Reply-To: <20190812161420.GX7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 8/12/19 9:14 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:17PM -0700, Allison Collins wrote:
>> New delayed attribute routines cannot handle transactions,
>> so factor this up to the calling function.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 15 ++++++++-------
>>   1 file changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index f9d5e28..6bd87e6 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -196,7 +196,7 @@ xfs_attr_try_sf_addname(
>>   {
>>   
>>   	struct xfs_mount	*mp = dp->i_mount;
>> -	int			error, error2;
>> +	int			error;
>>   
>>   	error = xfs_attr_shortform_addname(args);
>>   	if (error == -ENOSPC)
>> @@ -212,9 +212,7 @@ xfs_attr_try_sf_addname(
>>   	if (mp->m_flags & XFS_MOUNT_WSYNC)
>>   		xfs_trans_set_sync(args->trans);
>>   
>> -	error2 = xfs_trans_commit(args->trans);
>> -	args->trans = NULL;
>> -	return error ? error : error2;
>> +	return error;
>>   }
>>   
>>   /*
>> @@ -226,7 +224,7 @@ xfs_attr_set_args(
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error;
>> +	int			error, error2 = 0;;
>>   
>>   	/*
>>   	 * If the attribute list is non-existent or a shortform list,
>> @@ -246,8 +244,11 @@ xfs_attr_set_args(
>>   		 * Try to add the attr to the attribute list in the inode.
>>   		 */
>>   		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC)
>> -			return error;
>> +		if (error != -ENOSPC) {
>> +			error2 = xfs_trans_commit(args->trans);
> 
> I've wondered about this weird logic... if xfs_attr_shortform_addname
> returns an error code other than ENOSPC, why would we commit the
> transaction?  Usually we let the error code bounce up to whomever
> allocated the transaction and let them cancel it.
> 
> Hmm, looking around some more, I guess xfs_attr_shortform_remove can
> return ENOATTR to _addname and _shortform_lookup can return EEXIST, but
> with either of those error codes, the transaction isn't dirty so it's
> not like we're committing garbage state into the filesystem...?
> 
> --D

It does seem a little weird.  If I make the adjustment to only commit
on success, it seems to be ok.  I can add that as an optimization in v3.

Allison

> 
>> +			args->trans = NULL;
>> +			return error ? error : error2;
>> +		}
>>   
>>   		/*
>>   		 * It won't fit in the shortform, transform to a leaf block.
>> -- 
>> 2.7.4
>>
