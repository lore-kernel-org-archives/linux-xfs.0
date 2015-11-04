Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 23D157FB5
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 20:03:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D319A30404E
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 18:03:37 -0800 (PST)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
	[209.85.220.47]) by cuda.sgi.com with ESMTP id DAnWOjOL6f6X42xI
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Nov 2015 18:03:31 -0800 (PST)
Received: by pacdm15 with SMTP id dm15so11760584pac.3
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 18:03:31 -0800 (PST)
Subject: Re: [PATCH v13 12/51] vfs: Cache richacl in struct inode
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446563847-14005-13-git-send-email-agruenba@redhat.com>
Date: Tue, 3 Nov 2015 19:03:00 -0700
Message-Id: <713E53A4-D073-4745-B57D-77AD07E89957@dilger.ca>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-13-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5196607310400460792=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>


--===============5196607310400460792==
Content-Type: multipart/signed; boundary="Apple-Mail=_474FF3DA-AE9A-4839-BD4D-6C5C84BF4FC5"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_474FF3DA-AE9A-4839-BD4D-6C5C84BF4FC5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 3, 2015, at 8:16 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> Cache richacls in struct inode so that this doesn't have to be done
> individually in each filesystem.  This is similar to POSIX ACLs.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
> fs/inode.c              | 11 ++++++--
> fs/posix_acl.c          |  2 +-
> fs/richacl_base.c       |  4 +--
> fs/richacl_inode.c      | 75 =
+++++++++++++++++++++++++++++++++++++++++++++++++
> include/linux/fs.h      |  5 +++-
> include/linux/richacl.h | 15 ++++++----
> 6 files changed, 100 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/inode.c b/fs/inode.c
> index 2a387f4..8462ddb 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -174,8 +174,11 @@ int inode_init_always(struct super_block *sb, =
struct inode *inode)
> 	inode->i_private =3D NULL;
> 	inode->i_mapping =3D mapping;
> 	INIT_HLIST_HEAD(&inode->i_dentry);	/* buggered by rcu =
freeing */
> -#ifdef CONFIG_FS_POSIX_ACL
> -	inode->i_acl =3D inode->i_default_acl =3D ACL_NOT_CACHED;
> +#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
> +	inode->i_acl =3D ACL_NOT_CACHED;
> +# if defined(CONFIG_FS_POSIX_ACL)
> +	inode->i_default_acl =3D ACL_NOT_CACHED;
> +# endif
> #endif
>=20
> #ifdef CONFIG_FSNOTIFY
> @@ -231,11 +234,13 @@ void __destroy_inode(struct inode *inode)
> 		atomic_long_dec(&inode->i_sb->s_remove_count);
> 	}
>=20
> -#ifdef CONFIG_FS_POSIX_ACL
> +#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
> 	if (inode->i_acl && inode->i_acl !=3D ACL_NOT_CACHED)
> 		put_base_acl(inode->i_acl);
> +# if defined(CONFIG_FS_POSIX_ACL)
> 	if (inode->i_default_acl && inode->i_default_acl !=3D =
ACL_NOT_CACHED)
> 		put_base_acl(inode->i_default_acl);
> +# endif
> #endif
> 	this_cpu_dec(nr_inodes);
> }
> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index b3b2265..1d766a5 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c
> @@ -38,7 +38,7 @@ struct posix_acl *get_cached_acl(struct inode =
*inode, int type)
> {
> 	struct posix_acl **p =3D acl_by_type(inode, type);
> 	struct posix_acl *acl =3D ACCESS_ONCE(*p);
> -	if (acl) {
> +	if (acl && IS_POSIXACL(inode)) {
> 		spin_lock(&inode->i_lock);
> 		acl =3D *p;
> 		if (acl !=3D ACL_NOT_CACHED)
> diff --git a/fs/richacl_base.c b/fs/richacl_base.c
> index 69b806c..d0ab5e9 100644
> --- a/fs/richacl_base.c
> +++ b/fs/richacl_base.c
> @@ -33,7 +33,7 @@ richacl_alloc(int count, gfp_t gfp)
> 	struct richacl *acl =3D kzalloc(size, gfp);
>=20
> 	if (acl) {
> -		atomic_set(&acl->a_refcount, 1);
> +		atomic_set(&acl->a_base.ba_refcount, 1);
> 		acl->a_count =3D count;
> 	}
> 	return acl;
> @@ -52,7 +52,7 @@ richacl_clone(const struct richacl *acl, gfp_t gfp)
>=20
> 	if (dup) {
> 		memcpy(dup, acl, size);
> -		atomic_set(&dup->a_refcount, 1);
> +		atomic_set(&dup->a_base.ba_refcount, 1);

These two calls should be base_acl_init().  There isn't any point to =
have
an abstraction that is only used by the posix_acl* code and not the =
richacl
code, as it will just result in richacl breaking in the future if/when =
the
abstraction is changed.

> 	}
> 	return dup;
> }
> diff --git a/fs/richacl_inode.c b/fs/richacl_inode.c
> index 99b3c93..c41a6c4 100644
> --- a/fs/richacl_inode.c
> +++ b/fs/richacl_inode.c
> @@ -20,6 +20,81 @@
> #include <linux/slab.h>
> #include <linux/richacl.h>
>=20
> +struct richacl *get_cached_richacl(struct inode *inode)
> +{
> +	struct richacl *acl;
> +
> +	acl =3D (struct richacl *)ACCESS_ONCE(inode->i_acl);
> +	if (acl && IS_RICHACL(inode)) {
> +		spin_lock(&inode->i_lock);
> +		acl =3D (struct richacl *)inode->i_acl;
> +		if (acl !=3D ACL_NOT_CACHED)
> +			acl =3D richacl_get(acl);
> +		spin_unlock(&inode->i_lock);
> +	}
> +	return acl;
> +}
> +EXPORT_SYMBOL_GPL(get_cached_richacl);
> +
> +struct richacl *get_cached_richacl_rcu(struct inode *inode)
> +{
> +	return (struct richacl *)rcu_dereference(inode->i_acl);
> +}
> +EXPORT_SYMBOL_GPL(get_cached_richacl_rcu);
> +
> +void set_cached_richacl(struct inode *inode, struct richacl *acl)
> +{
> +	struct base_acl *old =3D NULL;
> +
> +	spin_lock(&inode->i_lock);
> +	old =3D inode->i_acl;
> +	rcu_assign_pointer(inode->i_acl, &richacl_get(acl)->a_base);
> +	spin_unlock(&inode->i_lock);
> +	if (old !=3D ACL_NOT_CACHED)
> +		put_base_acl(old);
> +}
> +EXPORT_SYMBOL_GPL(set_cached_richacl);
> +
> +void forget_cached_richacl(struct inode *inode)
> +{
> +	struct base_acl *old =3D NULL;
> +
> +	spin_lock(&inode->i_lock);
> +	old =3D inode->i_acl;
> +	inode->i_acl =3D ACL_NOT_CACHED;
> +	spin_unlock(&inode->i_lock);
> +	if (old !=3D ACL_NOT_CACHED)
> +		put_base_acl(old);
> +}
> +EXPORT_SYMBOL_GPL(forget_cached_richacl);
> +
> +struct richacl *get_richacl(struct inode *inode)
> +{
> +	struct richacl *acl;
> +
> +	acl =3D get_cached_richacl(inode);
> +	if (acl !=3D ACL_NOT_CACHED)
> +		return acl;
> +
> +	if (!IS_RICHACL(inode))
> +		return NULL;
> +
> +	/*
> +	 * A filesystem can force a ACL callback by just never filling =
the
> +	 * ACL cache. But normally you'd fill the cache either at inode
> +	 * instantiation time, or on the first ->get_richacl call.
> +	 *
> +	 * If the filesystem doesn't have a get_richacl() function at =
all,
> +	 * we'll just create the negative cache entry.
> +	 */
> +	if (!inode->i_op->get_richacl) {
> +		set_cached_richacl(inode, NULL);
> +		return NULL;
> +	}
> +	return inode->i_op->get_richacl(inode);
> +}
> +EXPORT_SYMBOL_GPL(get_richacl);
> +
> /**
>  * richacl_permission  -  richacl permission check algorithm
>  * @inode:	inode to check
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 08fde42..d91deef 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -583,6 +583,7 @@ struct base_acl {
> 	};
> };
> struct posix_acl;
> +struct richacl;
> #define ACL_NOT_CACHED ((void *)(-1))
>=20
> #define IOP_FASTPERM	0x0001
> @@ -601,9 +602,11 @@ struct inode {
> 	kgid_t			i_gid;
> 	unsigned int		i_flags;
>=20
> -#if defined(CONFIG_FS_POSIX_ACL)
> +#if defined(CONFIG_FS_POSIX_ACL) || defined(CONFIG_FS_RICHACL)
> 	struct base_acl		*i_acl;
> +# if defined(CONFIG_FS_POSIX_ACL)
> 	struct base_acl		*i_default_acl;
> +# endif
> #endif
>=20
> 	const struct inode_operations	*i_op;
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index 2baef35..de7d0d9 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -31,7 +31,7 @@ struct richace {
> };
>=20
> struct richacl {
> -	atomic_t	a_refcount;
> +	struct base_acl	a_base;
> 	unsigned int	a_owner_mask;
> 	unsigned int	a_group_mask;
> 	unsigned int	a_other_mask;

This should be in the previous patch where this wrapper is introduced.

> @@ -56,8 +56,7 @@ struct richacl {
> static inline struct richacl *
> richacl_get(struct richacl *acl)
> {
> -	if (acl)
> -		atomic_inc(&acl->a_base.ba_refcount);
> +	get_base_acl(&acl->a_base);

Same.

> 	return acl;
> }
>=20
> @@ -67,10 +66,16 @@ richacl_get(struct richacl *acl)
> static inline void
> richacl_put(struct richacl *acl)
> {
> -	if (acl && atomic_dec_and_test(&acl->a_refcount))
> -		kfree(acl);
> +	BUILD_BUG_ON(offsetof(struct richacl, a_base) !=3D 0);
> +	put_base_acl(&acl->a_base);

Same.

> }
>=20
> +extern struct richacl *get_cached_richacl(struct inode *);
> +extern struct richacl *get_cached_richacl_rcu(struct inode *);
> +extern void set_cached_richacl(struct inode *, struct richacl *);
> +extern void forget_cached_richacl(struct inode *);
> +extern struct richacl *get_richacl(struct inode *);
> +
> /**
>  * richace_is_owner  -  check if @ace is an OWNER@ entry
>  */
> --
> 2.5.0
>=20


Cheers, Andreas






--Apple-Mail=_474FF3DA-AE9A-4839-BD4D-6C5C84BF4FC5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVjlnVXKl2rkXzB/gAQgEKA//RqcPKXSvCfn2MOB6U7GOLw0TgGhL/6Ov
HZA/tBbA0rFB6+6faaPw0mHy6pkSQjqQsxzHubTXbKnh5PQBGx4ncvPNU8TrpJtJ
wPJXlD6OOT4mi6SUitptMg/tBdrUC6wLO/LWFXZ6abAGn+D6mlueD16QFJx3eRuj
JEDHAMH5RL6H8dWOIn3MVt3AuEOeiCcUKqL5OE1CLqgHmNKMsBETBPoCDnEv14gd
ZES0SRl3q8Q0yZoUkiPIu7f/nRWSjqcUiv4ZNDhoeSlKgDkO0+Wuh5dKVhbdqCEE
u6rf2/oDdlvte2dwD3uj6k6eZJsTmYqUHeqBUHc0X/a8ec8WwT6bxZhy+Dul8CC5
x/LOmZoVzIdXLgtI4yXr/BjnVD0UJWZeqv1ag8rpe2U66Jz006fmyD8RP6DHwWu1
TDwexZ3cZwNS0eb15Y2Q4KPM1TOgQruQDmWnvQgZTwpK2bYM0vew/F88xQ9S8iZu
1XToZpi9uADaGvqTEFW3fieAl8Zq4r+z/luEW1InsBKjpqwkb5MpvpaLxZ7u4/2L
w0q1FDe02Eez46s3maz24VOK/XD+8jC1ylcBSvHEGjJ3wouyhrN8qsik9xYOGIMa
7ThoKPKr1IDTI+czAsPWDVIV+Koqi6uYt884kubYCrZ//RU4P+F/QU70Z7JYeXx4
nhgOtb1WssQ=
=c/dU
-----END PGP SIGNATURE-----

--Apple-Mail=_474FF3DA-AE9A-4839-BD4D-6C5C84BF4FC5--


--===============5196607310400460792==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5196607310400460792==--
