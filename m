Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p79MVhvW130350 for <xfs@oss.sgi.com>; Tue, 9 Aug 2011 17:31:44 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A5D24EB3F9
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2011 15:31:42 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	YURbd0roIDg4fWqH for <xfs@oss.sgi.com>;
	Tue, 09 Aug 2011 15:31:42 -0700 (PDT)
Date: Wed, 10 Aug 2011 08:31:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110809223138.GW3162@dastard>
References: <20110806122556.GB20341@schmorp.de> <20110806142005.GG3162@dastard>
	<20110807014237.GA18909@schmorp.de> <20110807102625.GJ3162@dastard>
	<20110809091643.GA26036@schmorp.de> <20110809113536.GV3162@dastard>
	<20110809163525.GB22940@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110809163525.GB22940@schmorp.de>
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

On Tue, Aug 09, 2011 at 06:35:25PM +0200, Marc Lehmann wrote:
> > > [248359.646330] CPU 1
> > > [248359.646326] last sysfs file: /sys/devices/virtual/net/lo/operstate
> > > [248359.646323] Oops: 0000 [#1] SMP
> > > [248359.646319] PGD 8b43067 PUD 1bc63067 PMD 0
> > > [248359.646292] IP: [<ffffffffa13371ab>] xfs_trans_log_inode+0xb/0x2f [xfs]
> > > [248359.646285] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> > 
> > And the event trace to go along with the xfs-fsr run?
> 
> It wasn't enabled yet, I didn't expect it to lock up so soon, but even if,
> we would have to wait for those rare occurances where the kernel oopses
> without the box locking up (can take months).
> 
> > I don't need to know the dmesg output - I need the information in
> > the event trace from the xfs-fsr run when the problem occurs....
> 
> And I need an XFS that doesn't oops and takes the box with it to deliver
> that :)
> 
> In any case, I am confident it will happen sooner or later.
> 
> I will then not send any kernel oopses, although I had hoped that 0-ptr
> dereferences in a specific part of a function could have been a good hint.

They tell me where the crash occurred - they don't tell me the root
cause of the problem. Understanding the root cause and fixing that
is more important that putting a bandaid over the resultant panic
(which I'll probably do anyway at the same time).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
