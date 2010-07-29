Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58FO2bN011013 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 10:24:02 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30D5B480939
	for <xfs@oss.sgi.com>; Thu, 29 Jul 2010 16:01:54 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	WjtF4ZHRRBojALo4 for <xfs@oss.sgi.com>;
	Thu, 29 Jul 2010 16:01:54 -0700 (PDT)
Date: Fri, 30 Jul 2010 09:01:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: filesystem shrinks after using xfs_repair
Message-ID: <20100729230147.GN655@dastard>
References: <F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
	<20100724023922.GP32635@dastard>
	<777100A1-57DE-4DE0-B1F0-64977BD694AD@ucsc.edu>
	<20100726034545.GE655@dastard>
	<10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>
	<20100726060604.GF7362@dastard>
	<F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>
	<20100726102036.GH7362@dastard>
	<0EC8FE5D-212C-4030-9D59-FDF38DF4E9EE@ucsc.edu>
	<D6C570D6-FEC7-4E3C-AAC2-13275721370A@ucsc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D6C570D6-FEC7-4E3C-AAC2-13275721370A@ucsc.edu>
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
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

On Thu, Jul 29, 2010 at 12:22:30PM -0700, Eli Morris wrote:
> I tried filling up the disk with data to see if that worked Ok and
> it did, up until this point. There is something I don't understand
> going on though. 'df' says that I have 381 GB free on the disk,
> but I can't write to the disk anymore because it says it there
> isn't any space left on it. Is this some insane round off error or
> is there something going on here?

If you haven't specified inode64, then all inodes are located below
the 1TB mark. You've probably run out of space (or contiguous 16k
chunks of free space) below 1TB. Using inode64 will avoid this - for
a filesystem of that size, inode64 is probably a good idea as it
will significantly improve performance.

Keep in mind that legacy 32bit applications may have problems with
64 bit inode numbers, so if you have such applications (or 32 bit
NFS clients) then you need to check carefully as to whether 64 bit
inodes will work correctly or not....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
