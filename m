Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAK6guvE125589 for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 00:42:57 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50DA89EA35
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 22:43:19 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	kSQ2oV9zLuAA03CI for <xfs@oss.sgi.com>;
	Thu, 19 Nov 2009 22:43:19 -0800 (PST)
Date: Fri, 20 Nov 2009 17:43:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Improving XFS desktop performance?
Message-ID: <20091120064316.GB3804@discord.disaster>
References: <74fd948d0911191805m30c34b51m97c2a998dbe0bac3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <74fd948d0911191805m30c34b51m97c2a998dbe0bac3@mail.gmail.com>
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
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 20, 2009 at 02:05:01AM +0000, Pedro Ribeiro wrote:
> And on /etc/fstab mount it as;
> /dev/mapper/target      noatime,logbufs=8,logbsize=256k
> 
> After the above, my delete speed improved drastically.

That would be the logbsize option your specified - logbufs=9 is the
default.

> Searching around the net I was able to find that using "lazy-count=1"
> on mkfs would give a performance increase - how much would that be,
> enough for me to do a full backup, format with that option + 128m log
> and then restore all again?

It depends on your workload. If you are doing lots of stuff in
parallel, then it makes a big difference because it removes the
superblock as a single point of contention. It also has the effect
of reducing the latency of fsync() if allocation was required.

Neither will affect typical desktop workloads unless you are
doing multi-media work, in which case the latency reduction of
lazy-count=1 make a big difference.

> And anything else you recommend?

No, the defaults set most of the best options for performance.
We probably should set lazy-count=1 as the default now that most
distros have picked up kernels that support that option now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
