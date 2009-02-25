Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1P6fnFN191491 for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 00:41:50 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8635F150F92
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 22:41:17 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id vpSfXcqeQHXJbzE8 for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 22:41:17 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id CBD8E42B5
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 07:40:43 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id D7266400174
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2009 07:40:43 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS and XEN
Date: Wed, 25 Feb 2009 07:40:33 +0100
References: <200902170959.55077@zmi.at> <200902241604.29566@zmi.at>
	<20090224163823.GA19811@infradead.org>
In-Reply-To: <20090224163823.GA19811@infradead.org>
MIME-Version: 1.0
Message-Id: <200902250740.43223@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6330066388149676925=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6330066388149676925==
Content-Type: multipart/signed;
  boundary="nextPart3296521.54puIVQzs9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3296521.54puIVQzs9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Dienstag 24 Februar 2009 Christoph Hellwig wrote:
> It's the usual BS. =A0The difference is just that you actually see the
> corruption on XFS while it's pretty silent on extN. =A0If your Hardware
> (or Hypervisor) is not reliable you _will_ lose data. =A0Either
> silently or with a spectacular blowup if the filesystem actually has
> consistency checking (which XFS has a lot).

Thank you for the explanation. So to clear up: It was not XFS's fault,=20
but came from XEN? Can I write it like that on the FAQ?:

Q: Which settings are best with virtualization like VMware, XEN, qemu?

The biggest problem is that those products seem to also virtualize disk=20
writes in a way that even barriers don't work anymore, which means even=20
a fsync is not reliable. Tests confirm that unplugging the power from=20
such a system even with RAID controller with battery backed cache and=20
hard disk cache turned off (which is save on a normal host) you can=20
destroy a database within the virtual machine (client, domU whatever you=20
call it).

In qemu you can specify cache=3Doff on the line specifying the virtual=20
disk. For others I have no information what to do.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart3296521.54puIVQzs9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmk5+sACgkQzhSR9xwSCbQ2XgCdGbHavPxch1kQmBVaWRoMnls0
5lsAoNj9i06sEO3xvLYgvObWAJWVFnfq
=e6H0
-----END PGP SIGNATURE-----

--nextPart3296521.54puIVQzs9--


--===============6330066388149676925==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6330066388149676925==--
