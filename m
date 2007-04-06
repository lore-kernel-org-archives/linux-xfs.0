Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 07 Apr 2007 06:28:12 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l37DS3fB021195
	for <linux-xfs@OSS.SGI.com>; Sat, 7 Apr 2007 06:28:06 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1HZthd-0005LS-2Q
	for <linux-xfs@OSS.SGI.com>; Fri, 06 Apr 2007 20:02:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17942.39236.623189.817503@base.ty.sabi.co.UK>
Date: Fri, 6 Apr 2007 20:02:28 +0100
Subject: Re: Strange delete performance using XFS
In-Reply-To: <20070405152917.GB23893@tuatara.stupidest.org>
References: <20070404130535.GE18320@mail3b.westend.com>
	<20070404154523.GA20096@tuatara.stupidest.org>
	<20070405072803.GB2759@mail3b.westend.com>
	<20070405152917.GB23893@tuatara.stupidest.org>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

[ ... slowness deleting a lot of inodes ... ]

>> The Dell system has got a battery-backed write-cache. The
>> 3ware system has no battery unit. However it's supposed to
>> provide write cache, too.

Whatever, but you cannot have both metadata consistency and high
speed without fully reliable hw...

> [ ... ] The Dell's raid system can safely buffer outstanding
> writes and flsuh them, the 3ware can't so it stalls waiting
> fot the disks to catch up. [ ... ] I'd be tempted to just use
> the 3ware as a JBOD and use sw, but I'm arguably biased, I've
> had so many reliability and performance problems with hw raid
> over the years

Uhm, I had a friend that worked for a middling storage system
vendor and he was telling me horror stories about bugs and
misdesigns in their quite popular RAID products.

3ware seem to me one of the more reliable RAID brands, their
cautious approach may be why they are slower above.

> I will almost always use sw raid given the choice.

Does not buy you a lot over well designed RAID host adapter.
it is also a lot less convenient.
