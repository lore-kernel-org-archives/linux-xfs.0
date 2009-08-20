Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KFhEqX104501 for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 10:43:24 -0500
Received: from mail.sf-mail.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66D0514F98F4
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 08:43:59 -0700 (PDT)
Received: from mail.sf-mail.de (mail.sf-mail.de [62.27.20.61]) by cuda.sgi.com
	with ESMTP id AB11ONVaWWj7Pb3o for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2009 08:43:59 -0700 (PDT)
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Thu, 20 Aug 2009 17:43:41 +0200
References: <20090816004705.GA7347@infradead.org>
	<4A8D5442.1000302@redhat.com> <4A8D5FDB.7080505@rtr.ca>
In-Reply-To: <4A8D5FDB.7080505@rtr.ca>
MIME-Version: 1.0
Message-Id: <200908201743.50167.eike-kernel@sf-tec.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2354912876131097244=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Lord <liml@rtr.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Paul Mackerras <paulus@samba.org>, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>

--===============2354912876131097244==
Content-Type: multipart/signed;
  boundary="nextPart1495252.XOLBvpv6Aq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1495252.XOLBvpv6Aq
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Mark Lord wrote:
> Ric Wheeler wrote:
> > Note that returning consistent data is critical for devices that are
> > used in a RAID group since you will need each RAID block that is used to
> > compute the parity to continue to return the same data until you
> > overwrite it with new data :-)
> >
> > If we have a device that does not support this (or is misconfigured not
> > to do this), we should not use those devices in an MD group & do discard
> > against it...
>
> ..
>
> Well, that's a bit drastic.  But the RAID software should at least
> not issue TRIM commands in ignorance of such.
>
> Would it still be okay to do the TRIMs when the entire parity stripe
> (across all members) is being discarded?  (As opposed to just partial
> data there being dropped)

I think there might be a related usecase that could benefit from=20
TRIM/UNMAP/whatever support in file systems even if the physical devices do=
=20
not support that. I have a RAID5 at work with LVM over it. This week I dele=
ted=20
an old logical volume of some 200GB that has been moved to a different volu=
me=20
group, tomorrow I will start to replace all the disks in the raid with bigg=
er=20
ones. So if the LVM told the raid "hey, this space is totally garbage from =
now=20
on" the raid would not have to do any calculation when it has to rebuild th=
at=20
but could simply write fixed patterns to all disks (e.g. 0 to first data, 0=
 to=20
second data and 0 as "0 xor 0" to parity). With the knowledge that some of =
the=20
underlying devices would support "write all to zero" this operation could b=
e=20
speed up even more, with "write all fixed pattern" every unused chunk would=
 go=20
down to a single write operation (per disk) on rebuild regardless which par=
ity=20
algorithm is used.

And even if things are in use the RAID can benefit from such things. If we=
=20
just define that every unmapped space will always be 0 when read and I writ=
e=20
to a raid volume and the other part of the checksum calculation is unmapped=
=20
checksumming becomes easy as we already know half of the values before: 0. =
So=20
we can save the reads from the second data stripe and most of the calculati=
on.
"dd if=3D/dev/md0" on an unmapped space is more or less the same as "dd=20
if=3D/dev/zero" than.

I only fear that these things are too obviously as I would be the first to=
=20
have this idea ;)

Greetings,

Eike

--nextPart1495252.XOLBvpv6Aq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqNbzYACgkQXKSJPmm5/E5LNQCdFqJ/6Rb+l/1Jdd8GNwG86+MF
g8sAmwXujLHOGE0WsLOAchKRWCzuayAG
=PtAF
-----END PGP SIGNATURE-----

--nextPart1495252.XOLBvpv6Aq--


--===============2354912876131097244==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2354912876131097244==--
