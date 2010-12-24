Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBOMwCMu180842 for <xfs@oss.sgi.com>; Fri, 24 Dec 2010 16:58:13 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C19EF21E5B2
	for <xfs@oss.sgi.com>; Fri, 24 Dec 2010 15:00:12 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id PAF3G0pm3mxArxg2
	for <xfs@oss.sgi.com>; Fri, 24 Dec 2010 15:00:12 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id B50C26C14F
	for <xfs@oss.sgi.com>; Fri, 24 Dec 2010 17:00:11 -0600 (CST)
Message-ID: <4D1525FB.1010605@hardwarefreak.com>
Date: Fri, 24 Dec 2010 17:00:11 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfssyncd and disk spin down
References: <20101223165532.GA23813@peter.simplex.ro>	<4D13A30A.3090600@hardwarefreak.com>	<20101223211650.GA19694@peter.simplex.ro>	<4D13EF3B.2050401@hardwarefreak.com>
	<20101224060246.GA2308@peter.simplex.ro>
In-Reply-To: <20101224060246.GA2308@peter.simplex.ro>
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
To: xfs@oss.sgi.com

Petre Rodan put forth on 12/24/2010 12:02 AM:

>> fs.xfs.xfssyncd_centisecs	(Min: 100  Default: 3000  Max: 720000)
>> fs.xfs.age_buffer_centisecs	(Min: 100  Default: 1500  Max: 720000)
> 
> just increasing the delay until an inevitable and seemingly redundant disk write is not what I want.
> I was searching for an option to make internal xfs processes not touch the drive after the buffers/log/dirty metadata have been flushed (once).

I'm not a dev Petre but just another XFS user.  This is the best
"solution" I could come up with for your issue.  I assumed this
"unnecessary" regularly scheduled activity was a house cleaning measure
and done intentionally; didn't dawn on me that it may be a bug.

Sorry I wasn't able to fully address your issue.  If/until there is a
permanent fix for this you may want to bump this to 720000 anyway as an
interim measure, if you haven't already, as it should yield a
significantly better situation than what you have now.  You'll at least
get something like ~1400 minutes of sleep per day instead of none,
decreasing your load/unload cycles from ~2880/day to ~120/day, if my
math is correct.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
