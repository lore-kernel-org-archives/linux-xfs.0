Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 29EA47F5A
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 02:04:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 03924304039
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 00:04:48 -0800 (PST)
Received: from mail-pa0-f54.google.com (mail-pa0-f54.google.com
	[209.85.220.54]) by cuda.sgi.com with ESMTP id CAf5jJcLU0aeA6Xk
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Nov 2015 00:04:42 -0800 (PST)
Received: by pacdm15 with SMTP id dm15so142099855pac.3
	for <xfs@oss.sgi.com>; Sun, 08 Nov 2015 00:04:41 -0800 (PST)
Subject: Re: [PATCH v14 11/22] vfs: Cache base_acl objects in inodes
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446723580-3747-12-git-send-email-agruenba@redhat.com>
Date: Sun, 8 Nov 2015 01:06:00 -0700
Message-Id: <E0B14B78-0883-4F26-AE29-0FD737F5E83F@dilger.ca>
References: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
	<1446723580-3747-12-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6021738364067755902=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>


--===============6021738364067755902==
Content-Type: multipart/signed; boundary="Apple-Mail=_65082315-236F-444B-A9A2-6BE991F8EF14"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_65082315-236F-444B-A9A2-6BE991F8EF14
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 5, 2015, at 4:39 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> POSIX ACLs and richacls are both objects allocated by kmalloc() with a
> reference count which are freed by kfree_rcu().  An inode can either
> cache an access and a default POSIX ACL, or a richacl (richacls do not
> have default acls).  To allow an inode to cache either of the two =
kinds
> of acls, introduce a new base_acl type and convert i_acl and
> i_default_acl to that type. In most cases, the vfs then doesn't care =
which
> kind of acl an inode caches (if any).
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> drivers/staging/lustre/lustre/llite/llite_lib.c |  2 +-
> fs/f2fs/acl.c                                   |  4 +--
> fs/inode.c                                      |  4 +--
> fs/jffs2/acl.c                                  | 10 ++++--
> fs/posix_acl.c                                  | 41 =
+++++++++++++------------
> fs/richacl_base.c                               |  4 +--
> include/linux/fs.h                              | 34 =
++++++++++++++++++--
> include/linux/posix_acl.h                       | 12 +++-----
> include/linux/richacl.h                         |  9 +++---
> 9 files changed, 75 insertions(+), 45 deletions(-)
>=20
> diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c =
b/drivers/staging/lustre/lustre/llite/llite_lib.c
> index b4ed6c8..46912c2 100644
> --- a/drivers/staging/lustre/lustre/llite/llite_lib.c
> +++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
> @@ -1118,7 +1118,7 @@ void ll_clear_inode(struct inode *inode)
> 	}
> #ifdef CONFIG_FS_POSIX_ACL
> 	else if (lli->lli_posix_acl) {
> -		LASSERT(atomic_read(&lli->lli_posix_acl->a_refcount) =3D=3D=
 1);
> +		LASSERT(base_acl_refcount(&lli->lli_posix_acl->a_base) =
=3D=3D 1);
> 		LASSERT(lli->lli_remote_perms =3D=3D NULL);
> 		posix_acl_release(lli->lli_posix_acl);
> 		lli->lli_posix_acl =3D NULL;
> diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
> index c8f25f7..9646197 100644
> --- a/fs/f2fs/acl.c
> +++ b/fs/f2fs/acl.c
> @@ -270,7 +270,7 @@ static struct posix_acl *f2fs_acl_clone(const =
struct posix_acl *acl,
> 				sizeof(struct posix_acl_entry);
> 		clone =3D kmemdup(acl, size, flags);
> 		if (clone)
> -			atomic_set(&clone->a_refcount, 1);
> +			base_acl_init(&clone->a_base);
> 	}
> 	return clone;
> }
> @@ -282,7 +282,7 @@ static int f2fs_acl_create_masq(struct posix_acl =
*acl, umode_t *mode_p)
> 	umode_t mode =3D *mode_p;
> 	int not_equiv =3D 0;
>=20
> -	/* assert(atomic_read(acl->a_refcount) =3D=3D 1); */
> +	/* assert(base_acl_refcount(&acl->a_base) =3D=3D 1); */
>=20
> 	FOREACH_ACL_ENTRY(pa, acl, pe) {
> 		switch(pa->e_tag) {
> diff --git a/fs/inode.c b/fs/inode.c
> index 78a17b8..5c46ae5 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -233,9 +233,9 @@ void __destroy_inode(struct inode *inode)
>=20
> #ifdef CONFIG_FS_POSIX_ACL
> 	if (inode->i_acl && inode->i_acl !=3D ACL_NOT_CACHED)
> -		posix_acl_release(inode->i_acl);
> +		base_acl_put(inode->i_acl);
> 	if (inode->i_default_acl && inode->i_default_acl !=3D =
ACL_NOT_CACHED)
> -		posix_acl_release(inode->i_default_acl);
> +		base_acl_put(inode->i_default_acl);
> #endif
> 	this_cpu_dec(nr_inodes);
> }
> diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
> index 2f7a3c0..569cb1b 100644
> --- a/fs/jffs2/acl.c
> +++ b/fs/jffs2/acl.c
> @@ -294,13 +294,19 @@ int jffs2_init_acl_post(struct inode *inode)
> 	int rc;
>=20
> 	if (inode->i_default_acl) {
> -		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT, =
inode->i_default_acl);
> +		struct posix_acl *default_acl =3D container_of(
> +			inode->i_default_acl, struct posix_acl, a_base);
> +
> +		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT, =
default_acl);
> 		if (rc)
> 			return rc;
> 	}
>=20
> 	if (inode->i_acl) {
> -		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_ACCESS, =
inode->i_acl);
> +		struct posix_acl *acl =3D container_of(
> +			inode->i_acl, struct posix_acl, a_base);
> +
> +		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_ACCESS, =
acl);
> 		if (rc)
> 			return rc;
> 	}
> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index aacfb58..4573315 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c
> @@ -21,7 +21,7 @@
> #include <linux/export.h>
> #include <linux/user_namespace.h>
>=20
> -static struct posix_acl **acl_by_type(struct inode *inode, int type)
> +static struct base_acl **acl_by_type(struct inode *inode, int type)
> {
> 	switch (type) {
> 	case ACL_TYPE_ACCESS:
> @@ -35,63 +35,64 @@ static struct posix_acl **acl_by_type(struct inode =
*inode, int type)
>=20
> struct posix_acl *get_cached_acl(struct inode *inode, int type)
> {
> -	struct posix_acl **p =3D acl_by_type(inode, type);
> -	struct posix_acl *acl =3D ACCESS_ONCE(*p);
> +	struct base_acl **p =3D acl_by_type(inode, type);
> +	struct base_acl *acl =3D ACCESS_ONCE(*p);
> 	if (acl) {
> 		spin_lock(&inode->i_lock);
> 		acl =3D *p;
> 		if (acl !=3D ACL_NOT_CACHED)
> -			acl =3D posix_acl_dup(acl);
> +			base_acl_get(acl);
> 		spin_unlock(&inode->i_lock);
> 	}
> -	return acl;
> +	return container_of(acl, struct posix_acl, a_base);
> }
> EXPORT_SYMBOL(get_cached_acl);
>=20
> struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type)
> {
> -	return rcu_dereference(*acl_by_type(inode, type));
> +	struct base_acl *acl =3D rcu_dereference(*acl_by_type(inode, =
type));
> +	return container_of(acl, struct posix_acl, a_base);
> }
> EXPORT_SYMBOL(get_cached_acl_rcu);
>=20
> void set_cached_acl(struct inode *inode, int type, struct posix_acl =
*acl)
> {
> -	struct posix_acl **p =3D acl_by_type(inode, type);
> -	struct posix_acl *old;
> +	struct base_acl **p =3D acl_by_type(inode, type);
> +	struct base_acl *old;
> 	spin_lock(&inode->i_lock);
> 	old =3D *p;
> -	rcu_assign_pointer(*p, posix_acl_dup(acl));
> +	rcu_assign_pointer(*p, &posix_acl_dup(acl)->a_base);
> 	spin_unlock(&inode->i_lock);
> 	if (old !=3D ACL_NOT_CACHED)
> -		posix_acl_release(old);
> +		base_acl_put(old);
> }
> EXPORT_SYMBOL(set_cached_acl);
>=20
> void forget_cached_acl(struct inode *inode, int type)
> {
> -	struct posix_acl **p =3D acl_by_type(inode, type);
> -	struct posix_acl *old;
> +	struct base_acl **p =3D acl_by_type(inode, type);
> +	struct base_acl *old;
> 	spin_lock(&inode->i_lock);
> 	old =3D *p;
> 	*p =3D ACL_NOT_CACHED;
> 	spin_unlock(&inode->i_lock);
> 	if (old !=3D ACL_NOT_CACHED)
> -		posix_acl_release(old);
> +		base_acl_put(old);
> }
> EXPORT_SYMBOL(forget_cached_acl);
>=20
> void forget_all_cached_acls(struct inode *inode)
> {
> -	struct posix_acl *old_access, *old_default;
> +	struct base_acl *old_access, *old_default;
> 	spin_lock(&inode->i_lock);
> 	old_access =3D inode->i_acl;
> 	old_default =3D inode->i_default_acl;
> 	inode->i_acl =3D inode->i_default_acl =3D ACL_NOT_CACHED;
> 	spin_unlock(&inode->i_lock);
> 	if (old_access !=3D ACL_NOT_CACHED)
> -		posix_acl_release(old_access);
> +		base_acl_put(old_access);
> 	if (old_default !=3D ACL_NOT_CACHED)
> -		posix_acl_release(old_default);
> +		base_acl_put(old_default);
> }
> EXPORT_SYMBOL(forget_all_cached_acls);
>=20
> @@ -128,7 +129,7 @@ EXPORT_SYMBOL(get_acl);
> void
> posix_acl_init(struct posix_acl *acl, int count)
> {
> -	atomic_set(&acl->a_refcount, 1);
> +	base_acl_init(&acl->a_base);
> 	acl->a_count =3D count;
> }
> EXPORT_SYMBOL(posix_acl_init);
> @@ -161,7 +162,7 @@ posix_acl_clone(const struct posix_acl *acl, gfp_t =
flags)
> 		           sizeof(struct posix_acl_entry);
> 		clone =3D kmemdup(acl, size, flags);
> 		if (clone)
> -			atomic_set(&clone->a_refcount, 1);
> +			base_acl_init(&clone->a_base);
> 	}
> 	return clone;
> }
> @@ -383,7 +384,7 @@ static int posix_acl_create_masq(struct posix_acl =
*acl, umode_t *mode_p)
> 	umode_t mode =3D *mode_p;
> 	int not_equiv =3D 0;
>=20
> -	/* assert(atomic_read(acl->a_refcount) =3D=3D 1); */
> +	/* assert(base_acl_refcount(&acl->a_base) =3D=3D 1); */
>=20
> 	FOREACH_ACL_ENTRY(pa, acl, pe) {
>                 switch(pa->e_tag) {
> @@ -438,7 +439,7 @@ static int __posix_acl_chmod_masq(struct posix_acl =
*acl, umode_t mode)
> 	struct posix_acl_entry *group_obj =3D NULL, *mask_obj =3D NULL;
> 	struct posix_acl_entry *pa, *pe;
>=20
> -	/* assert(atomic_read(acl->a_refcount) =3D=3D 1); */
> +	/* assert(base_acl_refcount(&acl->a_base) =3D=3D 1); */
>=20
> 	FOREACH_ACL_ENTRY(pa, acl, pe) {
> 		switch(pa->e_tag) {
> diff --git a/fs/richacl_base.c b/fs/richacl_base.c
> index 69b806c..5826842 100644
> --- a/fs/richacl_base.c
> +++ b/fs/richacl_base.c
> @@ -33,7 +33,7 @@ richacl_alloc(int count, gfp_t gfp)
> 	struct richacl *acl =3D kzalloc(size, gfp);
>=20
> 	if (acl) {
> -		atomic_set(&acl->a_refcount, 1);
> +		base_acl_init(&acl->a_base);
> 		acl->a_count =3D count;
> 	}
> 	return acl;
> @@ -52,7 +52,7 @@ richacl_clone(const struct richacl *acl, gfp_t gfp)
>=20
> 	if (dup) {
> 		memcpy(dup, acl, size);
> -		atomic_set(&dup->a_refcount, 1);
> +		base_acl_init(&dup->a_base);
> 	}
> 	return dup;
> }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index ba91a89..2fd840e 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -576,6 +576,12 @@ static inline void mapping_allow_writable(struct =
address_space *mapping)
> #define i_size_ordered_init(inode) do { } while (0)
> #endif
>=20
> +struct base_acl {
> +	union {
> +		atomic_t ba_refcount;
> +		struct rcu_head ba_rcu;
> +	};
> +};
> struct posix_acl;
> #define ACL_NOT_CACHED ((void *)(-1))
>=20
> @@ -595,9 +601,9 @@ struct inode {
> 	kgid_t			i_gid;
> 	unsigned int		i_flags;
>=20
> -#ifdef CONFIG_FS_POSIX_ACL
> -	struct posix_acl	*i_acl;
> -	struct posix_acl	*i_default_acl;
> +#if defined(CONFIG_FS_POSIX_ACL)
> +	struct base_acl		*i_acl;
> +	struct base_acl		*i_default_acl;
> #endif
>=20
> 	const struct inode_operations	*i_op;
> @@ -3059,4 +3065,26 @@ static inline bool dir_relax(struct inode =
*inode)
>=20
> extern bool path_noexec(const struct path *path);
>=20
> +static inline void base_acl_get(struct base_acl *acl)
> +{
> +	if (acl)
> +		atomic_inc(&acl->ba_refcount);
> +}
> +
> +static inline void base_acl_put(struct base_acl *acl)
> +{
> +	if (acl && atomic_dec_and_test(&acl->ba_refcount))
> +		kfree_rcu(acl, ba_rcu);
> +}
> +
> +static inline void base_acl_init(struct base_acl *acl)
> +{
> +	atomic_set(&acl->ba_refcount, 1);
> +}
> +
> +static inline int base_acl_refcount(struct base_acl *acl)
> +{
> +	return atomic_read(&acl->ba_refcount);
> +}
> +
> #endif /* _LINUX_FS_H */
> diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
> index 5b5a80c..cef5428 100644
> --- a/include/linux/posix_acl.h
> +++ b/include/linux/posix_acl.h
> @@ -43,10 +43,7 @@ struct posix_acl_entry {
> };
>=20
> struct posix_acl {
> -	union {
> -		atomic_t		a_refcount;
> -		struct rcu_head		a_rcu;
> -	};
> +	struct base_acl		a_base;  /* must be first, see =
posix_acl_release() */
> 	unsigned int		a_count;
> 	struct posix_acl_entry	a_entries[0];
> };
> @@ -61,8 +58,7 @@ struct posix_acl {
> static inline struct posix_acl *
> posix_acl_dup(struct posix_acl *acl)
> {
> -	if (acl)
> -		atomic_inc(&acl->a_refcount);
> +	base_acl_get(&acl->a_base);
> 	return acl;
> }
>=20
> @@ -72,8 +68,8 @@ posix_acl_dup(struct posix_acl *acl)
> static inline void
> posix_acl_release(struct posix_acl *acl)
> {
> -	if (acl && atomic_dec_and_test(&acl->a_refcount))
> -		kfree_rcu(acl, a_rcu);
> +	BUILD_BUG_ON(offsetof(struct posix_acl, a_base) !=3D 0);
> +	base_acl_put(&acl->a_base);
> }
>=20
>=20
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index 1d9f5f7..7628fad 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -31,7 +31,7 @@ struct richace {
> };
>=20
> struct richacl {
> -	atomic_t	a_refcount;
> +	struct base_acl	a_base;  /* must be first, see richacl_put() */
> 	unsigned int	a_owner_mask;
> 	unsigned int	a_group_mask;
> 	unsigned int	a_other_mask;
> @@ -56,8 +56,7 @@ struct richacl {
> static inline struct richacl *
> richacl_get(struct richacl *acl)
> {
> -	if (acl)
> -		atomic_inc(&acl->a_refcount);
> +	base_acl_get(&acl->a_base);
> 	return acl;
> }
>=20
> @@ -67,8 +66,8 @@ richacl_get(struct richacl *acl)
> static inline void
> richacl_put(struct richacl *acl)
> {
> -	if (acl && atomic_dec_and_test(&acl->a_refcount))
> -		kfree(acl);
> +	BUILD_BUG_ON(offsetof(struct richacl, a_base) !=3D 0);
> +	base_acl_put(&acl->a_base);
> }
>=20
> /**
> --
> 2.5.0
>=20


Cheers, Andreas






--Apple-Mail=_65082315-236F-444B-A9A2-6BE991F8EF14
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVj8CaXKl2rkXzB/gAQicpA/+OeitqZLCsqV1MSaRUFodjrabv/0fPIYu
oFqw7xAGQIO7PJr0x+GMswKFvz98QU3OUtXASkL1WfYNN/tl4ClCkhdzMblNS4u7
DjtovBMWWUZZTYQtHZm1CdCUmUDHODq6V3xGrn7jgQEK7WDtBu4CNn8TZHupqDb7
0IRcEuIcw9IDc04Fn2rDtYQ5REovfnX9/ar3MC8Gqi9JAtJTfsjN5XaJ0QD20lfq
zHpaToBgGAP3w5vVhL5EW0Y187PlvKoeMFXqK+iKNJ2Rbg39fBIWw1BWxAFhYQzU
8GaNwQLs2ZRuczy2P0xgixm40CMt04rD4Y2e5+XP04s0wHLtGAW2vWZ4wUjo/tyy
iZDlqEXwa1ngL5o2hkXmy3ouzkVGCzUN7OC0E7qe0Qn5MOmy57Ssye6xi9hsjGv9
f08sYGkZYAKVfITOHqD/WYzX4AFpkjidiLCYkoMkWGYHvOO4dE94MMuCl+RnOPTz
mAWIOg0rSvI3rYenfQt9xlnHJ2TpGeLrWu0EUmFw34r4YoqpsB9nbwf4uns/4F9i
X4KUKHCvvVDCks9SCLAjdo64YRT3grLtKcP+WF8L8UkJ8uCo8OZ7ksUAkoT75q8/
5utTjtJppag2yusjXBH5glH2tRo+GSzD9wQnYWYv4mVbImNkkQ7vSjUUSiX7v6Sq
gge7QatOl+4=
=vmAg
-----END PGP SIGNATURE-----

--Apple-Mail=_65082315-236F-444B-A9A2-6BE991F8EF14--


--===============6021738364067755902==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6021738364067755902==--
