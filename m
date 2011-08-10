Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7A6xWbI165088 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 01:59:33 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B00B1E72E58
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2011 23:59:29 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id iCI6QgnFQOvgf9Nl for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2011 23:59:29 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Date: Wed, 10 Aug 2011 08:59:26 +0200
References: <20110806122556.GB20341@schmorp.de> <201108091210.50204@zmi.at>
	<20110809111526.GA7631@schmorp.de>
In-Reply-To: <20110809111526.GA7631@schmorp.de>
MIME-Version: 1.0
Message-Id: <201108100859.27576@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3100277545412468677=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Marc Lehmann <schmorp@schmorp.de>

--===============3100277545412468677==
Content-Type: multipart/signed;
  boundary="nextPart9013522.CcGkeH8okR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart9013522.CcGkeH8okR
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 9. August 2011 Marc Lehmann wrote:
> On Tue, Aug 09, 2011 at 12:10:48PM +0200, Michael Monnerie=20
<michael.monnerie@is.it-management.at> wrote:
> > First of all, please calm down. Getting personal is not bringing us
> > anywhere.
>=20
> Well, it's not me who's getting personal, so...?

A single rant from a dev shouldn't hurt one too much. He might have been=20
sitting in front of some code during 72 hours, his eyes already being in=20
16:9 format staring at a weird bug... It's OK to strike back once, but=20
then be cool again and work at the problem.
=20
> As has been reported on this list, this option is really harmful on
> current xfs - in my case, it lead to xfs causing ENOSPC even when the
> disk was 40% empty (~188gb).

Was this the "NFS optimization" stuff? I don't like that either.
=20
> Well, if it were one fragment, you could read that in 4-5 seconds, at
> 374 fragments, it's probably around 6-7 seconds. Thats not harmful,
> but if you extrapolate this to a few gigabytes and a lot of files,
> it becomes quite the overhead.

True, if you have to read tons of log files all day. That's not my=20
normal use case, so I didn't bother about that until now.

> That allocsize option is no longer reasonable with newer kernels, as
> the kernel will reserve 64m diskspace even for 1kb files
> indefinitely.

Just "as long as the inode is cached" or something, I remember that=20
"echo 3 >drop_caches" cleans that up. Still ugly, I'd say.
=20
> If you find a way of recreating files without appending to them, let
> me know.

Seems we have a different meaning of "append". For me, append is when an=20
existing file is re-opened, and data added just to the end of it.
=20
> > And maybe he could use it for optimizations. Is there any tool on
> > Linux to record such I/O patterns?
>=20
> I presume strace would do, but thats where the "lot of work" comes
> in. If there is a ready-to-use tool, that would of course make it
> easy.

It's a pity that such a generic tool doesn't existing. I can't believe=20
that. Doesn't anybody have such a tool at hand?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart9013522.CcGkeH8okR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk5CLE8ACgkQzhSR9xwSCbQGkACgsAo4i4Lsn6UUx1ZfKHPESD7i
LogAniUg7LJYI2c2WABx7qF4TQ1VGIy2
=r07S
-----END PGP SIGNATURE-----

--nextPart9013522.CcGkeH8okR--


--===============3100277545412468677==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3100277545412468677==--
