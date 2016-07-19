Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 890857CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 21:06:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 594758F8037
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 19:05:58 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id ta26hk7WJdg0VkoU
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2016 19:05:55 -0700 (PDT)
From: Calvin Owens <calvinowens@fb.com>
Subject: Re: [BUG] Slab corruption during XFS writeback under memory pressure
References: <28f77d74-5ab4-d913-2921-df90da53f393@fb.com>
	<20160717000003.GW1922@dastard> <20160718060215.GB16044@dastard>
Message-ID: <24d2f83f-5281-ab3c-9e91-985a4b8e2f8b@fb.com>
Date: Mon, 18 Jul 2016 19:05:44 -0700
MIME-Version: 1.0
In-Reply-To: <20160718060215.GB16044@dastard>
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
Cc: linux-block@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, xfs@oss.sgi.com

On 07/17/2016 11:02 PM, Dave Chinner wrote:
> On Sun, Jul 17, 2016 at 10:00:03AM +1000, Dave Chinner wrote:
>> On Fri, Jul 15, 2016 at 05:18:02PM -0700, Calvin Owens wrote:
>>> Hello all,
>>>
>>> I've found a nasty source of slab corruption. Based on seeing similar symptoms
>>> on boxes at Facebook, I suspect it's been around since at least 3.10.
>>>
>>> It only reproduces under memory pressure so far as I can tell: the issue seems
>>> to be that XFS reclaims pages from buffers that are still in use by
>>> scsi/block. I'm not sure which side the bug lies on, but I've only observed it
>>> with XFS.
> [....]
>> But this indicates that the page is under writeback at this point,
>> so that tends to indicate that the above freeing was incorrect.
>>
>> Hmmm - it's clear we've got direct reclaim involved here, and the
>> suspicion of a dirty page that has had it's bufferheads cleared.
>> Are there any other warnings in the log from XFS prior to kasan
>> throwing the error?
>
> Can you try the patch below?

Thanks for getting this out so quickly :)

So far so good: I booted Linus' tree as of this morning and reproduced the ASAN
splat. After applying your patch I haven't triggered it.

I'm a bit wary since it was hard to trigger reliably in the first place... so I
lined up a few dozen boxes to run the test case overnight. I'll confirm in the
morning (-0700) they look good.

Thanks,
Calvin

> -Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
