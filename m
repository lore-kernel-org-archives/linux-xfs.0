Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 284A97F52
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 12:22:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A265CAC003
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 10:22:50 -0800 (PST)
Received: from thunder.skymagik.net (thunder.skymagik.net [76.75.207.68]) by
	cuda.sgi.com with ESMTP id RhURIfDJRVKUlUui for
	<xfs@oss.sgi.com>; Tue, 05 Feb 2013 10:22:49 -0800 (PST)
Message-ID: <11083.192.104.24.222.1360088562.squirrel@secure.skymagik.net>
Date: Tue, 5 Feb 2013 13:22:42 -0500 (EST)
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
From: "Tom" <storm9c1@skymagik.com>
In-Reply-To: <20130204125510.GL2667@dastard>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
	<42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
	<20130130234650.GE32297@disturbed.disaster>
	<45702.75.149.17.233.1359599410.squirrel@secure.skymagik.net>
	<20130204125510.GL2667@dastard>
MIME-Version: 1.0
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
To: david@fromorbit.com
Cc: storm9c1@skymagik.com, xfs@oss.sgi.com

In a previous message, Dave Chinner wrote:
>
> Which doesn't tell us why the filesystem was not unmounted. We need to
> know why/how the unmount failed to solve the problem, so you'll need to
> do some debugging of the unmount to try to work that out...
>

Thanks Dave.

I can work on that tonight.

Oddly, since the problem is kernel related (308 doesn't do it, 348 does),
the system shuts down the same way no matter what kernel I'm using.  So
what would be the difference?  The umounts and running processes shouldn't
change.  Just seems to me that some resource isn't being released.  And
only with kernel 348 and XFS.  Quite puzzling..........

Any suggestions on how I would debug this?

-- Tom


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
