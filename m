Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Dec 2007 11:54:07 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBKJrqlg031174
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 11:53:59 -0800
Received: from email.msoe.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA655B8D19A
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 11:54:05 -0800 (PST)
Received: from email.msoe.edu (email.msoe.edu [155.92.194.61]) by cuda.sgi.com with ESMTP id LHcFtCS2ls8DtpYt for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 11:54:05 -0800 (PST)
Date: Thu, 20 Dec 2007 13:54:02 -0600
From: "Jonathan C. Detert" <Jonathan.Detert@msoe.edu>
Subject: Re: mount prob: "log inconsistent or not a log"
Message-ID: <20071220195402.GC6476@msoe.edu>
References: <20071220000144.GQ19770@msoe.edu> <4769BD13.5040303@sgi.com> <20071220011601.GU19770@msoe.edu> <4769F343.9040405@sgi.com> <20071220050445.GA3212@msoe.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220050445.GA3212@msoe.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Jonathan C. Detert <Jonathan.Detert@msoe.edu> [071219 23:04]:
> * Timothy Shimmin <tes@sgi.com> [071219 22:43]:
> > Jonathan C. Detert wrote:
> > >* Timothy Shimmin <tes@sgi.com> [071219 18:53]:
> > >>Hi Jonathan,
> 
> -- snip --
> 
> > >-- snip --
> > >
> > >>An "xfs_logprint -d /dev/sdb" will show what the cycle#s are
> > >>and where the log records are. It might give an idea of the
> > >>extent of the corruption.
> > >
> > >Ok.  It doesn't enlighten me, but hopefully you or others can take time
> > >to see it, and maybe it will enlighten you.  Here it is:
> > >-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> > >root@quartz:~ # xfs_logprint -d /dev/sdb > xfs_logprint.out
> > >xfs_logprint:
> > >    data device: 0x810
> > >    log device: 0x810 daddr: 39859232 length: 38920
> > >
> > >[00000 - 00000] Cycle 0xffffffff New Cycle 0x00000256
> > >    12 HEADER Cycle 598 tail 598:000010 len    224 ops 5
> 
> -- snip --
> 
> > > 38770 HEADER Cycle 597 tail 597:036946 len  32256 ops 101
> > > 38834 HEADER Cycle 597 tail 597:036946 len  32256 ops 145
> > >[25405 - 38888] Cycle 0x00000255 New Cycle 0x00000000
> > >root@quartz:~ #
> > >-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> > 
> > Well, that confirms why it won't replay.
> > There shouldn't be a cycle# change from 597 to zero.
> > This actually shows the cycle#s at the log record headers
> > (not all the sector cycle#s).
> > 
> > At the end we are writing out full iclog buffers of 32k each.
> > Hence the length of 32256 and 64 BBs (32k) between the headers.
> > 
> > Now at the end, we would expect...
> > 38834 .. 38834+64=38898 of cycle#s of 597 for that log record.
> > But at 38889 it goes to zero cycle#.
> > So that log record is corrupted at around 54 BBs (27K into the 32K).
> > 
> > And then for the last (38920-38888 = 32) BBs (16K) of the
> > log we don't find a log record header.
> > 
> > I would expect the log head to be at the cycle# change from 598->597.
> > 
> > >  25398 HEADER Cycle 598 tail 598:025428 len    996 ops 14
> > >  25401 HEADER Cycle 598 tail 598:025430 len    224 ops 5
> > >  25403 HEADER Cycle 598 tail 598:025433 len    224 ops 5 <--- head
> > > [00000 - 25405] Cycle 0x00000256 New Cycle 0x00000255
> > >  25420 HEADER Cycle 597 tail 597:025329 len  32256 ops 133
> > >  25484 HEADER Cycle 597 tail 597:025329 len  32256 ops 112
> > >  25548 HEADER Cycle 597 tail 597:025329 len  32256 ops 101
> > 
> > ie. the last LR written at 598:25403.
> > I was surprised to see the tail at the time at 598:25433,
> > as that makes the tail into the future.
> > That looks weird to me. Or perhaps I'm missing something.
> > If there's corruption that was not between the tail to the head,
> > then it could be a goer I guess but one would wonder about corruption
> > beyond the end of the log too. But the tail looks weird.

Another question:

	do you think it's worth me trying an xfs_repair with the -L
	flag:
	-L     Force Log Zeroing.  Forces xfs_repair to zero the log
		even if it is  dirty (contains  metadata  changes).
		When using this option the filesystem will likely appear
		to be corrupt, and can cause the loss of user  files
		and/or data.

Another observation:

	if/when I do an fdisk on /dev/sdb, I see this warning message:

	Warning: invalid flag 0x0000 of partition table 4 will be
	corrected by w(rite)

	I never put a paritition table on this disk, so I don't know if
	that warning is really a concern or not.
-- 
Jon Detert
IT Systems Administrator, Milwaukee School of Engineering
1025 N. Broadway, Milwaukee, Wisconsin 53202, U.S.A.
--
Never do anything against conscience, even if the state demands it.
