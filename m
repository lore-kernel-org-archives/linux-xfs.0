Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6E94A7F3F
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 18:18:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A574304051
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 16:18:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iAoAKlUxEcTKDLro for <xfs@oss.sgi.com>;
	Thu, 30 Oct 2014 16:18:27 -0700 (PDT)
Date: Fri, 31 Oct 2014 10:04:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
Message-ID: <20141030230457.GK13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<20141029212556.GH13323@dastard>
	<CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>
	<20141030050306.GI13323@dastard>
	<CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>
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
To: Tommy Wu <wu.tommy@gmail.com>
Cc: xfs <xfs@oss.sgi.com>

On Thu, Oct 30, 2014 at 04:39:01PM +0800, Tommy Wu wrote:
> I'm confusing now...
> 
> in the test VM and one of my machine, rebuild xfsdump/xfsprogs will make
> the test work.

I know why, too.

> the xfsdump command I use:
> xfsdump -v debug -l 0 -o -p 300 -J -F -M test -L test -f test.xfsdump
> /mnt/backup > xfsdump.log
> the log:
> https://mega.co.nz/#!xIhTjD6Y!Gwp_ilW5UyRiqn2DSxPTHM0TH5qBghMlKXAmHoWk2iQ

This indicates the bulkstat on the dump side was terminated
prematurely.

> the xfsrestore command I use:
> xfsrestore -v debug,tree=nitty -p 300 -J -f test.xfsdump /vol/backup/x/ >
> xfsrestore.log
> the log:
> https://mega.co.nz/#!oZIFWQST!VUY90EZ8XvZDYy9GwF5mqtQVtWNW90Sar5MZhNzGbYI

And the errors in the restore side are because there are missing
directory inodes in the dump, hence orphaning occurs.

It might take me a little while to come up with a fix - I've noticed
a few things that I need to check out in more detail in tracking
this down....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
