Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50860 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbfB0WTF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Feb 2019 17:19:05 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6ECBA78D6
        for <linux-xfs@vger.kernel.org>; Wed, 27 Feb 2019 16:18:38 -0600 (CST)
Subject: Re: [ANNOUNCE] xfsprogs for-next updated to bb83d20
From: Eric Sandeen <sandeen@sandeen.net>
References: <e1bd5016-cef2-c61b-7540-cf75d960c16d@sandeen.net>
Message-ID: <65344cb3-31af-2f5c-3d1f-fb45bc609b77@sandeen.net>
Date: Wed, 27 Feb 2019 16:19:03 -0600
MIME-Version: 1.0
In-Reply-To: <e1bd5016-cef2-c61b-7540-cf75d960c16d@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="m03ZOlbUZYJIKcQDY8ubChZ4jyE8k65YF"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--m03ZOlbUZYJIKcQDY8ubChZ4jyE8k65YF
Content-Type: multipart/mixed; boundary="rshl3FxmqEci9v9L7wLOqSgMOyCI5NqVr";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <65344cb3-31af-2f5c-3d1f-fb45bc609b77@sandeen.net>
Subject: Re: [ANNOUNCE] xfsprogs for-next updated to bb83d20
References: <e1bd5016-cef2-c61b-7540-cf75d960c16d@sandeen.net>
In-Reply-To: <e1bd5016-cef2-c61b-7540-cf75d960c16d@sandeen.net>

--rshl3FxmqEci9v9L7wLOqSgMOyCI5NqVr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/27/19 3:39 PM, Eric Sandeen wrote:
> Hi folks,
>=20
> The xfsprogs repository at:
>=20
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>=20
> has just been updated.
>=20
> This contains only the sync to the kernel's libxfs updates for v5.0.
>=20
> The new head of the for-next branch is commit:

Fixed a thinko stray ; caught by coverity and did a forced push on
these branches right quick before anyone but djwong pulled it down. ;)

Now we're at:

bb83d20 xfs: stringify btree cursor types in ftrace output

New Commits:

Darrick J. Wong (11):
      [5afb131] xfs: idiotproof defer op type configuration
      [5a23b29] xfs: streamline defer op type handling
      [c2d5dd0] xfs: const-ify xfs_owner_info arguments
      [9ef0cb4] xfs: remove xfs_rmap_ag_owner and friends
      [09c23f4] xfs: add a block to inode count converter
      [ad5eff9] xfs: precalculate inodes and blocks per inode cluster
      [6180d69] xfs: precalculate cluster alignment in inodes and blocks
      [ef1b0a2] xfs: fix symbolic enum printing in ftrace output
      [a97fc90] xfs: move XFS_AG_BTREE_CMP_FORMAT_STR mappings to libxfs
      [e01dc40] xfs: move XFS_INODE_FORMAT_STR mappings to libxfs
      [bb83d20] xfs: stringify btree cursor types in ftrace output

Dave Chinner (1):
      [7ab21d5] xfs: zero length symlinks are not valid

Omar Sandoval (1):
      [6890a4c] xfs: cache minimum realtime summary level

Pan Bian (1):
      [972ca59] xfs: libxfs: move xfs_perag_put late



--rshl3FxmqEci9v9L7wLOqSgMOyCI5NqVr--

--m03ZOlbUZYJIKcQDY8ubChZ4jyE8k65YF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlx3DNcACgkQIK4WkuE9
3uB/qQ/8DG65y1SvNeHqPhUbc+8R/34sag6AET2l1nbJ9QBXbCcqIp87onyUpOrJ
eu4cSUbVgntx5r+EK2qpKHBJ+pUm3Dn1NlV+o7o2ZftNOJCQ0o43RsTrvroRDP3L
LEsqqr0mnGOfLm96uKZYGzagJSII6P8ksplJCuxZqAnnwArDYMy15aupJi4jk0CI
bCUMysjPypMFWXCki+uXGKRIQrjkLHGyQzsGnAEHT/3REnqs5u2c68wyViW/FrH5
WyAPL+1Vhr3yqE9+3Ql/ZQWe3hXfW5W455xpkvO+SKD4LW9m6OL4xYsRNoLpN/TY
xBSgrTu1XVvZTARVgs3KntJre5nfNQefayD/1ArG2OIdcCPNsqIevnXIwS81Y/mm
10Yei+nVbUS2bMqeAI15Z8p4R0TJTxz5M6RGlR2GUCgdXCOGjgjl4AQ9249D3tKp
Woh3akFeVU/887TPQzz3su2w1dtSCmMJAh6/T07iMOrFaEYE/Tj52JGrz4irpiMN
Hcail5/+fO4zhcRomDGdfiKv9CPE22k1QJ1QXoHOL3DOYugms6K2Zj+JlI6d4GSw
Hbs77ZxXouV4XoSze8zOyoMIM/I01zf/dljR41ZZJ4LL1mJmMwJwUP6kBHXwAcPH
42z0MA7i5ABtzFROULOd5dmlEdM4eVt8vJbPxufPvLj3m/c7gUc=
=0O/y
-----END PGP SIGNATURE-----

--m03ZOlbUZYJIKcQDY8ubChZ4jyE8k65YF--
