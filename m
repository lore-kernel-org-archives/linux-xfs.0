Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBP3Yp1u223014 for <xfs@oss.sgi.com>; Fri, 24 Dec 2010 21:34:52 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CE75147EE25
	for <xfs@oss.sgi.com>; Fri, 24 Dec 2010 19:36:50 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id Son7AeEReIlD3sXq for
	<xfs@oss.sgi.com>; Fri, 24 Dec 2010 19:36:50 -0800 (PST)
Message-ID: <4D1566D1.6090506@sandeen.net>
Date: Fri, 24 Dec 2010 21:36:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfssyncd and disk spin down
References: <20101223165532.GA23813@peter.simplex.ro>	<4D13A30A.3090600@hardwarefreak.com>	<20101223211650.GA19694@peter.simplex.ro>	<4D13EF3B.2050401@hardwarefreak.com>	<20101224060246.GA2308@peter.simplex.ro>
	<4D1525FB.1010605@hardwarefreak.com>
In-Reply-To: <4D1525FB.1010605@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On 12/24/10 5:00 PM, Stan Hoeppner wrote:
> Petre Rodan put forth on 12/24/2010 12:02 AM:
> 
>>> fs.xfs.xfssyncd_centisecs	(Min: 100  Default: 3000  Max: 720000)
>>> fs.xfs.age_buffer_centisecs	(Min: 100  Default: 1500  Max: 720000)
>>
>> just increasing the delay until an inevitable and seemingly redundant disk write is not what I want.
>> I was searching for an option to make internal xfs processes not touch the drive after the buffers/log/dirty metadata have been flushed (once).
> 
> I'm not a dev Petre but just another XFS user.  This is the best
> "solution" I could come up with for your issue.  I assumed this
> "unnecessary" regularly scheduled activity was a house cleaning measure
> and done intentionally; didn't dawn on me that it may be a bug.
> 
> Sorry I wasn't able to fully address your issue.  If/until there is a
> permanent fix for this you may want to bump this to 720000 anyway as an
> interim measure, if you haven't already, as it should yield a
> significantly better situation than what you have now.  You'll at least
> get something like ~1400 minutes of sleep per day instead of none,
> decreasing your load/unload cycles from ~2880/day to ~120/day, if my
> math is correct.

Of course, then xfssyncd will not be doing its proper duty regularly ;)

We just need to see why it's always finding work to do when idle.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
