Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADD857CA0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 17:31:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 100D0AC001
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 15:31:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UcI3d0EfMFt0LTwG for <xfs@oss.sgi.com>;
	Wed, 14 Sep 2016 15:31:44 -0700 (PDT)
Subject: Re: [PATCH V4] xfs: Document error handlers behavior
References: <1473757385-81633-1-git-send-email-cmaiolino@redhat.com>
	<20160914012334.GK30497@dastard>
	<77fcc1da-9c74-da3e-5bcd-3df420a3bfbb@sandeen.net>
	<20160914222255.GQ30497@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8b69afc7-0088-e952-8c9b-cc7480a1bb2d@sandeen.net>
Date: Wed, 14 Sep 2016 17:31:43 -0500
MIME-Version: 1.0
In-Reply-To: <20160914222255.GQ30497@dastard>
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
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com



On 9/14/16 5:22 PM, Dave Chinner wrote:
>> Same issue here, really; they are symmetric, right?  First condition met for
>> > propagation propagates the error, period.  This sounds overly complex, unless
>> > I'm missing something. Seems like:
>> > 
>> > +	Setting the value to "N" (where 0 < N < Max) will make XFS retry the
>> > +	operation for "N" seconds before propagating the error.
>> > 
>> > would suffice, no?
> No, because that's not what the implementation does:
> 
> 	if (retries expired)
> 		fail
> 	if (retry timer expired)
> 		fail
> 
> IOWs, the retry count has precedence over the retry timer. if you
> set both retry_timeout and max_retries, the timeout only takes
> effect if max retries is set high enough that they aren't exhausted
> before the timeout fires.

Then:

+	Setting the value to "N" (where 0 < N < Max) will /allow/ XFS to retry
+	the operation for /up to/ "N" seconds before propagating the error.

?  i.e. it could, but only if the retries don't expire first :)

> This is for the case where an failure might take a variable time to
> report.  (Think interactions with errors that TLER would address).
> Normally you might say 10 retries, but if it is taking 5 minutes to
> then fail when this specific error condition is hit, you might set a retry
> timeout of 1 minute. In that case, we might get an immediate IO
> error and retry several times before failing. However, if we hit the
> "slow to report" error, we still get failure in the same time frame
> as the immediate failures that have been retried many times before
> giving up.

Either way, it's still the /first/ condition satisfied which will
bubble it up.

So "first condition satisfied will propagate up," plus
one condition is "retry up to N times," plus
one condition is "retry up for up to N seconds"

seems to cover it all, no?

> It's hard to explain complex stuff like with a simple, concise
> description. I'll try again....
> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
