Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7C93A7F85
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 11:39:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D648304032
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 09:39:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id iNk5AwFKVVY9Et3l for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 09:39:48 -0700 (PDT)
Message-ID: <55D75454.1060003@sandeen.net>
Date: Fri, 21 Aug 2015 11:39:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfsdump: fix problems in cb_add_inogrp
References: <20150821193047.661578219@gulag1.americas.sgi.com>
	<55D747FE.4070401@sandeen.net> <55D7540D.7060700@sgi.com>
In-Reply-To: <55D7540D.7060700@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com

On 8/21/15 11:38 AM, Rich Johnston wrote:
> On 08/21/2015 10:47 AM, Eric Sandeen wrote:
>> On 8/21/15 9:01 AM, rjohnston@sgi.com wrote:
>>> The memset in cb_add_inogrp will segfault when the index oldsize
>>> overflows. In cb_add_inogrp(), the temp variables used in
>>> calculating the new i2gmap segment offset should be int64 instead
>>> of intgen_t (int32).
>>>
>>> A second bug also occurs because we already compensate for the
>>> length of each item in oldsize so are 32bit wrap becomes a 40bit
>>> wrap.
>>
>> Hi -
>>
>> Are there any testcases for these?  xfsdump is alien code, I swear;
>> I'm not quite sure offhand how to tickle any of these bugs.
>>
>> Thanks,
>> -Eric
>>
> No I thought simple examination shows the bug.

Nothing is simple in xfsdump, IMHO.  At least to the uninitiated.  :)

> It was a customer bug.
> 
> The number of inodes that we needed before wrapping was a couple hundred inodes.

I did eventually manage to hit the segfault, thanks.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
