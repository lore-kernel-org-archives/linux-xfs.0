Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p447WiS1063698 for <xfs@oss.sgi.com>; Wed, 4 May 2011 02:32:44 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5154142C743
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 00:36:20 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BL8aocg8MRSomPrb for <xfs@oss.sgi.com>;
	Wed, 04 May 2011 00:36:20 -0700 (PDT)
Date: Wed, 4 May 2011 17:36:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110504073615.GD9114@dastard>
References: <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
	<20110429201701.GA13166@x4.trippels.de>
	<alpine.DEB.2.01.1104291710340.18728@trent.utfs.org>
	<20110501080149.GD13542@dastard>
	<alpine.DEB.2.01.1105012135260.18728@trent.utfs.org>
	<20110502121958.GA2978@dastard>
	<alpine.DEB.2.01.1105021247410.18728@trent.utfs.org>
	<20110503005114.GE2978@dastard>
	<alpine.DEB.2.01.1105031345090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1105031740460.18728@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: minchan.kim@gmail.com, LKML <linux-kernel@vger.kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On Tue, May 03, 2011 at 05:46:14PM -0700, Christian Kujau wrote:
> And another one, please see the files marked with 15- here:
> 
>    https://trent.utfs.org/p/bits/2.6.39-rc4/oom/trace/
> 
> I tried to have more concise timestamps in each of these files, hope that 
> helps. Sadly though, trace-cmd reports still segfaults on the tracefile.

Ok, that will be helpful. Also helpful is that I've (FINALLY!)
reproduced this myself, and i think i can now reproduce it at will
on a highmem i686 machine. I'll look into it more later tonight....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
