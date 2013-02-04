Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C62E17F53
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 06:55:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51A10AC004
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2013 04:55:14 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QTwRGFaAXESvVJsl for <xfs@oss.sgi.com>;
	Mon, 04 Feb 2013 04:55:12 -0800 (PST)
Date: Mon, 4 Feb 2013 23:55:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
Message-ID: <20130204125510.GL2667@dastard>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
	<42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
	<20130130234650.GE32297@disturbed.disaster>
	<45702.75.149.17.233.1359599410.squirrel@secure.skymagik.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <45702.75.149.17.233.1359599410.squirrel@secure.skymagik.net>
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
To: Tom <storm9c1@skymagik.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 30, 2013 at 09:30:10PM -0500, Tom wrote:
> In a previous message, Dave Chinner wrote:
> >
> > And this says the filesystem is still mounted. Why?
> >
> 
> Good question.
> 
> As mentioned in the CentOS bug report, this is a freshly Kickstarted
> CentOS 5.9 system, staged with minimal packages.
....
> My next email will contain the "sysrq t" output that Ben requested.

Which doesn't tell us why the filesystem was not unmounted. We need
to know why/how the unmount failed to solve the problem, so you'll
need to do some debugging of the unmount to try to work that out...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
