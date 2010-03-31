Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2V3wZcl232266 for <xfs@oss.sgi.com>; Tue, 30 Mar 2010 22:58:36 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17D971BCCC6E
	for <xfs@oss.sgi.com>; Tue, 30 Mar 2010 21:00:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	u74giQrhAuGO5MSB for <xfs@oss.sgi.com>;
	Tue, 30 Mar 2010 21:00:18 -0700 (PDT)
Date: Wed, 31 Mar 2010 15:00:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_fsr defrag top 10% that have the largest number of extents??
Message-ID: <20100331040015.GT3335@dastard>
References: <4BB27AFE.2030205@andcycle.idv.tw>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BB27AFE.2030205@andcycle.idv.tw>
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
To: AndCycle <andcycle@andcycle.idv.tw>
Cc: xfs@oss.sgi.com

On Wed, Mar 31, 2010 at 06:28:14AM +0800, AndCycle wrote:
> my xfs_fsr version is xfsdump_2.2.48-1,
> 
> there is a description in xfs_fsr man said
> "
> When invoked with no arguments xfs_fsr reorganizes all regular files
> in all mounted filesystems.
> (...)
> Each pass goes through and selects files that have the largest
> number of extents.  It attempts to defragment the top 10% of these
> files on each pass.
> "
> but xfs_fsr -d telling me it defrags in inode ascending order,
> 
> http://pastebin.com/h0RyZkwA

Look a little closer:

           vvvvvvvvvvvv
ino=603561 extents=1815 can_save=1814 tmp=/.fsr/ag2/tmp14298
ino=12652801 extents=208 can_save=207 tmp=/.fsr/ag2/tmp14298
ino=12652802 extents=164 can_save=163 tmp=/.fsr/ag3/tmp14298
ino=13245759 extents=2 can_save=1 tmp=/.fsr/ag0/tmp14298
ino=77725409 extents=11 can_save=10 tmp=/.fsr/ag3/tmp14298
ino=78685589 extents=2 can_save=1 tmp=/.fsr/ag0/tmp14298
ino=538183901 extents=2 can_save=1 tmp=/.fsr/ag3/tmp14298
ino=543424932 extents=2 can_save=1 tmp=/.fsr/ag0/tmp14298
              ^^^^^^^^^

Apart from ino=77725409, they are in order of most extents to least
extents. Maybe the qsort() library function that is used is not
sorting everything correctly, but overall it looks like it is doing
pretty much what the man page says. The ascending order of the inode
numbers is really just a co-incidence.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
