Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2FA3sNM121406 for <xfs@oss.sgi.com>; Tue, 15 Mar 2011 05:04:00 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2B9D15939BB
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2011 03:06:47 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	nbjBhefCsKQjQv5H for <xfs@oss.sgi.com>;
	Tue, 15 Mar 2011 03:06:47 -0700 (PDT)
Date: Tue, 15 Mar 2011 21:06:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Some problem about the xfs_db??
Message-ID: <20110315100635.GN15097@dastard>
References: <AANLkTimHb2J80CDYPKCXN3yB5=iQ=1ZvQd4iVBFRuiri@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimHb2J80CDYPKCXN3yB5=iQ=1ZvQd4iVBFRuiri@mail.gmail.com>
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
To: "Vincent,Wei" <weikun0905@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 15, 2011 at 02:46:04PM +0800, Vincent,Wei wrote:
> Hi all
>      I used the xfs_db to check the fragment about my disk.
> First I had format the disk,then I try to write the file on it.
> 5min later, we use df -h to check:
> /dev/sda1               465.6G    295.4M    465.3G   0% /mnt/hdd0
> Now I use the :
> xfs_db -c frag  -r /dev/sda1
> actual 616, ideal 30, fragmentation factor 95.13%
> 
> why?? this is nearly a new disk!!! How can it so many fragments?

What kernel? What's the output of "xfs_info <mntpt>"? What command
did you use to write the file? What's the extent map of the file
look like (i.e. xfs_bmap output)? 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
