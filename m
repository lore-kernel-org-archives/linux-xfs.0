Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD9067F69
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 20:21:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A52C0304051
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 18:21:01 -0800 (PST)
Received: from mail-pa0-f48.google.com (mail-pa0-f48.google.com
	[209.85.220.48]) by cuda.sgi.com with ESMTP id CL5LZWCA84v474yr
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Nov 2015 18:21:00 -0800 (PST)
Received: by pabfh17 with SMTP id fh17so36577115pab.0
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 18:21:00 -0800 (PST)
Subject: Re: [PATCH v13 43/51] ext4: Don't allow unmapped identifiers in
	richacls
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446563847-14005-44-git-send-email-agruenba@redhat.com>
Date: Tue, 3 Nov 2015 19:20:46 -0700
Message-Id: <6E00DAEB-506C-4D93-8131-D12D459D7919@dilger.ca>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-44-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0640026660189634988=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>


--===============0640026660189634988==
Content-Type: multipart/signed; boundary="Apple-Mail=_951D32E2-636D-4F9D-890C-9450C7F0D2FA"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_951D32E2-636D-4F9D-890C-9450C7F0D2FA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Nov 3, 2015, at 8:17 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> Don't allow acls which contain unmapped identifiers: they are =
meaningful
> for remote file systems only.

Looks fine.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
> fs/ext4/richacl.c | 4 ++++
> 1 file changed, 4 insertions(+)
>=20
> diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
> index 906d048..2115385 100644
> --- a/fs/ext4/richacl.c
> +++ b/fs/ext4/richacl.c
> @@ -74,6 +74,10 @@ __ext4_set_richacl(handle_t *handle, struct inode =
*inode, struct richacl *acl)
> 	int retval, size;
> 	void *value;
>=20
> +	/* Don't allow acls with unmapped identifiers. */
> +	if (richacl_has_unmapped_identifiers(acl))
> +		return -EINVAL;
> +
> 	if (richacl_equiv_mode(acl, &mode) =3D=3D 0) {
> 		inode->i_ctime =3D ext4_current_time(inode);
> 		inode->i_mode =3D mode;
> --
> 2.5.0
>=20


Cheers, Andreas






--Apple-Mail=_951D32E2-636D-4F9D-890C-9450C7F0D2FA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVjlrf3Kl2rkXzB/gAQhIRhAAmFM6Z3Er7qv7heUk5sBoyGEDG2hJCU2M
6AM81ezeI9+BqJ3VHsNLivKEf4tDQLktfe8awj/hkJuBlSp2TT8ILjsr8qDJ+Zbb
p4YwN9RG9VUMo3ncBD9UJmZdlv0cjTaEpnwVAAJBDLU//1Km0mLBxujQD6Pjr+/m
aN4pxOjJBbApz9RneupgetsRu3H+Bm3II0grAL8DyjQJdPEZ/Vf7ZjDdcbfXXmLQ
SMzBmOCs9xquwrgBwb7Ob1Yc+rVqotvQiwuelrl6ZAjbXGwz+nKVNSfxz9vZ+kIA
EaevYOYOr4USHXPah3iw0fHNJjmiiLQ6RJPFfT/mjuNvahoC/Q/9O4prrFZq3lP2
s5KGEMEEtQgM6xVGABcY8sDumuZEKW1J/kK5aXSt09nkKmfw9aN2CkWcM5c4FZow
2bMFH6DT7tAnsu/bHcCfj1hbhxqOSDAPg4pjxxirFR+IAN64Wkuk/0KKsu/S2LwX
hSmuJt4cKxmURIhMjHysmfnXc4kivMhc/YSKXXqRa0mfUw7+pUqMkzEUzdVIYrz0
qVbZBE6fNI+vZIdESJ3RO3PLw++JVsAfoPr+XXJDeNfy7FPCq+mzIZP+6uq8Q5iE
p2Vgg0tafoyFHl88ttZFc2QksLdHHtEQ/A4NM2k6gZIiwbDpHiIgdtww5+/MQhrz
/02xQ7FHhKM=
=DK1q
-----END PGP SIGNATURE-----

--Apple-Mail=_951D32E2-636D-4F9D-890C-9450C7F0D2FA--


--===============0640026660189634988==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0640026660189634988==--
