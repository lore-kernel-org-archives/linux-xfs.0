Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A17FD7F50
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 20:02:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7A495304048
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 18:02:26 -0800 (PST)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id xaGWBvMixuJLWfCH
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 18:02:25 -0800 (PST)
Message-ID: <52F98495.3040600@fb.com>
Date: Mon, 10 Feb 2014 21:01:57 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/004: fix to make test really work
References: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com>
	<52F925EA.20600@fb.com> <52F97B3E.9060608@cn.fujitsu.com>
In-Reply-To: <52F97B3E.9060608@cn.fujitsu.com>
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
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com


On 02/10/2014 08:22 PM, Wang Shilong wrote:
> Hi Josef,
>
> On 02/11/2014 03:18 AM, Josef Bacik wrote:
>>
>>
>> On 02/10/2014 07:10 AM, Wang Shilong wrote:
>>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>
>>> So i was wandering why test 004 could pass my previous wrong
>>> kernel patch while it defenitely should not.
>>>
>>> By some debugging, i found here perl script is wrong, we did not
>>> filter out anything and this unit test did not work acutally.so
>>> it came out we will never fail this test.
>>>
>>
>> So now with this patch I'm failing it, is there some btrfs patch I 
>> need to make it not fail or is it still not supposed to fail normally 
>> and is this patch broken?  Thanks,
> You should not have updated my previous patch(Btrfs: switch to 
> btrfs_previous_extent_item()) when you fail this test.
> I update your latest btrfs-next which has updated my previous patch 
> and it can pass this case, did you miss that?

Hrm I must not have insmod'ed the new module, which now means I have to 
re-run all my tests, sigh.

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
