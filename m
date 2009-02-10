Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1AJfkpZ070802 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 13:41:46 -0600
Received: from theco.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D18F19117DF
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 11:41:07 -0800 (PST)
Received: from theco.de (scout.theco.de.mind.de [212.42.230.55]) by
	cuda.sgi.com with ESMTP id fZIfVDgeIqLwrsIY for
	<xfs@oss.sgi.com>; Tue, 10 Feb 2009 11:41:07 -0800 (PST)
Date: Tue, 10 Feb 2009 20:41:03 +0100
From: Ralf Liebenow <ralf@theco.de>
Subject: Re: XFS Kernel 2.6.27.7 oopses
Message-ID: <20090210194103.GA18502@theco.de>
References: <20090130222359.GB32142@theco.de>
	<20090201003744.GB24173@disturbed>
	<20090205053847.GA24841@theco.de> <20090210095045.GL8830@disturbed>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090210095045.GL8830@disturbed>
Reply-To: ralf@theco.de
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello !

Here are my mount settings:

cat  /proc/self/mounts

..
/dev/sdc1 /backup xfs rw,nobarrier,logbufs=3D8,logbsize=3D256k,noquota 0 0

This is my current setting, but it also happend before i changed the
settings. Before I had it with this:

/dev/sdc1 /backup xfs rw,noquota 0 0

The problem occured independently of the settings i changed.

Shall I try to set ikeep/noikeep (whats the default for that ?).

At the moment I have no time to create a minimum Script to
reproduce, but essentially I do the following:
  - I have a tree with about 2 million files in it called daily.1
  - I create a new tree daily.0 with rsync --link-dest=3Ddaily.1
    so that the most (the unchanged ones) of those million files =

    just get hardlinked to the ones in daily.1 and only the
    changed ones are created newly.
  - every day daily.1 gets renamed daily.2 and daily.0 gets
    renamed daily.1 (currently I have rotated to daily.14)
    The oldest daily.X folder gets removed by "rm -rf" which
    is where the oops sometimes (not every time, but often
    enough to reproduce) happens.

So the setting is: I have about 2 million files, and most of
them are multip hardlinked, so i have about > 20 million Inodes
on this system. Every night about 2 million of those inodes
get removed, most of them pointing to files which have other
hardlinks and therefore are not really removed.

> How long does it take to reproduce the problem?

On my system I just need to make a new rsync and remove
some million files/hardlinks, but it take some hours until it happens.
Somtimes it even runs successfully through ...

As I said before an xfs_check/xfs_repair does not detect any
incosistencies after the problem happend. ( But the rm process
hangs and the filesystem cannot be umounted any more )

I need to see, if the problem is with the massive hardlinking,
or if it just can be reproduced by creating 20 million files,
and remove them in one sweep ... I will check it, when i have
the time.

  Greets
    Ralf

> On Thu, Feb 05, 2009 at 06:38:47AM +0100, Ralf Liebenow wrote:
> > Hello !
> > =

> > Finally I found the time to compile and test the latest stable 2.6.28.3=
 kernel
> > but I can reproduce it:
> =

> OK.
> =

> .....
> =

> > Hmmm ... can I do something to help you find the problem ? I can
> > reproduce it by creating some millon of hardlinks to files and then rem=
ove some
> > million hardlinks with one "rm -rf"
> =

> Interesting. Sounds like a race between writing back the inode and
> it being freed. How long does it take to reproduce the problem?
> Do you have a script that you could share?
> =

> Next question - what is the setting of ikeep/noikeep in your mount
> options? If you dump /proc/self/mounts on 2.6.28 it will tell us
> if inode clusters are being deleted or not....
> =

> Cheers,
> =

> Dave.
> -- =

> Dave Chinner
> david@fromorbit.com
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


-- =

theCode AG =

HRB 78053, Amtsgericht Charlottenbg
USt-IdNr.: DE204114808
Vorstand: Ralf Liebenow, Michael Oesterreich, Peter Witzel
Aufsichtsratsvorsitzender: Wolf von Jaduczynski
Oranienstr. 10-11, 10997 Berlin [=D7]
fon +49 30 617 897-0  fax -10
ralf@theCo.de http://www.theCo.de

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
