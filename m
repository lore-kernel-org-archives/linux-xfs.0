Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q51EHjdP154268 for <xfs@oss.sgi.com>; Fri, 1 Jun 2012 09:17:45 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 707D0304051
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 07:17:42 -0700 (PDT)
Received: from [134.15.95.98] (cf-vpn-hw-arenaud-1.corp.sgi.com [134.15.95.98])
	by estes.americas.sgi.com (Postfix) with ESMTP id 369727001921
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 09:17:42 -0500 (CDT)
Message-ID: <4FC8CF01.9080705@sgi.com>
Date: Fri, 01 Jun 2012 10:17:37 -0400
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstest: Cleanup test permission and gitignore state.
References: <4FC8C12A.4010805@sgi.com> <4FC8CC28.70805@sandeen.net>
In-Reply-To: <4FC8CC28.70805@sandeen.net>
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
To: xfs@oss.sgi.com

Thanks Eric,

I just also notice that the 284.full 285.full and 286.full should be remove 
as we do
not maintain those file in tree... I do like the idea of the check script I 
will look into it.

Thanks.


On 12-06-01 10:05 AM, Eric Sandeen wrote:
> On 6/1/12 8:18 AM, Alain Renaud wrote:
>> The new test 284/285/286 do not have execute permission set so set
>> them. Also test 285 and 286 create 2 executable that are not in .gitignore
>> so add then to the list.
>>
>> Signed-off-by: Alain Renaud<arenaud@sgi.com>
> Looks good to me,
>
> Reviewed-by: Eric Sandeen<sandeen@redhat.com>
>
> I wonder if we can embed something in the ./check script to check executable state and fail if not set - we check things in w/o execute perms all the time and we're constantly having to fix things up.
>
> It's just tidiness really, but a bit of a pain....
>
> -Eric
>
>> diff --git a/.gitignore b/.gitignore
>> index 900ff95..c53c0d9 100644
>> --- a/.gitignore
>> +++ b/.gitignore
>> @@ -88,6 +88,8 @@ src/aio-dio-regress/aio-dio-subblock-eof-read
>>   src/aio-dio-regress/aio-free-ring-with-bogus-nr-pages
>>   src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer
>>   src/aio-dio-regress/aiodio_sparse2
>> +src/seek_copy_test
>> +src/seek_sanity_test
>>    dmapi/src/common/cmd/read_invis
>>   dmapi/src/common/cmd/set_region
>> diff --git a/284 b/284
>> old mode 100644
>> new mode 100755
>> diff --git a/285 b/285
>> old mode 100644
>> new mode 100755
>> diff --git a/286 b/286
>> old mode 100644
>> new mode 100755
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
===============================================
Alain Renaud     - Cluster File System Engineer
arenaud@sgi.com  - SGI
===============================================

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
