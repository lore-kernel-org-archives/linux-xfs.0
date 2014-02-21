Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4BBDF7FA2
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 14:56:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CEE57AC005
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 12:56:30 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id aCAleGvVyT8nKvpT for <xfs@oss.sgi.com>;
	Fri, 21 Feb 2014 12:56:29 -0800 (PST)
Message-ID: <5307BD7C.808@sandeen.net>
Date: Fri, 21 Feb 2014 14:56:28 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 46/55] xfs: Add xfs_log_rlimit.c
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>	<1378332359-14737-47-git-send-email-david@fromorbit.com>	<5251A450.4000407@sandeen.net>
	<5252125B.2040300@sandeen.net> <5252BB9A.2040705@sgi.com>
	<5307AD41.1000807@sandeen.net> <5307B9C2.4000908@sgi.com>
In-Reply-To: <5307B9C2.4000908@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 2/21/14, 2:40 PM, Mark Tinguely wrote:
> On 02/21/14 13:47, Eric Sandeen wrote:
>> On 10/7/13, 8:48 AM, Mark Tinguely wrote:
>>> On 10/06/13 20:46, Eric Sandeen wrote:
>>>> On 10/6/13 12:56 PM, Eric Sandeen wrote:
>>>>> On 9/4/13 5:05 PM, Dave Chinner wrote:
>>>>>>> From: Jie Liu<jeff.liu@oracle.com>
>>>>>>>
>>>>>>> Add source files for xfs_log_rlimit.c The new file is used for log
>>>>>>> size calculations and validation shared with userspace.
>>>>>>>
>>>>>>> [dchinner: xfs_log_calc_max_attrsetm_res() does not modify the
>>>>>>> tr_attrsetm reservation, just calculates the maximum. ]
>>>>>>>
>>>>>>> [dchinner: rework loop in xfs_log_get_max_trans_res() ]
>>>>>>>
>>>>>>> [dchinner: implement xfs_log_calc_unit_res() in util.c to give mkfs
>>>>>>> a worse case calculation of the log size needed. ]
>>>>> 2 things:
>>>>>
>>>>> Ben, seems like your workflow lost the:
>>>>>
>>>>> From: Jie Liu<jeff.liu@oracle.com>
>>>>>
>>>>> at the top - in git, the author is listed as Dave in git.
>>>>>
>>>>> (Although those [parentheticals] were pretty fundamental changes,
>>>>> something I just gave Rich a hard time for)  ;)
>>>>>
>>>>> Also, this now breaks xfstest xfs/216 as a result of the mkfs changes.
>>>>> What are the plans for that?
>>>>
>>>> Sorry, to be clear, it breaks that test (and others, pretty sure)
>>>> because the log sizes for small filesystems are significantly bigger:
>>>>
>>>> -fssize=1g log      =internal log           bsize=4096   blocks=2560, version=2
>>>> +fssize=1g log      =internal log           bsize=4096   blocks=12800, version=2
>>>>
>>>> -fssize=2g log      =internal log           bsize=4096   blocks=2560, version=2
>>>> +fssize=2g log      =internal log           bsize=4096   blocks=12800, version=2
>>>>
>>>> -fssize=4g log      =internal log           bsize=4096   blocks=2560, version=2
>>>> +fssize=4g log      =internal log           bsize=4096   blocks=12800, version=2
>>>>
>>>> -fssize=8g log      =internal log           bsize=4096   blocks=2560, version=2
>>>> +fssize=8g log      =internal log           bsize=4096   blocks=12800, version=2
>>>>
>>>> -fssize=16g log      =internal log           bsize=4096   blocks=2560, version=2
>>>> +fssize=16g log      =internal log           bsize=4096   blocks=12800, version=2
>>>>
>>>> -fssize=32g log      =internal log           bsize=4096   blocks=4096, version=2
>>>> +fssize=32g log      =internal log           bsize=4096   blocks=12800, version=2
>>>>
>>>> -fssize=64g log      =internal log           bsize=4096   blocks=8192, version=2
>>>> +fssize=64g log      =internal log           bsize=4096   blocks=12800, version=2
>>>>
>>>>    fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
>>>>    fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
>>>>
>>>> -Eric
>>>
>>>
>>> Separate outputs for different versions of the OS version like we do for 16/32 bit tests' output?
>>
>> I'm not sure what we'd switch on....
> 
> I was thinking of the output of uname(1). Probably easier to filter the results in the test on the OS version rather than have separate golden outputs.

The behavior depends on the xfsprogs version, though, not the kernel version.

I .... guess we could do mkfs.xfs -V and split on that.

I do want to make sure it's all intentional though, first.

-Eric

> --Mark.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
