Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 987BD7F53
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 10:23:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87BD1304077
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 08:23:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vzV7GGczFnHsGYhT for <xfs@oss.sgi.com>;
	Fri, 22 Aug 2014 08:23:36 -0700 (PDT)
Message-ID: <53F7607F.2020604@sandeen.net>
Date: Fri, 22 Aug 2014 10:23:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfs: combine xfs_rtmodify_summary and
	xfs_rtget_summary
References: <53F6942B.80808@redhat.com>
	<53F6963D.9090500@sandeen.net>	<20140822131950.GC3915@laptop.bfoster>
	<53F75B54.8050802@sandeen.net>
In-Reply-To: <53F75B54.8050802@sandeen.net>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 8/22/14, 10:01 AM, Eric Sandeen wrote:
> On 8/22/14, 8:19 AM, Brian Foster wrote:
>> On Thu, Aug 21, 2014 at 08:00:45PM -0500, Eric Sandeen wrote:
> 
> ...
> 
>>> @@ -480,15 +484,40 @@ xfs_rtmodify_summary(
>>>  		}
>>>  	}
>>>  	/*
>>> -	 * Point to the summary information, modify and log it.
>>> +	 * Point to the summary information, modify/log it, and/or copy it out.
>>>  	 */
>>>  	sp = XFS_SUMPTR(mp, bp, so);
>>> -	*sp += delta;
>>> -	xfs_trans_log_buf(tp, bp, (uint)((char *)sp - (char *)bp->b_addr),
>>> -		(uint)((char *)sp - (char *)bp->b_addr + sizeof(*sp) - 1));
>>> +	if (delta) {
>>> +		uint first = (uint)((char *)sp - (char *)bp->b_addr);
>>> +
>>> +		*sp += delta;
>>> +		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
>>> +	}
>>> +	if (sum) {
>>> +		/*
>>> +		 * Drop the buffer if we're not asked to remember it.
>>> +		 */
>>> +		if (!rbpp)
>>> +			xfs_trans_brelse(tp, bp);
>>
>> This introduces some potentially weird circumstances (e.g., acquire,
>> log, release of a buffer), but I think it's resolved by the next patch.
>>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> does it introduce it, or just highlight it?  I thought it was weird too,
> but I think it existed before; that's what prompted me to go looking at
> callers and drop the rbpp checks, FWIW.

Oh, right, if delta & sum,there's a problem if (!rpbb).  And I did introduce
that as a new issue.  But the code at that point never sees (!rbpp) so I think
it's safe.  I could respin patches 3 & 4, to do them in the opposite order,
if desired.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
