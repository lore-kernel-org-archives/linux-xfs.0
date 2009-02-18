Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1INAdda062795 for <xfs@oss.sgi.com>; Wed, 18 Feb 2009 17:10:39 -0600
Received: from theco.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7FF51966F5A
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2009 15:10:03 -0800 (PST)
Received: from theco.de (scout.theco.de.mind.de [212.42.230.55]) by
	cuda.sgi.com with ESMTP id ESm0EtYf4BbHpOBA for
	<xfs@oss.sgi.com>; Wed, 18 Feb 2009 15:10:03 -0800 (PST)
Date: Thu, 19 Feb 2009 00:09:58 +0100
From: Ralf Liebenow <ralf@theco.de>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Message-ID: <20090218230958.GA6506@theco.de>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<200812141912.59649.Martin@lichtvoll.de>
	<18757.33373.744917.457587@tree.ty.sabi.co.uk>
	<200812151948.59870.Martin@lichtvoll.de>
	<18758.57121.570007.816329@tree.ty.sabi.co.uk>
	<B50173E3-7975-4A71-903A-A76D910CBB3A@mailcan.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <B50173E3-7975-4A71-903A-A76D910CBB3A@mailcan.com>
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

> Correct ordering can be proven to be enough to provide transactional
> correctness, enough to ensure that filesystems can not get corrupted
> on power down.

Please beware that caching RAID controllers which are not battery
backed and the harddisk (when write caching) may decide to =

re-order writes to the disk, so the ordering imposed by the =

operating system (filesystem driver) may not be retained. =

This is usually done by harddisks and
controllers to minimize seek times and thats what disk
command queueing is good for. So ordering can only be retained
if all external caching mechanism and command queueing are
switched off. Otherwise you need to have something like fsync
points (barriers ?) to have consistent checkpoints you can
rollback to ...

So the answer has many variables: =

  do you have a persistent (battery backed) write cache ?

    Yes -> you can go with nobarriers if you can make sure
           that the harddisk cache is off, if the
           filesystem does proper write ordering.

    No  -> if you switch off the disks cache, you _may_
           switch off barriers, when the filesystem driver
           uses properly placed write ordering

        -> if you have disk write caching on, you are on
           your own when power goes down and you dont
           use barriers ... you maybe lucky or not ...
           But to make that clear: its only a problem
           when power is failing ... its not a problem
           when the machine crashes ... the disks will
           eventually write down their caches then.
           So if your system is somewhere connected with
           a redundant power supply and failsave power
           supply sytems (as this is the case for most
           data centers) you can probably live with
           disk write caching on and nobarriers, if the
           filesystem driver does order its writes
           properly ....

So I have one open question left: does xfs do proper
(transactional) ordering when barriers are off ? Im using
xfs for years now and had many machine crashes (not
power failures) without xfs get corrupted (and that was
before 2.6.17 ... and therefore without barrier support).
So I assume it always does proper ordering and barrier
support is only making "fsynced" checkpoints in time.

Am I right ?

   Ralf

> Hello,
> =

> On 15 dec 2008, at 23:50, Peter Grandi wrote:
> =

> >[ ... ]
> >
> >>>The purpose of barriers is to guarantee that relevant data is
> >>>known to be on persistent storage (kind of hardware 'fsync').
> >>>
> >
> >>[ ... ] Unfortunately in my understanding none of this is
> >>reflected by Documentation/block/barrier.txt
> >
> >But we are talking about XFS and barriers here. That described
> >just a (flawed, buggy) mechanism to implement those. Consider
> >for example:
> >
> > http://www.xfs.org/index.php/XFS_FAQ#Write_barrier_support.
> > http://www.xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with=
_storage_which_has_a_persistent_write_cache.3F
> >
> >In any case as to the kernel "barrier" mechanism, its
> >description is misleading because it heavily fixates on the
> >ordering issue, which is just a consequence, but yet mentions
> >the far more important "flush/sync" aspect.
> >
> >Still, there is a lot of confusion about barrier support and
> >what it means at which level, as reflected in several online
> >discussions and the different behaviour of different kernel
> >versions.
> >
> The semantics of a barrier are whatever semantics we describe to it.  =

> So we can continue to be confused about it.
> =

> I strongly disagree on the ordering issue being a side effect.
> =

> Correct ordering can be proven to be enough to provide transactional  =

> correctness, enough to ensure that filesystems can not get corrupted  =

> on power down.
> =

> Using barriers to guarantee that (all submitted) write requests  =

> (before the barrier) made it to the medium are a stronger predicate.
> =

> The Linux approach and documentation talks about the first type of  =

> semantics (which I rather like for them being strong enough and not  =

> more).
> =

> Regards,
> =

> Leon
> =

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
