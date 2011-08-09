Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p79BZg8Z091968 for <xfs@oss.sgi.com>; Tue, 9 Aug 2011 06:35:42 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 872D3151EC75
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2011 04:37:02 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8iLCVrFAzKEsWN9r for <xfs@oss.sgi.com>;
	Tue, 09 Aug 2011 04:37:02 -0700 (PDT)
Date: Tue, 9 Aug 2011 21:35:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110809113536.GV3162@dastard>
References: <20110806122556.GB20341@schmorp.de> <20110806142005.GG3162@dastard>
	<20110807014237.GA18909@schmorp.de> <20110807102625.GJ3162@dastard>
	<20110809091643.GA26036@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110809091643.GA26036@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On Tue, Aug 09, 2011 at 11:16:43AM +0200, Marc Lehmann wrote:
> This just in, this was on screen, xfs_fsr was active at the time, kernel
> is tainted:
> 
> [248359.646330] CPU 1
> [248359.646326] last sysfs file: /sys/devices/virtual/net/lo/operstate
> [248359.646323] Oops: 0000 [#1] SMP
> [248359.646319] PGD 8b43067 PUD 1bc63067 PMD 0
> [248359.646292] IP: [<ffffffffa13371ab>] xfs_trans_log_inode+0xb/0x2f [xfs]
> [248359.646285] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018

And the event trace to go along with the xfs-fsr run?

I don't need to know the dmesg output - I need the information in
the event trace from the xfs-fsr run when the problem occurs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
