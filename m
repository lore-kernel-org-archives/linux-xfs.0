Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63FdfTe102895 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 10:39:41 -0500
Message-ID: <4FF3121E.4080306@oracle.com>
Date: Tue, 03 Jul 2012 23:39:10 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: improve test 286 for repeated unwritten/hole
	extents.
References: <4FF29F94.6030702@oracle.com> <4FF30A89.9010800@sgi.com>
In-Reply-To: <4FF30A89.9010800@sgi.com>
Reply-To: jeff.liu@oracle.com
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 07/03/2012 11:06 PM, Mark Tinguely wrote:

> On 07/03/12 02:30, Jeff Liu wrote:
>> Hello,
>>
>> I'd like to enlarge the test coverage of 286 to includes file mapping
>> with repeated hole/unwritten/unwritten_without_data/data intersections.
>>
>> Those two new sub-tests could help verifying the current
>> seek_data/seek_hole improvements.
>>
>> Besides, I observed a weird thing at the diff of 286.full, look at the
>> the sparse file creation output,  there seems to be a significant
>> I/O degradation compare to the old test01/test02 IOPS results:
>>
>> -1 MiB, 256 ops; 0.0000 sec (1.242 GiB/sec and 325699.7455 ops/sec)
>> +1 MiB, 256 ops; 0.0000 sec (70.161 MiB/sec and 17961.1310 ops/sec)
>>
>> I run the test on same machine and same partition, I recalled the old
>> result is generated against around 3.4-rc2(not very sure), now is updated
>> to 3.5-rc4, does anyone hit that?
>>
>>
> 
> Quick feedback. I don't see any degradation.

Thanks for the verification.

> 
> OLD:  1 MiB, 256 ops; 0.0000 sec (484.027 MiB/sec and 123910.9390 ops/sec)
> THIS: 1 MiB, 256 ops; 0.0000 sec (494.560 MiB/sec and 126607.3195 ops/sec)
> 
> All the tests are very close to the unpatched results.
> 
>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>
>> ---
>>   286      |   87
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   286.full |   82
>> +++++++++++++++++++++++++++++++++++----------------------
> 
> Please, drop the 286.full patch.

Ok, will re-post a little while.

Thanks,
-Jeff

> 
> --Mark Tinguely.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
