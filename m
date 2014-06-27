Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C03327F96
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 19:04:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB1968F8054
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 17:04:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Z8AeCRHU13wwBvo5 for <xfs@oss.sgi.com>;
	Thu, 26 Jun 2014 17:04:49 -0700 (PDT)
Date: Fri, 27 Jun 2014 10:02:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Repair hangs at inode repair in phase3
Message-ID: <20140627000254.GV9508@dastard>
References: <trinity-20fa04a2-b771-42eb-afb3-a915026306bd-1403810247665@3capp-gmx-bs14>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <trinity-20fa04a2-b771-42eb-afb3-a915026306bd-1403810247665@3capp-gmx-bs14>
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
To: Dragon <Sunghost@gmx.de>
Cc: xfs@oss.sgi.com

[ A couple of email-to-lists tips: Please:

	- don't post in html format, use plain text
	- please don't top post, commentin line
	- fix the in-reply-to fields on your email replies
	  so that mail programs can thread the conversion properly
]

On Thu, Jun 26, 2014 at 09:17:27PM +0200, Dragon wrote:
> i upgraded to debian jessie with xfsprogs 3.2. if i run xfs_repair
> /dev/md2 the system hangs too. If i use -P it ends up with:
> corrupt block 0 in directory inode 2147702899: junking block
> Segmentation fault

Can you run this under a gdb and get a stack trace from where it
crashed. You might need to grab the source and build that to get a
meaningful stack trace....

> No modify flag set, skipping phase 5
> Inode allocation btrees are too corrupted, skipping phases 6 and 7
> No modify flag set, skipping filesystem flush and exiting.

What actually went wrong with your storage? The only time I've seen
that warning is when a raid array had been reconstructed incorrectly
after a series of disk failures. Did your RAID have failures or
reconstruction problems before XFS started reporting errors?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
