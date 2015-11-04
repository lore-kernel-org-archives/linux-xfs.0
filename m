Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 62E5F7FC7
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 20:33:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3562AC002
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 18:33:12 -0800 (PST)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
	[209.85.220.51]) by cuda.sgi.com with ESMTP id LJcFqd7y1MHAKOHo
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Nov 2015 18:33:10 -0800 (PST)
Received: by pabfh17 with SMTP id fh17so36909943pab.0
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 18:33:10 -0800 (PST)
Subject: Re: [PATCH v13 02/51] vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR
	permission flags
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1446563847-14005-3-git-send-email-agruenba@redhat.com>
Date: Tue, 3 Nov 2015 19:33:02 -0700
Message-Id: <507E7A63-024B-4EBD-B0C3-4ABE8280440F@dilger.ca>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-3-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2855066050419614781=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>


--===============2855066050419614781==
Content-Type: multipart/signed; boundary="Apple-Mail=_3E10B02B-D902-4579-9A2C-C87E3793B392"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_3E10B02B-D902-4579-9A2C-C87E3793B392
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 3, 2015, at 8:16 AM, Andreas Gruenbacher <agruenba@redhat.com> =
wrote:
>=20
> Richacls distinguish between creating non-directories and directories. =
To
> support that, add an isdir parameter to may_create(). When checking
> inode_permission() for create permission, pass in an additional
> MAY_CREATE_FILE or MAY_CREATE_DIR mask flag.
>=20
> To allow checking for delete *and* create access when replacing an =
existing
> file via vfs_rename(), add a replace parameter to may_delete().
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: J. Bruce Fields <bfields@redhat.com>
> ---
> fs/namei.c         | 43 +++++++++++++++++++++++++------------------
> include/linux/fs.h |  2 ++
> 2 files changed, 27 insertions(+), 18 deletions(-)
>=20
> diff --git a/fs/namei.c b/fs/namei.c
> index 224ecf1..0259392 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -453,7 +453,9 @@ static int sb_permission(struct super_block *sb, =
struct inode *inode, int mask)
>  * this, letting us set arbitrary permissions for filesystem access =
without
>  * changing the "normal" UIDs which are used for other things.
>  *
> - * When checking for MAY_APPEND, MAY_WRITE must also be set in @mask.
> + * MAY_WRITE must be set in @mask whenever MAY_APPEND, =
MAY_CREATE_FILE, or
> + * MAY_CREATE_DIR are set.  That way, file systems that don't support =
these
> + * permissions will check for MAY_WRITE instead.
>  */
> int inode_permission(struct inode *inode, int mask)
> {
> @@ -2549,10 +2551,11 @@ EXPORT_SYMBOL(__check_sticky);
>  * 10. We don't allow removal of NFS sillyrenamed files; it's handled =
by
>  *     nfs_async_unlink().
>  */
> -static int may_delete(struct inode *dir, struct dentry *victim, bool =
isdir)
> +static int may_delete(struct inode *dir, struct dentry *victim,
> +		      bool isdir, bool replace)
> {
> 	struct inode *inode =3D d_backing_inode(victim);
> -	int error;
> +	int error, mask =3D MAY_WRITE | MAY_EXEC;
>=20
> 	if (d_is_negative(victim))
> 		return -ENOENT;
> @@ -2561,7 +2564,9 @@ static int may_delete(struct inode *dir, struct =
dentry *victim, bool isdir)
> 	BUG_ON(victim->d_parent->d_inode !=3D dir);
> 	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
>=20
> -	error =3D inode_permission(dir, MAY_WRITE | MAY_EXEC);
> +	if (replace)
> +		mask |=3D isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
> +	error =3D inode_permission(dir, mask);
> 	if (error)
> 		return error;
> 	if (IS_APPEND(dir))
> @@ -2592,14 +2597,16 @@ static int may_delete(struct inode *dir, =
struct dentry *victim, bool isdir)
>  *  3. We should have write and exec permissions on dir
>  *  4. We can't do it if dir is immutable (done in permission())
>  */
> -static inline int may_create(struct inode *dir, struct dentry *child)
> +static inline int may_create(struct inode *dir, struct dentry *child, =
bool isdir)
> {
> +	int mask =3D isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
> +
> 	audit_inode_child(dir, child, AUDIT_TYPE_CHILD_CREATE);
> 	if (child->d_inode)
> 		return -EEXIST;
> 	if (IS_DEADDIR(dir))
> 		return -ENOENT;
> -	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
> +	return inode_permission(dir, MAY_WRITE | MAY_EXEC | mask);
> }
>=20
> /*
> @@ -2649,7 +2656,7 @@ EXPORT_SYMBOL(unlock_rename);
> int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
> 		bool want_excl)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
> 	if (error)
> 		return error;
>=20
> @@ -3494,7 +3501,7 @@ EXPORT_SYMBOL(user_path_create);
>=20
> int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, =
dev_t dev)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);

Passing "true" and "false" from the caller doesn't really make it clear
to the reader what the argument is for.

Since it isn't possible to check the file mode inside may_create() from
dentry->d_inode->i_mode (inode doesn't exist yet) then passing "mode" as
an argument would at least make the code more readable.  "mode" is
available in all of the callers.

>=20
> 	if (error)
> 		return error;
> @@ -3586,7 +3593,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, =
filename, umode_t, mode, unsigned, d
>=20
> int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, true);
> 	unsigned max_links =3D dir->i_sb->s_max_links;
>=20
> 	if (error)
> @@ -3667,7 +3674,7 @@ EXPORT_SYMBOL(dentry_unhash);
>=20
> int vfs_rmdir(struct inode *dir, struct dentry *dentry)
> {
> -	int error =3D may_delete(dir, dentry, 1);
> +	int error =3D may_delete(dir, dentry, true, false);

This is a prime example why passing "true" and "false" as function =
arguments
is not very useful, and especially prone to bugs when there are two of =
them.

That said, this is code originally from Al, so he may have a different
opinion.

Cheers, Andreas

>=20
> 	if (error)
> 		return error;
> @@ -3789,7 +3796,7 @@ SYSCALL_DEFINE1(rmdir, const char __user *, =
pathname)
> int vfs_unlink(struct inode *dir, struct dentry *dentry, struct inode =
**delegated_inode)
> {
> 	struct inode *target =3D dentry->d_inode;
> -	int error =3D may_delete(dir, dentry, 0);
> +	int error =3D may_delete(dir, dentry, false, false);
>=20
> 	if (error)
> 		return error;
> @@ -3923,7 +3930,7 @@ SYSCALL_DEFINE1(unlink, const char __user *, =
pathname)
>=20
> int vfs_symlink(struct inode *dir, struct dentry *dentry, const char =
*oldname)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
>=20
> 	if (error)
> 		return error;
> @@ -4006,7 +4013,7 @@ int vfs_link(struct dentry *old_dentry, struct =
inode *dir, struct dentry *new_de
> 	if (!inode)
> 		return -ENOENT;
>=20
> -	error =3D may_create(dir, new_dentry);
> +	error =3D may_create(dir, new_dentry, false);
> 	if (error)
> 		return error;
>=20
> @@ -4194,19 +4201,19 @@ int vfs_rename(struct inode *old_dir, struct =
dentry *old_dentry,
> 	if (source =3D=3D target)
> 		return 0;
>=20
> -	error =3D may_delete(old_dir, old_dentry, is_dir);
> +	error =3D may_delete(old_dir, old_dentry, is_dir, false);
> 	if (error)
> 		return error;
>=20
> 	if (!target) {
> -		error =3D may_create(new_dir, new_dentry);
> +		error =3D may_create(new_dir, new_dentry, is_dir);
> 	} else {
> 		new_is_dir =3D d_is_dir(new_dentry);
>=20
> 		if (!(flags & RENAME_EXCHANGE))
> -			error =3D may_delete(new_dir, new_dentry, =
is_dir);
> +			error =3D may_delete(new_dir, new_dentry, =
is_dir, true);
> 		else
> -			error =3D may_delete(new_dir, new_dentry, =
new_is_dir);
> +			error =3D may_delete(new_dir, new_dentry, =
new_is_dir, true);
> 	}
> 	if (error)
> 		return error;
> @@ -4469,7 +4476,7 @@ SYSCALL_DEFINE2(rename, const char __user *, =
oldname, const char __user *, newna
>=20
> int vfs_whiteout(struct inode *dir, struct dentry *dentry)
> {
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
> 	if (error)
> 		return error;
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 4efa435..d6e2330 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -82,6 +82,8 @@ typedef void (dax_iodone_t)(struct buffer_head =
*bh_map, int uptodate);
> #define MAY_CHDIR		0x00000040
> /* called from RCU mode, don't block */
> #define MAY_NOT_BLOCK		0x00000080
> +#define MAY_CREATE_FILE		0x00000100
> +#define MAY_CREATE_DIR		0x00000200
>=20
> /*
>  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must =
correspond
> --
> 2.5.0
>=20


Cheers, Andreas






--Apple-Mail=_3E10B02B-D902-4579-9A2C-C87E3793B392
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVjluXnKl2rkXzB/gAQhnew//Xe1j6dVAnqqkD270AcQPLVGrtC4VAGn4
LpMJ3phONjrAEorMAKDqDjD5KIJPm12T8uKHBpIwX/SvNLKwJvTUt54ghXdXRbIC
HKAg1FvOSXKIhY8kBugK2WrzRLSv4Af4eBcIpFB+tuzyz4KjyFk16GPCqTW5a6f1
5F64AfiZXBoC3urtTNlsVU7GGy6p6PFmgKH2BJQk5PlhPQSRmUAE22rgCTvHUOX1
MEaAvVdNv79CldjGoc8GC5hrtYAxbFtG2UEveF/nWyUpGYo3+eWzBsbaH4i0DfLU
EBvKaK5sPeO+Z+QRwiosebRLA+AYy8iVqjJtB8ROlEdLcqhYrZqyyMypwRxRz9cM
LFelz+zuyuNnh29CaG9V1H0+MZMDsNCFLsN7wOrhz6MEWpFrF6Bm74H/zu+d3dAv
KS6PaPXtcVkkdXncAMmcSWYXwgF1NukJEBF+433ZXjlBvPzINWp54vebogVNLOJk
uRz1FPKv09nXrIouXwxqbaOC1qNQIjwNfiTHfDoqRZYHjVmCX51sKtNRk/oP8u++
QZs2YWhk/FxzDZb8TX2VS0GHF7JsKojI/G2cbvaRp2v2p+iebkMfctHrCKJZz2dE
FUlTM5lX0L6nKWgPmFBz+tNmSPkQzMzNsNXbYB/iDPqkr2UJwk5CTgRZ/7wkbBON
b5azRC83hBg=
=PL0r
-----END PGP SIGNATURE-----

--Apple-Mail=_3E10B02B-D902-4579-9A2C-C87E3793B392--


--===============2855066050419614781==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2855066050419614781==--
