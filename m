Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B41B37F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 09:33:55 -0500 (CDT)
Message-ID: <55DDCE52.9070105@sgi.com>
Date: Wed, 26 Aug 2015 09:33:54 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfsdump: fix problems in cb_add_inogrp
References: <20150821193047.661578219@gulag1.americas.sgi.com>
	<55D747FE.4070401@sandeen.net> <55D7854A.9030706@sgi.com>
	<55D785E7.8050503@sandeen.net>
In-Reply-To: <55D785E7.8050503@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 08/21/2015 03:11 PM, Eric Sandeen wrote:
> On 8/21/15 3:08 PM, Rich Johnston wrote:
>> On 08/21/2015 10:47 AM, Eric Sandeen wrote:
>>> Hi -
>>>
>>> Are there any testcases for these?  xfsdump is alien code, I swear;
>>> I'm not quite sure offhand how to tickle any of these bugs.
>>>
>>> Thanks,
>>> -Eric
>>>
>>
>> Hey Eric,
>>
>> Many thanks for taking the time to review these patches.
>> I take a look at all your responses and get a V2 out early next week.
>
> Sounds good.  If I was off track about the need for the extra 64-bit vars,
> just educate me.  ;)
>
> -Eric
>
Ok you convinced me, there is no need for patch 1 and patch 2 can be
solved by removing the local variable oldsize.

A new patch has been submitted.
[PATCH] xfsdump: prevent segfault in cb_add_inogrp

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
