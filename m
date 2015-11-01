Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7F1A77F59
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 16:34:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B02FAC002
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 14:34:53 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	O073XhY0g2Dg8Zaq for <xfs@oss.sgi.com>;
	Sun, 01 Nov 2015 14:34:47 -0800 (PST)
Date: Mon, 2 Nov 2015 09:34:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problems compiling xfsdump on Debian unstable
Message-ID: <20151101223432.GE10656@dastard>
References: <56362B71.4070709@calhariz.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56362B71.4070709@calhariz.com>
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
To: Jose M Calhariz <jose@calhariz.com>
Cc: xfs@oss.sgi.com

On Sun, Nov 01, 2015 at 03:10:41PM +0000, Jose M Calhariz wrote:
> I am trying to compile the latest xfsdump from the git repository.
> 
> While I can compile it on Debian stable (jessie) and testing(stretch), I
> have problems compiling it on Debian unstable. 
> I think the problem is because of new software on Debian unstable.

Known issue - xfsdump had an unhealthy dependency on the unclean
header files that shipped with xfsprogs. We sanitised the xfsprogs
headers in 4.2.0, and didn't notice that xfsdump started
complaining because my build machine was still using 3.2.4 headers
to build xfsdump.

I have patches under review to fix the xfsdump problems, I'll be
doing a release of it as soon as the review is finished...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
