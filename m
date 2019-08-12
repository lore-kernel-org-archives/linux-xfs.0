Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51146 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfHLWla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 18:41:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMYtCT062466
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:41:28 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbtagxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:41:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CMcdC0062168
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u9k1vrg2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:28 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CMdRJm022274
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 22:39:28 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v1 18/19] xfsprogs: Add delayed attributes error tag
References: <20190809213804.32628-1-allison.henderson@oracle.com>
 <20190809213804.32628-19-allison.henderson@oracle.com>
 <20190812164407.GE7138@magnolia>
Message-ID: <d56cc76a-cd1a-8e57-5f2c-553d33551502@oracle.com>
Date: Mon, 12 Aug 2019 15:39:26 -0700
MIME-Version: 1.0
In-Reply-To: <20190812164407.GE7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 8/12/19 9:44 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:38:03PM -0700, Allison Collins wrote:
>> Subject: [PATCH v1 18/19] xfsprogs: Add delayed attributes error tag
> 
> In the final version this ought to be "xfs_io:", not "xfsprogs:" since
> the libxfs changes will invariably land through a separate
> libxfs-apply'd patch.
> 
> Looks ok otherwise,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 

Ok, will do.  Thanks!
Allison

> --D
> 
>> This patch adds an error tag that we can use to test
>> delayed attribute recovery and replay
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   io/inject.c           | 1 +
>>   libxfs/xfs_errortag.h | 4 +++-
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/io/inject.c b/io/inject.c
>> index cabfc3e..05bd4db 100644
>> --- a/io/inject.c
>> +++ b/io/inject.c
>> @@ -54,6 +54,7 @@ error_tag(char *name)
>>   		{ XFS_ERRTAG_FORCE_SCRUB_REPAIR,	"force_repair" },
>>   		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
>>   		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
>> +		{ XFS_ERRTAG_DELAYED_ATTR,		"delayed_attr" },
>>   		{ XFS_ERRTAG_MAX,			NULL }
>>   	};
>>   	int	count;
>> diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
>> index 79e6c4f..85d5850 100644
>> --- a/libxfs/xfs_errortag.h
>> +++ b/libxfs/xfs_errortag.h
>> @@ -55,7 +55,8 @@
>>   #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
>>   #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
>>   #define XFS_ERRTAG_IUNLINK_FALLBACK			34
>> -#define XFS_ERRTAG_MAX					35
>> +#define XFS_ERRTAG_DELAYED_ATTR				35
>> +#define XFS_ERRTAG_MAX					36
>>   
>>   /*
>>    * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
>> @@ -95,5 +96,6 @@
>>   #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
>>   #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
>>   #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
>> +#define XFS_RANDOM_DELAYED_ATTR				1
>>   
>>   #endif /* __XFS_ERRORTAG_H_ */
>> -- 
>> 2.7.4
>>
