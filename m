Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 07:59:48 -0800 (PST)
Received: from sumo.dreamhost.com (sumo.dreamhost.com [66.33.216.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08Fxgqw004776
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 07:59:43 -0800
Received: from spaceymail-a1.dreamhost.com (sd-green-bigip-62.dreamhost.com [208.97.132.62])
	by sumo.dreamhost.com (Postfix) with ESMTP id 1584C17E75A
	for <xfs@oss.sgi.com>; Mon,  8 Jan 2007 07:35:38 -0800 (PST)
Received: from jupiter.solar.net (cpe-24-27-90-21.houston.res.rr.com [24.27.90.21])
	by spaceymail-a1.dreamhost.com (Postfix) with ESMTP id 308AC194F6C
	for <xfs@oss.sgi.com>; Mon,  8 Jan 2007 07:35:35 -0800 (PST)
From: Joe Bacom <joe@docsimple.com>
Reply-To: joe@docsimple.com
Subject: Re: What's wrong with XFS?
Date: Mon, 8 Jan 2007 09:35:36 -0600
References: <936386.57179.qm@web59111.mail.re1.yahoo.com> <1168267755.29690.13.camel@venus.local.navi.pl>
In-Reply-To: <1168267755.29690.13.camel@venus.local.navi.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1755204.IqRS27UC8K";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200701080935.36736.joe@docsimple.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--nextPart1755204.IqRS27UC8K
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

The solution to Dave's problem seems obvious to me.  If you care about your=
=20
data and your hardware, buy a UPS with power conditioning, configure Linux =
to=20
show down when the battery gets low and enjoy the peace of mind knowing tha=
t=20
even if your away from your machine and the power goes off, the system will=
=20
take care of itself.

Joe

On Monday 08 January 2007 08:49, you wrote:
> On Mon, 2007-01-08 at 05:13 -0800, Dave N wrote:
> > Hi,
> >
> > Can someone enlighten me what the issue is with XFS? I've been hearing a
> > lot of good things on the Net about XFS. How it's lightening fast, how =
it
> > has features other file systems do not have (like GRIO, real time
> > volumes, allocate on flush, etc), how it scales very well, etc... but
> > what I didn't hear about is how fast XFS screws things up if something
> > wrong happens. Because of the good things I heard about XFS, I too
> > decided to try it out (been using Ext3 or ReiserFS here for most of the
> > time). Now I'm very disappointed in XFS. I live in an area where power
> > outages are common and I do not have an UPS here. I have a few computers
> > all running on XFS and thought that XFS will give me similar
> > data-integrity like Ext3 or ReiserFS. Now, for the past few weeks I've
> > been experiencing "strange behavior" from XFS. One time, I was reading =
an
> > article on the Net and had only my Firefox browser open. Then we had a
> > power outage for a short period of time, and when I logged in again into
> > KDE, I was surprised to find out that all my desktop icons were messed =
up
> > all over the place. The other time, again power outage, only this time I
> > was working on a small text file. Booted up again only to find out that
> > the file I was working on contained garbage and I had to start all over
> > again.
> >
> > I also heard that XFS depends heavily on the application side for its
> > data-integrity. XFS "thinks" that the application will use the proper
> > calls when writing to disk. What???? How is it the task of the
> > application to ensure the safety of your files??? IMO, programs are the=
re
> > to provide the tools to be productive, NOT to ensure the data safety of
> > your files, that's the task of the file system. Even MySQL provides me
> > with better data-integrity here. If I'm doing some database transaction
> > and the power fails, I can be pretty sure that *most* of the time, MySQL
> > will be just fine next time I boot up.
> >
> > Why oh why such a beautiful file system like XFS is so terrible at
> > data-integrity? Look what Sun Microsystems did with their new ZFS file
> > system... full atomicity, CRC checksumming and other features to ensure
> > data-integrity... why can't XFS have such things?
> >
> > Thanks for listening to my preaching here guys
> >
> > Cheers!
>
> Hi,
>
> It is nothing wrong with XFS - your expectations are wrong.
>
> You expect data to be journaled, but XFS does journal metadata only, not
> data. So, the thing that you get is filesystem integrity not data
> integrity.
> If you want data integrity you need properly written applications and
> __it is__ application's job to care about it's data. It is nothing
> unusual here.
>
> If you need data journaling then you need another filesystem - eg. ext3.
>
> I suppose that you find all of it in FAQ.
>
> Regards,
>
> Olaf

--=20
A Cringester who requested anonymity says when a friend ran=20
Microsoft BS (Baseline Security) Analyzer on a XP Pro SP2 machine,
the cumulative size of the patches that were required exceeded=20
the size of the original OS.  I'm not surprised.  The volume
of Microsoft BS I've analyzed could fill Bill Gates' house.
Source: Robert X. Cringely, InfoWorld, Sept. 4, 2006, Issue 36

Penguin: Linux version 2.6.16, 8010.09 BogoMips

--nextPart1755204.IqRS27UC8K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBFomTILtK/s7Pra28RAr03AKCELLtTC2Nt5ZM5KDQDZsW7cQQBFwCeLn7Q
6hKiX3Z67OVHCmIcM5vAD8w=
=Is2P
-----END PGP SIGNATURE-----

--nextPart1755204.IqRS27UC8K--
