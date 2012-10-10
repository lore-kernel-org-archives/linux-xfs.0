Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9ALQ6nO160704 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 16:26:06 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	m8AQe1juDy6RllWS for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2012 14:27:36 -0700 (PDT)
Date: Thu, 11 Oct 2012 08:27:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: A little RAID experiment
Message-ID: <20121010212733.GW23644@dastard>
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEwYyzTLTJk7SU0t=1SnT-V=7VadtKd0v9qj0soXtJ8XTg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAxjCEwYyzTLTJk7SU0t=1SnT-V=7VadtKd0v9qj0soXtJ8XTg@mail.gmail.com>
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
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Wed, Oct 10, 2012 at 04:57:47PM +0200, Stefan Ring wrote:
> Btw, one of our customers recently aquired new gear with HP SmartArray
> Gen8 controllers. Now they are something to get excited about! This is
> the kind of write performance I would expect from an expensive server
> product. Check this out (this is again my artificial benchmark as well
> as random write of 4K blocks):
> 
> SmartArray P400, 6 300G disks (10k, SAS) RAID 6, 256M BBWC:
                                                   ^^^^
.....

> SmartArray Gen8, 8 300G disks (15k, SAS) RAID 5, 2GB FBWC:
                                                   ^^^^

That's the reason for the difference in performance...

> So yeah, the disks are a bit faster. But what does that matter when
> there is such a huge difference otherwise?

Just inidicates that the working set for your test is much more
resident in the controller cache - has nothing to do with the disk
speeds. Tun a larger set of files/workload and the results will end
up a lot closer to disk speed instead of cache speed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
