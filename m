Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34958 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbeJAW1r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 18:27:47 -0400
Subject: Re: cross-fs copy support
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
 <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <df92a795-3f2e-751a-8504-030015fba6d9@sandeen.net>
Date: Mon, 1 Oct 2018 10:49:19 -0500
MIME-Version: 1.0
In-Reply-To: <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9UjKmgcLzBeTqjtP1UIvfHakosmYM3iHX"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Joshi <joshiiitr@gmail.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9UjKmgcLzBeTqjtP1UIvfHakosmYM3iHX
Content-Type: multipart/mixed; boundary="Of3BxTUPGojsV2HfXW7xCSdriW3b0WC0K";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Joshi <joshiiitr@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <df92a795-3f2e-751a-8504-030015fba6d9@sandeen.net>
Subject: Re: cross-fs copy support
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
 <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
In-Reply-To: <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>

--Of3BxTUPGojsV2HfXW7xCSdriW3b0WC0K
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/1/18 9:48 AM, Qu Wenruo wrote:
>=20
>=20
> On 2018/10/1 =E4=B8=8B=E5=8D=8810:32, Joshi wrote:
>> I was wondering about the cross-fs copy through copy_file_range.
>=20
> The term "cross-fs" looks pretty confusing.
>=20
> If you mean "cross-subvolume", then it should work without problem in b=
trfs.
>=20
> If you mean reflink across two different file systems (not matter the
> same fs type or not).
> Then it's impossible to work.

I believe Joshi is talking about vfs_copy_file_range() not
vfs_clone_file range(), although _copy_ does call _clone_ if it can.

> Reflink (clone_file_range) works by inserting data pointers into the
> filesystem other than really copying the data.
> Thus if the source is outside of the fs, it's really impossible to work=
,
> as the source pointer/data is completely out of control of the dest fs.=


Yes, I would expect there to be problems with his modified kernel
for a filesystem that supports clone_file_range, because
vfs_copy_file_range() will clone if possible, and this should fail across=

filesystems.

In general, though, I don't know for sure why we don't fall back to
do_splice_direct() across filesystems, although the filesystems that
implement their own ->copy_file_range ops may have their own,
further restrictions within their implementations.

This call /is/ documented in the manpage as only being valid for
files on the same filesystem, though:
http://man7.org/linux/man-pages/man2/copy_file_range.2.html

-Eric


--Of3BxTUPGojsV2HfXW7xCSdriW3b0WC0K--

--9UjKmgcLzBeTqjtP1UIvfHakosmYM3iHX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAluyQgAACgkQIK4WkuE9
3uCwcg//dXNLuozv1pIWO7q7BXNSK5nO1F9jicwp/Ulkv+0iGDhWWx0kar9IEbvi
vXL7WgLbTHUCrlXr7rbwi8aGZH/ySPAPDwG/PuIbMVMIJzrfg6vvhtieGcB2lW6T
deVYw/10a/xOS4y1CyVsGMJ9FlsVIhwKeiHH6oqaU3hSDmZs4CQBgc4Tsz4elQFs
RjHjDxlEl0EH8kMsYl9HCQ8abgGePZrr1bcvWbi67HznpqHs/7FlZHkJNQcRwH7+
4yKpvBq+/08jtEiirJODxH9FQeG8iOIzWgn3/0zTcXA/qzOIl/kae0VRtj4j2Ej4
yhz0UtM3v2ldTgDrEQmD++3yadgLVx6yteoDc+nvCAvaJ2VaVpkJjOhtHQ0Xy8Zt
0IVyi3aLYj9NCjHUb1n86Xw17owuXwqmEmN3oaQ4GW7jvltbE7NoP6drhiDBLp9x
mMBLV9UMnPwBJgmV1fGhW82Qm7NHh8VqZOZhwaq8/BRn2+36Rcoowe+7NLZft7Ex
H8m0mic89HLCvspjFFsSbd0oJQtrlEC6EH25azRKO/4JE2NESgFsyxJf4FYMgw4/
g4LLsF8Ap5rHUvwLDeXvEGCwyY+zpvq6IWE6GFX78qLpdbbJ330Gs66zTcjuCuAU
7bADElcmZ9Z3zQgyuImeNqo+tXlFy2yVqKelwAHTtXaRTyJnN2k=
=X76r
-----END PGP SIGNATURE-----

--9UjKmgcLzBeTqjtP1UIvfHakosmYM3iHX--
