Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A7BA7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 21:18:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 50187304059
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 19:18:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SEx1V2TF5H3ECdi0 for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 19:18:37 -0700 (PDT)
Date: Wed, 23 Apr 2014 12:18:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: rm -f * on large files very slow on XFS + MD RAID 6 volume of
	15x 4TB of HDDs (52TB)
Message-ID: <20140423021835.GI15995@dastard>
References: <CAHuzUScfp19c_th_pfsZs05+yDz34MuEH-P1f+FF1dcivfH=5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHuzUScfp19c_th_pfsZs05+yDz34MuEH-P1f+FF1dcivfH=5Q@mail.gmail.com>
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
To: Speedy Milan <speedy.milan@gmail.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Ivan Pantovic <gyro.ivan@gmail.com>

[cc xfs@oss.sgi.com]

On Mon, Apr 21, 2014 at 10:58:53PM +0200, Speedy Milan wrote:
> I want to report very slow deletion of 24 50GB files (in total 12 TB),
> all present in the same folder.

total = 1.2TB?

> OS is CentOS 6.4, with upgraded kernel 3.13.1.
> 
> The hardware is a Supermicro server with 15x 4TB WD Se drives in MD
> RAID 6, totalling 52TB of free space.
> 
> XFS is formated directly on the RAID volume, without LVM layers.
> 
> Deletion was done with rm -f * command, and it took upwards of 1 hour
> to delete the files.
> 
> File system was filled completely prior to deletion.

Oh, that's bad. it's likely you fragmented the files into
millions of extents?

> rm was mostly waiting (D state), probably for kworker threads, and

No, waiting for IO.

> iostat was showing big HDD utilization numbers and very low throughput
> so it looked like a random HDD workload was in effect.

Yup, smells like file fragmentation. Non-fragmented 50GB files
should be removed in a few milliseconds. but if you've badly
fragmented the files, there could be 10 million extents in a 50GB
file. A few milliseconds per extent removal gives you....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
