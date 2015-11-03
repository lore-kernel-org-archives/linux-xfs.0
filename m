Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 21C1B7FB7
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 16:30:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6D06BAC002
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 14:30:02 -0800 (PST)
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com
	[209.85.220.46]) by cuda.sgi.com with ESMTP id kQWBXLxP46xXh1KJ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Nov 2015 14:29:58 -0800 (PST)
Received: by padhx2 with SMTP id hx2so22830523pad.1
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 14:29:57 -0800 (PST)
Subject: Re: [PATCH v13 10/51] vfs: Cache base_acl objects in inodes
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446563847-14005-11-git-send-email-agruenba@redhat.com>
Date: Tue, 3 Nov 2015 15:29:50 -0700
Message-Id: <D235953B-3EAF-4B00-AC07-4420B85E9E9E@dilger.ca>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-11-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1949083298119686516=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>


--===============1949083298119686516==
Content-Type: multipart/signed; boundary="Apple-Mail=_124A55A8-7810-46A6-8154-225356928F53"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_124A55A8-7810-46A6-8154-225356928F53
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 3, 2015, at 8:16 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> POSIX ACLs and richacls are both objects allocated by kmalloc() with a
> reference count which are freed by kfree_rcu().  An inode can either
> cache an access and a default POSIX ACL, or a richacl (richacls do not
> have default acls).  To allow an inode to cache either of the two =
kinds
> of acls, introduce a new base_acl type and convert i_acl and
> i_default_acl to that type. In most cases, the vfs then doesn't have =
to
> care which kind of acl an inode caches (if any).

For new wrapper functions like this better to name them as "NOUN_VERB" =
so
rather than "VERB_NOUN" so that related functions sort together, like
base_acl_init(), base_acl_get(), base_acl_put(), base_acl_refcount(), =
etc.

> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
> drivers/staging/lustre/lustre/llite/llite_lib.c |  2 +-
> fs/f2fs/acl.c                                   |  4 ++--
> fs/inode.c                                      |  4 ++--
> fs/jffs2/acl.c                                  |  6 ++++--
> fs/posix_acl.c                                  | 18 =
+++++++++---------
> include/linux/fs.h                              | 25 =
++++++++++++++++++++++---
> include/linux/posix_acl.h                       | 12 ++++--------
> include/linux/richacl.h                         |  2 +-
> 8 files changed, 45 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c =
b/drivers/staging/lustre/lustre/llite/llite_lib.c
> index b4ed6c8..5766f69 100644
> --- a/drivers/staging/lustre/lustre/llite/llite_lib.c
> +++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
> @@ -1118,7 +1118,7 @@ void ll_clear_inode(struct inode *inode)
> 	}
> #ifdef CONFIG_FS_POSIX_ACL
> 	else if (lli->lli_posix_acl) {
> -		LASSERT(atomic_read(&lli->lli_posix_acl->a_refcount) =3D=3D=
 1);
> +		=
LASSERT(atomic_read(&lli->lli_posix_acl->a_base.ba_refcount) =3D=3D 1);

It probably makes sense to have a wrapper for this, like =
base_acl_refcount()
so that the details are similarly abstracted from the callers, or there
isn't much benefit to having get_base_acl() and put_base_acl() at all.

> 		LASSERT(lli->lli_remote_perms =3D=3D NULL);
> 		posix_acl_release(lli->lli_posix_acl);
> 		lli->lli_posix_acl =3D NULL;
> diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
> index c8f25f7..a4207de 100644
> --- a/fs/f2fs/acl.c
> +++ b/fs/f2fs/acl.c
> @@ -270,7 +270,7 @@ static struct posix_acl *f2fs_acl_clone(const =
struct posix_acl *acl,
> 				sizeof(struct posix_acl_entry);
> 		clone =3D kmemdup(acl, size, flags);
> 		if (clone)
> -			atomic_set(&clone->a_refcount, 1);
> +			atomic_set(&clone->a_base.ba_refcount, 1);

This should be base_acl_init() since this should also reset the RCU =
state
if it was just copied from "acl" above.  That wouldn't be quite correct =
if
there are other fields added to struct base_acl that don't need to be
initialized when it is copied, so possibly base_acl_reinit() would be =
better
here and below if that will be the case in the near future (I haven't =
looked
through the whole patch series yet).

> 	}
> 	return clone;
> }
> @@ -282,7 +282,7 @@ static int f2fs_acl_create_masq(struct posix_acl =
*acl, umode_t *mode_p)
> 	umode_t mode =3D *mode_p;
> 	int not_equiv =3D 0;
>=20
> -	/* assert(atomic_read(acl->a_refcount) =3D=3D 1); */
> +	/* assert(atomic_read(acl->a_base.ba_refcount) =3D=3D 1); */

May as well make the comment use the base_acl_refcount() wrapper =
function too.

>=20
> 	FOREACH_ACL_ENTRY(pa, acl, pe) {
> 		switch(pa->e_tag) {
> diff --git a/fs/inode.c b/fs/inode.c
> index 78a17b8..2a387f4 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -233,9 +233,9 @@ void __destroy_inode(struct inode *inode)
>=20
> #ifdef CONFIG_FS_POSIX_ACL
> 	if (inode->i_acl && inode->i_acl !=3D ACL_NOT_CACHED)
> -		posix_acl_release(inode->i_acl);
> +		put_base_acl(inode->i_acl);
> 	if (inode->i_default_acl && inode->i_default_acl !=3D =
ACL_NOT_CACHED)
> -		posix_acl_release(inode->i_default_acl);
> +		put_base_acl(inode->i_default_acl);
> #endif
> 	this_cpu_dec(nr_inodes);
> }
> diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
> index 2f7a3c0..04a5836 100644
> --- a/fs/jffs2/acl.c
> +++ b/fs/jffs2/acl.c
> @@ -294,13 +294,15 @@ int jffs2_init_acl_post(struct inode *inode)
> 	int rc;
>=20
> 	if (inode->i_default_acl) {
> -		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT, =
inode->i_default_acl);
> +		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_DEFAULT,
> +				     *acl_by_type(inode, =
ACL_TYPE_DEFAULT));
> 		if (rc)
> 			return rc;
> 	}
>=20
> 	if (inode->i_acl) {
> -		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_ACCESS, =
inode->i_acl);
> +		rc =3D __jffs2_set_acl(inode, JFFS2_XPREFIX_ACL_ACCESS,
> +				     *acl_by_type(inode, =
ACL_TYPE_ACCESS));
> 		if (rc)
> 			return rc;
> 	}
> diff --git a/fs/posix_acl.c b/fs/posix_acl.c
> index 4fb17de..b3b2265 100644
> --- a/fs/posix_acl.c
> +++ b/fs/posix_acl.c
> @@ -25,9 +25,9 @@ struct posix_acl **acl_by_type(struct inode *inode, =
int type)
> {
> 	switch (type) {
> 	case ACL_TYPE_ACCESS:
> -		return &inode->i_acl;
> +		return (struct posix_acl **)&inode->i_acl;
> 	case ACL_TYPE_DEFAULT:
> -		return &inode->i_default_acl;
> +		return (struct posix_acl **)&inode->i_default_acl;

This would be better to use container_of() to unwrap struct base_acl =
from
struct posix_acl.  That avoids the hard requirement (which isn't =
documented
anywhere) that base_acl needs to be the first member of struct =
posix_acl.

I was originally going to write that you should add a comment that =
base_acl
needs to be the first member of both richacl and posix_acl, but =
container_of()
is both cleaner and safer.

Looking further down, that IS actually needed due to the way kfree is =
used on
the base_acl pointer, but using container_of() is still cleaner and =
safer
than directly casting double pointers (which some compilers and static
analysis tools will be unhappy with).

> 	default:
> 		BUG();
> 	}
> @@ -83,16 +83,16 @@ EXPORT_SYMBOL(forget_cached_acl);
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
> +		put_base_acl(old_access);
> 	if (old_default !=3D ACL_NOT_CACHED)
> -		posix_acl_release(old_default);
> +		put_base_acl(old_default);
> }
> EXPORT_SYMBOL(forget_all_cached_acls);
>=20
> @@ -129,7 +129,7 @@ EXPORT_SYMBOL(get_acl);
> void
> posix_acl_init(struct posix_acl *acl, int count)
> {
> -	atomic_set(&acl->a_refcount, 1);
> +	atomic_set(&acl->a_base.ba_refcount, 1);

This should be base_acl_init().

> 	acl->a_count =3D count;
> }
> EXPORT_SYMBOL(posix_acl_init);
> @@ -162,7 +162,7 @@ posix_acl_clone(const struct posix_acl *acl, gfp_t =
flags)
> 		           sizeof(struct posix_acl_entry);
> 		clone =3D kmemdup(acl, size, flags);
> 		if (clone)
> -			atomic_set(&clone->a_refcount, 1);
> +			atomic_set(&clone->a_base.ba_refcount, 1);

Also base_acl_init() or base_acl_reinit().

> 	}
> 	return clone;
> }
> @@ -384,7 +384,7 @@ static int posix_acl_create_masq(struct posix_acl =
*acl, umode_t *mode_p)
> 	umode_t mode =3D *mode_p;
> 	int not_equiv =3D 0;
>=20
> -	/* assert(atomic_read(acl->a_refcount) =3D=3D 1); */
> +	/* assert(atomic_read(acl->a_base.ba_refcount) =3D=3D 1); */

base_acl_refcount().

> 	FOREACH_ACL_ENTRY(pa, acl, pe) {
>                 switch(pa->e_tag) {
> @@ -439,7 +439,7 @@ static int __posix_acl_chmod_masq(struct posix_acl =
*acl, umode_t mode)
> 	struct posix_acl_entry *group_obj =3D NULL, *mask_obj =3D NULL;
> 	struct posix_acl_entry *pa, *pe;
>=20
> -	/* assert(atomic_read(acl->a_refcount) =3D=3D 1); */
> +	/* assert(atomic_read(acl->a_base.ba_refcount) =3D=3D 1); */

...

> 	FOREACH_ACL_ENTRY(pa, acl, pe) {
> 		switch(pa->e_tag) {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index ba91a89..3c22c92 100644
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

Is this forward declaration of struct posix_acl even needed anymore =
after
the change below?  There shouldn't be references to the struct in the =
common
code anymore (at least not by the end of the patch series.

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
> @@ -3059,4 +3065,17 @@ static inline bool dir_relax(struct inode =
*inode)
>=20
> extern bool path_noexec(const struct path *path);
>=20
> +static inline struct base_acl *get_base_acl(struct base_acl *acl)

> +{
> +	if (acl)
> +		atomic_inc(&acl->ba_refcount);
> +	return acl;
> +}
> +
> +static inline void put_base_acl(struct base_acl *acl)
> +{
> +	if (acl && atomic_dec_and_test(&acl->ba_refcount))
> +		kfree_rcu(acl, ba_rcu);

Hmm, using the base_acl pointer as the pointer to kfree means that the
base_acl structure DOES need to be the first one in both struct =
posix_acl
and struct richacl, so that needs to be commented at each structure so
it doesn't accidentally break in the future.

> +}
> +
> #endif /* _LINUX_FS_H */
> diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
> index 3e96a6a..2c46441 100644
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
> +	struct base_acl		a_base;

	struct base_acl		a_base;	/* must be first, see =
base_acl_put() */

> 	unsigned int		a_count;
> 	struct posix_acl_entry	a_entries[0];
> };
> @@ -61,8 +58,7 @@ struct posix_acl {
> static inline struct posix_acl *
> posix_acl_dup(struct posix_acl *acl)
> {
> -	if (acl)
> -		atomic_inc(&acl->a_refcount);
> +	get_base_acl(&acl->a_base);
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
> +	put_base_acl(&acl->a_base);
> }
>=20
>=20
> diff --git a/include/linux/richacl.h b/include/linux/richacl.h
> index 1d9f5f7..2baef35 100644
> --- a/include/linux/richacl.h
> +++ b/include/linux/richacl.h
> @@ -57,7 +57,7 @@ static inline struct richacl *
> richacl_get(struct richacl *acl)
> {
> 	if (acl)
> -		atomic_inc(&acl->a_refcount);
> +		atomic_inc(&acl->a_base.ba_refcount);
> 	return acl;

This should also use base_acl_get() for consistency.  That said, where =
is
the call to base_acl_put() in the richacl code?

Also, where is the change to struct richacl?  It looks like this patch =
would
not be able to compile by itself.  I was going to say that struct =
richacl
also needs a comment like struct posix_acl that struct base_acl needs to =
be
first.

Cheers, Andreas






--Apple-Mail=_124A55A8-7810-46A6-8154-225356928F53
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVjk1X3Kl2rkXzB/gAQiSPA/9HwI8jDfYrPQGfFL4NjZZNxfBK6rnfVsw
XRPQCXVJDDCjhM0t6RHBuQxJiGjBeHbqE3WkoqTUg7njFG5URFExY6XXOJBnjdTW
nwxR0gM840ni52uLCaD+QkvIxbvbBYZQmFdtYv5wB78usBcFFSltEx7sXh7+lQru
eMW3dlIAQhdKhhvN1BccVS3XBDD6TwNvgB4CK3/rOWCAU4YJLooeMPTebvEmcNYJ
j5bMqBhPJT3oyYlN0Q8dIV/NOFC59lwBEoItzHSnYkPLTawFP9CUNeXHRNP/39t/
rwRFRNl30EQFwB5FfPWFNtJhKgjAtlojiTU2OgXbTTn7041dEhkdVqkhLmU9odky
PD3UGjD6rSn3nnpvop7roAyoBUX5hU2G4gAKoo4aIwkp5kaN/L86JUHp1Sp23Ik2
JyxldGVwoLBSbgJKW6bBamP6IeA+kDuG1MwW5Af+9iPbM0Tf730kaON1B6X3s1xn
EHhgVYaqx5G8GcIr8+XYVxnnC/fwnka03DFZxRI0A/oSdRxI0TS+98jcbPliNiE5
sHoxCvmuegRXMMfYBzQcG6d6SXDz+oG3TRtonZkn3qIuWV2dBTQTY1mjrdu5RR/r
uIkBGaib0UjU6F5HHlTj4tNgXmkU4rPS7mOLcZ3mzr6eNinE3lr0oa9d9bY7zVLk
uta4gJIXPtY=
=vbcX
-----END PGP SIGNATURE-----

--Apple-Mail=_124A55A8-7810-46A6-8154-225356928F53--


--===============1949083298119686516==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1949083298119686516==--
