Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C381D7F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 14:15:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51B94AC005
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 12:15:34 -0800 (PST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com
	[74.125.82.52]) by cuda.sgi.com with ESMTP id pWeKUJ0nD6Jbm46b
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Dec 2015 12:15:32 -0800 (PST)
Received: by wmpp66 with SMTP id p66so76447255wmp.1
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 12:15:31 -0800 (PST)
Date: Mon, 14 Dec 2015 21:15:26 +0100
From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: Re: BUG: KASAN: use-after-free in xfs_iflush_cluster+0x9d7/0xaf0
Message-ID: <20151214201526.GA25152@glen>
References: <20151214180048.GA15690@glen>
 <20151214195422.GM26718@dastard>
MIME-Version: 1.0
In-Reply-To: <20151214195422.GM26718@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3376469857413192112=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com


--===============3376469857413192112==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 15, 2015 at 06:54:22AM +1100, Dave Chinner wrote:
> What line of code does this address correspond to in your kernel?
>=20
> 	xfs_iflush_cluster+0x9d7

gelma@glen:~/dev/kernel/v4.4.x$ git grep -Iin xfs_iflush_cluster
fs/xfs/xfs_inode.c:3179:xfs_iflush_cluster(
fs/xfs/xfs_inode.c:3414:	error =3D xfs_iflush_cluster(ip, bp);


Thanks a lot for your quick answer,
Andrea

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQJ8BAEBCgBmBQJWbyNeXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRFQTQyRTkzNjBCNzVERDZFODMyNTQ3RjdB
NDMwOTA3NUYwNTk2MEY2AAoJEKQwkHXwWWD2H3MQAMYmowe3OLqavidixxIqn/di
YsPztbgzT7DM1Fu6Mi0t15/yqX8unxFEeCW4qFWD6tmQP0xioLOvnyK+YYUWftUC
+eG0fyQRdkjcPBQTqrpCcuUU4r+R1cFLhZQGEYon16Ur3tmXy+0uZyTfokkS+aAm
yrNZRNqZAfgOdgwDBOJBrwNVAZmnF0XF8BC685VhI2COuq8giFQg00Va/5airhVs
0K+wRSWiy9u8nrvSWRwhjtLPSHAPtMRCSwibEfe+eL1bdelq6CbViXm+0W+bpT7B
DrT4A5JkUuFOKfHMrcjksN1+7v2tUTZ1fSjEW+CUYZ66niZadJtKvi7deE0On071
CUXBKQKo9QpmTIIJEiKCpoyN6G1tCZi+wpOPj//QN1X8k9UDaIdcBTwk5sbZWRJK
hmtoViSTn5RgCiYvrUUtL5IomCraij1nkdZD4rOi0GghoBN9+fG3BjVCYJKh6oDl
7Bm9xYscNNVxGm03oEHA3x5a9TVfpp6UxrzHok43Ma1oFt4vaaYAQ0CZRJdJGtl0
s7ms6yN9lNCP3HWu0ysfmTFJaYGGmcjvG/N+FmJKQGHbaLJtBU5HP7SvHF5+ifL5
QhStXt6bqjQiZCVcT5XX0BK9q61+czc1sP6bsFO6MR6faatuXBm7YxhbeNvukyDL
Dtgzli75EBZtmo2qX68M
=BsZX
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--


--===============3376469857413192112==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3376469857413192112==--
