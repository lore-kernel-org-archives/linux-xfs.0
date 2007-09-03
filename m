Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Sep 2007 07:24:25 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.179])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l83EOL4p026025
	for <linux-xfs@oss.sgi.com>; Mon, 3 Sep 2007 07:24:22 -0700
Received: by wa-out-1112.google.com with SMTP id k22so2006145waf
        for <linux-xfs@oss.sgi.com>; Mon, 03 Sep 2007 07:24:21 -0700 (PDT)
Message-ID: <5d96567b0709030724w3098395bnbd511fa3819e5b22@mail.gmail.com>
Date: Mon, 3 Sep 2007 17:24:21 +0300
From: Raz <raziebe@gmail.com>
Subject: Re: raid50 and 9TB volumes
In-Reply-To: <5d96567b0708070220u23c895ffk54849fca947b5100@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com>
	 <5d96567b0707160653m5951fac9v5a56bb4c92174d63@mail.gmail.com>
	 <20070716221831.GE31489@sgi.com>
	 <18076.1449.138328.66699@notabene.brown>
	 <20070717001205.GI31489@sgi.com>
	 <18076.4940.845633.149160@notabene.brown>
	 <20070717005854.GL31489@sgi.com>
	 <5d96567b0707222309y61480271xa8220a0b179764e0@mail.gmail.com>
	 <20070724010105.GN31489@sgi.com>
	 <5d96567b0708070220u23c895ffk54849fca947b5100@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-xfs@oss.sgi.com

Dave hello.
What is the curret status of this problem ? If you recall , xfs in 32bit
over 10 TB md device ( raid50 in this case) sees only 8TB ( and no more).
The disks I am using are 750GB hitachi.
kernel is 2.6.17.

thank you
raz


On 8/7/07, Raz <raziebe@gmail.com> wrote:
> On 7/24/07, David Chinner <dgc@sgi.com> wrote:
> > On Mon, Jul 23, 2007 at 09:09:03AM +0300, Raz wrote:
> > > My QA to re-installed the system. same kernel, different results. now,
> > > /proc/paritions
> > > reports :
> > >   9     1 5114281984 md1
> > >   9     2 5128001536 md2
> > >   9     3 10242281472 md3
> > >
> > > blockdev --getsize64 /dev/md3
> > > 10488096227328
> > >
> > > but xfs keeps on crashing. when formatting it ot 6.3 TB we're OK. when
> > > letting xfs's mkfs choose the
> >
> > So at 6.3TB everything is ok. At what point does it start having
> > problems? 6.4TB, 6.8TB, 8TB, 9TB?
> over 8 TB. we checked several times. in 8.5 it crashes.
> > I know Neil pointed out that you shouldn't have 10TB but closer to
> > 7TB - is this true?
> the drives are of 750 GB each.
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > Principal Engineer
> > SGI Australian Software Group
> >
>
>
> --
> Raz
>


-- 
Raz
