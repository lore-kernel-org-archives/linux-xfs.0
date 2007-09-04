Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Sep 2007 19:50:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l842ot4p010319
	for <linux-xfs@oss.sgi.com>; Mon, 3 Sep 2007 19:50:56 -0700
Message-ID: <46DCC80F.8030000@sandeen.net>
Date: Mon, 03 Sep 2007 21:50:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: raid50 and 9TB volumes
References: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com>  <5d96567b0707160653m5951fac9v5a56bb4c92174d63@mail.gmail.com>  <20070716221831.GE31489@sgi.com>  <18076.1449.138328.66699@notabene.brown>  <20070717001205.GI31489@sgi.com>  <18076.4940.845633.149160@notabene.brown>  <20070717005854.GL31489@sgi.com>  <5d96567b0707222309y61480271xa8220a0b179764e0@mail.gmail.com>  <20070724010105.GN31489@sgi.com>  <5d96567b0708070220u23c895ffk54849fca947b5100@mail.gmail.com> <5d96567b0709030724w3098395bnbd511fa3819e5b22@mail.gmail.com> <alpine.DEB.0.999.0709032053290.7103@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.0.999.0709032053290.7103@sheep.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-xfs@oss.sgi.com

Christian Kujau wrote:
> On Mon, 3 Sep 2007, Raz wrote:
>> What is the curret status of this problem ? If you recall , xfs in 32bit
>> over 10 TB md device ( raid50 in this case) sees only 8TB ( and no more).
>> The disks I am using are 750GB hitachi.
>> kernel is 2.6.17.
> 
> dunno about this particular issue, but you meant "kernel 2.6.17.7 or 
> higher", right? If not: http://oss.sgi.com/projects/xfs/faq.html#dir2

That shouldn't be affected by volume size.

Raz, are you certain that the MD volume is in good shape at this point,
after Neil's questions?  If it's something you can test on, I'd suggest
getting lmdd and writing a pattern directly to the block device,
spanning the 8T point, then go read it back & double check that all is
well.  XFS certainly has been tested at 8T and above; if I had to bet on
it, I'd bet at a problem in another layer, or the configuration.

-Eric
