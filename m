Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55481 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751169AbdHQFnI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 01:43:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D3E3920BB1
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 01:43:07 -0400 (EDT)
Received: from oryx (c-73-202-12-204.hsd1.ca.comcast.net [73.202.12.204])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B661240A4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 01:43:05 -0400 (EDT)
Message-ID: <1502948579.29878.8.camel@sub-pop.net>
Subject: Re: xfs_repair fails: mismatched UUID?
From: Link Dupont <link@sub-pop.net>
Date: Wed, 16 Aug 2017 22:42:59 -0700
In-Reply-To: <e285d801-755b-b84e-028a-b889f4ee336c@sandeen.net>
References: <1502946903.3034.25.camel@sub-pop.net>
         <d31ec46a-cc4c-5865-6ee4-fffdcb32c254@sandeen.net>
         <e285d801-755b-b84e-028a-b889f4ee336c@sandeen.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ktnPNncQqqA4Qn2u+gnJ"
Mime-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--=-ktnPNncQqqA4Qn2u+gnJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-08-17 at 00:26 -0500, Eric Sandeen wrote:
> Oh right, you did say RAID enclosure.
>=20
> My money is on the enclosure no longer presenting you with sectors in
> the original order, or in an otherwise severely damaged form, for
> whatever reason.

The problem *could* be from the enclosure itself; I don't have a second one=
 to
test. I'm fairly sure the cause is a failing drive (I get a red LED from on=
e of
the two status LEDs on the front of the enclosure).

> xfs_repair restores filesystem consistency but it is not a data recovery =
or
> storage repair tool.  ;)

I get that. But since the files are there, it seemed like the file-system c=
ould
be repaired. I'll dig up the output.

> > All of this has been performed on my ddrescue clone (not the original
> device).
>=20
> <cue applause!>  :)

I don't always directly edit properties of my filesystems, but when I do, I=
 do
it on a clone. :)
--=-ktnPNncQqqA4Qn2u+gnJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEqa+yVxzJn+17d/PuSGi9TERQ3rwFAlmVLOMACgkQSGi9TERQ
3rwSCgf+PnDOnesrYVvNzAJr2aJuF8mdej1Ra5PeQRgCl/+v8Nnrwcyk6yTfbmKD
ojSiOOqocVZRzPQxI6jS+UtaCbEInFMO7jZyeVX90FmOgMFcXDP/zqAJwLVdicoP
LpjoYCGy6Wl1h8vWQNa+FfasRbf6pdLZPPWQpwYRaH16iUQLvWp8Yi3nvsARoHNk
fPswtSW2bSWqDz80C3yFdh95lBBF7+k+bI54fUJjIAsLadqNH1bBxawnNfuipCbn
7Im6C3MA2EmfZAzctfz5sP9LcpinrtAR6e99PEzeOwGJTfvXklLcbZKIMfPArqAR
ipgSi9ZNZddEVgIXllOu+Zat8LRqHQ==
=DoLl
-----END PGP SIGNATURE-----

--=-ktnPNncQqqA4Qn2u+gnJ--

