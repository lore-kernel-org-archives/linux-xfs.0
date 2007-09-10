Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 08:52:12 -0700 (PDT)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [72.51.42.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AFq54p013983
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 08:52:07 -0700
Received: from localhost (localhost [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id 2F9521E0D5960
	for <linux-xfs@oss.sgi.com>; Mon, 10 Sep 2007 23:52:07 +0800 (PHT)
Subject: Re: Attempt to Access Beyond End of Device
From: Federico Sevilla III <jijo@fs3.ph>
In-Reply-To: <Pine.LNX.4.64.0709101145260.897@p34.internal.lan>
References: <1189432747.4385.27.camel@auctoritas.fs3.ph>
	 <Pine.LNX.4.64.0709101041390.897@p34.internal.lan>
	 <1189436396.4385.49.camel@auctoritas.fs3.ph>
	 <Pine.LNX.4.64.0709101145260.897@p34.internal.lan>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v7mpCcQKLTEw58Sg5en4"
Date: Mon, 10 Sep 2007 23:51:54 +0800
Message-Id: <1189439514.18040.14.camel@auctoritas.fs3.ph>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Alec Joseph Rivera <agi@fs3.ph>

--=-v7mpCcQKLTEw58Sg5en4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 11:45 -0400, Justin Piszcz wrote:
> Have you checked the following page?
>=20
> http://linuxmafia.com/faq/Hardware/sata.html

I checked it now (thanks!) and I believe this is what we've got (or
similar) as we use AACRAID:

        Adaptec AAR 2400, 2410, 2410SA, 2120S, 2200S, 2810SA (8-port),
        21610SA (16-port) series PCI cards =E2=80=94 real hardware RAID, us=
ing
        the slightly anemic Intel IOP302/303 I/O co-processor chips. Use
        "aacraid" driver. (Should not be confused with the Adaptec 2400A
        ATA RAID host adapter, for which one uses the dpt_i2o driver,
        that card being a legacy of Adaptec's buying DPT =E2=80=94 nor with=
 the
        low-end Adaptec AAR 12x0 series, which please see.) Faster at
        random I/O than the 3Ware cards. Optional battery is available
        for the card's cache, for more reliable operation in the event
        of power loss, etc. (Card disables the drive's write cache.)

We also have the optional battery mentioned.

> Does the error occur if you use a different filesystem?

I haven't tried any other filesystem, yet. I'm looking for clues as to
what this could be pointing to, first... and emails like yours are
definitely helping, thank you very much.

Cheers!

--=20
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph

--=-v7mpCcQKLTEw58Sg5en4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG5Wga5rCBSJO3Rr4RAoYOAJ0XGQZtzVviK8rl3ovWVLAYp46IXwCfTWK7
s6vKtooj64QKV7QkAzo5PwQ=
=Smnf
-----END PGP SIGNATURE-----

--=-v7mpCcQKLTEw58Sg5en4--
