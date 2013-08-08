Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6BDCA7F85
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 17:14:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E9778AC005
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 15:14:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id lxJ2dNs9Tb4Q5nrt for <xfs@oss.sgi.com>;
	Thu, 08 Aug 2013 15:14:23 -0700 (PDT)
Message-ID: <5204183E.2000902@sandeen.net>
Date: Thu, 08 Aug 2013 17:14:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 8/14] xfsprogs: fix issues with e0607266f23
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<20130806214154.GM3111@sgi.com> <20130808210600.GN3111@sgi.com>
	<20130808215330.GV3111@sgi.com> <52041686.4040703@sandeen.net>
In-Reply-To: <52041686.4040703@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 8/8/13 5:07 PM, Eric Sandeen wrote:
> On 8/8/13 4:53 PM, Ben Myers wrote:
>> A couple of issues found in review.
>>
>> Signed-off-by: Ben Myers <bpm@sgi.com>
>>
>> ---
>>  libxfs/xfs_alloc.c |    9 ++-------
>>  repair/dinode.c    |    9 +++------
>>  2 files changed, 5 insertions(+), 13 deletions(-)
> 
> ...
> 
> 
>> Index: b/repair/dinode.c
>> ===================================================================
>> --- a/repair/dinode.c	2013-08-06 14:43:09.910817602 -0500
>> +++ b/repair/dinode.c	2013-08-06 14:44:49.660857353 -0500
>> @@ -182,12 +182,9 @@ clear_dinode_core(struct xfs_mount *mp, 
>>  		platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_uuid);
>>  	}
>>  
>> -	for (i = 0; i < 16; i++) {
>> -		if (dinoc->di_pad[i] != 0) {
>> -			__dirty_no_modify_ret(dirty);
>> -			memset(dinoc->di_pad, 0, 16);
>> -			break;
>> -		}
>> +	if (dinoc->di_pad2 != 0) {
>> +		__dirty_no_modify_ret(dirty);
>> +		dinoc->di_pad2 = 0;
> 
> this probably needs to be fixed pronto, it's a memory corruptor right?
> 
> w/ a proper commit log, 
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Actually; everywhere else that sets di_pad to 0 does it through
a memset (sizeof . . ) - that might be best, on the off chance that
di_pad ever changes, rather than setting it to = 0 ?

-Eric

> Thanks,
> -Eric
> 
>>  	}
>>  
>>  	if (be64_to_cpu(dinoc->di_flags2) != 0)  {
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
