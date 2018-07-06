Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38884 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932075AbeGFDy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 23:54:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w663s9bp012207
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:54:27 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2k0dnt829k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 03:54:27 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w663sQ60029238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:54:26 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w663sQE4023943
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:54:26 GMT
Subject: Re: [PATCH RFC 8/8] xfs: skip local format inode for reflinking
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-9-git-send-email-shan.hai@oracle.com>
 <20180706032653.GL32415@magnolia>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <1eb4f33c-b0b6-ebd2-b9f0-635ce4057dff@oracle.com>
Date: Fri, 6 Jul 2018 11:54:13 +0800
MIME-Version: 1.0
In-Reply-To: <20180706032653.GL32415@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 2018年07月06日 11:26, Darrick J. Wong wrote:
> On Fri, Jul 06, 2018 at 11:12:29AM +0800, Shan Hai wrote:
>> The local format inode holds the data inline in its data fork and
>> has no extents at all, so skip the inode for reflinking.
>>
>> Signed-off-by: Shan Hai <shan.hai@oracle.com>
>> ---
>>   fs/xfs/xfs_reflink.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
>> index 592fb2071a03..dfb3a85ec0e6 100644
>> --- a/fs/xfs/xfs_reflink.c
>> +++ b/fs/xfs/xfs_reflink.c
>> @@ -1507,6 +1507,12 @@ xfs_reflink_inode_has_shared_extents(
>>   	int				error;
>>   
>>   	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>> +
>> +	if (ifp->if_flags & XFS_IFINLINE) {
>> +		*has_shared = false;
>> +		return 0;
>> +	}
> What happens if someone tries to reflink and either src or dest are an
> inline file?

I have to re-check this, thanks for the suggestion.

Thanks
Shan Hai
> --D
>
>> +
>>   	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
>>   		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
>>   		if (error)
>> -- 
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

