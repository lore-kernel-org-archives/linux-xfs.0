Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 17:12:33 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6H0CTbm009270
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 17:12:30 -0700
From: Neil Brown <neilb@suse.de>
Date: Tue, 17 Jul 2007 09:56:25 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18076.1449.138328.66699@notabene.brown>
Subject: Re: raid50 and 9TB volumes
In-Reply-To: message from David Chinner on Tuesday July 17
References: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com>
	<20070716130140.GC31489@sgi.com>
	<5d96567b0707160653m5951fac9v5a56bb4c92174d63@mail.gmail.com>
	<20070716221831.GE31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Raz <raziebe@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Tuesday July 17, dgc@sgi.com wrote:
> On Mon, Jul 16, 2007 at 04:53:22PM +0300, Raz wrote:
> > 
> > Well you are right.  /proc/partitions  says:
> > ....
> >   8   241  488384001 sdp1
> >   9     1 3404964864 md1
> >   9     2 3418684416 md2
> >   9     3 6823647232 md3
> > 
> > while xfs formats md3 as 9 TB.
> > If i am using LBD , what is the biggest size I can use on i386 ?
> 
> Supposedly 16TB. 32bit x 4k page size = 16TB. Given that the size is
> not being reported correctly, I'd say that this is probably not an
> XFS issue. The next thing to check is how large an MD device you
> can create correctly.
> 
> Neil, do you know of any problems with > 8TB md devices on i386?

Should work, but the amount of testing has been limited, and bugs
have existed.

Each component of a raid5 is limited to 2^32 K by the metadata, so
that is 4TB.  At 490GB, you are well under that.
There should be no problem with a 3TB raid5, providing LBD has been
selected.

raid0 over 3TB devices should also be fine.  There was a bug fixed in
May this year that caused problem with md/raid0 was used over
components larger than 4TB on a 32bit host, but that shouldn't affect
you and it does suggest that someone had success with a very large
raid0 once this bug was fixed.

If XFS is given a 6.8TB devices and formats it as 9TB, then I would be
looking at mkfs.xfs(??).

NeilBrown
