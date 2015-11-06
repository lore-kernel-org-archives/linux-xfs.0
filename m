Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1882B7F76
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 15:04:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 04AD78F8033
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 13:04:17 -0800 (PST)
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id p1kxy2VAtI5cXwkG
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Nov 2015 13:04:13 -0800 (PST)
Received: by pabfh17 with SMTP id fh17so133462618pab.0
	for <xfs@oss.sgi.com>; Fri, 06 Nov 2015 13:04:12 -0800 (PST)
Subject: Re: [PATCH v14 04/22] vfs: Make the inode passed to inode_change_ok
	non-const
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446723580-3747-5-git-send-email-agruenba@redhat.com>
Date: Fri, 6 Nov 2015 14:04:07 -0700
Message-Id: <A1B39E8C-4904-48D8-9CE6-2A464A5D476D@dilger.ca>
References: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
	<1446723580-3747-5-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6648739841219669278=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>


--===============6648739841219669278==
Content-Type: multipart/signed; boundary="Apple-Mail=_C50AB9E3-D3AC-4D52-99DF-74EAB42E7D8D"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_C50AB9E3-D3AC-4D52-99DF-74EAB42E7D8D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Nov 5, 2015, at 4:39 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> We will need to call iop->permission and iop->get_acl from
> inode_change_ok() for additional permission checks, and both take a
> non-const inode.

Seems unfortunate that those functions cannot themselves be changed to
take a const struct inode, but it doesn't look possible.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: J. Bruce Fields <bfields@redhat.com>
> ---
> fs/attr.c          | 2 +-
> include/linux/fs.h | 2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/attr.c b/fs/attr.c
> index 6530ced..328be71 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -28,7 +28,7 @@
>  * Should be called as the first thing in ->setattr implementations,
>  * possibly after taking additional locks.
>  */
> -int inode_change_ok(const struct inode *inode, struct iattr *attr)
> +int inode_change_ok(struct inode *inode, struct iattr *attr)
> {
> 	unsigned int ia_valid =3D attr->ia_valid;
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 402acd7..aab32c8 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2871,7 +2871,7 @@ extern int buffer_migrate_page(struct =
address_space *,
> #define buffer_migrate_page NULL
> #endif
>=20
> -extern int inode_change_ok(const struct inode *, struct iattr *);
> +extern int inode_change_ok(struct inode *, struct iattr *);
> extern int inode_newsize_ok(const struct inode *, loff_t offset);
> extern void setattr_copy(struct inode *inode, const struct iattr =
*attr);
>=20
> --
> 2.5.0
>=20


Cheers, Andreas






--Apple-Mail=_C50AB9E3-D3AC-4D52-99DF-74EAB42E7D8D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVj0Vx3Kl2rkXzB/gAQjYHQ/+L9LDlXVXWGi/GhDrCiBpnUWSkDNUm3a+
Vwxf/j2ZpsEZpgjz/sjgi+c189DNa1ZhpRe6M9kUYIQqofiHfYS+Yx3GpDvyCzUo
qmXtDGSPMRzsOjMNlx9NPoQULPutHRWJcKvHTXypQHGl3qbezEFvbUfP47l0trqQ
xir5U2N4z13p2ipJTq2Y7FstNqOgNU/xiF+BUeFlFDS5S8K6gXQVsAwhOHBpzRMp
A5v60jIbYtP5MmRiKDSbrEQLQte1g4rIlKklWIsjAmTbK98CRc8f3eb4V+DXYzNp
rjoTsY8H2XoJJeYmFe9/+CxVI/ICOoaCSRRZ9aV9hkff1gz2CifXM5kGy4WWO3Md
puhLHUJIUNhmSqWJEsDCJOegOS7XlrnrFLscv4VkCpse7UM9kMtn/ZtJABzQItfk
5DQ4OCoR9u2tXJlyVG8XWHiKzpNYL0ehDeYlIagguHgir0bM5lj4cji3vmoCGDZS
lU5vGydGX6nR8zeaTuPgGULObDEPOEi1jlDcyuSQz9VIhqTfuNgNPoZibZDhSYoH
zb6T3pNiV4peHzRZ1E8Pi/pZ7yVEdtuKQWSP34QyDjspnANm1panb7MtIEo09TIk
GPwEePLgLRlsrnD1bl1BhuZ4eby+yLYJp2c/AZnovrI4d7Wp1IQc4k9LFR5qB0ai
2AwZOWhuDpg=
=SiKg
-----END PGP SIGNATURE-----

--Apple-Mail=_C50AB9E3-D3AC-4D52-99DF-74EAB42E7D8D--


--===============6648739841219669278==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6648739841219669278==--
