Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934786AbeFKT77 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 15:59:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5BJulvu028238
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 19:59:59 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jgecxe7xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 19:59:58 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5BJxwIR017857
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 19:59:58 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5BJxwcY002405
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 19:59:58 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 19/27] xfsprogs: Add delayed attributes error tag
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
 <1528607272-11122-20-git-send-email-allison.henderson@oracle.com>
 <20180611172822.GB22045@magnolia>
Message-ID: <00c2855f-caea-3abf-2001-c78bec50711a@oracle.com>
Date: Mon, 11 Jun 2018 12:59:56 -0700
MIME-Version: 1.0
In-Reply-To: <20180611172822.GB22045@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 06/11/2018 10:28 AM, Darrick J. Wong wrote:
>> Subject: [PATCH v2 19/27] xfsprogs: Add delayed attributes error tag
> 
> Please identify the tool name in the subject when possible, e.g.
> 
> [PATCH v2 19/27] xfs_io: Add delayed attributes error tag
> 
> Otherwise looks ok, though in the end I suspect the xfs_errortag.h chunk
> will be ported in from the kernel patch and this will be a separate
> patch with just the xfs_io part.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D

Alrighty then, will update.  Thx!

Allison

> 
> 
> On Sat, Jun 09, 2018 at 10:07:44PM -0700, Allison Henderson wrote:
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   io/inject.c           | 1 +
>>   libxfs/xfs_errortag.h | 5 ++++-
>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/io/inject.c b/io/inject.c
>> index fc3cf25..2d6cc9c 100644
>> --- a/io/inject.c
>> +++ b/io/inject.c
>> @@ -63,6 +63,7 @@ error_tag(char *name)
>>   		{ XFS_ERRTAG_LOG_BAD_CRC,		"log_bad_crc" },
>>   		{ XFS_ERRTAG_LOG_ITEM_PIN,		"log_item_pin" },
>>   		{ XFS_ERRTAG_BUF_LRU_REF,		"buf_lru_ref" },
>> +		{ XFS_ERRTAG_DELAYED_ATTR,		"delayed_attr" },
>>   		{ XFS_ERRTAG_MAX,			NULL }
>>   	};
>>   	int	count;
>> diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
>> index bc1789d..f606ab6 100644
>> --- a/libxfs/xfs_errortag.h
>> +++ b/libxfs/xfs_errortag.h
>> @@ -65,7 +65,8 @@
>>   #define XFS_ERRTAG_LOG_BAD_CRC				29
>>   #define XFS_ERRTAG_LOG_ITEM_PIN				30
>>   #define XFS_ERRTAG_BUF_LRU_REF				31
>> -#define XFS_ERRTAG_MAX					32
>> +#define XFS_ERRTAG_DELAYED_ATTR			32
>> +#define XFS_ERRTAG_MAX					33
>>   
>>   /*
>>    * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
>> @@ -102,5 +103,7 @@
>>   #define XFS_RANDOM_LOG_BAD_CRC				1
>>   #define XFS_RANDOM_LOG_ITEM_PIN				1
>>   #define XFS_RANDOM_BUF_LRU_REF				2
>> +#define XFS_RANDOM_DELAYED_ATTR			1
>>   
>>   #endif /* __XFS_ERRORTAG_H_ */
>> +
>> -- 
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=QbTHukRdcKCnd1O8XZT7S_muyoJoMTtTL4i6k23zRGY&s=bhDah3NrmTekLEKtbCYu5KGb-r_-7o59FAmFdI_tqfM&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=QbTHukRdcKCnd1O8XZT7S_muyoJoMTtTL4i6k23zRGY&s=bhDah3NrmTekLEKtbCYu5KGb-r_-7o59FAmFdI_tqfM&e=
> 
