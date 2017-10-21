Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47509 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753242AbdJUBNV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2017 21:13:21 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9L1DK5h025673
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:13:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9L1DKEc032481
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:13:20 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9L1DKmL008701
        for <linux-xfs@vger.kernel.org>; Sat, 21 Oct 2017 01:13:20 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 15/17] xfs_bmap_add_attrfork(): re-add error handling from
 set_attrforkoff() call
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
 <1508367333-3237-16-git-send-email-allison.henderson@oracle.com>
 <20171019194357.GJ4755@magnolia>
Message-ID: <352bba04-eb5d-98e8-162d-19661d142058@oracle.com>
Date: Fri, 20 Oct 2017 18:13:11 -0700
MIME-Version: 1.0
In-Reply-To: <20171019194357.GJ4755@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org

On 10/19/2017 12:43 PM, Darrick J. Wong wrote:
> On Wed, Oct 18, 2017 at 03:55:31PM -0700, Allison Henderson wrote:
>> From: Brian Foster<bfoster@redhat.com>
>>
>> - fix for "xfs: parent pointer attribute creation"
>>
>> [achender: rebased]
> Please fold this into that patch.
>
> --D
>
Sure, will do
>> Signed-off-by: Brian Foster<bfoster@redhat.com>
>> Signed-off-by: Allison Henderson<allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_bmap.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 7ee98be..a631fe1 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -1149,7 +1149,9 @@ xfs_bmap_add_attrfork(
>>   	xfs_trans_ijoin(tp, ip, 0);
>>   	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>>   
>> -	xfs_bmap_set_attrforkoff(ip, size, &version);
>> +	error = xfs_bmap_set_attrforkoff(ip, size, &version);
>> +	if (error)
>> +		goto trans_cancel;
>>   
>>   	ASSERT(ip->i_afp == NULL);
>>   	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message tomajordomo@vger.kernel.org
>> More majordomo info athttp://vger.kernel.org/majordomo-info.html

