Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6KCeQXB116327 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 07:40:26 -0500
Message-ID: <500951B9.7030009@sgi.com>
Date: Fri, 20 Jul 2012 07:40:25 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: Re: [PATCH] Prefix IO_XX flags with XFS_IO_XX to avoid namespace
	colision.
References: <20120719181951.GL29979@sgi.com> <50095108.9010801@sgi.com>
In-Reply-To: <50095108.9010801@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
Cc: xfs@oss.sgi.com, Alain Renaud <arenaud@sgi.com>

Sorry resent because I fat fingered the oss address.

On 07/20/2012 07:37 AM, Rich Johnston wrote:
> On 05/22/2012 03:56 PM, Alain Renaud wrote:
>> From: Alain Renaud <arenaud@sgi.com>
>> To: xfs@oss.sgi.com
>> Subject: [PATCH] Prefix IO_XX flags with XFS_IO_XX to avoid namespace
>> colision.
>> User-Agent: Heirloom mailx 12.2 01/07/07
>>
>>
>>   This mod simply add a XFS_ prefix to IO_DIRECT,XFS_IO_DELALLOC,
>> XFS_IO_UNWRITTEN and XFS_IO_OVERWRITE. This to avoid namespace conflict
>> with other modules.
>>
>> Signed-off-by: Alain Renaud <arenaud@sgi.com>
>>
>> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
>> index ae31c31..7d3f6ab 100644
>> --- a/fs/xfs/xfs_aops.c
>> +++ b/fs/xfs/xfs_aops.c
>> ...
>  > ...
>> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
>> index 84eafbc..c325abb 100644
>> --- a/fs/xfs/xfs_aops.h
>> +++ b/fs/xfs/xfs_aops.h
>> @@ -24,17 +24,17 @@ extern mempool_t *xfs_ioend_pool;
>>    * Types of I/O for bmap clustering and I/O completion tracking.
>>    */
>>   enum {
>> -    IO_DIRECT = 0,    /* special case for direct I/O ioends */
>> -    IO_DELALLOC,    /* mapping covers delalloc region */
>> -    IO_UNWRITTEN,    /* mapping covers allocated but uninitialized
>> data */
>> -    IO_OVERWRITE,    /* mapping covers already allocated extent */
>> +    XFS_IO_DIRECT = 0,    /* special case for direct I/O ioends */
>> +    XFS_IO_DELALLOC,    /* covers delalloc region */
>> +    XFS_IO_UNWRITTEN,    /* covers allocated but uninitialized data */
>> +    XFS_IO_OVERWRITE,    /* covers already allocated extent */
>>   };
>>
>>   #define XFS_IO_TYPES \
>>       { 0,            "" }, \
>> -    { IO_DELALLOC,        "delalloc" }, \
>> -    { IO_UNWRITTEN,        "unwritten" }, \
>> -    { IO_OVERWRITE,        "overwrite" } > +    {
>> XFS_IO_DELALLOC,        "delalloc" }, \
>> +    { XFS_IO_UNWRITTEN,        "unwritten" }, \
>> +    { XFS_IO_OVERWRITE,        "overwrite" }
>>
>>   /*
>>    * xfs_ioend struct manages large extent writes for XFS.
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>
> Alain looks like this patch does what claims to do :), looks good to me.
>
> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
