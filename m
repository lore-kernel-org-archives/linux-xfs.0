Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 102877F4E
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 23:58:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DBF8E8F8037
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 21:58:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Ita2Z71yL7mXXXRG for <xfs@oss.sgi.com>;
	Wed, 20 Aug 2014 21:58:50 -0700 (PDT)
Message-ID: <53F57C8F.6060909@sandeen.net>
Date: Wed, 20 Aug 2014 23:58:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: deduplicate xlog_do_recovery_pass()
References: <53F5651C.8030206@redhat.com> <53F57758.9070007@sandeen.net>
	<20140821044915.GX20518@dastard>
In-Reply-To: <20140821044915.GX20518@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 8/20/14, 11:49 PM, Dave Chinner wrote:
> On Wed, Aug 20, 2014 at 11:36:40PM -0500, Eric Sandeen wrote:
>> On 8/20/14, 10:18 PM, Eric Sandeen wrote:
>>> In xlog_do_recovery_pass(), there are 2 distinct cases:
>>> non-wrapped and wrapped log recovery.
>>>
>>> If we find a wrapped log, we recover around the end
>>> of the log, and then handle the rest of recovery
>>> exactly as in the non-wrapped case - using exactly the same
>>> (duplicated) code.
>>>
>>> Rather than having the same code in both cases, we can
>>> get the wrapped portion out of the way first if needed,
>>> and then recover the non-wrapped portion of the log.
>>>
>>> There should be no functional change here, just code
>>> reorganization & deduplication.
>>>
>>> The patch looks a bit bigger than it really is; the last
>>> hunk is whitespace changes (un-indenting).
>>>
>>> Tested with xfstests "check -g log" on a stock configuration.
>>
>> which didn't actually hit any log wraps.  Does xfstests
>> really not cover wrapped log recovery?  anyway, something like this
>> on a small log:
> 
> xfs/016

AFAICT that doesn't ever run recovery...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
