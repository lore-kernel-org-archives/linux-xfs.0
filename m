Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBEIDbXf010370 for <xfs@oss.sgi.com>; Sun, 14 Dec 2008 12:13:37 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6F31172E2E8
	for <xfs@oss.sgi.com>; Sun, 14 Dec 2008 10:13:35 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id NJmgndB7Uz70Upwi for
	<xfs@oss.sgi.com>; Sun, 14 Dec 2008 10:13:35 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Sun, 14 Dec 2008 19:12:51 +0100
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<1229225480.16555.152.camel@localhost>
	<18757.4606.966139.10342@tree.ty.sabi.co.uk>
	(sfid-20081214_183524_928808_CA8411E0)
In-Reply-To: <18757.4606.966139.10342@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Message-Id: <200812141912.59649.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5667412010013938581=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Linux RAID <linux-raid@vger.kernel.org>

--===============5667412010013938581==
Content-Type: multipart/signed;
  boundary="nextPart7278677.KeuEffjm2a";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart7278677.KeuEffjm2a
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag 14 Dezember 2008 schrieb Peter Grandi:
> First of all, why are you people sending TWO copies to the XFS
> mailing list? (to both linux-xfs@oss.sgi.com and xfs@oss.sgi.com).

Just took the CC as it seems to be custom on xfs mailinglist to take it. I=
=20
stripped it this time.

> >>> At the moment it appears to me that disabling write cache
> >>> may often give more performance than using barriers. And
> >>> this doesn't match my expectation of write barriers as a
> >>> feature that enhances performance.
> >>
> >> Why do you have that expectation?  I've never seen barriers
> >> advertised as enhancing performance.  :)
>
> This entire discussion is based on the usual misleading and
> pointless avoidance of the substance, in particular because of
> stupid, shallow diregard for the particular nature of the
> "benchmark" used.
>
> Barriers can be used to create atomic storage transaction for
> metadata or data. For data, they mean that 'fsync' does what is
> expected to do. It is up to the application to issue 'fsync' as
> often or as rarely as appropriate.
>
> For metadata, it is the file system code itself that uses
> barriers to do something like 'fsync' for metadata updates, and
> enforce POSIX or whatever guarantees.
>
> The "benchmark" used involves 290MB of data in around 26k files
> and directories, that is the average inode size is around 11KB.
>
> That means that an inode is created and flushed to disk every
> 11KB written; a metadata write barrier happens every 11KB.
>
> A synchronization every 11KB is a very high rate, and it will
> (unless the disk host adapter or the disk controller are clever
> mor have battery backed memory for queues) involve a lot of
> waiting for the barrier to complete, and presumably break the
> smooth flow of data to the disk with pauses.

But - as far as I understood - the filesystem doesn't have to wait for=20
barriers to complete, but could continue issuing IO requests happily. A=20
barrier only means, any request prior to that have to land before and any=
=20
after it after it. It doesn't mean that the barrier has to land=20
immediately and the filesystem has to wait for this.

At least that always was the whole point of barriers for me. If thats not=
=20
the case I misunderstood the purpose of barriers to the maximum extent=20
possible.

> Also whether or not the host adapter or the conroller write
> cache are disabled, 290MB will fit inside most recent hosts' RAM
> entirely, and even adding 'sync' at the end will not help that
> much as to helping with a meaningful comparison.

Okay, so dropping caches would be required. Got that in the meantime.

> > My initial thoughts were that write barriers would enhance
> > performance, in that, you could have write cache on.
>
> Well, that all depends on whether the write caches (in the host
> adapter or the controller) are persistent and how frequently
> barriers are issued.
>
> If the write caches are not persistent (at least for a while),
> the hard disk controller or the host adapter cannot have more
> than one barrier completion request in flight at a time, and if
> a barrier completion is requested every 11KB that will be pretty
> constraining.

Hmmm, didn't know that. How comes? But the IO scheduler should be able to=
=20
handle more than one barrier request at a time, shouldn't it? And even=20
than how can it be slower writing 11 KB at a time than writing every IO=20
request at a time - i.e. write cache *off*.

> Barriers are much more useful when the host adapter or the disk
> controller can cache multiple transactions and then execute them
> in the order in which barriers have been issued, so that the
> host can pipeline transactions down to the last stage in the
> chain, instead of operating the last stages synchronously or
> semi-synchronously.
>
> But talking about barriers in the context of metadata, and for a
> "benchmark" which has a metadata barrier every 11KB, and without
> knowing whether the storage subsystem can queue multiple barrier
> operations seems to be pretty crass and meangingless, if not
> misleading. A waste of time at best.

Hmmm, as far as I understood it would be that the IO scheduler would=20
handle barrier requests itself if the device was not capable for queuing=20
and ordering requests.

Only thing that occurs to me know, that with barriers off it has more=20
freedom to order requests and that might matter for that metadata=20
intensive workload. With barriers it can only order 11 KB of requests.=20
Without it could order as much as it wants... but even then the=20
filesystem would have to make sure that metadata changes land in the=20
journal first and then in-place. And this would involve a sync, if no=20
barrier request was possible.

So I still don't get why even that metadata intense workload of tar -xf=20
linux-2.6.27.tar.bz2 - or may better bzip2 -d the tar before - should be=20
slower with barriers + write cache on than with no barriers and write=20
cache off.

> > So its really more of an expectation that wc+barriers on,
> > performs better than wc+barriers off :)
>
> This is of course a misstatement: perhaps you intended to write
> that ''wc on+barriers on'' would perform better than ''wc off +
> barriers off'.
>
> As to this apparent anomaly, I am only mildly surprised, as
> there are plenty of similar anomalies (why ever should have a
> very large block device readahead to get decent performance from
> MD block devices?), due to poorly ill conceived schemes in all
> sorts of stages of the storage chain, from the sometimes
> comically misguided misdesigns in the Linux block cache or
> elevators or storage drivers, to the often even worse
> "optimizations" embedded in the firmware of host adapters and
> hard disk controllers.

Well and then that is something that could potentially be fixed!

> Consider for example (and also as a hint towards less futile and
> meaningless "benchmarks") the 'no-fsync' option of 'star', the
> reasons for its existence and for the Linux related advice:
>
>   http://gd.tuwien.ac.at/utils/schilling/man/star.html
>
>     =AB-no-fsync
>           Do not call  fsync(2)  for  each  file  that  has  been
>           extracted  from  the archive. Using -no-fsync may speed
>           up extraction on operating systems with slow  file  I/O
>           (such  as  Linux),  but includes the risk that star may
>           not be able to detect extraction  problems  that  occur
>           after  the  call to close(2).=BB
>
> Now ask yourself if you know whether GNU tar does 'fsync' or not
> (a rather interesting detail, and the reasons why may also be
> interesting...).

Talking about less futile benchmarks and mentioning the manpage of a tool=
=20
from a author who is known as Solaris advocate appears to be a bit futile=
=20
in itself for me. Especially if the author tends to chime into into any=20
discussion mentioning his name and at least in my experience is very=20
difficult to talk with in a constructive manner.=20

For me its important to look whether there might be reason to look in more=
=20
detail at how efficient write barriers work on Linux. For that as I=20
mentioned already, testing just this simple workload would not be enough.=
=20
And testing just on XFS neither.

I think this is neither useless nor futile. The simplified benchmark IMHO=
=20
has shown something that deserves further investigation. Nothing more,=20
nothing less.

[1] http://oss.sgi.com/archives/xfs/2008-12/msg00244.html

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart7278677.KeuEffjm2a
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklFTKMACgkQmRvqrKWZhMfDkQCfUtvqiYUWcrUzywC9ABTMfhNx
U9kAn3P022QV8h0HhShvjJqC3vZ72INW
=nPs5
-----END PGP SIGNATURE-----

--nextPart7278677.KeuEffjm2a--


--===============5667412010013938581==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5667412010013938581==--
