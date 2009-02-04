Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14FY879159535 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 09:34:08 -0600
Received: from theco.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7853618C1B62
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 07:33:25 -0800 (PST)
Received: from theco.de (scout.theco.de.mind.de [212.42.230.55]) by
	cuda.sgi.com with ESMTP id vc8xWwfknJLKQsGt for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 07:33:25 -0800 (PST)
Date: Wed, 4 Feb 2009 16:33:22 +0100
From: Ralf Liebenow <ralf@theco.de>
Subject: Re: xfs_force_shutdown after Raid crash
Message-ID: <20090204153322.GC15454@theco.de>
References: <498376CF.8020806@renderforce.de> <200902031140.08576@zmi.at>
	<20090203154907.GA21278@infradead.org>
	<200902040952.45440@zmi.at> <20090204122241.GL24173@disturbed>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090204122241.GL24173@disturbed>
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

Maybe this is a stupid question:

Should Battery backed RAID controllers not always set their discs cache off=
 ?

As I see it (in case of a power failure):
  - the discs are connectet to the main power, so if there is a power
    failure they're offline at that moment in time and their (write) cache =
will
    be gone in that instance of time too =


  - if they are connected to a battery backed RAID cache, I assume that
    this cache will be written as soon as the system is online again
    (if the battery lasts that long)

  - if a RAID controller does not turn off the disks write cache, the contr=
oller
    cannot know if previous writes have made it to the disk. A good
    RAID Controller would also use its cache to re-organise the disc =

    writes to minimize seek times doing somthing like intelligent
    command queuing. This would also mean, that any order of writes
    to a disk could have been changed by the controller. This would
    ultimately break any filesystem which does not explicitly fsyncing
    consistent checkpoints to the disk, which would make battery backed
    RAID Systems pretty useless ... would it ?
  =

    So .. a battery backed RAID controller should default to "no disk write=
 cache"
    should it ? Otherwise why should anyone want to use such expensive
    controllers ... it just does not make sense to have a battery backed
    cache on the controller, when things get inconsistent at a power
    outage ... It wouldn't have any purpuse ... I hope developers of
    battery backed RAID controllers are aware of that implication ...

  Greets
    Ralf

> On Wed, Feb 04, 2009 at 09:52:45AM +0100, Michael Monnerie wrote:
> > On Dienstag 03 Februar 2009 Christoph Hellwig wrote:
> > > Yeah, that sounds correct. =A0Do you volunteer for the FAQ entry?
> > > =A0xfs.org is a wiki so you could add it. =A0I'm happy to proof-read =
it
> > > if you want.
> > =

> > I don't know if it's good and correct, I just put this in the wiki, and =

> > additionally changed 2 sections, please check the wiki log if it's =

> > correct:
> > =

> > =3D=3D Q. What about the hard disk write cache? =3D=3D
> > =

> > The problem with hard disk write caches is that their contents are lost =

> > in case of a power outage. With hard disk cache sizes of currently up t=
o =

> > 32MB that can be a lot of valuable information.
> > =

> > With a single hard disk and barriers turned on (on=3Ddefault), a powerf=
ail =

> > "only" looses data in the cache but at least does not destroy the =

> > filesystem.
> =

> I'd drop this paragraph - powerfail can destroy filesystems even on
> a single disk (e.g. root directory gets corrupted).
> =

> > With a RAID controller with battery backed cache, you should turn off =

> > barriers, as recommended above. But then you *must* disable the hard =

> > disk write cache in order to ensure to keep the filesystem intact after =

> > a power failure.
> =

> I'd change this to say "*must* disable the individual hard disk
> write caches" to make it clear that it is referencing the disks
> behind the raid controller. I'd also say "The method for doing this
> is different for each RAID controller. Please consult your RAID
> controller documentation to determine how to change these settings."
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
