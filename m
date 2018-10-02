Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39814 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbeJBVte (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Oct 2018 17:49:34 -0400
Subject: Re: [somewhat OT] I just discovered that Stratis uses XFS.
References: <20181002162530.42b30c11@harpe.intellique.com>
 <20181002163707.5452307c@harpe.intellique.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6eb79c7b-4f15-28af-44b5-03488008a897@sandeen.net>
Date: Tue, 2 Oct 2018 10:05:42 -0500
MIME-Version: 1.0
In-Reply-To: <20181002163707.5452307c@harpe.intellique.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vD5pMcn9p4w53WVrZ7oNSs2Etq9xK09oW"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>, xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vD5pMcn9p4w53WVrZ7oNSs2Etq9xK09oW
Content-Type: multipart/mixed; boundary="dtAleURllUYzGWW4fLo2JatSo8fnMDW72";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Emmanuel Florac <eflorac@intellique.com>, xfs <linux-xfs@vger.kernel.org>
Message-ID: <6eb79c7b-4f15-28af-44b5-03488008a897@sandeen.net>
Subject: Re: [somewhat OT] I just discovered that Stratis uses XFS.
References: <20181002162530.42b30c11@harpe.intellique.com>
 <20181002163707.5452307c@harpe.intellique.com>
In-Reply-To: <20181002163707.5452307c@harpe.intellique.com>

--dtAleURllUYzGWW4fLo2JatSo8fnMDW72
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 10/2/18 9:37 AM, Emmanuel Florac wrote:
> Le Tue, 2 Oct 2018 16:25:30 +0200
> Emmanuel Florac <eflorac@intellique.com> =C3=A9crivait:
>=20
>> Hi all,=20
>> in fact I just discovered that Stratis exists :)
>> (https://stratis-storage.github.io/relnotes/relnotes-1.0.html)
>> ( details on https://lwn.net/Articles/755454/)
>>
>> Reading the FAQ (https://stratis-storage.github.io/FAQ.html) I see
>> that it uses XFS as a filesystem layer. Furthermore it seems to come
>> from RedHat. What are the relations with the future XFS capabilities
>> that Dave (IIRC) demonstrated recently?
>>
>> Sorry for the OT message :)
>=20
> Oh, and what about the probable constant use of xfs_growfs? Stratis
> seems to create all filesystems with a size of 1TB, and extends them as=

> needed from there. However that means that a filesystem could
> potentially be expanded many times, which, as I understand it, is very
> suboptimal or worse, can lead to problems (inode allocation, AGs
> count and structure, etc).

First, a disclaimer: I'm not a Stratis expert.

None of Dave's fancy new tricks are in Stratis, because right now Dave's
fancy new tricks are pretty much just in his lab.

As for the growfs, that's a little bit of a concern - in general, the "st=
art
small and grow" worry is that we'll have a bazillion tiny AGs in the resu=
lt.

But if Stratis starts at 1TB it's not terrible; I'd need to look and see =
how
many AGs get created (probably 4?) and if so, 250G AGs are not /too/ gran=
ular.
If it's creating a lot more smaller AGs, that could become an issue if it=
 gets
grown to a very large size.  IOWs the growfs concern is mostly about the
resulting AG size & AG count.

-Eric


--dtAleURllUYzGWW4fLo2JatSo8fnMDW72--

--vD5pMcn9p4w53WVrZ7oNSs2Etq9xK09oW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAluziUYACgkQIK4WkuE9
3uBOaQ//bodnd07ZhnZr7JR3KKTisLnvT40bLjz5gfa3kfKJIAbc+Wn4qUDb/RSQ
xPpSnhYsvHdupf6Egx0uGUApzxmRzhwrXCdV//esUTOpjDzVbIlYqUe4FO4INHiC
kz83l69+v8Q9NidWYgQQCbiSoR6V8bAFMbZdOGAu9P/2ipip2sJfoTwJLM0VCntv
pWgfQ24kQNUkAOJR0zWMvkrnagJYq9v9p2qsclY1atV0KSND8Apt05HmU7EJI5x3
4r+y6O19+9QlHVapnGVjjhkqNQ8BvZtvhZl+XknBoKn1vRsY8k1pClhsxHTOhImk
EGj251zqb6nsulo2k1VsQTqI1nD/1CrNB0+X1VY/LBsL4ht0SVfqq3PtpYkMSkFI
3H9icDEaBEhXUjrqgG9qIWv1xA3ji4tvZ5Z62Sqy1cTyFWb0k2wje+KyH+8rtUXj
MXoydr0lelWkqsuEpjMTY20GFCJq0pul+3pATv/iom9/z3loqrhDGN7nhby1y89W
jcXcH37+310AHKzQWqu0Fl/gs43DIUWcXk/B+PEYvILMFJSQ0jLIGDKh0FwJAZPn
fAbsfGqb8PhiNKy3sr4qPmaY8z+5xLZJVyU1yqVymq9+B0AV8W/5iUH6n5Udp8QD
ZamCXEDgIvVKmtq5YZkIuyL4RIgvha8czIKPh/g8twaF4AvTJ+4=
=d9sg
-----END PGP SIGNATURE-----

--vD5pMcn9p4w53WVrZ7oNSs2Etq9xK09oW--
