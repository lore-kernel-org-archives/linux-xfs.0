Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bilbo.ozlabs.org ([203.11.71.1]:40221 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbfGABGI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 30 Jun 2019 21:06:08 -0400
Date: Mon, 1 Jul 2019 11:06:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the xfs tree with the f2fs tree
Message-ID: <20190701110603.5abcbb2c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/WHgTUq_CIxHe8Gi/4qnrMHz"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers@google.com>

--Sig_/WHgTUq_CIxHe8Gi/4qnrMHz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xfs tree got a conflict in:

  fs/f2fs/file.c

between commit:

  360985573b55 ("f2fs: separate f2fs i_flags from fs_flags and ext4 i_flags=
")

from the f2fs tree and commits:

  de2baa49bbae ("vfs: create a generic checking and prep function for FS_IO=
C_SETFLAGS")
  3dd3ba36a8ee ("vfs: create a generic checking function for FS_IOC_FSSETXA=
TTR")

from the xfs tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
This is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc fs/f2fs/file.c
index e7c368db8185,8799468724f9..000000000000
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@@ -1645,22 -1648,45 +1645,23 @@@ static int f2fs_file_flush(struct file=20
  	return 0;
  }
 =20
 -static int f2fs_ioc_getflags(struct file *filp, unsigned long arg)
 -{
 -	struct inode *inode =3D file_inode(filp);
 -	struct f2fs_inode_info *fi =3D F2FS_I(inode);
 -	unsigned int flags =3D fi->i_flags;
 -
 -	if (IS_ENCRYPTED(inode))
 -		flags |=3D F2FS_ENCRYPT_FL;
 -	if (f2fs_has_inline_data(inode) || f2fs_has_inline_dentry(inode))
 -		flags |=3D F2FS_INLINE_DATA_FL;
 -	if (is_inode_flag_set(inode, FI_PIN_FILE))
 -		flags |=3D F2FS_NOCOW_FL;
 -
 -	flags &=3D F2FS_FL_USER_VISIBLE;
 -
 -	return put_user(flags, (int __user *)arg);
 -}
 -
 -static int __f2fs_ioc_setflags(struct inode *inode, unsigned int flags)
 +static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
  {
  	struct f2fs_inode_info *fi =3D F2FS_I(inode);
 -	unsigned int oldflags;
 +	u32 oldflags;
+ 	int err;
 =20
  	/* Is it quota file? Do not allow user to mess with it */
  	if (IS_NOQUOTA(inode))
  		return -EPERM;
 =20
 -	flags =3D f2fs_mask_flags(inode->i_mode, flags);
 -
  	oldflags =3D fi->i_flags;
 =20
- 	if ((iflags ^ oldflags) & (F2FS_APPEND_FL | F2FS_IMMUTABLE_FL))
- 		if (!capable(CAP_LINUX_IMMUTABLE))
- 			return -EPERM;
 -	err =3D vfs_ioc_setflags_prepare(inode, oldflags, flags);
++	err =3D vfs_ioc_setflags_prepare(inode, oldflags, iflags);
+ 	if (err)
+ 		return err;
 =20
 -	flags =3D flags & F2FS_FL_USER_MODIFIABLE;
 -	flags |=3D oldflags & ~F2FS_FL_USER_MODIFIABLE;
 -	fi->i_flags =3D flags;
 +	fi->i_flags =3D iflags | (oldflags & ~mask);
 =20
  	if (fi->i_flags & F2FS_PROJINHERIT_FL)
  		set_inode_flag(inode, FI_PROJ_INHERIT);
@@@ -2850,53 -2773,35 +2851,33 @@@ static inline u32 f2fs_xflags_to_iflags
  	return iflags;
  }
 =20
- static int f2fs_ioc_fsgetxattr(struct file *filp, unsigned long arg)
+ static void f2fs_fill_fsxattr(struct inode *inode, struct fsxattr *fa)
  {
- 	struct inode *inode =3D file_inode(filp);
  	struct f2fs_inode_info *fi =3D F2FS_I(inode);
- 	struct fsxattr fa;
 =20
- 	memset(&fa, 0, sizeof(struct fsxattr));
- 	fa.fsx_xflags =3D f2fs_iflags_to_xflags(fi->i_flags);
 -	simple_fill_fsxattr(fa, f2fs_iflags_to_xflags(fi->i_flags &
 -						      F2FS_FL_USER_VISIBLE));
++	simple_fill_fsxattr(fa, f2fs_iflags_to_xflags(fi->i_flags));
 =20
  	if (f2fs_sb_has_project_quota(F2FS_I_SB(inode)))
- 		fa.fsx_projid =3D (__u32)from_kprojid(&init_user_ns,
- 							fi->i_projid);
-=20
- 	if (copy_to_user((struct fsxattr __user *)arg, &fa, sizeof(fa)))
- 		return -EFAULT;
- 	return 0;
+ 		fa->fsx_projid =3D from_kprojid(&init_user_ns, fi->i_projid);
  }
 =20
- static int f2fs_ioctl_check_project(struct inode *inode, struct fsxattr *=
fa)
+ static int f2fs_ioc_fsgetxattr(struct file *filp, unsigned long arg)
  {
- 	/*
- 	 * Project Quota ID state is only allowed to change from within the init
- 	 * namespace. Enforce that restriction only if we are trying to change
- 	 * the quota ID state. Everything else is allowed in user namespaces.
- 	 */
- 	if (current_user_ns() =3D=3D &init_user_ns)
- 		return 0;
+ 	struct inode *inode =3D file_inode(filp);
+ 	struct fsxattr fa;
 =20
- 	if (__kprojid_val(F2FS_I(inode)->i_projid) !=3D fa->fsx_projid)
- 		return -EINVAL;
-=20
- 	if (F2FS_I(inode)->i_flags & F2FS_PROJINHERIT_FL) {
- 		if (!(fa->fsx_xflags & FS_XFLAG_PROJINHERIT))
- 			return -EINVAL;
- 	} else {
- 		if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
- 			return -EINVAL;
- 	}
+ 	f2fs_fill_fsxattr(inode, &fa);
 =20
+ 	if (copy_to_user((struct fsxattr __user *)arg, &fa, sizeof(fa)))
+ 		return -EFAULT;
  	return 0;
  }
 =20
  static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
  {
  	struct inode *inode =3D file_inode(filp);
- 	struct fsxattr fa;
 -	struct f2fs_inode_info *fi =3D F2FS_I(inode);
+ 	struct fsxattr fa, old_fa;
 -	unsigned int flags;
 +	u32 iflags;
  	int err;
 =20
  	if (copy_from_user(&fa, (struct fsxattr __user *)arg, sizeof(fa)))
@@@ -2918,11 -2823,14 +2899,13 @@@
  		return err;
 =20
  	inode_lock(inode);
- 	err =3D f2fs_ioctl_check_project(inode, &fa);
+=20
+ 	f2fs_fill_fsxattr(inode, &old_fa);
+ 	err =3D vfs_ioc_fssetxattr_check(inode, &old_fa, &fa);
  	if (err)
  		goto out;
 -	flags =3D (fi->i_flags & ~F2FS_FL_XFLAG_VISIBLE) |
 -				(flags & F2FS_FL_XFLAG_VISIBLE);
 -	err =3D __f2fs_ioc_setflags(inode, flags);
 +	err =3D f2fs_setflags_common(inode, iflags,
 +			f2fs_xflags_to_iflags(F2FS_SUPPORTED_XFLAGS));
  	if (err)
  		goto out;
 =20

--Sig_/WHgTUq_CIxHe8Gi/4qnrMHz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0ZXHsACgkQAVBC80lX
0GxP6gf+Pl8lwcBYH5ii6HdOz1bH6Ls00UO1G40zosKUfIRsQGgy086i+AS7C03a
K6V0FA2ltt3FJFXi3st5jgGgEiuyqsVU5TCOmr4p0izz58IX59LVXOcf90MqEZN8
md1iBOSmuIJyJ0/j3LrUV1d9xr8bj/vEgzI1HKLJy4LKzRyVx4fmHR4ooYMlQyCc
HpNPF/4PiH4BHkZckOysU7gZ6TRIEcA2PWQHleIFxepU2SjsZ9YdtTISGqe9PRUY
nh4l9d3+hQYIUBgg9F5LiuJEfJdWIuBkOAHQrYXJMDKkaPr9c7k3cwaLkD15rSYg
AZQPzhJ5GrKBmB6azd3xy6KyC3nbiQ==
=rEt8
-----END PGP SIGNATURE-----

--Sig_/WHgTUq_CIxHe8Gi/4qnrMHz--
