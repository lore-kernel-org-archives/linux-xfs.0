Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p79GZWEZ108530 for <xfs@oss.sgi.com>; Tue, 9 Aug 2011 11:35:33 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5345F6A270
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2011 09:36:53 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id AiEYN0YHntfHynJG for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2011 09:36:53 -0700 (PDT)
Date: Tue, 9 Aug 2011 18:35:25 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110809163525.GB22940@schmorp.de>
References: <20110806122556.GB20341@schmorp.de> <20110806142005.GG3162@dastard>
	<20110807014237.GA18909@schmorp.de> <20110807102625.GJ3162@dastard>
	<20110809091643.GA26036@schmorp.de> <20110809113536.GV3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110809113536.GV3162@dastard>
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
Cc: xfs@oss.sgi.com

> > [248359.646330] CPU 1
> > [248359.646326] last sysfs file: /sys/devices/virtual/net/lo/operstate
> > [248359.646323] Oops: 0000 [#1] SMP
> > [248359.646319] PGD 8b43067 PUD 1bc63067 PMD 0
> > [248359.646292] IP: [<ffffffffa13371ab>] xfs_trans_log_inode+0xb/0x2f [xfs]
> > [248359.646285] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> 
> And the event trace to go along with the xfs-fsr run?

It wasn't enabled yet, I didn't expect it to lock up so soon, but even if,
we would have to wait for those rare occurances where the kernel oopses
without the box locking up (can take months).

> I don't need to know the dmesg output - I need the information in
> the event trace from the xfs-fsr run when the problem occurs....

And I need an XFS that doesn't oops and takes the box with it to deliver
that :)

In any case, I am confident it will happen sooner or later.

I will then not send any kernel oopses, although I had hoped that 0-ptr
dereferences in a specific part of a function could have been a good hint.

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
