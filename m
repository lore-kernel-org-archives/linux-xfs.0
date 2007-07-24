Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 18:01:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6O11Ebm023446
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 18:01:18 -0700
Date: Tue, 24 Jul 2007 11:01:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raid50 and 9TB volumes
Message-ID: <20070724010105.GN31489@sgi.com>
References: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com> <20070716130140.GC31489@sgi.com> <5d96567b0707160653m5951fac9v5a56bb4c92174d63@mail.gmail.com> <20070716221831.GE31489@sgi.com> <18076.1449.138328.66699@notabene.brown> <20070717001205.GI31489@sgi.com> <18076.4940.845633.149160@notabene.brown> <20070717005854.GL31489@sgi.com> <5d96567b0707222309y61480271xa8220a0b179764e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0707222309y61480271xa8220a0b179764e0@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jul 23, 2007 at 09:09:03AM +0300, Raz wrote:
> My QA to re-installed the system. same kernel, different results. now,
> /proc/paritions
> reports :
>   9     1 5114281984 md1
>   9     2 5128001536 md2
>   9     3 10242281472 md3
> 
> blockdev --getsize64 /dev/md3
> 10488096227328
> 
> but xfs keeps on crashing. when formatting it ot 6.3 TB we're OK. when
> letting xfs's mkfs choose the

So at 6.3TB everything is ok. At what point does it start having
problems? 6.4TB, 6.8TB, 8TB, 9TB?

I know Neil pointed out that you shouldn't have 10TB but closer to
7TB - is this true?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
