Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9HNp46131886 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 11:23:51 -0600
Received: from karif.server-speed.net (karif.server-speed.net [188.40.51.140])
	by cuda.sgi.com with ESMTP id CDp65WbDhOCmwFbt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Nov 2012 09:25:49 -0800 (PST)
Message-ID: <509D3C9A.6040209@xinu.at>
Date: Fri, 09 Nov 2012 18:25:46 +0100
From: Florian Pritz <bluewind@xinu.at>
MIME-Version: 1.0
Subject: Re: NFS stalls when writing - linux 3.6.x
References: <50957087.6050008@xinu.at> <20121107190724.GD7421@fieldses.org>
	<509D2993.4050604@xinu.at> <20121109163658.GE6171@fieldses.org>
	<20121109172014.GT9783@sgi.com>
In-Reply-To: <20121109172014.GT9783@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5927697261565048522=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============5927697261565048522==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA73601D2338BA9D2DB3A35AD"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA73601D2338BA9D2DB3A35AD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09.11.2012 18:20, Ben Myers wrote:
> I took a brief look but there were no slam dunks.  This seems like it m=
ight be
> a candidate:
>=20
> 8375f922 - xfs: re-enable xfsaild idle mode and fix associated races
>=20
> The sysrq-trigger information would definately be helpful.  Meanwhile I=
'll see
> if I can reproduce the issue.

No idea why it doesn't show up on gmane yet (the excerpt is from my mail
to the list), but I've uploaded it here[1]. The link will be valid for
10 days.

[1]: https://paste.xinu.at/koXRw/

--=20
Florian Pritz


--------------enigA73601D2338BA9D2DB3A35AD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnTyaAAoJEG0WVcFM4cE+MSAQANIRtLp/ZgBy5PGUv2jCi9j1
bOPFmidafzVaMX5fM0YcxI94ToAg4tkk6biGCj0C0kYfKbTaods9TsUOJO3MvLaM
yw3rZpUFAVDuyeA0Q5j9mqEZeCofVSURLHMvJx618giyfhEPMND4RBYAk8MH7eYV
5WGEsuB3x0Cog7zXz+kZ1UBrExhaHmEWfV3WK8zw9EBAkB4XhxE3SV9AT4uq6K4Q
LkSEm6SVKewnsS8GuULejPTgdo9GFi2lJCVUFJiVuOZyygxSuiSLZRoglsP4R5QO
Z2suctOJxpIEt8vVU3JORFowSlXG7lu4Z75GBmVHb65/Jhvk6G3fYEts/uInoO6d
rRmCA/kfLiTqPqpaA87lsfi72kQ5GwWnE1tVHBCZ3Q0gX8u0WpDY6twvcczmsxjZ
dSwx6ndD5FiN3rsvoYzdBYTZunPSVzPOwRsVHCofaHJfpaPf/zSipfN8+oQcUvKq
pfU0939mt87asnm7bnPKJ6PjZ/dxHkWJp40bZse7WfeyHFiRIj9OTuDt6DhjtpgV
60RJ2VpkvXFVmGulbrc7uHmd74NO2bNXXzbcaYGst81vq3Ojfzu1qgEPdPzDelBm
I9WBtzYP8CbE3D5KBlI80M2TSQLu1XzvQuPm2wTB9x/B213PR9LAmIcmVGHzaYKw
i5abQQoolhtPEnXxama+
=DpmF
-----END PGP SIGNATURE-----

--------------enigA73601D2338BA9D2DB3A35AD--


--===============5927697261565048522==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5927697261565048522==--
