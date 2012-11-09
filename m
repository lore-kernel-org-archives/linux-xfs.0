Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9IUmFq136899 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 12:30:48 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TWw12B2hyrTzPzh2 for <xfs@oss.sgi.com>;
	Fri, 09 Nov 2012 10:32:47 -0800 (PST)
Message-ID: <509D4C50.2020607@sandeen.net>
Date: Fri, 09 Nov 2012 12:32:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfsdump: default to V3, use V4 if projid32bit is set
References: <50788C50.40600@redhat.com> <50788D9A.8080302@sandeen.net>
	<509D4C12.6080800@sgi.com>
In-Reply-To: <509D4C12.6080800@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 11/9/12 12:31 PM, Rich Johnston wrote:
> On 10/12/2012 04:37 PM, Eric Sandeen wrote:
>> Because 32-bit project ID is not default and semi-rare,
>> default to version 3 dumps unless dumping a filesystem
>> with the 32-bit project ID feature flag set.
>>
>> XFS_FSOP_GEOM_FLAGS_PROJID32 is a newish flag so I've
>> redefined it here just in caes as well.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/common/fs.h b/common/fs.h
>> index 878385b..7e63f8e 100644
>> --- a/common/fs.h
>> +++ b/common/fs.h
>> @@ -26,6 +26,10 @@
>>   #define FS_MAXNAMELEN_DEFAULT    256
>>   #define FS_MAXPATHLEN_DEFAULT    1024
>>
>> +#ifndef XFS_FSOP_GEOM_FLAGS_PROJID32
>> +#define XFS_FSOP_GEOM_FLAGS_PROJID32 0x0800
>> +#endif
>> +
>>   /* fs_info - decides if a source name describes a file system, and if
>>    * so returns useful information about that file system.
>>    *
>> diff --git a/common/global.h b/common/global.h
>> index 5138ed8..a847c5d 100644
>> --- a/common/global.h
>> +++ b/common/global.h
>> @@ -29,14 +29,14 @@
>>   #define GLOBAL_HDR_VERSION_2    2
>>   #define GLOBAL_HDR_VERSION_3    3
>>   #define GLOBAL_HDR_VERSION_4    4
> Hmm looks a a patch from your previous version.
>> -    /* version 4 adds 32-bit projid (projid_hi)
>> +    /* version 4 adds 32-bit projid (projid_hi) only used if projid32 in place.
>>        * version 3 uses the full 32-bit inode generation number in direnthdr_t.
>>        * version 2 adds encoding of holes and a change to on-tape inventory format.
>>        * version 1 adds extended file attribute dumping.
>>        * version 0 xfsrestore can't handle media produced
>>        * by version 1 xfsdump.
>>        */
>> -#define GLOBAL_HDR_VERSION    GLOBAL_HDR_VERSION_4
>> +#define GLOBAL_HDR_VERSION    GLOBAL_HDR_VERSION_3
>>
>>   #define GLOBAL_HDR_STRING_SZ    0x100
>>   #define GLOBAL_HDR_TIME_SZ    4
> 
> I used the following for testing purposes.
> 
> Index: b/common/global.h
> ===================================================================
> --- a/common/global.h
> +++ b/common/global.h
> @@ -28,7 +28,9 @@
>  #define GLOBAL_HDR_VERSION_1    1
>  #define GLOBAL_HDR_VERSION_2    2
>  #define GLOBAL_HDR_VERSION_3    3
> -    /* version 3 uses the full 32-bit inode generation number in direnthdr_t.
> +#define GLOBAL_HDR_VERSION_4    4
> +    /* version 4 adds 32-bit projid (projid_hi) only used if projid32 in place.
> +     * version 3 uses the full 32-bit inode generation number in direnthdr_t.
>       * version 2 adds encoding of holes and a change to on-tape inventory format.
>       * version 1 adds extended file attribute dumping.
>       * version 0 xfsrestore can't handle media produced
> 
> 
> Rest of the patch looks good.  Correct the common/global.h section and you can add a:

Thanks, but I think we NAK'd this one (and the series) for now, and decided not to bump the version
just for this.

-Eric

> Reviewed-by Rich Johnston <rjohnston@sgi.com>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
