Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B004Mr204314 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 19:00:04 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id vtVEAjQ3OXXlQEeZ for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2012 17:01:35 -0700 (PDT)
Message-ID: <50760C5F.8000607@sandeen.net>
Date: Wed, 10 Oct 2012 19:01:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfsprogs: add PROJID32 geom feature flag
References: <50747753.6040105@redhat.com> <50760C26.1040802@sandeen.net>
In-Reply-To: <50760C26.1040802@sandeen.net>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/10/12 7:00 PM, Eric Sandeen wrote:
> On 10/9/12 2:13 PM, Eric Sandeen wrote:
>> Matches new flag added to kernel.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> SGI, can you please add a :
> 
> Cc: stable@vger.kernel.org
> 
> when this is committed?  New stuff will be depending on this and it'd be good to get it munged into stable kernels as well.

Ugh ignore that responded to the wrong patch :/

-Eric
 
> Thanks,
> -Eric
> 
>> ---
>>
>> diff --git a/include/xfs_fs.h b/include/xfs_fs.h
>> index faac5af..0dd3afd 100644
>> --- a/include/xfs_fs.h
>> +++ b/include/xfs_fs.h
>> @@ -233,7 +233,8 @@ typedef struct xfs_fsop_resblks {
>>  #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
>>  #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
>>  #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
>> -#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names */
>> +#define XFS_FSOP_GEOM_FLAGS_PROJID32	0x0800  /* 32-bit project IDs	*/
>> +#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names	*/
>>  #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
