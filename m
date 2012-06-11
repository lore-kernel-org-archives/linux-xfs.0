Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BDDIko091222 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 08:13:18 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id N18GKBg0aIYqEIXf
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 06:13:17 -0700 (PDT)
Message-ID: <4FD5EEEB.6060709@hardwarefreak.com>
Date: Mon, 11 Jun 2012 08:13:15 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: block sizes > 4K ??  possible w/large page support?
References: <4FD5643F.5070801@tlinx.org>
In-Reply-To: <4FD5643F.5070801@tlinx.org>
Reply-To: stan@hardwarefreak.com
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 6/10/2012 10:21 PM, Linda A. Walsh wrote:
> Is this something being thought about??

Probably not much these days, but I'm sure it's been debated much over
the years amongst many filesystem and kernel developers across all
operating system teams, including Linux, *nix, VMS, MVS, and Windows.

...
> All but 2 could benefit from a 16K block size, and 3 of them could benefit
> from a 128K block size.  Wouldn't that benefit in  in freeing up some space
> both on disk and in memory?  Just a thought.

If you could increase the page size and thus the XFS block size to some
arbitrarily high number such as 64KB, it would do nothing for on disk
layout but increase wasted disk sectors.  It would increase transfer
performance on some workloads, but it would also cause a myriad of
problems.  Not least of which is the need to recode, debug, and
regression test the entire x86[64] kernel to use properly use 64KB
pages, which I assume is no small task.

Everything is a tradeoff Linda.  At this point, 4KB appears to be the
best tradeoff.  And again, even if it were increased, it wouldn't do
anything to benefit the case the you mention, but would actually hurt
it, because you'd end up with more wasted sectors at the end of each file.

Array controllers and disks have no awareness of the FS block size.
They simply swallow or sling 512B sectors from/to the block layer.  It's
the block layer that can benefit from being fed larger FS blocks as it
can schedule transfers more efficiently.  For instance, allowing the
elevator the potential to order sector accesses, minimizing head seeks.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
