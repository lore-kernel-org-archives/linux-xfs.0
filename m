Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C80757FB7
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 20:13:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 841F38F8040
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 18:13:23 -0800 (PST)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id H4fb9KROwDaJA9Mo
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Nov 2015 18:13:20 -0800 (PST)
Received: by pacdm15 with SMTP id dm15so12027162pac.3
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 18:13:19 -0800 (PST)
Subject: Re: [PATCH v13 20/51] ext4: Add richacl support
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446563847-14005-21-git-send-email-agruenba@redhat.com>
Date: Tue, 3 Nov 2015 19:13:07 -0700
Message-Id: <6A710DA3-0B03-4371-A1EB-7AF39F684EDC@dilger.ca>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-21-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1765466717201547145=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>


--===============1765466717201547145==
Content-Type: multipart/signed; boundary="Apple-Mail=_59126A52-FAF0-4DF2-B107-A9EE09A9B3C7"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_59126A52-FAF0-4DF2-B107-A9EE09A9B3C7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 3, 2015, at 8:16 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>=20
> Support the richacl permission model in ext4.  The richacls are stored
> in "system.richacl" xattrs.  Richacls need to be enabled by tune2fs or
> at file system create time.

Patch looks reasonable.  One minor cleanup below that could be fixed =
when
the patch series is refreshed, and you can add:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
> fs/ext4/Kconfig   |  11 +++++
> fs/ext4/Makefile  |   1 +
> fs/ext4/file.c    |   3 ++
> fs/ext4/ialloc.c  |  11 ++++-
> fs/ext4/inode.c   |  12 ++++-
> fs/ext4/namei.c   |   5 ++
> fs/ext4/richacl.c | 141 =
++++++++++++++++++++++++++++++++++++++++++++++++++++++
> fs/ext4/richacl.h |  40 ++++++++++++++++
> fs/ext4/xattr.c   |   7 +++
> 9 files changed, 228 insertions(+), 3 deletions(-)
> create mode 100644 fs/ext4/richacl.c
> create mode 100644 fs/ext4/richacl.h
>=20
> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> index b46e9fc..65c5230 100644
> --- a/fs/ext4/Kconfig
> +++ b/fs/ext4/Kconfig
> @@ -22,6 +22,17 @@ config EXT3_FS_POSIX_ACL
> 	  This config option is here only for backward compatibility. =
ext3
> 	  filesystem is now handled by the ext4 driver.
>=20
> +config EXT4_FS_RICHACL
> +	bool "Ext4 Rich Access Control Lists (EXPERIMENTAL)"
> +	depends on EXT4_FS
> +	select FS_RICHACL
> +	help
> +	  Richacls are an implementation of NFSv4 ACLs, extended by file =
masks
> +	  to cleanly integrate into the POSIX file permission model.  To =
learn
> +	  more about them, see http://www.bestbits.at/richacl/.
> +
> +	  If you don't know what Richacls are, say N.
> +
> config EXT3_FS_SECURITY
> 	bool "Ext3 Security Labels"
> 	depends on EXT3_FS
> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
> index 75285ea..ea0d539 100644
> --- a/fs/ext4/Makefile
> +++ b/fs/ext4/Makefile
> @@ -14,3 +14,4 @@ ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+=3D acl.o
> ext4-$(CONFIG_EXT4_FS_SECURITY)		+=3D xattr_security.o
> ext4-$(CONFIG_EXT4_FS_ENCRYPTION)	+=3D crypto_policy.o crypto.o \
> 		crypto_key.o crypto_fname.o
> +ext4-$(CONFIG_EXT4_FS_RICHACL) 		+=3D richacl.o
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 113837e..a03b4a5 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -30,6 +30,7 @@
> #include "ext4_jbd2.h"
> #include "xattr.h"
> #include "acl.h"
> +#include "richacl.h"
>=20
> /*
>  * Called when an inode is released. Note that this is different
> @@ -719,6 +720,8 @@ const struct inode_operations =
ext4_file_inode_operations =3D {
> 	.removexattr	=3D generic_removexattr,
> 	.get_acl	=3D ext4_get_acl,
> 	.set_acl	=3D ext4_set_acl,
> +	.get_richacl	=3D ext4_get_richacl,
> +	.set_richacl	=3D ext4_set_richacl,
> 	.fiemap		=3D ext4_fiemap,
> };
>=20
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 619bfc1..9657b3a 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -27,6 +27,7 @@
> #include "ext4_jbd2.h"
> #include "xattr.h"
> #include "acl.h"
> +#include "richacl.h"
>=20
> #include <trace/events/ext4.h>
>=20
> @@ -697,6 +698,14 @@ out:
> 	return ret;
> }
>=20
> +static inline int
> +ext4_new_acl(handle_t *handle, struct inode *inode, struct inode =
*dir)
> +{
> +	if (IS_RICHACL(dir))
> +		return ext4_init_richacl(handle, inode, dir);
> +	return ext4_init_acl(handle, inode, dir);
> +}
> +
> /*
>  * There are two policies for allocating an inode.  If the new inode =
is
>  * a directory, then a forward search is made for a block group with =
both
> @@ -1052,7 +1061,7 @@ got:
> 	if (err)
> 		goto fail_drop;
>=20
> -	err =3D ext4_init_acl(handle, inode, dir);
> +	err =3D ext4_new_acl(handle, inode, dir);
> 	if (err)
> 		goto fail_free_drop;
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 612fbcf..647f3c3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -42,6 +42,7 @@
> #include "xattr.h"
> #include "acl.h"
> #include "truncate.h"
> +#include "richacl.h"
>=20
> #include <trace/events/ext4.h>
>=20
> @@ -4638,6 +4639,14 @@ static void =
ext4_wait_for_tail_page_commit(struct inode *inode)
> 	}
> }
>=20
> +static inline int
> +ext4_acl_chmod(struct inode *inode, umode_t mode)
> +{
> +	if (IS_RICHACL(inode))
> +		return richacl_chmod(inode, inode->i_mode);
> +	return posix_acl_chmod(inode, inode->i_mode);
> +}
> +
> /*
>  * ext4_setattr()
>  *
> @@ -4806,8 +4815,7 @@ int ext4_setattr(struct dentry *dentry, struct =
iattr *attr)
> 		ext4_orphan_del(NULL, inode);
>=20
> 	if (!rc && (ia_valid & ATTR_MODE))
> -		rc =3D posix_acl_chmod(inode, inode->i_mode);
> -
> +		rc =3D ext4_acl_chmod(inode, inode->i_mode);
> err_out:
> 	ext4_std_error(inode->i_sb, error);
> 	if (!error)
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 9f61e76..9b6e8b9 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -38,6 +38,7 @@
>=20
> #include "xattr.h"
> #include "acl.h"
> +#include "richacl.h"
>=20
> #include <trace/events/ext4.h>
> /*
> @@ -3854,6 +3855,8 @@ const struct inode_operations =
ext4_dir_inode_operations =3D {
> 	.removexattr	=3D generic_removexattr,
> 	.get_acl	=3D ext4_get_acl,
> 	.set_acl	=3D ext4_set_acl,
> +	.get_richacl	=3D ext4_get_richacl,
> +	.set_richacl	=3D ext4_set_richacl,
> 	.fiemap         =3D ext4_fiemap,
> };
>=20
> @@ -3865,4 +3868,6 @@ const struct inode_operations =
ext4_special_inode_operations =3D {
> 	.removexattr	=3D generic_removexattr,
> 	.get_acl	=3D ext4_get_acl,
> 	.set_acl	=3D ext4_set_acl,
> +	.get_richacl	=3D ext4_get_richacl,
> +	.set_richacl	=3D ext4_set_richacl,
> };
> diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
> new file mode 100644
> index 0000000..906d048
> --- /dev/null
> +++ b/fs/ext4/richacl.c
> @@ -0,0 +1,141 @@
> +/*
> + * Copyright IBM Corporation, 2010
> + * Copyright (C) 2015  Red Hat, Inc.
> + * Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>,
> + * 	   Andreas Gruenbacher <agruenba@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or =
modify it
> + * under the terms of version 2.1 of the GNU Lesser General Public =
License
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful, =
but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/fs.h>
> +#include <linux/richacl_xattr.h>
> +
> +#include "ext4.h"
> +#include "ext4_jbd2.h"
> +#include "xattr.h"
> +#include "acl.h"
> +#include "richacl.h"
> +
> +struct richacl *
> +ext4_get_richacl(struct inode *inode)
> +{
> +	const int name_index =3D EXT4_XATTR_INDEX_RICHACL;
> +	void *value =3D NULL;
> +	struct richacl *acl =3D NULL;
> +	int retval;
> +
> +	retval =3D ext4_xattr_get(inode, name_index, "", NULL, 0);
> +	if (retval > 0) {
> +		value =3D kmalloc(retval, GFP_NOFS);
> +		if (!value)
> +			return ERR_PTR(-ENOMEM);
> +		retval =3D ext4_xattr_get(inode, name_index, "", value, =
retval);
> +	}
> +	if (retval > 0) {
> +		acl =3D richacl_from_xattr(&init_user_ns, value, =
retval);
> +		if (acl =3D=3D ERR_PTR(-EINVAL))
> +			acl =3D ERR_PTR(-EIO);
> +	} else if (retval !=3D -ENODATA && retval !=3D -ENOSYS)
> +		acl =3D ERR_PTR(retval);

(style) Typically, the braces on if/else blocks are kept matching.

> +	kfree(value);
> +
> +	if (!IS_ERR(acl))
> +		set_cached_richacl(inode, acl);
> +
> +	return acl;
> +}
> +
> +static int
> +__ext4_remove_richacl(handle_t *handle, struct inode *inode)
> +{
> +	const int name_index =3D EXT4_XATTR_INDEX_RICHACL;
> +	int retval;
> +
> +	retval =3D ext4_xattr_set_handle(handle, inode, name_index, "",
> +				       NULL, 0, 0);
> +	if (!retval)
> +		set_cached_richacl(inode, NULL);
> +	return retval;
> +}
> +
> +static int
> +__ext4_set_richacl(handle_t *handle, struct inode *inode, struct =
richacl *acl)
> +{
> +	const int name_index =3D EXT4_XATTR_INDEX_RICHACL;
> +	umode_t mode =3D inode->i_mode;
> +	int retval, size;
> +	void *value;
> +
> +	if (richacl_equiv_mode(acl, &mode) =3D=3D 0) {
> +		inode->i_ctime =3D ext4_current_time(inode);
> +		inode->i_mode =3D mode;
> +		ext4_mark_inode_dirty(handle, inode);
> +		return __ext4_remove_richacl(handle, inode);
> +	}
> +
> +	mode &=3D ~S_IRWXUGO;
> +	mode |=3D richacl_masks_to_mode(acl);
> +
> +	size =3D richacl_xattr_size(acl);
> +	value =3D kmalloc(size, GFP_NOFS);
> +	if (!value)
> +		return -ENOMEM;
> +	richacl_to_xattr(&init_user_ns, acl, value, size);
> +	inode->i_mode =3D mode;
> +	retval =3D ext4_xattr_set_handle(handle, inode, name_index, "",
> +				       value, size, 0);
> +	kfree(value);
> +	if (retval)
> +		return retval;
> +
> +	set_cached_richacl(inode, acl);
> +
> +	return 0;
> +}
> +
> +int
> +ext4_set_richacl(struct inode *inode, struct richacl *acl)
> +{
> +	handle_t *handle;
> +	int retval, retries =3D 0;
> +
> +retry:
> +	handle =3D ext4_journal_start(inode, EXT4_HT_XATTR,
> +				    ext4_jbd2_credits_xattr(inode));
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
> +	if (acl)
> +		retval =3D __ext4_set_richacl(handle, inode, acl);
> +	else
> +		retval =3D __ext4_remove_richacl(handle, inode);
> +
> +	ext4_journal_stop(handle);
> +	if (retval =3D=3D -ENOSPC && =
ext4_should_retry_alloc(inode->i_sb, &retries))
> +		goto retry;
> +	return retval;
> +}
> +
> +int
> +ext4_init_richacl(handle_t *handle, struct inode *inode, struct inode =
*dir)
> +{
> +	struct richacl *acl =3D richacl_create(&inode->i_mode, dir);
> +	int error;
> +
> +	error =3D PTR_ERR(acl);
> +	if (IS_ERR(acl))
> +		return error;
> +	if (acl) {
> +		error =3D __ext4_set_richacl(handle, inode, acl);
> +		richacl_put(acl);
> +	}
> +	return error;
> +}
> diff --git a/fs/ext4/richacl.h b/fs/ext4/richacl.h
> new file mode 100644
> index 0000000..6fe9a92
> --- /dev/null
> +++ b/fs/ext4/richacl.h
> @@ -0,0 +1,40 @@
> +/*
> + * Copyright IBM Corporation, 2010
> + * Copyright (C)  2015 Red Hat, Inc.
> + * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or =
modify it
> + * under the terms of version 2.1 of the GNU Lesser General Public =
License
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful, =
but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> + *
> + */
> +
> +#ifndef __FS_EXT4_RICHACL_H
> +#define __FS_EXT4_RICHACL_H
> +
> +#include <linux/richacl.h>
> +
> +#ifdef CONFIG_EXT4_FS_RICHACL
> +
> +extern struct richacl *ext4_get_richacl(struct inode *);
> +extern int ext4_set_richacl(struct inode *, struct richacl *);
> +
> +extern int ext4_init_richacl(handle_t *, struct inode *, struct inode =
*);
> +
> +#else  /* CONFIG_EXT4_FS_RICHACL */
> +
> +#define ext4_get_richacl NULL
> +#define ext4_set_richacl NULL
> +
> +static inline int
> +ext4_init_richacl(handle_t *handle, struct inode *inode, struct inode =
*dir)
> +{
> +	return 0;
> +}
> +
> +#endif  /* CONFIG_EXT4_FS_RICHACL */
> +#endif  /* __FS_EXT4_RICHACL_H */
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 16e28c0..4d79adb 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -55,6 +55,7 @@
> #include <linux/slab.h>
> #include <linux/mbcache.h>
> #include <linux/quotaops.h>
> +#include <linux/richacl_xattr.h>
> #include "ext4_jbd2.h"
> #include "ext4.h"
> #include "xattr.h"
> @@ -99,6 +100,9 @@ static const struct xattr_handler =
*ext4_xattr_handler_map[] =3D {
> #ifdef CONFIG_EXT4_FS_SECURITY
> 	[EXT4_XATTR_INDEX_SECURITY]	     =3D =
&ext4_xattr_security_handler,
> #endif
> +#ifdef CONFIG_EXT4_FS_RICHACL
> +	[EXT4_XATTR_INDEX_RICHACL]           =3D &richacl_xattr_handler,
> +#endif
> };
>=20
> const struct xattr_handler *ext4_xattr_handlers[] =3D {
> @@ -111,6 +115,9 @@ const struct xattr_handler *ext4_xattr_handlers[] =
=3D {
> #ifdef CONFIG_EXT4_FS_SECURITY
> 	&ext4_xattr_security_handler,
> #endif
> +#ifdef CONFIG_EXT4_FS_RICHACL
> +	&richacl_xattr_handler,
> +#endif
> 	NULL
> };
>=20
> --
> 2.5.0
>=20


Cheers, Andreas






--Apple-Mail=_59126A52-FAF0-4DF2-B107-A9EE09A9B3C7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVjlptHKl2rkXzB/gAQgjChAAkKzLoa4Jxvskyv0w9logUqsDIjZpujRv
iH6EM3NEMZ5WWDESmwJHdJJ8iC3hThdex6borwxYKs3WPIXQYp1USHu3F5f/nl3x
+wpmGjSetBnde/Mg4V7FUXI4Q+ClWyOn+Q55eHQ6xrDyT+9pEDr9Iy9mSnZPLKzL
KBl/s/dOdhfdYyAcjMCLkFXBKeBrMgxvD5VyIbX1/uYQglLEwIVkwvgfAS2zKaSO
Sfb8qzYykd8VaLdAPEHCeT0MgaRrCfBqDGPe29pAfm5YNkFpSQcckHwkrx6H1Bkc
b4wO41mNejOZrkYdNF/5wiQWhSYuBwkL/v0MmanP0S/l/ilHrgDYZ+cFS9hSMY7K
35wbbWiq72QbAq0eEOH7f34UcBGTYdi4alrML0cDcSDyOJVgWMFulyVYvCx2Mb5S
IY/WWTK9PnWdpbt168KZahtbrvhF7ds97/8wZ8cj8gcD9kWUsCuzZVGVEmqiHaAy
Jp9cduKmhwxh8JXAlpi0sHJ0Ybf+W022zlDeAVJW4lKNdhsehyIJh1ZJU4yRVnyz
4FE1aCC4eQBZhTi4BAppco2lo+RLRmQa7H8od4fjzcJNYDFqiU8YbXJlgaDZ2BYu
obw9NBUpIOQLPClZPWfkW95zueQzeVf+1cPYu8Q7jNP5cVphT/dAq6h/jbg9DmWS
8LYQyQqr3NE=
=egkX
-----END PGP SIGNATURE-----

--Apple-Mail=_59126A52-FAF0-4DF2-B107-A9EE09A9B3C7--


--===============1765466717201547145==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1765466717201547145==--
