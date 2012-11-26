Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQI1sBt215855 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 12:01:54 -0600
Message-ID: <50B3AF15.7060205@sgi.com>
Date: Mon, 26 Nov 2012 12:04:05 -0600
From: Andrew Dahl <adahl@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02.5/32] xfs: remove xfs_tosspages
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-3-git-send-email-david@fromorbit.com>
	<20121114064247.GC1710@dastard> <50A3E807.5010403@sgi.com>
	<50A3E86A.2060402@sgi.com> <50A3F80C.7050502@sgi.com>
	<20121121080502.GP2591@dastard> <50ADB3AA.302@sgi.com>
	<20121122232920.GX2591@dastard>
In-Reply-To: <20121122232920.GX2591@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com



On 11/22/2012 05:29 PM, Dave Chinner wrote:
> On Wed, Nov 21, 2012 at 11:10:02PM -0600, Andrew Dahl wrote:
>> On 11/21/2012 02:05 AM, Dave Chinner wrote:
>> ...
>>>
...

>>> +	} else {
>>> +		/* it's a sub-rounding range */
>>> +		ASSERT(offset + len <= rounding);
>> This is false. (8K - 2) <= 4K -- Not so good.
> 
> Right, I put this in after testing without thinking too hard about
> it. It's always completely wrong, because offset can be an arbitrary
> 64 bit number, and rounding will always be <=64k...
> 
>> Maybe (2*rounding) would be better, as offset + len could never be
>> greater than 2rounding (but can be greater than 1rounding). Or removing
>> this assert altogether.
> 
> No, the correct thing to assert is:
> 
> 		ASSERT(offset + len <= start);
> 
> That is, start is rounded up, and end is rounded down, so for a
> sub-block range the end should always be less than the start of the
> next block. That's what my current code has in it.

Ah... that makes sense.  Yeah, with that change, I'd say it looks great!

Thanks, Dave.

-Andrew

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
