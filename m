Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Nov 2006 22:29:11 -0800 (PST)
Received: from mailgate.mysql.com (mailgate-out2.mysql.com [213.136.52.68])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAR6T1aG000561
	for <xfs@oss.sgi.com>; Sun, 26 Nov 2006 22:29:03 -0800
Subject: Re: XFS_IOC_RESVSP64 versus XFS_IOC_ALLOCSP64 with multiple threads
From: Stewart Smith <stewart@mysql.com>
In-Reply-To: <950D2C3E-11AE-4805-9286-65ECD880272D@sgi.com>
References: <1163381602.11914.10.camel@localhost.localdomain>
	 <965ECEF2-971D-46A1-B3F2-C6C1860C9ED8@sgi.com>
	 <1163390942.14517.12.camel@localhost.localdomain>
	 <12275452-56ED-4921-899F-EFF1C05B251A@sgi.com>
	 <1163395250.14517.38.camel@localhost.localdomain>
	 <950D2C3E-11AE-4805-9286-65ECD880272D@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+0Xx/HOYEKeIYPkemlLi"
Date: Mon, 27 Nov 2006 05:55:01 +0000
Message-Id: <1164606901.26726.18.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sam Vaughan <sjv@sgi.com>
Cc: xfs@oss.sgi.com

--=-+0Xx/HOYEKeIYPkemlLi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-11-14 at 11:04 +1100, Sam Vaughan wrote:=20
> Those extents are curiously uniform, all 32kB in size.  The fact that=20=
=20
> both files' extents are in AG 8 suggests that the two directories=20=20
> ndb_1_fs and ndb_2_fs filled their original AGs and spilled out into=20=
=20
> other ones, which is when the interference would have started.=20=20=20
> Looking at the directory hierarchy in your last email, you might be=20=20
> better off if you could add another directory for the datafiles and=20=20
> undofiles to live in, so they don't end up sharing their AG with=20=20
> other stuff in their parent directory.

I think this is typically what the QA guys do (to help keep their sanity
if anything). Perhaps we should have this in our "best practice"
documentation as well...

> > for the data and undo files, we're just not changing their size except
> > at creation time, so that's okay.
>=20
> I'd assumed that these files were being continually grown.  If all=20=20
> this is happening at creation time then it shouldn't be too hard to=20=20
> make sure the files are cleanly allocated with just one extent.  Does=20=
=20
> the following not work on your file system?
>=20
> $ touch a b
> $ for file in a b; do
>  > xfs_io -c 'allocsp 1G 0' $file &
>  > done; wait
> [1] 12312
> [2] 12313
> [1]-  Done                    xfs_io -c 'allocsp 1G 0' $file
> [2]+  Done                    xfs_io -c 'allocsp 1G 0' $file
> $ xfs_bmap -v a b
> a:
> EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20
> TOTAL
>     0: [0..2097151]:    231732008..233829159  6 (11968856..14066007)=20=
=20
> 2097152
> b:
> EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20
> TOTAL
>     0: [0..2097151]:    233829160..235926311  6 (14066008..16163159)=20=
=20
> 2097152
> $

That works fine on my file systems (or, on my rather full and well
used /home, as well as it can).

We're opening the files with O_DIRECT (or, if not available or fails,
O_SYNC)



> >> Now in your case you're using different directories, so your files
> >> are probably OK at the start of day.  Once the AGs they start in fill
> >> up though, the files for both processes will start getting allocated
> >> from the next available AG.  At that point, allocations that started
> >> out looking like the first test above will end up looking like the
> >> second.
> >>
> >> The filestreams allocator will stop this from happening for
> >> applications that write data regularly like video ingest servers, but
> >> I wouldn't expect it to be a cure-all for your database app because
> >> your writes could have large delays between them.  Instead, I'd look
> >> into ways to break up your data into AG-sized chunks, starting a new
> >> directory every time you go over that magic size.
> >
> > I'll have to check our writing behaviour the files that change=20=20
> > sizes...
> > but they're not too much of an issue (they're hardly ever read=20=20
> > back, so
> > as long as writing them out is okay and reading isn't totally abismal,
> > we don't have to worry).
>=20
> That's handy.  All in all it sounds like your requirements are very=20=20
> file system friendly in terms of getting optimum allocation.  I'm not=20=
=20
> sure what could be causing all those 32kB extents.

Perhaps being flushed out due to VM pressure? but with O_DIRECT/O_SYNC
that shouldn't be the case, right? Or perhaps *because* of
O_DIRECT/O_SYNC?
--=20
Stewart Smith, Software Engineer
MySQL AB, www.mysql.com
Office: +14082136540 Ext: 6616
VoIP: 6616@sip.us.mysql.com
Mobile: +61 4 3 8844 332

Jumpstart your cluster:
http://www.mysql.com/consulting/packaged/cluster.html

--=-+0Xx/HOYEKeIYPkemlLi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFan21KglWCUL+FDoRAuShAKCFCYR9f8UxYdccOPP02RC5dOYUQQCgugkN
WrWw90M0e7g//UX2WCHeVjI=
=H03E
-----END PGP SIGNATURE-----

--=-+0Xx/HOYEKeIYPkemlLi--
