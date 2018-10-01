Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:35257 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729412AbeJAV0d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:26:33 -0400
Subject: Re: cross-fs copy support
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
Date: Mon, 1 Oct 2018 22:48:15 +0800
MIME-Version: 1.0
In-Reply-To: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Qv99O5hZknZYCc2HZwRH8gtgh2XOxSLYH"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joshi <joshiiitr@gmail.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Qv99O5hZknZYCc2HZwRH8gtgh2XOxSLYH
Content-Type: multipart/mixed; boundary="ci0Jq2j01hmhpU1Xr0oZYQMaAFiUooomG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Joshi <joshiiitr@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org
Message-ID: <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
Subject: Re: cross-fs copy support
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
In-Reply-To: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>

--ci0Jq2j01hmhpU1Xr0oZYQMaAFiUooomG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/1 =E4=B8=8B=E5=8D=8810:32, Joshi wrote:
> I was wondering about the cross-fs copy through copy_file_range.

The term "cross-fs" looks pretty confusing.

If you mean "cross-subvolume", then it should work without problem in btr=
fs.

If you mean reflink across two different file systems (not matter the
same fs type or not).
Then it's impossible to work.

Reflink (clone_file_range) works by inserting data pointers into the
filesystem other than really copying the data.
Thus if the source is outside of the fs, it's really impossible to work,
as the source pointer/data is completely out of control of the dest fs.

> It seems current implement has below check, that disables such copy.
>=20
> 1577         /* this could be relaxed once a method supports cross-fs c=
opies */
> 1578         if (inode_in->i_sb !=3D inode_out->i_sb)
> 1579                 return -EXDEV;
>=20
> May I know what are the thoughts behind disabling cross-fs copy?
> Code has the comment "once a method supports", but that leaves me
> wondering exactly what 'method' is expected, and from whom.
>=20
> I disabled the check, and copy across volumes seemed to work fine. At
> least for a single file (1G size), with no data mismatch, and faster
> speed than regular copy.

Please provide the steps or script about how you did the reflink, in
case I misunderstand your "cross-fs" definition.

And just in case you're really doing cross filesystem reflink, please
also run "btrfs check" on both fs.

Thanks,
Qu



--ci0Jq2j01hmhpU1Xr0oZYQMaAFiUooomG--

--Qv99O5hZknZYCc2HZwRH8gtgh2XOxSLYH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluyM68ACgkQwj2R86El
/qiZXQgAl42dvErkqnlBQaSinUyBBlH97d2zZW21MM3WE8kofldrlZwmBhtngGph
KtZX9YBuPVrmHY3h2dZ4tt+8BOn9c0HYiFK1g7hrSgsggzZnpyRgEHkqzH1QPUFV
F8b76taNajcoQnsrVfbjHHBWGARcsNvxUIu1gAW3JtmHiQUxKGqgvD3t3p4V0/+r
rgxdoPb6d+qSI1fAq01xcHQwyNTvsCmEXn9edauux9c1mqW2WhX7yXiEoeqHVnzc
GodbRlQBeURPwjhnmjEzH/3syeIqiu7uNKu1IBbKsDbacgXvmMWNtbt2cozz9wMG
z+kj2Dg17pO0MXAzbrznSEDj0cJNtA==
=iJnX
-----END PGP SIGNATURE-----

--Qv99O5hZknZYCc2HZwRH8gtgh2XOxSLYH--
