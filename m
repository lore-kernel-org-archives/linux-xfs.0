Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7U7oPXY157061 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 02:50:25 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nGCHkiLbrcBy0CJ4 for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 00:51:17 -0700 (PDT)
Date: Thu, 30 Aug 2012 17:51:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstest fails at 018
Message-ID: <20120830075114.GC15292@dastard>
References: <20120829233946.GA30212@centos-guest>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120829233946.GA30212@centos-guest>
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
To: Chen Baozi <baozich@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 30, 2012 at 07:39:46AM +0800, Chen Baozi wrote:
> Hi, all!
> 
> I tried to run xfstest on my machine and failed when running 018.
> I've no idea where I'm wrong. Or it is already a reported failure. 
> I'm wondering if someone could show me any clues about this. Here 
> are some details:

Check your group file:

....
# Old tests that we won't spend any effort trying to run and make work
# on current systems
deprecated
....
018 deprecated # log logprint v2log
....
081 deprecated # log logprint quota
....
082 deprecated # log logprint v2log
....

You should be running "./check -g auto", which runs all the tests
known to work correctly. If you just run "./check", it will run all
the deprecated and broken tests as well...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
