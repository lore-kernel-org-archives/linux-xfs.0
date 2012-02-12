Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1CLEboX206526 for <xfs@oss.sgi.com>; Sun, 12 Feb 2012 15:14:37 -0600
Received: from pavilion.ashurst.eu.org (pavilion.ashurst.eu.org
	[85.119.82.45]) by cuda.sgi.com with ESMTP id 1Uxrcl7XKxrRKHag
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 12 Feb 2012 13:14:35 -0800 (PST)
Message-ID: <4F382BDF.3070901@ashurst.eu.org>
Date: Sun, 12 Feb 2012 21:15:11 +0000
From: Andy Bennett <andyjpb@ashurst.eu.org>
MIME-Version: 1.0
References: <4F3803B1.1090205@ashurst.eu.org> <20120212200647.GI12836@dastard>
In-Reply-To: <20120212200647.GI12836@dastard>
Subject: Re: Disk spin down
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
Cc: xfs@oss.sgi.com

Hi,

> Seems to me that something is still dirtying an inode regularly.
> 
> Perhaps you need to look at the XFS and writeback event traces to
> find out what process is dirtying the inode. trace-cmd is your
> friend...

Something like this?

-----
echo 1 > /sys/kernel/debug/tracing/events/xfs/enable

echo 0 > /sys/kernel/debug/tracing/events/xfs/enable

more /sys/kernel/debug/tracing/trace
-----


I tried recreating the situation of the last 2 days (clean boot, stopped
services) and it's currently quiescing nicely. :-(

I'll keep an eye on it and try to catch it in the act but every time I
turn the tracing on the HDD light stays firmly off. :-(







Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0x7EBA75FF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
