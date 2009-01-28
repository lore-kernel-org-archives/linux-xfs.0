Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0S8c9wf111550 for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 02:38:10 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 619C11878826
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 00:37:25 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id PU6UtldJby66ZgkF for
	<xfs@oss.sgi.com>; Wed, 28 Jan 2009 00:37:25 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 2437D2979
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 09:37:24 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 1D67E40016C
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 09:37:24 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs open questions
Date: Wed, 28 Jan 2009 09:37:19 +0100
References: <200901270928.29215@zmi.at> <497F130F.4010107@sandeen.net>
In-Reply-To: <497F130F.4010107@sandeen.net>
MIME-Version: 1.0
Message-Id: <200901280937.23743@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1737605943173417862=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1737605943173417862==
Content-Type: multipart/signed;
  boundary="nextPart3360888.Mn3H5685aV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit


--nextPart3360888.Mn3H5685aV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Dienstag 27 Januar 2009 Eric Sandeen wrote:
> I think that's all correct.  It's basically this: stripe unit is
> per-disk, sripe width is unit*data_disks.  And then there's the added
> bonus of the differing units on su/sw vs. sunit/swidth.  :)

Yes, it's always fun to have it complicated.

> I'd love to be able to update these pdf files, but despite asking for
> the source document several times over a couple months, nothing has
> been provided.  Unfortunately 'til then it's up to SGI to update them
> and the community can't help much (SGI: hint, hint).

SGI, do you read that? Your users want to do your work, you should be=20
happy 'bout that!

> > Documentation says some backup tools can't handle 64bit Inodes, are
> > there problems with other programs as well?
>
> Potentially, yes:
> http://sandeen.net/wordpress/?p=3D9

OK, so is there anything really problematic? I did already mount with=20
inode64, is there a way back?

> I would not get overly concerned with AG count; newer mkfs.xfs has
> lower defaults (i.e. creates larger AGs, 4 by default, even for a 2T
> filesystem) but to some degree what's "best" depends both on the
> storage underneath and the way the fs will be used.
>
> But with defaults, your 2T/4AG filesystem case above would grow to
> 3T/6AGs, which is fine for many cases.

I used 40 AG's, so it will be 60 then.

> Hm it's unfortunate that there are no units on that number.  Easy to
> fix.

For who? Are you one of the devs?

> This is to avoid all metadata landing on a single disk; similar to
> how mkfs.ext3 wants to use "stride" in its one geometry-tuning knob.

I find the concept good, just the doc about it should be better/clearer.=20
And why didn't they choose to specify # of disks, swidth has to be a=20
multiple of sunit anyway? With su=3D65536,sw=3D3 it's at least clearer.

> The defaults were recently moved to be lower (4 by default).  Files
> in new subdirs are rotated into new AGs, all other things being equal
> (space available, 64-bit-inode allocator mode).  To be honest I don't
> have a good answer for you on when you'd want more or fewer AGs,
> although AGs are parallel independent chunks of the fs to large
> degree, so in some cases, more AGs may help certain kinds of parallel
> operations.  Perhaps others can chime in a bit more on this tuning

Nobody?

> > - PostgreSQL
> > The PostgreSQL database creates a directory per DB. From the docs I
> > read that this creates all Inodes within the same AG. But wouldn't
> > it be better for performance to have each table on a different AG?
> > This could be manually achieved manually, but I'd like to hear if
> > that's better or not.
>
> Hm, where in the docs, just to be clear?

I meant the XFS docs - you said it again "files in the same dir are kept=20
in the same AG". I wasn't clear enough on that. PostgreSQL creates a new=20
DB in a new dir, but all tables etc. are just new files within that dir,=20
which is probably not exactly what one wants. I can imagine it helps to=20
stop the DB, "cp" all files to an extra dir once, to get them=20
distributed over the AG's, and then "mv" them back so just the dir entry=20
is moved but the files stays at that other AG. Or does that sound silly?

> Note how the AG rotors around my 4 AGs in the filesystem.  If the fs
> is full and aged, it may not behave exactly this way.

Does anybody have experience with an aged XFS? I've had the problem with=20
reiserfs, that it became slow after a certain point. It took ages to=20
search within a directory of MP3's containing 50.000 entries in many=20
directories.

> I don't have specific experience w/ PostgreSQL but if you have
> specific questions or performance problems that you run into, we can
> probably help.

Just the idea from above, to cp & mv all files once after creating to=20
distribute among AG's. There was just a general discussion whether XFS=20
is good for postgres or not. Could have been there's that "super-trick"=20
to speed up things by a factor of 1000... ;-)

> All good questions, thanks.

:-)

mfg zmi
--=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart3360888.Mn3H5685aV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmAGUMACgkQzhSR9xwSCbSqIgCg6iO3RtqXupkr2VoaVoeb9d7n
tm0AoJry1fDYLdwDXPg2YusiAx3O0twI
=FBd4
-----END PGP SIGNATURE-----

--nextPart3360888.Mn3H5685aV--


--===============1737605943173417862==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1737605943173417862==--
