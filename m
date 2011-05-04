Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44J6Sxn089369 for <xfs@oss.sgi.com>; Wed, 4 May 2011 14:06:29 -0500
Received: from trent.utfs.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 476754302BD
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 12:10:05 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [194.246.123.103]) by
	cuda.sgi.com with ESMTP id gM2zCn7FBK5LFiaE for
	<xfs@oss.sgi.com>; Wed, 04 May 2011 12:10:05 -0700 (PDT)
Date: Wed, 4 May 2011 12:10:04 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110504111211.GF9114@dastard>
Message-ID: <alpine.DEB.2.01.1105041205340.18728@trent.utfs.org>
References: <20110429201701.GA13166@x4.trippels.de>
	<alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
	<20110501080149.GD13542@dastard>
	<alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
	<20110502121958.GA2978@dastard>
	<alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
	<20110503005114.GE2978@dastard>
	<alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
	<20110504073615.GD9114@dastard> <20110504111211.GF9114@dastard>
MIME-Version: 1.0
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
Cc: minchan.kim@gmail.com, LKML <linux-kernel@vger.kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On Wed, 4 May 2011 at 21:12, Dave Chinner wrote:
>> Ok, that will be helpful. Also helpful is that I've (FINALLY!)
>> reproduced this myself, and i think i can now reproduce it at will
>> on a highmem i686 machine. I'll look into it more later tonight....

I've tried to reproduce it on an SMP i686 with 1024MB RAM, but there was 
no OOM there.

> And here's a patch for you to try. It fixes the problem on my test
> machine.....

Excellent! After one run with that patch, the machine does not go OOM any 
more when running du(1) over this XFS filesystem.

I've run du(1) login with my oom-debug script to gather sysrq-w and 
slabinfo, see https://trent.utfs.org/p/bits/2.6.39-rc4/oom/trace/16-* for 
the details.

I'll poke it a bit more over the day, but your patch (one line only! Wow!) 
seems to help.

Thanks so much,
Christian.
-- 
BOFH excuse #160:

non-redundant fan failure

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
