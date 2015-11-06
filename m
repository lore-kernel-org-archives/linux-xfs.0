Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A8DF57F75
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 14:40:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 971808F8035
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2015 12:40:30 -0800 (PST)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id VCQ3aYi1mb7JVsjv
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Nov 2015 12:40:27 -0800 (PST)
Received: by pabfh17 with SMTP id fh17so132962785pab.0
	for <xfs@oss.sgi.com>; Fri, 06 Nov 2015 12:40:27 -0800 (PST)
Subject: Re: [PATCH v14 01/22] vfs: Add IS_ACL() and IS_RICHACL() tests
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446723580-3747-2-git-send-email-agruenba@redhat.com>
Date: Fri, 6 Nov 2015 13:40:19 -0700
Message-Id: <FC1DC7F3-F165-4575-944F-EA2926C37E11@dilger.ca>
References: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
	<1446723580-3747-2-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6153252508625250544=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>


--===============6153252508625250544==
Content-Type: multipart/signed; boundary="Apple-Mail=_6590A0FC-D328-440C-B3C9-4B91CB6E915B"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_6590A0FC-D328-440C-B3C9-4B91CB6E915B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 5, 2015, at 4:39 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> The vfs does not apply the umask for file systems that support acls. =
The
> test used for this used to be called IS_POSIXACL(). Switch to a new
> IS_ACL() test to check for either posix acls or richacls instead. Add =
a new
> MS_RICHACL flag and IS_RICHACL() test for richacls alone. The =
IS_POSIXACL()
> test is still needed by nfsd.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: J. Bruce Fields <bfields@redhat.com>

Looks good to me.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/Kconfig              |  3 +++
> fs/namei.c              |  8 ++++----
> include/linux/fs.h      | 12 ++++++++++++
> include/uapi/linux/fs.h |  3 ++-
> 4 files changed, 21 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/Kconfig b/fs/Kconfig
> index da3f32f..bff2879 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -56,6 +56,9 @@ endif # BLOCK
> config FS_POSIX_ACL
> 	def_bool n
>=20
> +config FS_RICHACL
> +	def_bool n
> +
> config EXPORTFS
> 	tristate
>=20
> diff --git a/fs/namei.c b/fs/namei.c
> index 33e9495..224ecf1 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2798,7 +2798,7 @@ static int atomic_open(struct nameidata *nd, =
struct dentry *dentry,
> 	}
>=20
> 	mode =3D op->mode;
> -	if ((open_flag & O_CREAT) && !IS_POSIXACL(dir))
> +	if ((open_flag & O_CREAT) && !IS_ACL(dir))
> 		mode &=3D ~current_umask();
>=20
> 	excl =3D (open_flag & (O_EXCL | O_CREAT)) =3D=3D (O_EXCL | =
O_CREAT);
> @@ -2982,7 +2982,7 @@ static int lookup_open(struct nameidata *nd, =
struct path *path,
> 	/* Negative dentry, just create the file */
> 	if (!dentry->d_inode && (op->open_flag & O_CREAT)) {
> 		umode_t mode =3D op->mode;
> -		if (!IS_POSIXACL(dir->d_inode))
> +		if (!IS_ACL(dir->d_inode))
> 			mode &=3D ~current_umask();
> 		/*
> 		 * This write is needed to ensure that a
> @@ -3553,7 +3553,7 @@ retry:
> 	if (IS_ERR(dentry))
> 		return PTR_ERR(dentry);
>=20
> -	if (!IS_POSIXACL(path.dentry->d_inode))
> +	if (!IS_ACL(path.dentry->d_inode))
> 		mode &=3D ~current_umask();
> 	error =3D security_path_mknod(&path, dentry, mode, dev);
> 	if (error)
> @@ -3622,7 +3622,7 @@ retry:
> 	if (IS_ERR(dentry))
> 		return PTR_ERR(dentry);
>=20
> -	if (!IS_POSIXACL(path.dentry->d_inode))
> +	if (!IS_ACL(path.dentry->d_inode))
> 		mode &=3D ~current_umask();
> 	error =3D security_path_mkdir(&path, dentry, mode);
> 	if (!error)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 72d8a84..4efa435 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1781,6 +1781,12 @@ struct super_operations {
> #define IS_IMMUTABLE(inode)	((inode)->i_flags & S_IMMUTABLE)
> #define IS_POSIXACL(inode)	__IS_FLG(inode, MS_POSIXACL)
>=20
> +#ifdef CONFIG_FS_RICHACL
> +#define IS_RICHACL(inode)	__IS_FLG(inode, MS_RICHACL)
> +#else
> +#define IS_RICHACL(inode)	0
> +#endif
> +
> #define IS_DEADDIR(inode)	((inode)->i_flags & S_DEAD)
> #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
> #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
> @@ -1794,6 +1800,12 @@ struct super_operations {
> 				 (inode)->i_rdev =3D=3D WHITEOUT_DEV)
>=20
> /*
> + * IS_ACL() tells the VFS to not apply the umask
> + * and use check_acl for acl permission checks when defined.
> + */
> +#define IS_ACL(inode)		__IS_FLG(inode, MS_POSIXACL | =
MS_RICHACL)
> +
> +/*
>  * Inode state bits.  Protected by inode->i_lock
>  *
>  * Three bits determine the dirty state of the inode, I_DIRTY_SYNC,
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 9b964a5..6ac6bc9 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -81,7 +81,7 @@ struct inodes_stat_t {
> #define MS_VERBOSE	32768	/* War is peace. Verbosity is silence.
> 				   MS_VERBOSE is deprecated. */
> #define MS_SILENT	32768
> -#define MS_POSIXACL	(1<<16)	/* VFS does not apply the umask */
> +#define MS_POSIXACL	(1<<16)	/* Supports POSIX ACLs */
> #define MS_UNBINDABLE	(1<<17)	/* change to unbindable */
> #define MS_PRIVATE	(1<<18)	/* change to private */
> #define MS_SLAVE	(1<<19)	/* change to slave */
> @@ -91,6 +91,7 @@ struct inodes_stat_t {
> #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
> #define MS_STRICTATIME	(1<<24) /* Always perform atime updates =
*/
> #define MS_LAZYTIME	(1<<25) /* Update the on-disk [acm]times lazily =
*/
> +#define MS_RICHACL	(1<<26) /* Supports richacls */
>=20
> /* These sb flags are internal to the kernel */
> #define MS_NOSEC	(1<<28)
> --
> 2.5.0
>=20


Cheers, Andreas






--Apple-Mail=_6590A0FC-D328-440C-B3C9-4B91CB6E915B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVj0QNHKl2rkXzB/gAQgu9BAApe7t8JVkJBussiJ9KKn3HcKnbRMd0Ceb
yHLcspAiOUXHfjYzZdKOrdXC2PIGV0Yn9ka6dMHKjktKAy95hTtkGdyKZFTtS5eu
TvyEtTo0OX0I1XhuSQWBljBlO98BdgggT4mDUY52rmb34E8wEEiuCA3vESEQtVJm
TblPjsT9xHFwMsApvbLRM+SD8PQl5x6n8lyzUtc4rcRBnpSlYO1AapJ5CKbKUXRR
J1J4a8cU5hEGshwKqmd/vs+Gz8QsR6pXCuGxmG+d4OjjtoQa2y60b+e8BHL8yYHp
qmaDKEXsJVl93H29IC+Pfah5DTsFpBPi3kcZMT86UGnIE5dcQocB9zhloiY3l14Y
M+uV9MDmzgI8y/+vyytmwtECYlaXfFcMbYYolxfBqDi/p4OPS1nRsDUHJL/Ph+g8
jqyALbYkqGdJIBj9Yumh7ZSFtCMeQzlFZI1SctRddOk7DYgvuKoTqC+8zo3ttIbP
Fa3sL2RtPd5HsNP6ksNsye5qblhV2CfLpq+hox8XxEW2GUF8+uO/cI+s6ugChNsi
hMCc5Yn1ANjicj2jmJH7e1f2WZxM1hnDNv3Jw34CoUkb4mWPgiw9Y3IBDBvq4Br3
2rvRPo4XkvZy4Y37dKb1latxRllqsbDU6Dhs2HZpCuTBHklw2BpWTjMxr2F8rXxV
5rtthkKehAA=
=qMGN
-----END PGP SIGNATURE-----

--Apple-Mail=_6590A0FC-D328-440C-B3C9-4B91CB6E915B--


--===============6153252508625250544==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6153252508625250544==--
