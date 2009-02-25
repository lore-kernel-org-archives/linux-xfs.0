Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1PImNAV220635
	for <linux-xfs@oss.sgi.com>; Wed, 25 Feb 2009 12:48:23 -0600
Received: from amanpulo.fs3.ph (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C3EC153D7B
	for <linux-xfs@oss.sgi.com>; Wed, 25 Feb 2009 10:47:51 -0800 (PST)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [202.81.162.101]) by
	cuda.sgi.com with ESMTP id 6t1zHQ7ZVyHDkKf7 for
	<linux-xfs@oss.sgi.com>; Wed, 25 Feb 2009 10:47:51 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id 51E5B30317926
	for <linux-xfs@oss.sgi.com>; Thu, 26 Feb 2009 02:47:50 +0800 (PHT)
Received: from amanpulo.fs3.ph ([127.0.0.1])
	by localhost (amanpulo.fs3.ph [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id ZasckRL7juGq for <linux-xfs@oss.sgi.com>;
	Thu, 26 Feb 2009 02:47:49 +0800 (PHT)
Received: from [10.37.1.117] (unknown [10.37.1.117])
	(using SSLv3 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by amanpulo.fs3.ph (Postfix) with ESMTP id ADC96303177CE
	for <linux-xfs@oss.sgi.com>; Thu, 26 Feb 2009 02:47:49 +0800 (PHT)
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
From: Federico Sevilla III <jijo@fs3.ph>
In-Reply-To: <1235556051.17569.4.camel@disciplina.fs3.ph>
References: <1235480661.17293.28.camel@disciplina.fs3.ph>
	<20090224224636.GF26138@disturbed>
	<1235556051.17569.4.camel@disciplina.fs3.ph>
Date: Thu, 26 Feb 2009 02:47:48 +0800
Message-Id: <1235587668.30386.3.camel@disciplina.fs3.ph>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7228535812288778251=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux XFS <linux-xfs@oss.sgi.com>


--===============7228535812288778251==
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ygAgm97XS4nxaIHcci/2"


--=-ygAgm97XS4nxaIHcci/2
Content-Type: multipart/mixed; boundary="=-JMoaKkwEWJGSE0hyGo0z"


--=-JMoaKkwEWJGSE0hyGo0z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-25 at 18:00 +0800, Federico Sevilla III wrote:
> On Wed, 2009-02-25 at 09:46 +1100, Dave Chinner wrote:
> > On Tue, Feb 24, 2009 at 09:04:21PM +0800, Federico Sevilla III wrote:
>=20
> > >         attempt to access beyond end of device
> > >         sda7: rw=3D0, want=3D154858897362229008, limit=3D3885978852
> > >         I/O error in filesystem ("sda7") meta-data dev sda7 block 0x2=
262b58bf959708       ("xfs_trans_read_buf") error 5 buf count 4096
> >=20
> > A corrupted extent pointer of some kind. xfs_repair should have
> > found this. Can you run xfs_repair again? If it doesn't find
> > anything, please upgrade xfs_repair to the latest version and
> > try again.

I have attached the output of xfs_repair. You are correct, it did find
errors with the file system, and repaired them. I don't know why this
wasn't caught the first time, but I guess the lesson learned here is to
re-run xfs_repair until it finds no further errors.

Does the output of xfs_repair help give you an idea of what could have
been the root cause of the crash? (I know it's a long shot, but maybe
you recognize a pattern in the messages.)

Thank you very much.

Cheers!

--=20
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph

--=-JMoaKkwEWJGSE0hyGo0z
Content-Disposition: attachment; filename=xfs_repair_sda7.log
Content-Transfer-Encoding: base64
Content-Type: text/x-log; name=xfs_repair_sda7.log; charset=utf-8

UGhhc2UgMSAtIGZpbmQgYW5kIHZlcmlmeSBzdXBlcmJsb2NrLi4uDQpQaGFzZSAyIC0gdXNpbmcg
aW50ZXJuYWwgbG9nDQogICAgICAgIC0gemVybyBsb2cuLi4NCiAgICAgICAgLSBzY2FuIGZpbGVz
eXN0ZW0gZnJlZXNwYWNlIGFuZCBpbm9kZSBtYXBzLi4uDQogICAgICAgIC0gZm91bmQgcm9vdCBp
bm9kZSBjaHVuaw0KUGhhc2UgMyAtIGZvciBlYWNoIEFHLi4uDQogICAgICAgIC0gc2NhbiBhbmQg
Y2xlYXIgYWdpIHVubGlua2VkIGxpc3RzLi4uDQogICAgICAgIC0gcHJvY2VzcyBrbm93biBpbm9k
ZXMgYW5kIHBlcmZvcm0gaW5vZGUgZGlzY292ZXJ5Li4uDQogICAgICAgIC0gYWdubyA9IDANCiAg
ICAgICAgLSBhZ25vID0gMQ0KICAgICAgICAtIGFnbm8gPSAyDQpiYWQgYm1hcCBidHJlZSBwdHIg
MHhjNGMwMjUzNDc0OTVmNDEgaW4gaW5vIDUzNjk2MDk1MQ0KYmFkIGRhdGEgZm9yayBpbiBpbm9k
ZSA1MzY5NjA5NTENCmNsZWFyZWQgaW5vZGUgNTM2OTYwOTUxDQogICAgICAgIC0gYWdubyA9IDMN
CiAgICAgICAgLSBhZ25vID0gNA0KICAgICAgICAtIGFnbm8gPSA1DQogICAgICAgIC0gYWdubyA9
IDYNCiAgICAgICAgLSBhZ25vID0gNw0KICAgICAgICAtIGFnbm8gPSA4DQogICAgICAgIC0gYWdu
byA9IDkNCiAgICAgICAgLSBhZ25vID0gMTANCiAgICAgICAgLSBhZ25vID0gMTENCiAgICAgICAg
LSBhZ25vID0gMTINCiAgICAgICAgLSBhZ25vID0gMTMNCiAgICAgICAgLSBhZ25vID0gMTQNCiAg
ICAgICAgLSBhZ25vID0gMTUNCiAgICAgICAgLSBhZ25vID0gMTYNCiAgICAgICAgLSBhZ25vID0g
MTcNCiAgICAgICAgLSBhZ25vID0gMTgNCiAgICAgICAgLSBhZ25vID0gMTkNCiAgICAgICAgLSBh
Z25vID0gMjANCiAgICAgICAgLSBhZ25vID0gMjENCiAgICAgICAgLSBhZ25vID0gMjINCiAgICAg
ICAgLSBhZ25vID0gMjMNCiAgICAgICAgLSBhZ25vID0gMjQNCiAgICAgICAgLSBhZ25vID0gMjUN
CiAgICAgICAgLSBhZ25vID0gMjYNCiAgICAgICAgLSBhZ25vID0gMjcNCiAgICAgICAgLSBhZ25v
ID0gMjgNCiAgICAgICAgLSBhZ25vID0gMjkNCiAgICAgICAgLSBhZ25vID0gMzANCiAgICAgICAg
LSBhZ25vID0gMzENCiAgICAgICAgLSBwcm9jZXNzIG5ld2x5IGRpc2NvdmVyZWQgaW5vZGVzLi4u
DQpQaGFzZSA0IC0gY2hlY2sgZm9yIGR1cGxpY2F0ZSBibG9ja3MuLi4NCiAgICAgICAgLSBzZXR0
aW5nIHVwIGR1cGxpY2F0ZSBleHRlbnQgbGlzdC4uLg0KICAgICAgICAtIGNoZWNrIGZvciBpbm9k
ZXMgY2xhaW1pbmcgZHVwbGljYXRlIGJsb2Nrcy4uLg0KICAgICAgICAtIGFnbm8gPSAwDQogICAg
ICAgIC0gYWdubyA9IDENCiAgICAgICAgLSBhZ25vID0gMg0KICAgICAgICAtIGFnbm8gPSAzDQpl
bnRyeSAiaW5fb3V0IG9mIElOS19MT19CRy54bHMiIGF0IGJsb2NrIDAgb2Zmc2V0IDIzNTIgaW4g
ZGlyZWN0b3J5IGlub2RlIDUzNzAwNTU5NSByZWZlcmVuY2VzIGZyZWUgaW5vZGUgNTM2OTYwOTUx
DQoJY2xlYXJpbmcgaW5vZGUgbnVtYmVyIGluIGVudHJ5IGF0IG9mZnNldCAyMzUyLi4uDQogICAg
ICAgIC0gYWdubyA9IDQNCiAgICAgICAgLSBhZ25vID0gNQ0KICAgICAgICAtIGFnbm8gPSA2DQog
ICAgICAgIC0gYWdubyA9IDcNCiAgICAgICAgLSBhZ25vID0gOA0KICAgICAgICAtIGFnbm8gPSA5
DQogICAgICAgIC0gYWdubyA9IDEwDQogICAgICAgIC0gYWdubyA9IDExDQogICAgICAgIC0gYWdu
byA9IDEyDQogICAgICAgIC0gYWdubyA9IDEzDQogICAgICAgIC0gYWdubyA9IDE0DQogICAgICAg
IC0gYWdubyA9IDE1DQogICAgICAgIC0gYWdubyA9IDE2DQogICAgICAgIC0gYWdubyA9IDE3DQog
ICAgICAgIC0gYWdubyA9IDE4DQogICAgICAgIC0gYWdubyA9IDE5DQogICAgICAgIC0gYWdubyA9
IDIwDQogICAgICAgIC0gYWdubyA9IDIxDQogICAgICAgIC0gYWdubyA9IDIyDQogICAgICAgIC0g
YWdubyA9IDIzDQogICAgICAgIC0gYWdubyA9IDI0DQogICAgICAgIC0gYWdubyA9IDI1DQogICAg
ICAgIC0gYWdubyA9IDI2DQogICAgICAgIC0gYWdubyA9IDI3DQogICAgICAgIC0gYWdubyA9IDI4
DQogICAgICAgIC0gYWdubyA9IDI5DQogICAgICAgIC0gYWdubyA9IDMwDQogICAgICAgIC0gYWdu
byA9IDMxDQpQaGFzZSA1IC0gcmVidWlsZCBBRyBoZWFkZXJzIGFuZCB0cmVlcy4uLg0KICAgICAg
ICAtIHJlc2V0IHN1cGVyYmxvY2suLi4NClBoYXNlIDYgLSBjaGVjayBpbm9kZSBjb25uZWN0aXZp
dHkuLi4NCiAgICAgICAgLSByZXNldHRpbmcgY29udGVudHMgb2YgcmVhbHRpbWUgYml0bWFwIGFu
ZCBzdW1tYXJ5IGlub2Rlcw0KICAgICAgICAtIHRyYXZlcnNpbmcgZmlsZXN5c3RlbSAuLi4NCmJh
ZCBoYXNoIHRhYmxlIGZvciBkaXJlY3RvcnkgaW5vZGUgNTM3MDA1NTk1IChubyBkYXRhIGVudHJ5
KTogcmVidWlsZGluZw0KcmVidWlsZGluZyBkaXJlY3RvcnkgaW5vZGUgNTM3MDA1NTk1DQogICAg
ICAgIC0gdHJhdmVyc2FsIGZpbmlzaGVkIC4uLg0KICAgICAgICAtIG1vdmluZyBkaXNjb25uZWN0
ZWQgaW5vZGVzIHRvIGxvc3QrZm91bmQgLi4uDQpQaGFzZSA3IC0gdmVyaWZ5IGFuZCBjb3JyZWN0
IGxpbmsgY291bnRzLi4uDQpkb25lDQo=


--=-JMoaKkwEWJGSE0hyGo0z--

--=-ygAgm97XS4nxaIHcci/2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJpZJU5rCBSJO3Rr4RAp/sAJ40nR9GltwjtpKZXaL8Uj9UJ6idMgCfcbSX
5EYg6zDJYuCOuJoDCNGqiBg=
=9721
-----END PGP SIGNATURE-----

--=-ygAgm97XS4nxaIHcci/2--


--===============7228535812288778251==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7228535812288778251==--
