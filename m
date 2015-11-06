Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E9477F87
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 15:27:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B6878F8033
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 13:27:27 -0800 (PST)
Received: from mail-pa0-f42.google.com (mail-pa0-f42.google.com
	[209.85.220.42]) by cuda.sgi.com with ESMTP id MK3asVQELXuLRjJI
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Nov 2015 13:27:25 -0800 (PST)
Received: by pabfh17 with SMTP id fh17so133940976pab.0
	for <xfs@oss.sgi.com>; Fri, 06 Nov 2015 13:27:24 -0800 (PST)
Subject: Re: [PATCH v14 03/22] vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD
	permission flags
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446723580-3747-4-git-send-email-agruenba@redhat.com>
Date: Fri, 6 Nov 2015 14:26:45 -0700
Message-Id: <88120453-8E06-481C-90C7-5D7E7B279C4E@dilger.ca>
References: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
	<1446723580-3747-4-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1248904952758722363=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>


--===============1248904952758722363==
Content-Type: multipart/signed; boundary="Apple-Mail=_2915270B-23EA-4C7B-BE26-9213A7A0F9C4"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_2915270B-23EA-4C7B-BE26-9213A7A0F9C4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 5, 2015, at 4:39 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> Normally, deleting a file requires MAY_WRITE access to the parent
> directory.  With richacls, a file may be deleted with MAY_DELETE_CHILD =
access
> to the parent directory or with MAY_DELETE_SELF access to the file.
>=20
> To support that, pass the MAY_DELETE_CHILD mask flag to =
inode_permission()
> when checking for delete access inside a directory, and =
MAY_DELETE_SELF
> when checking for delete access to a file itelf.
>=20
> The MAY_DELETE_SELF permission overrides the sticky directory check.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: J. Bruce Fields <bfields@redhat.com>
> ---
> fs/namei.c         | 21 ++++++++++++---------
> include/linux/fs.h |  2 ++
> 2 files changed, 14 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/namei.c b/fs/namei.c
> index 0259392..2eab19e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -453,9 +453,9 @@ static int sb_permission(struct super_block *sb, =
struct inode *inode, int mask)
>  * this, letting us set arbitrary permissions for filesystem access =
without
>  * changing the "normal" UIDs which are used for other things.
>  *
> - * MAY_WRITE must be set in @mask whenever MAY_APPEND, =
MAY_CREATE_FILE, or
> - * MAY_CREATE_DIR are set.  That way, file systems that don't support =
these
> - * permissions will check for MAY_WRITE instead.
> + * MAY_WRITE must be set in @mask whenever MAY_APPEND, =
MAY_CREATE_FILE,
> + * MAY_CREATE_DIR, or MAY_DELETE_CHILD are set.  That way, file =
systems that
> + * don't support these permissions will check for MAY_WRITE instead.
>  */
> int inode_permission(struct inode *inode, int mask)
> {
> @@ -2555,7 +2555,7 @@ static int may_delete(struct inode *dir, struct =
dentry *victim,
> 		      bool isdir, bool replace)
> {
> 	struct inode *inode =3D d_backing_inode(victim);
> -	int error, mask =3D MAY_WRITE | MAY_EXEC;
> +	int error, mask =3D MAY_EXEC;
>=20
> 	if (d_is_negative(victim))
> 		return -ENOENT;
> @@ -2565,15 +2565,18 @@ static int may_delete(struct inode *dir, =
struct dentry *victim,
> 	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
>=20
> 	if (replace)
> -		mask |=3D isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
> -	error =3D inode_permission(dir, mask);
> +		mask |=3D MAY_WRITE | (isdir ? MAY_CREATE_DIR : =
MAY_CREATE_FILE);
> +	error =3D inode_permission(dir, mask | MAY_WRITE | =
MAY_DELETE_CHILD);
> +	if (!error && check_sticky(dir, inode))
> +		error =3D -EPERM;
> +	if (error && IS_RICHACL(inode) &&
> +	    inode_permission(inode, MAY_DELETE_SELF) =3D=3D 0)
> +		error =3D 0;

This looks like a serious bug, as it is overriding other errors returned
from inode_permission() such as -EROFS from sb_permission() or even from
generic_permission->acl_permission_check().  Clearing the error returned
by an earlier check doesn't seem safe, only new errors should be added.

The call to inode_permission(inode) is also duplicating the =
sb_permission()
check from inode_permission(dir), so at most should be =
__inode_permission().

It looks like this would be correct if you check MAY_DELETE_SELF =
together
with check_sticky():

	if (!error && check_sticky(dir, inode) &&
	    !__inode_permission(inode, MAY_DELETE_SELF))
		error =3D -EPERM;

I ommitted the IS_RICHACL() check here, since that should probably be in
__inode_permission() when MAY_DELETE_SELF is passed?

Cheers, Andreas

> 	if (error)
> 		return error;
> 	if (IS_APPEND(dir))
> 		return -EPERM;

> -
> -	if (check_sticky(dir, inode) || IS_APPEND(inode) ||
> -	    IS_IMMUTABLE(inode) || IS_SWAPFILE(inode))
> +	if (IS_APPEND(inode) || IS_IMMUTABLE(inode) || =
IS_SWAPFILE(inode))
> 		return -EPERM;

> 	if (isdir) {
> 		if (!d_is_dir(victim))
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index d6e2330..402acd7 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -84,6 +84,8 @@ typedef void (dax_iodone_t)(struct buffer_head =
*bh_map, int uptodate);
> #define MAY_NOT_BLOCK		0x00000080
> #define MAY_CREATE_FILE		0x00000100
> #define MAY_CREATE_DIR		0x00000200
> +#define MAY_DELETE_CHILD	0x00000400
> +#define MAY_DELETE_SELF		0x00000800
>=20
> /*
>  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must =
correspond
> --
> 2.5.0
>=20


Cheers, Andreas






--Apple-Mail=_2915270B-23EA-4C7B-BE26-9213A7A0F9C4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVj0bFXKl2rkXzB/gAQgVMw/9HRWeCdxHmVddBJ/NJ4cEapoGKeJnXALg
cLCr0ABLWmBJr3IH+IUcb717xKy9DtCjIMB5WIRCi6xhaNqfm+4ytLpQ34zLq006
EXkyLU/RMK2/x1OI/VsPHZ6LX8SAHqIwq5pJ8ZDd8ZuwA74DRwY6txYEyRHOptdT
xffUViiy+5tEJChnqJgi4gMSaGXamyoUjJ/YfF1/TftgMq7Iil8DC6JtcfUtEuTu
NhXsPhpGl4Dfz+jOyZd09CmaKDdeXHoE9o/0vEjZz6A20yS1zC5fbjQ0UwqMUDT9
WDyxa9WbLArpUalW/L0tRE1l34n/rfIqIBz0gSF0Uw/cjE6mPb40Vc+W4AWkUEZl
K3LWTq6aXdSn9oXmPDW5/4y3lVVeJ0DLRHCMkgkKGyx0U2zcHyHkA+iEIYM7+0FL
2nJ7KBig+DX2O/qXvsygIfYiaOsLJTnkz+8s6hOh041lbNSOK9Ul9E1IjAGd4VV3
Ft7+qLEtN0LT464Lj2SxfSRh3B+Ug+ylVgNiC496XILMSGAga7ORSNeoKDhMbO1h
b+KHBY8hHgQL446CHtIiMEveBtXEgKK7DH0zdl2kpTtGwTMmwOHsZ/6IVUeBKZGh
V4dD1jpUZtmqgNsxysAMs2bCH7R+w+1syXB09lP4+KTaGlQeSATGtlFkZ4Ow2i1l
rxiI67P1K2g=
=Vb9Z
-----END PGP SIGNATURE-----

--Apple-Mail=_2915270B-23EA-4C7B-BE26-9213A7A0F9C4--


--===============1248904952758722363==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1248904952758722363==--
