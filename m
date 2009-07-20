Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KBBVJi075074 for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 06:11:31 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1546371BF1
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 04:12:12 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id pFfdMR9zV59lwGNO for
	<xfs@oss.sgi.com>; Mon, 20 Jul 2009 04:12:12 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 3620F4DAF
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:12:43 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 8C78940017E
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:12:10 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: concerning 'optimal' strip size on RAID disks...
Date: Mon, 20 Jul 2009 13:12:05 +0200
References: <4A611851.8060904@tlinx.org>
In-Reply-To: <4A611851.8060904@tlinx.org>
MIME-Version: 1.0
Message-Id: <200907201312.10058@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0609134684763417672=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0609134684763417672==
Content-Type: multipart/signed;
  boundary="nextPart2554431.G1PSpzaxgO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2554431.G1PSpzaxgO
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Samstag 18 Juli 2009 Linda A. Walsh wrote:
> Concerning strip-size.  What are the considerations for that?  Any
> reason not to chose the largest?  Seems that at sizes up to 1MB, the
> larger the better.
>
> For direct I/O (which is what the RAID controller would be doing to
> it's disks, seems a larger write would be better).
>
> Would I be na=C3=AFve to assume that if a RAID controller only needed to
> update 1 block, it wouldn't need to update the entire strip?

I'd say exactly your last sentence tells you why a smaller stripe size=20
can be better.

> Would there be a benefit in running a smaller strip size?

If you run virtualization (say 20 virtual servers on a single hardware),=20
you will basically only have random I/O. Each of those 20 servers might=20
have sequential I/O, but the RAID controller sees 20 streams of I/O,=20
making the whole thing quite random.

Has anyone benchmarked on this?

> I know when I can control the hard disks, I can enable their write
> caches, so having them do physical writes the keep their write
> buffers saturated would optimize write performance, at least, but if
> it's a BIOS or hardware controlled RAID, I don't know if I'd have the
> option to turn the disk's write buffer on or off.  So that likely
> wouldn't matter much.

That setting should be possible via the RAID controller. On Areca you=20
can set "Disk Write Cache Mode" to off, on HP it's called "write=20
through" or "write back disabled" IIRC.

> Ideally, I think, it be optimal if a RAID controller (hardware or
> software) really knew the the layout of the data on disk -- as in
> sectors/track.

On today's hardware that's not needed anymore, as already a simple RAID=20
level virtualizes accesses.

> Then it really might be able to interleave tracks
> among disk units (unless all the tracks can be written contiguously
> w/no delay, then I'd guess there'd be no benefit...oh well..

Yeah, I'm so old that twenty years ago I really still learned that at=20
school, but those really don't matter anymore.

> But how does one decide a strip size for RAID disks?
> What criteria does one use?

If someone *really* knows, I'd be interested as well.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart2554431.G1PSpzaxgO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpkUQoACgkQzhSR9xwSCbQf7QCfYLi8C5ihFrbEBxIY1WFmsoVN
f3UAn1IATEpk8Lr73DjdCLt56Mj6+57B
=CTNB
-----END PGP SIGNATURE-----

--nextPart2554431.G1PSpzaxgO--


--===============0609134684763417672==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0609134684763417672==--
