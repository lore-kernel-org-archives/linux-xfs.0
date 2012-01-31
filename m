Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VJi9UD094192 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 13:44:09 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	tDiUF0tbgGbfHqbC for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 11:44:07 -0800 (PST)
Date: Wed, 1 Feb 2012 06:44:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File system remain unresponsive until the system is rebooted.
Message-ID: <20120131194404.GH9090@dastard>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20120131013124.GE9090@dastard>
	<CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
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
To: Supratik Goswami <supratiksekhar@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 31, 2012 at 10:34:10AM +0530, Supratik Goswami wrote:
> We are using Amazon EC2 instances.
> 
> ubuntu@ip-10-0-0-10:~$ uname -aLinux ip-10-0-0-10 2.6.32-318-ec2
> #38-Ubuntu SMP Thu Sep 1 18:09:30 UTC 2011 x86_64 GNU/Linux

The growfs hang problem was fixed in 2.6.34.

On earlier kernels, if you do a grow while the system is under
allocation load it could deadlock. growing on a mostly idle
filesystem was generally OK, but under heavy load problems could
occur. This hang is what xfstests 104 exercises...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
