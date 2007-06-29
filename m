Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 23:55:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5T6tftL003785
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 23:55:43 -0700
Date: Fri, 29 Jun 2007 16:55:25 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS shrink (step 0)
Message-ID: <20070629065525.GQ31489@sgi.com>
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com> <1182291751.5289.9.camel@localhost> <20070619234248.GT86004887@sgi.com> <46838FB4.1040906@linworks.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46838FB4.1040906@linworks.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <ruben.porras@linworks.de>
Cc: xfs@oss.sgi.com, iusty@k1024.org

On Thu, Jun 28, 2007 at 12:38:44PM +0200, Ruben Porras wrote:
> David Chinner wrote:
> >No, there isn't anything currently in existence to do this.
> >
> >It's not difficult, though. What you need to do is count the number of
> >used blocks in the AGs that will be truncated off, and check whether
> >there is enough free space in the remaining AGs to hold all the
> >blocks that we are going to move.
> >
> >I think this could be done we a single loop across the perag
> >array or with a simple xfs_db wrapper and some shell/awk/perl
> >magic.
> >  
> Do you mind that is it ok to depend on shell/awk/perl?

Sure. We have a few programs that are just shell wrappers
of other xfs programs

e.g:
	xfs_bmap: shell script that calls xfs_io
	xfs_check: shell script that calls xfs_db
	xfs_info: shell script that calls xfs_growfs

> I'll do it in C looping through the perag array.

For something like this it's probably easier to do with shell/perl/awk.

e.g. in shell, the number of ags in the filesystem:

iterate all ags:

numags=`xfs_db -r -c "sb 0" -c "p agcount" /dev/sdb8 | sed -e 's/.* = //'`
lastag=`expr $numags - 1`
for ags in `seq 0 1 $lastag`; do
	....
done

Free space in an AG 0:

xfs_db -r -c "freesp -s -a 0" /dev/sdb8 | awk '/total free blocks/ {print $4}'

And so on. You can peek into pretty much any structure on disk with xfs_db
and you can do it online so it's pretty much perfect for this sort of
checking. I'd start with something like this, and if it gets too complex
then we need to look at integrating it into xfs_db (i.e. writing it in C)....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
