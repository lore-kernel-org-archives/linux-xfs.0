Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B4FEE7F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 13:04:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A40008F8040
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 11:04:37 -0700 (PDT)
Received: from keptprivate.com (keptprivate.com [38.117.1.51]) by cuda.sgi.com
	with ESMTP id tA9mI3BmoXURFYas (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Oct 2013 11:04:33 -0700 (PDT)
Message-ID: <526026AE.8000306@keptprivate.com>
Date: Thu, 17 Oct 2013 20:04:30 +0200
From: Stefanita Rares Dumitrescu <katmai@keptprivate.com>
MIME-Version: 1.0
Subject: Re: xfs corrupted
References: <1381826507281-35009.post@n7.nabble.com>
	<20131015203434.2f336fd8@galadriel.home>
	<525D8D67.2090301@keptprivate.com>
	<20131015213447.40d05ea0@galadriel.home>
	<525D9E3B.5040507@keptprivate.com> <20131015202640.GR4446@dastard>
In-Reply-To: <20131015202640.GR4446@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi guys,

I am finished yay! After the array got rechecked and fixed some errors, 
i ran the xfs_repair and left it overnight, and i came back to a clean 
system.

Thanks for all your support. Now i learned that no matter what the raid 
card status says, i still need to force another integrity check after a 
power failure, even if it says all is good.

On 15/10/2013 22:26, Dave Chinner wrote:
> On Tue, Oct 15, 2013 at 09:57:47PM +0200, Stefanita Rares Dumitrescu wrote:
>> Since i am using centos 5.9, the version of the xfsprogs seems to be
>> old, so i cloned the new one from sgi.
>>
>> I have a machine with 4 gb ram, and 4 gb swap, and it's all been
>> eaten up by xfs_repair, and slowed down to a crawl.
>>
>> the sdc partition is the one being checked. i am all out of memory
>> now. 4 gb phys and 4 gb swap all gone.
>>
>> http://pastebin.ca/2467064
>>
>> posted to pastebin for better formatting.
>>
>> i was using:
>>
>> [root@kp4 ~]# xfs_repair -o bhash=16384 -o ihash=16384 -o ag_stride=16 \
>>> /dev/sdc >& /tmp/repair.log
>
> You don't have enough RAM to run threaded prefetching and parallel
> AG processing. You'd do better to turn prefetching off entirely with
> "-P" if you are having OOM problems.
>
>> but now i am trying the -m option to see if the memory can be
>> limited, so the server doesn't freeze.
>>
>> [root@kp4 ~]# xfs_repair -m 3072 -o ag_stride=16 /dev/sdc >& /tmp/repair.log
>>
>> nothing in dmesg either.
>
> Give it another 10-20GB of swap, and it should be fine. xfs_repair
> usually only thrashes swap when you don't have enough of it and it
> keeps trying to free memory, paging in pages that are in swap to
> free cached objects from them. Most of the memory references that
> repair makes are quite local, so when pages are swapped out they
> generally aren't needed again for a while except when cache reclaim
> kicks in. Hence if you give it enough swap that it can grow without
> bounds, then it should still be quite efficient.
>
> Keep in mind that badly corrupted filesystems require lots more
> memory than clean filesystems to check and repair as there is lots
> more intermediate state that repair needs to hold in memory about
> partially or incompletely referenced objects. Don't be surprised if
> the amount of memory needed to repair a badly broken filesystem is
> 10-100x the amount of RAM needed to run xfs_repair on the same clean
> filesystem....
>
> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
